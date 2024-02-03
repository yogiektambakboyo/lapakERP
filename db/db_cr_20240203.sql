PGDMP  *                    |            crysta %   12.17 (Ubuntu 12.17-0ubuntu0.20.04.1)    16.0 f   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    37760    crysta    DATABASE     n   CREATE DATABASE crysta WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE crysta;
                postgres    false            �           0    0    DATABASE crysta    ACL     4   GRANT ALL ON DATABASE crysta TO postgresql_u300188;
                   postgres    false    4089                        2615    37761    pgagent    SCHEMA        CREATE SCHEMA pgagent;
    DROP SCHEMA pgagent;
                postgres    false            �           0    0    SCHEMA pgagent    COMMENT     6   COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';
                   postgres    false    8            	            2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    9                        3079    37762    pgagent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;
    DROP EXTENSION pgagent;
                   false    8            �           0    0    EXTENSION pgagent    COMMENT     >   COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';
                        false    2            m           1255    37933    calc_commision_cashier() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier()
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
		            select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year 
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
       public          postgres    false    9            �           0    0 "   PROCEDURE calc_commision_cashier()    ACL     N   GRANT ALL ON PROCEDURE public.calc_commision_cashier() TO postgresql_u300188;
          public          postgres    false    365            n           1255    37934    calc_commision_cashier_26() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_26()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
     isdated int;
	begin
		isdated := (select to_char(now()::date,'dd')::int);
	
		if isdated=26 then
		   	begin_date := (select (to_char(date_trunc('month', current_date)::date,'YYYYMM')||'25')::date);
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
			            select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year 
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
		end if;
	
		
	END;
$$;
 3   DROP PROCEDURE public.calc_commision_cashier_26();
       public          postgres    false    9            �           0    0 %   PROCEDURE calc_commision_cashier_26()    ACL     Q   GRANT ALL ON PROCEDURE public.calc_commision_cashier_26() TO postgresql_u300188;
          public          postgres    false    366            i           1255    37935    calc_commision_cashier_today() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_cashier_today()
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
		delete from cashier_commision where dated=begin_date;
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
		            select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year
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
       public          postgres    false    9                        0    0 (   PROCEDURE calc_commision_cashier_today()    ACL     T   GRANT ALL ON PROCEDURE public.calc_commision_cashier_today() TO postgresql_u300188;
          public          postgres    false    361            j           1255    37936    calc_commision_terapist() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_terapist()
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
                select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year
                from users r
                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
            where pc.values > 0 and im.dated between begin_date and end_date  
            union all            
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'referral' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'extra' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
       public          postgres    false    9                       0    0 #   PROCEDURE calc_commision_terapist()    ACL     O   GRANT ALL ON PROCEDURE public.calc_commision_terapist() TO postgresql_u300188;
          public          postgres    false    362            k           1255    37937    calc_commision_terapist_26() 	   PROCEDURE     Y  CREATE PROCEDURE public.calc_commision_terapist_26()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
   isdated int;
	begin
	    isdated := (select to_char(now()::date,'dd')::int);
	    
		   if isdated=26 then
		   	begin_date := (select (to_char(date_trunc('month', current_date)::date,'YYYYMM')||'25')::date);
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
	                select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year
	                from users r
	                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
	            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
	            where pc.values > 0 and im.dated between begin_date and end_date  
	            union all            
	            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'referral' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
	            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'extra' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
		end if;
	   
	   	
	END;
$$;
 4   DROP PROCEDURE public.calc_commision_terapist_26();
       public          postgres    false    9                       0    0 &   PROCEDURE calc_commision_terapist_26()    ACL     R   GRANT ALL ON PROCEDURE public.calc_commision_terapist_26() TO postgresql_u300188;
          public          postgres    false    363            l           1255    37938    calc_commision_terapist_today() 	   PROCEDURE     .  CREATE PROCEDURE public.calc_commision_terapist_today()
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
                select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year
                from users r
                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
            where pc.values > 0 and im.dated between begin_date and end_date  
            union all            
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'referral' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'extra' as com_type,im.dated,ps.abbr,ps.remark,case when u.work_year=0 then 1 when u.work_year>10 then 10  else u.work_year end as work_year,u.name,id.price,id.qty,id.total,
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
       public          postgres    false    9                       0    0 )   PROCEDURE calc_commision_terapist_today()    ACL     U   GRANT ALL ON PROCEDURE public.calc_commision_terapist_today() TO postgresql_u300188;
          public          postgres    false    364            o           1255    37939    calc_stock_daily() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_stock_daily()
    LANGUAGE plpgsql
    AS $$
DECLARE
	begin
		delete from period_stock_daily where dated = now()::date-1;
		insert into period_stock_daily(dated,branch_id,product_id,balance_end,qty_in,qty_out,created_at)
		select now()::date-1,branch_id,product_id,balance_end,qty_in,qty_out,now()  from period_stock ps where periode = to_char(now()::date-1,'YYYYMM')::int;
	
		update period_stock_daily set qty_in= a.qty_in ,qty_out = a.qty_out, qty_receive = a.qty_receive, qty_inv = a.qty_inv, qty_product_in = a.qty_product_in, qty_product_out = a.qty_product_out  
		from (
			select a.branch_id,dated,product_id,sum(qty_in) as qty_in,sum(qty_out) as qty_out,sum(qty_inv) as qty_inv,sum(qty_used) as qty_used,sum(qty_product_out) as qty_product_out,sum(qty_product_in) as qty_product_in, sum(qty_receive) as qty_receive from (
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in,id.qty as qty_inv,0 as qty_used,0 as qty_product_out,0 as qty_product_in, 0 as qty_receive  from invoice_master im 
		                join invoice_detail id on id.invoice_no = im.invoice_no 
		                join customers c ON c.id = im.customers_id
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = c.branch_id 
		                where dated = now()::date-1
		                union 
		                select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,id.qty*pi2.qty as qty_out,0  as qty_in,0 as qty_inv,id.qty as qty_used,0 as qty_product_out,0 as qty_product_in, 0 as qty_receive  from invoice_master im 
		                join invoice_detail id on id.invoice_no = im.invoice_no 
		                join customers c ON c.id = im.customers_id
		                join product_sku ps on ps.id = id.product_id
		                join product_ingredients pi2 on pi2.product_id = ps.id 
		                join product_sku ps2 on ps2.id = pi2.product_id_material 
		                join branch b on b.id = c.branch_id
		                where dated = now()::date-1
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in,0 as qty_inv,0 as qty_used,id.qty as qty_product_out,0 as qty_product_in, 0 as qty_receive  from petty_cash im 
		                join petty_cash_detail id on id.doc_no  = im.doc_no
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where im.dated = now()::date-1 and im.type='Produk - Keluar'
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty  as qty_in,0 as qty_inv,0 as qty_used,0 as qty_product_out,id.qty as qty_product_in, 0 as qty_receive  from petty_cash im 
		                join petty_cash_detail id on id.doc_no  = im.doc_no
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where im.dated = now()::date-1 and im.type='Produk - Masuk'
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty as qty_in,0 as qty_inv,0 as qty_used,0 as qty_product_out,id.qty as qty_product_in, id.qty as qty_receive  from receive_master im 
		                join receive_detail id on id.receive_no = im.receive_no 
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where dated = now()::date-1
		            ) a
			group by a.branch_id,a.dated,product_id
		) a 
		where a.dated = period_stock_daily.dated and a.branch_id = period_stock_daily.branch_id and a.product_id = period_stock_daily.product_id;
		update period_stock_daily set qty_stock = a.qty   
		from product_stock a
		where period_stock_daily.dated=now()::date-1 and a.branch_id = period_stock_daily.branch_id and a.product_id = period_stock_daily.product_id;
	END;
$$;
 *   DROP PROCEDURE public.calc_stock_daily();
       public          postgres    false    9                       0    0    PROCEDURE calc_stock_daily()    ACL     H   GRANT ALL ON PROCEDURE public.calc_stock_daily() TO postgresql_u300188;
          public          postgres    false    367            p           1255    37940    calc_stock_daily_today() 	   PROCEDURE     
  CREATE PROCEDURE public.calc_stock_daily_today()
    LANGUAGE plpgsql
    AS $$
DECLARE
	begin
		delete from period_stock_daily where dated = now()::date;
		insert into period_stock_daily(dated,branch_id,product_id,balance_end,qty_in,qty_out,created_at)
		select now()::date,branch_id,product_id,balance_end,qty_in,qty_out,now()  from period_stock ps where periode = to_char(now()::date,'YYYYMM')::int;
	    update period_stock_daily set qty_in= a.qty_in ,qty_out = a.qty_out, qty_receive = a.qty_receive, qty_inv = a.qty_inv, qty_product_in = a.qty_product_in, qty_product_out = a.qty_product_out  
		from (
			select a.branch_id,dated,product_id,sum(qty_in) as qty_in,sum(qty_out) as qty_out,sum(qty_inv) as qty_inv,sum(qty_used) as qty_used,sum(qty_product_out) as qty_product_out,sum(qty_product_in) as qty_product_in, sum(qty_receive) as qty_receive from (
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in,id.qty as qty_inv,0 as qty_used,0 as qty_product_out,0 as qty_product_in, 0 as qty_receive  from invoice_master im 
		                join invoice_detail id on id.invoice_no = im.invoice_no 
		                join customers c ON c.id = im.customers_id
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = c.branch_id 
		                where dated = now()::date
		                union 
		                select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,id.qty*pi2.qty as qty_out,0  as qty_in,0 as qty_inv,id.qty as qty_used,0 as qty_product_out,0 as qty_product_in, 0 as qty_receive  from invoice_master im 
		                join invoice_detail id on id.invoice_no = im.invoice_no 
		                join customers c ON c.id = im.customers_id
		                join product_sku ps on ps.id = id.product_id
		                join product_ingredients pi2 on pi2.product_id = ps.id 
		                join product_sku ps2 on ps2.id = pi2.product_id_material 
		                join branch b on b.id = c.branch_id
		                where dated = now()::date
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in,0 as qty_inv,0 as qty_used,id.qty as qty_product_out,0 as qty_product_in, 0 as qty_receive  from petty_cash im 
		                join petty_cash_detail id on id.doc_no  = im.doc_no
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where im.dated = now()::date and im.type='Produk - Keluar'
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty  as qty_in,0 as qty_inv,0 as qty_used,0 as qty_product_out,id.qty as qty_product_in, 0 as qty_receive  from petty_cash im 
		                join petty_cash_detail id on id.doc_no  = im.doc_no
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where im.dated = now()::date and im.type='Produk - Masuk'
		                union
		                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty as qty_in,0 as qty_inv,0 as qty_used,0 as qty_product_out,id.qty as qty_product_in, id.qty as qty_receive  from receive_master im 
		                join receive_detail id on id.receive_no = im.receive_no 
		                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
		                join branch b on b.id = im.branch_id 
		                where dated = now()::date
		            ) a
			group by a.branch_id,a.dated,product_id
		) a 
		where a.dated = period_stock_daily.dated and a.branch_id = period_stock_daily.branch_id and a.product_id = period_stock_daily.product_id;
	    update period_stock_daily set qty_stock = a.qty   
		from product_stock a
		where period_stock_daily.dated=now()::date and a.branch_id = period_stock_daily.branch_id and a.product_id = period_stock_daily.product_id;
	END;
$$;
 0   DROP PROCEDURE public.calc_stock_daily_today();
       public          postgres    false    9                       0    0 "   PROCEDURE calc_stock_daily_today()    ACL     N   GRANT ALL ON PROCEDURE public.calc_stock_daily_today() TO postgresql_u300188;
          public          postgres    false    368            �            1259    37941    branch    TABLE     i  CREATE TABLE public.branch (
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
       public         heap    postgres    false    9                       0    0    TABLE branch    ACL     8   GRANT ALL ON TABLE public.branch TO postgresql_u300188;
          public          postgres    false    219            �            1259    37949    branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.branch_id_seq;
       public          postgres    false    9    219                       0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
          public          postgres    false    220                       0    0    SEQUENCE branch_id_seq    ACL     B   GRANT ALL ON SEQUENCE public.branch_id_seq TO postgresql_u300188;
          public          postgres    false    220            �            1259    37951    branch_room    TABLE     �   CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.branch_room;
       public         heap    postgres    false    9            	           0    0    TABLE branch_room    ACL     =   GRANT ALL ON TABLE public.branch_room TO postgresql_u300188;
          public          postgres    false    221            �            1259    37958    branch_room_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.branch_room_id_seq;
       public          postgres    false    9    221            
           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
          public          postgres    false    222                       0    0    SEQUENCE branch_room_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.branch_room_id_seq TO postgresql_u300188;
          public          postgres    false    222            �            1259    37960    branch_shift    TABLE       CREATE TABLE public.branch_shift (
    id smallint NOT NULL,
    branch_id integer NOT NULL,
    shift_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.branch_shift;
       public         heap    postgres    false    9                       0    0    TABLE branch_shift    ACL     >   GRANT ALL ON TABLE public.branch_shift TO postgresql_u300188;
          public          postgres    false    223            �            1259    37964    branch_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.branch_shift_id_seq;
       public          postgres    false    9    223                       0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
          public          postgres    false    224                       0    0    SEQUENCE branch_shift_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.branch_shift_id_seq TO postgresql_u300188;
          public          postgres    false    224            �            1259    37966    calendar    TABLE       CREATE TABLE public.calendar (
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
       public         heap    postgres    false    9                       0    0    TABLE calendar    ACL     :   GRANT ALL ON TABLE public.calendar TO postgresql_u300188;
          public          postgres    false    225            �            1259    37972    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public          postgres    false    225    9                       0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    226                       0    0    SEQUENCE calendar_id_seq    ACL     D   GRANT ALL ON SEQUENCE public.calendar_id_seq TO postgresql_u300188;
          public          postgres    false    226            �            1259    37974    cashier_commision    TABLE     g  CREATE TABLE public.cashier_commision (
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
       public         heap    postgres    false    9                       0    0    TABLE cashier_commision    ACL     C   GRANT ALL ON TABLE public.cashier_commision TO postgresql_u300188;
          public          postgres    false    227            �            1259    37985    company    TABLE     r  CREATE TABLE public.company (
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
       public         heap    postgres    false    9                       0    0    TABLE company    ACL     9   GRANT ALL ON TABLE public.company TO postgresql_u300188;
          public          postgres    false    228            �            1259    37992    company_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.company_id_seq;
       public          postgres    false    228    9                       0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    229                       0    0    SEQUENCE company_id_seq    ACL     C   GRANT ALL ON SEQUENCE public.company_id_seq TO postgresql_u300188;
          public          postgres    false    229            �            1259    37994 	   customers    TABLE     6  CREATE TABLE public.customers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    address character varying,
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
    segment_id integer DEFAULT 1 NOT NULL,
    gender character varying
);
    DROP TABLE public.customers;
       public         heap    postgres    false    9                       0    0    TABLE customers    ACL     ;   GRANT ALL ON TABLE public.customers TO postgresql_u300188;
          public          postgres    false    230            �            1259    38003    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    9    230                       0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
          public          postgres    false    231                       0    0    SEQUENCE customers_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.customers_id_seq TO postgresql_u300188;
          public          postgres    false    231            �            1259    38005    customers_registration    TABLE     �  CREATE TABLE public.customers_registration (
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
       public         heap    postgres    false    9                       0    0    TABLE customers_registration    ACL     H   GRANT ALL ON TABLE public.customers_registration TO postgresql_u300188;
          public          postgres    false    232            �            1259    38014    customers_registration_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.customers_registration_id_seq;
       public          postgres    false    9    232                       0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    233                       0    0 &   SEQUENCE customers_registration_id_seq    ACL     R   GRANT ALL ON SEQUENCE public.customers_registration_id_seq TO postgresql_u300188;
          public          postgres    false    233            �            1259    38016    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    9                       0    0    TABLE customers_segment    ACL     C   GRANT ALL ON TABLE public.customers_segment TO postgresql_u300188;
          public          postgres    false    234            �            1259    38023    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    234    9                       0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
          public          postgres    false    235                       0    0 !   SEQUENCE customers_segment_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.customers_segment_id_seq TO postgresql_u300188;
          public          postgres    false    235            �            1259    38025    departments    TABLE     �   CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.departments;
       public         heap    postgres    false    9                       0    0    TABLE departments    ACL     =   GRANT ALL ON TABLE public.departments TO postgresql_u300188;
          public          postgres    false    236            �            1259    38033    department_id_seq    SEQUENCE     �   CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.department_id_seq;
       public          postgres    false    9    236                        0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
          public          postgres    false    237            !           0    0    SEQUENCE department_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.department_id_seq TO postgresql_u300188;
          public          postgres    false    237            �            1259    38035    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap    postgres    false    9            "           0    0    TABLE failed_jobs    ACL     =   GRANT ALL ON TABLE public.failed_jobs TO postgresql_u300188;
          public          postgres    false    238            �            1259    38042    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    9    238            #           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    239            $           0    0    SEQUENCE failed_jobs_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.failed_jobs_id_seq TO postgresql_u300188;
          public          postgres    false    239            �            1259    38044    invoice_detail    TABLE       CREATE TABLE public.invoice_detail (
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
    executed_at time without time zone,
    ref_no character varying
);
 "   DROP TABLE public.invoice_detail;
       public         heap    postgres    false    9            %           0    0    TABLE invoice_detail    ACL     @   GRANT ALL ON TABLE public.invoice_detail TO postgresql_u300188;
          public          postgres    false    240            �            1259    38057    invoice_detail_log    TABLE     
  CREATE TABLE public.invoice_detail_log (
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
    created_at_insert timestamp without time zone DEFAULT now() NOT NULL,
    ref_no character varying
);
 &   DROP TABLE public.invoice_detail_log;
       public         heap    postgres    false    9            &           0    0    TABLE invoice_detail_log    ACL     D   GRANT ALL ON TABLE public.invoice_detail_log TO postgresql_u300188;
          public          postgres    false    241            �            1259    38064    invoice_log    TABLE     �  CREATE TABLE public.invoice_log (
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
       public         heap    postgres    false    9            '           0    0    TABLE invoice_log    ACL     =   GRANT ALL ON TABLE public.invoice_log TO postgresql_u300188;
          public          postgres    false    242            �            1259    38071    invoice_master    TABLE     _  CREATE TABLE public.invoice_master (
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
       public         heap    postgres    false    9            (           0    0    TABLE invoice_master    ACL     @   GRANT ALL ON TABLE public.invoice_master TO postgresql_u300188;
          public          postgres    false    243            �            1259    38088    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    9    243            )           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
          public          postgres    false    244            *           0    0    SEQUENCE invoice_master_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.invoice_master_id_seq TO postgresql_u300188;
          public          postgres    false    244            �            1259    38090 	   job_title    TABLE     �   CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.job_title;
       public         heap    postgres    false    9            +           0    0    TABLE job_title    ACL     ;   GRANT ALL ON TABLE public.job_title TO postgresql_u300188;
          public          postgres    false    245            �            1259    38098    job_title_id_seq    SEQUENCE     �   CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.job_title_id_seq;
       public          postgres    false    245    9            ,           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
          public          postgres    false    246            -           0    0    SEQUENCE job_title_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.job_title_id_seq TO postgresql_u300188;
          public          postgres    false    246            �            1259    38100    login_session    TABLE       CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.login_session;
       public         heap    postgres    false    9            .           0    0    TABLE login_session    ACL     ?   GRANT ALL ON TABLE public.login_session TO postgresql_u300188;
          public          postgres    false    247            �            1259    38104 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    9            /           0    0    TABLE migrations    ACL     <   GRANT ALL ON TABLE public.migrations TO postgresql_u300188;
          public          postgres    false    248            �            1259    38107    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    248    9            0           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    249            1           0    0    SEQUENCE migrations_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.migrations_id_seq TO postgresql_u300188;
          public          postgres    false    249            V           1259    40959    ml_list    TABLE     �   CREATE TABLE public.ml_list (
    id bigint NOT NULL,
    remark character varying,
    active integer DEFAULT 1 NOT NULL,
    seq integer
);
    DROP TABLE public.ml_list;
       public         heap    postgres    false    9            U           1259    40957    ml_list_id_seq    SEQUENCE     w   CREATE SEQUENCE public.ml_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.ml_list_id_seq;
       public          postgres    false    9    342            2           0    0    ml_list_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.ml_list_id_seq OWNED BY public.ml_list.id;
          public          postgres    false    341            �            1259    38109    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap    postgres    false    9            3           0    0    TABLE model_has_permissions    ACL     G   GRANT ALL ON TABLE public.model_has_permissions TO postgresql_u300188;
          public          postgres    false    250            �            1259    38112    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap    postgres    false    9            4           0    0    TABLE model_has_roles    ACL     A   GRANT ALL ON TABLE public.model_has_roles TO postgresql_u300188;
          public          postgres    false    251            �            1259    38115    order_detail    TABLE     �  CREATE TABLE public.order_detail (
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
       public         heap    postgres    false    9            5           0    0    TABLE order_detail    ACL     >   GRANT ALL ON TABLE public.order_detail TO postgresql_u300188;
          public          postgres    false    252            �            1259    38127    order_master    TABLE     H  CREATE TABLE public.order_master (
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
       public         heap    postgres    false    9            6           0    0    TABLE order_master    ACL     >   GRANT ALL ON TABLE public.order_master TO postgresql_u300188;
          public          postgres    false    253            �            1259    38144    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    253    9            7           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
          public          postgres    false    254            8           0    0    SEQUENCE order_master_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.order_master_id_seq TO postgresql_u300188;
          public          postgres    false    254            �            1259    38146    password_resets    TABLE     �   CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 #   DROP TABLE public.password_resets;
       public         heap    postgres    false    9            9           0    0    TABLE password_resets    ACL     A   GRANT ALL ON TABLE public.password_resets TO postgresql_u300188;
          public          postgres    false    255                        1259    38152    period    TABLE     �   CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);
    DROP TABLE public.period;
       public         heap    postgres    false    9            :           0    0    TABLE period    ACL     8   GRANT ALL ON TABLE public.period TO postgresql_u300188;
          public          postgres    false    256                       1259    38158    period_price_sell    TABLE     X  CREATE TABLE public.period_price_sell (
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
       public         heap    postgres    false    9            ;           0    0    TABLE period_price_sell    ACL     C   GRANT ALL ON TABLE public.period_price_sell TO postgresql_u300188;
          public          postgres    false    257                       1259    38162    period_price_sell_id_seq    SEQUENCE     �   CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.period_price_sell_id_seq;
       public          postgres    false    9    257            <           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
          public          postgres    false    258            =           0    0 !   SEQUENCE period_price_sell_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.period_price_sell_id_seq TO postgresql_u300188;
          public          postgres    false    258                       1259    38164    period_stock    TABLE     �  CREATE TABLE public.period_stock (
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
       public         heap    postgres    false    9            >           0    0    TABLE period_stock    ACL     >   GRANT ALL ON TABLE public.period_stock TO postgresql_u300188;
          public          postgres    false    259                       1259    38174    period_stock_daily    TABLE     �  CREATE TABLE public.period_stock_daily (
    dated date DEFAULT (now())::date NOT NULL,
    branch_id integer NOT NULL,
    product_id integer NOT NULL,
    balance_end integer DEFAULT 0,
    qty_in integer DEFAULT 0,
    qty_out integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    qty_receive integer DEFAULT 0,
    qty_inv integer DEFAULT 0,
    qty_product_out integer DEFAULT 0,
    qty_product_in integer DEFAULT 0,
    qty_stock integer DEFAULT 0
);
 &   DROP TABLE public.period_stock_daily;
       public         heap    postgres    false    9            ?           0    0    TABLE period_stock_daily    ACL     D   GRANT ALL ON TABLE public.period_stock_daily TO postgresql_u300188;
          public          postgres    false    260                       1259    38187    permissions    TABLE     l  CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    url character varying,
    remark character varying,
    parent character varying,
    seq integer DEFAULT 9999999
);
    DROP TABLE public.permissions;
       public         heap    postgres    false    9            @           0    0    TABLE permissions    ACL     =   GRANT ALL ON TABLE public.permissions TO postgresql_u300188;
          public          postgres    false    261                       1259    38194    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    261    9            A           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    262            B           0    0    SEQUENCE permissions_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.permissions_id_seq TO postgresql_u300188;
          public          postgres    false    262                       1259    38196    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
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
       public         heap    postgres    false    9            C           0    0    TABLE personal_access_tokens    ACL     H   GRANT ALL ON TABLE public.personal_access_tokens TO postgresql_u300188;
          public          postgres    false    263                       1259    38202    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    263    9            D           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    264            E           0    0 &   SEQUENCE personal_access_tokens_id_seq    ACL     R   GRANT ALL ON SEQUENCE public.personal_access_tokens_id_seq TO postgresql_u300188;
          public          postgres    false    264            	           1259    38204 
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
       public         heap    postgres    false    9            F           0    0    TABLE petty_cash    ACL     <   GRANT ALL ON TABLE public.petty_cash TO postgresql_u300188;
          public          postgres    false    265            
           1259    38212    petty_cash_detail    TABLE     �  CREATE TABLE public.petty_cash_detail (
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
       public         heap    postgres    false    9            G           0    0    TABLE petty_cash_detail    ACL     C   GRANT ALL ON TABLE public.petty_cash_detail TO postgresql_u300188;
          public          postgres    false    266                       1259    38222    petty_cash_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.petty_cash_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.petty_cash_detail_id_seq;
       public          postgres    false    9    266            H           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    267            I           0    0 !   SEQUENCE petty_cash_detail_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.petty_cash_detail_id_seq TO postgresql_u300188;
          public          postgres    false    267                       1259    38224    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    9    265            J           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
          public          postgres    false    268            K           0    0    SEQUENCE petty_cash_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.petty_cash_id_seq TO postgresql_u300188;
          public          postgres    false    268                       1259    38226    point_conversion    TABLE        CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE public.point_conversion;
       public         heap    postgres    false    9            L           0    0    TABLE point_conversion    ACL     B   GRANT ALL ON TABLE public.point_conversion TO postgresql_u300188;
          public          postgres    false    269                       1259    38231    posts    TABLE     $  CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.posts;
       public         heap    postgres    false    9            M           0    0    TABLE posts    ACL     7   GRANT ALL ON TABLE public.posts TO postgresql_u300188;
          public          postgres    false    270                       1259    38237    posts_id_seq    SEQUENCE     u   CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    270    9            N           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    271            O           0    0    SEQUENCE posts_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.posts_id_seq TO postgresql_u300188;
          public          postgres    false    271                       1259    38239    price_adjustment    TABLE     k  CREATE TABLE public.price_adjustment (
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
       public         heap    postgres    false    9            P           0    0    TABLE price_adjustment    ACL     B   GRANT ALL ON TABLE public.price_adjustment TO postgresql_u300188;
          public          postgres    false    272                       1259    38244    price_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.price_adjustment_id_seq;
       public          postgres    false    272    9            Q           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
          public          postgres    false    273            R           0    0     SEQUENCE price_adjustment_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.price_adjustment_id_seq TO postgresql_u300188;
          public          postgres    false    273                       1259    38246    product_brand    TABLE     �   CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 !   DROP TABLE public.product_brand;
       public         heap    postgres    false    9            S           0    0    TABLE product_brand    ACL     ?   GRANT ALL ON TABLE public.product_brand TO postgresql_u300188;
          public          postgres    false    274                       1259    38254    product_brand_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.product_brand_id_seq;
       public          postgres    false    9    274            T           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
          public          postgres    false    275            U           0    0    SEQUENCE product_brand_id_seq    ACL     I   GRANT ALL ON SEQUENCE public.product_brand_id_seq TO postgresql_u300188;
          public          postgres    false    275                       1259    38256    product_category    TABLE        CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 $   DROP TABLE public.product_category;
       public         heap    postgres    false    9            V           0    0    TABLE product_category    ACL     B   GRANT ALL ON TABLE public.product_category TO postgresql_u300188;
          public          postgres    false    276                       1259    38264    product_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_category_id_seq;
       public          postgres    false    276    9            W           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
          public          postgres    false    277            X           0    0     SEQUENCE product_category_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.product_category_id_seq TO postgresql_u300188;
          public          postgres    false    277                       1259    38266    product_commision_by_year    TABLE     O  CREATE TABLE public.product_commision_by_year (
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
       public         heap    postgres    false    9            Y           0    0    TABLE product_commision_by_year    ACL     K   GRANT ALL ON TABLE public.product_commision_by_year TO postgresql_u300188;
          public          postgres    false    278                       1259    38270    product_commisions    TABLE     _  CREATE TABLE public.product_commisions (
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
       public         heap    postgres    false    9            Z           0    0    TABLE product_commisions    ACL     D   GRANT ALL ON TABLE public.product_commisions TO postgresql_u300188;
          public          postgres    false    279                       1259    38276    product_distribution    TABLE       CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.product_distribution;
       public         heap    postgres    false    9            [           0    0    TABLE product_distribution    ACL     F   GRANT ALL ON TABLE public.product_distribution TO postgresql_u300188;
          public          postgres    false    280                       1259    38281    product_ingredients    TABLE     H  CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_ingredients;
       public         heap    postgres    false    9            \           0    0    TABLE product_ingredients    ACL     E   GRANT ALL ON TABLE public.product_ingredients TO postgresql_u300188;
          public          postgres    false    281                       1259    38286    product_point    TABLE     �   CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 !   DROP TABLE public.product_point;
       public         heap    postgres    false    9            ]           0    0    TABLE product_point    ACL     ?   GRANT ALL ON TABLE public.product_point TO postgresql_u300188;
          public          postgres    false    282                       1259    38290    product_price    TABLE     -  CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.product_price;
       public         heap    postgres    false    9            ^           0    0    TABLE product_price    ACL     ?   GRANT ALL ON TABLE public.product_price TO postgresql_u300188;
          public          postgres    false    283                       1259    38294    product_price_level    TABLE     �  CREATE TABLE public.product_price_level (
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
       public         heap    postgres    false    9            _           0    0    TABLE product_price_level    ACL     E   GRANT ALL ON TABLE public.product_price_level TO postgresql_u300188;
          public          postgres    false    284                       1259    38301    product_sku    TABLE     �  CREATE TABLE public.product_sku (
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
    external_code character varying,
    photo_2 character varying,
    product_id integer
);
    DROP TABLE public.product_sku;
       public         heap    postgres    false    9            `           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    285            a           0    0    TABLE product_sku    ACL     =   GRANT ALL ON TABLE public.product_sku TO postgresql_u300188;
          public          postgres    false    285                       1259    38310    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    9    285            b           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
          public          postgres    false    286            c           0    0    SEQUENCE product_sku_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.product_sku_id_seq TO postgresql_u300188;
          public          postgres    false    286                       1259    38312    product_stock    TABLE       CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 !   DROP TABLE public.product_stock;
       public         heap    postgres    false    9            d           0    0    TABLE product_stock    ACL     ?   GRANT ALL ON TABLE public.product_stock TO postgresql_u300188;
          public          postgres    false    287                        1259    38317    product_stock_buffer    TABLE     J  CREATE TABLE public.product_stock_buffer (
    id bigint NOT NULL,
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT now()
);
 (   DROP TABLE public.product_stock_buffer;
       public         heap    postgres    false    9            e           0    0    TABLE product_stock_buffer    ACL     F   GRANT ALL ON TABLE public.product_stock_buffer TO postgresql_u300188;
          public          postgres    false    288            !           1259    38323    product_stock_buffer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_buffer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_buffer_id_seq;
       public          postgres    false    9    288            f           0    0    product_stock_buffer_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_buffer_id_seq OWNED BY public.product_stock_buffer.id;
          public          postgres    false    289            g           0    0 $   SEQUENCE product_stock_buffer_id_seq    ACL     P   GRANT ALL ON SEQUENCE public.product_stock_buffer_id_seq TO postgresql_u300188;
          public          postgres    false    289            "           1259    38325    product_stock_detail    TABLE     u  CREATE TABLE public.product_stock_detail (
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
       public         heap    postgres    false    9            h           0    0    TABLE product_stock_detail    ACL     F   GRANT ALL ON TABLE public.product_stock_detail TO postgresql_u300188;
          public          postgres    false    290            #           1259    38331    product_stock_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_detail_id_seq;
       public          postgres    false    9    290            i           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    291            j           0    0 $   SEQUENCE product_stock_detail_id_seq    ACL     P   GRANT ALL ON SEQUENCE public.product_stock_detail_id_seq TO postgresql_u300188;
          public          postgres    false    291            $           1259    38333    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    abbr character varying
);
     DROP TABLE public.product_type;
       public         heap    postgres    false    9            k           0    0    TABLE product_type    ACL     >   GRANT ALL ON TABLE public.product_type TO postgresql_u300188;
          public          postgres    false    292            %           1259    38340    product_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.product_type_id_seq;
       public          postgres    false    9    292            l           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
          public          postgres    false    293            m           0    0    SEQUENCE product_type_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.product_type_id_seq TO postgresql_u300188;
          public          postgres    false    293            &           1259    38342    product_uom    TABLE     �   CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.product_uom;
       public         heap    postgres    false    9            n           0    0    TABLE product_uom    ACL     =   GRANT ALL ON TABLE public.product_uom TO postgresql_u300188;
          public          postgres    false    294            '           1259    38346    uom    TABLE       CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.uom;
       public         heap    postgres    false    9            o           0    0 	   TABLE uom    ACL     5   GRANT ALL ON TABLE public.uom TO postgresql_u300188;
          public          postgres    false    295            (           1259    38355    product_uom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_uom_id_seq;
       public          postgres    false    9    295            p           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
          public          postgres    false    296            q           0    0    SEQUENCE product_uom_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.product_uom_id_seq TO postgresql_u300188;
          public          postgres    false    296            )           1259    38357    purchase_detail    TABLE     |  CREATE TABLE public.purchase_detail (
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
       public         heap    postgres    false    9            r           0    0    TABLE purchase_detail    ACL     A   GRANT ALL ON TABLE public.purchase_detail TO postgresql_u300188;
          public          postgres    false    297            *           1259    38372    purchase_master    TABLE     �  CREATE TABLE public.purchase_master (
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
       public         heap    postgres    false    9            s           0    0    TABLE purchase_master    ACL     A   GRANT ALL ON TABLE public.purchase_master TO postgresql_u300188;
          public          postgres    false    298            +           1259    38388    purchase_master_id_seq    SEQUENCE        CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.purchase_master_id_seq;
       public          postgres    false    9    298            t           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
          public          postgres    false    299            u           0    0    SEQUENCE purchase_master_id_seq    ACL     K   GRANT ALL ON SEQUENCE public.purchase_master_id_seq TO postgresql_u300188;
          public          postgres    false    299            ,           1259    38390    receive_detail    TABLE     |  CREATE TABLE public.receive_detail (
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
       public         heap    postgres    false    9            v           0    0    TABLE receive_detail    ACL     @   GRANT ALL ON TABLE public.receive_detail TO postgresql_u300188;
          public          postgres    false    300            -           1259    38404    receive_master    TABLE     �  CREATE TABLE public.receive_master (
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
       public         heap    postgres    false    9            w           0    0    TABLE receive_master    ACL     @   GRANT ALL ON TABLE public.receive_master TO postgresql_u300188;
          public          postgres    false    301            .           1259    38420    receive_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.receive_master_id_seq;
       public          postgres    false    301    9            x           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
          public          postgres    false    302            y           0    0    SEQUENCE receive_master_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.receive_master_id_seq TO postgresql_u300188;
          public          postgres    false    302            /           1259    38422    return_sell_detail    TABLE     �  CREATE TABLE public.return_sell_detail (
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
       public         heap    postgres    false    9            z           0    0    TABLE return_sell_detail    ACL     D   GRANT ALL ON TABLE public.return_sell_detail TO postgresql_u300188;
          public          postgres    false    303            0           1259    38434    return_sell_master    TABLE       CREATE TABLE public.return_sell_master (
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
       public         heap    postgres    false    9            {           0    0    TABLE return_sell_master    ACL     D   GRANT ALL ON TABLE public.return_sell_master TO postgresql_u300188;
          public          postgres    false    304            1           1259    38451    return_sell_master_id_seq    SEQUENCE     �   CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.return_sell_master_id_seq;
       public          postgres    false    304    9            |           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
          public          postgres    false    305            }           0    0 "   SEQUENCE return_sell_master_id_seq    ACL     N   GRANT ALL ON SEQUENCE public.return_sell_master_id_seq TO postgresql_u300188;
          public          postgres    false    305            2           1259    38453    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap    postgres    false    9            ~           0    0    TABLE role_has_permissions    ACL     F   GRANT ALL ON TABLE public.role_has_permissions TO postgresql_u300188;
          public          postgres    false    306            3           1259    38456    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap    postgres    false    9                       0    0    TABLE roles    ACL     7   GRANT ALL ON TABLE public.roles TO postgresql_u300188;
          public          postgres    false    307            4           1259    38462    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    307    9            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    308            �           0    0    SEQUENCE roles_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.roles_id_seq TO postgresql_u300188;
          public          postgres    false    308            5           1259    38464    sales    TABLE       CREATE TABLE public.sales (
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
       public         heap    postgres    false    9            �           0    0    TABLE sales    ACL     7   GRANT ALL ON TABLE public.sales TO postgresql_u300188;
          public          postgres    false    309            6           1259    38471    sales_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sales_id_seq;
       public          postgres    false    309    9            �           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
          public          postgres    false    310            �           0    0    SEQUENCE sales_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.sales_id_seq TO postgresql_u300188;
          public          postgres    false    310            7           1259    38473 
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
       public         heap    postgres    false    9            �           0    0    TABLE sales_trip    ACL     <   GRANT ALL ON TABLE public.sales_trip TO postgresql_u300188;
          public          postgres    false    311            8           1259    38484    sales_trip_detail    TABLE     b  CREATE TABLE public.sales_trip_detail (
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
       public         heap    postgres    false    9            �           0    0    TABLE sales_trip_detail    ACL     C   GRANT ALL ON TABLE public.sales_trip_detail TO postgresql_u300188;
          public          postgres    false    312            9           1259    38491    sales_trip_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sales_trip_detail_id_seq;
       public          postgres    false    312    9            �           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    313            �           0    0 !   SEQUENCE sales_trip_detail_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.sales_trip_detail_id_seq TO postgresql_u300188;
          public          postgres    false    313            :           1259    38493    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    311    9            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    314            �           0    0    SEQUENCE sales_trip_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.sales_trip_id_seq TO postgresql_u300188;
          public          postgres    false    314            ;           1259    38495    sales_visit    TABLE       CREATE TABLE public.sales_visit (
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
       public         heap    postgres    false    9            �           0    0    TABLE sales_visit    ACL     =   GRANT ALL ON TABLE public.sales_visit TO postgresql_u300188;
          public          postgres    false    315            <           1259    38502    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    9    315            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
          public          postgres    false    316            �           0    0    SEQUENCE sales_visit_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.sales_visit_id_seq TO postgresql_u300188;
          public          postgres    false    316            =           1259    38504    setting_document_counter    TABLE     �  CREATE TABLE public.setting_document_counter (
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
       public         heap    postgres    false    9            �           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    317            �           0    0    TABLE setting_document_counter    ACL     J   GRANT ALL ON TABLE public.setting_document_counter TO postgresql_u300188;
          public          postgres    false    317            >           1259    38512    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    317    9            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
          public          postgres    false    318            �           0    0 (   SEQUENCE setting_document_counter_id_seq    ACL     T   GRANT ALL ON SEQUENCE public.setting_document_counter_id_seq TO postgresql_u300188;
          public          postgres    false    318            ?           1259    38514    settings    TABLE     	  CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);
    DROP TABLE public.settings;
       public         heap    postgres    false    9            �           0    0    TABLE settings    ACL     :   GRANT ALL ON TABLE public.settings TO postgresql_u300188;
          public          postgres    false    319            @           1259    38521    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.shift;
       public         heap    postgres    false    9            �           0    0    TABLE shift    ACL     7   GRANT ALL ON TABLE public.shift TO postgresql_u300188;
          public          postgres    false    320            A           1259    38530    shift_counter    TABLE     $  CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);
 !   DROP TABLE public.shift_counter;
       public         heap    postgres    false    9            �           0    0    TABLE shift_counter    ACL     ?   GRANT ALL ON TABLE public.shift_counter TO postgresql_u300188;
          public          postgres    false    321            B           1259    38534    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public          postgres    false    320    9            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    322            �           0    0    SEQUENCE shift_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.shift_id_seq TO postgresql_u300188;
          public          postgres    false    322            C           1259    38536 	   stock_log    TABLE     �   CREATE TABLE public.stock_log (
    id bigint NOT NULL,
    product_id integer,
    qty integer,
    branch_id integer,
    doc_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    remarks character varying
);
    DROP TABLE public.stock_log;
       public         heap    postgres    false    9            �           0    0    TABLE stock_log    ACL     ;   GRANT ALL ON TABLE public.stock_log TO postgresql_u300188;
          public          postgres    false    323            D           1259    38543    stock_log_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stock_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stock_log_id_seq;
       public          postgres    false    9    323            �           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
          public          postgres    false    324            �           0    0    SEQUENCE stock_log_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.stock_log_id_seq TO postgresql_u300188;
          public          postgres    false    324            E           1259    38545 	   suppliers    TABLE     Z  CREATE TABLE public.suppliers (
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
       public         heap    postgres    false    9            �           0    0    TABLE suppliers    ACL     ;   GRANT ALL ON TABLE public.suppliers TO postgresql_u300188;
          public          postgres    false    325            F           1259    38552    suppliers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.suppliers_id_seq;
       public          postgres    false    9    325            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    326            �           0    0    SEQUENCE suppliers_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.suppliers_id_seq TO postgresql_u300188;
          public          postgres    false    326            G           1259    38554    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    9    247            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    327            �           0    0     SEQUENCE sv_login_session_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.sv_login_session_id_seq TO postgresql_u300188;
          public          postgres    false    327            H           1259    38556    terapist_commision    TABLE     a  CREATE TABLE public.terapist_commision (
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
       public         heap    postgres    false    9            �           0    0    TABLE terapist_commision    ACL     D   GRANT ALL ON TABLE public.terapist_commision TO postgresql_u300188;
          public          postgres    false    328            I           1259    38562    users    TABLE       CREATE TABLE public.users (
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
    work_year integer DEFAULT 1 NOT NULL,
    level_up_date date
);
    DROP TABLE public.users;
       public         heap    postgres    false    9            �           0    0    TABLE users    ACL     7   GRANT ALL ON TABLE public.users TO postgresql_u300188;
          public          postgres    false    329            J           1259    38571    users_branch    TABLE     �   CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
     DROP TABLE public.users_branch;
       public         heap    postgres    false    9            �           0    0    TABLE users_branch    ACL     >   GRANT ALL ON TABLE public.users_branch TO postgresql_u300188;
          public          postgres    false    330            K           1259    38575    users_experience    TABLE     P  CREATE TABLE public.users_experience (
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
       public         heap    postgres    false    9            �           0    0    TABLE users_experience    ACL     B   GRANT ALL ON TABLE public.users_experience TO postgresql_u300188;
          public          postgres    false    331            L           1259    38582    users_experience_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_experience_id_seq;
       public          postgres    false    331    9            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    332            �           0    0     SEQUENCE users_experience_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.users_experience_id_seq TO postgresql_u300188;
          public          postgres    false    332            M           1259    38584    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    329    9            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    333            �           0    0    SEQUENCE users_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.users_id_seq TO postgresql_u300188;
          public          postgres    false    333            N           1259    38586    users_mutation    TABLE     K  CREATE TABLE public.users_mutation (
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
       public         heap    postgres    false    9            �           0    0    TABLE users_mutation    ACL     @   GRANT ALL ON TABLE public.users_mutation TO postgresql_u300188;
          public          postgres    false    334            O           1259    38593    users_mutation_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.users_mutation_id_seq;
       public          postgres    false    9    334            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
          public          postgres    false    335            �           0    0    SEQUENCE users_mutation_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.users_mutation_id_seq TO postgresql_u300188;
          public          postgres    false    335            P           1259    38595    users_shift    TABLE     �  CREATE TABLE public.users_shift (
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
       public         heap    postgres    false    9            �           0    0    TABLE users_shift    ACL     =   GRANT ALL ON TABLE public.users_shift TO postgresql_u300188;
          public          postgres    false    336            Q           1259    38602    users_shift_id_seq    SEQUENCE     {   CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_shift_id_seq;
       public          postgres    false    9    336            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
          public          postgres    false    337            �           0    0    SEQUENCE users_shift_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.users_shift_id_seq TO postgresql_u300188;
          public          postgres    false    337            R           1259    38604    users_skills    TABLE     [  CREATE TABLE public.users_skills (
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
       public         heap    postgres    false    9            �           0    0    TABLE users_skills    ACL     >   GRANT ALL ON TABLE public.users_skills TO postgresql_u300188;
          public          postgres    false    338            S           1259    38612    voucher    TABLE     	  CREATE TABLE public.voucher (
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
       public         heap    postgres    false    9            �           0    0    TABLE voucher    ACL     9   GRANT ALL ON TABLE public.voucher TO postgresql_u300188;
          public          postgres    false    339            T           1259    38621    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    9    339            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    340            �           0    0    SEQUENCE voucher_id_seq    ACL     C   GRANT ALL ON SEQUENCE public.voucher_id_seq TO postgresql_u300188;
          public          postgres    false    340                       2604    38623 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    38624    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221                       2604    38625    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    38626    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            %           2604    38627 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            '           2604    38628    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    231    230            +           2604    38629    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            /           2604    38630    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    234            1           2604    38631    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236            4           2604    38632    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    239    238            ?           2604    38633    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    244    243            K           2604    38634    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    246    245            N           2604    38635    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    327    247            P           2604    38636    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    248                       2604    40962 
   ml_list id    DEFAULT     h   ALTER TABLE ONLY public.ml_list ALTER COLUMN id SET DEFAULT nextval('public.ml_list_id_seq'::regclass);
 9   ALTER TABLE public.ml_list ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    342    341    342            W           2604    38637    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    254    253            c           2604    38638    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            v           2604    38639    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    262    261            x           2604    38640    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    264    263            y           2604    38641    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    265            |           2604    38642    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    267    266            �           2604    38643    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            �           2604    38644    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272            �           2604    38645    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    38646    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276            �           2604    38647    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            �           2604    38648    product_stock_buffer id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_buffer ALTER COLUMN id SET DEFAULT nextval('public.product_stock_buffer_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_buffer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    289    288            �           2604    38649    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            �           2604    38650    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    293    292            �           2604    38651    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298            �           2604    38652    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    301            �           2604    38653    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304            �           2604    38654    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    308    307            �           2604    38655    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    310    309            �           2604    38656    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    314    311            �           2604    38657    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    313    312            �           2604    38658    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315            �           2604    38659    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317            �           2604    38660    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    322    320            �           2604    38661    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    324    323            �           2604    38662    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    326    325            �           2604    38663    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    295                        2604    38664    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    333    329                       2604    38665    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    332    331                       2604    38666    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    335    334            
           2604    38667    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    337    336                       2604    38668 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    340    339            �          0    37763    pga_jobagent 
   TABLE DATA           I   COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
    pgagent          postgres    false    204   ��      �          0    37774    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    206   
�      �          0    37786    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    208   '�      �          0    37838    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    212   ��      �          0    37868    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    214   �      �          0    37883 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    216   7�      �          0    37812    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    210   ��      �          0    37900    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    218   ��      x          0    37941    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    219   ��      z          0    37951    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    221   �      |          0    37960    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    223   2�      ~          0    37966    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    225   O�      �          0    37974    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    227   &�      �          0    37985    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    228   C�      �          0    37994 	   customers 
   TABLE DATA           t  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id, gender) FROM stdin;
    public          postgres    false    230   �      �          0    38005    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    232   ��      �          0    38016    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    234   ʞ      �          0    38025    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    236   �      �          0    38035    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    238   q�      �          0    38044    invoice_detail 
   TABLE DATA              COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, ref_no) FROM stdin;
    public          postgres    false    240   ��      �          0    38057    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert, ref_no) FROM stdin;
    public          postgres    false    241   ��      �          0    38064    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    242   ȟ      �          0    38071    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    243   �      �          0    38090 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    245   �      �          0    38100    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    247   ��      �          0    38104 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    248   ��      �          0    40959    ml_list 
   TABLE DATA           :   COPY public.ml_list (id, remark, active, seq) FROM stdin;
    public          postgres    false    342   ��      �          0    38109    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    250   *�      �          0    38112    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    251   G�      �          0    38115    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    252   T�      �          0    38127    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    253   �      �          0    38146    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    255   ��      �          0    38152    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    256   ۪      �          0    38158    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    257   �      �          0    38164    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    259   /�      �          0    38174    period_stock_daily 
   TABLE DATA           �   COPY public.period_stock_daily (dated, branch_id, product_id, balance_end, qty_in, qty_out, created_at, qty_receive, qty_inv, qty_product_out, qty_product_in, qty_stock) FROM stdin;
    public          postgres    false    260   ��      �          0    38187    permissions 
   TABLE DATA           m   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent, seq) FROM stdin;
    public          postgres    false    261   ��      �          0    38196    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    263   ��      �          0    38204 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    265   �      �          0    38212    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    266   6�      �          0    38226    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    269   S�      �          0    38231    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    270   ��      �          0    38239    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    272   �      �          0    38246    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    274   ��      �          0    38256    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    276   i�      �          0    38266    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    278   O�      �          0    38270    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    279   l�      �          0    38276    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    280   ��      �          0    38281    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    281   3�      �          0    38286    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    282   P�      �          0    38290    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    283   m�      �          0    38294    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    284   ��      �          0    38301    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code, photo_2, product_id) FROM stdin;
    public          postgres    false    285   ��      �          0    38312    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    287   F�      �          0    38317    product_stock_buffer 
   TABLE DATA           ~   COPY public.product_stock_buffer (id, product_id, branch_id, qty, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    288   ڳ      �          0    38325    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    290   ��      �          0    38333    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    292   ��      �          0    38342    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    294   �      �          0    38357    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    297   ��      �          0    38372    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    298   %�      �          0    38390    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    300   ��      �          0    38404    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    301   ��      �          0    38422    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    303   ��      �          0    38434    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    304   ��      �          0    38453    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    306   ��      �          0    38456    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    307   �      �          0    38464    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    309   ��      �          0    38473 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    311   �      �          0    38484    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    312   $�      �          0    38495    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    315   A�      �          0    38504    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    317   ^�      �          0    38514    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    319   ��      �          0    38521    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    320   V�      �          0    38530    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    321   ��      �          0    38536 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    323   b�      �          0    38545 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    325   }P      �          0    38556    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    328   "Q      �          0    38346    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    295   ?Q      �          0    38562    users 
   TABLE DATA           d  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year, level_up_date) FROM stdin;
    public          postgres    false    329   S      �          0    38571    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    330   qV      �          0    38575    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    331   �\      �          0    38586    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    334   �\      �          0    38595    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    336   Qd      �          0    38604    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    338   nd      �          0    38612    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    339   �d      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 21, true);
          public          postgres    false    220            �           0    0    branch_room_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.branch_room_id_seq', 249, true);
          public          postgres    false    222            �           0    0    branch_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.branch_shift_id_seq', 15, true);
          public          postgres    false    224            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    226            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    229            �           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 3790, true);
          public          postgres    false    231            �           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    233            �           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    235            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    237            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    239            �           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 6210, true);
          public          postgres    false    244            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    246            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    249            �           0    0    ml_list_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.ml_list_id_seq', 9, true);
          public          postgres    false    341            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 167, true);
          public          postgres    false    254            �           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 8685, true);
          public          postgres    false    258            �           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 538, true);
          public          postgres    false    262            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    264            �           0    0    petty_cash_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 1380, true);
          public          postgres    false    267            �           0    0    petty_cash_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.petty_cash_id_seq', 234, true);
          public          postgres    false    268            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    271            �           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    273            �           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 23, true);
          public          postgres    false    275            �           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 55, true);
          public          postgres    false    277            �           0    0    product_sku_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_sku_id_seq', 2736, true);
          public          postgres    false    286            �           0    0    product_stock_buffer_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.product_stock_buffer_id_seq', 3031, true);
          public          postgres    false    289            �           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 31, true);
          public          postgres    false    291            �           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 9, true);
          public          postgres    false    293            �           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 60, true);
          public          postgres    false    296            �           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 24, true);
          public          postgres    false    299            �           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 37, true);
          public          postgres    false    302            �           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    305            �           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 16, true);
          public          postgres    false    308            �           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    310            �           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    313            �           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    314            �           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    316            �           0    0    setting_document_counter_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 109, true);
          public          postgres    false    318            �           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 14, true);
          public          postgres    false    322            �           0    0    stock_log_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.stock_log_id_seq', 17446, true);
          public          postgres    false    324            �           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 8, true);
          public          postgres    false    326            �           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    327            �           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    332            �           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 221, true);
          public          postgres    false    333            �           0    0    users_mutation_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_mutation_id_seq', 207, true);
          public          postgres    false    335            �           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    337            �           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    340            6           2606    38672    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    219            :           2606    38674    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    221            <           2606    38676    branch_room branch_room_un 
   CONSTRAINT     b   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_un UNIQUE (branch_id, remark);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_un;
       public            postgres    false    221    221            8           2606    38678    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    219            >           2606    38680    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    225            B           2606    38682    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    228            D           2606    38684    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    230            F           2606    38686 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    232            H           2606    38688 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    234            J           2606    38690    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    238            L           2606    38692 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    238            N           2606    38694     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    240    240            P           2606    38696     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    243            R           2606    38698     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    243            V           2606    38700    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    248            �           2606    40968    ml_list ml_list_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.ml_list
    ADD CONSTRAINT ml_list_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ml_list DROP CONSTRAINT ml_list_pk;
       public            postgres    false    342            Y           2606    38702 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    250    250    250            \           2606    38704 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    251    251    251            @           2606    38706    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    227    227    227    227    227    227    227            ^           2606    38708    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    252    252            `           2606    38710    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    253            b           2606    38712    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    253            g           2606    38714 (   period_stock_daily period_stock_daily_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.period_stock_daily
    ADD CONSTRAINT period_stock_daily_pk PRIMARY KEY (dated, branch_id, product_id);
 R   ALTER TABLE ONLY public.period_stock_daily DROP CONSTRAINT period_stock_daily_pk;
       public            postgres    false    260    260    260            e           2606    38716    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    259    259    259            i           2606    38718    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    261            k           2606    38720 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    263            m           2606    38722 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    263            t           2606    38724 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    266    266            p           2606    38726    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    265            r           2606    38728    petty_cash petty_cash_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_un UNIQUE (doc_no);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_un;
       public            postgres    false    265            v           2606    38730 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    269            x           2606    38732    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    270            z           2606    38734 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    272    272    272            |           2606    38736 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    272            ~           2606    38738 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    278    278    278    278            �           2606    38740 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    279    279            �           2606    38742 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    280    280            �           2606    38744 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    281    281            �           2606    38746    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    282    282            �           2606    38748 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    284    284    284            �           2606    38750    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    283    283            �           2606    38752    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    285            �           2606    38756 ,   product_stock_buffer product_stock_buffer_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_buffer
    ADD CONSTRAINT product_stock_buffer_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_buffer DROP CONSTRAINT product_stock_buffer_pk;
       public            postgres    false    288            �           2606    38758 ,   product_stock_buffer product_stock_buffer_un 
   CONSTRAINT     x   ALTER TABLE ONLY public.product_stock_buffer
    ADD CONSTRAINT product_stock_buffer_un UNIQUE (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_stock_buffer DROP CONSTRAINT product_stock_buffer_un;
       public            postgres    false    288    288            �           2606    38760 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    290            �           2606    38762    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    287    287            �           2606    38764    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    292            �           2606    38766    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    294    294            �           2606    38768 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    297    297            �           2606    38770 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    298            �           2606    38772 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    298            �           2606    38774     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    300    300    300            �           2606    38776     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    301            �           2606    38778     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    301            �           2606    38780 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    303    303            �           2606    38782 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    304            �           2606    38784 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    304            �           2606    38786 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    306    306            �           2606    38788 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    307    307            �           2606    38790    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    307            �           2606    38792    sales sales_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pk;
       public            postgres    false    309            �           2606    38794 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    312            �           2606    38796    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    311            �           2606    38798    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    309            �           2606    38800    sales_visit sales_visit_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.sales_visit DROP CONSTRAINT sales_visit_pk;
       public            postgres    false    315            �           2606    38802 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    317            �           2606    38804 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    317    317            �           2606    38806    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    319    319            �           2606    38808    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    320    320            �           2606    38810    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    323            �           2606    38812    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    325            T           2606    38814 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    247            �           2606    38816 (   terapist_commision terapist_commision_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.terapist_commision
    ADD CONSTRAINT terapist_commision_pk PRIMARY KEY (dated, invoice_no, product_id, type_id, user_id, com_type, branch_id);
 R   ALTER TABLE ONLY public.terapist_commision DROP CONSTRAINT terapist_commision_pk;
       public            postgres    false    328    328    328    328    328    328    328            �           2606    38818 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    295            �           2606    38820 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    295            �           2606    38822    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    330    330            �           2606    38824    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    329            �           2606    38826 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    331            �           2606    38828     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    334            �           2606    38830    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    329            �           2606    38832    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    336    336    336    336            �           2606    38834    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    338    338    338    338            �           2606    38836    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    329            �           2606    38838    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    339    339            W           1259    38839 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    250    250            Z           1259    38840 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    251    251            c           1259    38841    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    255            n           1259    38842 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    263    263            �           2606    38843    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3638    221    219            �           2606    38848     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    3666    243    240            �           2606    38853     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3792    329    243            �           2606    38858 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    250    3689    261            �           2606    38863 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3764    307    251            �           2606    38868    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    252    253    3682            �           2606    38873    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    253    3792    329            �           2606    38878    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3652    230    253            �           2606    38883    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    270    3792    329            �           2606    38888 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    278    3724    285            �           2606    38893 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3638    278    219            �           2606    38898 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3792    278    329            �           2606    38903 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3638    280    219            �           2606    38908 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    280    3724    285            �           2606    38913    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    285    3724    294            �           2606    38918 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    297    298    3746            �           2606    38923 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    3792    329    298            �           2606    38928     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    300    301    3752            �           2606    38933     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    301    329    3792            �           2606    38938 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3758    304    303            �           2606    38943 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    304    329    3792            �           2606    38948 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    304    3652    230            �           2606    38953 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    261    3689    306            �           2606    38958 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    307    3764    306            �           2606    38963    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    329    3792    338            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   s   x���=�0��˯�]޻ks����X� �
Z�o7��CH��n�u�c�Oo>����9Om� -�P��V\��$ѬEv(�p�
%�1��m���:�����k�hR��a!�      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      x   V   x�3��putQu
q��J�I�S�J�N,*IT��W0�r8=8���t�t-�L̬L�LL�,�L9c�8�b���� �m<      z   4   x�3�4����4202�50�56P02�20�21�307251������� �#;      |      x������ � �      ~      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x������ � �      �   �   x�E�9�0@��>�5��㥊�"�Mc����"B
n�P�W_ψn���ǔki��|�6���*�=�t���a��۴����Y E��Z�C�{9s��C��%8[9k��������Ht*�!F�hY�Z��R�/��+      �   �   x����
�0@�����%1ɍ�,(t(�� j��ւK�Ґp��=NYgD[��wt���$�K��Ԭ
&e��.��4������P���6v�T�ce	]��[q{M�G�s�9���}�%˝��y�f��8aݶe�Q����9��<�� �dX�(K�R4��y��A���H&ei�)˲7fg��      �      x������ � �      �      x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �   y   x��K
�0E���^R$���vӒ�A����soF}�����A���!���&�2Dg�(�c�E�{#R�~ji�1����G�&!v��UM�<���Uu�.=-y
��Oe[�j)��FD?R'      �      x������ � �      �   �  x�u�;n�@C��a�!�_� )ӹ�v�������c��4�����>�?���z=��Tf��2B�3�O7�p�a�½(�>-'i1I��t��kF�9陓����(4z<ޠ�E���{İ���WL���ʮ1�v��9w�s�W�ς*��N�2��y� �U�9����{|r�'T����ۦ�ӫfrUỢ�f��2��7�7�e�_��x@(PL5���W��aC(���,��!���L�iL � ��6NA[88+�O<�TE�1�Y�����fT�;�ۡ�x�ի�h@]#k�:�h��	��g ?����y�� ox����&�X�K�<��x ��x�AЂzo���!�� ���'[׬��C�gק��\�6�|�6�eC_�X
�����������۟�p�b0i�ma�.Sg0u��e0{�-h0��mjؾ�mm��7 " ZWtf, T�w �'��v=J���]s~�����*�{)��'�      �   �   x����� ������@�ۡ-]&Na�����\�eڂ��n7~��늄s�H.!>��H��;4c=&�fH#�b��{Ң͉���2�LE��1s�ox��2�\����F�ŞX�=k;W�ܳ�'Q��[�|��(xܨ~�S�Fef��Q��FV�q��1��9�(�w��r?      �   �  x����n�0���S��f�x;V�P	*Up�R�= $.���YHb�H�͌?ό��ϯ� �Ȥ��qU7K���y_�HSh"��Uп�m;4���PD)�kq�}���rQ���vJlB�5Z�"��0[C"��bkf��:0B�>����>N�	 e�G�S��c"�"��,/k2,�K|����n]�0�@Z!D�&3O����lJ����\]�����v����	��2�����Ns�*a�e��,�!��59���~�ߨ�z�'Y>z��(��GP�5"	/��Lz�{>������o8���0Uȕ{pf��5���Q��M�8�f�H�s6B�6G(�nf�����.�Y��+U`��Q]U*˓�ћ�����6`������粈�1��p��}	�PA��}fZ���d�)�      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �      x������ � �      �   `   x�=���0B��)��})��!:A����%�� �H1���6ds6v��N�V��yE6��4[So���=W�����#���'�e��U�-�Z      �      x������ � �      �      x���ێ�6����$�3������	2�{`�nk���ٞ��闲)���ٍ�O$'�(J�W�,�$�����|���v���K�{{W	&�WL%ܚ��R���ݯ��׿V�:����}�6���ҁu<�;"�����4���aC�`X��x���4��n�'"J���R;�U��[Ľ��]Q�.��?�0��]��X����T0��
$��d�a.m4W����"���j�mP�ǘ���v��`��j����H�Z��a�e�H#���1[+&�g[9��kG�}hO�n�9�So�����p_Pr�6a]�#�B��ѳ���6�� c�XE��� �e�����XD���H�ζ����#Fc8�u��'�F��I1��Ғr��!�HC�%��M{h��K��U�I�c�6C"�%L��(� 醣x
��	a@��_0��T�!�F�0e`(.� &R(�qhX�p"�e����@����b �'����C�NWaD�y��L<���Gփv1�c�l�xdGb�D�h��Hw�FM<D|p2�*�t*B��D3��'"�F����=5w��E�ɨ����(��9�,�Z�H���eƄ������ZgP���f���fT�k�]�xߺ�}��@>g,�B�Ϩ�L	3*"1�d��O�ʘ �s6���� ��3�S�Yfs&��.�B��P�ϯѽ������=<�wM������(*/��?����Û]`���a���{�a���#=�}�w=�{�o���������W?4O�o���qjB�xH��l�Qkf�j�V��wo.?��9�����J��j����~^}���?Lm�&Wg&�eT�w�|F���E�xG.s& >r��v�y��-f�ȹ���mģ;Y�""�zB��`��O8�q"�kB|������&P�̌�`�g*�Ug�
-�y֒0�)J~�t"��1R��IueA|�4ս�<�-Jj��H���	1�:f�E�0� �t���R�:�P��t�a�����?k����a'����f�=�z7[��w瓟�`�YZހv��h��e6憛2��(M��!b��6�]]��-��1�;��vw�('J�*]2Q�'0Z1:�BDbLF���،
��q3*B�ΰ !X�3
����//�#,~XY"ӕ`U�P��0D��UX[ C�a]��P��h�B+q*q�ܽ�z�`��
Z�tŸ�b:@7����������s?>DI�����Г+�)4 PU]P�@Gh�VU��?�m���v���ƛ�xUԐ:�]s�IRK�Ԕ�O"���z����};ͱ!��.���	�6��J??��Ƞ �+�m )3���xmI�2T?�V?������;�9s0��r�s'��)r��4�nhV�����������+/C.�폿�ޅ�S3|ť�.�/ٍ�g��7�sY��!��n����ݾ���4�4�i�����d�Bw���5�mW�r�����4�݋��\�o��>64D4g�ݷ��Ȉ#8Ϩ�C�\�Pz��2g"�M�>�"���:��c 7��a���
	 �Ψ(�/D�-�;�`�@�К���5��v�@E��F�����j}$�Q3�B��Rq������="u<��pYb8qU�U><��+�II>�0u(du<�[X��*""b�E@z��&�!Fڈ�1fSG<P�� 1M��gJ�H^�*:��=��ߝ@��Dpt��z?�lo��O���P6��Vn�ѥ�ꁅ��f����]�ZF�Z�8���
4����m�._���]���`�"�K�u#!1"A�ubdĈŨ�	P��1"cg6I׎Ɏ�5��@�T�t�������9�I���!�`�1]�J`�ά��%�L�p^�U�����e	���xt)86� 
p|�A߉���,%G�̝�x�vz�ڙ���e��."i�X��_��S�`"��".��3Axrʹ<��5�K�v}2J��x�D]�t�����6'n�S�}�r��{pJ�90�Cï���l�����{h
���4,c�#��f�DAFNfdL&N�I.�C_Χf����kS.�WG=��v]C67%�5�v6��z>���Q���)�ّR�o��q����/����!K+V��u��~Z}��5���6��W]-�D��p������3���"������ijì������ן�n���y�s۝��c�w>�1V/hc������:�s2�����������+ͷ~I�E�M�J�o��9���TD��nhQ]r��9N�9�4�T�ˆ l�O�nwl��1�9.���(@*xB��G�d�' `:&���1ʖ}��	�1�c ���0)Pz���NHH�X��9jׂ�,ÂN�K�30�\����f0R&f��H�
P��@�i@�9�@T�r�k^���������0/bZN
�ވ#��ח�G��]���/�?6;6��K����>�v���x�n���}�����S��Q������O�KP=k=�N��G�u�F8D��+�B✞���p�gxLD8#& � ����MҨ��@�I� �ڍ͙ E�A!~�dNc	�eTL5|>�"�eE���ʜ��QF�v�p�vR�<��:�b�dT�a�bX.�"�Θ�����\̃r<FB��)�23�ǩ�%N'@��61"v��ڑ+�1�T��R�?�NN-9S6��G�ڮ��95�y�\e�>0�����<����pI�d:�6v���d��w��~l��ijC�6/<Q:�Սx����P2�U~zN�9L4� ܗ�`]j��O�tfu�ώjߑ|�G��W��y��Go�H�:s���
G��67w�,?�c\Q3����<���`��07ҧ瑀���O��ч�;�\�_�6X�-��m�>�74�VR��[�����66a���ϓo�Ί�r��п�3�ϱ��ضwb��7��7�ܵ�廱5�y��%�	�D��v�	{s�&�N��y�����?��z��Qc��С���بYq>�[\,�p��}|��ԯaݜЩ!A����n��Ԭ0L ��k^��ݵ(q��Z��7��Yr�xx�^�4 /f)k}xz�� m��Hծ�̥���u��[p�[/���7Ѐ;Ţu@X1K�TN��Q��	x�&�syG�lF��������E=�"��Y���P ���
�,���U%.@\�EpS CT�KKYe�¼����(D���o.@�"
*��T��D\1K%
��T��K`1K%
��T��Qd1K%n/Q!TUP+����Y2u TI^ ��$E���s.f��`�p���!���FHE�9��
Xȶ��(�k�%N��=_|7+��7}]�������v���,aQk`k��^]���5����`�R2_���hOj|�:�R&a<��)ᴕK����I׻f	�4Ϡ O�E�}�����S�ZL
ŮM
�w�t^�λ���5�37J��TG<�f�嫕�K�W+�����ߘ��􄧻�W��/d�j��������d��#u�G��*Ŕ#U�T�R�T�\����(�o�� ��(���tqNV�D���'��gT����C�"_I��x �?��q:�mׇ��eޭw���q����s~@��{���4��	(䩿�[��~>>+4�q��&�imoƉk@>����ϝp�㽝^R���V���oU�K��V��8o�������n����.��ܱ9���a1���;��\A���Ԃ�ޮ \�
��l�Q� �Z�r�@�x��BRƻԏ�m��&�q@?ڵ1���WʢE��4z���BtS$ �*� ��r�4���HCD���[ �/ں�A��օ�d�f���]s\�k��ȴx6^�A(g���^Yi���)�/�$;L͂nB��x	�T%;�L�D�\3�Bj�̕��'�Yʅ�_s�R�^@s�!�@�̤p����J�њ�L ���4���}�B`�����*�e��ݠ���%�p�l�v/V�.�[m�����=k��O��5��o +  #��OXl�N����Z2��4���mwh��mP����+���{I�E�tVf���հ̕\��Ӏ��ǂ����?ξ���ƍ��.�0I�ؿ`�����|i����)Xuw���S�V�,0yʤ �H� �*d��)�J����	��ɘ����	0�.%"�R��l*�K)���{���6{������$Q0�����y��a�;tӕd,o.ѣ�fZ�L�A^d/��C��ǒ4�����C�"@��g��3���E�R�|eU�����O�%d��Ei�˧�w�c��	���j��/Z�<H      �      x������ � �      �      x������ � �      �      x������ � �      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   Z   x�m�1
�0��9E/�K��������C���Ǐ��~�g������	L��f��ZE�[z̍���o0���,�Mt-Dts>\      �   �   x�}�Mj�0F��)|�-%�v�_)��d`���h�M�qg��{߇�������)xJ��qk���Q��<�n��/������lv�Lȴ�3l��[������.�I4�KCm�
��G(	�ҏ�!L��Bk��%�4~��]9�:C%��������:Ce��e{S���P��m-u6�:C���}�>�q&���U�;��l�+�g%Te��"~�s�      �      x������ � �      �      x������ � �      �      x��ػ��uEA��B	��p� cQ�qh�ȸ��S��YV��?�?�/�_�_1����s�?������\�?�o`+���}�o�ll�	ۂm��:�Ձ�t�U@W]t�U@W]t�U@W	]%t��UBW	]%t��UBW	]%tU�UAW]tU�UAW]tU�UAW]5t��UCW]5t��UCW]5t5��@W]t5��@W]t5��@W]-t���BW]-t�Е��BW]]��BW���Յ�.tu��]]��BW�z�Ճ�t���]=��AW�z�w5�w5�w5�w5�w5�w5�w5���>���>���>���>���>���>���>���>���>���>���>���>���>���>���>�����������}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}���}�o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_��o_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o���7�+���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������_���~��/x�o�������?������x�o������?������x�o������?������x�o������?������x�o������?������_BW������?������x�o������?������x�o������?������x�o������?������x�o������?������x�o������?������x�o������?������x�o������?���������7���o�{Z�������q}����ƿ�������7�޿�����0��o,��c)�Ka���X
���R@�7�⿱���0��o,��c)H�Ka���X
���R��7�濱8���0��o,��c)��Ka���X
���R@�7�꿱X���0��o,��c)��Ka���X
���R��7�x���0��o,��c)�Ka���X
���R@�7������0��o,��c)H�CaGL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#���OJab�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#���CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?��CL?R
�1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��O1��ϔ���SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL?��SL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���KL���+�01��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��/1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1��o1�N)LL���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���[L���GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL����c)LL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��GL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��WL��7�01��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1��_1�ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+�S
ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+������ӿb�WL���_1�+��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL��&��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�OL���?1�'��������b�L?������}���ƿ��/��^�7���o�{a���¾�����00�o,���c)L�Ka`��X
��nR��w��������ݤ00��&���c)L�Ka`��X
���R��7����������00�o,���c)L�Ka`��X
���R��7����������00�o,���c)L�Ka`��X
���R��7������� �  ���00�o,���c)L�Ka`��X
���R��7����������00�o,���c)L�Ka`��
;b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�R
�?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�����?b�GL���1�#�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b�!�b��R��~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�釘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�駘~�&��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�)��b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_b�%�_)��闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�闘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~�鷘~��wJab�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-��b�-�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b��}~Kab�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�#�?b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�+��b�������?��q]      �      x������ � �      �      x������ � �      �      x����m�ٱEѱʊv����!��
zJ]ݣ�A�_�L�{ĕ��������???����|W~��O�i|{�Ȯ?�(>X��;�+=�����~|��������?�����O�w⯎ob����������������#���	�?>���|���'���ߏo��f�W|]t}�b���x�ϗ�L����D��7���zu���/�7�[���(�j�:����&旉�����|�=��U�ڛ�L����~���)V�8y�>����O�>��D�z���iz����z����z����z����z����z���z���z���z���z���z��יz��יz��יz��יz��יz���Yz���Yz���Yz���Yz���Yz����z����z����z����z����z���9z���9z���9z���9z����F�s�:W�s�:W�s�:W�s�:W�s�:W�s�:O���:O���:O���:O���:O���:�#������u�G��?r����l݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��֭�u+j݊Z��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��ѭht+݊F��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��խhu+Z݊V��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N��ӭ�t+:݊N�"��X�6�>߆�ې}r�oCn�mȑ��ҷ!g�6�Nu6z@�:��S���Щ�Go�T磷t��� :�	�m ���6�NuFz@�:$��S���Щ�Io�T礷t���� :�I�m ���6�NuVz@�:,��S���Щ�Ko�T祷t��� :Չ�m ����6�Nufz@�:4��S���Щ�Mo�T禷t���� :���m ����6�Nuvz@�:<��S���Щ�Oo�T秷t��� :�	�m ���6�Nu�z@�:D��S���Щ�Qo�T稷�wj�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT ��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxT5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� ��G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx���G-�Qx�u "	  �G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx�u�G�Qx���ݣކ��ې;}r�oC��mȝ��ӷ!w�6�N�Щ�Qo�T���t�{�� :�=�m ���6�Nu�z'�Sݣ�	�T��w:�=ꝀNu�z'�Sݣ�Щ�Qo�T���t�{�� :�=�m ���6�Nu�z@��G��Sݣ�Щ�Qo�T���t�{�� :�=�m ���6�Nu�z@��G��Sݣ�Щ�Qo�T���t�{�� :�=�m ���6�Nu�z@��G��Sݣ�Щ�Qo�T���t�{�� :�=�m ���6�Nu�z@��G��Sݣ�Щ�Qo�T����wj�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx�e�G�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G9�Qx��G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT �G�QxT ��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xT��G%�Q	xTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTU�G�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxTՀG5�QxT5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G�Qx� 5�G���Ǐ��0��      �      x������ � �      �      x���k��6��_+��U35����č S��p�/��=qb�fvj߰%v��j�W�؝O��C ��-��݌-�)���ǅ�.�f�a�٭:�����ٛ����te���3gfj���.�}V�g�,����?�r�Uu]e�2p�{�JS�Y	��fNU^���Kgf�i3o�����R�����k�VFkm�rz^]�u�uW�������V�_�p���R���~��i���~�����j�4�������]�U�]Z�����*��J���ꪫ.�R�+v5�-�"+��J�KSWe]/�ʪK�8�F�o�������~�+^��O݆�I��<�L�+�4�79_����W��*:��k�@�Ѻ�g�j�[���b���M����$��{���7M{�Y�v�4��R:�4��s�UY�E�t��RU�5ک��.��^���j�-*wi�{���e۴s����Ë�P��a�׾]_�=K��={s��W?��}���IWU����Tso�PcU����y�K�}�ca��|�.ue.[��*�nTWzm����oT]���U�mo�u���!+_�;��0\�z������`����.��W��ʗ�����K�J�5^_���j���z���Ue�����W��˺�C>o�Mשv�^�j�b�^�k���(��3���ᬔ���բҭ�L����������?&>ߚ�����W~~�X8թ����V�����T���{��/�����LB���
�*�$לxsS7�^X8o((�q��;}u�.;��P ms�j�*���r����W�/�++98}�E{յ��hw���w7����j��n��A�ڱ����f0zJ�[�V�k(�����B��|i,x:���Qs�T�)�ei��\u�X��]i��/����)������y{y_�k7�~�>� ?�ӹ��G�m��k���S��Hgg����U^��7�ΝAͲYw��%	�9�.	�ͬ�����'�MpM8߶�|�-��Jd�[�=��N��n��6�{u5����b
�㮪E�js�����n:�L���1h1�w��G�"a������<��=��s���n���n]�t�
*�w�z�9/�$P=W>�!x~���k�����9O�,� N={�n�z�2e)�����N3{���,���/�v��K�W��M�`:	Dtb�'~9�Ô��a�t�*���Z�]�[���xEE��-��莻�Y�4�Vhhf���7���T��n��e�f"	�k8(^ʦ�1�y3�	#O�������-�)����Y�Ђb���هM�\�:t��
B	J2����������W�e���gg@��b/6]{;��]� �Xӵ�od+)q�&��^�o��n�a��$�I�����۴�E��)��IAa�` ��1�����tE�=t��J{.�]4x��ǀ�O� � sj����e3�������ǀ�M� ��4h���� A@+ ����(pzKm���
U��d�#�hPP�5��G��v`�-�c
o�DB�	J�O�̈́���tF�@�y�SД��FB�	�Wc�Ζ���h�Zπ�}@3��B�	�ŀ��U4��0ch��N6�N
\�rθ��&4s�X�K1�����D��?�����i�� ��I8	<����Q�����X&�@<�S+1�N��]$���nE����mz�%�3�H ��nZ0�0��34���+V| �h_�`&V�\�O��	�ق�Xs��`��	�ق�@{ �PR:+�K�OZ��f�o{��]�>�(��!�z����_�>�/{WP�,�	�s��i�SR��
 AY��%���
ݛ�c�]n竎�I(�CZ����ۛe[L�ƈ��x��
v?_}�EˣhpW>���s�pm����]��oR���Ŗ�$��Z8��_��.��d0��n2���.�#�n�07�����r�{�s�J"��^��(�̿���dIIP+9���O����q	�כvѱo�@pI�r���ſ��mW�g�$��A����\3{�lo��n�n�a��P �$�U��(A���|*udH�I�&y%iFU`;Й�Ρ@(An��n*s:J�~��j*�x�QِW�@tAs�é���u]��j9��g�O�Ԏ�LU��uA��NSM6ED&y��
��g�����u���Y��	�*)|`)Un�G��|�$D�������T���y��:|��٦]1��@<4v�����X�D�}��*�ğ�j<%y�$ɍS��d���<�w'F2}1��Qx��b3h�,*�󋒽��`!�����-����2i���n�o�^m��U��e	'�����*����6��h�k��;j�~�]�����u�4�&hc�`�f������F�H���4�d�u|�Hx$��ma�Q�Cg��5�H ���jp��Ŷ�u�Ytk�$�@���@���P�5i���[I˪���_ݼ-�k�����VHRy+���w�3��ه������p�"1�S��́��M�	����$̤)g/ws�x��H)�A� �7`$��Yb>i��Wӫ��l��_�d���1�����ߠ������n�S��N��m��L2�ڀ�4���6������Ѐ�4�(���&�*|}eSPp��:��\W�IHPA�h�d�b�"�%���m�kW�w�z����Ђz��i���j�B&5K��`�rF�4�J(�8�S�1�����曪,��Y&��x�}z jYP}-�R T �_���Ǽ�Q�B 4 �)��w톧F!��^�(��b�$$��K;P�T�^�o��>V�1�*Ab=�xX�P�/;�jW�!�n�0��DD}z�D�B�f�����+>@���IH���
� ���/W�w�b�Ɣ(�W"��U/P��T9���t���O L�0�ӥ$ezm��O������=������۝ T_���(۟���Ic�k&�x���F���z�/��ͦ_o�+���H8ɣ+Q��2Ť0��i-N����~~��{7dä�h���O�P��7���z?���<8��)�i��B@
*^��#H�8�� �
,E��W��nR�U�.�5��	���o�����s�JQ�P��h}H��~f
[֜JQ�Q��h��~sۮX�{v�D���~�����۔�X�@	ʈ��n�z��FK���h@&��UC�%h9��\_3��	
���~���,o�M�{)��=I����A�0�|Rs�$/���f����#�l�g�{�Irx�	Qq��Ә�oLG����F�EX�Q�7��r�3q�O|vQN�r 
����@�1�K޿���/�HB�	LӀ�3��@����q{��r�Y���/���4�Q�B3`*�}�ϾA�ml`��߀�
�7�Z/~).�mǎ�00�����1t�o���C!�>j�	L}���&��R-jk��C^-�����x��L%��`Y��׾L!<�t ��k��
Va�e��1QÕ����R5�o�z�ǧ��&t�J:�ɰK�`�<+p&�`�{�oS�m��~r����>|�B�ú'�U�G���w��`An��,�"?��U�%i�dT)�냛��xw?�巸�W:���s�m��`�6�~�ͩ ǣ���<��\9{��b�
�P\��x�ӱ�=���p`[l����s��5�T`8�m8p+�N�G�ѢI�L#������3bx��C:�h��p�T����[�#ƱH��	,�F�����q(���P�� 	�C�j��0*.u�A}2P:z��$M'&��A������9k3Ҙ�*	�D����\=}�T�3����r�����:����O�8���r`\t���r,� R���f�I�
��R���tD	�j.U�	�LQ&�7�{��e�(Q����*;A�)�E���+��MP�UE���+𞪚���#J`�XM�'�z��#J`��IUOP��D���+��
�=c/��ƫF#��V��<�~���_-g�ؗҴ��/�6��C�_<�a٩�2    }/��NA`/��g]�-���M��n�-��*.7��n��5
�94"7��;>�����Y����t��<�LB�lԃ�x��R� !p��m|5;�ݟa�&|�� M#2O6������}�j�cBc5��G$pP^�c�%��(7g"	����7��~��o-��n��a���j3��o��ԁ-p�S����k��Zq��[����2X���z����߯w�2G0������6����%I$Aq��]���n�$�H�[�R�SA�{SW�ϧD�������pk��j���pg��j�&ǱTjT����$�i�ҔCi�{�-VݖBty{�d"R�Sp�FA�dL"S�]p�Fe��]F%!R��?i�O���r\�R�%I�@A�i�V{h�@ˀ��E�ҸC�r 
(�_4`3���2�3X�-�c�Ƈ�H�K&����׀�45���zS���TXJ��B��[Qy?j$D���7�x�Փ�C��9.��O/� �:��и|z� ��ʮ��H|z��K3<V-oo��ݝ � �)�>�N.�B��0-0�a��G\x�[�+�$!�=�p x��0��w��4C�Q�^D�TO�x�?�7˻;�������U� 	9]R^<���F9�_��:� !�J�L��J+>&����� ~�^��﬏7�IȁO� i�&67(.���;��t���.��
lI�pػ�-��%!�r���2q�n�`���3 !;AS�WP.�����3ش�R��T_qOo�Π:zua=<�OB���06��JQlsJ�`g�{. ��ar�h1�-~�$r~z�$7|K5_Q�N�X
K�T�ah�~�CI!�X�������\��I
	#�zz8��.�w�I ��������Ti��&��	LW����*V�� �0Y�f�{�n��� N[4�5O��$9\DW��3�4#9F���0�&�\MHU��$��B���gP�3RM�$�	,C7闕z�L��P ����``���k��F�H4`�b�jz���V��Rj&�)�������=@�??�e�#MP���1Z��d�a��秗;��<A�̀w@���6w4IG9f�DL�ï���~�fi8NP8��l#x^�4	')`'l��W��;x��s7�2���x[��u��7-K��q������4��c��^vl��(0�*A�΂���>r⹀>c �Pȉ"x�= ���E�k�)��$p��^������h=AK�38�u�w�z�?�R����I!�#�n��,P�+Η��oJq��V-����o��u�4{'rfj�np�v�^�Dz-Y'��1��=�o�q��a���'�R&�σ1,�%ts�Y<K�S<K�
�ԁ�8ű,��q��Q�����_Է�v;N���(0�`� ��KVc�/�Ӂ��;rM8n�l��,�[�iݺH�w�\�����]�˽OL#�#�8����f�D8S`9,����sϒ$p��x��g?_n�\��n�߲$	�&���1JaX��|�λU�c	�(0�Saj��&ZJ�	<�ϩ�l��Gp��Me�F�C�M��3�(�(�wy��RŮS��8Q���%Q�K*��&�LG�b$��Hp��a��!:}3���B�b#�F*��膷^CWZObZz���YqR�!*	.�o����%����9�_���[	R���ϠT�����O�㇈� ~���n�.��!JmL���Nq�x<�+
N��!)�����CH���H�߻�n����$��S��!2x�7	0F,�4	9��~6���R���G���`9�%���fX�)$dȓ�^B��``p ���L���S`9,��x�m��rx*�D��x�_' �o��(p �vI�</v���,p"NT�i��[����(����������A�S$�8��`C5��������9G`:5�Nm�UF��C�35�Lm�[���NOp��_j7��[��q}��:vu'u8����o��-^���'J�$����(����� 0������W�����)�f���c�{֮���X���&p�ܡ)g/��a�����9G`
�B��0�-?/���6WҞi���q|
���o<�!'
L��hL
^�C�I9Gd}���CL0��0�����S�mb�s�:����J����yRT�CL�\�w��S��:�u��о�Ý|���n�M��BBƔt�����>N�>�g%}��if|�`,(Q;
h�|S�%M���q�֔\��[��
,���Q�_N��$�w���+�����5K�0�޾��i�QBi@��)��pI��r��X��9�m�Ǟ)$$���� ��0�0&��[�����,� 	]��z}_��؆�|g������Y����l�%ᬽ��WG!��$Up>?���M��r��?2�աg��N���7� �D�^�_^���>
	��z@ K�q�2� !��^_�Z�W��v�g[u$$������Z��w\�]��BB�=�q(��W��:�q��F>"eT����;}^3C8�S�=P�X�ʫ�3<��b���LBb
�N��
��UJ�.Y��Ē�HpUe,3e���wQ>c�)�r��������/��0������͐�q,MB�	LK���4΂�=}&!����G '����Պ�HH(�ei��ȿ�*�,�y�aH"j����!�d+�A���эB�	����<�:�IҖ�8�mi����g�w0��^����#���)���4�0 %w�����L��=M`'��N?��*%IH,��h������8k��a� ��x7��&&���fX�}��Z�HH<��0�j��=f��2K��HO1�)�s������W�X�s� !�^b�KLj����������}��l{v���K���7h��a�*}&!q�b�P�tֿ����A���z�LA90`)c��r�+x��m�R$D����ѯ{��q���q��I�LI) G��}���L���� ��������!�p�_�c����+K��Q��i�Tlj�����y�����U"Ѐ���_l�K� ���t�b����؜\��{�&��%ς�X�~����;��	ʟs�.���ۘ ���΂��1�~���oX�N�8�b}��[�/���C\Ŧ������-ɔ�&6uyޯ���%I�0I3q�7KrJ�E[�w`&̤�ky���V,I�	�#q�H�ˑ>��Q�F�q��j�9/
�'h�80g�ʷ$�p>☏\m��\��a�r`$,���)cs/��� ���`��d:	+02���x�0��R$p���8�kR[��,[�"��$E|�J�������Bc�KX��T�1��eش�c� ����v*��j���n�a��LRҦ3(���Oe�8�c�'(�xO�f�Q)U�0�	Je�S��~��X(��L#�#%���*�c���'�aVSy�iʜ?v�%I`4AUQ��T5�zxY1޽�&��͉
,�J�}��.��I.p�������ġd	
�k�q�%ΖJi>}�p�'��H���w�_/�J�
�zf����M	��'+��6R2��`�r��J����סS>NS:{ӵWg?�W����n�m�V��k$'�����te�L�� �Qe��rvq6.�tr���x��g[U��ޔ�do#NRZ�x|=�1��a	���L!!Gڧ����|�<�2�_�o�<`^L�S�)�`��D�­��aU
m�W,)~�w�i�:��s��ܩ�!��� ��p��(��s͏�6�\lW}W�k?}�����͟��H��C�2���j{�<���]���.V�~�݁������j0����8�mA=�t�w}#_М�����l��"ށ�_����
�m�}���$c�5]�go�ۛM�߆H���p	(!������Õ�vE���}�qذ����fP�	�9����n&���zcv��}�*��O� 	9]P��`�M     ���{�	t�|9o�p��H��=��:8#)�'��-��p�Ca�!!?	A˭ol�
��Y�I	>6i'n��4����_�
9Q��x_޷�?e�&!
̶�k���W8�$�4��6`hC�2b�WRx�WD
<��j��-�z�����I�N@2܀�5��	\�'0\�D�ar������I���k��ڷ$�l�y5�7MY&@|�I9��ƀ����:/b��PȉO�$�QC�ps�����)EB�{�)
p���������tS���ֽ��>��翯oo�NB~�9�����g�&�C��O�)�����m>.��6�ݡ��nS@����4��| 7��V@��ù��6�k�#!�>݈ �&�{^�,�H�qO�@}�@[�6��������w��$��S���~��9 :����5�vTG!�
<H�����k'��K�#Rf��+iG/T�E
���q��W{�$!�	,H�A������x=�
�BNx��� ��9Q�=
�ڐ��	��)� �Q4������&0ƣ�x.�@S*��F��h�֩�k
	r��g4��
#��z}��́�qK�����ZSm3j�c�(�������{Ќ*	9V�0������!+�	9M�/�E��|���n�RϏا��s���k|M��v�
|sh.�c�(�1����4�O�c�1i�Z�N�5�F�h�$!G
G��@kp�����������x�f_'�!6dp-��O*<�����.p%�dh=�O�.4���t����u,ʀE�M�#!�	�ɀ;AC����#b�9r����	�V�>����d���m� ŏ�Y��'�%���@Q"g�ǀ�@K�.�N��n�A�?i���X`9�d��U����y���U��r��y8���t��;}&!�	�ƀ��Z�|�3P&�؈�IK�? ��1�����p��@ȉk�`-�2��X	���TK�`)l��p'�K�#wR`(Z��(�v�|&p������a�7Y�v���[$�!pN�����B�H������b�E�}���>d���Řz�;Z4i*dēv�x�n�Ƹ��v\ �nҎe�6�x
Fd�	4��M����^`JL	��9x��$>K>2�������)�`�j�=�i$�P�-9�%G-F�1SIȱ�r�R�`��`I쎼;iێ���U.��>FC9Q`X����S�eʱ�+0'��h_����Ux�~ �D�90#翖X�ȁ����'r�D��D@�!'
,ȁA�1.��p�ģT�	U`B�t|
U�B�PŖӺ���tss��4 ��&>=h@�_M|zЀ辚�B@���l,����Q���+�������!�u�sW`1�F��<a=��:Y��K�#-�Z�����)H2-��/� ��	ڐ��?���5��fc��$d�FP�yp h.F��n���A��/Ÿ�;DB�V�������(�2�_�ƣ .�N`QІ�-@�6Kұ�ђ�V��'@%��O�Jn/x�%� T;\
��øÜ&$$iG���R�-ʋ�8�qɔ<�D���k��T�CA[2tU��S�(P�)���0f�A��aإ&%I�y�䎂ah��%w��<��
�����#!�{��A��!z�}�'a\=R]?ȯ���_�M5xS}��V�+��I��.U�KA��^P�I���I0Ѐ?5j��/K
O�S�i���W�!ल1ᑪ$�T3���6��0 {�~��g�E�X�h<A?��j�f[4*�'�|�	QP�4`[����yF�T���s���0��͔hr���؀5���EM����G�?ـ�4c�P�=�}N��F���7ߨ��Ѱ�n�j�azE�ŃF�Ӌ?��#
o��yI�X�l"$"Vb�)��b�n;HD�������uu	~��JB�}�� ��oq���v��a�$�����n;HE��~���;�&!#>݅�Ċ4���-n�$2�Ӎy�D^��uF����ԧ����0:o/��M׌8�kFD���	�HoN[�"�nQ"[�������;b$���)q(���o��e{��p�N�"���v����߶�������=�K��EBv�R�U*z<���eӷ؂	�<� xx"���D���s�q�7'��.	��Hud;��Ĳz8�m24��'����/{u�.�1�X��Ð/{�#�)���G'@J#~ٗ!�O�ӧ��_�⇉]
�;���<~�d��?B{�:��y�@��e�}����~�"~�$�0#���ⴷs�]�#��	I�0�J S�5��(�����{�Vy9n�JtL��/��#Dt��tE/�Jf �wh���x?P2I�C�@^~���%�!}�J�C�@��+z?P2Ilàm@Nf[�F��ұ��X�A1�B~�(��$b�B 3���i���ᵝ0��$�	d�DJ�Ġ�@�J��U�
���޲Ůk��;&���%�b�\ ǿ��X���G2�	s����@V��p��вK�#-��=D�1��͇B��X�A��,O����� }�Āz6`o��Ň�6�3W�p���?���7��z��_���!�G��BP
^t����>���$EƢA��~�o���)u()*���0�g����(NRV,�d��������;r���X�!������G1��dr���X�!�C'/�ͷ'�I�lс�"���n�o���-�Hȱ�ڢY6�Cؚa/�$�XI}mы\y������.�;��-^o���lOBv'�?|Mɱ�A�i�گ�
z�x��Q��8�Cgr�����38x'�?rhV��`���$�`�i94-7<�7\�X�P�k9t-��ἆ��<�c9t,\	;���~��Z���JB��C�µ�x��1�>��%��кp�D���ÇY�$ږk8��"�g})A�eU�,-�W�2�4	9S��S�b����|�@<aH�"R�����¹�S!gJL�B��-ǔ�2�Sb{�OesD��r���*��ʍmρ�J�1��r���*��������0�Wm�ݑ�)��Ѓ*?�6S�A	�VhCUM}��q(�L��U�CU3.� )y�(i�UhC�d����R`�.��hB^1DC��$dH�8�G���r��P�HBN���G��f��'(�O|�bdI|ǣ����b�@ɜ$1�f�]X��fX���Hȁ��h4_U��7�vVLi��bDJlƣ�x�N	Ĕ<J�x�G��u6��Q�!gJ<ƣ�x��.}�tΒ��Gw��Ѧ���v&)�F4x[���jm�Ѓ�B4|[���z�n��71|�dN��K��R�P��ś��o�X���h5�=��S�A�/���wj�
�������$	9Qb<5O=Ni=�̇����2,Ī�+�I�#!?�!�hH��?;I�F���^�g
	9U�5zUM��qI	\@���/q5gv���.q�ݫI���ק_�>%v٠s5�]�`W����83rh#��6h]�>��O��S�$?5hc�9�^L�S��A�.���)�Ŕ��P��w@}9���R;	�������WSꕄ�����$NzÖT> �OX2�0TC��s,������>av�#dt��9J>��ϧ�/�=B�½
�<'_0����I� Ya��*F��{�>��'��=�S�ӌq>�M��	!{��4�L
w	��ç嚩$LȢ;k���������<E��E ֘I�[t&"�9�!֪�년	�~��n�!��m��v
c��S2{���a?�q����Ӂ�9XЖSqM����S�47�Q
��,N������k�� : ��It��V�����p����{~>�O�d`_a�Rz4�����܈.�J����:��F�a��=�^L�Ӻ��8$�S+�fҾ�W8_ �f��;8�?����>.�K|c�p"'����y������������n8+v���C
㭕��%�X\�%Iȉ�Q �a�J�Uk?�|:�(    �dÍ��J���sŀ�gr�	�!��a,61��5#֟I�%�	c��V��n0��[��A
I!!�J*&��VZ���7w�.{���a�q|�f���%�Y\su?�	9ORa���v��~h��.?�* �i$�XAw^a���.tz�M�wV0��0j[�j�b����-V2�#	�E���h���s���0h[�z������ۖ>���$>���J��E�~ùZ�	��n�e:	9Zbt­�/B@� !�I�ɭ���Qa���<�6<a5�G��8F���#c\�1%����(1��V�@�[��q��HҞ�3I�� ne��o�F#�'6:	I�¸me���é���J$�F
���f���ݪx���gI�Gb\�2`!d�����M�R$J��0([aPv{8��#���Vg}���b�m,AB ��Z�-g��2��ERx0�Za�5�9<�9~?.��1�ZY��v����g%�
���5�0�@�$HjZ��V�B����~?P������ʺq�������
c��š�k��;��V��1�YY蓠�ܒ$
C���gaA���f���a�����t�Ya���W��\9{�o���u��R� ɒ���ў��_l�Q�}ɻX���
�o��
�OlYa�H3�+������Y�RUa��rv6vd�^$�m��<�s�Ha�h����h�Ǌ.������#D,ٮ�}h7����!���pc0�r~h��/��nW��Î��C�6�F�(ga�v��J�E�{��5�|��I$�(�a�����[�n���Y�����2��U��a��&!�$�6���J�G#�'��堮�{)��1�WU|���'�X�����(��f(=E�� b��\�2S��(�)`����01�M�S$��"0VWa�n�q�>�8���\U�A�0����F�I$!%�����j��&7�����1Bw��f�I �h��t�/g���i�]��v�`*	)����|�Q��D��;ii�G��*^O��0���q����_J�!!���D1tW��r��r>>�7����?_/���B����.�Բ%	�$v�1��ۣ���r������l
~�w��{\+�}�;d���r�_�v��i�)H
� +�_�V"NR]c�����b��"OR�b��5-V�yI��$U(�*�e�T�[y�I*���^���`�
%￠�s���z��!6�8�%%�.��7��6��Aa��x7�E��<��*�?�?#!���/�ª������I��
Qo��Um8�|�Y�w��5�1�9�%��Umg/���+^^_�+M��J%�	�
��,�ޞ�,�2<g�2�~�_ޟ� ��� ��H
F��-�3:��*:��@����jOo��b��!�$1�
C�U]�'q~I�\�$�]a8����C^��x���&YZ�0X5q������X
;6%K�b���͸�[J�����x`�h�O�⦟�+���$D���b�jR����=���3�h�&E�	/w��`�� ���z�9���K_�4�D��7i���~�G�δhe�ª�&`�6t)w�G������c5~r
��%�����5�m�2���H`'#z�gMZ3c�Z�99&������4,�/ח�!���+��`�.��~���+�5��R=�m�܆q%=�!�C��_�-����h�)��4�ñ�94��PA��A�q��M�.~��b\�;)l9n"
���@b� ���������1�XC���4[�x��>�K?�s �5`:[������[O㈰�d	�)0%�!�C�i��X�Ӌ���Id�r�*'���G����և�Ha�������f�8������'�>�J��F9���O�10X��<����;�b���>ƀG=o�W��������b�CnY�Ɠd
���������etUM⥶[y�ǎ��Ĕk���Ϟo��x����c��E�Gթ�A&�������1�W��ZBL�ԗ�L2�1�W���+ox����>����$�ӑT3�����y;=���t$�5ԛ��W���b�q��w�;{~�����
*޳0���	IJ:Fk�P��^�q����<�~^1�F�y���o��~{��CK*�!�P��kR����IA4g��2�k��6�a{�����$0��b,����6}ʂ1��x��A%����m����Eӆ��l:zxgE�	-N7{G�yo������f�i�6x�Fנ����NB:-�-�1�XZ���v�F�N��w�q�	H� Fk�C�kCu�vt��~N���	����DYÐ�Ic]����Z�ϖ"!�E�fhM�mXe���X3�����"0RY�4�q�kVdw:9�ӒL���ړop�"���t� ,�*0�YC����a����gǾ@B�K�r֦�ی�o]�'ׯ�gÿ0
�/i9b�6q�O��l�wH�� ��hmq���qz���OǦO_����Pim���H�;��v7�<���	H�9�SkK��*x������$$�� �1�ZC����R����NF`�NuN��H�
�����z�`�����R D�Rv�\^uU�g��$$���1�[[?��mZ ��}�f*	*��hc���q����X��D�X~k���cy�ZrJ��h"�@�r�jG�->��K��p�{�a�ڱ�����].�!�I�#!�%�!F�k��y�o��i��ߡ�x=�~}CŇɿFB:I�����%[�S,S=D��#$D����Ps�l�|����-��.�nV+��طHH'!���s�\~x{}ND!%�����U�y�̅Eh��/S�({��������q��p+�LB���7ڔ!\17Gv�Y�c$$�������5�/�xDy{[l���5����	�2�XE&ƶ+�^,��Cv����*uוJ׵�Ww7�5V?��$$���!�bFI�Rf�WS��hy�a!�9�]1�
)��T��
��uego��X�!���a�4RRh1�]W,�o�&��ޕ�?HBbK�.���b헱n3斄ĔTD�+��֩�ݑ�i�Dt�Ѯ�z�x�L��FB"*I� ��u�0Ք�r��g���zX�z�-���6����?2
�,q	��מ��E��vx����
		(�Q3��>��^,������L�:�����dYKR�0t^c�|;���0�������0�q�:�B��6�.50n�M\�3WB��r��ѳ�K{��SH3y�X���*�����iy0�%�+����y��Kx�U~<NB��x����W����j���l>�8D�}n$.N�z1����Z�������+��.������BB6" �W"ѩ�r���g˾AB:�S|��z]���U���<�K�ĝR$Dسä䡍�hc��tIv�#	�Z�AZUm�l���G�HtѦj;FX���v��ϣ��$����NC�yva2��1�O;y��TW�߰��Z����&�)hA�OS��fK����ۊVS��߿5��������Y}���?žO�pB/^^�6G���A+����qp:?J�);�������t2��6FG��4�$?%e�j����C|��׍���K�m���};%ց���5M��3��r �d?��׍�8��W02��$$��vŐx�X�5��^��8t\�%)�J0XҼ�@xݸ�L;n��e	yR�ÃH4��O1/(��W(��0�]7�\��e��3����4}��$���u�B�h:�x��̛NhTq�^q���-�HH'x�p��'��4�,�>�(N��I3Md������L��L�4��>��2�� �`��z`�Fzd5e�"!���������I��x
Ѓ�WkG!��f0(ޔlwm�b#SHH@���7%�0~X��g�����L��x���xS:6�u[����.~|�+�Oz� �!���܇ؤ`�f0<�@m�,�\kT�;3o��� ����-.V-�&uV`R��Tv��;�q�\��m�>O`PC��t����]��I9�����xu����]p%6q6�g��    �0Dިa��8a9�=N���J,���[xQ���am�i���Q>�J\�������{�Ge
�t�Fɛ!$����w7�n�eHH\I1Šy�rhƽش���}&!�$Ec��O����>���R�S�Y�~p=l���aO�'&������Σ��Z#%��M�A�wt��3�DSj�4=iz�C0|7P���f�����?K�!1��@�3LT?h�Vw|W�I����'#ɲ�n��F���x\��4�10%5
ƴ�m��]ǙAYc��5;JB�����A:�TP�Е�����u�q=HG7���0J�3����ӈz�3�ϴƮM�&	�L$-az7��A�e��E<�We����Ģk��(�a*	�z�[���\�9JUzr�a�Ԉ=%x�A,Z��1�ì���8ʷ��[$����(���|uv$�s8)n��s@�3�|�r��Q�V�'�E� ���8o[�9z[K���n��,;e�2�$�����Lf<��Q�'U�P��B$��ʓި?�F��V�#h�g������vc�c�zz�uBK�1F�h:���E�h��;������xbѵ�/����.o����2���e,�+vu�;<8��e_��.i` ��F���8w�K���n�>�玃O���{���$$-�e7֌c�x��n5�/ud}ur��F��1l���7����*
n;�j�ߙ�������ƺ�����~�&qcI/TM��'pI}���VG��$�Ƹh�}OR-b|���W�$����'�:�{<�p+w��F���� |M�|�?��%�C��S�a�)9��%�#��ӱ���G1�:�]�px�`�{7�<�-)��n���%�����ͦ�o7ʹ��o�v7����zظ���%�~�����[�3�%e������/	����'��� ���G�n�t�)�N�3���,�חKZ Gmrg%����*g7���zۮw7��>f�$O���ƹ�jh���l�G�8!J`�n� w6*�yE:2�J��Me��w]��G^�&<�'c���l��qZv �|݁�Nۏ�A$�RŢF�2Tq�'�����1ƹ\��)U�$0�`�����M{�m�-K����l7U=f��}Q�&�&*��?Us|��-�'�(*�hA���@��\��<b��/L�T���ID/�D0��x}i�H���:#֍7�P�������+���ƯO�ig�,$`�&@�`̺��F�~:�_�Hu㫯EJ�h�N7�-R��n|�7����;ij�@4�|P��:uI���7&Mx��#�M��2v�����ևм*y�-)��nj����c�G	�t&z�����C�#ߏ���d�c�M�3Z�'dܘ��$�a馦�N�670�<aJJ'���C�]c<��o�����M�.��$z%��0V���{A�\�������"E��)��{�EiP�27������}_�'/JJ�;i��q�Eb�Oh�ä�%:m˦�hA��j�$�b��i���%��ė�������4�h��PL�[a�tچQ2т��8SO��%}�n�2т?C��Q	����p{���40��4�4}�tID��`���0�"J���mY>���LsOh�#���㏠�b��-�tڸ���j��9W2��b��-GO��7��n�ܲ�yO����dd�7�C��AƕW�a#�t�d�O�����7nK�)?���r}s���n�dSPx-Ƌ۲
?>.��ֱ$�� [��6����n��<�h��@\I��ňq[��ǁw�Bv�np��->Nv�� T���-.��V��c�Z�Ű-C�
	�oAX�mZᒲuh����H`A�d1��*5���Vp���.�MR�U`�cɭ��,W��w�m�_��J_��B\�0	Ė�IZ�(�*n�@���V��+Lip����+)�CH9mI�����ɱEv����n4/�����՟�Y)AB 	���-�K�o|�w��j]�����!�+���Y���֮P�3W�#$U��dn�놵�&U�ޫ~s��K�/z��Y�"�n�+��fi�!+z��Tp���,�JR(#a��ߨ���|��q��ГI:V�ʢ� 	+���n��[.4\c���$���A:�:�Z��_��bܿ�pp�����A�\�Q� )N�n���Ol����N�� 	D�����s�in^ؑ��G��3��^�_W�q�M�1�V�P�����`�HB@
����-���z����LB�I�ɭnr���7�7
�'�R1�ܚ���GB�Il #�mX��$�4�]HDI�ĸp��s��U$
By-�[c�C]�,�v":��ǈzJ��f�$D4��*��R$J�n1 ���E�u!�$����@C��|s�Z�S}�]���/����%��Cs:}�:�J�S�xp���g`�l1��b_!!�%�'�[hr�í�V���ޱo���Ɖ[����.*�S�P�ŠpkUz'4�tJNX��pk5o{}��[y����0��Z3�4�6^M����L�Q�*[��z�!r����W�^���@n����]���r����. !P%�w��P�s�Ͽ�+(��.�P���	ĭ%f���#�C��pG�IP�-F/�j?os�H7mtŜT�
%ڏmf!~$�f֒�$��!�!�֕4��P������@y����M�r���D(�?�m]f@�:.,�t���[� ,j[(��2)��Ӽ�11*�:;�c��j�j��0�$5�b[ž�5n���R$Ht��k\5�1�~���X)A����Y�������>���q��t���Ņ�u�p(Lb�[m]3������Y\zb� a���d��t��*,}y�tLe]�f1��Vj�`"K�,��``�����8"�$H��Pj[e����k�E�[IE�Զb�C_vwP��יN�dK����쮝C���k�U&�Y�[�LR�`ܴ�f3����mJ��o$��'m+~��e5����@����L�:�����}$!pD�}�jh7--`����DE�×1/��Vښ%I,I)� i�����%!�$��F[�Ï��P���7-SH8Ie�q�֛��oz\�~�A#! %�������{�\�$	�%q���~�"��SH ��`���C޴��ae��n���nJ&�Y���>�I��L�'L��`����m̈́��y�/��Կ��k&���\��⣽���L�$��ж.g?�/,i��I��X����b?NO�@4ɣ��g[���C��8���\\��H�%!����`��S��`����I�,�	�$$��mM�Ɓh�já-[�;�vJO`�Z�mVy=ؖ}&!�$�A��4���?��!�L!!�$MQz�u����$�5Q�F<�:�QN����$�F:�&6ip�!��I�!F8�&,Nt6�6j�D)oЈ�x�l=�eq��/�{�d��?3����x�7��𡛸������x7�ffɷXJY��b'�bb��m���_���D3I��LD�L�l�M�?�{��O�((��Xf��X���Kɼ�S� f�Գ���&�v=�M,�R����@f�4����o��cK��c�
F0���=M�y��W���9Wv�����d	H`%��]���_���P��a�O���/q��J�!�U
�H��8Gv��Z��LF!����@��M�^ŵbz����cWV_7��,Z!�W����19a	��aı+)>��ܾ��t�	�a��+���	�Dc�ݰ��eX�7}dk�"G`_c��J�.�z~�=�SH ��a��u��#,��^ Hbb)��W3��<�@�8;e�_��S�D)wLI��à`��K6P��])���TmI���`�<���N�a��n~�R$I���=T��=�;u 0-�v��T^Y�c�jTY
��Hv3r��tX������ip3N�K�"�NA2��0����~���?�x�kq���J[2����Ԯ��>�tS�KLI}�Ѿ���ݑan�˒�Ȟ�d��    �_�팞(�q^�����]��$���b���1��6�y�/׻�Ʀ��NK�+���a�9]�p�(�D�(1X�uz�&�P��l�|�뛗�nxړ'�ɞ�d��a����v���0e;!!`%&���N7��H3�~�R����_�����Ժ�n�!���{�����<6<�!��lӅ5�y��e9�ˋ�=rF:�Lz��ܓ�	�ڐ�_t�ǈ�dF���jq��|����B^�7�<�}�[ã��`j��e��8��
��Y���$�s�b��\��͋�rNge�慟⊞9z�����؇[�s]�R����3@��.G�j���vWt�h{Ə�p��`�U�T�=�ǐ�p���xwi.��<�������N�!!��(ãי&4�b��qKGIg�˃ݏ����+
��zJ����R���ן�
�jy}�+�c���cֆ��n�X�q���Ҳ�_�@������N	=β-�3�*�th���_�}���f͑j���Cs��r��ݥ;f��V2&���`��q&�[��@�T0����k���]�ޡ�ܛ&#!������fӻNj�P�� 	D����cT�4�Q\�/�$��̡�a��]7_������7�PB��ò��K]��E�]ͦWj�~d�*��ӛ�'!�E�-�=ϰ����3����R�a�.�5������\_�����TRRw``�s�H��O[��"E@40�ʋO`UPT�e
	���}1�3�Ȁ����?���=�%] �pv��~�F�}l���0��܆lk���$�3�!��v��h�wvVI� ����|�qѰ�?���N�9<�E���Ӿ�8���7P�n���(����A�f��T0��$����Hh�-��u��Ue*	��T�XDt�D��L"!�$���]���A�%K���g?_|(�<�1�Qe8�ϸ0rL��h_�d���N3vB��9Ҿ8��1:Q5َ��g��%�r��OC�e1f���hj���]���T08��d>y����B�C$D��[�!Ԯ�����$�ˣ��р��fG���ALK|A��۰0�ck��Cz�`1��y5��,ǿ������0��yͶy.J��冩$��k�q��C��� ��j������K1��x���[������/�N���W������z�E�j�G"HRQc���~��s��M�޲4	�&z�h=Єz�ߴT>؎MgEl������I�u�1��yfB���š״Z��$D��#0���+��@�(G�+�f���|�+���&����/G�<EK�1E*9o�5�SY���=�b�z2��/ū�&��t��,�q]�I��l�b�GTLt�$�`���MX4k;V�^RHx��n���5���Z�r3εm�v5x��D�U��:,�Qt��nLŒ$D��1���UZnz�Ŷk�S�)�p�ߋţ$$���1�a$�xi��-v	�m�$"Qb�����[�����L%!2E�M����]Ã�V;���H�t��5��~��9���-�:'!�%�{��vͰv"�T�w�?�h�q|s���.���H�x��c��k��0^m�k&����'L�|�V��ڴ��Xy�N�8]0a���2�1,�Qc�b1�*�$��Zы�=8���N�F��*�����K�`3��m��S��~�|��P�;M�~jc� !�$��ڮi⏿�))AB �
=�M����g���{����CAW���T)����%I,A��¨�����]���@�W�!�Ui&�5��P��NA%����,�3R�M]@���*֮Jf"c�aJ�XDd	��X��L����gHt+%�gU��f�(�QU�]��=�ij,EB@	�����L�q�a��jCB 	��l\�-��o���n��Eّ>�X�kU�]��"��8�9K�X�� m\�*���Vi�=�D6{���@m\2����Q��V<B�į0@�����4M-}f�Ԟ�0��1��:x��Mf�+��\����"j2�S��o���Q<ѕ��@�H&�f�!	
�0>����7-q��Iʳ��'�>�CQa��?��y�Y�	%*�h"P7]�2L��9����]�j�I�3�3��b\6.7Jceǰ�P���\ͮt�ZO&%�3�O�_�
�D�~Λ����0��I$N��]��"�ش�,A�$&�Q��]��<�qSkY��eE}�
c�q܋�⛫�j:�[�����$t-x�Wa�u�U�k���z�c�i��Q �	{7<FD��
l�� ��;XM��w�XWP���6�Cslu(NT��r�Z�����w�����//JW�g_���æ+�f�L��w�k�&!#J�?�����E;�F�l�FBF����LX�m�D��#K*�FWP�N׍1I=ƕ�9GWP�R�&�N��lu��x:�BWP���Q�}6<Գ����/Ξ_]߬�K��`�S��>�IWƳ����ݪ;2���0���񢖻������A�Z���=��K���ؿ'!;CI�q���*����,0%��RW���a�4��4��c�`�ʦx����s���Q�7+{��f�췦P����3��������,{���0t�������v�^���ڿ����f�3T�?"!;/�c�t��w8m �TX��hѳ@�c�s�8a��6�������7���=y{�LI�+�v��֫��hJ#J��+��V�^:��%��ѕmf��!_$��Z�2�.�?��O���$+aXt��!�bJ��P/$T4,�g�z_�ϧ�$d8I݃a���X*�r���`k���c�t��lJL�cDI�ҕ��C"1��%mk���m��B���T��.qx��p}��n
w9\������գ�1yqᵨ���Ȕ0FFW���׊���������l�;�	�iH\c���|�4�|��%�!��L�@o����5��SIȸ�&6�NW���p�ۢ~{�T2�ļ0�����w�6Sl3�~yM�ǰh\�M�!�a��$dD�qa@uU��j�3���)�.��*���𨓞���1�Ĺ0��������R�ObVB]Uu$���½�w����%���Ը}LXam��mY��(1'��|y�QС�!%��ԕO��ú4��f�Y�@;�^���������tBV6Ɔו�a����u5���2��+)Qs]y3���<��q�x���/)Ul]y;�W�n�^�g�a����㑳�2���"���S�@Ϯ����/^��9N��Ἂ-܎~3l�ɾIBv.�"��ەOQcpğ�3�{2��Xb�v�S����-.qz/SHȘ�r���S����Eu{�2����Qڕofo����q�	����&i `x6�M��v�s&������V1N���!�|J=�P%�U�Ϯj}H��R/&TIoC���R_�M�I��/$dt���_N����RBE���!�Ք�jB}%��%��!����zB}-��'�>�����>��X�1�lWu=D�f5�LBF����]�ų�RK�#��h�c��w��W�K6z��_y$y7}bE!��lW���<�:T��]5:�C^��Va�ϳ�0�(#!�K�R�ٮ3�F��z8���1%u)lW��M�����t$���V1Z�j�������}>�Z#��0Z�j*�8��&�Y#��0^�j<C\Lq�j��Tc�]5���c/��f��]ws�E�슞'�&	�dD��]5�,����U	%�H�x���n_���݄��dL�cl������q=fߤɾ���� o�A���z>�
2��Xo?,ϝC/�Ћ	T��={�a���b
}1�
c��}��nOuJR�T2�f��߾��u��;&�$	PP�y��%��/������2�����p��KF�=���n��܈=x�aE����}X�;��}ݍT|�ɽJ~?�bA��c��W!k%��Ia3'S2��1��C�v�L�̤c
* ���7#�Y�sZ3��i2��
��r-�q�'�E�"hm{�(�Ќ}���v���(��$F������v��94�R��(1"� ��\e���)MBF����{E�    E֋H����{�-��V�W�/W�F�1A�^�ƃ=F�{h��o�.�-��;dƤ�@4I��`r��p�[xb8'�����$���="�l��(.�w�.�Œ�_y%��W�Y\y��/J�H�`*���r�B����HDB{�1��!�rB�� �(��i�uu���D�	-��7��v7�)��e6����M�_�F�=ƙ{h0L�_bJj~2��v�wA�q.W��I:��^�B2=�{h<��/����,A�$v�!�Z��fN��c_�hu�t�-��J4��1��C�al=�xZ3�"Jjf2�Јȉ�gR��W��/���>���K��l���Sɨ�ǐr��m��[�=S:Ϟ�2���'�$C ��}�Rc��J4�1Dܛ.-~����؋��L!%� ���&n[�i�<_��M6���l�W�L����oo��k�{���q^���yȓ\+F~{wJ��KC�q��3��7$!�%�����jZ���b����%������*��Z
�&�	1b�۴t�c;"KR�1T�c�v�����&��0f�����u��r�DQR0T���.%pu�G6kE�(7��Xhɴ�v�c�~YR�`T��M~9�o7�/�IB J������C8����iAJj:���N�^wkl݆�)��q����x�ß��*4���χ�D^��i���dk!K��1��;�~WI��_ڷ6�qc�~��
V���̽c��Nխ�~��$v���If�~�$J�DJJ����ս��h�6�}NM�XM����Z� �0I�~���l�a�bq_�(]X$����G���!rX��t���YM��40IJ|��w����E�:�Ҍ*�=pq}Igs@��_�N�A���QW���W�>v�31�W��¦�F(ȇ�>"�;&�IJ |���mY�wD��F�-�UX���S�>T�-�x������oO�Vg���)�G?����0AןP�%����6q�������`�n=O@!������WNyk{�(|���qA���9���Ē����s��r�x���ry�pM[�V��=
BQ��� ��b�04���JRb`J�.G�8��#��gYdrPK
��!�]ԴK;E@�Tr��`>��%���쁃�LR��L�#��Ǵ������f��c'�Y��W�p~�4�<��x�~D@�Q��.���6������b�0
�(#C�B�F�-��p�214)��!�-��!�Љ2.)v����jQ�Q�]�P%��� Ͽ̇�������K�P%mF����\zX5�;YF6��p�f�]��_��W���oSRu�$b�h�Mj�튐�D#
0�ș��aI
�!]��dM���D����hN+kw�(~����f�;d�k/1&���qJ+�!^{��4��܏-�b6������{��71�c~�4;E�H,z�P���'��]%��k��CR���$��k���1^_gƃ����	J�O2J^.,�!�1P?]�&'d��X{��Aɖm�MrjBuHm��
"�\YBO[i`��q_.��<�,r���v�9��f�3,�07<\������rk��k{o������2C����C*���+�f���/�}����C*���*��Hݓ����`���󽜐(z�4b�n/]��bA�37�P��]�]8�o�����n�ðlM�a�L&(�6��o�����&AQ�����>�IP�"���~Hh�n=�	
\�	8f��1\PW6דle3�iV�ev`�)4m`����\�]�Ƴ=l�`/�q����u�ƫ)��)��TT%��w�&Y�Qp	�x��7v�sF
�zz���^nȋ�vqʃ�@�8�������*��=�D����m���02I� ^ߨ�Pu�U���z>I��7�:g�G/��
�NPh%Ub��7"��nZ=�ՕV�w��j�r��d���f�d�v���^6���Lb�i�e<G��,ʯ�"�2wS�3��/�IUe����#��>�-8��kFW�9l�Q����xa�H'ɚ�GM},��Y�Y�͞I"���F]%�f
��+�$E fߨ����c,E��%i���;�~ӓIJ�Q�����%EVި�l���e=��H#)=��F����Z�|�0�I����F]�����V7w��P�M�Ku�cC�1D��t�(q�ν��mZ�ܦ�]H�5��ь{��&�,I�H&)m0�F�+���#WMM�$ ��hX`��X�t~U�w����JJ���ٛ����߮���WȮg�͈OY%�Fޘ�הu�$�^ޘ_��6�}��>��?�>��Y�o�o�y���1�9�Z��92���Y�����[��-��g��{�QvL��$*�!۵S~4�P16��:l��>Bxy���ᆩOL�$/�ݘ?-�⋿p��H�a��+���W8B���#`�֖��c�g4�sv�8�T"���F�f�{.��W9/�<�`
�DJa��sN�a�O*QR8{������>;C@��(*�����}馔�PJ4��h�w�X� �u�a�����R�%�γ�݁�R�#��7�q�q�(�9pkʽ����:^?bS���j�7}{z�wv��B+Q"���k�ܵ�	�*���<r/dȱ���ǭ>͂�i�Cr/!$����զ� �/7�zu��0
�D
`��O�Z�-�"̧�Ձ�H�0^��m��&���8�xp�u��/��v����b�IBI]	�qD(�NMM��,aE	(��r�q�.>8{z�A�*�J��Kgr�Uo���e��z�mVI��M9z3��|%�M�%%n� ʜ��K�6/����,G�Z��7�=�����
P8%	|���j¦y�m��I�'����q��~��&�p؁����x0��HBv|�6c�I�;�W�2������$�T���N<��(v���+)0 Gf@��.���%�<Ǒy�ˎ�5�vD�d����AWX��w����=KP�$j�qd�����d�fi
�DF�-�,$1vf϶��&���c�ƙ,������}�����Ƀ��{I�',��>&dMP�$rq����<����N�(��8�e}���lX�ݪl]w��DV`!�QՋ#w�^o�"��I�����}���_1
�DT�"��ԧ9��h��#��DX`#��
�+�;��5�H�*p���S���P�$v�C�������fA�9@>II��7�X/�s�����c�%�P���zL��o�����l(l������5n�� �� xtcR[�bX�7���xtc��ъb�4�Kj<tc2��V���Q��̴"I�;7&;�j}���\��19��q����f�W�+�l=��H*8xmcj^�t�1�N��`��n�mcjF^��'�P%e^ۘ�����ċ�L_Q
����jS���N�,E@��%��p�oO��.��m�4D�;�d��|q����ٞQ Tr	&��i����hd+t$�f�:S.����A>��$�mSg�ðC
�@J���s����;}�x�d)
�@M̵��C�G��*F��o��?_�cv���+Гom�F�Ju�m�M &	���e1ƿ^|w��w,A@ahH��6ui�K���)���@C��Iu��KP����DQ���&�����S(Y8$��lRz�v}wGK[�)���5s@Q�p�&e&Cϣ�4^_�S^���1��8=\��]e� �Q�%0�&��\��rņ
��"��J�n٤�fJ�o�j��I��߮��
�]"/p�&��Mt��Hˠ��,�I�:�K�����L&��d���\ݬ��P�$2�lB��r�1yEX��L�$b�lB�S\��}�}�}�I�:��&��=�%���:����5l6���<���%$�^��)KP�$
�l��O��$�g����9��G%ɖ�K"#p�&��5�xX��x��|�`�M����O֚W����Ȇ��M�Wۯ�A SD�>e^��T�3!(�߷-��j�d���M�%�PJ�(��ɨ�fJi�$��N��c<�,�� "I��63+    ��_ �f��	>ˤEN�'m2��B�E�m2n苼[ܜ-�!�GR��;�L���$��*��L�Q8��u�I�u�"{U�16�����~�7�D\���\�.p�&�ڵ"�4�~�g'(�y�k6َyd��1�H"*p�&�h}{q�����|��f0�S�*��&�y��;c4�Qa>�E֮mj-�u�ۈ�޺Y�<���	�W77�A�F@!������2"-�,Z�I����ɲ� ��k�Z�-�7�,�z��yqz��6���.�l���&��p��>,��^:���.6W�E���
O^�Dd��M����?n�}T��$�pIt����G����I����t/|�,A@a��
����y^>e~F@a��	̰��z��o5�(T%�69�$}8���/(t!�	69�;�,�K�&Z�b��F�%V��krq���fU�s�부�&Q�^�K��˓������G��l��w��M=^O����ԗ�}M��q�@�t+�W_��5���B���pÖ�ܮɳ�7����P�$��k��^�E��{kBH�q�d���m�]b�K�&?.$��,�WB �I~	��C�%�N5Ŷv �Db�oM��[)�Ś�E-r�%�[�O�C̰;L�6#��%�\S�fz~����/N7���)-V�`0�S".p���;C�u߭��:������`qMAS�|XGZ���R#���5��Z<Ҵ���S#�J>L�)�mB��F6.�k
n�����b�ƻ��q>ndCG���g�oV��G�h'�)�;ݏ��5�'e�l 	N���b�m��DCI0��0ne�b}sz9��,c���'��"�9��t!�؄P"�����H�߭~`�I���5E=�o��c\����edGp��hxkv�ށH��p��h}�0�SI��5E7#o��_KDz,1�
�oV��7E_�K�"Ua��0?@4b��K����ՄR�- 1��=S��V�I�!1��+i��J�R��9%�\�	�oN0���歧&����ڄ����S��*�ڔ����Ͳ�Mi��R� �d�jS���F0�M�MG˼�X�F3�M�&��=C���z����zJjB%�m"�F%)�p�&��T��WA��;ps����/��Y������C���0�F�^l�r�ay�p=�~8����i�N0\F���{N�~�����fO�<���.�k��7�����K)"����k��튲f�~�����J���wvH@O���u^�[���U�����~�7{{zw����O@C��	XA�_ �7�\?�Z�{^�þ�}��>�v܇���[�}d<�<b �Z�swz�@�ϗ_0�6n�����K�DE�m�4}�4��v��U���*��1�U����p�軯�Ww�����܅���^�J��7���;vL@���7.<��+��:S�]����??�|�\��I���ٳ����(u��=����om�[oO��>����壥w�O|��e��� ��f���ju3�w8l�<�s��;W	ݹ;=sɜ�,�!-N�Z����Yw��#�w�uQkT�Β]t�<�������+w� ˹�b�W�߸�ܳ�y���U�=w�=��|��DǥS��bl<���T�n�<�y�c�g�)D�N�R���'9C:���t�gԼ�+��Ҽ�^r�'�>��J����K��<��&y㺓��V��ַ����AN�]�/|���X��.�iP]8=��It�$z(_5��uǣKTw�h�[k姮�%�yJIݣQ�h3�r���wb��|������~D@s��V#K�a�Ӂ������|�Y��T�_nU�S��O�s��z4�2.�g�=`.��c�4l�V��`�uh�^�;1Ud^�f9%���80��Ȇ{8��[R�jԡ:;Ċ��7ڛK����Ԩ<M7kV��_�W�$�g���u| ��< ��^6���.>�㡿>V��c6��(�1#Cbl�z�Ǔ���;8e��~	N��lMN!�ȋ��7�����k���* ����e;�8:@~������=�N����00�B�ζ?���Ez��z"?%�����ܺ�Zo���ʌ<��W;�O�3:c�ٛ��c�(t����L�2*cUa�,�daJv��8��z��Y@���a���~��6�P�2{)�2�4'(�?�i�z����CTg/;T�ڝ�@>TThѝ���[c�è&��m�L���~�(��aijM�#�s	#��� Gd���*�wF(ć��^^�l������I�P�"�J�S�g���x���s�/�PF�E}�1����C:�����6�W�n.k��x�����-��x���:�'n���v^Ln��vP�����rz;/'��Rr;(unkΔ}�zfק	�O����ӑ������\�M����:�j���*!�(��e�p���|�C8�AA�����{]�!�DF=J�7��ɭ��CX���u�;�ո���c��}qS�����?�\�$�g?$���Cڕ{oճ�����JI%�!#��R���7��v�^B��>[X%L���S.�����e!��?/Y���PҤ�����ms���� �A����HP�����z`)8�Aq���A�XlSr	�$�B�(�pz�4$+���uP����������!4��	P�P������W�J@�+�� �	~�jA���f}q<<�O��{�ѮW.� Qb�Q/����f�@Z�*�R��@ӛ,��D@C*j-(SH۬�c-����O��Ak��fB+i'G�TT۴z��z����p�ZŬV�����R�'j�{=�D�c?��fc��j{V�����Va��WC��N�3�U���sw��2�����.��q�K��ƅ^ؓ���Yr��o�Δ?�����/�_$WI���]ӻ�d�<j~w�$oNC�A}���d�TXv'��w�㩩�f�<�qaN��[(sv�NO͉]v���D��'q}V/����!,�B�<\=�Ra�G�--�٬O��� �%��"*�8��BАW˫�����H%�SD-G^n���,M ��J���>�R����+�XJIQ�8�=�D���B��ӻ���0?ܬ�O`� ��"ꅘʞF��p�cL~c��� �-i-G��ԕ��_���_Z"�	�CR��C�~�,��|~y`�4�*��'O��EC���P��C͐������йB�
ڞ��� v�J�dg5>�0��g,��X%R� U�q���D�C�o����a��������K�+A����c�nk�/��$ \)��T�F��P�D���zw˧,o�1�D=�%��2C��w�܏J�����ԇ�Y���V>�h,ƪk�P+Yl����@�<�
��Y1�ؚ�.��Rp��r�}0��ɘ����c��i����O�Z�>�_z������@���*7���m�^1>
7p
TB���r����>�J(x�Un*y�x�X� F'����0���������{�Gn�V�	`��P�c�n��9�.���#��~��������9͹������W���E� 1R�j��A�r]@���`7 
�1��Â��&y���� '�^:�R>�ר?��/swdqُ��������7_)�54�܋k�h���R5>�{���$��I�	� �jv���nuZ|����<)�'R��m>̼�Y-�9�D��*����_�=�_�>���.O/??��̏�����/��H�
+Tn|��ˏ�t������P�D���@�A_ɾج���!�J�MXd�4���Ơ)ɭF����V�10F�6?�I�ZOwP��tP"]�gM���J,'
m�-��f}M�9��N"0E+��C���z3��v�+sv� �,������@K��qO����������:���f?'�ݎD%`�V�N l�Ś��0B�(�M�t�����X��$� ��ҩ��,��}dI�uZ��yq��eԐ��x>�&�;��:$�]O&�M(ئ���S[,A #�h\�ʰ�ȰP��d�b|�ՁS��wZ��?�݇>O7�I��ie��Ъ�    1Ń�l́GZ��9�`i�DT`�V&�[$���2lS�f#��	�Y�gZ�*+�ޓ'���%����ݮ�a�|���\��V}�A�����x"|����6�����V��̇�sX��$
��b�_�7��5��#�%���M��nB�Q�k��*���Un!����_�8�H$�he���{��=0��^2HLn�q����1V�4��������{��5����������Wk�PE�R��
%����X�(l�<
�r�4b��|/�E�;�,E@���M�����R�I5���]���{��|/#��Um���[o�����{��*�m=�K�P�$5���y���kT�]��KR����r����-ݖ����*Ȇ�2�����\m��^�ޖHjcP�K5qi�㽘~�#�D�`Q�6[��X��I�&��ʫ�h�6r�y��_�S�l)����傚�m5y>�f�G:�x�C��ݢ{6�{6�I�>q�|�o<��I"\��+_���?�5l!B��-���NJ�D��W>4�f��|�ʗ���[*{}�O �$f���u�2xnFc��3c���f�%�Єn�����r�*C,=!�d$��UP��ew�-��I2��*T�y�n#?@l��F����	f:�;�Y�հt��Qu-y�����*T��~urºF߯(T�Jq���{�(]X$u��*x�����uH�����{/�%�u��Vsu�դ�JI9��[�8^�/^5і7ш9L�*�=9RMs��9RR��J��)�A��z� b�,�*��.g2���حb]��z�9ɽ׻��"����sJ��n��}~���������Sgǧ}8���oW�<��f�kgSy�<�*���|u������a~N@�,)�p+8�����0�����I(��U�[Ĺ�z�f0-�`����XŰŌ%?cq�+�`���Y�X�9U��hh%J۱�4KԎ�G�(-F"�8�c�R7\����#�e��(l�*������+�h��*�]^�6��df�`�:_-���*I�	�`��V���7��N����6�)E㒰+؂{���>��c6�n���(�PI|��x��H���7%TSM�o)�H$��*��0�e>�v�+�x$��*�6l
K�Q��O"��ꎶz�/�P�!���W�
����Wt�Ga�*F@�*�So��k<r/�@`4콺3�7�����ÆA�+6^���W�7s��e�p2� ��W窉vO~�\\���ǜN��hxxu��Z�\��;�}��M���~@@s�����\��[nVgXr6�K��F�1�]�볯��cu�E��R�@Z4L�:�eC��������@Y4|�:�c#LϜQ�0J$�\��ʠ>>������	zs�?�^�DI��չ
�׍I�I���dPP�s�s���'��5����u&��l��ؖ5̵:�%�/�wU�7�M�aY�Q�s-��'����gY�A�u��%�mn+��fq{��{g�oy��D?��*�p�����Q���j��\��O7k�e�4t���V�N�y�C�y��e	:���J�s=U��bB�M[�H�5�k�G���1q��j�IFo5��:�W#C�tqG���j�uu���,6��Ŧ�K��F"-����xX��r���j�Yѫ:r�ܸ:W[_?.nJ���cIFr5��:�_�!1�&��&�ru��g�h
�����W5��f�X�5�:�f7(e5u���ID�\����|S����5��:We�!N��YSbp�0��\�M��/�_{[��@�,Q�su�Φ̗����U6K4.]mB�!~����j�٫�{��]�<���\ϱ��˻�Юw-�8w��xAc���I��r�W��C$��\~z�l�����:W���3IT&^�+�1\%?$�!�H�:�~56f��.�W\��o�	8�Ĭ����֎��5��h(%27�����P���D`�չ:���T�d�D���w���i	hh%��{u�G6�	h�$
?��i6�k��vȬ$.���W���\�ZV��H*��z��ʆ��e��f�Gb����s�ȉ�6�Ӹi-�D����p�"X�ઢں";�� � x~5<�}�������	��W�:�4�֒�E(�!�u�h_\��rŶ��.R�
��]��W�+��pZ���X����s=%�R�ܼ�X;�-8[�^�㖮#���J�`S0� 7.�J�������P�ڵ�A��+��D��a��\�^>�m�1�HR@�ֹ��~yFOvH@ᑔ	��u�d{�lf���3�4�LR��s%[B>�x��@a�dG؂u�b)��O}���|P�DY�+׺+��3?���`9���f���/J,��K��!�(aֹ�m�M�z�����J�`��H!j��0�Tc��X���e�i~��g~�?��$�aֹ���rŢ=��T
��T��\�N�K2VGYO)�6�ֹ�e�6?]�gQX3��B)���u��@=�;�P�$���u\p[S��IFa���w��_.�g��&ΖMf�h\�:\|��`�;$M؂u��4s��Ԫ}����Cb��ғ璈��:vX͚���9Ϗ�
��BdĀX3#�Vd(lՂXGkd�l�XM��$�`���2����iMN�$%V_�8�sc_Ѷ��!��ձ�A*��9��#L qJ k�{u�;8m�ۆ�
����Wǰ���u�i��N��W�իc��i��5�=P8��p��n��d ���[���].�2(�R�TZ���V'={�Z��/��%���Â���G)S�'#)�0��4���z�;E�f'(����N�&-x��"�ǧe��puo�e�R�g�E�l�N���
WMN��˃O]��%;�٠���V`��R��%E"��f��R,�s���������VR���͒b��x)�{x��� �sxQ���
���x�����x�������xц����x������x�a��5p�~�@7l�����C
�!}��<<i����y�P�Q������k�}�6a��;�"�PI��\���韶.>h�`��!4��'w"�z#!;$��H�V]�n�n}��~o�P%�ۮɷ���������`X&����k%�qH��ˊ�҃:0{Y� ��a�SV]Y���e�~�܅�e`};�Ú�m3�D���5�
?ܬNכ�9w3��D���.J=���3��'�Dw�(͔�T�Cz��(��5Z��f^�90��^BH�֓�����N@!U��	K���]��������J�'��F�=�f�j*��B����j�������^V(��uyh���|҃��B|t�&�S��5��Kұ��X����|/�w'|z�W��{��>��;�3S��OZb���_c�|��z>&�#is��k��q�����t���P{� 7���>��3w���?�%�v|�%���џ�2AU̡��?0��^6���͒~�,no�a�����S�+��װ���aj�����g���A˼�BP���A$���kX���������$���kX�ݏE����S�a�uKШ�fQ�@&Qs����d~�&�I��\c1��&��_였B$�Xp��������V�jLM�$�뭱n�fuS�Nx$�׭�lk DG|��y�
�D0`�56�^m��mQ�3�N��k/-d���_�õ��a뒣���c
�D:`�5�F���(]X$�g�q�;;Prk���%��i�+֒/,��]���${H�5��&�����b�L����ڴ|���qv��d�ɶw�"��\��@�ˎ��/[�ՃVQ�%��8O��W�3vH ��zj/��ն��!4�6P�$efY���]���v�_��i�i̊�B*)�0�l�ܿ�7�������8vyǃ��PnBT�!2��;���\%�����_`p�� '�>B8g�W����v �P�a�5^��w���6�%�    Z���:����DV�5���r.m�P�$���x7�~� #�H8,�����1�m�J4�Z�'�S��D�a�5~z}�F(rxg�Om�L)l�P4��	]{��\ �|�&L�yTi`���q��>`�6�%B۬	�м�Z\��WC��4�O�30͚��̫7Ϯ����&��Id�Y\��� ���l�f�͎tNM��&�Ą���h۷	��I>Z3�h?|�����X%^�0>���Lk3�������|�y�iM�>� 6|F��;�ẏ~Z'��i�-�J��Z��Fh��D^`�5Ѵ|j��P-�D_�5�N_��J�Zw|��}B���Vk�%hR��Dd�5CDUB��:ͫ�`|���� J��b��_�{�I 㓈�㚘�ec��X^�v���Pu��̻&u�ߴ\>���	`|�B�Ij6\[��VgK�dj�!(%�^��Ҕ!_=���y��'�hr�H��'��Kd �^��G�ٿ���%� ׯI���9rHs�[T��["���4^��r�S!�1J�_|<z�b�9
�c0N�J�lxWc ��g.�����u�`���+�4ݸo7���e%�e���*���ܪ|~(?�7�!���l������m�m�����6C8�ߡ' �O�P�_���������	���k;��M�W�k��@�,쾶�-����O�:6_۹6���` �'�{o; ����`t��p�ڎE�y��l֛�;
������T�L�0�ڬ�[3a����8[�́�n�F�ٰ |hj��<���c?����)�VT�4�����N��w�=}&�(�()�p�Z8~˵�=Y^��PqN�-D))�0[ջ��|�fnmʚa:A �J�$�6��MΚ����l 2I���*��]�-o����~����m�/�.�w�w�=�f��Ͳ�a�Uߞ�߬Η<1 ��6��[U�.�F�72��تf���V��� QI
>��V�;�~=����O�ܮ�����lU��,��@|���̆W�K�i�XD��+��]R����.z�AԌ�5�>���l�%lx�/~��,斝$��%�#��V��Ď�����l��I�@B�蠅�j7��6l�K�ࠅ���!����z�F_�V"�S���;��|�67�_�}�!��R�E�;0�Zn�K#���KwM g��l��ۀ9�꺖 g�(�������pB���l�S���4#'wd$Iak����iw����	��)�]��ó�T͑mt� �+QB������Vߘ�8�X��0[�����u�Djݲ0fQk�bk�l����-��1]=�#�D��*��ƃʿ�Z��;&��IT
�bk"#�S2ݐI�	�bk#0S2ӐI��bk��W�ߖW� ���$2c����e�p.���Wl��r���9�Dd`,�֌�^�(͙$�g�����aj����X f#k�cl�#O���^@������ٸ��l,]{��58�-�;L��#�v^@������
�?���ȏ`=h�M�&�\�{��r��� ��B���j������%�%5 |�ֱ��0�;�	+L�@)��`G�NO)�t��@|�	#�u�&��}}��MRaC����%�#��P 0�OR$aE��nE�y�^.됇�U}� [�k?�鴎x�F<����ٺ���;���*)�0%[?�UR+l�J^��-V�￫G�&I�ױ�]������ ��h
��֫r�R�Y�@�\�،�����6�}��d�����StQ�P�5z�p���jr�%�*ʜ�[ogo����!������ϓ����\ud.6�G�K�~X�5�	�z7{�������lD�����sJ4>d������:?lϗ�ȿ}��w���d�C��b�|�������摝 `��RB��qJ�n���G�+N���Z�
��i��5rVZmV�e���"�K*-��m�fwCd滁ҩ�p�0�_�-�ެ�M����dԄT[}�8+��D�
�
z���Q���p�S	+�)���W˛>CQ��x-�D,j���l��]�O���-O���$�|�6��`N�knO�B@eU6�*��gg(�3j^��zq��h=I #���`\�!��??l��������D ��a�R�_�v~J]���>1J�m[��mH����
z7,�c�_��U�t�¼lc7˥㏱p�=�qus������Zd�[�����l��}9��ڄ��|<۬�)�V�ai��<�wf�*L���G5��{/����F�hΕe���|oX����u\��������j񘫿�����`���C��OԀ���F�}���o��mWw�'A?�g_G=G �J��0A��w�j�)bI�fh�.bՙ����/��X>c?��D�E�h�����y�#?���$�E9ʕ���~�PR��m�j�OJ�+��6iN>�'ɦ�?�d8�'������M��	ߜ�KDxʠW�{~���Y�u`v��ٙ7�[�_�O�������j}��h`� �LТ4n�I�H}}�0:QV������|�;��u�����QdvQƂ�X����]�00Jd�g��L�/�v��<f�W�9�]��r���v_���'��u�?�|�e����q�m߬�sRO0
������8}V�ث��囦�?�z0�][�H'(�Nh�o��"�����ln�l-�@`�R7��w�|2�Yvx;Z,"Ayt�A�|�}(��&0�yy}��D����<�xʒ�d��������?]���Kn��C
�dF�����~�x�r}��b��L�2eQ�n-�����}��cIF2I�����3�/�!�Eqp5��N��,���GI	����Q�P�
x���l��#�˯�L_�6b����Qhײ��Nu�ئc���?V�:V&�����r�� ?��9�К���X�3�������n�4�b�_�P
��D@Qr��|�L�|>Q����4^���7�W����>7J�I
�D;�vv�!���fi+F J��f��7͠���b�.���P%Fg����nN���c-]�CK~[����Hֳj��B�rwu~�x�O�S��(�Lӳ�v���o7�-6gs�B�I�>��.z�܅��'��n�]�o�]0����{��K28��N����=�F֟@�� ��h���W�'��r�Z&Ov1�L@�(&��N�]��n}��yϊ����Ocl��m�r?TM�]��z	�7�z��S�NWJ@����G�">���@�e�Y�� i�^���q/6�D֝��{ڼ�MHT.kgv�ai�?Q���B/�X�����:�0�Z�.�&�v� b�x(a�t߯rߍ����jEy�UKz��(�c[O�b'�8%�QX����3�3(��	���;v� �}R(\�o�����c}��?�:����[�>$J�3S+K�)��ϲ����׹�7þ)|���l2�кˍ��z~+28ر��i��S��+�SnhW���')A�d;�/3��I醯
������,����C(t��o���^<M�҄MR`��v�֋�n�~�,M@!��������7�<���2I�'�Y_/n]�6{RK ��:�0e;�����������#���'oP0�/(��F�Ύ_-��0K0�����w�q| 
��I��c������^��B@���|����!�X�W�N�x���+����S���S���$�0J�l�tX��I�ɟ'��Jdm�LcC�yZ��K�PH?�>ꨳ6$�������s�pP8?-B�97�t�\{�>g�Ok�G8�E�oq��n�-�y�P�G8!I.lq�L�<'���:�N萋S�\a��1	(��V��PB�\ڕo�����B�i-�)�(k��������Z�=�_,6�"�~�	��A�^��v>_���d�Ɯ�u�^��#4�띌zʨ��C���<�K���ܻ�
{A?�|����C�����M��� C  	 �OW(� y���Y��#D��:�#�P �����ۥ��~�N�)$ȇ=�~J�GRI���qi7}���z%�
L܈b�;u�|4>��R��ۅn��r�<�����m���y�M��'��%���L�ޑ�~Ϯa%g=S�v�U"Kpq��c=�h�g�y�W_��搹��C��&���;A@��f�S`Ť�9����[ J�;�8��QH@����w��|��r�h�዇X��aB��� v���n��hџ�������VX=t�GfE�r}����o`� ��`�vY�~���m�qI}���l�-��뇓+
�N��%�ߎ7)���\��r�`��*
~o�k��_u2�"u2�0J*(8�]���I_��[�Y��pw���[��pz���=�����/��\ܲO�� v���[���ĭ�F(�4x���g��� #�(<�.����6�%�ϷK����uL ��(��.m}���(7�H���nA�_��#���fP.O�V��.�O`� �0��]����[��G����.�)�Vv��P4����������h����\\�4����[Q�~p�O�|�!E~�ޏ�U�2�2��R�/�vu���o�G� �0I$	�o�b�~e�7�_,E@���,�.��?�D����]w�s	�����s�z����+�;vL ���A=��Õ�sy��}�ZA���W�������}>�?G���;�}�����猧����%�����!xh�8K�wW���;E@��[��K�Ino�3!�o��g���9B2T���SP�=��>�F�f���|����E��a��Q�_.�gK� ����q [��#�I7���T���a��r��q+��q+����81��8�@�<�Y3�[�n�G�!E �4<<�>�֛Bԯ�8�	ZFr����|�������wY�~yd0���I�1L�>7��Mס�5�_�s�z��YmI˕�o��e`�o���m�~Y�)��]��:]��(�}�
��0B�r�}�QuG��TR��^��~̆���)�̽
ۜ�(�� *�D%�2��q��i�b�	�r���I�?�A%5.L�^wۤq�Ac�)�:yͽV;T��ATR�*�j�ޕs�4�z�)�Cx̽6ۜ��F���f��^�P"���E1N��I��-r�\�x.5���z�}��HFt<,�^�Т�t�d]ǳ�dT��3��1�GnZF㔈�^����dT����-
���sJ��oovi�mH	��-��ۛZ�3���"^F%b{�7;��� ��pw{�C��4%��$��7;�(N��i��u����f��i�bx�"1�xx���%Ev��y�)��ۛR���nk4 �T�Ept{��ad�R�� *�D�`��v�i5y�=PI%j/���[Fm��*�D�`��v�uS	����#�P#�C����zNz�����B��9�%$M��H���)�������e�p�����B���Q���Լ^�"����.E�SE���r�#�P$�C�\#HTN� ����.A��J*$���!H�ɻTN�����=J�z-5YW"G�{{�C���d���9��ۻ]r4�����f%r��w��f%j��w;���Iӳ*�D����n�i��PI%j÷w;��>�v%b÷w;�(�l��.�F5��ۻ�j�j�J���,���P���M@���\�����i�4�用����6�ȸ��H���8�E�!9'�"����2�~N�>��(|���j�Io_�)"ؾ���,���d��Id�o�wȐ�S�f��It�o�w5��I�*�D�`��~����e��IT�ov��
���*�D�`��aW'-L��SJT^ovu�T��%��J�^ov)��v"o�y����î����M�5��H<�>쐢��P9%R�������7^"F0y�������ݼ]����îF�6����U�F0u����N�/6� ����G� E�k.o�|�����}��o}r��|�����<���-�N�i`�������h�>	����w������@���\0e����s5y�TBI����]^���$��I�,��}�[6*��������.�����H'�c���7A��O��&�S4�
��o�k;4yD*�D_`��Mp��O�O(�}\[u�A@�(�Ӿ	�����&t}�[�'�/�!�~@�Jn�\���I�@@�����>q}	�(��TB���3��'�'�8�}����?��)��>5
���EM��h���u�~驠M������'�&�/�R��i�L+x�V�� �t�L�4z�x��)З �t�l�a��9iPH&H�ҡ���塕��h�Q:t�O�	�%���H��j�m����]l��8��o'�0A�.mW=��"�h�:(..��>`7}@���W5-�-쒙� �sP\[�$�P�$��sPJ[$���m�G��I@%��?x��r���6>���)���5��L��LNx��j/z��z򀒙� Cs���/���r3H��YZ����.�D��!��F��8�'�az�Lnu���h%�N搛]#��g�4���s���AwG�3jFIᇉ9���`㌆��QҲ��9��W͛��!�PJ�00������7/���O"p0/����/5M_�VƑ(��!7�j֜��� $	�-�$g]� h(%��r���)�d�"��������Q� p,�4'�ŮUr�U%Cv�`���4�:i;�H ^�`���V �D �T�6�aʸ�s$ �r0�y�j�VՔQ"p)�D^�6瘭�(��d�G��_�?-�w�      �      x���Q�[9�����*jN���k���cX��4��< �������Y}�X����D~����g�����k9_'2��Xߪ�wG����Q�k���y����//��''��{��>k�??��g��k��g��ԏ�|E�|�ϣ����<�?V~�:��~����/��ys_��]�;�>�}�m~ݎ���wr���//���W|����=Z������?��=?�|Վ�����ѝ��ܿ?��W���~�֏|_Ƿ�������Yߣ�\�Gݿ��_���&��C�}*~�}O��{��ug}۟���.�/,^^H^(^ؼ�M.nrq���n2���&��n2���&��n2���&��Ln2���&��Ln2���&��,n����&��,n����&��,n����Mnnrs�������&77����Mnn����&��ln����&��ln����&��nr���&��nr�I�{�p��Mn�p���<���&7y���Mn�p�������&/7y���M^n�r�����d���h���&��M�G��6��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8͎��8��$;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��4;N��;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;ΰ�;�$7Ɏ3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8Î3�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�M��v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q;�a�9�8���v�Îs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs��dǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���\v�ˎs�q.;�eǹ�8���CΛ�*߄f�&��7�a�	-�Mh�oB�|��:�tބ�ɨ�&�Nf�7�u2�	��i�Mx��;o��d�y^'ϛ�:�xބ����&�Nf�7�u2��	����Mx��=o��d�y^'�ϛ�:�|ބ����&�Nf�7�u2��	����Mx��?o��d�y^'Л�:��ބ���&�Nf�7�u2�	��)�Mx��Ao��dz^'�Л�:��ބ��(�&�Nf�7�u2�	��i�Mx��Co��dz^'ћ�:��ބ��H�&�Nf�7�u2�	����Mp�˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+���nE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+
��p+��:݊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(܊­(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊ҭ(݊2�N��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+J��t+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��r+*��J�ӭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊ʭ�܊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V���t��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡg;�l���гz�C�v��=ۡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�zڡ�z:�N���v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��q+��I�ӭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt��t+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ����Vt܊�[�q+:nEǭ�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�]���Vt݊�[�u+�nE׭�   ]���Vt݊�[�e+�[ћ�:߄��&��7�u�	��Mh�oB�|Z��:يބ��V�&�N��7�u��	����Mx�lE���V��y�lE���V��y�lE���V�&�N��7�u��	����Mx�lEo��d+z^'[ћ�:يބ��V�&�N��7�u��	����Mx�lEo��d+z^'[ћ�:يބ��V�&�N��7�u��	����Mx�lEo��d+z^'[ћ�:يބ��V�&�N��7�u��	����Mx�lEo��d+z^'[ћ�:يބ��V�&�N��7�u��	�s�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE?p­h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���V�܊�[�r+ZnE˭h�-���VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�VnE�^�[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q���V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�V�nE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VTnE�VT�u��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[Q��[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊vz�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m���V�݊�[�v+�nEۭh�m��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+j��v+��:݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭ�݊ڭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh܊ƭh؊����۷��p)&      �      x������ � �      �   �   x����	1г]�6�F��e��T���%�!�t����l:�����$?���x%��`J��0�Dcxg��$i>����=��d�+B�����.�x8Jn'��W՗:0���P�r���M'�����{��<�      �   M   x�3�t��O)�4202�50�52U0��21�21ֳ00661���(�O)��2�N-*�LN%��'�21/1�+F��� xB      �      x��ۻ+IEAy���XY��[�;�-X%��� ��3���E��;G�'��x�����[�������ĕ}�������l�4??�����}?�]���Uw��c��.����ª�O���ª�.����ª�Vݵ�Uw�:���k�]��Zuת�V]ZuiեU�V]ZuiեU�V]ZuiՕUWV]YueՕUWV]YueՕUWV][umյU�V][umյU�V][umՍU7V�XucՍU7V�Xu��Q�U7Vݳ�U���g�=��YuϪ{Vݳ�U�V�ZukխU�V�ZukխU�V�Ru����G�����U�?��T]�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D�M��D.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B.��B�R�p��p��p��p��p��p��p��p��p��p��pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa�pa���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1���1�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��g6��&���3�xf�l�M<��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X��5�X���3����ݷ��=���)�oO�}{���S}ߞ���؟1ŷ��*�=�gT���?Êo��W|{�����cF��3���؟�ŷ��.�=�gt���?Ëo��_|{�� ��cF��3���؟1Ʒ��2�=�g����?Ìo��g|{��@��cF��3���؟�Ʒ��6�=�g����?Ío��o|{�π��cF��3���؟1Ƿ��:�=�g����?Îo��w|{�����cF��3���؟�Ƿ��>�=�g����?Ïo��|{����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8�����q�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E����#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?�#�?���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?
���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?���?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?��<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?��C�x���<����?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�c�?�g�����oO�}{���Sߞ����߷���=����?�o���|{�����c���3���؟��w���?��g��?����|'�����c���3���؟�Ƿ���?�=�g����?�o���|{�����c���3���؟�Ƿ���?�=�g����?�o���|{�����c���3���؟�Ƿ���?�=�g����?�o���|{�����c�� �  �3���؟�Ƿ���?�=�g����?�o���|{�����c���3�����A�8�����q�?��A�8�����q�?��A�8�����q�?��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8���_�~q�/��A�8��"�/�"�/�"�/�"�/�"�/�"�/�"�/�"�/�"�/�"�/�"�/�"�/���@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@��@�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\��q�?.��E�����\�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�D�H�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�B�(�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�F�h�A��A��A��A��A��A��A��A��A��A��A��A��A��A��A��A��A��A��1���?����ާ      �   �   x���K
�0����@�<�D��Z�����9L��ԩ��L~>�G�H����CІJ?���y��4/�@������=ףco���Q�L����&M@�8h�����I�e{��h�nzYo��~�n�1�ΥS�      �   �   x���K
� ���)�@d:w��jm���5��@m)�Y��|��0C�v��1�����;a���k�@p����ô�S����^Y��1qt�J�DJ5`�ͼ�mXZ����|7��CaU�hX��2�y5�-Cy���PВ&�ةD�����þ�3����^�      �   �   x����� �sy
^ �R�\o:M�E�y��?�lz �03)�C��i�X��"p���:����Ԏ�Zcŧ�`m������-�o�)�����TȀv/H�,��f%�� ��9��@�9r�6?(��@�ۄ�)Ȩ����	�l�_`��h�ط�����      �   �   x���Kn�0�s
_ �<2�;�FbUB���9긴B0BQ�g��L>9�n��� �ח����iO�ԩ��2�:O�Cm]�ւ����H.�!%!��������n^���Q�hq�j��S&����\DC������'�oޘb2�f*�A!fI���`�7���-o�hWp~�(DLQu�l�:Ă���Մ�_��g�K�z�S� ��ݐ
Of�¯��o+8�      �      x������ � �      �      x������ � �      �   8  x�=�Y��*�Ӄ�u� �s����L�>.��C`K�j6/�֕��{1����1}����1��f�Bv�r!�x>����}�z�zY���e�����/���]�)/���S8�S9��r�ۉM���+�+�$�$\J���8)�ʥǥ�J�@��j1�J�re�g�g+�
�3)����BC����fZ$Tb��P��S=�����N��N��.}��|�Y���T��vS�f��JN՚�5Uk�*+UVz^����Iqu��Y����������$$RL�������j��7�"Ke�NWj)�R�p�����T!�B�oh���EV�[-�z��qRί]�~m��/�o������k���~NPN �p�����l��%r�>�q���K�,-�t��g��E -��Z�V߰�[`��j���N�(-@Z`��h��Z�
`��A����qV��@Y�cľ�e���/+_�ͽo�ø�g�������1c2"�;qzrzrzrzrzR�� 5H�bD�F�F��R+�wh
#�:��ޑ��N�i���S,�X���&��b!�B����'�qz��w�)�H��vr�t�T</�K�R��#�+����1F������?�)�"6�.ĻY�ˇk�n'6kO �)�S�0Na��8��>�h�]���SP��NA��:u
�=��������<��ˣ������o��~�Nj3΄\�&+������h��^�{i���ǿ���K;��;��������˚����ۉ�r0.F��G��n�$�T4�0�|c���H����&r��-�[ �8�<�a7޿~{�0|J���!����=���w����k_V�{M�~���;��S��o�fƛ���eͫ5o�Ĳ>��Aޡ�kۋ���6�m0��֛��3���ŒPII��t`��EJ�|�zY����,#�M����@���Ӈ�.!���0�Pl����%�%��`F��A1DI����"�Q�!.B\��"�a��b&JqCX¨@�
tOʵ���x+ފ/ŗr�c��3�fh�О�N�U\��6�F�8�q� ��F|*��Gã���hl44�FB�q�0h4��=�ϋԋԋԋ�˛�_{��o�o��#�m�k��)����ږ����m�k��+���n�+ٓ����׮m��$�^/��O��T����h]�ˮ���4{�z�v�+Y����&ڿ����M�]��Fh�G(	�@t�U�i{���_��m��$ ��w��;X� ��s`�9� ��o�����"[`�ka-���Ѻ�~��~�ښ}5�6w�V��X"�>槳�"^��w�.��X�"]��sa.���"\��o�-����"[`�k<������H�'�4y��3���0�\F�]�<!�.��
�b|��AUU�aUW��U ��V�����_�~����N_x}�;����_�I�N�\�G#�����߬_�_����+���)�)�#��aH�~�+��j*,���/,���/,���/,���/,�ª/L�aΌg�?`��Fk�5�*�U���W��`�
��+AV���Y��h%�J��X�K�h����m�$�iìa�кjQ%�CU�U��S}jO�;U��T�zSm�h0G�A�A��� ��H���H���H�H���H���H�|��b��yB��
VFRFNFJFFFBF>�ٟ�5#3#1#/�H���PIlJ����D�$BA���H���H���|#RD�4Ƿ�)"T���Ħ$6%�H"T�Қ N<8��ă�I�J�9��$��xN�3H�G�G�G�G�˶�v�6�t�A�t�A�'{D
�I<'�:l�'�'�m:��c	�n�n(��������Fm�&9�� �O��B�6�J)�i�����PzC��?H~��Ǟ��iHMcj
�4���5��i`M#+6�	Y���Y&�iTM�j=�������0���0���0��1��1��&1��3�FŰ;��=���ȅH�ȄH�ȃH�ȂH�ȁH�ȀH��H�~x�7� ղ�c��� �$H
� )@R�N�$H
� )@R�R�T����$; �0`
��) S � L��g�M	� ���5,U&�X�����w�a�9KG+�9Z��[��������x&�FÏ��������]��Y˔�L���_�~���_�~%��+.F�J����S��?Ni�ق�L�u2w9����_ܕ�+aT�RM�"$/B�"�/B�"$0B#�0B��ͬ0Zض/آ�}϶�h��u[� n_�}�w	w�����b�l#e)�H��.�Σ�S�Z�����+R����O�j0m֚���ok_�O��a�.ʹ<MX�3��,���ּ��B-�Z
�j)�R���S���➪'�K��P=�zh���l���l���l��.�l��>�l��N�+��N �`�]�a$��a@�B9�p���!�C���X�:����nBo]��R�+N"N�C��3�Vi��R+�C�4���Ը������6K�,M���:��6�CO��3A�FF{FwFsFoFkFEEE�D�D�DD{D�aaa�`�@���M��$mO��$mO��$mO��$mOҺv뛭s���:W�\�s���:W[��~[���~[�[�%[�E[ѷ%}[ӷE}[շe}[׷�}[ͷ�|[Ϸ}[��%z[��Ez[��ez[���z[���z[��%i[���R[*��h��[�h�X�+�6E�q����o[�m]�u��E[m]����7[�l}�;�/���c��{؏�/`����M��� QAR&ա7`^�%���^�y�XR�{�ԋI��ԇIy�gI
��;�$�&��(o��~�;�&9"I�Cy%_��wJ��[/m��9w_�n3�6�D�^�i-���ln27�����&r�i�,n7�����&p����m�6w����&n�i۬m�6g����&l���lm�6W����&j�i�s�����������K̦�f;�|����#�4��ɄM"4�4���t�C��A�7=��  ����[\7�N㫍�
Q*@ŧ�l�����3���U�6>�X���ߚ[��ҳ��l�5�[��R����'�l|��Ɇ!lꌦ�h�\�M�jn��&�5ׂͭ���F�i�����)�����޾�ek���ᴑ�Ц�hymx*--�,�,�,�V�Ka�F�a�6��`8ՀS8հ(�&�����������z�r�j�*��l�%�i-�����Z�R�0l6��	�aðQ�3���샡���&W-e�R-��R"--�Ҕ���4��)5M���הf�4���5ͬifM������GJs�Y7ͺi�M�n�uӬ�f�4�|ZJ��98��iNsp�����`�O����.�٥wv���P�;���.��S�8����E�����ri�]������i�a���;������l�vB�����l!����������"5�ܘ(�"(�"(�H達H達H達
�� �� �� �� I鑔�葉��{��`{��{��{���������������������$�б�б/{���g��/y�&hl��&hl��&hl��&hl��&h����#4Gh��19�pD���#
G����7�o���~#�F���7nd.G�rd.G�r���#G0�`�8�o��H/���H/���H(���X,���X3�5�X3���H�<�H�L�H�\�H�l�H��H�,�H�<�H�L�H���\Z�9v>/뎚�^T���[����~�R�+�M�Zڅ������g���      �   �   x���[j�0E�5��T4���YK�L\�ITc��*ą��8w�\T�yOYm��i�5;È5�~��&ǪQ�Kj��Z�,SZ�&�=���JY��ܠ.m^gI�AmBG��5H{ɳ̒��\�jk:B&br5hww*�l�J��=��;��ץ�����5�{��}�1@I����MY��`�3�qz�G[��N����7 ����      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x��X�j1}��b�F3����M򒤦�
!�'���8�6�����~[�Y�ftt΂3����~������_nn�3?O^�� �]�T�[&�٠4g���ߗw�9;����d35� ?��P�r�P����#���n����x��7��s|r~�����K��^���B�� �`�B��A����ܼ��K�± /;4�ll��&�z\
�%2a����l����ќ}�1���� �����u��f�el�>6֮5��b��֞)��T��S�lY#Q� ��P�iH"S�m��?l���A�A*��G�V���U4����Ċ�D��̃���4]�z��ʠ�2�
�p���[O8�6ꥬUtp�E�jΪ�MR���*��c�"��F7r��4�k��1�)f�����g����q�cyL��I��*6��E�Q[u��Q�qm�p�
p�|�	�k�;���P@��;U�����9���7�tu�N��r�x�@V%�7�=c�KLC��It�^�#0#�$O�O�t��^�:�qq`9=O�����������~�:e�K-h_]Ƅ:xK"BT���fD6�QsMQY��
4�1���'M���t�E��L�Bh΃!tn6�I��x�(@�������$2���O���RT&3j��I����/��Vj$�7|��X�T���tR���n��椳�nl_:�m�A��n��D+u1/����y8�7�������-p�<�Fk���#M_RH��3��8��tm�&ҵ�#B]�D�Z�9�>9�Wάt��iv��1TZ�v�M\Km�8�ϰ���oh��I�bff1�ywM�����y����]����v���ۿM�a�0�9��si��[c��      �   X   x�3202�50�54�42�9��*�Ks��srR�K2�rRR�r8}�\�8���9s�����3�K�
�ҹb���� ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-�����s˒$G��s���/]@�����6��p~V�C��ί��$��l�Kd��_�L`�M�D��*&d�,.7(wm(�_���h��P�l8���
�~�J��t�ø�*�<�6�{�����:���#u�}Hw��]�3t탑�!�C�Cr�j}H_>�2hs�.��c���ڰ���v��(�4;�?�a��/�^��[E>�����ֳ��*�����-�Yn� Q{�z����ޒ2��g�-FL��������?e�U�}ϭ����Ʊ�p��>�CF��g]�-z�S^mxK���(�_���N��s�cj�-��(+*j�+E�#���}��!#�ů�O{������2�^2����i���4�s�(fnmO��I�ES�UZ�%����Ke�E�xM��[!�"'��F�B��n!�>0d���dBF�p��a���&�0y ��0��g�[:K�c�t����A.��C��
6����u)p�|s�kh,��AC>P�K�S/͟�a(��?b��-�Җ�V�G̰�������K�ҭ|�
2�����QԚ9��545��pޭ�U�^�l���yzf�L{�A�7 ��/`���­u����iK^ۼ��b�qԏo����c����"�3b,����!۫�:C>,!X��qw��%�@����.�hM�kEI�vw��e�(��6�g�y�-y���0W�M����M{�E��ܾ�����Suvo�`�VF�>���vn#%�=�=�6#,y o�y����H	&ꀡ!����N0lc�d����Jo1�����+�h�\�#�;�����m����8q�t�އGc����#O��>P�C4�Q�ǅ�jE�5	6�����Q0(^�#�d�ߏ�_H/6��M�oq�.[�:-[E������O[�_�j]h��)h�@��`N�����I�/�l�я9��4��IyeDJ����7��wH��<�H��w汼p�0Z�!��1�+��M���l�=V�= }:���p�Нm&\���P�>dNȈςz�u+�1�_x��g+cF����]��=�֦��0H�2�-�lE�o�A�v��s>d�L���"���Q��5��+����?��G�5�%y�1�

�����O�^25�f�+�۲�%��0����##��(��:^c��i�F�z��i�T��^�c3`��>"�T�]���s/Xv3!����C���k�D#Ɣ�C�����23,3b�&�UڢW}}��%bn`Pv�5���    ���'�� ���:0��}qA��,�~�7����R�5�۳䁴��[6K��7�2w� �c]1<%�"4����DhP��r+�-`�BW���c�[�-�bp�/���@�V�G
.���~�#��>�=fy�~j��-_�J��Xם�=MO�䷘�j�<�����zC��nY�i+�[Ohe �E]�6D%�5|�H�[�_oy,MG�TIEڞ&��:b���a��d�@��ܶ�����dՀ!���ں/��=�$tF���3fO�����D�u!����ʽ�Ɠ .��۬�{�s�Y����m�l@Ͻ��"fX����j�lG�b&q�/_�=k�oe���������O
���;��CR���Z|�jhӛ1�R=�7��N�x�\����*L�4�����~��Ny0m7e�A��!�wS�CY�2}�7�aGʲ(,�es�7OhL��%0.�FPn��F�i���v���3R�(��R���j)ö�����@��y�c�M�Ջ=U�<b0|�7�u��[-5bԲ�U�nO���'̲zc�����ZZĘ�K����ieg-����?Z/m3|��j������-R�0�}����D�r�����
�X��e�G�XK��޾���4$|�H]�9��G�E"F-��8p��
�0"���f"�ӫEj�)Ҿ-�T*3:$�t�!�<\Z��ox~R��K{*���-���4�5/�P�R�ł�p���=��Q7��JVO��%NW���_�§��QL�=eb��t��6��Z��Z��{/FA��ϒ��±m��wX�v�+�(�C���ҩN��%�)h��D4_��%�9ah_���%�!j-Ӯ�ۼU�tɗ��!�ۘt�^�5~�fzbJ"�NM�C�1�U��c��Z[� �2��L����/�f��C���#�1˳�H���j�Ӭ��h~� 1Wχ���[��ʇh?U�$.w��+◱�Ix�)_9Fid;��w��+�(CE'{C�*fƻ�5��"&^���e��7F�jq=��!+�_o/J[n�:%]���$��4��Q���w�f̃�!�0��N��BM��_��<�S����M?QP���4��FAK���T��綷D�Bjz$����1f�+�/�Z�}#oJ��z�(�p���q���Jw��)���<,��,
cK.���A�{���}e�(FW�/�y�B�7%���m�%C=��/~�=��]��j6��H�2�K�����(7�{I=�%CH�[��z���;(��ؒC8^�qK�zP��#�bS���k��|�Ė1:@E���+�<Nm^{jЫ�y���4lP����y���;��Z�%�]��G5��^>���+�;�|��;9`:���4�����5P��Z�'��)��nR���/B?�p�~��G/L���?�l0}[G��N-m]:a���)$����i��ļSg[�{}OA$U����� ]3��u��?�̤ת�D"�s���Jf�/��I��5��-XȘ��<&�`=a�:�H�^�j�0M�~���<,�#�=}��l�ꁲ6�d@B�ַ?��Q.꺕)o��^s�~f�@!o}�v&ｫ^-�$�����|իE��)���[��+�l0EL5E�n�L�^���K>��^k�-��Q,0R����_V���=������o��^^ƪ2�o
%s>��?��,�w~��uQ�쯴���a�w�k���1gk��o����֗u;�����(]�n/�+��lp��E����t8���.�|�e��䋷Q�ش7f�* �e8k㈱�*�y}<J'��F���"T7L6O��&cjS\1��c�kb��݊奍��7�`k��K�o��{�n��2��g�=঑b�0�\u`���.���逽1	����] ���aD�q��xX�3`��tu0o~�ȓԷL}�l�ä	���ڳ�y��g�Q.�Y{\|?�h�Vݞ&O�|�(K�c�d�A���-e�^��PG�x���Ml�`�N|S�\���@���r_f��P���(C�;)/�<Aң�@Q"��K���y�]<�3w�`�6\��9�x�M�D��MP�t��q@����r�>Rn�{���6݁�{�\����
������R���c̶=M� ���Q������� M�F�)��k�l�t�CH(oO�k�?7���o��0=M�u	&��eǑvr��#8q˺�y	 �{�jߍ[�'�t�D��l|��8���C���KYZ󡢇߁�6%2|I��@�n�5���Q����P�"��ų�� A�L��X����M<&�-�ᐙ�_��� 
��&�N37��"�F^�*��q��>̀7��ݫ�+��G�%N�ތn�&���Dc)$a#�0Dܑ�̯uAg��;m�8Q�vG?�T�>��8
)�eǝ8��柝�_
FA���y�q��Q�ƙ�����66�T��D�E���`{�Ð���j;�{I��)1�|�4c�&��@AE��v�K(�@ѫTk���d?�i��kW9﷋'����J���o�y"xî�Pyh��)���=e����<%��(~�ƾqM��O��p:�5�/� h��k�[	7��wLä@h���Q~ΐQ�b?� ��7�v(����l_F�;��w��.�e�@)���~|���?���]S#x�͢�(�*�Gn��=P��|C�wk�r������������C��@�9şj����S�Z\�j�_���Z�k�Zn�d`�h�!b\|+$��R�7�mY���q:��τb���϶F��Q����V\�Y���*��/�H�J^֟s��{Ao�jq�yk������˺qpy[�X'�R�pC�49�o)H�w�.YO[�n)6aPayS��g�dY�~Pڢ_��u4e�`�/l?ѺO�N�h�B���r�����B�ջ��4���{�@�5F8b-�v�L3�^='�86S�|�#��ͣ��� ݚm���+Ἱ���n9����nO�G�n1���oz�w�U��]۸���~�-�">�Ŝ�`ր!xX�L��!��3b�-���I�l�}s^�0J��L�";����c���V�|��ck#���hc5*�7ۗʽ���ltmm�U�!�6(P0魾:*���x�;`�����6~p��%�{���7�!�v�Y@Y�݆yX����U��A������n�/�:��,~S����e�T�VOyX�#R�5�N}�犗��������Coݐ���/����5l��	F?1�iU?�Lȧ��1#f��u]�i_3�jk�0�<$�V��`��ϤFJC)x��e�����[��������*qw�`������H*�Z%�uZ��z����R�F k2m��-���O�]��2�>|��~ߩ��C;kת��%R^C��9���f�}�~>S�4���� bb څ�炗���MBΛR����7ZWmG�W�~0]�>_�Qɧߝ }(�@�~�t�i1��Sh�A���=�"/���C[݁Bc9�n�h*�R%~��ۀ���5M����;�r�f�*��!�v���7A�y�����$�Ҷ��L5߫�]M^$���!��n���v��m�1	2��������C��P�I;�;�b걭�Q��%s]?�E:CG:��mZ8�E �M�9@���#T��IS�=�]�я̙��9@;4F��~��%k���	bBGh�k�qx����w�k���Th�6�/m���._O�#�>����<�O�r4sy��j�\��zA�!%V�ш�m����?0�����&��00ae=L�"ӛ��ņ�ƾ��JF�/�
:훃�Qj�~yA�9SP��~�5�o�u�(;�����n��ߣF��Y�\䅁��r��#��;��K��/?;��r��!k��c��;j����#[�+_����nO��Y�C��M��x�F�4�+�;=&�sn1�����4�*[�ߜ���������OBl�M�c$^���\Z�T����}�j�Y��B�ޙ�v�ҟ.w��Vp���҄I�́�v���'Z���6H|�R����a��Sxݥ��Dy��@Y'    ��:Z. p����)�~R:"sԜn�����"���0��;�^׆є>�f�z^��E/��ik���t�R�L��*y��:F>/<��b�,�V4���&g�����H6$B2ۛ���Y"F���\8=O����Ư~u�S�e9P�-nL�%s�:k�t�~D,�[�|0^�-blf M*^�m<��0��G>��16��N��'�W�i�P>��qL�ˌ�-��p^=&�M��"��n�)_�1�T�pS�=�����]I&���2���z�ip~�(�S�E�F>/�Cl;oW�c�Ӊ
'
Գ�S�i�o՟�|�Ɲ
O�����3B��:ڶ�����p�Pk���#�W�D̰��Nx��М75b�f:͹����h}!o����>?8F���wؑ-8
\u��o��/���9R��e�&��l�t Ӊ��a�?K{g�J����������-�>�=��o��I�u�(��-lV��~*��#�<(c��F0����.��R��H�!1�5��>�oJx���W[O�d��C^0��Fi�b��!N���׺�����%��(W�0�/��.�{L[W�u��>��M�J�	��JI����e��ep��i�O��:G��r:��م�6�x�Ȼ�����}h�;P�R�,���b�&ӵ�\���E�L�!���\p�L��a:#o�k�
.�k�5F��{�� ��Oj�EL�*ie���e��#���g�:J����'���v�Я��5�D�}P��ox~�~/
�8[�ɛ�����T����1���
J�2�dv�$;f����e��ڎ�͒`8`D^b�qGI=�VF� "�/�Ey�&�S0,��]����<�A �a$�h� ���7�m��y�̈!��M�=Mzkk�L��S'��%���j��j�	\�o��|^�-bL��b�y�ԃ�y�_���uG��o�[�2l�t?�?Lj�O��s��7�f�R�t{5�7U���1��/��u����U��� �l?*u�OY�i_}��ꈘknwa�~T.�y¨�m,��(��-f�~�DՋ[}5�P��\�(5�>�*�b�_s]���8y���0���-�%֞�lo�+�`�A�ϝ��:�[���ܲm���3���A����&���S3.~F���8�i�щ1y�ގ� �vNS�S�:s�Wŕ<�P܈u6Uwq�\3�NnD��������GQK��S���V�Akh>�--��0��6�]ri��ZĨ]V�/_/�� �'��Z�~��wy�7�.~,���r�L˻l���H�|;Q�Mw�K����T2P��_"=m�n�G��J��&�)�0fk��v�tf���|^k�ͬs�h�oG��3������qC��:`x�͆�#�Zs�j4�\�4�?���𣿤�@4t�[S[-��-����2���R�p;A�(tA��p�4�v�,�n�P�=�x��uK�s(����#}`p�]|�_(�ƅ���UP
�����7[�(�R�ي���=P0��|�A�x����Jܻ��
��e�p,y�s�{�`z�{NC���&��&v%��$���5J��Yo����S�r�.!)1}l\`�j:�O�b䊪�S���3�h��.��҃#t�%��P�����V��K<~EE��HU����GeB���]��Jih�:A�^�:�W�]_6���F�;a�d����5/�4 (mMr/�}���4�|�鯊�w�G~+<` �*ۻ�#^J� ��d]7L~+������_�ܰ{EȋB�35���0�dw��Ef@A�כ��#�/7/|xa��Mw[6�j5��a�:"�m�Ol��Q�l^��yX��^Xg3�u�&7�I$�0(h�sj�w�5/�h�+����-���k^�i��œ�Ѷj��zqCUk]�-���R�߻�,�kUO�o�J��+�$o��[�������ٟ���I�|�)J�\F^f/���*g_^������3bz���}��h�Z��m�����p�0a%�o�1��J�	Io�W��M��K��2��F�^�X�azф��dBR����"�牊�!�8�h�������@����x-W���[�{����a��}�y^�>ޯ��6�{�����ǂ��ܒ=3w���Y��3���--�|������7�)��í,�j�kXv�|{'�v�I�9y{7X����𫣣h{�T���Z�`���nx�`E��[`�
�u�>��%��$�M����G�I��4bC<&�.�~Џ�����&�.�bhm��kѵ䋘K��i͂��gFsC�^Ɯ�tvX����Ѻ(˅�����v8�,P�i��J�y~:����y�@��-n*j��7��
�H�Q&���Qr#�񩛅��3���iM��o)k�����9���j�����s� f�q|��"6JB>â5_��/�U\�ڶ�d���wu�������z�U0�ziofr���0P����ۚU�!��1�Rj]�sE���xt@B��(�>��>^C��$�\�Q-���w�(R�O�,��g�(*��j�XwO��#'uI{m�w?'�g���� y}P8%���J�h��%���]/w�3կ����-f��M�I{^����RĆ�V�x��ޝ0����Cr�5RpDU;�C�8���f�%���-����xQP-��ɮ���?��E��k�
�#\ߌ�mu�g���������՝0�����}um��$�L�`���cr�;j�XS�4�"xL�~o1\�6�>�����?,�F�mE�jdA��g��4}��si�@,?#✘�������|��]@�V*�(P7�����DS�=`��q�5��afZ�s���x����
��暰�f��Z�um��D���:���y �
���a}H�	�]/��t�yp�5`�,D���S�\}3�qF�N���׼��DY'���)ߌ'�5�4P&��W��y��9�#�ko���v�2���aπ�� �np��M12[�R"Ɔl�cr�/֑��` ��^����T5�{w�,w������u��4)�umZV����H'��(}�{�7N�/����n��Ȼ��;!�r��&�!91gZ,�w��J3O���(�^�V�)��4ic���b/!��;�#��j�0�X��c�P�0��
9��$�p��J�TlΕ��W8`�
�ׄ����?4��bP�X��U�.�W�]y�J~��+�k��/������M�_���Ϝ2#�j�P��~�i��1KNm?��>�e������o6��۱�&��{L�Bhܘ��J�6��ik>��iܘd.y�4�Nk�>0���/�O��|�]�Yh0ɗ�'���)���GY��\�"�g�wQ 
���+gԼ�.XP��9�S��Y�_tCAmݚ|�iִ�B#���;�'�\���r�t�^�՗�(rq���0��(6��φׇ\���&Ր=a �Ky�!���D��{`J�^��ó��[LGa$Z&w�&��0��,�%�.��^�}>4����@�v�F��b�<��)V�Tw�A�>}��b��0��Ѹ��%�mhQw�䁈[�|UY��S��g�0��.(2K^$KHQ��5��;�o�(8���<�3PȊ����i�����><q�D̰��T��}���in1�%���\"�����
7$2��6!�z���A>���C�rLֶ8B)��Jz,F���Jȝu�1��[_>)W��>2זl�[�h�˱
{֫
Y���Z��<�Z܃���P�ȫ�o�}�������L��Kϖ{2^:FLZx����Ͽmi��L0�c��U�i*�#3�姀�y�0�sU0��[��{�^�F~JfҶ���1����c���֟��arWܫe]�X���^q��jY�!S0 ��o)��G�W�2[,Y���afz.�bj���쬛�7��d�e&+O�C����E|QpԮ��k\�8�/ְQ��֧v�9�)A/�qQL�m���1������L��n��iD���f��n�R6����m�_M�V2�����ӀH/�k����=�,ۻI�p/1�"`�.�Iӂ�    ���U��ґ�J�V�.��c�3�یF�(�SX�;���`�������pu5�!),M��)�f�5-)�X�{
��څ�Q���^���V|P����i�Mhɼ�s�ŭ��ϛ�(\1�����|�	�Ps�N�F���/�H�6�R�8����(d"�ů�|_/#Rl�,
�|�r�	�^$b�&'�9}�rrZQԋF��Te��	�s�=��@��¸K&O3#f��Ӡ���"���=�����egL-Ӭ}v]�6�+�)''e�5b�-v�|	׸��4'�O�m3���5�a�L�@�ä��cm.����-����s����y<Gj�{�[��lJ�xL���k�Rd�J���~沛'��#�?M��"��p�4$r°�/8--�u��dJP�_�o��i@��0ML�TMC��ɥ7?1���A����K�U9QT��홷�EÇ�s�ieeNoH�]zQ��*g.��[��u(o�#iaQ44W�,Է�P�0��Q���t����[���g�&�/�4���*C�����ϥ7{�_[�4�q�{?L��G�]�J��ySӀto16�BUĿ�<)�G����6*{�Wn�H�`��K7M�ʋ�(���E}S�r"��*�VՉ�N�ʇ��4����T�%Z_69��Z>��F�'�/��T�C�N�N��;�7��/e9A~�$���8����l�m��3��[������~CҒ�d�7�5J�|��kV��o檛�}�Zk���&7�ς�1h���=Ӛ�[�]%������wt7�`L��\*�&s�6�ҕ-Jɻ�N���4Wų0��P�Zwҫ]����%_�5>��kݏ߲���͟ ���(���m_�y�.���|���3�-�=&-��>���c�᳾�C�~�-w�":���F� fl����Q�r6������;4�k���ݤ-�wf���lN�����y��H��c+�R�χaˆC��1.���0l�Q�f��!i-r�;%ȥ�b�k.��0���1j�B"���[s�{�@�E����?��0-����C}L�
C���~T>��c����laV�D�o��8տ�����b�7�co��ֈ�6��ϺY�<O&\���҇[�6�����/��������Ss��Qr��>���3S�P������iy���g�E��(h\_��ꞥ�ַ�@鈞�_Ti��������n���	Cs�'����F%b,���Pݞ&�����6
Y �ɭ0��Z�{���A���S��/,exK�s+|�����[���:`x�����<xF�1�nƦ�+u�@C�3�P�@1f��>|F{a� 0q�t�ވ(��@-�8a���(��0�m�(y�F��M��Z�EL�fw'�E��y�P�+A1��:�_6�G h�^�Kk�}ä��1{�^�}a�,�]�͆>d�D����:���tp�	�!I�=M�J0�mo'8m9aFEc���׀a��U���0�)�1�M��n�#禘7��S�.�R:���|3E�龮����G�y�1�x�ښ7y�^���p��F����F�(c�+��	GM}�E��X����2�Ld�Z��z:���`?/
5�$����A`����W��l�9*
K���0�5�ȶ�r��p�#pf��ߔ;û-�(�H�i�
oJL��	��e	�,����[Wl%�|/�f��I8րAm� �ٷH�C�����$�7|��/�^���}u��L�j��h�P�%b*ʓt]~�%,�5b�e����C*n���k���vX����C�xʥ?�W̨¼arG�Y�I��hZ��G����F��ߍ>x�q�t������35�{��p!a}���)¥g%4Ohp\��^;�\`Y��Et��g��jo�����?�p�;(�+��滼���.�iw駙a�r�Z�?TL)�+�VV������*ͦ��/���N��/1�T��@�WB�S���NsN{�!x>�)Ђ�.ރt\�[9P���yg^<n��4`O�!���)�$��ؑ[wy_�=��6�큙�o)��q}W�K���NfH
�!_y�%��4I������ɽUOɽ���"&�(���oT��%�CX��1y�3�u�߻j�K������u��"�o�����.5�}w��Xxsl�&�{�?kMŎ,�na�Z����쒏�՚{^��(H^�Ei������A���iR���%c.��ݎ3�c�˧�8%�g׳-J^q�Oz��K}��y��&����uQg�k/��쾷_'7$p���j�?|`�$��xo;k��(�N��-��^h@M���\'fI{��r|�̶�;QN�-=/�b2�Mt�І�W�W,�0z5�r��`tc&J�'�,�bM�Ƀh^a�0PLFus�^q^�v�Hݔy���m(�ktCq�Rs�����M���`��&%�6�Y�]�=��a�uz��H�52�H��Vst/<�0y=�h�L��Y��� ����m���&�!�/n%J�e�����*]KĠcod�z?�Nw��cZ��H�05R:�h��G�.L^У-b�xN��u��ѴG�05�姑?�)�"��ś��t�R��Ht�����:�"]9blzxcSyr���B�5f>Uo�(�d�D���uu��)ʍ�����ߟ��*��S��l'�z�)yJ�@Y��F�Y�����]�K�n�>4�Sc��/�����#O�YU���Rs���M٭�z����T�}�
�( l��YG���K��~�'J}H�i|/h@����-և4��O�4� �n��Ӯ�hȰv�QK�oF�N�YR:�Zwʦ�8�U2O�����k*g��c/�8h�?��������0�
�-b���������{�؅��zf��A�Х��f�x�e�m�I����VS����C�%�9��kx|R02lVoh�iu}~<
� ]���0��"��i����3�"��Jo�oyX���0�����j����ܷW#�0D���J�zx���|X�=E�W�FI�N�u��'�My��(6��E�u���9�J���|�j�H�+���>�83��є�[�9�E��r����[�"�Tl&��)�U����%k�"H�ū���v�-���7g�@3YзX��A�����x���ul�7�WG�����ۤ��qM3TZ�(B`��lM8US��Yx��#�����O4���VS�
��u]6b���wAw�ä��
G�i���ݐ�t�c�D�^�ua�[\8G%�����Ɯ�Ae?��G�b��~��¤�&T$b.f�I���l����3l�W)c�`g��2#f^���V�Vgz��Z�Y���u�:L��k�����n�d��d�H7L>a�ؘy�I�����P�u$����;��J̟^]��M&�C;`�=���i҄U��a9�Q��9��r�^vQe���������)~D��h�4��{��������_nG�<)w���'#Z�qՀ�ƪN�r����h��uɭ3JUܵ��MrрNT���IH]�	�0|��)�B��7��l��N�C�co���ù�\Ij3N��KqW��ND���x^�H�ܯ����t�ct�W�wR���S���l�N��������+�[�V#F-� ��Pp�Fe�47�e:���Ǥ�E'㪼���n-b�����gS����	��d�y�F%�0Wʳ�!r{7i8���f����`5��.�%�[w����e�6�:14�#�1�@�o���K?F�T���V����ȅC� ��L����E��P���:��w�Q�2������b�\�ƴ%;:��l=Ջ���l������)뒻%�1�Բ4G�ߝ����C�NB���4�=T�t'eAQ��G��{�\[mݞ��fz�_Ayx"Gh7��~��vL�8C鿙s�3i]�G�d����}B(���R���k�Y�[0H����*�l���Or��I��`ڭܵ�<C�pC�}/��ޛ��m� ��5��N�,�8×��(̽�Rϖ�fF��(�jC-��<85����䁑��4�P�Ʉ%S�
�ES�%��?Q �    �'z�g�'��k��s�9�M�(�'����E����D��5�}4>���z�h�L�Rx��F��y-�`$��4�G�MH15b�o�yL!-O��]�&����������<:�uW����Q�V�?̃C���&�J�75��G~�<P�'�׆fŸ������JF���ѝ����X1ͺ� Uջ�iy�yU��b��R�m� o�;a�����g���\���sn�v�#)fD�@w��-'yH�˿Īh�-Yu3i��	ã�o_�y�w҈�J�� ݞ&O��b�^��&K��,���R���Kn�).aȂ4S
�┚�a�۩[i;��.Z�S�@���m�mM�<�ͳ��ׅ��-5_���n�h��u=�0�A=b��T�U�a�5|�i���a��"
*��g��f��<`:/'b[5i�'GLE�}��u�ې��i�1�Mݢ`�a��ag��N^�Cz0��n}J�񽹓e�Qi��v�A����*�0�X���7[�L�a]ۦi��S�DÇ�������m9s/��җ���lRù���� �7%7�$�bsًʖ�m�=��0������{�m�C�df���,��7�*���FȔ�&��{E�h�ֵ%��ɦ5����R&���'7zF��Z�����f�����2��䈿�<��`|%��oʃ����:�܅��#�K�l�u=����T�3L��8�-����1vᙸđǤr�=b&�!Z��R���d
�K2�U��
��z��C_�;��7���{�b�ѣ�c�Q�^��>F�LD�[�#bG7x���g�D�a$6��w�k�ؔ��.>����P�x���ejd���.�-��DT�0�>`�����|�Ek��u	��J�M\��N�E���&q��偈pX^J�˷�^I�?��Qi���ޖ������늣�q�Q"�R�=3����3���Lp�刺X�Lk��3�!1x���w\@��z�\	�,9F��e�s"+���,n$���}q����^�?�{�A�CEcGYp����ǅ3�(] _��|���^��m�)������,�àP�s��Ş7�ш﷛2ɲk�z�̟�È��s�ם����"���w�?w��u����������-���hpĘ�X�f�`Z��h��Qӳi�W�ҙ��hC6�����H�"Z;m?��k��eS�KٟF3���a�D��&+n�M	F��#�%��M|�s��Iܘd�A����������]��h�:m(S���oR�B�f�;�+�L��eRNs��/�(���]7���{�C����嚙$=`�u���6��Ct�q�>f��^�F��ꃃ=�^GBsɤ��C��W�!�x��`�^�p��#��?�HEWN�I�>�a"s�9'#b�]Vj���E�Cؕ�K_�C>N��^�a�Zo^vb<黹�(�Q�o�8�F0���b���H4b�Z�P�}�<!3`x�]y��u�Ls&��m_��s�/�y��n�!�d'��1���䮄���G�v��ӗ�B�%��w����Z�d4e��0m�a��M^��=bl��rHh�M�vP47�*+��,�J�����-��J�e��A��ґ����7�e	{�6ʺ���R�@�����ޔ��?J�	N� v)��y��~�^Z�N'd�ޔ'�ҋ�w"�qr�u@���/d��=��Qֳ��h�s���&TG�[DvC�*�nq�2�f�u�&�����s��a�J�RT�/�@��ߏ��A�W��&��O����<H�%����ϒ_��(V���(�b�=i8��p�����.W(m��_�ԳsU�^r��e�`п��햲L]+��0�,�xN��r�LR�1�l��|���}3�n������P��p���~�b�Z1M�d?�F��iF�@�@7���4�?�=f�D������}4Z�T���/�4w��Qx�Iݤ6zH�(��a�b�]g����)���� 殺xF�uc��ձ�]Z(اc��=�����j��t��b�N{R�~]^)�c!�������'U&x�G(�u��йN隼�K
g�=v����3��.n���r��v�D���Sdӷ��7�0���jt��3�o���#u��B�l��c�t?PY�P5bqƨG�q�f����a�ŷ���H���f��HG�nf��k�^��2��%j�'Jc�p�[OCӺ��~�?����s
3�X�y�>WC��<-7��"�S�'e�CaJ������F���6��'P�����0U�:L�l0k	o+���j'��C���Qq��C+���0k�t��禑D��wB��f���
���Pz'�����f�O�:�V�=�2��6��>w�'p��u������/���ܞQg�T�!�w��(�h��gO��Yz���eG�2[}3b0�fxˈZm[��x�,'L�Z��*�LᲛ������:����\j�0���ѽ[	J%��1=-R�a.-b�fV��}�ԗ8a�m��a�aK��2�+%����-��u)N7�j"ΣeO��.�,�����
��S���N�mCZr^y1#fm�JP���_����
�]�J�(O�q��f���e�)����cbK���|�|L^<r����ܮ��d_�����|����<��N�I������||G�"�F�Y����[�`������!����q{Q����/�w
����\f�{�!��uǊ� �	�Q�0�=��I��1�Zn�����`��Sk�����~Pȴ�!������?��U&w}�4S�E��!�~���4]} ��J�Nh:Qt=�,�|U���E#f ���Z�-�<��eF�X/=�{����s��i�n02�|���K��E��u�B��;!�{b��y���n�]�ѕ���c2���#��升��f��R�6h<�E��	��c�Ƃ���9i����`,�Z�ۏ�Wq3��v{��z��L�6fa�햑'�N�R�b3Qe�xߚ�B}�R�D�a�c ׿9�yޏ댘����+�(�<Q���}K+��򸕈�VG�����s�����#�S�j��=2x���6dOs��<�A[h$����"��������	:�l_*��ĭG�\c	��sA�ļ{�@}�&�K�B'7��i�o�M!4!{�;L]�M߄�2�=�u��p{�A,��fOs�AW Fqv�I��F��ϰ�m �]�����0��;M"Ƅ�݄���Ξ�3lb��<,�hB�T�MĄ�y'fz�m�=,�hC��-_k���ar��{��07���r.��=�Px7P���?󂒧�Š�l!s󂲧�6�Y�����ߜ�Ą�h��#aȜ6'�ùHg����z�eZ\y6�4�}��F��r������/e���*��WȂ{�����%�T�W�p�(w_�f���o����W��{��;5�+p��]�`Э�<8�q��f��:�����d�oԔ���>�a�BЏVq�Mvh�݅�����C�`Z�x�j!9e�UޅX�n$�i�AΛ�N��Z��/��,v�]7�f��(yމb}Y��l�����Q��)l��7�+A�kq��S�r�)�����y2.:�FA�jn
˜��N(���_y�F�y��r���ߋ�L�1�Y��}w��^��N���s��)h�ܤ�8ﾋ.�Ql2����+���B�F{�)_��F���	�o�W^�/�/'�E���rz'��D�.�n0(�W>�EY?��<ۛ��k�Њ�V������_�W�Q=Y\5���E
���m�r�].7�.3�	����l��f��o��U\�;s���qG#�(���ާ40���HWר��s��_��h�0pwe{�|���������U�p��V�bZ�ul!�i�(���B�z�U+O��0����)t�%^�3J-�mv<�ḟ���V{�z�50���K3bp�zp<r���dkWZ��V�W�`��>��`:i�A�#�Wb����5{��_��0p6׽b_6i"�i��j5���H��ir���p��u&K��g�g"��$��K)^U������#���X5�ar#|��VD��<�@�����W��X���I���    QR�~�e0�$bԆ��s{���L���:����Y���ݚ����|g��u"�ے�LY8.sij0����|	b�OkBu�q�U0?_�0�e�ǩ�s��s�4�\:Qt�?u�!��\�E׳th��כ�n1�*}�<��-R*��i���8��޴N }�u�vf�n9!�T\�%�4A��w��|`�w"�vn;Q�u�?<�1�8��n�mH�o��?
p�+S>��
�����V~H�1EL7���n������r�MH!��.���bq�y�<"�/_h�:�ʱs�Y"��PZ7L���ؠ^�)�����[�5P��,�˦p3�ֻpLbx˰���/��w;P�U���)�'
͆��oJ~��)����r�}�xȺ�1��l�5�I?k�W��k��Z�o��度b�Y�wBF���I�ޙ������'}GY���p�XG���څ�[�Wh�[���Q�q���5�F���^���D�A�46�0T�W�5_��G��cyx�NĨ�?�F^�l�Ì���u���n��e!�も�C�d��xj2��.���ۏ��c�B|G����#ty_�z+lZ�ٮ�M���t\���5��<@�θ\�#��S��u���;B//e�E*�����̇�́���,ݯ��ZOP~`t�ڔ�� ��A}��s2y��_��dt�hol2�N&����
���O-8a��)&��d��wa�j�]VB���
;���Yg\�ʁKg/f5쿿b���մN甏��l���/0�8.̃����F���;!�%h�S>P𐲽�<2�:�0
��u���&����B����&�0=a��Ҷw���|7PF�"Z��w�i��@:�oD�S�-f��ݦ�⇱�鋹Ǭk�6�t�y��W��Ǩ6��_��CV�	��`l�x�^��4����G�m'1�Ͻ�<�w��e�\��9]������E����I����6��S�7���������A��2lm��)������q�p�����Z2�} ����[�����88�U(�U�E�K�H�)����̇�H�X	O���<��"�l2yqY�i��%��f�[pp����@�w�Q�,2ˌ�isd'����{Z�Zx{��)8F�D|R�%���yk��/�V�G��ysk�uU�Fn�.��E�Ô��?���Y���ؤ����������*c�h@���ׯ��A��:1|��ȵ8O������x��P�XD������<����b�<X���O�c�Mn@�n�-5x��*C�MH)nN��N�%4�ⴊ��Olp�\�g˱�n�xHJ|3�/Z��9g��Y��&�H�}���K`lf�]��(�/r:�;:�l��!3x���;7�i��s=��m�5HU�B����M�cm�L���{�
�:|�y��aZ�T+S���Wk��f��M%䊜����Ru��連��=Q0u�%��Csށ�i�.�Cjp�H��f�/�<z�n1�U!&�W�Coޤ���̐[��t<�1W%�8m6�9o��s���y̄���4��1�"���͎�a�5��y��&漥4�I�n#�'J]�;W҃S#e^b����<�v�@:�/��;���Y���䪊�-�^�:�Cr0�"łA�2rT%o�?P�����a��H�����}����F)b�G��<�U9G�C�^�~�_2�gGi�P�JZ�o?*�.e����ey}��c�hv��0���4i��(1�'�vg���Zm'��o��&7
G�XMoˏ�E4�1�*kGm�ؚ��࣌�����n?*�����<��i$o�E��!v��^���>a�ˠ�i���	�	.~$��41�LkxŽ�M�A��*���WA��7yoި%be�C�O�O�;a����zH>"���ظHf��%-�rO���L~�MIݣ�@�z�t�M�YZ��k2�ak�0i����]s�J��<xqՐ\*�s����� �>%GI���`��ڤ�>7%F�'|�@\��r%�����l���DJ>%�Daxv+/��| P,Ak�:#�\�f"�8�u�Qޢ<���ѓ\����Q9@����ۆ�HO��Fc�˿ۿtn�DJ��L�ρIޣ�Nu��g�������@骮�M�~���p�v�7%��4������T%�DYW��=}�4�J�R����)��D����?Qny�c��,����F���C�xJ�8Q����|�:�B�F�0�;��s��������~Qޤ7�Fʴ�z�^�Lr��h,;����o��©Pۉ���p��`����>�Q�h��up�?��<�/���3��S��e,�w[0iy�q����[���d����a�U�w��w�0�T�Y�q������߄D�<[����ӷ�ȸ*<��'����4���Y��QrǷ�H1�p���7R��w������8�D�ݘ�|��A���{ H�es��J�#cf������p���W#%�{̺��ߍ�}8��Q�0��{��*�N�9a�r7}>Ol(�7O�6⩘��?[#�>P&�k�Q8�����N+�{SF6|�D�m�N�;��A�s����t����ũ�~�e����D�^�;͗��t�[�E2�i�0*m��P��Y���e�ҡ�/K�V؟(H
�x��!�[
�ݨ�r���=P���Es�{���z�dM��q���nvn��K�����ۉ�i��h��jUU�n6m.^�4w��*(�������M箄;�p�6��!w�a_O�ߜ�2��5t���ޓo�Ҥ�qV2��K�;(�	��E�~�iqOe(S[-�Y2#� ���Q�^�������v%37�^S��ֽ�����\sx=àXH^�dS�ՒgI�u�ߦ)i��9�"�aPqL��fA�2��x�f����	�gkIk-NC���ixy���)/Gr��Yr7� �-0L��J�|'�ʕ��9�F�$ݞ&s	�} �
�u6�`@��k�ey>��5�s�K�jm(v���Mњ��㒱8GA�{W�����2k.J�������upUL8s��K���a���k����a490��ZN��0i�Љ�l���6/�����7��)Ћ&�����"�T��Q�x��E��^���xY}H�0sJ�)j]nNv��zQ���Q���+$�!����sI=`~u��<�q�p_���]ˣt�2	�kf��;=,�{�Z��F������U�w�	纽�<�|�`�����\~std��e�n����ι�f��J=�~�����uX����Cz��@�6�Z+~d.����Ǭ�4d��	>���a��M׍��m`G����@L7�n}��Q�Tt� �%&ϓ0�,x�u}H��(]�fbn���y��¯6����[��vb��i/DY��<��{
W����<�_�A��*�?K�fK�R�5��j�n7�I�C���Y��{��r�\��2�q��;f��p:
��9iy����Z���\j���<��U|=62��@Y���[+��B�A=`���˜�t�|�0]
m����K1j��Z1��Jەq��;�:���i(�#blV)�����#c]
�uN����R�6z%��7ͧ��c�D�S����C��K�\z}�4���� 0S����:r�5b��D���_��W�mH�0�y���0����N[S�x���,��Dat�f�{Ġ�j]4��Q�G��H������N�|3!�b�Q�/��.bà�MuVj��?��_ʄ4�;�ƃ!�����=-w�)��?(V�)�l�*+x�5(�Dy�ZK��Z���fEɆ_z�_�X#��N�^|�&��鏺��oO����C6|]W��4�����	��a$]�bƫ������V��B��ǂG�6��e�#h>`�4���_j��iv~�>�qWPvK1=b��^�onQ�W񠈱������ׇ�����ƀo��xc����>77@��ܐ�A	�k ��}�<g=4`�8p'�rd��ޝ0˜O_u������RV��B��=Z��9�    p��Dlۚ3���Z��W�/=k�R"Ʀy�T�� �E��Vq��6�yic�{�Jh���Zٶ&�H�}��:6=��w�P)�a���w�p����ݾ�~4mb���<�9��v�
��wu���׺�f�R� gZ;G�+/v�uQ�V�~No��Wn��=��Hq��řp��A�qt��)�ő �)Ԯ_�\��|����v�5@��_�>K^zq�,��g<�CB�@��6-������/W�����n(c�@��|�	�	�>;����V�Y��_M:������;P0�yxJS;Px]�\Nn����3�(��Byx������u�n��|H��R�+7��V�*�/�7��[.&d��%�R�]�E\/d#7��?�nLd�x|��@Q��~
x�rud�e�P�wL�7�L'
]���<K�"�	����t��u�����?$#�P6!�/���Ê����M�LYH�[��ڢ�?����Biф�ɘ��=�.Ǆ�H�O:��T���Iu��l�3�Y��2�[��|�<`��i����O�X�oy\ަ>$o)6��K�\��DA}��'G����d3J�R�F�\�s��<{:~�镶�#�!k�U�:��0L�_�K��$L�U���<d�P܅�6�������/�f�n=&A�a�V�0�t����a�p�WD�0d��߯���?��,O������!~��YsQ�\��|�(S�y�M�c%���!Ļ9�,�
�Jq�j��NRv�7��&JRl�ړܐܙO񻇌W����oJ��z���<]�JSPqs�:P;O������>�{S�$(T�Rbv]�����e�:|����zI��b�Md��{��2�'
�o��!k���b�Uve��y�ƝĶx�U���C�0�_)X��O'{��;}��g��*��[-�#�e�bPq�����+u�`�D���`W?:�o)˳,���C{`���gV���h�9��������Կ����\��y��B��ʽ����-6Q�E�׿�J�Cu�<��'�M���>6'-�s�`��?es�Ρ3R��Y���M��y��@�k}�*ބ[����/e.�ۛ��\��Oꌂ�
�Gy�����
���'����L3����������)W�q���F�'��à�Ɔ��
j��%��c� !k�!�� G�-�FT����fP���Z֮v]�S���l���S���
�|rߘ=`z�) �/�>��o&sGY��Q�OG��<�1�����A4}�{<D�'~��9&G�uN!y�o3w{o)���,�Lh�P����Ѭs��f.�y�6����)3Ы+܇��3�n1��$(��cz����,ȇ��9a7E�6k��R��^&�:�T6s����ӘD2��v8��sJ��BV�Y�t�FKI�gR�����:�q�i�z�R����p��bB�Ǵ��IJ��4-�W���Z�4|v�1�������������
�,R��D�\}-Ϯ��F-%��I�[��g:GF�9.����~�>E�k�-���ma�;�X�{�vń���&��h��MC�l�c�4�{��4{J�R�Rf�t���U�����8�ם��3���K&�������f��k�w�tA�q ~�A��A��Z*�@���ݤ�6�'L]��8p��r�[k�T��^f��/��c;'�:k��=���04I����4Ӱ>l�f�y������	#��ܞ&��ImSMZ^�l_�=�OC�a������n�~)�r!�!�q����Td?�o�\��D���)��s�_��V&��Q��|O���5%홖��l�Goŗ�(l�W�ra0����OJ��N]�-v֪���DY^O�b��IV�_��T^��݆�(�S!��r�R���C����¤ޯT��K�f9�Żx=��I��g2]��=���Y�1�&OHo�ar��j�@��`���Qy�M�61�n�������.�E��R������#�ݲ���)��[��Ni�4yl��hg���y�ƈ_��M��M���E�u����� :�i��r�E'V��)Z����Eu-��(��m�[����V��3�Ӥ��0�Ʒj�.j�(E�~�-��P�2�&.���1dֲن\�SZ�K��2�ۆ�aOVA?un/8���#EQ�'�C�^M�6��[�k@�.G������=`��B�ޭ�|�^�(�*:��N#��D�@m���������;�_����|f��R!��Q�ۛ4��ʸZ��7��=��m�ooX��tOA-o۾v~�k3b�Z��~���/�^�
f�����$��xH�-�U�K��M0��aȎ��6Bs�|e���LH��Oɼ[/ZO�����߳�f�����)����+A�������_t��h����Io��F"���h�0���D[�U� D�N������}X�#`.oߺ�%���?I�O���f�㦊[wy�-����ֵu������D�u��u�ۻ��e�#m� ���r^��)���M�(x=��J�o'q��S�soa3��l"�i�����1��� ���^��[�ҥv��_��?Ȩ*� �'�I�@��-f�l����!�0���bf�H�{�xU�ޞ&M�I�!,L���{���'ʲ�e�af�[z��rA�[d�!�쮩�C�߂ZK��|b ��.�^��^�H�����z֐�o�K�O�a�vR{U�����T��h�;B��[���������2�����ߩ�cA��ti��,t��u�[q��͜Ǟ�]�b|��a��i��:��A��ZO��ZzǱ�I#u�hc9����#Z�|ⅿ��f2S��v����[��o�5����=M�l�һnQҮ��k�s:J�/ ^���IB]��I�D�F�@���̋W"�0d���^cpa���'�\g�lO�pu�s���ҋ�o�����{L���0T�J��kS&Kv2�
m��i����/+�K�3���]�RT�hl�&/��f�05_OR[�����@z5aWڽ(�;J��j�2W��Z���f nM>qձjM����
kF!K��25�����
kdZǖ"@��M[5�޷½��PjO+���я|�5_]��V��e+�hA�4�iZ�`]:��z��7w�щ�c]Q�-�%;�)�)��?K^9���j��͂�!n��T��D!��.�W�GA���廝q�;@�����R�����˯_l�$�z�-'�/<J^�$b�w�Zw����`�5bLof�H��:L�;`�W�a�$
̀AҺ�)k����0��!��Y�[9<&,)\#��KU��9 �an���A�b[7i�	3�Z�'�C�{��Ep���&O0ˍ�e{�Tm+s�ej��68?�Wc"m��kZ�܋�ݔw��A+Ii>|\�	}�1���1fd��Y�[:�h[{y���d�5(�-.�iщ­ͷ��"���(��f���v���~�\^��%���䢝'J�NչW�f��
�+�����dm�f�Ƌiu���0�7>[��Rv��ȝ��F�X̢<X�ݐ2�U_��'�:/2J�ؐ�Yv�7��g5RԒ�2�𧊍�K�E�	~u(c��$ii<��txv��_�M���3rQ���ڼgd=x�E~)�eV��T%.�"F�nq�� �����>���NuQ�~Щ�@�ui�Ϋ<\�(P�M+F�<%�;Q��ѝ�A�*)�;P����<��8�#^�C_��m���M��L˭��*qϒO�^�Q�����ek���!LB���Lr'��o�\��[���e����g�"Q5�|�?E?RɄY*���=�((�b�n����/�n]��%O�((�Y�ҷE��s��u���2�{���V�eo�3ˮ�g��]�+HH"%Jgv���{�A�G=pMچ�O��͗��JJ)1�8U���9�E��eN��z�l�^DQkB'✁��b�������nC�+���̕}_ϖ�f���ܹ�0�%�ӻ���m=��^���˪�M�][O$��'d|�s�{���`J�����MNF��x��^R>`������d=��V�    z�������x�:����Ni�m1��G�3����R)���D�'^��R�,���SJ���,�W�h�Gc�^�����K�Ӵl�E�\ު�'�����Rn��=���@/7�w˥�"Bi����J\@��4� g�͠3�_���Ҷ��Z)&l��z����b��˒���Sqgz��,��_r?��2Mf�l�FVL�!�ʹ;�n��L�fLzᐜ|r&4�dW��[e��c+,c�`,�^���MnKi6)�o�;=��c���ޖ�,��]�r�G�B�d2Mz�q9��N�EmL�����������V��;Q�m�j��M
nq��B�#_{V���4��
�\�C��;���&� ��z���ͦ���c��&�&��J1=�2hj_*��<�b,/^*o~)^��W
���1����v�oՙ���x���R������E{�g�IoF��k�����C�9N�=M��g��9u\'J��8P����T8vz_0���pE�1��Ǌ��*����qρRG_�Y8��1� t~V�e<[
���\Զ�t�(z�N�цJ��ߑ
�t��+���X�]AΙ��g��j�����F�0����4l��;��b��=E�*d蛣�x̖�f����[�K���L��to��/x��b�Rx�SZ�ܴ�0\Z�(5��<Qj��^��+�[@{H����я�`�I���4 Y17+XVLF��PW5OOס��b�cBRξ*��8<Ɗ��T�Z�a�(pO���h^�}�����C=��"b̞ʊ騶��l�	z=M;��k۰0���K�S�M�7�1��W��Ra��Ǆv���b��L��+&����V��p�1�-�d��i�&D>��M޼�ih�K�:ew�����[��A���)G���@��k��I�"��?K,�����B�\����Yz��b
j�t?Y�[.�N��boG��Y�P��D��봷%B�4%�3c���J�c���i�t\WtKN�κ�'JÉ��^s�=�Sl6ש����{���7{����	/���D��˖�~c�ׇ!�-G(NqQ�����Wu!����E���d���#�k�'�> b�x�גח�ւ߫���S������!�]P~���"�.�uj��0{����}��k��q���A	���������o��k�M~��%��a
촚�?~��"����s>��H�H:��8j��=��U��v�����1�bE�9��è �7�8ؽbTE'G���.�Mq��)p��&-Mce��x��1��z���A;��3�������)����Rl"�T���0a0o}����1z��Ŗ`X��qG�s�2X�B%��U��R�w���צ8�|m`l���PvU�!����C����t���B�ܴu�1O�GQ�f4�cJa(�{���r9\��H"Y$N��6��r����Ņ1��^y�CS�Y��>(6���!.�Eq2p��F)�"�sb(�N�Wèo��K�0�?)^�_�w�/�x`߉�kMӋ	K��=I?RM��16��A�`�KF�fH��^�ag/�P�fwq���T�;d/����T�3�y�~�k���D�'*�Q/u�ؒ)�
�=Y�J�^ڊ���mL{2��[׌�ڣOZ-�gp�R�h�R���Lh��������)hEr�� Y)���v��_"K_1݂ ��M�wDw����W�^K����ל��B�Da�SZ0��W^��&�����҈H&Ll�)��bRy��=a�L�)f��T������,�������l�������l���EL�b:�p��=c¾�Fr�d�)�	�0v�c�qx������S�}�	qXO�t���oV�3x���';�S�Z��I~�P��[��p�!���$+�Y�	K�QAⰨ�S_1�;BJ�d�Qq<�Ɗ����1a¦��i��dy��ڴ��x����b��f���Ⲿb���%g\��_b}�J�����E������މ���"r�a@zO!����x(^�Rڥ���D(���j���k.{��
�Z3�vw&�D<oO�}P� ��ì�z�5��b b�m�[�:�6���^�Ut�y/qO^�b�Q�9e_I79An�R����%��&'Ȳ`�Isv���6����A/��.P��07+x,*X3�ӻ�=��Brz�x״b�`ѯ������\��@���.�f��mp-+�F']P4��8 ��4emj�1���^���)s�v��Uń�`p�($��H���׋�V�Պ�?��(��J�D(Яq�w$aWt��P�g�t��f��+�X���I/��f�~=L�I̒����xm�p�
����G��R��i�%���X��Š�B]��|�&��[͸A��hMu�p�M�_���K�oAqo�	3�)c8�O��ޫG�OM�c�{�*����`�C�,Pf�C�q�Ȁv���.�|¡~�
ڋpr����|�����y�n�xׯg9齽O�����1j�%'?%��w��r�JJS�<���m}5��I��q0��C���/g�
#���b.��6�{���h�t�A�V���+�r��uL�����BA�J{�ɫ�>0 l�w#�k������S�zr�k2�]�
8����MA� �KWG�1�{�P��%8���.;��6���*�d�=P��k�;`�Zn����ńY��іp��������-o�Z�Y]30���'��D�
٪���
��)�,�\r��+�٣��_�o��X�D�=쇝p�V�R���9�V<��
�Y��^�vŮ��~�C�d�#��z�:B[X7��B[g������|��8@3�?�����̈�ÄiOj�(Q��I�zk��T���P��UC'���r;�?�Za�����8l���R��D��!%��5t�&5�{9jh�"U_�J�qvh�F~��r��A�Q��)����������!]�>����jɂ!�oc�<&l�^���t��� ��}e3�Ys��Z��wC���	��(^5�o҃[j�k�Þ8��\^10�a��puJ��;Q*���x���U�� ������+
u�N�1��S|��2�ք�|�]�X�ow�J!nn�S|����]�E�U�ȾКmT�9j�!.��/�<���Z-{	�h���EZ��&;�N��x�[/�R��wO),n�z;�U��)��M���6&s�x�8E{�(a����>���u+�u�8'�.�% w����*x��н�CCa�ۍ$�ڄ����La[3#���q��	��Y�k�MNPd�`ƴ^�Է�ݘ����W�M��p�4=M��`�T�=�0׸³��b����&)�g��f�U��4a�K岄M[�����_�ٖ7I�-�/M�C�/���t��F���s�)��K�M��(�ו[����׳�9{aƝ��{��ʂކ�A>��EmL����q}�FY�k��okB?PH�rE�U�����^WL�Ƥ�I{��CL[1V��G�$�7M��A���Zt'G	Y�&�Һ�Bn������2K/�ܠ�I.��(hzl���v,7�w������'kgkܭ�:8�\oC�@̈́�� �*���m�h�;
|�;ǃ�z��r�	�&��%S!�/�X)�̦�:����X1�z'�i�(t���4��d�(P�(� �����M�EAu�^ǝ$+����%2����`\�����Pځ~�4��=�;�c�+��=}�xX_뛹:�����|�y#t^�B�=��o�;/��\����₌QWL���a�5<ڊ��J�hF��`���~}�,�S�����������#�Í�b�x�⹎8�=��=�&i�:u�3�Wp�>`8�i�=�pj�Hi���5�F���GN�0����0��Ƹu�^��-#\�#兂�A}��%�~S��0�f�&�j�TV��s�<������f��AMqm��F���$����d�H�P*�3��&���1�����p0���2��n9�b�/��<'�Z|�tMa��	��k�7PS��4}(9 ?�j��*�^    ���456ӌ�j��ߞ-���&�3Fv2����~{�]H�R\������B�5Z�|�^���F�øSV�M<a���9:X�{*F�7��j=���d�v��O.U_sX�9R_)��Rt����Ң�ꚡ	:�#���ըf�����;{ {L�D���X�s��;a,V�����'��iޢPm
)W$�~}t��`Ĵ�b�ipV�<O�mJg)�i�x-�ܦ�ˊ�k�@���w�L+�Z�[�yj����5��sf�V�69��9a��~w�x�bLR/�(cz7���ɜz�	/t�-�	[�j�쇃W����D��`���9���S���*���C���?�<��tH^����CA_1�s%��m������Jԁ?{�F�Ғ��U�V�`#h��o�����_�����_KښL��MP�h��� ��/���?����?8�/��w�R?M9rtc��I1���k��<N��*r$�TW ���~����)w�rU/�Wك8}
��^�ɯ;���V� 7o��|�f*P���civt��Ӌ֛"�����EC! t����s4�`h{)�.%!�>	fu�x	���|;�tE�,�e��Y�.�Ӓ�?��o�9dI�D�W�8�&��x�fS ���1q�u���wͰ��ƻ����[P�~aJ��a�!���ݑm�DNR�_��KA�Švy��˪~-�7��m/ѳ师��g7v�F����fZ����2���!�z ]�r7��L2p>{�I��OT.ap4�����Wu��{�ҏ�;}��h�*�x���td���M��#HW��������lS�$�_Rb�����yn����u��|6�^����>�PpYn�2EaVg�OVͺ����&�Q�Qi����B���o8��q@����8戽�R�+:qtIw���|3k�I����֕�D��+�M�Wx>�P}��U�}'Q������-wG#G�93r��6����1��eh�z��?�~�O�Dgk>��w���FcS���Q9Y~�n&���Wc��"}����n��mE��Ŗ%�������!2j�
j#'���b6�`F��K�'^���U�D_{X)t�X9�7q�oxA.y��%h��'�G��60a�c������YJ�.���J���R\cd�a�z����FF�f����S��2\uC��|ëE�t����s$^ZI�s�aV�^~'̈�'�@5��8��%��=���1_�]�޿��`�u�#^�L��C��ׯW�0�O��٧���W+u�6!=�1��a�����=�7��M�2}��i+&�x(�{�L߹���i�����j���idŠ�Go���	��F�+�������8ӷb��I��\Φ��[�~'�����I�Q���0�ԧ&ؖB�Ai�4ӏ�3�&Lb^6�55VҰ���o�Y�e�p�ܥI�;JX,���ō�B���C��?���)�+�X 1��_�x�%�i"�Ā��I9ES�On�[ �%�~�!���H9�)J-��뮾5j6��%^��&���]��|����r�?��\(hCx�ɖkxP�05�Jf����&�G�`J���w�ظ�q�C�2������n�|�@��j��d8s\hq�@ ����6;a���e��]��ڂ�&I#e���6���Ȃ��Ga����b'�����-4P�ޗn%�T�X0V����O1��N+ƴ�K��5�Z�˅8/��p�� yL�
/܄S�Ldb'��J|�;@��m�CO��E�vvR���r������5�?5�&�Fq��i��\���o-��7�WL������4q���ۨ��0�|���`�D����$��Q���}��W�J.On����M��jg���5
;��MpQX��٦}(���z�%���v;Q�0�J�Z��h:��r�ݷ�!8��!Bm�������fo0��$iNeQħ�I)"#��9<�I�='���▻��ap	i0�(��bZ����=�ꈦm�#f���C-��-,�O��Hi\�/��v;2 }ri*��cZ_�.��b��$��]:���	Nm2W�,w��e�vm��p�X_1��}CB�gm�=e�|h�#_�g���Y24���2������0 i�GЪ��&>
.�
o���As�h?=B�_?���%�,<!ە�>M�90Ʉk��ly��ω���#Y�_���g��B��{�^߱[��4B��zƓ�U�0�܋�֓�i�C��;=�bޤ���J/�h�k¤��������]�M�|F�\�,�w�0-���֎�^ua�bX��C�P�nC�n�Rه�[<)px�>��K�d���4�C�^ �I�WM��7C�a(��7q$�p��c_]�Z���ux���"��Z3���'���^���s�u�LABQ�o�Mg�ȶ�z�[<*pxٿ�N�0�h�.=�)-����ľ÷�Ҡ��ðX�z�Ƨ�z�Ɓ�<���c��~=L5�a��P��֥G�j�w�)b��H��v���齄¶�����Ǯ95��� ם�߭9��,��ĺ�'
�.�����(�f�k��W��Kl~[[(�[��r�*-�MV���=�o���0�hj�h#M��b�b+u��k�f�~A���a�أ2�9(<���6����B�kll�w��B]�fX	+�<�D�� i� �_���%#ڈͯ�#6�G��4}��J�Xq2���j�Z��M�n�o^)�齲T`����6�(���j��%V�E���}�Ĳ�{���ʖ
3��"�p)�LS�$��Sc����}��P���[ŹD��FA�J�чg,�Yo/4ʸ��IqZ[V
�M�ij�丶�A`��I�`�+��pK՗xH��u�>v%7�Ai�f�a�<�����rġ]Êq�UE��P9��^�&�!=Sr�Ȑܞp?��|���8*-_�q�i�F�+�L{����k�ⶫ�a+����[�P.��\�P��(�@��bfR0���Pn���S��y�&)(}� ���8o��.7�w�+�U]\Q��8(��0�Pΰ������o���uF�C���_�W���i��C�F_F����)�,%�z^1�f�N��4/�-Q��ۄ�K3�ew�U
��F_7S��а��8�؅8`�ܠ�2��a��t��IKV�!}{L{!JHӫ�]��+�"�G��0 '��#V��ng�~T�D��l�)i�����ND�y����b���ڸ��6+Dw+��?��&1x�4���@�����[�$q7�xGɯ�d$�,q���b����w�o���n�qV���y��y��5��u��`��d����G���d{�Z��f�~=��F���h��ݱ>��'��^��I�!�=l�ԟ�T��kf�z��p�?�G���X�huM��p�f��Wy5D��Y��n��Y��X��:�zv�E8O�����c�ń7�`@y�7w5�[��Y�����e�ŵ�c�ւ:\�r�q�Ŷ����|�j�Q���P!1a� �-�bE�#79���B���-�"��<O��Wʵ�8O���b�!�<�\���u8�7lc!�֊�B��ܖ�tU���2�|�
nə�X�s��PPǋ���X~KA�mm͐��>;y�/F_1�kØ,�q���W3��ur*�C$7<��}�N�&r (��`j�'�4�Q$j9bXͪw��EO1y�\� (��T� ���c�%nK��m�ӗ�nq��_0�dT|�^��U|�{�N�#R^9P�~7�@z�@�?�
._f.�{ %L�a�Ɗ��]e�cz3�1oL`�s�����Aoޖ��(}(7^Ć������f�N�@]WX>L ��#E�MGJ����P�S!m��`ګ&ߟ'#*�<b����K�(��Y1v6�\�~-v�f��I`�>��	>b(�I�ZF��PL_1��v�6Y��g)�7��&8�;���=�����`�<OR;>�ਲ�HA��tp�ȋ��׍�f�є읽��5|�P������*��SM�/�L�xo1Bg��������<&���磲X�"�8�����E��0FDLҶ=    ��;brm�M?J�"z�A/O��?����4E��=�'{ᇒ���(9�1<R
�W����#���8P��b{F��O����=��C��}�e$n.�խE/��;
��2��%r!V��t�ԡ7 ��#���j �~�<r!.Jy�?��(��e�G���^K٥��ՉG�go�~鳺�|*ƅ��Io=�6uo걼��K=�8Kp���G(Y��C(\�v�E���`��*��t�������=T?��4�^�tX}��o�@����%�N+�WL���\T����0�Lҩ�D�e�T��6=� ��۝:E噊i+Ɔ;Wj��p�(@w�@$zLO�M�kƠ5x���ur��~�����$�X3OK	ĻY�{$Ի�G�7��+���2�b��=rD���w��(�����l�ӯ��L��{���E��G��*�b��k�:?�׀g�6h8����&P��DIB+��)�/��f�p7�G�fo�2e�:oI��s/�sQ :�V���G��#������D�`�4y�T	K�M9G��#�T�*ӻ�2���ǰ��n
zDЎq��VY1�`�YK�z�W�_�)z�_��k����j�sWE�[�5*5:RF�"�%R�Z4(�@U$4\V�Q�둂��q���B�k����1��8Fr�P��o�{襮+����~�Z��|�:`�m�zz�*TL[1�Ѡ��O��+<��#+�cSb���H�`8]S�F����Z(��b��}�^���{�h]|l�/=Me=�*e�N85�X���6�>X|&�MֳE�"���S�lM�����o����yZ6Q�[1�`jA�;�է��">ۚ-�\)~ȍ� ��ͺ�+]͞�t���S̺3��I�\��B��c���26���G�Ֆ�U���!�,����B�	�rc��E�27s��P|�{�-V��4��d�)G����� k����nɂ�m	}�$�!��=���\����B��8���Tix�6�)�����{�W�f�1��	gi,�ɍW�$���/����G~�����{p����J��H�od{r��!f�NDyr��!���D�O.�?D��$�:����X�u+����G[�����p���y���ʡqx��<��F�b��{"=��F�)�|zF~���8t߿������c�m�e�ӧ�c���׬���H�ڱɒ��
f:��Ո#��` �wE�BSV�1�j��Cŋ��0��i��Vy�36nR�\V��< \�+F8D��������n�r�
�f@���{�!����E!���7?�HE��e�zcuF��Q���/�ULB�`���"O�����Hj*�Y��崵���^y`̨���wq^�*�ձ&���v)�H�p��]^�]�ܚ�Q�����Q���^��@J�+�Q�8'��c,Z]��͐ɂ青i����#���lb;�`S����6
#&���Pn��R�Ջ4��rcw�c�q��q��\즼#ݨ�j��)�y�|ˍ�M�ί"��n���G
��\��).w/�/Mݺ3Ղ��7���x�0{LSs�C"&==���j�B�i$:����c�[�s+G�B���bL�L��'���a%�\�u��Ǌ�0�hk���#l!<b�ՐV�PY��\u�Iz�qڸ�/ִ2,����i��eEw�j�mɂU���JOw�q2$r����|�����R�����*�Z�U�!-��=�� 0_wz����M�1���ʂ�#"[���E�ȯ<������k\|�j�$���<|����y���q�D"�Mv��Cن�p>"2�&B{�Ɗ�J��sc���f`�Ԝ����a�PW\6�&�/[n��%��ۗ|c������I.�܆"�1%?2մ:�PԵ"v��PV�ˎ_#��﬷n��n2�[
��Zg��n�*�_�V�^)m�d�NR�����R�C�ќ���Mb�@�FC<%j�F?�JA[/Z4��:&8�ꯏ���+e����=FO�i7������6rX��W�����JɐK�U�o�Z�~�����k��1WΔ[��t���(��/����wvD�&���&���T�8�2�����8�\�S*[JU/o@��C�Y��R�%��Οi�����C���7�a�~��PtK���)?9n2�������NLm��^���S"�QɄb~����@3��g��W?�B6�}"�cg;6�n��P��}��è�T�����spv�.����?%�f϶��ğ	�J��
l� y[0|U�S���KY���>�:ϨP^�g��#TV�%\���6$1�)�=�;׳�6� ��
z�̛�Ȟ)6E�Ȭ�<}T��3���F m�riO��ʘ}f�g�	��z��~�RG���P�S@,�=�:���)�c���6�#�*g����&y��Z��C<j+�Z16�6a*��4� ���ʙ&5�c��9��M��h��y'�E��/�(�wF� #�~R��8Z`L��d3y�2���逩&��(q0䋒M�9����RF4,�H�7#�*ȑn��
K.�S�l�S.|S�\Ufr��BAѯ�m�jG�u�Dؕ{3N��8�Cp}�ú֣����,~ݍ�TL_0P��l�&.�;�%:c�o�A˘0vp9Y<`��C���R�t�tz�E=#|l�u��J���R���y�����<�se&Ցt��Z[�%IEB�+珗6��`K�P0��c�/�~K�PԄcn؇rs�l�삑q!�P��+�P(��R�6��8�� �85l�t���� ۊ9��]�a��t��0��[��|��o؊�Zq���Ô�:)�bLe���j&�k�iz�v}_#ݤ��Ѽ�1�>�+��{�[��ib+|���ٻI	�X)��k��qF��:�iŨ���4�6G�{^1���8�O[�^L1�ު�J��&5����m20H	����b
:�Kɒ�^������,�M����Y�_��Q ���tw��´�J�x?���	7I��s�I��1e�`���>�Q���m����'���Z��N�b"X��������seJ�\s�ջ�(�����Q�G
�����>�b��Tm0l�Sr�o��"ҹ�}��u�����6&S�qDo�Vj���ԙ{����J�sRX���H7��-�溩���qBey5�e�{�޻�i���0��l���/��'u�@z�Q���ٔ-:)���Ħ��J�X2]w$��*�*�/�K�f��^�Q\們&��a�7x��a��Z�6���iv�����M5nui��|)o�Y;��8�r��Q��w�k��40l �E5-mz5�<ʊ�,ԗ"I�������c��E�>a�E<x�$���.������Ӌ7W7}��.ܒ��2���C�m��7��L'N�q��S����Ԅ���0�����5�,Q�&��0c�N�Ì@�A%�o�Mp6V�e�x���J4V�H�Q��&qAю����;#7x�U
�t���o���Y���Yn��B�Atv�x��6�=��8�8����o
!�M��g�Y�{
�)ٝ�{#&:�� !:�M3���c)�E/�����#Er���6�'�1����3Z�S\���c��f��d���iv�J�U�0a-��b�����^Q�Fm1����1bi�~���q1aR�Gi�3�wN����g�1A�gB�6�#S_R��T�J/���/8A�ABG�1��gf��~D�IA~v�,'�Tơ�sr~O%���#���C(w*|�����]�{hQ�x��k��×ڰJ�o��y��/U��_��b�:[	��&m
���Kgo��d��@�o谭���q=UQ3;�,=d�=V'(4[���w���t��Qa��Z�8�9�7f��X��ueI��`[�gv���@I�{L�k'L�%9A�����P?x�^��\�/��z��|�Q�`Kv��oJE{�:���p?)���0\�ϑsxS�N���T6�L�W�*&��8a�-�F���L%�A/�ԧ��#������7ݬ�`�mv0&��OB�U�,+�������Ǆ�~v�o�5;aB��D�|��Ǌ1��^��RB�?;QًՋ�:�    �>�����F��r���D�����c�)����X�y��|2ɦZ�~R�,����t�U�����`�Z1�!x!�2����m�	S��	2�}�Qa�0�bQ�T�L�;^¹�33��~C�ǜe����J�ab3|�=|�0#�xۜ0Ԋ�<WLX��s_1��O��c-���s+�\�dM-�abC\Ҋ�0Rk�� [�;�c�_C���j}&H<8\~(����M�t��Q�°��X(�ۢ)�(�:��p�J7�wX����pXyw���]�[�0�Y1�ʍ��|(7�wO��Kge�:Q����ژ^Bt�c�����jj;�b��sYMy�6}E|4��}~�6�F�$��G���eHN.C����А�jD��o$��[
W����5��G�l�I��"�9�&]�~���aG�� �7��oV��K��'�Q*j�O��v���+���L��k�2�\�����wA�8L��Å�g�-o�+dX�<�4��o~�#�0abۻ\���ei��#��lO�{S�������\V[�zx��'O�1�<&�B�u_#n��d�tkj7Ʒ��|a�Ϙ#j���A�Ũ����	���2V�X���i���L��B�t��
�<�8�x���(#�34�<�e�[Ҙ>w܄�����GP��oq�z5`+s��]W���)���
�H�MT�w
�0�q�ѽ�*a��	SP�3���X|��@B��_M��n)P�
����*V_�(H:�� ��=@ʔΗ�s��x�������x8��2��!z��Z}��_Z��-LzG��U,Jz�T5�>�{l�IV��&�4���f��)����j��lEK(<e׏��x�(M_��w���yu�q+H��U��;�_Kѯ��jL������{����<.ߚ�q�����A�-���s����׮�J.6�毀#=P_(�.�����@c�XXY�)����?$�?L�U�uIտ�8��W� .o��WJ|y�R����S⵻�g1�$���5�9V ͼ>Ԙl���V⦿�U��X��Ͱi���_?��J���{
.��Ш$����(j3["G��oߔn����lfIa�ݞ"ЖL�����-�ڊ�^{G�}_^wR�q�y��Z4��06��a���1�o�P9�.<�*�SM�6[%�Äd3���6�ǫ�u�������:���U%�-S�ۊ�6F��Ȅ	�����P��Ln#�e*������Z��7HGv���a�U^R��r���b0&�U1�ݯ��������C�x����fb�,��QJ8{sA1��΄t����	)p���/'������+7�ﺗ�f�k��~ 7����
?v[)qڂ�p�!i�����`���F/�)�sJN�x�r����Q�L>����|���!h�sʅn���H]	5-��J<\�D�(��)qԡ���K��\)����+w�����Kq!����l;J��i�ݭ���/׼Rl�M�4�?)v�z�VS���O֛�C]-�%^�_zj)���h�������8T�͆����SX������}}T�����ή�^���1c¹�'��Aïa�/ou�P0�vKGF�S�q��������o�d�=�����s���K��1/A��ώ�I�(�S������fl��Ѡ���'���7�	c8�y�y�}�\աd�EJ���uv�:R��A������V�U�3P��1a�~n�ٳ&2�S���'��x��H%%��b��]j�v\���тAt]�:͂����L��/n��r�X 4����N`Zv����"n�˭-������&�v���x��7�o̰�>�'�h���E�����[����z�;��T*��%�� 3}�v�G���ˬ 7Ww[�n�ew�¸f�;"�c��4��$����C�+�*�Ziz/���4�i����m}��Q�	����@CI�4{���a������08�w=%��R ��}9.����S.���/p�.���T��'�M�m��8)�Z)q�_��'�O�0j	�H��#�'��"q���×�q�B��ܤ��S�d�%��U����r��bԝ�w0���$�1@<O��Nao���o#�Wn�oԘʄ��|�_��~��j.7[��x�ڱ|���ʓ�C�-�f0���0���+�VV]��opkz��~(]�M՝�#^�;
���\}���ς�i2ы%� {e�W��;o���Q��p��=�_���v��1ɡQ� !
�]?۩Q����ꑹ��j���dM]��}w�;@[�)0G谦6y��q4V�O�g���A���W �{`T�=r�8N��[�zC �t�R�8|�������M�t��֍���	0(ōL;�Eer����d�3xa;��W�l`�4;�@]�-
�L`�.8`�Q<����B6�+���tӌ�ղ.�5��)L��g�����$u��>abO�k�&�H<|~�r��q�!���S� @��I��N�ؓ�qf`��;��K�@O��dxL\H�uS�A&鱗���ƛ��|#�l5N;�n���(��&�0��.V"�Ȥg�3}��(%T�9Q&�:ȍ��`��g��0���۠X�i�zaN�Pn���֧�!*�V��Aה¾x�n��J˙��q:eِ�-�}R�B%��J�2��x�za?�P��P*٧(��T�:o��b����y7��F�6���m1��c�������9��S�	�}61�D�J�d�5Dq!F�+�[�PO�8�!�t¡\���T_�g$�R$�`��R��BmRܢ���e4��H7	��{�� �{X��y7mxJ�4Sn�0S
���Wh�MޖB/]���&���Qr�/+�i�'�m�8�!��7'�K��F^(�,�ݬ8��m���te�`�#C�{>�����6�J������G���V�	���y}�h�;
�?��B��}�ꃊT�@���ao��/x^1vc�fj+&�D0��H��!_B�����ſ���(�q-nKָ�i���nE�WvnH����̬���/�}��`��c�m��+��D�+���K�J�)��G[0��@�S����XSm(�oY�?%��n��2�tuo�&8���a�C��Vi���dI�ky̍���}�g*���b��ic�潙����b�����T���S�J�8�?W`Mq'^I+������)��+i>��&&`vS����;�J���ox*����$^1����6�~�#l���ÿ�X��D!=(]g6A�����Q��TKw��&x�T)9;?/Nn^oGǺnj��뷤�Pp�*E��������bL�})���z��.I�nJ|�2ݛn���c��9BL^M���Ƴ��2n�+i6����P�C��Z��Ɗ��i�|Y2���i�@�[��[w�(����� Z�y��k�c~�x�`Lv^9�)���ќ0]����\2}c0��9�����謘1ź�$�K8Ll�s]1�R+4�L&8n�+�-2�^�i���F���EO\z�t a�dY1���p��&��y��Ц��,�
��J^�we��1�g����$��ucV��\K�)o�騶>��)��,e��p��h��W,�+o��/ݱ���q�6�%����h~b�b�E|�詛��4��J)�b��ԩ�&^ŅWLGa��u
M�ĨN��܇=9��ɥ���w.6x�NT'�wxi+����/�U���bC��`-͐�qn�~oBA1y!��v��1o9�m>�L���J�j���PK�A[ФpC�0��������?U/���J�(�%���ш���6��Xև�3J����W�y��dK�K�J�+�� �,�cb_���ZO��A4�[�j�0N4Y���c�Ыވ\�ǳ�N��gAq��[Ε���~��w������st+/n��~�����6W��%,�;A:�����E17B�r��6J�,�+�������$�S�[r"1l��gg�@an����D���AZ!8��88Lh�XF/7=���    3q��M�O﷥VW���μ_�E�^j��?���[VJ������W������b#�ƕ����5
�Jrb7Ǆ�\��P��qQWhrZ�)�!F�b�����WW3����d/�Pj�<��~� ����!��/�T�C�ш�̹3��l:��@��P!�q�O�������b���{(����[�e{�pC]G��ը>rU��<��̚բ+�:��S(
���V}�����=Y�#���h�&�x��S���I�Jӱ����ڎ;�*f	~F6z_Ŭ���<c�*�Oci���=���	�ݔ�"Etu�s��/�D���Ċ��s����&W��*M��T��!naS�7�.k�)�Im��=� �!ù����']F��S�_O�sw!P�rn^��(l>jB��_[X�Q�f�a+�Dh��^��1Y���8�*<a���g��M"ѫ�j[K�7��G�p,�	3F��\�*/_
��b�)7Wl��#��9'JM^E�%,E*^E�S$�c�Eq������d�п�٘�q:+�]�$KX����P�3�����cS2~���@P��"�Mq�X�n�\�4�8����D���N*.��JSs��dzs{��dxY$�a|�#�)���F�-@�bo{�@|�V��q-�]'�<}+9�R�����&}��.��ꦾ���X�s��5G]��:�p��	SZ_��7�C��ta u���q�xw�Ӻ�|�q7a�z���SC�ϑ��֧A��J�;�M��1E�Sv�<n�����썃��O���pwW�����\#�Q�c6ƳG�(���˭��o+��=�X��ࠇ~��k�&�~{��@�S^�Z��17˗�2��3V5�_�R;{������6�PMb�=ٚ�Iq��!�bW���\V��^�b�SSX�|�T)T����_���*C��l������R��v��M�p��dՅ�F�}j��.[
�0�:(7�ki���뻧�*չf5��w9
�b�9;׬�뻣�W�u�A��] ��q�餺�0^��G��%��`Z(W��^Ӫ�jܿWx�18eMg�=<&^�_�b֡�����M��@�d�?�P��p](����b��Tor��T�/r����p[0פ7�����jF��öY�	¸4����/�lh:��	sc~w�M(}��d�k�y,�ҭ����+I+�!׭Ь�S*���<4�O(V{kEa~��!�AI���T��ȃ7#&���ѳ�P�hO��]w-C5��,u>��ɝAڹU�~R\wTˊ�z N)�R�z�?��`LE��2W/�it)=`P8��7B[Sy��荆��
s~�u�0ҙ���5��Wj[)�=s����ʱ\eň��4��������1��W;QK�e��R&J��y��te���|�yC� �~:ƺ{����VCA�����x�^iy��;�SeL�;�Cl1z׮6�������	C���ƞD+�fSr2	j��"�0��&��5Z1ݒ�m�?�5��* ��N��9�<n�[��E���^w��{.�`���������
_��@����g����5ԥ-���ʠ��Ӆ����/�^�Q�5aB-���/}�P��<M�k�b,J�7�i�P�������D(0\u23-��m����Z��'����#��X�s13���JI~��PS�Diْ^J��x����
�_9�
�z���~{4!�iRꕱ�������'�"N�,�M�l|˥~�52�s
��7�(z����pI+e `jC���E_P�u��.W�S�>�����-)�j\9����a�`#�$r,���������c��q���^�|�`�H��y��z�tJ|�P}��0����=pUݒ#�`�1�����3�5�gL]/�G(��v{��ѩ�z��XW��ƞ3*n0~+�.^���`�M
��)D��X����(Ê0 ����GB��.,/�Z{8Z�a��O�f<دx�W��n�?9��oK7���i.�5���-ҫp������Ed'�[�	����C�j��S8,i=P���E"0𝽄,����u�^<ٯx�26��k�r�6T��~'t�}�L�g�-��M�[$�T��"�����l�3���ʺd`��"�R�\v�8���'K懒1	��ؒ9u+(Й���Y�aM�Z����%Eo)핚8����룗�dK���]���C��� ��R�.��k�Y$��
�F�.�R���[�Y�}�`/��K�����y�-�˳�J�I0�����<�7�ؑ�1��۬{��o2
�H.Ʉ��~�Q�u#ה��6�/�6��'�䇻��'��{M�cg�mL+8�ַ���M��&��0?�l�ɳ��1M?*����\���}���7ַS�Q��x+�h��K�.���~'���MXk%."�B�+'N�ʥ�8��i�dA����[�Wo����x�n�S�����75�g�H'�d��ړ�tQ�$(9u�fn<�=E�D�&��y���cʣ�k�����n�h��PPU�JeZ<��D�^��.=Z�?耸&��[�T���	s�*�g�+8��L���$wv�ҍb�-�Jk�ť��~4�*��Ԗ]��Q8�gO��mݻ�{}���)ojv�~65ũ�F-�l8N`��`����$��@S�~g��#?P�5�>��n��/HCwT�LW����F�I���0:fǂ��-=1�cnV��c?��q� 2Ҋ��H�D_F§9`��4i�7�}�1������F���0Coƾ���x��bغFS^,��j�{�0U�L�xZ0Y��Q�w���Ӟ�rn���sT��.����e�e��j5� F])����#��G���Rd��=L���3���_;�0��4�U�����g��PM�'�[j-��^F_1�d���:���c��T��n��c,�d�F�;�RJ���t�ؾ�����SLOY-MqS�[���������vӅ���B���)9��b|�����8��W
#%��lӺ�{HǊa�_2:�V�y��[
��j���ED��%#����Wr"e�{+���U�8�$�)��Z��No�&���D+��7���1���V��
����oր�k�iF諑�j����n��{�(y.g�Q���y�Jr�?�(�*�կ޸o5T��Y$gh�(����K�i��9!���yXםM���y!W|�b�u��xd�<?��/�Jk�S�~�
0�&���"��iI�!����=�S�V$����K��*D�RT�m��-V�r�\��W��v7���IC�t/���o(� �T,�	�g���ֿM����CM�ߡF�B��$۫a첳\#,�&�l��N�4y|���c�y��ӋBY���D�1]jCez�0�B^��(�.�����z�{T����K�ɫ�w�*c̉�]:.����a0�
�#'L��|4AR����=���1��\����<mL�G��t��,)�e$��Xߣq�}k�7K�3���/وFiͷ�H�<a�#�kO����lP�z�has����(} ��(���6@���~�~/
��\��؏���у��'$����y����"���T}�� �QH��2��0zd_�.��g�O����5���� 5����$�`ȶPK�݂-�^\ثZ@	��/�W�ݫg����/B1A��C	/���/�{j���)���
��=�
&��C9L9a��{�U)�w�y��CC�h���b,�Ӡ�Ӡ�D��Z�Vcb�BH�%H��w�G��^��I���+ς&6�	/�'Y������<��jvCv��iՄM��Ǌ�8o�I�[�$x��0z�L�z������'��=���F����J,1J%��n�cZ1��R!��b���tST]?��g�z?_�'��艢�s�������B�
��Й�8K�n����� �q�:u����l�fs��ͮ�^���U�������9'J�F��α��ҡ��_K�YEe]-E�8OZ��1� .����^0��b��8    mk���S�u݋�H�He>����30��_T�����PA��a���j�l��A��?߻�W��
��%>�"5��Y1�C�����J���=S\I �y��r�4u�\DrO� �;��z��g+cI{�N\| BjXYOe|CX^rݼ��A��b�ꁳP�Ä:k��c����;9�-^�TL����Nm����
-NV�^�;����x�@�D�w�ĕ�T��ѓ�}����NuB��&-��i���"��4�O�Y'���>T�@�,��+:v}Mھç�`2���G�ErD}�ؐ3u���kt�S{U�a�{%&Y�ӊ4,v�Q����12���=N�7��|��^o�L���$aY_q��n*�=�W�7�:����٩ۋ�,���T������O����J�iUm�g�(ӊ�L0�AL2�r����d�m9nL��6T�cLE��_47>�+ƒs�'�,�I�}S�(��Nl�j�O�SJOP��Pb��m�th'�������Ĳbl�n�2��8�;�Iz��5�����{���rs��
!z�X��e���k�aS+ �)��=P�~^}4�&�F�V

��]���[;N̯��Yb��}�p�(�t�F�}re=����� k.ޱb,��뺯9��Z���5�%Ʃ��Mոq`e�X�Rx����ځ2���|�n�o����jU�����f��)� �B=��w>���Q�_֩������M�]0����>~=NpQ��bj>%���C�賤It7�@�D��r?���/i5��]eߺ��?���N��sh���	7ׇ��|�m0eW���]"
,�Q`�r�¹���Q
�a��A�-[%���c}j6�g(.*G��V
��RK=� A@	�B�r�=�#�@�����P(L���	-4��Yh6�����<��:�m�Rg���b���~ϱ�>`tߑ�P�%6�3�kdb7����M��@�H�Ԟɋ55�A�X���G{	E]N�	x=�^Bi�=�C���#J��bL�bX���4|�?�={7��5�����
����8�p�X��3�qWy�1�T�{Y��;d��=f ��`�	[���5X��4 �w��M���[^k��|mBL��	W��).|�R��X�/`�{JI���)G>Q����;�q_/���M��<J�>H�����R���缿H=_�E��7�1��>������=q��M?��j�f�)R���۹�)�J���p�8{���)�h#����G-���"L{���Q��=�,�v�(�f<���ݼ,�Q����T��9v!��\��."���c�yy����������Q �T�K�B����3
*\K���cM�={I7��J5\(\�S�>�~ �!2�(�o����J�{��������ާ{�M֭�N^�4��h�ɕ��N�*B^�׸h�ъ����r�=�b��x�d5�)]��v�D��J�C�_4ӕWf'G��GsQ�Q�c��Cu�c�s��ՅBf�����U���tڪ����z�Y�mAXh�Uk�T�{�1��`� �_�ð�K�6B3�� ��f���0��f~'I�:��`j�\���%qЭ�9X�؍|]��ȓy��������7�Q7����"���|���=`�zfy�M7XV����/=��;QFn>�*�H�=D���� ��M��󄭵��D�/�	�ل["�:�O۠�5g�+��1����_���PTҦ)g�&c'm�����p/<=ڡϡZ�S�ET�U/�{�-��b�a=�N����*�>��Fc���/�=^�[�n�V��{��Xr�H���N+e n uq�"��{�7�����ڼ�sq�μ�.�qL��|D������^Z������WT-F��V�5�zU�nB�[Pr��K��tR"mx��@H�oʛƷfX&�Q$�Me�TS&��Yy�7��C��Ԩ�Zm�'L|{�bL�%���F
u�N]&�ۻP�^WL�NQ�4>&�m1����y�#���&̊���`�z������b�#��}I&T j��?K����-ɤ��MN�t����2�Nv��_��6hYzW0��&���o��E���ֽ�;_��ZP����SJ�!��u��c��x�c��La/�Jjv
:l�P}-�>�rI�:B�5��n{���ԏ����O~����pE���=�g�<C�-�)J�QI` ϧ�my�W�uI'hI�������wҋN��ER�Js��X�=��b+�p+�J�W+%>�C�F�����n����Nab�����R,���쎼Ӹ���Я7���Gx�:�!�[}�(�Bq��;��Ô�r=_<�姼,R�I�/ R�(#xF�l���O�
Yf���-����r������E,3Y�	:��ό:�'��f}�����}�Xr}��x�`��3 t��a�/"�D�_\ͺ��������������(D_9۟�m���������_������O��?��?���Sys&�+}L�;�"�S�iG"�������_�w��bCA\��=�kr���wD�r>�O}G���.~���n�#���ǁH������D~�ƾ�������
��GT/����k/�	r
�_-�vq�����7���u�ڭ�qO��1�<1_MV���,�E��ײ[��J�vx�(@����#J��ΐob����#�]JN�i��Jx�AZ�}���D��G?	�)<�&�^��"Z'���9X
��G��[]%�^��U�q�8��{��?@��:����[��dq���XԈ��Pȑ~&��Y)됹c��y�ᥜLn�_��:"��ꇯ�����������V�S (��E������q@m� �.���]-����"����R�!f�F�Nd2~�R�!"h}X:H��ڣ������7�<�(����a-�����k�ftX��!�ڡ�C]����sIBo)����3D=Y[��(Ϙ���ӆ����E,]Z;}���̅D]�	��o*� Kz�^��`���GG��ӓ�����z�����&^#����������M�����CPj�1�'�_Ϲt���|��96�1#3ROƱ���*�Dx�u�~0���.�'v65�-u�-?%���g��7QY�;�#�1���{�W�'���d¯x��g,z��×����=��M������M�'vtBV�h�#vL^��zמ9���D���W���+�J���1N�-�|F�螈i�{b��2�[�w���~���c��Cv�J��u��,���#s1���r��3�n��wπ����ǷGb���\ y9h'{ѿ\�a�݈�>*d�O~�ULu#io���Ь�]�ޑ��Ö(����r�6���p;��b����L7:����}r�pZ{�iGZ~��'���L:��8�|@b�e:}��j���z�dY�}�)���-�7���>�>��<:)(_c
x'�?;).bo�h�9�2�Ą��䤠|M�|ܑ��?9).dO���''Ņԯ���9��줸���٬�;>�����$���?�wy>��s@�2~�'6�:�����a%��^����q��b����/��X�G����> 9ձ�b ��la�\�ROH9~� p��B���>[�ߓ�,��	����)"z����Q�G$?��^HD������ٹ��o�7��=Z��{=��,0$�-��~B�g��Y����b�����'���Yx�B֒s=�G���R7��q��(�V�O,}���E/d���Y �YH�Q���Y/�.�C��,x!�V�}�Hy��]z??e��((����Y4�����~��zSi�G�Z���S�c´�s�x����1q�Kw�jA�����M��^o6�Y����Mև��!����}�ۏN	C�z��z�b�g��!�X=?��+�� �K�܏:����g�̢.�	���Sj�YN?�Fmy��l`ʐ���M�˞��*�?N,���ʱN���p'��^n��慳���O/'�?��X/N��}�Y&N���    \�2J61l�U)���8�XsF[e�W�Jm�^�`��Ӂ��.Z9֟)25�+G¹´���.4��?�9&?i��M���5^���×�l1E���J =�B������~b�!bۺ/���fN�h������"�<���=�Ѻ~�b�C JӜb0��08��c���c������1qO�b_�M�ӻB+e^�=��:p�Ҩ�K�aO"��r�u�u�`�8�.��r��W�̛��ƙSY9b����衸����M�L�,�is�P�`�A���{���x�5�Q�jy�	���T��<:=4Μ�ʩ���]��d{(�x�p���.�_U?�@Ү7��W�&Ω��v���&��B�d�@��Q亡��oq�¹�Prc���fNc�\űP1���Y�;�x]We�#Q�9��k9��k��y�Q���{�Sv6��1:�rs��ro���V��Uhw|�=F�8R�c�1;�g������
����q��̹,u��27<�焲�i�d4i'�Y����L<��\��=?����X�c�A4��)�c��� 6�I�<&���6�/�e@��6a���Cy��Gt�0���#q�#'�e���d�~?`/`-?È��=&��y>B�i�t4�O�!�8u����B9o�M7y��jG����R-/�0���p&����^���^���`�g�ђ���1���y�QE`FE�����%T���VN7a�T�Lv���8�o��#8��ǉ]弾�W��m �C���ĩ�ɉ&��[��N+�XK>S�y�@� 8fv6E�9-��v�@��͘P�n�V�z��x�N�'���V3�<��҅��GE�|?5��G��8�>W��oE�\������������d��e��Գ���P��RɄ�+���'�P��2�D�p_(��vG/u��8�.�B���W�¹�W�����Bm}.e�4L���>h�]��[� B�IW���3��4\h�\�|��bu�áB㞃��3&v�/lLUm<E���;?k�Q�'�sB.u�SmT�hc��O��M��s��T\���r���9�J������9��<Y9վ��������s:��F�|����ܲl�Um��kqK0��ĩ���X)���?g��==m	!��Q�=�i���Cڣs���\ᦼz~p5f��D���?���A�����mt�Wr8�S�<\Zqzs��b�������EI�8J�6J-b�9��%� �=�ıˣ��LS��!t��ɹ��K�\o�1�#Br�|�A�Uw�K��{��iJ,�xNK��ü���������	�x����ɣq�G��E��@�ԣ��}�� ���`���t��ڲ廧+y,��k%��}��A�<��,y ���STzݯ�#w]�a�ND��n��Q����S,d��0yP������݃2��K�ì�DW:��9�vN�ν� F>k���O&&P��@c_���K�&�U>���~p�����Q��E�F:��Y���{���
�Y�r�0�Mm=?M��Y��GU����C���������7P�d����3r�UƸ�th0u��Z*���y��N�gNm.�^��D�s�+�8���{T#��?�z��<G-r��� A�Ϋ���N�J-\]���S\����)��>M+1�8r.-�bS�wNM��r���M
����!�l�6�<�E|��>T�wۃ\_b4�p٣�em��;�`,n�ܹ�h3�cT�\�s��5��Q4��_*���}5=��<����0�՚Uχ�-�A߯4����״�ui\Wƺ�[��Ҁi��������V��2���e疻��˘k��t�1lx��yp�G��5�����X��H��^e��F�o��T�h6��ǋ��5[���7&���
p������"_�e�iݝ�V�dh�O���^��|�����t�?*����L鎵7��1y��[��%��R�鹮I�C��K�\�ƥ��:�牟��L� �nkU��s�!�K���}�[���҇��?��>A����7f�)�RsJ����}�z5����1��zH�cj��M��w��r\�&H�Jۍ�l��;��,7���Л%h���cx�;�߬�_��1ܫ�7��(�{[���5�l�_�r��q=��r,l-��s�U{�X4��(��cY��i��|qj1�%��u�T��W����-��L�>���U���怶��B��9S{֑z�N%'�yPS���;�*g=��Ա,��fϚ�Ȝ����{&���Yr}��zM���z���,|C:0���5�A�z���b��#���4Y��!O�B/HaAK����y'κ��9icˉ���o�iL.�����B���������!��'�n�9�`�{�:�֧s5���D'���5J;N񥸍� �>�w�C�ڰ�:Է�4�C�κ)�
���yF�Xu'�o�-s:��đQ�w������y�(w�?O��@c�c�휴M�ӱ+�nw	x�8��*�=��,�x�V�����xnE������>���(�;�U�����}Ҭq�!)V����g�Q�%���&P"�8��Y�'�Mc�Y��p���!�(9�f��J���7�8��sΦ.j�;px]���xH=��a�Z����qV�~򴍌�k�Ø�~��`�^1b�cThw�r�����?���Ef��K���5�/���x7Tgu[+={��l���Ϟ�E�a��zp{9��˸��O%\Ew�Cp0��AKgm������F.�a�����aha���ޜ��gi��!�B�T��j�a��m�S5����H�ǝ08�<F��_-�I���͠=��F���2k�x�r���i�șV>����+����&��_�.�-�2���|)0�����yP�\U�S�O΢z9}�;Nõ��d_��Rq���YMՅOg��򙟖O��'_��������E��q��{��IWqe8^���vD�=x���za���Fh3_����!���6�����g��H���r�[�@�i���<��0�>��ҽz��v�u�1w�Õ-��OO�ZFs'���aP}�&����n����(�E���:fܝ��3ii����wd�ɮ�3`_�^8g��Q]ߜ�����0�
��1ysVp���6��eq�py/���a����yp.�0W,���w�Y"G��bvv	�^r7y����K���;'O>�8���,��;M�����[���q��^������y��}EJ"�跔�4���Y¾p)��y5zuFp]H�x�����@�gǤ�4)b&l�`��_�{��r�;'of��XwVð����ܹ8`��{�~a��>`xp-��hy����9�lH�hw!+�u���#:yzN�������V���|%O����u4���-�.�YC�P�~)Μ�Gy|c��Z?i6��r�<#��mYei�^�<tq��A�覷� $֕�.5������&�a�侵�v����\#��W��y���\�1(`dl��������xlmrv�<�|�Y^�Q�n(?��1u��W��on�ֲM��Z�?\��1̬��7wsk�.�g ��]�B��;&�s�V_�ЃW��j:����GQ^�t���Pm/)�wc0��S����2�bN�:ȵ����r|sL�6x�W��-ʛ�L�rm|�.N�G#皣U�k�tz���*&�s�۞�ȹt��ϓG-�J��&������Z>p�Z����"k��fE"�<'7��#�,�GA��s���9�Eu1��!ɧ1��t�F�?d�YW�9_�ʑc3��N���+�����sri��ܻ�9����9�{�~����ڦ��=?��T#�[�T���S��@����r��:��Ze+��%�<���E�+���y�a�b�he�x�f'�=���Q���wŵ��vw�E�m�1�y�̵t�h^�/�����u�#�
>�(�S�_�H�1�0|5rar�<�ǥFN�,��������K���wa��=O�q�s��/;�y.)ʅ"gb�˞��&�p�A��J��оF�*(� w��s|\8`����    ���H�p\$p�vm��~��.���`�e����#���k5��}�b��b��������o�K���a�_V�{�ܽ��s�M�]�i>��0������kr�y��ˌ��X+��gZ:�E#Ǥ���U�s���'�9?��&{N�^�s�W٦���fv�T���P0˵�J?��>/�G�w.4�ʵE
�E>�ڻL�)]g�8��^Vy�L"�-k�.���^>Ň��_�^h# ӌ_��A��J�0&���8Lڔ�A�3LMf]�]�k�uD�9�PW��d���B�z;�mY�o�<�w�p�EpM�0{�E�O�c��Z�{N����(�0�:���)�V'k�����s�:C���|1׸
;Tݡ����;'_�U#�#��z��RW�[�+�BRֿ��h��SP��|7�Z��j�L�9.�^���饏[������\L��|�|ڴk`4����#��|��������?C[�Q������~00����V��b��|��'�){�j�����vO��"�,t��Q*{�b@?��aD攱cҠ�	ӥ�cR79�f����zDG�����Tf������mS�^��aP�����B�3���容�i���M���k���Ŕ���5���
qo��렻k�����G^����L�n'���<v�	�w�#OX���$�k��at�=�//�����t���ڪ����Da?J:A��������x�|���23�����t��!�sK%��O����g*]˵WE�IW�:�yv�|3я�^l�耢��*�%M)O:�8L�N��$ 2ςv�XL��f�'w�w�L�R{�HImҼk���u��<�8�������BJ3���r�����\�=�\���9t���&E��$`.݁��l��P���8�Y��p�s�����=g}q_�Dy�wQ��%�uެ�8iI��GLx��d�<��s���nS�E�]T��X�]����))O=�s����(O=��ޠby�6�����s�ڔ���0*����#�S����u.{�:h/$ɚ�Q��lX�z<q���<i]�҉�R��ʁ3��u��u������ʓݳz�E��~9��q�vg+������#w
��H5�z���=�#���4���ns�L�q�A��ʿ\�Vau/'�����\�e/�����[���5��Ř��'+��GY4�=ݿ��z�!��Z�y�<8��[+p���0�B�~!C>��:��e;�!�!Y�-'Li�B�B��Ẁ�kC��������1�?w�1,��s��h�Xl>!�2Zw=�O���snc�TE�Y'q���)�/����?��o1�cl�=��}��{�t�No�T���>�n-f����[t�u��t���JĘڜ�=̹;�$C���H�J��ջ�yꑩE��u�I�ʴ٘z�EUdovr���0r�˶+������S�h5���/���ĺ�O[��ϕe����#PS,Κδ�������|5�β�����ܿ��ȇj�.3F�G�#&��̹_�y�!�L_^��dD�wN~�;p������J��~l�	i �>h7�G�H��Z[w�����j��1���-�#Pbt�tdr��|<��VuM�V���.#�.�Zu3U8o2d�&����
m����$Gye���dض~��_M��H���׳���q.n��#Ǌ��6w��\ݔ�"�f<֩�"`Vʒ,����c���2s�t3;�_��V�,�7��
N+**�{=h1L
KxD�\��"�;�a%�ș�u��+�[�H�z4pP6I�2ܡnɯ�y�D�U#V�|�f�/0o	��qj�t��byx��]��%v˳D��Ņ���\{���:�K]%�Kz�jS�=/
9P��,����zٯ����z.,��*��y��(&q�|1G���������sϡV��.�Hb��$p a-I����FC�9�fRC�s���'�\-|���Tf���Y�bn��q�	���U!��m�p�qz:���Y�`/l��?�BHb��Q��nlq�?������d���0�wfQ�C�!;�F���f`��[�=_ˣ�˗+����9y��<�����6�����*¥���k������2�������
�����'��9J�1���raֱ5�౻�_����E���M-�O2�����ۛZp����GA馻�P����� ۺ��1y�O�a�(����N>���FIG�(Me�m�v9L��p��:dʼ&R�8IH�� 8�ڼ��0����\w��sLvN��O�A��'_�C"�ٴ�!�_ 9�p�����w��<"�Z(��(���t��3��+�5����{��.��y�!�8<�Y^O5`��=�Fu�0vbg��cJIdG�S�ǹ�ٺ4ڥ�����U��Q���n�t"�	3������o�KY�tz�����Na�!<�<�:uW��$����D/(NR3���|z��X�b�����҇tߦnta��_\+0?��6]��C�5[��N��o9�ַ^��T���i5L��|ߦ� �%�:?�����/�g4��'�=q�ݚ]�>?���2��G����윃��0�>�p��ȍ�&)L�.�VQ�����jQ{kS�Ck���c�}^�>��k{��k���.S�=��>�L��+�~�g涖	�&�9����0|�h���U����E�h��a̾j���9RX��]���uK_��!�e=��0�y�qv�m���&��>�h���Z��u����^�o���� A[�Y�v`^��ˇ�tBu���k���П��_������8Ȋu��.z�y�Bk��?*"�G*5�j�9����������M>p�D���Y�����E%��g��Y)p��+�J����B��Yeͯ~᳋]Ijd��KI�׳r�t�`��j��$h_�XEG�̡���qs��,l*d�wL�)z��Y�����e�����a�AZ�������<�#p�a��dw��(�����:)y(N5r,��Eu���PJ�2� j���I=)���x1�e��+ǖ��'�lӷ�J����Qʇ�W'���3[��T�����ȱ����]��|�0
���Y
E�����s���#}��(��5��/�uQr���m�'κΔ����z��a;sh,��=O�x(eDĚ1a�]����Ր���M �2��{����	O����A�<�w�̱~��-�5�h�\=���\��Y?�%r�z�0&�sR�,�Fj�֥�Kx���R[����z��&��J��3�N�p%���̬x���"�Sy�}������?���S%$��ʁ�v�uy��]	��"����b��Q�6�z�EFO��x��k�J�Tkm·r{���g]Z|��4�l!8�l�kW���F�O%{BJ���1���m�����0_\*0�f�PZZ$��il�ulH���9�.&�z{J�%gZ>���H����c�R�����8i���8���t����|%0cP�^y�OZ��f����vN�ex��l�Ժ�In��~'�z}WZ�<�l���Q��8ۅ��s��7��fJ�]'����F?i-`���Pd#�a�T6��ޘr��V���S������{��4�u��iq�,�lT�xǉ��'��:>��yp0$p��/�r֝Ӱ�=���b���I�gM�"\�	�{���~�98�\[��;�dK��a����_=��K�玃i�ڸs��߁S������~���*nv�������/�C�c7��#fJuK�߰��;�/ʄ�4hεtN�"���u`��LEVp��T�=U����P�HU=�˧��8k���c�突&
0���?���6�8�z��˄�z����D�E,�X�>�:�K�@�T��ʣB��L���G�K�Z�?�V��Hi�\������^gl����v��g��(�����g%OV�ΩÜ��ƾu���|a���B���F��Q/N5���Ɏӳȵl�T�z�9�;@�
�l��MY`EQ���#c�����Q��8��tS(�8dz�*���e��-g�`I���̙�eS:�    ��
��;&_�[��F-����K
��m'����l�l9o���X�Һn��.�
����{ql�ܧjU��f�G��揄B�Os��Ay���s)T�3p�Ƴ�p�k�s� ����%ݍ/M:q{�����Qw�WɥP� +�\V�[��K��z°�V���(錸f}cdJ7��Zր�������r�Q^�e���,@6Vu{��fk���KZxM���;*ӭ
���qDٲ�|�L���Ќ�Y�[F?������+Y�����zNe9pXK!��s�L-p�Ԉ�n�.�6j*�.�B"��.�}/KM&��C93�i��@���xq8,C���?}�wBKM�<y��8r��c�T�j��C�]W���s+4:�݄Yb��_�#�ݑ��)E6~��~�6���`B1l�������Z�ê+�r��<ګ�l�kr��q��Қ����:q���g0mnb�(�8e�񐒤9�	Q��c5��)v��aĎ֯� ��Ɓ�'h?�ND�9b���Or�����c����`p�7}͙k�:On<�$o9kk-��������{&��ֆ���V���]�	��Mq�!�j?�:��[����u�e�g��pn6BjL�ƽ��ȱ���8n����`Hؔtj.�ԉ���V�
K���$r�ؖ;'7���\=����-�3�N�e������d��_]W$o�(����Ӭȣ�Z]��ȧ
k�`-^rww�A��R"Ǌ��� ��9�F����2���������:������M��0=[�Š����?s�mn�T�{�CV��iӱ[AN�����j�fȎ]���ߍ�?���ڨ���1��Yw��&��I�Pv�_'�c�<$'=p�=��d8�s��{����8�|�E���¾u��#oE<qD58��`���BDn�d)�ھV�8`��k���)�cв��c�|�(�"�}%&9.A4.����5k��w&�¬��=� ?�M���D(����C6�{p�M�򎉹X{\m�v(0������f�������(��)�]G�M�\W��J����[���re�(��6�H��&����ȝ�g�cr�c䞅�3������Gǃg1#���_���^�x0��^~�K���QD#��b���G?��`�o8T>eJue�c�I�Q�������z�ȱH��N�<��n1����7L�$0jİ�HH�"��b>`�㥮ga̴9����ޥ�����-p��wU��@��K�P�]-�{(��ύx��Άͼ���b:6s��&M-�@*���1he���0�W<��l���?G.<z�����@�x������#���@�N�hޛ�[��������f-���p�]���(��PY�m�C���n4�uW�yb����6ݏއ��'Gn1�� ��Q�eo�e�aSF�noNK�%&玃����8y�bė�S$^��8�}���c������<5rଗ�2GH(�����mB�rw�����ʹ�힪�5b4Q�����*F	����j�^R���:�Wo`�-	U��I�=ty-y�h@�M�T�#���������o,��'_eY#�&v����"��t����m�S�	:�3X�b��P��N�����A��{�^Տ��N�hּ�����/��--.�8���&�r���$��ߟ5���;�ǁ
���j�ϓ���K�q.#0Gum���a�j<�AS!'7����9�(��x~9��`>9��w��U��`�n���|����0�Ǳ�m_���W�o����8v�Z�4��9�q�it���4F��i�Y"Ƕ��[�9�h�e�Җ�[�g�À~os��Zf�=L:au�j~fOEd�ߴ6:����^p�K�f|�2A{p�AF���pL+^0os�?�g�@�1��_��u3쩆k"���ҺWḢ��F�r�[��cؙ����R\2�b�w�C�L�N�B3�:=qF�|�!�85r Ӎ�f�*�I�uSK����pzx�!Ũް�e*�>�5��O�o��ɑZ��ƻ���6��q��N�Q����C��CH��6�rc�-`��+Z���I�\�c�C��u·���B���d}s�Y�����E���9`>�n�����=`0f��Z��p"ޞ��{�!��䞅Ɵ�j"Tq՜�����A�~z�=ANE"O�89�yX�9פjJ����w����@�8yD[g���?骏04�h�XE�6\��:��8�4^�Gl���Yj�+�0�,uG�À3�d��֦X.�^؀���Q�$S����<y�q�9zy)�0�o��Gi�c	��rx�,ؔ���GNCO�X���嚧��Ba�5���^�|q�^��6�� ����Š�qϺϑW��}e��p?i�7��(ʄF��ioNPB�Sm�KѺ�4#�yO��g#$7L�>`���W�͑�.F�#����)�>F:�x��ӻz�>�p��q$�u��R5��[���I�p�X�"�N�b·U9�:�H�^�7��������v7�|�a�	�1�=|;��KĠ/.�Oޯ�I�rF�cӦF#_39gZ�7���PG�3�yG�(9������L��1ø�Y��+��|�a<�s��ֲ��3�}�k���ݟFsu�EY{��̥NG�?J�贮VrE�3O0���1F[�Ԅ�<>��6�E��7R��6s��Q{�@k	�����`C����P�����Z�8׭��y�=�&�ou� ���n��״m���na�m��W�QG�TS�l�2�g��4�<���hUꎓf��9�l��T�iT��K(��
ͧ�V"�U�l�s���j���Y��o��~rk)�����m.��NG��1 �(��F��0�P�$5��s�W�\z9��Ƒ�{��.��yC�hqS�Bk�y:NMcq��]��˓�u�p��涹�լ9]NO'�;�5��G������w4o(<q�2b.�5m��Dδb �wr�"o(��O]���W��{�3���s�ޕ�[�4�C�꓏�'��n��a�0�J��O�\_4>�3,�j�]ъ���]��[�y]��QQ��7�G��Y�U����ģ�aZf|���'_�w�8���wsi�#ޢ^M�9[c��h�R8:�ɂ,��Ys���9rl����:�Jniy�-ل�]cN@�t��j��ĉ1b$`�8w�f����=w3��֭���{�yG��q�4�X��t�]͓}�k������ʯy��3m�?pr��A%p�Di�-��}��>��$����lT�k�<�䫚Y}�j�ow���y�S�^Q�?�8��B���^g5�L�p�|58����S~��E�j�[���Y.b��`�K�\#�d�>w9Y���Y�IW�IKL��qaֽ� B�;&ʝ0m�ߔ����
fL#)A{�Q)���^JLgm��HQ���y �F�*ͬI��AŚ?m�a!�pЄ@6j��=��ϵ��(VE��>�E���qaP���A���B��8bL/��꧛(��X'δ���/�;F��R�ɹ�A9�Mf�����7���sI�TcЈ�a�ht�w���˞�#\��Y��\�fX�����k��F��0��1�c��|q�4��>4"�FPr�|��Y���IS׷�L��@4�8=Q�+�=M���p��Y�����U�X����j�u,MI�.�����JV�?jB�V�},ܽ���|֔T$��E�#4�70J�yO�״�3�ZA����4��3��b��Ե5{�H+.;�r,K��3��:}���2zF�i;�oc�\z,l��:&��>T��9���u<pd��NRBG��� _�.��5��ȝu.��\.�_5�'�	r*�t���z���7�j���t�㘘��fu�̢ΑĄ�WK��eCݳ�LC�D�V�7�w�(lC�{Su�|��	#��]PBR���"�S�%�'���"��D��/���ipY�`F��Z�$[x��a�{�\���鄮;��#(L����SM�~��:s�]�K.�g�N��RBј�P�o� 阽�;��W��P�捍���e8�e��"�S��.ę76    ���?s9ؽ�B_Y�fEc4+�6��D����C�e2�N����'!�Z��m4���76�S��܂6x;}7#`�i'��|Ϭ,N�o�9�&a���x�����_/�_ӭt��u
=��f�F-�[�rL��\M�k�ss�8��>A�1�{��乙`�U�{Y&н�<tr���o����02Lms������蚥�]nfq�D��ȱA��� ���� ��)f��ۍ��7��͟(�*4�0��^rG�#㹴�u����O����V��1����54=o��u<��%������W�a��GՒ7�2lv�W���nq;p֎u��!���Y�$������߁����MY�������0�0�g�t���}���X"��\�V��s�B�"&��1���ky$��3�O���_<7�NG�;7s��!=r,�8l���ɽ�f����������N��%U���u��a�k�5ϡ�s�s��$�z8���揊�.[�99�F��~���<"G�Iw`����6Yf� x�Pu�t�j�G)��A[!�Yܮ�T!o�9d�����'��M�;N�^�9b#ͪ���3�ԟq���q|�z��-缫p���0�xq�T��+��#n���O�W�/B�zόr���xH3r\>l���M^w��⏯��&��dԱ�l�~�3&����ܔZ�-��,���FX<���C�q�ș&�W1��q��8�� �9{ٽ�[��[L��6�+�Q8���w�8
���M�'�h{���8���ϴn�]w��sG����!u7�|��_�wX�8�<��F��I�*�7���n9c��J쎈��D�K�K�wS!�<e���:iu�"W-=a�k�?�C��@Y�=&��_�0M>HL�؇�P��k��A��s�s��{�Z��e,i�w���x�r��X�e|�����z	���b��86Ln��;)8}O$�h���+��,K<��~�sݢW*?R�A;���Sj\iݵ;�a�o�G�_#��7]�J����\%��<�����ts��f|s��bл��+�H57��`���4g(f|��,�'&h�arS<#�B?4-�����{�3���qޭ���1݄3Z�Kԟ��l�ܥ�q�#P����xN^�7��DL{~��Y�w<s�b��	��	5�������7hG�:�z	ϓ��G��%�w�m�[�8� ��4��͸� Ê��:}��!���i���)�&�ܵ�sq�e(��5��S#���B����vH̏�;�sm5_���`m�ub�-ꃃ,��� w�Ň�^x56����u��~=���梖�Z6��4%�r��r�qP �����b%�ɽ���L����<!����9���:<'�Q���W�^AW���Y}��)E�%)��5/T�d����IlzU�ɋ��/f5ib��:�w������>t����=��:#Ǻ�:3���1�g�+ݫ�k}�&T��yu/W���˶�,%r�,M����:̓|���!��ư��']ϳ��a�'H���Ƞ�9��ȱ�󹾍�
��٥��>�A�'��~[ �x���c|3ε�up~�#�E�z�;��8�o�@����ħ�j��Rniz�Y��x�����q�kF�Hę����%rL�����̈́'�zNnn	��1v�9ͪf��9i1܉3������N��w�i�K�������)�3�;m�<,eOA��I�r�=L~���D�*�&�Yi�]�+'{뎖�b�"��6�`�3yy����>�F������V!��∸0�F����0��G����.�^{����W�	1�U�Isֳ~��k�TE��s*N�9����\:���1���tO��|�
6�1E���nm���Ԁ�I��<hgܩf����u�[w���Z�������}M����	�j�n1��(���tI��D��¸;#�ET���������*����P�9�O\_>��	�w��g8u�����:��[8�w�.o��׺֍��▊i)�J�L���{V��c�nB]����k���gA�����9*4P!�]�%�fC~��͝��MW�d�i���N5��xÑ��p��`�����u����h*?=Pbbb�)��`�A���c���J��r�鹎;�e��Od�+�8wɪ�c�E�M)m�����C\��<�f<q0.�ʫ��s׾�8�d�zc����N��[�`��y��7Xh�F/�[���9wI����x�3���^=�.~uqlr��� رIm���g.�%�Y0��q����3:��u�N)s�����h�䱶��~�H}�g�X� cd밵��Wyr���}1z�8p.u���?��#��*H@��ҩ'� �^r>)1�z� :�p�c�/瀱Q���1o'����O�vRZ���{��2��Q����3�'
���0y%lt�`*���6�0y%�/|m;�����R=�~��i!��&j��t�ee�U�%-d:Q��cҚ�F�����Ws��Z�S�0G
�"e�^(���p�p�[��8� �x�/v�/���{�P�|7�S���u}�>o%�mD���%��p�9���9�wq��wz�;0�Mgy��>�v��|L�%K��Lg�����M��4����+-̛�N�2�ڝLK����o������a+%�j?Q�}m�<,f&�W���c�F�xM%W���c\�hA@��2��L߅y��/L����(y,�{'�Z��u��?w˳����!\jڲ��9���S���S����w���9�67���i&H��t�߭��WN�TwL�j�1V�Pֳ8��j~�;pFC@�q�v���Tب����EN������K}6�R�<ό����qE)-.���d��H75CG�<;�]�MZՙ'H%r����M����W�#T#�J�DF)��ڥ�Z�4��b������-�01�E�[>�pR�j����r:΋���g}�I���W�[��TL��'��N�ܬ�E����'���>��F�}Ss��݅'L'�jn���/�#��@���/Z�s<q���ɓ��`�M��+��D30/�͙sa���=����=�A���
���J�N�G���@���pU����[��>�O�,XO��&��QX��A��[=x�8�XLO��[��J>`FG5҆����SQ"Z�l���/���hs��V�F�@~4��j�E�r2.���KwOCo|àłX���F����0h�[.Xu��ͳ������{�U|�_�F�X����"��V1E�^h��MP>`�����u���ib��Q]�O�N�3m>�R�ܷ8`T���,N��}&A����u�h�>nC���{wZ��R���;��c�-=_й�KP�7�R>$�د�a�"�A.�U�6΋@n9�Z�aS
�|#�Z����ܵ`oI�uDá,����鯺�q��44�]��!�+]�\���m2�ȱ�n��z>�p��qG��F�으���!��G$��p��">��!��5R,���vn�7�ae)�#��49NZ�7�Fΰ�>I0�#w.�E�5}�AR�qr�,�b�	F-Opv���9`�ʙ���\����0�+@�Ɇ��8�sv � �~Un�BM���Y>�A��1k��c��
��a�ho�o#�/�#��Dm�a���ǔ��q��RH��?����W�tE�����6����J�t�����d��~��M^����/$~r.vF47���I�5#���"��i���h�K5������W_�9��(�I䴼�p�����G��1Q�d���\��mϙ����/9�!n�_m��K�5yW����¸A-)���1�ث�[�[��ah|� ���{��c���︄*�{Y�쁳���׎�F���Yӎ�/�%��/\���p{=�R;�0�U��n��b|c0Dh4{�Ӈ�\"��`��=km�6n���J�����\�M�>��������GUc8��f�������.w�����Jh<SɊ��;*��NZBE�uRf|O労~B]����J�FB}��>PU���FL��ԉ!p���'5z�\�V6��C�1�F�`r����*jK����oj~j��Z    d��֡<f�c��Av{��T8���tP���"��v�\%+����tdƑ�V0,��]������t���a*���c���YW��:��}�R햌�믺06��xU���q���i&"Eky�����3Q]�^�C.rWn�8�����3{�C,���qҁ�s���	�'�rvh6�~�.;B�to��C,n��է��a��P�:��Vh}<pd�^\
=����ȱi5���?O����t��Nϻ�ȁ�ᇊ����ɑc'���Ž?$#��@]�m�:u-�0�i�0�W9��ܝ��Y����{����sU�Mj�5������1E��ޛ�z��M:Z^�&�w��!o90���C"RK�0ҫ
	h�<3=Co9�ξ�\��?d"o9r�������96�����C.��i�5���d��������'0��=y�P{�m�ӹ�Ey�S0;W��@%���v���lHw�-pR�$���c����7\W��)7�ʁ�L6����y�P%r�Oס��	w.�f���O�6Um�<,�{N�"�N�������b�/�a5�s�G���CRRg�0"�]�������c�(�6s��U#ǂt���g=\�8w��ss����j�R��\���UK�����ܶ��a�A�ZZ�pAQ�n�:��Lǲ��O�=�q�s���|�Yd�]X�����~Z��F��`�M���U��6PrG�@��u?)O��s�~��u��;&w�o1b����0�G�Uи�Mq����g��u��1#��i�O��A?4G�ר�]DE��i�Eo�f?׽�8hpq��0����ȹ�/�7�y*RK�S�R��tW'�t�7�5�2�Φ�H-3`�`Ԓ9��K�j���j��f��?O���~L�[7#4�+OE�<N�Ak�(�E��,��%`r#�&�;fz�����UvC�~���������R���2��W���E��u�{���B�1h��]fa�N�=�K�ε�ӐZ[�T?,G���0���i.���C�=pP�0��w�L;NA��3���-�R�``t1l�ri�R�ʑcn���߯�C�8�YN��4��ʻ��ȡKɬyaL�{a�ي��^;k�'��C�qg1*�>uhwڿ�L9~S\�Ƅkl�<��;��!�sfV�~�P�IE;'bx��:�]��|9�9���^J�d���j�9�k���P[�n��%��P>�P[�̫�@RٕPI=�x�Y�hC���!�T<�����U�g�A6�[�G�M�B���0*i�BE�Z����WOKP�9���᪝��.F�_���Ĵ�����.F〹�x&�[�"���{���o�ZʛO�:��SSM�f�y?��^�^Y<'��u⬻�H���w�k5��r��xg�8��Ź�tN��C������M��j��c���fx�i��6�s{��=�O�tz�0Ks�1�J��K�LL����]��ψ�S�9�c����k�B�'L��������/��!,�aR�����&mr9a��L���>F��
n���ln�4�ج�-3���bӿ�y]%�*��S��{LC=������׈1	'�4g��C�-p�I�u4����u|�z'���1�_Og���Y�����V\�;��_��H�fM!R}[	�tv�=��қ�]���s�X-40�y���%r.��+�q(��������wy�l߉3��q�'�:�>��?��\V�(��u�+��d��;'_�T�.�l�����?��]m�3���pEޔ���Z�`\�X�6��?O��V�c�4�U]�D%
Ԣ�L_?��(_�đ�;�G����s>���w]�q�yF��?���N���ݗ��}J0�"���u�u�7����q��cr�4��My�/`0��Ӥ��0��4"B�&��N��N��A�n)s~��8ז�}$��}�ă#��b%�v�^�{��Μ�7 *i�tɵ�W�"���r�L��L(O�����	kR���]��$_�~�_�O������Q9�?/�!ócr/�����:�7F��8�r����2�ጸ0�~��0�I�1ݾ�X��O���;�-���i�}H�q�Y��cر%���3��u�/����4�(Ɓ���"�g=�d	k��t��x! �6��z6��ɻo)P $L��1�B�0�&�/޻�V#�߹��:hf�< w�t�\���ޗ���,��(s�������L�0[�sr�v�Ր��a]Ewe����	C�����0n,�,cZ,�Q��6��toۍ`�3z���I�1��s��ah��C�/�V^�b2��s~��Q�ѷ�W��y��h�)�g��C����Q��eG�<��W�ֱ���s;�~%\�ӎ�{�(��6�^[�uBC��YD�4����s���T�H���]w
+���"�'(�.������|�e�|XK��=�������t�k�"~H+�b���t��C]�#�#uo�g���b'{#;'U���@��CD��%.y��-f�x��p�<��k��Q�N��̾8Tٝ���V��U�@I�^�	b���Lt��3�t׮Mrax�bۛ�U�s4rj��p�y�Nrq��ZK��C,N����-�CV���V��D~H+~�g�UCO#b��窩�	����'� �]a����]��h!L<���T�3�,���~�7����ֲa.�Uw�0�;O�S�[n�w��i}@�$J���hyz����j�����]�☨Ȝ�"�l�ɾ��,7�L/��-�	E�a?Z���0Z�R{�������њ��*�7�}9�����
��S�V�7^-�/�]���y���ȁ�Ӈ��Jv��#�O]_��	�CZQfఉu��ֺ�������7Y��^�t��	�1Ae?B{~��k���p��U*e��Df+�t7N�r�����NU���;ˣE���@������F���X;}�C���"GLQk���s�A���[�%���硇���&�[f�%��!�(�5c�x��F{҃��9%���r?[���u����cJ���0ru!n���,�)8;�����u����Ϻ7�$?d�7_l��5p4�X�.���1�EKw��D�ԙ󢥡�CW(ҽgN%
t�ȱΎ�������3��������C>��g)�Ϻh��wL�a��?�]H���9(��Ͳ���m.�<]1s�*�1��$돼��뙞8��x��?8{��R�M�p�&,�Z>p�?��%a�I��Q����>��%�����Zʳ�Sf�^8rF`!�aV�ƏbF���䷾��4���u��~Tn��?��⭶�ܸ�g��h����Շ$��M���Yo<��U_�Ɣ�Q��9m��ya���7Li�~��ӳ�<g䠜a�Ryh#��@�	O'O)N�+ME˾�Q<<�Ɓ3g��x��YK�@I7����ʓ1���֯�s�%��v����z�8�]��"璎�L��.|��V��<38���0����_�����a6�*6!�?�c�_c�.�˙��fPs��CVQ)R�z@�����3��b֩[�3�2��BE��:)fk^:�g�f���.w/0��E��a{&k�k�!�x���m�q�	uF]s��W��|���F����r��*���k���D��l58�z{�2N�	�Fj�!-7}"�b�8-p���B��xN��}�i&>����vN[�/�ٕFp:�pq(r ��Tr��&�������E���~�6!���=@)�߭F�$��j���c��,ֹ��Uy����Q$�cAY��'��Q)��X{�g0����<�8|�᱅����foz.����$�$dH���!x���23&���y�~')Y��Ⴈ��I�~�~�3�O�s��F1���}!#�7^?��}_��Å�_����G1��M,G3)::p0Z��Ry���CC=ʜ�8�y�����0Y��Ң��̭�I�8f�t�ɒ%������}����L�n��[IsIA#�O�LC	qٝei&�c�'��0����C�	�g��;�ޭ������i��˰W    L0Y�z��})(7g�f�q�Y��S-��mKVhvƾ���=Cg�~U�fT5룊�Um��8י	z�`�L��6�Hס���b�S�:	�ٷ��2��M%˛ �u(3�+�b��X����3�h�FY.�.�3�{��:�����M��IΩ�T�t����T��K�S��/ҳ�r*��q�M��d��>́3�7(N(�,��M�-�Ɲi��=�ʧ���E(�h1hs�݄���T�c���6��]�s���3��u�v:7qq�ql"c9{s#����^�zq�U��~�貌��q'�DNǦX~t�1͜3"�摢E�{β�37M����Wڹ�8�8��0.�����u��Y����`��.~��������K�TzČug��鄳6*���
�3��^I�k\�8d5e��b/�d�W�������ڞ��w��C/��)M]Ņ���fy�R�vN��Y�9�`7RpI5��(rؤ�E�Ӣ�jL����������O�ś� ��w�J����l���w�d�5GNG����lP��ȱ��2�m"0���{���>}%�ͩ��f��qF�}���/B�6`ց���H~:�*��qˁ ��^/#�h�`7r�U�c��{=�����\eQ�+D_�&#�_<b֭UvqL|aP�'����Nq���w�����"YC�z��(�u���G��H������.ѳ�kk:;qaZ�4�M%r�uIӌ_�\l�3#[��Ɋ����:��J	IG'~�r������N�I�ǌ����ff,���!�N�r
|L)M28؜-��d��θ&�i�g�̗r؝ːb��ZA���z��#�ّ���$�9r���g*:�I�NUC,�x��=rֱ�+:q~e��K�82��z��Z�#rm���ɧ���1�\D��%,�����Q7�^��T����d-e����w��d�GN*	�0����H�X�89�|#��$�+=R�{���C~�J�tS �:�V���ŁC���FɃ�T#g�Trr}���G�N/��ിr���8�w����h�Q�z����
bG�4����=.;&�_P��;Ԫ�C������ѿ�Kf��Yi�U�:>`0Xfw.B�6�0\h썤�fEq�3�����^�?Җ�#H�Srs�8�s�OT���Wss|�PS�S�#U)����j*�n��	�H�$�%u�}c�P�ST���ɴ������:LV �0�@�Ꚕ�l�K�T���A��?F��V��KM����~c�L�<w��H��hY֑�U<�Rg�4r�)� .��ɒ�T�D�4�H�>84Z�#8�A/�q����Q�m��4�����-p�U~�?�ϓ��;��tŻÄJϛ�{�4S���wG�m2}q��zuѸ�����'�2��8�~I�X$o,'g������\T"����a�"�G���`�=���@��S&���`���S�X�K��#Hx��u�p��!�wਲ�y�B)�z;��:m�����g�s�W7�bP����I��g���x����.nj�H
�p����	O�ɴ7��zkJ�b��`RAu�w�󈘫v	QVg��a1�s���G�E���r��j��P~X��0��A��]�q<d�n9��><'��q<Ի�7��,�͞*�b�n� ���<'/��xc�T�]���!�'���
n��������c#!��W���a�E�B���ɾW�٩Su5�X��6${B����%;��>P�r�ʓ��=�fA����V`t�����(u�˖ 4���*�#wt���Al�%u�=�3umI���s�d�}.6-��KK�j��'0���)��:���1��&O�0���]�f�p�?��}�-��!����!N�9�d����_��j�vs<�O���c�rs~1:�)W�++���l��[6����h>F��p�t�ԇm2��4�q l2�X]��y�|�^V2F&+W�Jq��49M�7'��x�8��+��C)�T,Bǩ�;��>b�v��l�[K�%e��u����c���c=vi�a��7��0s���Lp������kg�Ȼ7|	J�}�K���{�����^s����[ڨ�b�Ir3"��BjЭ�������9R�p�.�4~����������1��uȌ��v<$w-�c���U]Y�0���5�p0K`J	�'�d��k2��;(V�C������GE��ל�J��NG��R�;&�L��J��Ր`~����wm��3�B ����3Kn�o96U!�WF�&~՞@�����^�u|C$�������V0&�d~J�.w���W6�@Rܽyg/Jo��=A����Z���5K�0\pT�e֝N�|H28���y�57��{](e+OE�j����g2���\���bx�n:�����Y��8�����ұlȫ�.y>+�q�����ɘt�a������B͚'g�݂N(R�(���������Ӽ�Ɔ!�5��!�x�L�sOs�t�׶2#+���0�M�3r�}�Ѵ�#�o���W�0[ބ5F�5<��;�i�1#:86;F·4�#�_sy��^��:6DC�?ni�k�oN�_.A�Vn��NZܾ�����K!��;�k�����m�,}��D�t�^�Yz�L���F��+C#F�a����y�����V3�,�:��G��hu�/gϋ�����f�g=�~Y��Bۅ�[6٤�#f]Ϧ;7���`�M��=`6)�Ƴ�B˨���1S��T,lVf�m��/�frR�rk<k�4�9ag��Iy�△\�"ŵ|b�u�tf���~�M������c��m�?��ܱ8p�����O�YL#���w�pI��Ɂ����R�)Y�T�tq�,�X����ܹ8p��tR�3U,������g>���_��~)s`Dˎy{�06d��=͛��/��{��b�~x�RZ����*���Ap�<���!P�q7ɫ��LG	�p!���=x���W���9ҫ��F�c��f�P�Na_�1�c!�ݻ����zɯ��_�69}�<x�����]ٔ<�6=:�V�^�[Q�Z"播'?t*��h��2c�\r��{��|�s��ϖB[�t2������B�-g��^�$��5{�9b���+>�#S�9r����#�!+E�-���?O^�8k�"��U�<4�D�M��au�yX�#r��뢇y�;'_���Wʂ(c4w^�����L[�s-C�n�FP��⎃tQW�5g�)�F�4_�3����Cx�L�D�BXK	�V.ǽ�k��yf��Y�]q�I�L%
j��S�����.�LWs--p�ˍ�����I;Vj��Ȭ��]ә�ʵ�7g�u6t��	���%����4]�'���������m��j	�^��FS'㛃"Z�c�ն�I�}�HİIC�E�r��ZF�`�|xߩ9�.�Zf�t��6h6��"r�k%��	Ə���x��yW����vUQW�=��{,Gٓk��ƍ��b�Z������ě?af��Z�#�&�?��ﴤь�7�PK�:���Z,�ς����xעc�?M��@k�WJ����&I���sW���H���!۫�T���r�0(x�7Vz�T����6�r�]vMk�=�s��%?|�f�n�w����Us]{�����:u\(Vk6H���@[�����8���M���a&���㤾s�9͜��Gc:��_����%�c�m�<�w�A=���׃�Wu�K��G�5O��0m2$=7LZLl20�h�X���1�i����
x7LZ�<����ȱ��ר1����f~n����@7����;Y\sR�ڲ��N��Z�-F�$��	j^����&}��r�\��YfWH�A�b{ͩ�F�..�cT���|���1��f��
�Cw)@c�wi�W�`Fn���06�B��=�K����(8���.��ygap/����xw�Ԟ�ͭF�Y[�O��4>w�X����K�����{�>��=��>q����S���z�P�@_Q�Q*���sz���Ωo\��i�a�l�.D3���fVl�a�dI�s�TE-�{�k9����    n����G�sza�4��l�晿�uCJ�z�P���Y��(�"3����MZ���%�l��}/(R��q0;��2��p���S��huc�D�:������lE39��An��tm=w'��e��<!�����ML��L%k�;�PX��t�la�Nw��`�����z=u���6��^9�Q&�~����ǹ���U��5�VuO:�lh�(�S����H>��?yG���d�j��VVC:}d�@��"�{>��z
e���TZ���J������똩H�w�	���b�:�ݑ�g-�13��LIˬO��"��cϦr�=�`(cO(@옇��=�����I�fp���S�_�~1�7�r<D]�b���SQs��:�.w��(�{5!�{ʺ���z��/fy�jl�<|��#O�����u�t-&6�4�j�㘴6gy����c�����ꇖ����>` ���5�V�]6�8l��^���_�|V~8qtZ����#�p�Ź�c4��j�m�u��Vg�m��Z���O�����<2C�h��.@�t���G�؆rV���_���B0	S�]��![�k	_��A���<~x˩��VLz�V�b�ơi}r��D��f�떃���&��U\�8���izNZu������#��?;[�Y>�j8���UOO��=lwM�j����؍�Շ|e��A�
yOv�mbS��C��
�����rfD��Z���<��s�X���1$�^?Ͳ�k��y��͈'L_w��&P���68�C���o���[ɻ�9����=n�8y��Ð[t�a�/���V��m(Rxq��O^G�ZE7��:����7����a�cx�$�vL�h�0�D�j�_qM%�N�	�����<��5`.�ɵ�Zq��!CI�$�8t׍��Qs��8svm������Yt�s�K߁31�s�[߁�hyꎓ��p���`V��?{�/0�J������f�o	����������p�n��ҡ��*��[�-S��P��2�9�{A8��3��~��<�K�8��8y0��QnD���ۉ�L׮����*)�8�$տ�<�A9W�F�?+�T�4"�g�V�3a=/�"j�tuh�������>�=g��yL�F�ia�2�x���y�D���2�ս�_��Fΰ��u��ӝ�Fd�9j:�n�G������ͱIҵ��&?��X*Sଣ�x��L|>鰲�V��9v�'oQ<q����^����96i[�m�)����Y���]��3��=u��)�V�~?6���΃�t��	����x�J>��hڠ�Qj�o9�����H�����q�nw!W�d��A�����w�<R�	��KJ7�Tg�s���nrV��X�fRF��=�w�6S���q���ڪ��p�TZ?&<�����J/�%��L��v�J���� �TZ3��q�{�N��:
S��<&�V�S�l���6t������r|X��Z��f�>?�L07�b������^��L/7�im�T���&2����Hn9�Ԅ�UE��._k�fc*!;�1y���cj�?+7��(�qz�;��9�7~�����Mw�In�w��Mhէ>:[���3?�X8�$���η:���T`�j�uj�H)����)�������u�V�<#�Oٵ�.�ՉKV��sj��oʵƜͭ�W�Kg��0�_�8��r��!�N
�k�l���qZ�\�����A����6���D�v�=�h]$y���'�h��4S�y�4�Z���W�`3�%Px�fTn��g�sa�\'�AV1��������1�7�l���������G������R��ӵ�v�ܖ��o�#>+�U[��;'�Ç7��eAg6˶sr�|�`�zw~����!�3Q�ׄ�cb�!��e}u���1�u��AG&*�H|T�!�8f�X���(D�9�j9��M(&w��!�8�y��謭�����;��hG0j�]����aP*��:&O�3H9�k��d�4�5��t��vã�R���\Ci�|����fB�t?��CB��4�sR��:�Z�r��N����]�媎��O/n� $!��7�2��H���1�N���c!�3�wC�3}�;�,�[t�Oo5�XE���J���ʳ㷜��x�g��������������0	d�Z��=���O���G����G������H������]1C���i9݊��R��{��1ht�<�a#p�\z��4��U�%I�G{��s��ΐ�[�����|��	3ןm���zx�:b�0�ފM6L^Mz�L�כ;&O��b���hPq�0y$c̀AT��ø�����[|���s�HF8�Œ�h�����R	�{L�Е��0y�c0<b�,��w��lf���pq?*�r��`R���V��w��Ѻ)'���%����6� 5���0�Lr��58_C�[�W� O�_���1��g	sr��=\�P}�z~���o��P��=N{�6�bHZ�O�\��^�/�1Sv���a��fj��[��0�~�P�8Pd�������#XQ���樻E��6����&�x�0���I��w�桵Ŧ�m�����kuO�=|^��7����&��w����Y>�O�|�b�-r��2 ��8y�bR�t�O_���W�>�l�y߁���f�;�s���H�4�Ce]���~Rq��0���z���mq��K�(��C*y�3�,�p�>F��9mֺ���B#y�b��s`�Z]���]�cq˙��	;���в�.�a��G1"犠�Q�7*y���)�Q������(zBwd؅��B+5p�������|x+-pֵ�Sc���S�|�Y����8餡V���+4��}�4�|� ���y~�~�=�C��mZ�V8p�0A!�����V$p�ZCD����>F+=p�ڠxm=���v��ABkm�&�N��z��e���� ���Nk�子�����r�JC�>b�f�<lf����G��y{�n�3}����""n�]����=�Ս�i�sȞg�:H�>k��B�8���u��\��9�&`u�~}��ŉ�Z��.Z�`�[䘨�2�}���j>����}��=�a+;��,�A��׶_�l_0<��F닠]w�Y���v���eO�p���fG�UŒGM�b}ä��F�������0�!�c�q��n~����#չ�紫���y�`�훃�F����j�:7����8QI¶�ÃsW{w�L�*�"��N��+\�	;�y�C��6l�
��vVݸ�N�J��_=)��
G������Z!�Fgh�4ī_�?m9�%a�ɣ$��X( ����}������e]�Ͳ
�*�UO:^��%u���8C��7��[�fQ�ib��� 8�.]����s��:g¥K��%u"�u�i8���M���Z(C��Eq&�}?�;*�R&j��ԞW��S�MHޟ��ʹ�CGS�u��#W���e
�*\��y�V)P���&.�Ѭ�29��9�if�&�PU���ջ�Ԫ�6;3��3�ΰ���6EˋC�#�q]p�f�8|� �[���7���f�AA�?�����р�Թ�}������l��1��:N\��thKK�o=J�M�mq\0%dLuw�R��G1Ǵ_�.�ʢ!ՙ<Ϧ�vq�2�C��\�&����k$2���v�R!�����{���t`�	#͂���V���3��N�/>����ا(6�De�M���P���+���<��In]n�@еx{�����r���6e��]YV�4�s�<�������7J���Ѭ-������w2~a2&��Ǥ)��66�S��U�n�4M���ʈ���(�卓����h�M�\D��
�(�3M�X����m�-?��l���{�4;�����<y���>]f�s��i�D5$]ܮ�I�g�����|�ck#r�"K+t�'7ʷF����w�����a�0��Q\*�q��ݨDNG~p4���9�~�9�J���+�n��Dh�"g��l�A�?C���F8b3ۚ2{�Ǆ^����2b(���{�< y����s�$��]����Y\#p��;�    8C��[g�c��wa^.<�<�y�@����%i�k#���O�++��'�K8�����o���I1�ϱ)�/L^?`A�w��������A�k(��4���i�3�/�L#�/�|9K�.��?��maш	>vT'��{!S��폿0��)ur�"�!�y�Y6���U~�5z�)�P��V'�ʷ������@���b��^����;��\�Q�������#R0x`��r����s�QR��T7LC	&"9;&7ʷ��6��]�=�<�:�L�ӋW����3f�b�M=� o9؀�*�Q���5����W���0��ֳ��O�4���R��o�|?�[��պ�m���U5���l>�TtB�K<Re�{���J�ή?$<9�*2KZ�z�6��c�Y�N��e�����D����P�w_D��ظ����N��M�CR���������F3��:����s��g@��?O���0�]�7עn}fڬ{���!\�M�y|�g�P3��T�9��OJ�5n�Z��sg���~sx~f��ҹm����#ׄ"����s����n?�g~�g50���Q����c�\����}�3>�P� N8?�,`�{�&�g9_�����ul��Ĳ�s�s�J��E"5���*Tr�,=rV^���9��O4r�ί:��bTv����#c�͋�6"�8C0��q�t���A�`|�z_�y��y�S�i��e�J��:
����7(���6�1�ڭ�<����x�g}�^Ҍj�3���EX�M5�{r�����ȓ��^s�֧�XgO&���i�΁�]}V��&�g�eO���ws���^<*ks��TSQ����	�}�'��*�Y��W
v��zͻ��"��h������x����}�k$ٺW�#��ZAzH����0H0�>��Im��h�b���<��%`��^��A-�>q������e�sP�Y���� �=rlt�bT���-�>q�layR��{l�7N.�ںF��	�����Ϻ�(�_H���{̺�5W�N�`����К
��e��J���	���Z��H���9g�_���O�z,T��{CQ�r��"�4��m4��^yM	�f��{�+�+��٬��w�+��0R�S2���eS��lS1d�{Вr���0_3�ł��%����m�'���kM�����Sm���"L���\S1L֝���y��#���{�����M�鬗	�质�:�kv�鷨�
+�*���<S�0���7�F"!q�פ�����s%��)� 2�,��^�&�W�'j ��N����[�~�v:ِwɞg
�8�0_/c�@&���9p0�ɛz�C$�$����cˬ��.)o�l�&�Gp�ZN��! ��������ɭ���g�롑�{y����s������Ujޣ���G���]�fN�Z����2�p� ��9��pΑș&*�&9�8z�'���ڌk�ᇸ�Ƀ׷Hs̱'��y�M��s���oλ�	�[�L��~������f����V�<v}�25睓W�n�|?�}�ڹ����b�����s��uM�^���t)Z=�3��6J�T��9}�$��g�3j��0��>��S>���8���#sV��q�mP��`�:�t�>�p9�f-�o;�nj9d��RدO>�1�x��C����[zH-�bP�1���<�w��ZR�`�xe�	%��\k�c?p�+�l�k��m����#�z�C]���}x�ð�k�U��<s�t��ϭ���8�=|��!�8F�T�O_�<-�t�W3r�F�.�ޜ��eS�,�#�U�Ët����Y#"8�������|�0�
�<��<[�X�K��{�3w��٤Nn�'\1��V/�B3�̓#��ڤ,��Yԙ�iS"�tHM�o��N�B�9�\��#�,�z�>���a?��e���X��T����~������N!���g-�������W
�mv��n����O��2X��¡���{���:N~�qq�\��?O�����$=k���T�ӊT����e��
�5��T�ѐK	x�*n3�-�T��@zr�ui�yR�L��XT=��4'�iE*9�\��龭��6�)���\⇤����%^���p�w��i�{���8`:f��y��=`l��g����v���˃grUP�R���F�С^��"�9���to�[��2#Ǥ���3�8�'�ǴO��-�?+�)~Yh���Թ�V5}�������|tR�����\���Fue��	vT�^&F��r-|��4�����W@���UN��N�>U���yK!U
��L��2�sr���<�烾�=�Ĺ��	ÓȽ�\A����,��%~h*���zd��~T^�w�A
Eչ*�0��9���6ʔ����V�����]�}TX�~J�P����s��rLiT�7z��q����J䘖�H+.*Ɯ����g����
 �'J7�ѣ>���j�J�Zm�zN������{(�Qh�j�o��G��t�5�/�:#��S�r���{�V"����ū�s�^H-�m��F��מ1Qk�ӱi�t,.�_f+����Jřż�0z.���Y_�.Tƹ�j���Z?�5�q���HY���0i�9��
7�"����0�7,�~�g-p �R>p���LŹ�*5�P��C1)tOg��-g��6<'ͦ�8��Oz�|�"5���R��3\D��h���{�B��}yf����kX�湩I�(|����8�n��#f�Z[ޟ=�?q�0��O>O1�C֏b�U���	���}��OS<aP�.�i�ka����9+���{n�k�Bl������O���Y���ٹ��9�4�����қ��孆'_׷�����A*�rܕ���V�c���[F�.����̀�v	���+�sAO���{/J�|ˁ"�����_
�D�*����A]5�(��RQ��2R����j�a�.�k��{���<'x�Y���;�O"�W�p����J4}�f�Cn���f�A>"�7q���e�7Hp�$��1���겂�K���fZ�p�S�vGz���`�H��u�3n�4p`�1?�'�x�#n�1���ι�Y�Uf����9�{1%獆D#b���1���S��\��;��R��g�Է�)���y�����N�W���<#H\B�vp���|/s��K�u�_.#��4L��[�,�e���{����5Y�JIu9�)r� ��Ax��9`��<��}���.c"�r���a-H}��C�d�({�<z��n/�r���F�|�"���2(Хr_���@���VJ��ԃQv�9ʫuX�WQ����n1��x(%%�����j�+���]H�`x��}���������8�t��;��#�1\p�#�GC���Ex݆��|���aت�M$�>
W��5���Hi��-v��Y!Zj�@_k7y����u�5��j���/s �P��d�|V����.���t�e�ϝ�e�9���[�$%���e/�ƀ;*�y�%�P���5� ���|����^��YH4`������JZ1�L]�V�w�j|��2ύ,�Ȏַ�*b���TMYԾ��GַZ���e��O��&2��QG����]����t$�D�]�[ҝ��J���^o~��P~�=p0�A<'/C�U.�D�&G;�Ȁ��s�Y�ե̈́��.�b�K ��S�˨��t}q�XZ�����s�{�t���KA��v	�~��}����c�{��Q��}}��-��R�,�y73o�������=R�8�����gy�p�wN����P�X��3���7�\E���P㈩�b�&yN���GNG�iY�A���a;k�(�;�v��ʷs����|�)���f���g}�����g��n�õ�����S������?Kڅ@1�2�N]��H^(3pH�OB��͉�2'N��\>��Y���إH��{��[Ta���V��d'�2ʽ���7r�����vͯO@�-r�m}z�r;��0=O��,�wpK���L���0�x�����-���}����-�%ӳ���cJ8l�6ٕ�y�n�$Qv��Je�&=��ƐW��    ڍ R�o���t�Q�7��_�o̲�����3���-1Z{��}�����=��T����a�u�*"?�C��_L_^���m�?y�i04��cr�"�
6�6���u����`��|����C�]"��Ϻn��p�g1FL���{-./Ϋ_��B�O�<an�ɭq8e��>�^�$#/29`�튰2j����k{"��oj�����h+�~.�J}�Ue=���l.�J}�X�]�w�����[��Zd���ȣ�t�W�8�閇t����,���<y%�ǜt�wf�I>`H��'=��@�����a'�n*)�`��*s��n�z���ğA2��E��g��ͥ3%�p$��AI�2�~��y�㉳����{Hgj��ч���侅j�����)�;��Ka1����ܷ9��/�Q�e����6�z�e�Q�:��؞�6���A�gy��ERz��N�4��zN���u�T���������|0N�<'����_�T��F���,��c{����g*s����{���1D&`G(��9y���3�zC�k*pCC"�DJM.��'5Y��oÇ�f���O�A�6��qc�}vs<`�uڋgz}0�3`P1�pU��\��g�G�k�G	�q���ۜ8��w��^s_y8K���in%f�W�I���9�ڪ�@?�<3}Ww*h#������8F�Xdg��݅�{���}��Z�tPӷu�ATïr�K�ǌ+X�#rei����[���4θ5�}�Y��:�q�9k��|�!�g&'��s�T��h�ր �j�ֽ�׾�/cJ��`�{���9\O��j�Ny��������UW��I�c���b��Z���{����0l%i�'g�蒱>�F�8�ST����|?kϛiR�t�1"��>T�C��랳.`���S��{��򏽇��9�bzիOuNU�O�u�6������<��-��=p����2}S"��_�^�������8D\]��#�w.}?q���*�;?��{N���Ӝ��hî�̬��9�����?�G��a^���f�% ������?��n1�Ǝɫ���d��w��a�uc�u���Yz>+�)�nm<��T�E�Õ=��x�����Ӑ�@N=���_E��n�˂�s)R_V ����;*�{��&�a���b�{j�JB�y��=�4�\��vF����[��@������T�*`�m������B9f�Y�\1�v�$�-�®�S��癎cu&?��}T�?8/�]w���iP,�O�k�|j�NҪ�4fͻf��-G]1��=N��(���7I��3���Ǖ��-��7����uO����'y�2���`L�;�4�˼Q]��=#�=��y�Ѡ�J���M�;���v�8�#��%�I��w�����m�#Օ�tM=�{��<������.�uq��us	����9����.;'m^�]��,�ݭ���o�#m(㢑�(���]���ݑ\F�#ZlV���)}<��9ds�T�K��A������@�p��<�ȵ٘�eQ���I+����a4H���G�|�3p�����ռ��a�ezNn�k����)`�E%O(�8�h`7���4r�՛�k6��AI�q�(���y�5��jZ�9-s�J�4KS)��'͏�p�^6����b<-A^l�2Ʌ���xx�i����)�8Ӊ2������EGq?J�K�	3�%w���3M�ēK~�oj����\.����sv�%\G{ڭ�	�Y��;��\{�\-��8v��{#�j�4�t�Fsށ���f�8V�ۋ�Q��q�h�+nhI=�0�C���Z���f���^x�-h��1 n��=&�/n1PiVݥ�Ԗ\�_8�zЄ�����D���*r��7ھ�5��c��I����8ax�ܛ#Q���_�u�(�7=x��#�N�.b��Fꉣנ���Vwp��czܬ�l�""'κ�4'�57��V����2�]�E��!PR_>���w�����?�2c���Os�Tn%`0 �H��ʏ�i�g�J�r{�j�t�����EB4O#rk�3MD�*�zvN�X���`vP�:��hK���9��t�>m�Qnq_�)�Bs�Tn~�;�+����y���z�L;�&�KOi>y���r�(QB^@�L��8��C��w�y���(�����M�}�@������h���>�Z��^~��j7��P��y��j3�b�8�ar�lư	��f�����Ji��	3��m���<��e}�Bw�WN�q'�\���8j�3�mFδ�3:ɕѠ�1s��N��9���e���|y�-�T*���-G�I_:�H�>c���V�3�@A,n�K5��C����Xl��\���N�p�1"�Ź�_��6�~mTy��_�����r���uJ'��Ng+���c�!Q��rsL�r]2S�,׹;�|D&��z	?�J�$"�D��|c���2��(N�L��9�xD&��r���<#�u҈��P'��y�]L�����������c�A�h��z�+�a����>l�*��1����W)�i>���@t�B��Ì񚎓G/E״{�=���"��5]�Y7IP������� ��4�S�������#�Bhѯ��n���nc�tvwJ؀Ŀ��?��C�w7���0��*{�U5-T:a ��憙9`P�qL4W(�y�`��Q�-c�����4q}¬�ε�j�5N����Nv�����'L��������YW��_��Gߥu���Iݍ/�|,b8�$��,Ws�8o~ 0���ut����e �Ud��/�]l�升��2���O���E�j˜�Ι�_.��^�ê��͚��C�L-��p�<�w��c0�޲��H�p�_��X�"�O��c	�?��+��n}H�q��j3K����<)�1����q�t�A��e��cZ��:�-��U��h�G��Cn�GİE���5�"����S1�Q"�ʚ�z�8��JF5�݊�S��#n/Xׇ��#��ё��R E�\t�ܩ�Ŭ�}w�����Qr�p�wL�+x�h�s؏\�4�ǆYgC�Í�y��	���S� Da�g}��)�����gvrqd佫}���D��ܔs���N�~.�D/~Z�zO����Jz>TV�zG�.B����W�;j�ٓ��a��D��
��rVS���&��Y�CZ9{�e�[{Ke4eT|0��*p�κ��DoG�/��,͵/�
����j���SJ4m��];���h�v����c��'I�g�u�V��='��e����[����FSA/�D<�Z�I�nm�4�'��|�CBr�d+�&x1D\��hy��g��:F�c6ww|䭍'�,�w����	C��>��6A��Z�Y���N�Rg���fs_���,��gћ���i�:�y���a��"�i���������Q*/ƻ���m����'��ݡ�4Ɓ����=M:������U0t/V��*H m�<y�Hb����54l?>T������.vf�j��E�A��< �8�Y?�����Fg1#�,�A��?N�7�p���e�����}e�K;f]�+/�ј��{�ڻB���_�(�f='O��*Z����:��_��$�8l�&s��ܝ��y�tB��8ş˸'�S�@^�{c�lǐ�&8�K>='��v�v��B]�mH*4v�A�ga�o<�$�D���Z���K�\��ę���X�a؇4c�VRy~�E{�ڥZ� ii��T䄡��t#��x�����0�V�:�aݰ�ܾ4�P��Ju:F>��atc�.\��1�]/j��Z����Q�YG����f�:�/�i��	#�����o�?A��Cɇ�*Od<qd���۞��:q�ޝ��;�k�,��\���{}D�0����́����2$zzu�3CLr�� ��L���r�}Bc�)�A�W�ƁCJ!Ʀ9�2�Ueq?+��0�����Y���F�M'��ځ��h�������|/k�栃�Fw}��!!�8h�B�D���y.G�_�2%G�k�����Oe<qt�9�Jw�J��4β��+����e�Ӯ0    'y'or9p�%��z�|,#�F�"�JPy힎�Y~��Hw�y�>Ɓ��w�~��*����/��@�[����Q"��Yq�yN^�wǁpZ��=��|�T�$����w�?�F����#;�����Wm���p����Ay�����؄�i�]�[Ù�<}sLp���ڲ�q�HƠ�!�e-rxY��<8p�G*�`�R�����|8$r:�����sR�G=p �?uT?Px���8�q�3R�N����A�oΰ�1�n�Y��W/$���_e�"{��,�^~ڧխPwJ�g�/�0��A�/�]v��J�@��7�D�̧3�0�!�%?g���)�#�aՁ>���=�bPj)eO����c|a��Aٴ(6�|��u�U�4���=����ԶG0�C����(��:���{�:j�q���垪�7y����^x��I��\��a鼟z����c(QNS1�Te��݇_ˋ}���W�̖�0�)saPE�	��p���iV����XGiZZqˡO���:N��3r:$1D�����z�<wX.)�1Q��/��N�:
��e��5_�U�0���01=a�}�wE�N�λm�k��y�>�6	��k7S��9y�cr*���S1}���K�"#�w�t�P+n��̧�xM��xVG�+��T�ni�������P�C�a0��;�ieoq��~�	��2���7=�sE���g�� c��ͫ��b	�t`��:���5:�����W�3��J��Qש�(�Md	��}���N��g	�[�ر�鞊�fϪ�$�{**��Y��>1�W�Qi�Jg��G��SrsɺJ^�kI�U �Y�F�`�V�!�x�Y+�n�����.}q�o��;\$�m�bپ�J
ܵ�����T���R�h�J�瞃!��q�ca�J�e�����Ȕ���k
��l^�t�����ay���.��H�h\�	�K�Ǵez
\���N�^�ƺUđ���a��x�	ݙ��.�|QLD�����G��q���Z��������W����ř��+���<I�k��	�Z2c�/R��J〲+���@f@�������}?N�2�555�Rj�X��ڂ4]�+��IQ���
b�����sw�QS_mf�/u�nVҿ�Ϋ�|aڧR/{'��_��P���U���x�Ӭ��|�B��-Nj��P�XOS-�5��o��(7;$&B�n
�Լ���<�}����;���
����~��^|W��pAL{�/���i�ʯ�L��!���l��=��sfw��R8`sW ��|�a��ŉ�OW�>���G��ˣ����kx����w=��9l]�U}���N�9���t'.����s�R�fA���c{YE����y���;�C"8��l�
��a�l�if&�/ô�6�ا̼2.2�ƑQY79v>�L3��HGvǤ!���~6�a�U|G��8Wp��R�)��b2��ܕ@i�ǹ݉���X��6AtaR�,ś��]-�7���8-�Q���V���8��{sz�iv(���gq�78a:)��6�dS¤z����h~�LWNź ��G�\���~��8P�[W��ę&� �J3����N���r���Իu�������J��!�d�1w�D>.Qj���^Tj~3�i�g,�\��z��9u�c��q�f,��[�&B<>�
?r�4C#uF��落�iq��i%p�f�i��;G�|^s��,��;������������V��U�0ov3ts:fXafU�-j�k�V��� ���{����?�u�5nis�4
��c���`�m�Wg��l#Ov{'o,�&���&���ߕ��2O��9����A�W��47g3.������ٰ|h�����3�ˉ#S�_�j;���(χ�����
�B�����%pY�u��+�}�fQ5���]�E���#Qs|�{*Z��1Q��W��S9P�t�PI�Q�<l.���n�u]�1�����u�}��	q����\U��b���,�e�:B���R��*�����YV�&Jy����o��V��@�T�fzN:ٵ���iG�$��¤��[L+6]�q��0�Ś�OjE�LvƎs�fF�8�����o�����N��]��rԅIk�e�0tՌ�F�g!���{κq����̌�h����g�<�(�����6{)~��6�Ną��I2�������9��ٹ�6���*���ev�a�x�	��$��cRUJ!�61���}m�tB��`ʚI�
���`�IF�8�Znߌ�
�À\�j�*�7��J<ph��}Z��V^��j71���m�YƸ�{��ٹ�z�s�����x���<c��8�{�Nhϣ�ܾ9P[���q�2�0S��U�o��S��ٕǨ�]�'
a��NI'D[ʸ��U�����&��È�4�M��t�S��`jh)Ý�v�	s�0��X���z���8�zl�9~w��2�����4��9V�?��;�sr���;�6�r�qP)uh��*���m0�6d��{��#���*����w3��1aIn�����'��C����-$q*g�g��=x���xƠ�g�����Jn;�M�'�2��inqRq��SU%���}&�tE�8�.�UX�a8��--b�z����C>\�G�7"�G��a[���o+͡�p�X�D��<='��2���2��k��#�A��p�l���}�)-������y����4D��\}q��0���ɥWo186�؅^g<`���6�����zQ���
�A�s>����*�mcwd���m��6����Vz��ߵ�I��9�D����X�iu�|�9V�4Eu}D��M֧�ȹ��9N:� �v�ĭ�Nպ�P�g+�c�v`��L	��v]Ѩ{1���oJ�t0�e�[¢���)V�[1[U�u��9p�t�R��r-��qˁpYu5��O�N^�c՚G���=>��nm'��˫�i6jo�����[L]����gäma'�;�~B@���S��#���M{��k�a3�k�8L�Ls�h�3���3��+n��K�3Ѩ�Q�ᜩ�h��$��
ռ�1�3�!T�κ'z ���V4��`a��6�F>��O���y��B��M�~9��(�E��_O���r�J�c�r�9��?�M�>"�.psT�tN)����:��Y�V����a�5��#	]��%���}���d��[H�w*�!�9��ެ?�@eB�]B]�׷�*�v��®M>^�.]W�r��aJ�_>�X8S���t�=t�k"���,/՚���>S��AP���x��uZd�a��� ﶌ�CY�=)Lڅ��ԝ�SP]ذ>�%wa��#��*V��N���1��\Z��N�8#p�mJ}�N����u���Q�˓��8�,�k�s��d`����+�Z_�����o�kTn9�YW~7ԁ*�}6�k�����s�qUrh�f3�E}�wN���z���
��j����1�Z�s8L��w�8�mI�p�R\����eW�3�2\\6�J^Խ+��O6z��T&t�<ɮ8���\�����o9)�)�w��Y{���Z7��ιq>p&�D��yHM���by]���=oSo5EP2F���>��G�8ղ�\�A�����7�ќG\��AϷ�(��ؗ1d�|;��8MM�}�o���Ӕ�g=O!�>v�|;8�f�;N��-r�{,׸xN/8|����?/M�O�L�y���◣0�ݪ��n���"V�>�y��f�o�R�f�m��,�L��g��<�}�(���G=X���A4�~��w}HN0����$��.ψ!x+��в�\=�D0�7�.ʒ�@ʈ/|�6Н�2]&)��3��Ⱥa�ނ��9�+_N�)��m��<�r��a�;'O���q��g�t���#���*V���>�"��Ԩ�� e��S��9�����w��Pz&
���f�:����~�?�g��d#3N�+W[����>$#g����y�;=3�;p��o��m����;ռ������)�.{�gJ��9z�ԩ����
y����~���<{��L��    }Yɩ�9�=�+)�2���q�羌��|�\q5zO�����6-xaR������o�'�Զ'=Ѓ���X�g��{�4/N�_�(�ʢ �3�Ac쿉�#��$�_x4��`L݋s���������y����ֶi*.�xc]��Q�gٲ���A�?m?=`�t:���+�-Վ�8;�6L�G<�f���6-za6�=FI�5�a�M=�.����o~m�<�-��÷arwc��Avʠ��-���8p������#5}Z}e��iӮ��,�s����/y�mB�����1�|�nu�ۏ��qqz��U��e�V��s�_�C?���Tgk�N�%~�|��)�����D�rd�t�M�[�t+��"F���VٯNj�{���L�j7j-��%~���=�ׁ�s��稹��ŧ�/O�l�ژ�u&�O��|��	���W�7`=�W�xc:��c�Fs��P�K9=r&�cZ�i���h�`��@<�\��)�_'�:����5J�s���H-�2��W��eF��"Xq�4���6s-�3��|@��qF�Z��k�(3+k�ʕ��.�5u7N�^[�ȏ�*�_8{��T!o����^)r�j�#�*��,`�9���ص,5N����Ot�/�Į���[��O�zIMU��S"O�0��-F>p�W�׉���ɜ��|s�E20�[�~�潉����vj5L��GR��8�j��}�4z+��V�Og�N�����_�$�[�#�-W@�� ��S��	���0��z&�0��/�?=a0ā�ˑ���|dY9�:"&b=�=鿿������Nhgl�ԻD����K�L�]�$��Յ����4���4�l�U�M��.�G(Jn�'�ҜΣ��.n5b]�e=���6�x>��u9
��玲?<�Ab]O�Yg���ұ1'�P�	�0��������G�B`F�-΅����0���9��T�!Iɭ���iu�]��������A���k���|�boq#�5Ե�������+ǝڦ�@l�
/9yW1���c�$4���{��_����x�<9��E�E<'�g9NN��}ُ�|�bpQ.N�Ezo�E����?�t�{{�'-�1�Z�72]"��T��ā�Z�Ԭ���S?VC�6O���-�,h��0M�C���sx������_�&�~;� ko�m�:B.QJwuvy;ч��W��2=3�s�;q�0��q҉^}K�8�&oC��?On�w����#4H���'-�],e����)�R�P��Oq��5��m��Q?�����z��<���K:\��2+�3�s�{߮�pq���"�F�w#�8:�M��E�<8ժc'����C�$Ȱ��a��2cӿ�t��>Ӫ�w�7?��S��a��U�R����\� ����ڮqM��x]��V���D���FZu�`TR���QTU0�CI|Ǥ�/�f ��[m�چ�M�-]&C�ar7�#����uϮ�U���H�
?��oʻ;;��l���>�����9�&��o��w���1z�����}\_��_�@fNw̫}��A��-r�����r����+ʳ}�a��)�/L~�;`���n�Ts#X@*��RZwO��OYw����}U��s�i
�]\E�eK|��X��~S��f�8t�m�`P��pL�r��MM�}�����8d3˨��9��wO�Y�U�8�s�9Ц�X5�p�<��=r��k���ɷ2k��?E�����;�΄��3�--��<�9�2K�o�s�2��q�5Q��P���DN5e����rD��*�r�3X�9qD��#G�,c��nܑ�kG-�{JE���듈�0�������>�(�gh��qk��ei�c���yѿ�<�!8�Ƽ
d�7�w�u�ȹolv���d��!�+ؚ6�� N'_�8H:q8����O����M�&'���]j��;&�0�G���vB��/On�E#u*�҇��pZ�-�q�+�@�}�o����N�2���ʹi�/��)��)�]%�/Aą��%3�_�f^�µ�b�\�ق���]Ɓ��ہF�;�ˮ̳�u��k��y���6F{�HOw%%ZF%{�{��V�w��կK�Â���_�IR����a�꨾X�T&7��ia�Z��;g$���G1�� vu������=E=�,���Z�V���v��Q�^#f"շ�JuQS��8"��9�>�-pltz�}���Q��B�b���dɾ?ߎ�7��'2��2��w��+��p����K{}{�1�-~�S�����nmҙ�'Μ4��h�!�����8i1��8������C��s��jB�K�y:���8H�q��<{���$^j47�=�A&k�������}���t��y:�o�73F��On�yNP����Z���@\��yq�=�-���e�[��}eVZe���碣�:r�]@�\=������{����T:�,�g��(Ȃyu�m嚣]K�@��-��*�Yk䐉�A,��#O�h���k׹4�W�r��=�	�N���>����P��o�ե�#�ޖ��.n�O;<aT�^�E�Ս�2�N�8�W�_�\��z�oc�8.F?���u�0ХS��=̃�ܿ1�9��������K�u�u�����+E�)G��ǧ���+GN�sxb���Y�;�[��t����Ł#�z�.��7��!^����-3��}'��{ ��}�㶾hsJ�]D�s����l�W���K���b�u������\��^�����oL���,ec�W0����aR���=bȮj�|��s�j�u֬ˑk�༡���f�W�+S��~�����@��r��q�ʋ�]d"��T��$J��5j�X�|9��i�s[U%��|@ьO��\sOc� �r���u����g"7E�Y��ve�7�-F����g;&�4E��PF�&�pC/I���!ln]7m�iùi��1��Q�ҋ�3U��c�	U3�#y��8R�LS�������D�� ֩=&O��0�I[o��q��{y������u�H��Y����5<p�m�el���5p0:�Jm�]*�r���Yw)��*���"G~T:�u�2�.ǁ��x@@�d��)b,71�Uɉ�0����N�Eκ ��s^n�6��E���?F��q��Җ�cRy�x�M��Z���ӌ��y|�	3ki{���}JĈ.eV��a~��7�Z�b�|�k}�pL�x@�i�Y���-��Լɞta���f�U�OG	��@�	����&�/����F������g4Õ�̜�g��(��6�.?��Z�`�T�o�����p�"��ڗч���؟����]�.�͹�g�_�e�:K*�xDN����
�����^�89��s���-%ZJ�i|�;�+�a��{�<׈�*�eY��/:PT:�cä�XK��B�r�}~H�������!w><$�F�Ub����C���N�N-~����5M1����Qbj�=��ٻ�Z	Ѵ�;^�ԟh�(*���sa�_BU���cL_S&���]a�k#�ܭ8`p�rۦ��X�׏b���\�?���wϩ�#�I��
�f���ӝ��txʉ�g��%�p��_�xM�у���s:Y���I�$Z$rL�v}V\<'��r�Զ�ߕ���:w�:ku\9�?��%D����z��LK�Vq� ����2LS!g/�'�&{��<.����+��u]�x�!C�*��&��yC·�0<���y`>^�)���Ò	-��(�:e�G��C��L�|��=u]Rt]��n�G^>+Z1�yF�c��+����d?�Q�y��T���ߋ�ߩ:��G�L?�%��4�H���gZ}�`(�p����Pwa
� �6J񝾜���.�0�i�P(D$}�9f����Q.�wN���	�P�w����.��uS���Y%U�\}c]N�ޑ�3��û�6�r����t����{B���о�#%�Ȼ܁a.[[ �;1�7�8����8;yF�	TK�n�*��9Qp�U�8�Fޅ�!%AБ\$m����q�qW�����j�_k��/�'���X��i>�ႻRҺ��`����{y��8V2��q�W    �@��G�up�~���@�-�>i����ȯ���|���9@j����"hx��<��]iF�2�N�}H}��������.�6Bm%r�4��-5U�9q��N�Mjn�[�ή��
{��Z�N�9LKK�N�eP�]y>1ZFm-�
�ݦ暡ڼ�rm��w�����Q�L�xg�R����Ɓ�Њ�=,O+��M�� 籋!I�O�6L�
V�ӫ�ޑ!�i6L�j�:��ze�1�k���=�����X/�-U�¸�MӗЃî�*/��_L�u�� �������̍�o(�c�7��Mh�6��� ���7q�" ���ye��i���܋ze�1�e��~у=��f�1�jbS&���Ep��T¹o�$P���>��l%�"j�3��ߋ̱F�4����(y���8?
�WO��I#�'N�\�ᙋ�~�3#� �Ruo+��mFJ�aG��U֬	Q���+[��zL�ԭT#f⃐1��y��Q^���#r�P�8״�Rh��Hn��8�xX��l����/�^�;$�(8a�;�����"�SևK{-��<�~�\S�t'
�	ͯv�\�Gtk����nC��K��9`x�$�8�I�3�-�Ѳ���.�*q�\�x}��%�y�$r�z{U\�Lr�P�1�
�f�o�緽f�n�^Er�ЛE6��>�;��痽fbH�~
��"���u>@͝����7��:NZܡ4��Do���?diFN��$r"�65y[\"g �0x����6���!����[��7G��Pq״|N�r��Sj� ��p���mC����\��&J>)�M��xm�_�<9h|_g��n\>*�����B���1z�M�&�!�xଣ���>r��=r���QT�vO>,���Vy�"H��_�R��^3�"�p�X_7|�6M�pü1�h�.v�Ou�6o�φ��ܝY�\�j��Aœ �JN�Vr�������|c%'��Y�v2�&����0�nG���+�����fUR���<��n1�W��i�p�?j�i(��pk�˄����`r����Q�?�����]t���J��!�w�A��u��!���f��PQ]����s��p�]�e�Y�8J���)������\!4�?�룚%4�0��w��F��\bSv��q����6���T/y�ҁ��*r����C�8�V��{t����'"ͭNG�hrP�	I������EG�}H�����wbthru��=o<a�*�GL����u	d�5��U�6���ۯ�v�"{�$����SI��8��E�XS�$�-6���[A7�JVT�QQ��uA6<�}}��=����zY��Vty�gj���o�s�JT�֨��B2y"rp���I�=+���Z���Kڏ;kD���l�*�S/�M|Ȏ����V��/=3(M�F��4��D��&�D���簊��fH/n:��s�@I���j �Czq�@��4P�e�����l�� �l���!�RŚF��B�s��d�Qv�dK�����GU��N��]w���ҋ�7�Z��࠺b�l��߸aDPeA����H�M<TF  ������H^�-�}*�hꝓ*��&�yq �R?(?p!p��x�iq�~�{O���,��󁄺ɠ\L�PL(�sҁ����V��_9h�9N��~W�F�cY��b�]O�=���yr�|�`�����yânz3?���m]���u��(�s����g4L%q�<|��&��h˃�ֺ��H4&W�fJ���E;�;�0g?+�)���8�>��R��ƛ8��t�c�Uy����9�Ę��Y���׍QQ��a�g0ͦ��c'�k?�C�񀁅p���O�a���D� ����g�Ľ����rT�u�9M�o�7��$h����Me�[��3�֌S#���ka?���Z3N��~����8���)pP��m\�w{�&��-G?C��'��o<p���f���o�8dU��E�2�#*�1�3�V�:y8�K��Wժ'��a�=7̷�a*��驤��9b�����'�7vn����	�8��	�>�}aEZ�������'�<yl;,��35L!���޲ǹ�L����F�B��ۇOU��T�-g�K��6�VVo��g�(��N>�P�DK��$f��j���E�	�h�~�}��JU)r&T3�˻U9p�*ߨ�R����*4]�X��Of�(8N�:W	�(oY��ok�s푃��kB�qrGC5r���Y�u?8��ٍT�͘H2c�	�j���KUg����H�G��c��9&��9���Y������p�����`���:&��3�$wN��o9�������C�q��!SK�!�>$��u���fH<8�G���̷�h�c�uNi�w�ѹd'%�s��x\�߱��(���!�8(b�9>˛�W��[����Uz�jͩǙdJ�88��jhMU�1��duF���?�[k���=��3��/}�1��N������ ��bx�@ja��C��Ѐi6Yp�~_a���1"�>��o�����Nd����of��)��)E��Z|��!��4q},�(<Q�۳���]8K�\mִ�&Ξ�,�Q���k���sZ����𬾖�Z�2N���8<O��N���q	~`�o�����[��M ��!�a���#L��Ig �C_����bk���Y���r��Qvz��~Ď�5�G-у�U�8�U�˺���]5�������z���~1�w׿�^��W0S����W��`K1Fa�u7M3��f�澆��F�c��4����K��=���ġ���vN��_�~x��U�s"}i��=�Q�����R�I�g*Y)���r�w����\<�+�OPi�U��C;朜�hP͉�~G�k8Ꙋ��okZ�7�����:��2�L]_l_=q}��=Q���}�y܄�Z����q��On�C��&/uq"�6�T<���QǱ�F6���"E�XVȸI`����ba7n�W�o�8P&��zA��65�x������j}�yܤ+�!膯��j�B�����~���O���SǦ�	�Z���g�YV��qj�\�hE����\?ul�?�~�Ī��h����T�KY�{*iX��i�)�0��36�s	u�b��;'-��P�t�P����|pb܄��
�,5W���|��d�~(k6����8��s֏��]2�����xCh�ZFɼ�{0��8�P%1�c�u�96��ֽۅ�4��� 2R(��n{�!�x����Z�iL.�'���
~��}�P�&���d7�=�ɣh��k��P��t��s:_&N�Yŏ�ռ��Ch(n��r��eD��t����ӈ�(~�m��p�-�4�rϑ����@������6W~�Sq����5M��0��݀�y�{}JWu�&M��7��*BB��V�(�J���0]
�@���Ũ%bl�Ψ��-~�<�Ǆ+,��sf�<5r���t�iH�ĩ�V���|j�-r0"`y�4�sRgyT��,!��PCs�ȷ�-gme�A�q�\9rvgv��i������ǔk>6qT��'^����'���(>�����Q{Ġ��#�̩�YiR}T��H_���R��}���	�}�]�Ţ��{z�Y_��{{[�歏��CkB�s[�j|�$�k��9�e�Zh�{G�c��˩���}����Y P�������/F0b?��d|W��T\�P:L~�;`��'�h.p?�	�񣬡����,˻0}2��БON�D��
Ʋ�����{L�j@s�%#o}�6W�>JU�dw،<�8Z�3ȭvwH��yq��鎓���οQZZ!��Ҥ�h=p,U���yR��E��;576�;βG�4d��v?Ko��h ������?��d���Pk�:S[E?P'
KgB�4�~Kŉbr�g���j����%[Ic�j�RZ��=�4?P�JW@fFJ��2�"�{�!�\Tul:u�!�ۮ������v~�,v�ȺB�)#�|�8kO��yp�mrw?+�&݅��2��D{ur��$�N؄�ֺܥl���T�~0Ӛ5�xf3���s�R    ��q���ش�._�ڜ�i�f{��Aedu�\˯�������#ڛ�څ�n��D������B��R8�Gp��;���p(p���V���0��7ypPM�����N�ܹ��z~8�tN����^�&�ÙֈRk�y���3\0{Q���L(eZ��"w�vLZ�=H#f@<����'=��{Θ�|��a3��a���T'`;���D/lѸ�c�Ҫ���q�?N{x��Ӏ����E�<vrˑ�����;yF��[*���e��Xׁ#s�?D97��d�/�;�1�^�0�${Z�g:�>F0<l��BKs�y@�[��n]��+x�3�{O��r{'��8�����qU_�	���:p0�N='�F̑3�į�CR���k�޺[��lOY��6y��������s0��_��Q���U�h�E�����"3=�����e��a;�m:;'�8x���4���<�yF�9=Pr�e�#�R"gZ�Ƴ�����La���O/U��d�-�/fv!ލ�C�Qj�(6O~q�@���'&���!-r�E��T�yr'�Sn�ev<$9r�6!צ�w�W��ӡ��wL���"F��kmd�9�{#z5+V_�2l`�٢�rQ��-�C�Q�%T^' ���PI��0�y3���
Czࠝ��6�1Y�!�Yj�?+�2�9�
�d�}��@ثǱ���&�+�C��i�R���C�Q4`Ш�Q�5]���{�9��!��Ͳ��A[A�ޗ3���1~�ڿק�'O�0�&�vŤ�k�Ɨ5,W=?�'�6̫����9w;p<X�{���&O��W�����U=d��.�:fn���.�k��0~�q�|�YWQ\�yχ)�^���C��� ���E��d�ڦ7��Ư�E��nb�xH60C�����]��Qd�0\�˭t��#�v�#g�������3m�]2��Z2�oF���x�F�����·�c����
���62�Μ�;U�y��8R��u�913W[��f�x��Y����ȹZ����4s�;������H8&���b��f���'�w��)�?Mn��G��h����G�f>Nqtg����}�Nwb֚&Q�8�i0�ʽ���qh���n'�Ρ�qn9c�\�}�<u�5bP���� �:i�؉�Am.��������E���2k�<w�i���qrw��w���r��(�iy����Ϻ�y���C��c�$�.��9���~�b�&�Vl$�)�:ە(EŔ��5��(�}��Nz.�䦬��@�ٳb�y�Ҿ�NH1�U~'�r�㽥��<�iϨ�v�T��Z�#;�= �`~KŨ�r.�� B;/W Sv4��+0�r�b�%�bf�O�:
�\~u�j@dIc��JW/���,�}�韲��0y��Y�k^�IȽ��8dS\Ä�����7�Ʀvs�(0-yvO��`��0��N\3��1���a�ګ'L�6�p��m5�(��n��vǱ�-�����'��C�S��7�c�t�.�D& \�}���8���n1�S1���)���h�\C�Y�����TE��䕂��ÅAm����t�䇝<#�D��̹_���=G��&����9u���T�r�M���?(��vGr���$]����~��v�C��3����!�+W���	��˅�S���N�"G,��mz������^�]�kG����pϱ.?�pJ^�:$p����tr���q��h`Z����v>p�0n}z^����ʔ��>h/YH�����5���C�����cRE�14bڕ����fO%��9������!�1"Ǌg����V�}��7L�p�TH��Q̥u���7�1�,Ï��K$͇,�,�a"%)���N��[��sr?������'w4Ǻ�Z��.�=�����b��;L<`Z7I���.�����u�E|{����p�uS�_�{w�!y�Ϻ�6͇�����A�x��ч�m�G�xx�#Ϧ0�^��Ԛ#7ɳ�
�r:p]�v�C�c8i��ὣJn���w�A!b+.P���8[�t�fg��e�|ϸ����u�χn��<�x9�ܥ�ñ�C��3�@�}Ì�4�
 8_�uA�\p���,ٺ���ef����:�]I�|H@N	�����/Z�������|�?�9��R�L�C�qz�B��l�e�\A<xr�8��m�|��#r��B��3?�/N�B�^�`�������Xx��x�v�Z$m
z�VG���7k|a�@�l�<��1��ry����RG���:��"Y��&8����8;�F��D�6`���#LC@g��E�sP�ea�>Tݳ�-���JB��O�J�ä�,_S�/�yo��Oz<q�Խ�ta�m<K|Q�W;�.մ8i��,-rZ7����Vj�g��	�Cw��n��������ks�gM}�Y8p0�`ԭ��Y�}��Q���ߕ��O�����kZB=��Ī^���/NZB=K�4h����WK%�g�o�7K��47ˈ���g�ϓjܜ8뤣��W>jqo����=f��3mi�ެ%r,����='m;��ȧa�_�����7���`�]��O��`���s>oq�8R�ȕ�4�sf��8tIMoʭ��lU];��<S�(�_u��I�a*�s��Ad��v����Ýd��Ui4��(û]H�����ǹ$L���GJ�Y"f�*��������Qm�7]��;v��I��Y{�Pý����}[��˳j�،���d:��O[�uD��;��65��xϱ�U%��杇��i���\��;��盹|-�%P�������2π�j2fˡ���a�'�
�9��8[���]ig��Ӝ�l5r�je���\r���Z��X����of��-���ۄ���p�C=E힤C�~��tp��
�ס��܆ɷ�?���Q�����p$���0cؠ�����a|a�^W1�e�<��{� S=�0�N��ӥ��e��ԎICV�1jY�e��p'��9q7�a�پg`�����C�A�h^/�LzZyz�,#�J۝����9�^�<Rv�h��r��S�D�z����ˮ%;����-�,�BRRͪ��=����w�n���ۛ?c�L�+���@�Nf~�"B�(^~:�c���9�� ��f��'w�zbS�̬��0O��0����~��^��V����9�/ֶ�*�b��M�+����9��r�TPl��]>����(���2�?`�zw�sRj�k_�$6��L�VO�!�q[?EP*�I�Tѣye���sJ$�$r�=����SB�#a����=����؇�a��W�!V��Ӫ�~��׮�D����Ӳ��Eypp)2�:�p�˂����;OHQz㗷>�]��P��WD����L��k��8&s&m�����q��@����g�k�L��]��8���s$�I�v����_�n�����]���4�d�&�N:���Q϶�_;y(e�"�b�O�:a�΁�0w�9y�qu	���Rfuk�R����`��9���G�4Ӱ�j������>#��ρa��t�N�^���+�s��Z�'��<����cM�B�׾R�A�4��e��7��d����!�T��}�\*q�f P5��V��QOf�c�Q�:��1aol��yX�S��K���&��J�E%bl��Xeo͢��Հ�&��.N+��%H݁'�^g�;ij����E!D�&y�mU�)ױ�㄁|Ex=y%X�oBm���>��I&��
��h��ԇ����k�;������d�ɐ���vi>t��_�"��e0��E��C�8pPX�sY��:�>|`���|/��&G���f��"��E#x�P1l:js0��;�4"gX���8��Lo�5V��3��yޑV�`D6T��ly�K��%��`�Xk��{q���º1���[���C�������u��C�1��@?1&�Xy��V��u���9�sq�L��:L��߾:[_D��~�I�jw�ji#mǬ������J+{��B�����W�����q�ޚ
�&�����.\Z�b�s�.�덯.+��~N�Zt�1C��̷ar�9`.���d-� {�>p�v    w��h1�H�1�1"I0�E_d��_�A����/<�w7�;5��,zxO	F2oA<q�5�{yybt��Z���&��~�)~ct�=�P���9c^祃�a�~�7eN��j������ߋ�ZS��_q~�8�,����8��g!u�Ļ��b��z8�1������_4s��1���赪�(&�f�MJ�`��Koq�j-1q�9L|�Ǽ������F~c�!��!��ԀAف��鹵󐌼��������tV��9V���rʹT�q��f;�?0����<��Z���R��ѣ��'0�7�����m��|�Q�u:���������:�����{���y���!����W�돟	�gu�v��Z����ӭ��!#~�f�
����0<��a���b�}?$!��w|)f~r����U�87\�2�`o�gU�����G�8`m;�W���`�z�^��~�|�b��Bu_7#�iH\76mV���W�z��U���<�ܭݦ,&OŁÖn�RX�#i􁣛��sO���,1zMR��\#ΉD̺t�MYb�9y�Ӂ#�8r��!�w��.e9�=o;\2��M)�v�<�,3r��)�ߚ��"�#Z���s�姷�[\�Nr�w�F���Uf��Α��8iw-@5o<<qh0Թw��tN^$�/?=�:�F�i7��v���{�E���W�J�k>fq��١�5K�w�����z��+��o9�՛޾ܮX���9�
�J�������Yĵԕ��㌢={��Fq�5R��� �5�w����!cb��ǅH��]�[N��
����Z\cD�4OND?���y��!�t�����k��8����8y:��.��N+L���ޫ�Y]��*��ǳ���"Ʀka)o���b�k�0�P�� ���s��l-E��v����Q`���1Ǧ�BHק_jEF��dqq_�!x�Yz'�c���)���M�i��:�V�Y����V�yÖ�����[��>��~nLa�HWΎ���P��N�҉9������?q0~a��.�vx�J\809���}��O�	ّ��y���Q*���o�AU�G�4��H
�F�z�S�^��Khk���V���QW�V�y0�wݙ��to8���^��p�P��w̃1���C�+�S{�����-��L�����pl6���ie9̃Wq��ak�1��Q�F�H������Ǳ�P�@\g�P���c��Qw�{^K���R;2���d��������e��ޭR9�|��6���*V�M�Q��.��:��+�����q9W������)U2�|��e���T=��k�n�~B��B�,�֫<�3�ޒQ0u��?>�X�.�5�X����%�Y�%�F�7Wס-�(Z�`%�|%\���.3�(�v�J�f�>}�K�a�\V�q�Ϲ����LO�6!�Ν�kK�)�+V�Έ�.i͏�e�rU.�|��~���/z��~�C���F[sw�1u1I��z�l3uN-�/좸�m��yӫ���CԆ.�O1j��9F�I�N�.�f�^�FUB�j���&S���]���oǄ��N���ǚ���o�z״��4NG����#&(>qi��?����T���!師g^S%Y�,�ޱ<�d���<�bL~�N^J>�a���	�������}�L���ۖ��=4>��#��J�Ks�Sr�����y�]�D�.�U�����,�c�:N'���G�r�ӵ���/w���8�6��c�s��d"?�s���{����F�ɥNo8�,Vv�K=~�X�*#���N���'Oee�3�#ֻ�,�L���N�u�V�;虐�kR,����{�j��i�|��Z=r�w����w��C��ȱڟ�Q7n���X9��r'w{���{��?Ds�ӵ$r� ����T���j��"���׈�
~�e������	����5hlߢ3/i:`�`Խ��=40��Vg����5�ա��{wp>��8d�0��{s��|��-��F.d��Q�p����)�����m�d��\�������\P�9��W:���Q�Vv��f=�?���
�&��0I�ݸ�=�\J�1�Q�kXmi�!���sP��B}�]�vr)-r&Z�t�t��Es�G�Շ8������@^�ܑt���[��1�I�Rz���6��c�O��0�C���k�Mr:!�d�s)֏�]GR/Y7���W�r���^�|�x�ڋ&��Vm��ֲaH���s�<,�1�b�cBXz�d%zo�J����Wkٽ/2粯#��{n����o+К8,9<ݍ��t?�a ��i��4�ȥH�0����\d1�F���9��^�[ߊ���)c��>�|r@|c�M��(���@h~�����·oL���5�xD̴(\+�]�z:g�ȁ�sn{{X��aBC�}���g8N6��Y���'ʁ���p������s�Y���AOӎ\ʊ���ø���ꙸ�9��O�'S��Rk�u{���'w���ZN������2�Y�ٝ�Km��p��0I�@O�N��8�j�������/�C�#���M7TNv�;p���L�1H{�T�`LS�j�^���.}\����@���^��|�@��|mO�r�#pp�w����ճ�:#�P�;0,�s��&.uE�2	���%[:ec���8������=Ѱ�}�V�LX��d��i��=����1�z/����S�$�;e%!G�^�܁�j�((l�;L���Ի�G�Kю�����k2��'��Y�7pl�����l(�3E_c��s�p�g8z��Zߝr|�dz��qOw�v�yĨ�V����tÛ���FO�^��9w3��~���V�m�0aX,�x羯�J���{���^܏�Mr��1���K�F)��]~��/>���d_9upri#b&nH����#y �9sq�|뉮�z��i�,�|�4H�9C<�ȩ6�XF�Cq=m�ϋ1�����a2�.mE�u�������m򁃊9�It(��E���*�8ͺG&1���.�U�5r������Κ�m�7��d��W��Q�}��.e��g�{�e���S������&��;b�����0Z��O����W���/
#��{٠�=����Yy��7'��G�9p0ݕ�ߊ�Ht���&���by(��o�V�B���9+�9��K�w
��#G����V��h<j h\�c�yo�3ˎ0�'��o�|%���rg<U��1���&�(����nN�z�����t�ᑂ��ε���ݑ��U����ElUD�������G��C��o&M�)C���,�Q�Fs7��1e�k41�ɚ�>�N<d�V��!t��P��������Q�U��s�s�Y�_g?��1�����w�RQb��~�Y��)��R>�B���7 H�����j��gԱ0��H%���T?�SW��ޙ���!���*(T��9.0.�Gi��3�j�C��)��S�_L�X��p�<���!�fTY{���r<^0�ϐ˲�C�q��0���=��YQӑc���%Ϥo��.�+�|-�Η��HBLCJ��B��a���P��x�)�/��_?��V�R^��6���U�'��鈵c�'����#��Θ�9^:��N�ƅr��N/J��b/u���rs��&���8Y�4�]����K�}�O��4q�5挃�rGj/��Al��E����.5d͎?~���d\�G�����ZĘt�D݁�-7˷�;ں�9�۾+�]��H�����z<pX=����#Q�|M$�P�?Y�.C�'&�ْ�~��]�zL�E?b��:�K�dA�̻���i{���OGڑ^7O���X�_H��;�gc��(W�K���)��vS��0��xǰ:�Ҫ�yH��wsƈ��M�a�1���|b�z��p�S����.O�L�P|�n��^{q�ԳBӻ粑tC� {Q��rĨoA{;<=�iF̰f�R�G&z��w���B���Aގ,��olHb�ǢON�o�@���s��/K7�4����\hE���^�\��2���s�ZCͅ? h�<���<�A�z��L��|�p|ǰ�P���ƺR:[���Q�    P��(յ)�C�1<�q�Ro��GOM����ZhB�r��4w���v�Jg+r�(W�FC\�8_�L��lVU��'_�́��HER��s�r|;W�dmEȯ�O9>W7���ѾC99b -⾖�~�7p/� $�2��,-�1��:C������E�_�pf�:xW�֯A�KM�P�s���7s*�'�4�W��d��o��*�I�y�e�?&ɓ��z��'&�9z�7��.Vu!?��$^�}n�����h��y_1[q��r�4��ŁEzKK�/+�D��7�l"�W�7��.�v�1po�04_�����n}`KMW��3u Y�a��������
l���8��:r0l�5�R:��ʹ���qro'w����C�0��=V�[�EZ��T �P��Ǧ��\��s��0�ǴDu�����W|�6]�$���׺砌ӕ���d �G�ļ��9�b~�tku������F��� ���?�HAy�K��=��U�5�8���i��3/�96�����Ӈ�っ�F߭A+w0�A����,�7��j�ի\2���k�F���Ć���V���e���F��O��i�`x��s��ah�)����^n�լ���ˬ<Cr��b��f~�vP��^\&-�Y�����T��\2=.�E�u#��m�K6���^�=�kw��䑸��w�c�����ZS1��=T�9`Q�ɋ�F|(��c��S����*�#�_�owhq�}ey��k�t��(
��!�����j��*�r1reG��������;���P�;%������Qr���⚗��1&02����?'OZ8�v�3��H�
8N��~7'0©�)�Y"g�T ���eLȞ떃a�rs��0[\�H(޷Q�r���_M��Y\���*E}:SsgzD(��u��μ[��ǜo1�U� ?����T��^=�I�[�^�1xh�-�����x S�C����z�H1����G�{���1�ɯ�Ơ�u�Yr������"_(G/�rr�&���ӭe�;�{7����P'�Δ������z�ȱH��������wβ�݂��+�==b�"��<o��v�a"��=�=Oe0��x���+9�B�t��?Y1dmhԇX�qP!?$�wcU$]�z웮���NT�7�/��FypJ➣�}�����3�9���ņ�^ܘx����8��8	#������y�N��#��񶽈��{"Kw]��#�>�&��`��>^el���U��lHJ*V�FZ|��e���i��'u�uԎ!bg�J���VDߏT$�pS����Y�Q�s�su�-U���g���Z?�b��̨��>� �����Ji%���yq�\햏*�)5a�q��Id�B�}�T�>8/��j���g2��!}���T�ߘ��d�kJ�x��B�|���z�����������9K�������������������_������6Z^�ˇ^`��5\��Ə���"��N�������F+)�;��2�V8Ǒ5)��I�]-G2*��T��3�Q)R����B>y5�g�wq��L�C/�}����auHj[~��i�]�v�ls��5�k�dy��ȹ�-���ʰx�z�0�Ź�P��Q��ú�υ� 蛍�w�!R��Mm �b�J<����?Ǩm������ڌU|z�3D����h�q06A��1R���7�����y���a-�!S��OE�52)�#�h�옕FS�E\4�!����+��W���S��#�C��݋S�T�xIvO/(�aW����/Y�s�+��m��P*��eQ��%�!u�ל�Z9���,�c��YB�w�fyq�X��k�1f�3N��_X<��L�{��1�%S���z�tU���r|ɸr�S�^���>��i����8���|�Qǻ�Ujl�g+x���r�>2����}�����^ֈ���t��ru�G���g���n}I���=� �a�s�Z/W+��7�L��?���״�C#�-f�����VyHn��d�O��sM����1���K��!��V� 45��%RRG��9�4O�h�?�Ht(N�A��1�RR]�Z��2�^��H��xN��w�A���Fki�s�}������}��E�>��J�U'�1f�K*�>,ey�0CNm���O�c�F��j��;�yG�C����<d6=V�3��&�;��zi�uYĚ?�`��7���-U��M֔��%S�|렬=%&-�atČ�1�n�<��{̬}��?9ȿ)��V�IK k�˦[[����n�Ҿ�g��\�R��j���X���jIe��=��u-q尝��pwΤ�C��+S�U�����V`�cp� ��w�K:��(�ӎItj��i([�}-�0I.����%S*jG�{��0�V��J|'7zT���	#���6N�$S���C�!Zk����Z���"|�]����Nݡ�͸�����9Vg��2�ϕ���Z��3�����v(���Zk�]Ӛ�vN�8qXh����Y�Z[�̚.��4e%OS�8��ߓ����c�2 ſ�4vQ+ِk�S\��P�`�8�5DIwN����K\W��ΙY�g�ވ�p.FkD�Vv��8}�t�K��8\{�>w��X�d����=%oe��\���C~X���G���_'�Ɯ�K��:#��B���%b)%N����]vN�.׺"�����Y�������Y6P�p�?��n06�Fܼ��_�G�ap}4�����HE��gk�X��<DRw�C��mȸ:L�d����l4���N���f<�'e�6߼�qpbIq���i_j_�E�-�<�w�,�g���h5rL�\�x&��]>q�`,�α<�y��rЬ7��G��%��G}?�XF� ���V4nI��ߟ}�!�f�]�7��Z��L�-{k���&�1�Mh����'�j��6�MoZ^{\FZ���{��e���V2>�/P ;-�[���{���r{��ک��a�+~H����C�2�x7_��&�c����0iK�	3��ņIq�Q�`�v�p����y��6�K�rtVg�7��U5E�ݔW�q�zB��u�g�����p�5t���?`��m/y�U���FO��r�䋘K��_�J�l����ѵ����<�7E����3���;��T��ѫ��4�|���C=��1r�}l��!�X?�,��N�IVZxq�/�����L�8wW~�w���:� ]s,�V��(��	�s��@��`��j����fe����wPF�V���/U�F�]B%+�����-������C�V�u�r"�h|�N��z�ꪖ��bm�PW̺<S�C)��#恙@g��K�
} ��{��C
r�1QZ
1��B��5�y�3&�9��ҝ��%��}Ƅqx��Q���:G>ñ�����^-ѱ��Rݾ��
0N�L[��Ƒ�p����*���ꎚ�>����x��1!�T����}��<���_B{�=�]�F��<qF/�N`�|5�B�g\*�j|�{n�j�e��.����9N˺XN�YZs��Vs�t��,uywͽ�wR�cګ�N��k<$#��fk�c����QL[�jyX�׆����ӫ�E��z`��<,�1�e���]�|�<ӝ!��k�'ju�<��X�Dδߣk��F�JY�N���n��j��C22l�fBz��t�G>��AB|/�=ϫ���,����Q���&�{���I�n��*S�k�}�s9���S���BuV��{'�~���@��[�G�羛w<�"�G��ES��nkY�d�\�=��Ǥ�iN��	'�?l~���P��'�8���\�;���(D�uK�yD�!y�`|^�\�Y�9�M�����M���D�]n�#�=�vLX�q�e�G.�Z�#���Ն�iHz{*���%Nipn�iDY!��!�=�f�0.j"�)��3���Χ���Eȩ^{�υ\�����F_��&
�nR��g�ƞ1(�ؗ2�1�E�bq��.׈�ï���d��C�[�X|�c���2��#g�d�16�a��7�_����d ǪG���    �ĪQ��}A�x�K0cu4gn���1z+�4�>�jȃ����*�r7�}��L��2�en�|U0ӫ�͑7���n�2��d�y"�@��n�.�z��;�!2z9�ő�6(B��W+Rw�7�����(�f��ƃ��t3��F���v�L3�XWq�͏�d�>p�ՙ9N^��9vm��Cw��Tq$.j|}0���зhz�=!=���E�*�ޛkn�~r��ƠtnA�ܿ����	�1��3B��y_�������~r��ƨ��+{Fހx�`��������ývw���00�]��<��ިK�[j��ݸԱ�U���UW락K����$�ȩ&<�L~���-��ǻ8��Ȝ�k��'�)��h��,2�g7�R�9Y���������H���M�xփA�����y��1��5��K��ʳ��#��/ӏy�Ӄ�_"��fF��|�SSz�=fLGi����N�ٜ��,y5�p���&h���zx�m�.�tq.�����Ep�M��NK���"'�:L��{�=�g��\5�,�r�g�Dl��m�4��a5�a�JsM?�l��ռ�*�^�	����ނM$� GJa�·$਑ce�������ˬ��"��z�N�ê��gM�}��~��'nz�Z��}�|��=����v�GK���x��fͣs�5��������y�A���͹�w>k��G��"1��i@L����	A�kBT�=W˝�[�X�p����#�8��7��<�:�W���Q�X�$��rwy�ș��3�%�[랳.�����A�8W���u����Y�Y��DY�;(Ҁ��]^z �ګ��Cpğ��hY�z��k�C�o
Dו۬e:L�1��saz}ɜmw	'&*�:��Xڳ�1�0V��z��Yz{��}�t��L]g�{��e*Gj��뾙dW'�]����o�_�R�����U����?�(���髞�݁3����܈�k>Mџ�n���.�j��\/��
��]���0~�Lu��a�м���,�^�(޽�<��R]��Hݧ0'�I�^dY}�M0�����#9`����k�~�U��G�%_1��14W�%�'呻]4n�Y�N����.��l�ڂ���?���q񖃁'��=��1�E����D���.c89wH=��{ �{$���Ł�&$`����<�r�A��B�w� �p���I�̫�T��#	��8Ь)X�-Ç��`
�hNC��i�|c]o_�=�����3\�P��7N�5��#y��3ѯ�+�0�'����pbPSr˼(r���7�LI��9�P_���Dၣ�p"��_�lOna���$��\9P���|��⡅������O��s�s5	�'_��$5���T���G��#���L\�j�_�a>�3����h{�t>$��e�R5ͣ5��`��A)�е\|��|h`<pC��q���֗J��j�{�88)�:}�<�f��,�jA��5��[��gq�#7c|�e����!��{������:��Y�"վ�r��x�U�u�;&O0zon��s����z[������f{�t/�2��:��,r=�����v�<�Fcm$��-�0�T�aR��{�ԭ���v�Y�V�7��&�W<�?�V�;q֬���������]������Vj�`���P�b�Is+-r,��U�׀�&�Ouw܌ӹ�����g���ɯ1̠:�9���]+=b��PS�>��g	[��E[G�������1Z����)zO�������Z���&X��ZZ�I�r+#rlx�쥻��q��c%�Ui��z'�T)�R��ʌ�i�o}����4ባg1����ӄ������!�Lb*[���8��q�N,m傥'��;Օ����Z"�~e!��5���8M��-`��`��g�v�W���������1�y�cV�-;�췀�cl��2��f����Msu6:	�4���zBum�v���������W�Gd�)�|1�rګ���wW.[�j�Ӱ�Y�B��s�N��n��Q��LባF��<S��
L��3�����O�F�C�4;�O=�x�H���)�e���l��_�WS�5�{5��Zp��0i��	3d�����a���0���m����/�c�Ę���.�c�k>\Ċ��D�p?��5�����B�p_�s���.�#2h�I^�H��3����ؽ���3ꢽ�w�=�'̬�=�0y�/8^��պU��߮\��h���r79���Ƶ@vPx��Awg�2�޾�	��d��(�'
~�T�՟�$��I��R�Ud���L�TP�@�c��L����s��1I�rP[�dJT�ҷ��q�V�{1��G����Kns�92���`�Nj�9C�W��r�Ӷ��*�xӢưC�ͳ�mZ��X>k�잎�K�M����O�/.�\����ۦ��%Jf���o|�5�����9i�����R='��M3��0�p�N��\���%��.��$��ux�r��Zۮ��$m?atn��&==a:U�%����8t�!x��w+�Z��A�0�
ը�,V�]��s�����\8K~��/Lo����/��0�f/l��U��0�:;/���,���"w��;�D�HW���]�k��`�*��K�x���y�c�M���5��@�b[8#��>q�����F��z�;E�p�|��'.i{fm���{L�ڤ&풍��XpÐ��d"��?�ou����7�0<{w�k��Ѭǌt��\�\�f�:�t��E�����[6��l�n9���G�r�ӶI�~q0�Ik8��5S��[$����ǝ#YI{k8ժ��יy ��QW�7-���𞃙��$\3ϲ4d#�P��1X�`�gb@�ä�+�
^Ţ�'
{ێ��ύ�7f�gjw
V�(7	Tk�&�r��4:�����C���_
d�yH�9v��u��Q�q�]=q���;�a1�s���E�W�k+p��"�}��\Jn�{��R'��)'7��~��
�5I���L��U�?W��{L��z�OVW��z��Y�Į�x��T̃m���-���T����`���l��|�8¹��EG�o��ޮ`���Sq�D|����Z��������YY�Uߐy�a�=��
��EZ�Օr�������=t�:�RۇԯXvk�?˅6�U�lle�(;�W�C�񀙵lZ|J�"ELs�w�����>pP���d��[{��z���n�O���>�Y�&��uF9��G�`
�*�Ǵ�=��,�K����R��x�XI0������7o��=���hǤ��π��b�KC��=S~c|�9��(ݥD�|u#�O0��4+��0YsA�!47{���yX��א%�:�~�]�J�4k_�R�퇇D#��B�n���H��鹵n�S���1�߯��s>�1�R����0y"�m��Lc�k����K��^>aXF��K��k?��$_�=�~��_�|!����
�`+>ٿx���G�5L�@�0�e�>��(:�
��8o�?,��X��{�R����Ib�t2� )��DJ��;���_���ťV���d�w�>֊��6������V��/e���D%��EO��<,�1�s���P������exW�fz�q���
y��1}Hr2ipH��zrA��=pФ!�ԫ{?y{ac��'�U� �s���9�KL��n5?$
ٯ楞 ?\�Ŀ���<�_{�t���;�����o�M站G�X�=n{��w6~�9��.fm��rn�yEδ��� ��䮲��A�Yw�j�=���q��K�@m��~��.�-Fo�N���b���\�Je������L�f�쎓��~����0e����&���k.�^k�ùƒ/ey�t�S�ln�J�;pcT<'_���vL	�����3,άT�B�
��ց�>�wP<�
�!�����5���G:��aY�푪����_cM�}�c��9�Kh�W�$n+5�xÄ?so�a%�]N6����5��
��=�2��e(    ;'I8s4�Ɓ^��k�]ѕ�d����s���@�j1!�9��_+��x�QG5����[��waP,����C���X=�z�q�ǇL��WL�mj<�}�C�NhX��x�Yx���m����Kf͢��}�δ�����P����L�ĵ�yE��/�=W>����p�g塸Wd׋gq��\L���{�)f�wN�({�A�O]��h�x3�s
���A]yr���֋υ��b��5���H�g%���hv��M������VB{ʇ�Eu���c��
e�u,�e$����*j��q~�R����f��j���f���1 ���3�*�֋��#�fi���^L��K���+��bf�T��Շt�-Gp/�6���rC�z�o�pV�����kBz�{�9B�.���D���R���1�\���V�~e�6�C�/A�_�v��M������%;��*?��s߽��3"�����K�ϕ�3���~q���u����Iq�˸ּ�����7�CE����Z����_�cr����5�xڊH�پ���C]v9�k`q�k~iU~c��Hsz�\[+����C6%���hV�/&6c��a+��kN�vZ��8�L6�v�vZ��8Б�6����wd?0����|��=RU2����ir��51��!��M���Cv>#|���j3F��𞱲ɮ?>)~a����N۴G�b&�5v��5|���3���c������v�������Z2q�0��!z�`����Ký���m��m�����:7��k�UR�:�ލ�%����26�҄3"Ǫ�uk.��G��>֜e��#���ټ���'�Cnq΀!L]:9��k�J�s�9m�:N�_�9�F�~��O�_�r�����`}H.�8l✅�@�5+	>�g��`��|MKJ���b�j#@J��ǰW���|8�_s�a�9v����:����O3w���io�&���5cdN���5W.=a�V��Q�Y|�X���1�^�k$�'�ȿv� �+9�P�X�9�����F�[���!�8�CY��%��w��~����)���`��)��9�2G��s�� h��\Lr�S���,S]�0�������RNi�9gzme��˕�0j�h/���2??��7����-I�wۊ���Eօ��CJ���M�����h֯Z�vm���V��0���?�(�����=5\v�e��s^r����/2����8\Ɖ�!����^]d��xkDNE��L!�\�����uG���yp-�%�6�}B�#��a1�ȩX�}���k:�y�R�941^����ܷ���`V,�^G���Ѐx��f3�~c��ԭ`��s&7�o/b�sy�m�-S%>a����;M�T�%>����.�l`ͳ����n�L�]w���`i/=rL����ۢ3]ʽP�M���ܛ�q��<q ��N��Ǩ��M�}第}��QC�+4L���3�����c6�)#�WZ�q�����d����gOu)���,�J&{�ȹ�t��>��6�eD㪯7�%�=���焏<�{�#6y�8����|�!�Y>t�F*���"g�L��욥�La�{�9k.�5'/E�s�{�%r&�-̽����c��AS�.�ri��˱N�9ĝ����pŽ�1#�5�m�����s��`��2�cr�\k�`���r�ؗLWƉY�%���;3\{�麳�n.�I�� �����
�bH�e����1�Ȍ:Ք���}����}��%M�s���Y�ڿz.Wz¬�p�FI��{�]'zw�3������I���[�#[���a:YU�t�&���f���t܆Yٍ�������WJ
��_�˴/'ti���b�7��,B���r��{�`4�t�8*�ǰap��mn#�/�����ߘ�1�|���E��A
z��;N��z�?�j��/�z��8��I��S�K�M�"l����pB�T�^�����샕l�������Gm�(�_��=f��y��΀A�A�q-N�j��8+r��Bn6�զ�`Z�k�}U�o=��[�Vd	C��K�[;�ٹ8qV��1��|�A@e��W���A�rf,�N�}���#xa�˚�&Sq������FO喨&���n6���ӅAc��ť���l�a:�d���JA��3[9��(��W�{{�c�Qu�`L��'Ak�mt�����װ�Ԙd4��Z�c�%�80cz�Ci�Eo9�Ry���{��r��A��t�[�v���X��Z4������1bWk��]A�}����V��=t.4�8�jZ{T*�r�����GlZz���&����}sZ�q�@?������|ȉ*҅^�a��c��,�0��my.<T[L{����'�U���Hn���fA^=���$�O�t��Q˛{���4񛫆�8c"��݉�']�� ���ʮ�������8�eF%�Z.��r�wN��z=�ݨɫ�%�^�%��t�P�5rP��7��[�I�\w]�йq�g�э7N���EM�o#7ڽE�5�,��l����Y���y�a���_�w�s-��sr�S��X��.K`y���p�L��6���Y���p��x�xX������Uh[�r�X9�JT_af%�gN�&��x�(�2�}F����J�Y�����s�kXg��{_�mf�$b�?'��o9������ ��iW8��"d�v����Ʌ�O��>�*:~l4��nj�꽺�R+������!�o��sf'� g��y�aX�W��x��� ���N5@����?�W��d �g�zi�N�W��j�v�s-^՛�|~a'���� �6�[;q�@��%z3�!������_s���Ia�������J��BwD�V󙏕�3w�k�|����9i9s�9b�_7��*/���O��\t��2G��O�_�@ỹ�q��#�8J�ap	luzu1-���<x+p�9�4L�b�9y�〙���?��(d)��µc�ҹ:7�vLv��Ty�:;f}�k*b~zw�{ϻ���ya���@��9,��I���u̬�j�z>��s��I��]K;&����A��,x�tY�8������=�$[y6����ד��5\�f�����P6�a��-`�(���h�/g�/���7Gv&���{�`(����r1�n3�Ǻ�,�[rc|�@��&/�8`���?'�yǿ���V����̎�{���ӿ�
F��;��B�αS���O��_g�0����=UWF���Ӻ��q4�=V��㝱+�S���1J�W���O��*'r	� ��!u�'�K�@>��I����!��{E�C_���#p�?�����栍�)ӣV�􅖏_��%�5oP�]x�6��*ʞ7(v�wW�����9�G��{ ,��ӽ�X��d'��U<4K].G�)��o9�"S�]�����'�qz�e�s.E�6_mv���E6+�<p����O^O�3r�P������%��i&6�+<'���8�g�Z���(v��SM�q�	j7�/竫^=��hOx�e�ǻ�� �X�ٹcr���-��p�i���҈��H���ѣw�w(v�U��{�T�����`��ɗr��	��U���a+�k�1�݀=�&8v��y�[(`P��\} oR���Q���7�$v������PNq��m��� %�Y�,n��V��'���e2=oS�2"��Ԃ"�{��4J����m���}��Z���Y�k~떛L~ϊ�i��Ț��󐛼��X-W��r��[�f:B���5��[�z�]�����*�9H���D��Cnr��i�ã��s��G�><'�8s���r�ḱ~Y�3��y�b<�1�	��fߥ8zީ]��x5&�j�|,X���ދF�H��c��Y�8��)�0�|0j�V���6TJ�W3sg�3��"f�ar_���ކ��ZN2��݉�Yotfq��:e���U���ȱ��Q�����K���~M��H84O��g|r������>փI���D$�L�}=d%��c��!ͱo�����/�v����F?��|�)�fگ����|Hb    �S��+p��������?��d�T��_	!�S9��?�Y��]���{<F+s����Z�r�;��Z�՜fb_��<K�0|�UzuN
=�$g�n�E��c�9΃sYw�e��A9�[̴A{�ա����%�|i�X�r�PZ
q���β�NVL�Y̸?q�e|+�*Ϯ�h-ԽU�*O�*o�	n2!���)������aꥻO�>��
%[C����T�'w�o�Z�<&����P�M�*W�͆iـ���F{��j:�O�9��\\�0������Y6�~���q�d�u��h�\A4&����1\��·�İ���::�_�E�9�,��}����O���ߘ��8a������q\8he�,�U�� ��g�9��;&�vq�]-TM���z�%blXm�pƾ7s�F�o�G�P��y3b�i� r�WDx��0"�a���p j��<��c�J�"�oy��-�bHOs���z��1�N�k8���p�h�l-R�R�;�z^&ܷk�m�3Y�=4'��i�w�\��A���m�a:������������5�.�����5�w�K�����/�1V���ޝ^�T'��9֫qi���C^-r��	���V �w�G0�y8Nn�W5��Y��Wx�����E�)W!�"��n��N���Wܡ,�������n�@C�wQl2�yk-o��2�@�G�v��c�}%n5�GvÊ�$Fi��G�#�������K��CK�Vb�;�d~��L�넡�����i�F�۲۝��^X9�w���.��S�H� /��Ƥ�����1�j�7ɽ#��j����G�_�V\6p.��\��{kE�U�W'{�����%�K��)*��A��+�U��O���3$��,�wv���4];����[���]���ɆTj�,`D�A?$�m�J�jڍjqf�/9�/����2�:�B�'��7Fo���4h&v�J��~?��o�Ի�B��h��z�uI0i���c� 2��݅GI>a0p�:L:A%��֪\u!#����J����0҄e�c&O�Q�i��H���2{+r����>���l�7c��S��R}��3��&W �?U�����E-o9���.�8�+|������1�UF݇�#���a+����!���÷_��$��h�6Z�X����5v}i�s{�OS�o/�(�O>���	C���L�oTf��H{�RC��}�4%Be�s�Y����\;�+�%rL� ��n��=�5ppE�~,W�D+�l<q��Ş�ƒ���1�(���+�Js"'�Z=?��V����#�ƫ�`��"(�^b1 ��K �	c��u�s���� )r�U�����Z����t�K(��`�,�a�sV�HS��Y���Zǽ�qRG�đE^���U�d_���q���̘U�aw�iYH���Y:��J/�Tg�TkR��<���]�TW�tk��Ё8NޠV"G,<;)|.�����ibC;�{5s�PJ�F�0�^
U�s��\��!�zz���%�$�`�p*�\Stj-R�v���%qM�t�z��Y��Z�F�s}Rj��Aim��|�<,��\0`��p�&\Se�f��'�0�/Gք�vp�)@���1�f��k�4gM��ԃ�S�`�D���d#P��R��I���s�m.�O�*�a)�;��:2�o'�,��ki���j-酩1�U����"�@VgX�Y�3��f���N-���������C�����J=v�uܣ������H���Y\���'��+�R�����˕R/CWo���\p��s�9r�^Lq=���]o�qvy�'F�4���{�\� �u��+Lx���.��=_͝"Ǵ�f��u-pO{�o9h�E��?Wn��.m_MC��^���L�wg��e;������|��=t^��_���w������������Oހ�.+;������~NՋ*�<���kI��=�/=p��EW��Q<�J����Gּ|�kh9w3Q޸zUW��3��x�.���,�,�Eb�Li������L�Om_���*�h�=�8BNf��$��U���[F�J�����[��ڌG��].�8���ʺc�8�-!c�=�sq�ѡ]+�[_��fC���L��I��R.��%䧵0�|�a]��J��.f�yz�v���^�Gy��o~�{:�V�����Y��Ź�a�������b�;'-F=q ����6�q�@��6�y7�G%��!�W@�uxE�^�g�m׍��<CI4"�������q17j�֩E�Q�ؓ�Bn1����v�Vr�=,��}��Z���9�H4�۴��k�;=o><q��!T*'�g0��v�G��'�tw69�E�/��`��u��=��=;B�V!ݏ�G����0j��>Ô�!�D+b��^��t-[<(Sd&.�ӗ��/�����޸��\��j����s�K���墨��J����C��[�\⪺��S����'�����D�8�
m�o��X�\����<A����?�)JbLA��zm��$K� �91���
<�EQ�G���A���>�D�9��������=�KQ�h=<Sd��nYʳ�0���2��XiY*I���Зհ�<�"=P��CFi���W���"��)1���!G)8-R�f�n\ށ��Xl��svpXi���Cq�vHu��L^y���0�{����P�J_��Wb7-��7W�,�92��3��>��r�|�t/���a�H�}���cy+m�z� W�VG/l�\���O�0��l�;$�!�8J�	~�����<,��XA��X��c}d�m�
����O���#�O�&���ņ,l�ܿ5b�Mx��G�Jɓ6�]��:�vN�)M�qp	��lwk'�A�cl@�U�V��Zҏ�G����h��8�+j_���{ix�<��pA�=��|�ѵ\�u��<$ �Dθ����5y��@�2D��yX�#r�����򐁼�X5�d!5m�1#g!���t���Ɓc��I��Xsy��u3�]Z^u�=��argy�����^���Fry�g�S-�{�߬�c3�Zk<���W�åW��Y��Ø���X8S��sϙ���5������q�F7�ϕ���	����oR�Y�:��j��Ϙ��`@�b�c}��s�iF+��OA<�\�\�a�4��ak`��7�'���j,�W�a�����<W�@�E^���&k`$d���9�޼0��<*ήe��a'��:��ߔQ����2��ebӔ�kH��Q�`���K�ײrY�+���L$������B��I;�e�����KQZh}�Pm��Er��xj�1���ғB�*>`��({�Rr�QZ5`��a�˕3�EL�z��r�y���CtaN:>y�{͕<d��5��a�VDZ-`�f��>�%��(�9֞�2��yH������B0��=U���9����8���s�ؘ�En�s�1�����2�ycQ�tK�J��87�Q����V4�p
�0�@:����tl��Ru�P�=�[JG���Es%�J3)`�I F7wLK�%c�}�p�}���9��Q)�MX�\k�֌�a��t���q�ȱ�4u��K\Kތȥ<�*�pI�4qͥFN�:du�ߓ��N�9P��8y׌��T��/���1�g���*zy����4 �/2!?���%�D.�6+�z8f��x��y'��>,�g�������q$�9wAN��+�ȯ|�����[k�!پu�s�1�����zhG�g�U#Z:�����:>`�OzL��'ͅA�z�� �<������DAf�6�w����/��gw���\�%��U��3
q��39_���)s8$�0$�u�Q7���'��s��_�Q3�\�GG�W}!��L��8c��@��F���%��sj�~�8�7?}Iփ�᭲�C��Ћ��0oG�"s5���S�eN�/�c0�8<�5��k}�c5����d�&��y|F���\��|�;�Ϩ��2�Ө�{�z����B���Ko!t����:aǦ�uv(���j�9����E��:��؃    :���	�j�0���^E5J����l<G�bR=�o5�DI㞣�ѐ�����k����k\�a�c��RSw�iP���#6���DsL��?W*�~���%��4Rr��u�]c�yoa&+J��Bz'rA�QS-=ޛ�.�G���Ow�4s���~�<܀��������\���i����v�@�\]��S��A�q����GM[��9��aN���F���vN~�<p>����{�/�ep'��wL{X�0\,�Tt{���Ҁ	�9v��St_+�i�:#����Y�s��M'���sҢ��\���9C����â����걻�`��6��� c ���m�4�}��صQҬ�2��w�ʴ�O�����5zZ��ץ��􃛎ʆy����4S\��ɹB���b�T����A�!�ɽ�`M;<�j��N�}�e<�.�I���I��1j��~��1�|"7�� 7&�S��_N,�V�9z��>�ӧyJ�[���N�ԒwNn�[���!�H.�2(���8P����2�R	s��\�`��l$n�5�K�Ɠ�!&B���ܯIVN5:��VG�U��L�s����q�����.<�F��/�m�:mw�~�}d��#�Pt�&-[���Pl�>�WT?�䜷�g*d$���<�*r���z�D�b���Ǻ�_�O޿y�V�� �\V�2������3��t��o��%6�c��A혏L2�*|W(�z혏,2��J���so�#�l��[�u�<��((R�պ?���An3b�������F�S��9(=���䫸�O%Ve��sQ^�9��}�D~�=��p��޼�Ő���k�X ����vN��{�S���P��|)�8zϧ��v���k���4�A�ۙe?����'�g���b���y݆��"��+��0�@�ՆyX��B���������;G[�˝�\ᔻ
��2��G@F�Z8z�Gfh�<��9�R���yታ�{�yX�3r�=ө��{ѽ!��`S��[�UW�\䔩��|�%���3�ȁ���Y>�4��;�9v��?	nS>Đ�����Z^jXj��E��_k�6�q��2�ݵL}_�&ru�y�e���R��q��)�D���Dj���<�q��\�I��7�e�`���n$���	C2y�o6V�%gc��j��+_�a�.���Y.��.�����0��z��夒L��4�]�奯�:u���1dZ�cW�ڮ�b��4s��1UBނ�s�k�TS7�u-����Ÿ8�C�hn.�@n��� �T/��xЙ�2����a�<�}[ͼ�����0�����ɝ~{���¦^��9�;��d��!��B��ݨ?J11�t����Yr/㖣�{��a)�}-�x�KXl�蹓q�P����Β���#l��B��wL:��3p��t���R0ɐ�)J�!�r��[���M�NWq4kZ�+`L�����(1�������9ܯ��|���0"ý��Ӧ�mG�"��9g-j^J���ʙk�����~�\�ˉ�̼����"ݽ㴯��,2�,�eb�C�/��
GP���9����e|��$WT8R|���c��	io�<��+b�Ł�\�o����3�������d(�Z��butV���jU&.ҩ�-��J!���yl���ו���1���wg�ի�ՙG6n)ׂ�i�yS�i�9�Y]VP�r���fuˁ2M[NGh�z�'NC݁8N�vH\ d�kG��='_��ޖ�=��q�p;����:�9ј��H���Zf�c�q�U�]�Ѵ9�?6�-�6�˷�̼����}�^[6�I��?N�T��Q�%�,����?�ϨT�
�LmV�8?�J�1�P�W&�����
����s�^��:�T�P���?��W��ѳ�%V�y�U=P��WI,R��.끊��DFxR��Cl��&�90\�mf�36���F��uj��{��<�r��5z:����x��.��]M}S'��a�s�0��c���<8W>_�������rX}\�a��y9ȁ�7��Ĝ'��uL����]���Ki�5؂];�a9�ȡ+fUd��zX�+p�"�ݡW�~�Cr�Sb�S�~!Sܧ�s�9WWc�^�~���KyW2��
��)�O���8}qn�˃0��1=�r��.Iy���D
7�&Tݻɻ��(P�gju���SrQ��#fZV_�q��{�~�Rݫy�d��Y������v��juu0����5=C�v����{��Y�E^���yY��jCW-W?h{>$�>���
�W�!�x�S]�P�y<��c�5覍����シzAhݵ̇���gh�T���R����t-�ȱ�ߥ��L�C�q�wT)������|3pг.��\����r�^[�����a��"Ǌf �����ܳDNG���G�#YP�,����������_��?�y��ޜ��_�b���������������_������6��d�V�Y�	��bo�R���"ȡ=��j{I�y3�1�]Yb�yFL��!����\���-r�%ز�
�\ǔg�A���뇏��9z�z^����5=)r�z��)y��R��.	9���#�bz2�Mu~<��?���u���|�l�n���`[�s�)ӬNn��U�����#�ećՋ_\�^�U�;�-Fp�ѣp�<��QD�^C�d��K��j;��N�zh:�#b,�U������r��(�nB��{�0b��F�tw)c��ن8p���&O��1ݚ�//e����G?rs%�+�2�ph�_LF������s=�!�%ҝ��j�sΫF�M�ĴF'v�2��D��p��w^-r0����t�wN������[\5��̫����Ur-��s���A@������ȹ���\5_η�	���!9�WGa�����r4��pƏ���kBRb�<�eB+%��}ln���|ǙjQq�s��2/��Or�Z�a-�sfg+\�E^#rؤ������Z�程�z���`�E����Ϟ;��sY�3�Cwݼ��t\��a�)�QTp�|1�xR�u�L���z���-<dUQ�IP!�'�4K��se���wN�1�8cZ���ɛ�e������s������N��0|-�@�M�[��-�!����1��/�@àl�v�P���I�q�`��l��Ͻ���������>��kN#���*E�W���m��d�@ĈF>��+���o��ff���H~�뫭�Hށ�Q9V���7�NL��jx�C$d�O�qZ�z~Dl����G�F����ٻ�t���IrIz@�Y�W��;��y�-&Ʈ�W��ö������S>ER�R��3��8g��o���<�r�A"R���1�e���ר�YE�1��#,�鱕�@Ji�Qԍ�<d!���2�\�r��~����tYH\%�
z.ܡ�d;��n1��لA6L��	�䰹9�D侗W.y���1z c~�yp�9`�mLK�ս����z�5��p��Ŕ�Z�E�c�IR�f@I_q��&(.I健�-N_2�M|�@O����r�1��k�1�G��.~#'I;#��B�gȥ'��	�����H�Y��%�I)9�4r��C �HW���i�4�ԩ+���-I�=�"ى@�4�b�s:�^�5҄��(li���������"�^�����ԭ�Z�9������iJ�qA���E7�K/�y-���;���ѻ<��<�_�����������?��?��6f�9�wAm�3�����l�PJ4�Q�Ni�[�Y�����l�,FTK�z$5[�#{p�
c*��g�.��� =����M��������?@b�= �-ҭ�Q=��c���L8=rl��.����\�)�K�DP7�酇��d�-�6|+"1���ܦ�A�������V1(�f&��Aa�;A ��٫�H��1K?�*��b�^���o�bz��Kx(�4$W�D
�aH�Zc�g�ε��O�5����_�#rٵ�-8 E��)!C�6����zyTdM%h��>!�ldf��W��k��RW��k��FV�$;�>zp�aI��_���l��GJIK��z����x��^e��VNZ�(U    �u�ջn{���ܦ�9m�1
�Am�7�[N/�B�y�R�t��s���1�6�^J���ǘ0)��7Lz�:�l��w�B)5��9�DX��N�*�D�����qҐ��s�
�o�[A��|��	#dCN6L�i5b.%j���l��'�B�Tw���QZ���S�}�V�[�-Uϵ������0]��m��_v�L�Ԡ�Ӆ������c��$8=7L~�m=bl8�(pO��I�sp��[+�+y�����g�\w����o��HQ��g{��� @f�(x��>|Y�>-jY_�Q��gת�(�^Rm��t��#DҜ;xi`4H����(�+�4;Xq��-���/LE�L��o�<+>oկ��u��K����c�s�H�S�w�=G�'���Ei�498d�bgy�a1�����x�����_n�R��P��TJe�#j0�d)�P�3�D(zä�vi��\��2ى�I��?#��*�����֕^t���v�F���^1i���8]D51�w��5��O��}9̃������P�p��8'4����.p$(�����/���Mܧze�/�+��{9y��ʁ�ܒ~*Y��B��J�s��9u֫����i�A��;kz��o9�PO��j'�J�p�y�+W��簕�7���ɒBtr�?�����r�:�8�ZwNZ�x�q�P"FF�zߏb����S��AC^g/���|��k��	E���Y�g��m ����~(�Õ-W��G���`w�u.:�L�&-��t8��� ��"�wL�n�F��>�;� �"�ט��9�jQ��`����}˘����oT�3�B�#ê߇�&~�{�j�A�b��a@���*��b����Sg��'ϊD*ũۀ����_S[����v�����,���je��'T�+�Ǹ�6j�ى��X���:����-n�{*7+܋�Ì��g�I�70ʹ���M�j���R�\�l�q�3�t�ױ�K��3u\�C&��x�X-���-y>�雃�Ol�p���=T��v%{�z�`��e����L���Εӭ�ޛ����W88��y�3������#7AM������)Uv��3L��*�b4�x���8��|p̛���E_S��5�(���
	�t��ɓ��Z���a-�����܌�]ZRL'�J>�U���x�.�{q.�_mbww��p���'
��)�mFuaq�\�a�钬N0�t�����SG�4��U�m8��=W`��K�O�Q��:)ܮ�y��y�n��s��ϭ�I1�M�P�Lv�_�L�"�s��t͇`�.�+h$�:�T���E�I�/��ɹ:.�^�Ù����Q˵�vN^Up�"���tҚ�89Y,*�	�ߕ�'�9w�<y\���Y�3��1+����Vp�$U�,m���@���<��(���3�>�r�<���ɩha׭[�k·`J����������C���3Qv7�����!	���X��wR��J�����1I�:k��{�i��ON3��)ӕԼ#U�����oy�'m�X nY���T�Y�_��&�r�w����0g�q���,��^��<��3��6Un�&��k+?���C��&�/��{#o��>�'�޾a䍍���
Ŋ3^>Ͳ�m�9�|�4�Q�ݹ*h#zq���Ƹ�������0�c�@.r��|�?�Y�����0=C��p�ߜ60������a�Ðo!H�n�<z�����qo6�rä}���<Xd:1���Eu�{ũ�=F��,P��0�x��e��P�vv�!�)���}�x���:���W�a+�ε`��+�~Q�bC��O��Xwy�-�-v��h�1֊�f��f�c���׏��ՇA'҆��� ��5�n�W|a����s���[
\a!l�I��~֞�Ҿ9]�v4�U��\�V��i����,��k�O��Dw�w���O�~r�U�������i��������ȉ��>u�?d?e|s:�Q{��� *��0ZF>����93==�R���~�q0q�߭sZo�*�0*����C������z������rr�w���2;'_ͣbH�f�;'���@^W�b�������dr���힁��0>VЫw���ǝZ�����u���'�k>�4=����.�^�� DX�w����n����q���`����&O����g���OC���R�������J>,�a0Y�4�,7L^*8�OՇ��գX.Z085<g`|�3<#�^�ͯyb�}�M�q��0�+y�ԗ:���3r��B�U+t�\��0��p(�t�=G� ����2��^@�꾭,%����:w̃Ev�~Hf}��_�0e̓c��N�;hr����ђ�k�����r�b�c��^���S�Q%�[w-����qua��S9��y>��"ꤸr�j)�_�j]�MR{�V�߯��Q��7�o/�U$��=̖��q�����tyK��nf���|��<8�~�f01:�]��Q���bcjϋt�h��q-���"�{꠆�*1uX�NXMrO��Rɨ3�I��ꍦ���؇ҳ�%�Y�ԆF�l��=UM�aL���~OU����ڮ��p�o,������4�f�S��6��p\����������p\|�I��u��(%�yv���3;�6��UZɋBv�͋��zum(-�)�ܦq�����xN��h���2��ݰ������^�yq�E�u��s����b��sr~/k�8��>��y ��/��7b���2�{A���=�cl(�}��>̀3��}��r����mZ .��l��Ї`�%����O �����^:7~���]�x-���rE\٫�F��G�Z�t�<�~X��Rv2���W=,��06 ⚇Iǯ��ݻ�?� PB=�pQ����s*��5�=��Uj�v�9��X�Gp�*'��m���c��|!�N���sky��7Gl �z@�E�=���܍��z����?6\ć��C�e��ӭ�Km��@`�\���ӹ��J���@^�����i�O�8��p��F�b^|p�����)�Іyˁ�9��'�2V?9b<���q��-G�Gv��sü�\�%z�����j'�_R�i����o����[�����<����Yv�d��sr�������?؛�0��5�t��n���Z��ܖ�%t��-OEF�B�sˇb��P0P�nT��C'f�Qs�����(����1?�ܘ2��$�{�Yh�tK��W�cU3��%��ˇYV�g{[�Ba�،�ӳ
�Qځ����u��q5����«��4��8yf��jH�J얫О'���'j.Z�i�90W!�}�����aH�`��/��ߖs<O
�QT�0��<
�4t�Ow�K�[D`���ӏ�9�m�<�8
���Psm-֡���;��$<��z����>9�=O@��L/Hj����J�q�Ai�w�ǃA>wD�8&���x�����ft�4�qD�{V���y?횫Y��gw���|�!ar�=OA��-��9g�&��W��<8��Q0�� �8�{���6��Ohy
�C�R���.^���b�� 
C�ǚ���g=kz�$������oծ����k�	���%pZ>s�u`ؒR4Zu�
0��9��[8�� ]����q��SO���P!���Tw' ù9G0�B��N��*���;3ml�~=횵���~��|!�b�I��=|�O����gPs�-OE�p��A�Sw#�adv��n�|)W>0\��M0�Un����v�ߨ��l�,�'�)G�5yT���Xܨ��YG��A�y�"�{�P�^�kk+u�G'��=/�C�a5ϓC��z�k���V9��N�!���QI��i��u='�v�@����ֿ0�Wu�fQD���^���r��L�s��Sy�/�ON5>�cǌg��~��/i;&�.Z90lu��,n��@"�����1�v�n�����N[�ju����G�%?�W�*��^
剾�;���N����0|@v�g��^0�'T���0��W�/���N�cҒ����؄ڏ�*�    7����gW~�Z���W��1d�����ju�P�.��`��=�ƗA�`�䫸���{qJ��|I1Z�Y�<�o��-ƙ��$g�����^�;���� �=�r�\g5��!}컡�w���)*O������r`���I{ZF;]Nw׳AT�u��Y-��K�MNN3�V^݅c(o1�8s���X�o��3��O��\Y�Ҥu�\����1J�(���6N�	�2�ˋ�-.�����(�*m��~��p�D3_Mw=���>p��}�q��J��m���X�.��f��g�s��t� �#N��Wo��.�Z���#��p���L�ގ�����{EO�n��׾Ƭ�	n;&��ޮa�f�ܳQ���5��[��PGs]���h��z���wPj�c(&.���6����CE�:m�VW U�98y�t�k�|�3Ɋ�)����b�P�Q�|�j�Uˊ�!!�C�^���PI>�XUn|F�QY=��K�
�j��w����\�z�p���d��"�\�/B��+��%4�"5���=�#'�Ӥ>?�Φu\�M����	�������2�-u�[-�%�Rr6�1��K+I�;4�l[Y��b�]��N�.)I��]���v�3���#I��.�l=�	��t<��1|b�U�[���ɯ���Źbl��������1Y'�Ԝ���
0����2A4�0�.7Q�\Lb���!�y˙p3�<�Cnsד�?��z��Mv\��j^�C�
���M4��T���9z���q��㮍8����O�U��!�p����xX��{�H������Z,�J���h�j�W�j��T�(�]�N�]餯�r]4�����²������B��Uh�{�9�<�`H�l������ǉ�h�h8�v��Z������{�%SL�۸�`/g�r1��|rLTB��^<'B�3��\"L�ַ<ܖ�N�8�q˩�c�]?=d8�a��>S1{ƟV���0���z�h�+�0�A|LW]F���{�fJY�G�����4G�Kj����Wr��4�_i�i� �g��%|;&OԳ���Sq��Ѯ��d���9])�L�w<~n����%q������wQ�.� �0&�m�81Vq�7��r�\r�#����e��=�1O��7��n�%��r��M98y��QF|�D�C~��oLPkG��ye�	��S���kSp.�z��������}����oQ�]�d���ً�73F��Wq~�͌���S-���h���|��yذ��&���a���{#�����k�`t:0jO��p��Sm�{�2���N�
8��i�q�s��$;4b��s.�:�����>�Lu�T�zt99r��p1kλϝޭ�@�m2�|toG��1z�^���a%�o����%�=���QM"�}�W�G��ɌPnƙ'G`��\�נ�?���2�c��ǈ���oY9zQ��7`-d|s��[?����k�ԓr�f�;�-�/ei�諽p�4�(9��1��V��<��*�?�ۄ�UK���r�3����K&/<9�����!��ɹ��i�� �o��&w/�w|u��"��S�L��O���t3M?���>�{�|Zgr��L+��~�Re��K�eoY��qV]N���2N�0]V���#�soY���V������3�N����^�Ǥ34��fg��F��8��72�QOΰ��E������L���b��y�A'������2.���=RF�GnW䝌c�ɹ�(��s�<�q���Yi��z��β���+�m,�����;ޫ���v9���i�C/cr����K�Ef��i��:����tb��y%�pe�;T����Ӟ[�1�"��͟�=�������k��8��������f�<�P�][���c�\��u�}vW"ay����!=�w�~�7K�_��]��%�ag�/�>���9\z��~���fWLs޲�N��5-C��9�w�i�����?��y����x��.+qO3�Cb�ӬkY�ms9��jR�sǁZ��@'�#պ��3�?$F^;p, ��\S�4`VF�~f'�xH�M:1b�����=��t�3�_� 3����<WO��݆Fٝ��Q�s�7��8�������mY����#�.�����zc��`P�����̭���z>���˳f#�:C�E�
�->HTL�R7{<�u�Y��[�� ٰhb6 ��?](N:Q����k�5a��=�zY#��U��wT�y�d�$�x���wԮ�E��"F.Q��K*�%.��NۊU:�>HE�Q}����HZ<I�՞g�E�P]U=)���u��P�X�KL���}u[Vhd��Y�{�I�rc����J�=����Mf�������_Z�қ �z�NP��oU��^y�c��!6`�>

:B��a��B��u"�[]�B�j�;��W�]��0�l>-j$�S��<Ȳw"�!?T}���(W/��N��h;L���š� �����2�{9�qh"�G�paY�,e=���5���W������j����XwN��E,���/���~q'�w�bz-�W���^����W������wӯ������w���Nċ0���}�ּ�r?4��a�V��"�~Un����������b��og3��k��i��j�\��?�^�U,p�B_�_s�`04E��H�I�ybLG��N( E���YC�1�{�+���,����Q���hK�߳���ڈ��{4�X=-<�:� \�~��w�1���+���7����]g�[�cD�qu��t-�B'��*���[N��#N����P���ɱ�[�p2=�xZf�NŪ_]ԣ�>�Cf��E�G�g<Fu�{��|ŝ�j�&˙��v�[���Z�>��##�ڋ�z>�q�~b,�8P�<J��Y������!>�)��sԶ#,��C>�q�qr,�;1ҭcN��9��i���ݖ�FYN����̃C��j5��yRr�ub�HdL��g�.Ƭ���G�y׀���Y����`��p:ww�vr�*�'���gf��{N���� ��wg���V�?yd%�mq��T(9�7��G��9gJ�k�V���8�Q��=�4~7b3�������=5���'�N_1��;vO}�{����0ic�~b��w�v6,OKFZe���*�Y��tT�ʔ��E��M9��+�h�]z�K�N9�<8�Ru� =�x�AD���wI��f]'�ƽ�1���:G��2�W/Y -6��5(�����b�{���J�'0���V#T�RB�|�'�K��j��-�8a���JN��=�2;�R�u|�Ŧ􋙮��aFĈ04�+LDf�g�óCwä)��10���R}<������nv%�j^��&��	Ҹ�yp/�7�PB��Î�r��\������/oA�� ug
L;g��R�I�ѧuD�����<E�!���>���l_�����h=�@�8��N��ﳥ��-G7y=�����Nθ���$3�v�8s���$r�6>9�D�&���IKE"�\�w��q6�^L\a��/�3�$}����ɮo��4�<��Z�r�I��0oB�m��Nғ�t׏�WZ�q��#�s����ᴸ�J�f��*��9�Qɏlz�L ���xeމq0+ɉc��G䨜k��N�9�uV'�3��W��c�x�3Q^Vۄ���I�)'�ɱʧY��gI.�:�}E>n %��M������)�tS��$99��z�������'���w��sr}��"�s���tUڒ'��]�#��K�m�Wħ~����A��>@Wʃ�q�W���{�q)��m���`�I�$��0�?���v��<"G����Op!'ɥV���G9��w5G�id9� �C(k�\�!C�Vwa�t�l2דs����ǻ��"[7�&�>(5����eu&��o���[��` ���H>Q�3���}V���h\��q���$��M���ت�t����_0�|q�<������ ���J��:��T�oD<�_�vT%.�qE9��-�k9����<���鶔��H���2ˉ�����\Z�'��W���    uj���l�wp�w^��3#n�NR�>���)�m@��pM��'�"�?����)�[�D�y��<����M�R~�潈����n��g�����x��;��7�!H��Nyp/�)�(���*�~��k�ML��E�I�x�鍫�ʗ�q�zp���z�rmN�+�F]S.�.)�[��kJ�#Mr����c����#e�蹾�=�����qF�10b`-��7Ln�{;1�Z��*ſ�T;��e
;'ϑй%���K��{�,_Jϐh\nt�X��ʊz=-�W=�C��8����H��`����_��R �K�����h\�s���s�L��e|�iH��Ewm�;�9mN��y ��i}�j����G%���L��J�&	u^�悔��No��:^B!˟� ��f����q�ԋ��Z�{*F6׸_�B�DH���?V���]���{j��@�PL�&��٭��'i�h@}Ջ��L-g���>6��Z�s��]�W�VA���&<�é��߆��e��O/Կ�?������?������u�}xPJѿ�����������O��?�׿������������Š�/Ē9������G�M������f(G�Q�D*c�8��Ěia@FGl&Xٯ������gjE����l��/_�.�?5��D}:�� ,��o�u�����B�iL�z=�/�M��ђ�v^͗H�4rY�[ܘ0;s�v��u��_.c�Ε$ފ�/tN�@YU���A�)����9'7?
��>�3c��iM���gr��o˜�{��^f�ǈ�c8#��vO�DΑQ�Z5�SWY".ȕf"��ԥ���_ꍄ�7�V>�φ$'���L<�;*;b{LE�)�d����W������"��GWY�R )r�!�q�4G�1���Iْ��2x��@Ź��D}��D��3g�8>�[��(��kp<F�K�➈�S�Z�#`���=pPg��ܔZ�i��Κukrl��I���M���e>p��__ׁm�!�I]�xOb��Q`����sQ�J�>��1Q9;DZ��m��RP������u��P!��aA\-�rN��ګݓ��_�lx|Ml�\�������J����l�E;��E6��z���X���56ձ�8�kw�$݊>�J�� ��iN�?Hl$������oȚ�	�S��
�-��EB��)n�A�GQ���h����A�-(@�ɣD_ih=:^"Yݚ�p읗�R�����q!C;��2d�<�pV�>��mL?P�z�c�ph:P=�Q�Ie�Uf��Hdg��M�H:}s�m�F�e�uR;ģD/3���M��|S�l����M{Uj�A�L��0�>G{ ���ɕx��Չ�{�Bm��/��G�C��6���%3:9���S�t��L�r�l�r�Q�lS��9�Dv���(HV������zv��:J��P�����~�#�$�D�p�9�eW7���ӥ��T�U���Z��m]#�(�>�D����{�$~W�� �B�"�7?���F�A�7�p'Il�S��<� ��X[�li3W2�y��s�	����wu!����%o~W��U���Yh��tI�bյ��&:@���۝{�[�R��h8�q<��.�{B�m$��ɛh�:9��8���*�Q�t��p��7	�`��2}�?s�`��@���6ܹ���,�;�碫a�K8滞p�<��|�V�	֜2'��m�|��y��_�zڬ��g戡 @���u��3�{`�Q�T[D<�R��ň�fϙ&:[+'������aDg�c�'�D1�ZK�G.]��)�I��:y�]��Y��F>�"��0iX��v`��
���ſq��^��мp��?%5��N���nA���q���{��XA�d{�j䨽��Ek�1D�
r��M��誘ub��UB(s�[;�-�_�<Sr�T���im�]��í��{{֥w���\�;�G^ ���R�é n���n2��F��]��f���d\2�z�BnI�L?�0��[ɔ�����r`Pކ����>LN~���f7J�j�k��,�A�8&�aJѴc���s��Hӽ�w�y`�:�a�������Os���[�܆I��j=�0F6��ƴ�{�i��=q���{�y�|?�Ϙ���
�yu�-E���ٛN��m���,潪���lK`�G������#�.&kd*��Y9P�N&��c��f�k��t�YP���z\Z��X�c�)�ݤv���Bu�3�a���|ü��v�
���RwQ}h˽�������c^�Y�vH��;s�����Ъ��Ԙ@X�4RN_�'S\C�X�2�8<��90P�̔F��)�Y��|�\�D��!����F��+����N$�wN��s$�;�nj��l�	���c��'gX�jSù����P,��iV �����V�LL�-�t�P�ii�����Q>��ij�8Sҗp�u��;��O,�2�ף��wtBE'�w�ۧݱwN.]�ͱɉ��ͼCE����1��v��'F��J����"�b���D�����&C�K��Bc�.f>�t�:0}���\��/����-ƥyC=��������ƥy�+p�څ| ��i�Ȗ����\�1��|��sz���k%͇���Z@h�rC���>U޸`�[�G��0�L�ݽ������L���^��8A�����CM�>�� ��!�ν����c:��~^�,N��p��^��l��ߜ^>b7�8�B_�a�9���;�Zn�ǹ�1��Pu�&C�p�~׹�	���X��s���%�T;���^���z�n��E}פ�y?�=F�S)c~=s��9΍�&.��m�o�r-����?t^�����昄�~�����b>-�Ui��q(���z����失�}��E�,2����W�N��[ѱ�'�TX��A�����|����� �r�;_?���R)�B��86�̖�=����������M��AYm��le�Tٲ�F�"M�����|�$����^�ޝ��|����Z��W�-���\0���͇V�Y���g��v� ܜ���2�Kl�W��-򤃣����bu �?����oN��4jpD7L/�߈���S�t��_=�������O<��)�����C?��'fY�Y�~���fo���V�Fk-��ޣЖ�V?���ܷzG�"rb�Z����ܽ��6bS�����N��kCq:]3i:��z���6��R�s���R��.�bW����rr��vR/ћ���yr�䫑��[�t�3M�X{�5O��1i:׉AJ�,���.u��L���)��e,Y9z�n��|h��戥WJ�8t(,n��^�&�t���f�؛�}ct�K�����>��̰K�Igr,�����s�}0�̇���Ύ��q�Q�b����G��cL_d9n�Z��b]��A8���1�h��F�Y|�h�~����������LӨ��c77� ��!��`��A�T��� ���������`t3�\�a腗�/����(37��ɹdiP�V٩����k'�t�͡/��{Ź)0ct܏�S"��<�U�b��{�3������1+�E�}�}k�|�F�Qgt����;�$�Z�-Kh�X������n��4��_��iT�jۭ�zp'ʁ�l��iQ���gi3�ܛ���A�5��N@�0��sK|���@��"���wsU?��������a��}�O����;�fN�X�sߖ}zq���,�)ˎ�W�-FhsjQ�Ə�e�o���+�VQ����F�{��8M션���S!��$��Z?͢QIp@�RG�1�c!뎏�S'��Uf�TsK����NA]Vl��6	��rHE�X<���
aB�&�֬��ڐ��t7�w�ӄ�UN�@��/z8�}իi��o��J���B+�ۉ���ր��G��%5Z#lX���!��oh7�ɒtw�:,~ݠ�X�k�+����DB_F{�����Z9�pf�_�(�߱�_�n��u~�>d1�y�J��L�����)j�R;NE,Ć�7/��{	Y���d�iᏝ���r����z�c~�.=1�ɜ���%I�� C����ז��u휈�    zHb����(��v~=�0��iV9��^=���*��叺0U]�2vQ����Q��=��%�:�zPD���.x�£�¦E���`�o����'�R�f�w���ߗv��?����Y���%h�k��^��Љ���C��}��u��rW���e�|5�����O:FO�ٵb꟞���A�΃�a�Rg�ǡ��<Qd�� ��t���U��ꨵk��������-��n+6��I��Ο���52��r�f]'���̬�c�G-��Y���+�Tk<1�y�]�Mh\�j%�E��cM*������|l+����>e���,��q7+*�0����?r����o{>g�؝leV��E���ӗ�2f�ɉ�@��0�f7\Ȱ�Q�N�\�^,XjtS�^��૧�����!{ǭ�k;gdz���!�u]��eQB�<��g�r-7Ls�t���)��uI�%i��*�d��\]���'�F��R�+O_�zns�c�R��KR�QH��%C@��7G5�^�����0�_���:�j�.�G�!������2�~�nճ�ǥ�5s���1��R]�Ò���χ���x��g�4��:0���Ԓ��9�*��u�E9���F�Bp���P!�U�����|�=xa����e�h]#M��ctW�qvJZu.c��'��A�zy�2�e?�F����Mh���,}`���&M�G�$�Ժqf�@�W�Ǆw1fA�ä˘�:0(�~A��d�5��y��|�=g��J	��1D���?H^��9��{�4��j;1V�K�Rw锬/�H�����C�tpȪ����sR��¡�*;�V�����N:�l�~re�WV�<���U��@�~
����]�������ɫ���H��3�4����[��EX�ɗ'3��,Sj��l#�wL:5�3?Eo�n�ʇ���C|�Su�xӓ�3#�z��{�����؈#e�v�����j��i����o磔��h����ß�^�8J�Ԍ8c���(&^�vb�u����s��|��]Q��<�jnΊ��yT�e-�zr'�����"B6Pvi(�Yέ�L�]��7)��b����H=��0o��0D�k�1i��j����&j��F�QХ,�8c."�ɝ�&3��f{�wk��y�9���{�[}��K��8�@�[�S�������>�8� 3��iW�j��@����f�Gk:�,�t_��+w��	k�E�F�^�RŤ#�1�j�������V�Y�r�4t�����=�%�s��_?�`7|^1���,�.{9J��[TN�jս���Y�a�刵t�����'�y���XwO�~zX����D�9���QΥ)J�͓3a|�S/���G�5������2j��P['h���� �I�=,9Q,e�^"*�sX"�Th�����
Q�^A:�"�B�=����՜D��t,u<�Gͯ��Y��7�	�1H�����I�qڈD�YܙKy ���1���ù�Ntp}O�3�礹�i��Tk죲3Sy���*_Q:2w׏s7=��r]����$��~�̱�`������|�c�S���vLZ@���a����:�0�{�g�c�̬�i��rȣO|t�J�B��{�^2U��#�����յ�,��t��^Ӊ!)�aϓ#H�S�~pҶ��M���\Kg�˸)�������ީ���ڦ�^��2!��yO%��`�s��P��o�L���]Ru����&���tr��Zk0���t1�~�%��y:bf��6�f0����@Y�8L*y󖡥��զ$���|�0�(X[V�"{��(��ӈ�jis�IԦ���4/Dq�{3y�ܟ�?�G�$4�����������:�cF^�bs��*P�1�������#x�4��|`���Szo��2��?fL�\��➦�9e�`�WYCo�?=��NK�p�Xb��R�-��H.��L��ٗ3[�#�,�qp�LL�t7��`��I�H�O����'�y�+a�g�y#U([���6қW�nfn�{=9�L�5��/��N�l���|�n�~E��3���ǡ|w��CV�'������;��Ύ���V���tH;պH1��Ѐ>�r�s�K_?�ʠU}g+�K�Ż�Ič�i?�r	�տ~��>�.��k��s ��p����%�XP����V��t��;s&�*z?00]z���5�'	�ߛ�}eᶋ퍒k��bЧ���~Ճ�N����kެ��Zy̢ˁ�����$����1�>N��r���wkW�*���4��Yk��Q�~��_EP�6��/90D����6�nb���-C/6�W��aV���2g�Br�&YH91��>�������Ͻ��]�k�r��exG��v윑ڋ�3�z$���ei���A�qr'9���b��FSrz:9Ê[��^sͯzG�
�����K��L�Ki~�< p�Ԫ�g�x�L3ϔ��^�?�o9�8���vE���ɱ�>�w�<��/���.�Pk�-�89dJm�*�Z��'��1���jFn1㬓s��)�yZ�-�rpW��\����y�6��>�Nƽs��p��{�NF��F�5�N�W���Fk�ɱ������E��9�W��j�D�F?9�j��[)�=��[��b�'l�n�B�yr�|ˁ�:��8��c��nBΗ��ɍ�-�t��mzX���U������֕�Υ,=Y�����g99~C��r�h�t��PV��gY��29Ը`#�Lr='��k�g;1����B�9iS챽��,H
�YxwSs=�cw�ac���m�n��6�M�:L5�r�X���̈́��]�����t` h� ����H��K7�pȸ�zW�?N�g|c���>!mmwf^�=�azA�dǌ��0��^>*�b��6����f2m�ݎ��������i3�[�=�M>0P*��*���>U�iu�-�1����������'i(�kV��������,��q��)'g�X�ҋ7��Q�<�=�9=�����!5�C����}-�T���y�!�eMju�����81����V7=6+.N͗;ћ͈7usH�/G��ҀC�fc�<�1��1=g�S��$/-8���[m�Px��k�;�zt�&t��i�lK�1]A�I��#f��}�H^~qxͮ؄�]����I��Q�,m����b�� ��a�:0d�m�ǹ���%e���E��#w/�4���sc�}wE`�C?.ngj�a"
�E_R�1�2���BF����SR[W�f���T��1�R4+��h~��!�*n�|N�Ц�"aJU�!/�?!(:��\w*��J��ܨ�@eJy�P��%�< ����H~��� F�k��N����J�3~=�I���ERiP	�+6����"@<lE���3??n9Ĵȇ�s׈�\؇[r׵4��б���0���K���w��}�P��ƹ�������H�z���r*�̝�+��a����>�q�0���L��Gщ鶰�^L��t��%��`��:��z��<ҲK�O����WW^�t<�q���m���j%7���3j�I�K�^-��Q}u��I��E�l��F{HN�50P,�z�8L:xf�b7�.�4����3N������r���1�]P�~j�Ԙ��;���[N��^ug++yƠ|2z������I�4l���C���gI)��\�*��:����}.)���~�h�ݕ-5�}|�i���~�I�F����Ĺ+?�ȍxKH)��tTgԅ񍆭fAC)�N��0T��K�4�k����q݇`��&'�>0D׀�Y\:�ل�_+�4
m���	�����@�a7�ͿXɆѕ�te-MLJ)���w�����MV�w�A�D������|�xk:`�	�ON�J1Y�c���1]:��ҦR�88�\&u��9��$!u�Au���a!{�lS��4/�� 쏓E�C�տ欁WJY'Ǵ�;���s�,{�S��O�4/)��-�
���b�{;'s���zp؆I�=�-��`�S��v����d���O��mKӒRj;9�zv�k����5w��ڴh��rBL��v7iRRJ�s7�.���
��!�!G��N� �
  d7韃cR[����ZY7��<�n�Y��5�3]��ֿ0��&�bVۨ���)�Rj?)6��M�g9�̙�,��ɹF���ʄ?�����H�A�sκ]"��iZ:�QJ��>P��e�������up�yݨcp-U9���7mc���\Ο��Z��PK�4�������z�_?�k�zEy���1Y <Ġm�=L�����I1Ǡ�Qrƫ�1�?c�*.����yc����M
�&�g}�!͇��V��9������*�� ^t*c���b!�������<O��.�~���7��apL+�#>ԋ����� S?�j�+N�V�M�BD��-`�P��Fe�~T����vb*�e��ɶ�$K���k���j�U�)�\9�[��� s�L�&�5�����3z[�9Y���v.e��t)Oq��6��zȑf��;'�m����鸬�?s�yd�����5K\�wK�4~�]�|��ܛ[�r�u�*��&�m�ܵ8�ràw�v'���D)ML�{>��9����/g��h\��&JHy�Avӷ��'%����;(��F	'7�6K:+��]�&��f3�Lw@%�>k�Lw4+���7�6����G��P�����i�O�X�m1?]�5��	��:j��b9�0}zG�h�'{�I=�V�-�=jVC�Щ�ԫ3�f�ˆ��D�莊>�
����X_���V:׌
9�d��5gK���S��k�0WL�/ �&����27�=]Y�'�`ġ�Y�LV-�`D�xN��9���ge�Rv�)èkYt��<�9��=��[��i�Z~�jI�tA+$ ���zt��3?{]��`�0$����=sG�0�$�[�=�Rv�f�f��>+Ai���}�����)䒏���@��1���dI�s����b�9�UJ�[Cd���*Y��ׯ�R�zۯ��e��7/��4���[��機�_a��n�=�K51z��p�j>�h�0Y�p��n��6LV`b�m{@�߿����4|�}[լW�kw6��B��=M���Ey�Gj� �/^זj�� e�2�^��}t�u�g�����ccQ
.l��d­!gN�2n��$��?�����Y�!�y��>���a���^Ʃhۚ��ң�/�Y�ĐI/��O�e%RR�[�n�SA��'lH/�Y`/�HG���dj$_��8�b��n���ʯ�c� zf5�c� �a�z��H�.�������3��������\�5ġ�<'4�������;���"�����zb ������&��r�����s�����bJ]-�5b�}���9S?z����ZVԆ[Z){ѫ���^���H+��a��>��Xc����LgSU)LJ6�Ƅ:K�p5�O뾭�R��'�M�����2���'���(�P9,�9�s�9�_�m��,�/F�[�l�{�ou�o~�֚V���
S��i)m�1�7��I��A�Rx�;%����TFU
σ��͕��gq:����
���^�x�ì���C�,�N\\6Yoe�8��vMpPw�E���>z��q��K��
8K?��~��A�dM���eJ�5��q�������Z�
5Vv�g$y#�trB?$���x�6���^����$�U0���=#J?���70:C�����t`�Օ���k9y�T�c�.R};'7ʽ�@G�[�<�p0�ܛ/�o~��2����}��b�|X�k��0�qÌl���2��m�]Ɨ�]N���4�Is9#��}��a>wo�;�#�n8��P��C"�����n��qu�<�p`�ܞy��c�}���_��Z��L4:6�)���Z��LP5~�ROκ�OE�o���]�堌��+�tf�i�hv�g�&P��z�<(�b�Σ����l�h���z&�}��=�R�U+���W���o~��k�kU��o~���B��q2q`)�Oδ�3=���=3�k)�T)�է�wFi��yR\S1�{�0�㞂�2�}����d��}�B����Ӡ^�M+�#E�����f���ze����:��~�+���{+�a^Ye����T�K�2�F�[�`����0����G���%�452{�ӎE)����պ,�.��%S�	8�O����[d9?9c<"����P���06�]֩�q�THB��]|�˃I>�&g)��q�A�!�i��t��ŰQ:��΋�g��~�G���9y�8�M��T�w9^�yhy��k1�Ҕ�Wa���I�A���rͭ�'gA׉;{QC��y�9�i�����D��Yo�~�d`vyvޣ��X��-�}jc&��3u�/KQ�KF������TC�O���������;
�r�Ƽ_��:��Q��{LU�-�v��殾�{��	�y��/�/b$���zu.kT��(ޫq�����u̸��U����{l��.{X�ҵ�x��"���T��H}���Z�T�4HJ謹�J�_I�AIU�=V��}/*�t����>�8��e�nJ�m��\J$��7�������2� ��>����׿�?������?����~H�ߗn:�Ӯl���_�/��]���_���/��������a4V���f�gk:�h]i�74�`>M�f��2q�n/�Z�����e�lS��\N��i�ź�� p�P���@��SK�=�T����05�j�3��u:~ACiMG�BB��Ġ�iИD����2���Ϭ~LFkJ㿞X�eKf,��>6=g�-��_ɨ�Fx7����a9�K��W���%��7��ߟ��������:      �   �   x�u��
�0Eד���d&bV�ࣱ�ͮq!��U�_���B���p�^m�� �o�1T��k�1 *c		�\'U�q�:�03�7'8������$gWs�ŕ��j����BjR�9S����/�G}}f���^UN�ii��Ҳ�f�� _@.�      �      x������ � �      �   �  x�u�]��0F�ǫ`T��o$E���)�ԇ�H�%�W	�����<vB�|��Y�K�J
v)Hb�ظ���v�KU�M��d*54�ǯnB{�Ԋt�ۯ�q�g���x���4�#Ҥ�L5��>�
25���{ �d*y��c{�����T��<��\
�2��F�o}�@�JE��G�`%�6�2�jz��� �*��o�D�T�4ܦv@R ��-X�GG�`��3t��	��	����s��c�u��������rۉl���03�~�Kw�'���"��
3�7����13�� /q��עf?�̄H�&�@t@\�Kq���M��?�Yޡ�L��e�i�Ȣ:�wc9�l���ת���[��;}2�6�q��m����+t��g[J����{����kx�|��J��Rz��=*��(Acbf$���Y\�Nk=r,dl���R�:���HN c��1�/�9B�      �   F  x���Mw�:���)Xt+f �եX}�
�`՞���/�(�����V�vs�Ypf&q~�L0Pɪ�ުO/�F�`�Q �L�`�P�$��q<�{�+=��@P������QO�{���w�J�����h�v�!�5Gw�!���X�e���ˈ��&cdj�D�]�-DK �x,���</]x����Rv�w�O��r��� ȹKi��Db�gf�	h,G|r^y�Ԩl�Qg�R	���tU篵�Y_�+��=>P��j�l�����+�.�nl�M/ d�n�LK�\�B��ԧMm����/�9��!xY&rÕm�-Q�N�DGe�-��p�#Zz�_}��7��\kh	�T}���;�v��|�o�����MdUG�3/A2S���(A9rU�)3��+�ɋ*�jpg{�(�)a�$o��`��2�Y��|�'���eܬ��j]܍�^�-��(�5�/vG�m�b<�מ���Y��4��0Q�П6��*��+���T.�tA�?7�"?�p%�Wr� w�q�<�x����_��=U&{ej��؊�V��C��묧Is�8=��F�k�;䪉�]�o��yr�?�A���������o>G{��l^���Am��:]��q������*����K[���؛�\R�e��1��*2��t�4���@�c5-Wv�g��[Y<*#KR�5 V� �J�z?H�ĭ�v���(�դ��=%r���/~�l̔��h���9�L���k���T:�U({>����G���=Ts[�ai�*�4������
�Q��b����b�L$�#)�Eg��{�ތ�ӎ{�9J�R��/�v��      �   C  x����ql7��(&�8�8|���_�U�j�(^�&�үb��;ԗ�'�G#cb�5$�oM/�П8~�������E-O(OJ�A�DGw�1����t�A�DOO��I�/͟�8�Q��-�I��Ol�a(�J�?�c�+�Ǔ�1���=uƠ�C�/mO�O.�ADǜD�DG z�$�͠+��1ig��+�'ק(c�<ޝ�'��1i�w^���٦�0ӏ֟8J��&�K�!d��B��@����dli�O?����⩘�5Yԟ��e���-SØ�3���<���_��W�����jy���^���k'���MFgLP{��~0¶��`�����w�DD�@�1|湂�OB�JdL�6��+�TV�LZ#v}�2&M���"p0��ڿ������ZK������裔	V/�9�׹1i��y�a&-[�2}0�n$��Pc����z�GL�}¶C��t�H�e�`�;�۪��	6]��a�\t�����A:�G=,&5����0�a�1�!�γ��bЕ�q��D++b����zu0���cx�\`{``z":����,���M��m���WK�C��j��шN�?9���M��=�,�#	�:�3�KgL���eϢ���;ք��AO^G>�{,�A'C/�0���lJ�1��S�`U���;AC��L���8����`��n���Ǝ��{�L4��[�DƠ�ij�����=v��3�F���t0�$282��tl�2�D��N�1�l�u���͸�y+��1�ُ=���?z��gu2讚�M�� a�-�N��й�=4�{��0蝌���ƠG�;����dȁJ��cz&z]���a0$Ò�C�l����d�IB�)�@�yU�J>��OU��+{2�,�{�cWH;2�T�\�N�������Y ���aX�Y�wč1�,2}+�Ef�j}� �mLƶl�y�瓘���:W�)�ݹ��4r��Q��_�y3(���G�|��S[�ۑ�7�/E��%�o_��o}>�hcz�z�z#zݟ�6�)Y�>�n�.�1Q$����z�T���8S��I�Ei����i��Q���D��߬6�������nc�$��r�}2�$	p�;2�A'�Li��m:�l}�0��̾�:�[��|�L������=�ɠ�����O�$AN>�'{��z!�)���Y�$2���z�<&C��^��	�J��^�>�e�à7����O���;�����;2&���me��`c��61�n��}2��m�o���n�W����'��A'���:u:�Ռ��=M�A'�����Aw���	�����f��p��v7��n��2�8��׍����A/D��:�1��i�l6�=�WӃA�D/d��=��u���!g2���i�`Е�Ǣ�1���nBN7�<B��2�̪��i��9�j�x,��b���Wھ�mL��PؾC~�C�*��Im���W�L� 6���Ƥfb�5���m�3�1���}M���Vo���=��d�,3��Z0��i_�%���Bfv����b�u�9��k����j����0�vs]-����W�z{{�:���#"��      �      x������ � �      �   `  x�u�ّ�8D��V���<d�Z0�۱ ��1_o�%5+E�J�j�b���?�^)���o�?����HC��&?7��,�R��%���;&������K[���p�r�h1�~U�s���b(����3��?�67�y�b�x����M�b�t���Jܾ���?�?��,*W�~���e1]-��z���)իe?���0�c4�/��n1P����gNh\���[���P����P�>�2������b`i���1?�we`i���_����~_h���OXڞ�y���\�m�xX�n�/�r~Kۋ�k\G����d�"��x�z�X�^?���O��@wKۿ}�����_6���R~C�9���,���B�!�&q=,�vp_�a���"v�u�-�v<}�sC��~K;��K�	w��K+�O���e�����5�+��`1���[V��� #G�m������x�x�bzg덁��ϕw��X��-k�s�75�Ypc`eG����ɛ`X���9����� ʆ��P��bgy��ޱs�-��ۻ#����� ֆ�ޑ��t��2��,�{ǭl�x˳�\�L������d�1����w�w��D�����)["a����0���oW�0z�i���>"b���d::d|�Ę��6I-�b����v��� .F�9|���Š2��xI~�}�U���u����qcP�W�&3Z������U��J72y�����A�L~�g�zT��(~��0��ɛ{d�rN!�J��
�U���Z�Ƚ�,�αU�2��uB:GH�K�w��\V�������+��W53��](U�A��~�d�u��f�~�c[����C�_����
����Y�����A����,[/�A���>mN_W�A���+l^u��ʠn��߳�/��A��ݿ'�K��A��~�r��O�͡boѪG'Z�-Qs�>��{�=�?��Yxt�>>Uw|�r�1���GwXI9t�c��L������/��Y����f������Rf2���pmj&��&�;Ooj&��K���L*���kd7��n1�����~~+����zI=2��L
~2����Aͤ�'��>��LJ~�+S,5���l�oE��;${��Cʠ��ߡ�}�Ơ��ߡ�k��	ʠ���!��
Y�	�⹊�&(�zB~�r��zR��p�C�zR��N��
~cPO�ߡ���W�������iI�V<�~�J��`ʠ��ٷ9S��h�à��鷗�|�0�'r��$��r&�A=��n���~I�bPO��K�s���7�F%��9��<��T�DN½d{w+�z"g�N�|ޟ�z"��^2�[ύA=i�'���Cʠ���'ewk1�'��I^U�A=i^���`B�ԓ�u��q�����q�����4�+1�
����e��$�ɾ�va��d7��(�azRf2���6��	9�*W-�[�'�O�-��Is��w[�C���[�"M�u��\�'�O�ھ�A=�O�wߺ1�'#��a<�ܕ�'#9ɮ�`�ԓ��C��!��hG�Š���CF�7�L�0�'q��D+I�È�xG�ɽ�M��ϲz[ē8�L&#���6�$��߳�k��A<�c���]�0LO��,qk��0=�~2�;ލaz��d�=j�s+���$c�\��$�azR�d
��.��i]k.ӓ�'�ӡ�A<I���sU����0=�~������)�7)+���0=	~2�'o��$��me�0LO��,��aa����u]-��CYN-���!���{"�1LO�E9#���������֩��&z~f��S��05�篔MO��������1LK�yǮk��<W�A%���}�������u7uDNޜ�r��1���Aю�      �      x������ � �      �      x������ � �      �      x������ � �     