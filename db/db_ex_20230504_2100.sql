PGDMP                         {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
                        false    2            j           1255    34652    calc_commision_cashier() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier()
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
       public          postgres    false    7            k           1255    34766    calc_commision_cashier_26() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_26()
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
       public          postgres    false    7            i           1255    34653    calc_commision_cashier_today() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_cashier_today()
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
       public          postgres    false    7            g           1255    34586    calc_commision_terapist() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_terapist()
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
       public          postgres    false    7            h           1255    34764    calc_commision_terapist_26() 	   PROCEDURE     Y  CREATE PROCEDURE public.calc_commision_terapist_26()
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
       public          postgres    false    7            f           1255    34591    calc_commision_terapist_today() 	   PROCEDURE     .  CREATE PROCEDURE public.calc_commision_terapist_today()
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
       public          postgres    false    219    7            �           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
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
       public          postgres    false    228    7            �           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
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
       public          postgres    false    7    318            �           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
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
       public          postgres    false    7    257            �           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
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
       public          postgres    false    7    276            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    7    289            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    294    7            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    295            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            �           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    297    297            �           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
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
       public          postgres    false    217    216                        2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            "           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            +           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            ,           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    315    316    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            /           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            0           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            3           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            6           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            @           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            F           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            J           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            Z           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            m           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            ~           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            �           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            �           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            �           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            �           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    310    311    311            �           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276            �           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    279            �           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    321    320    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            M           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
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
    pgagent          postgres    false    323   F�      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   ��      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   ��      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   3�      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   ��      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   ��      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   @�      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   
�      O          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   �      Q          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   ��      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   ?�      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   ��      �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339   _�      S          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   �      U          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212         �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   �x      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   �x      W          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   �x      Y          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   \y      [          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   yy      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   �      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   �      \          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   a�      ^          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   ¶      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   ]�      `          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   z�      b          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   a�      c          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   ~�      d          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   .�      e          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   K�      g          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   h�      h          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   ��      i          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   ��      k          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   ��      l          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   �&      n          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   �6      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   �6      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   �;      p          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   G      q          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   dG      s          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   �G      u          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �G      w          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   �H      y          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   J      z          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   $Z      {          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �[      |          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   �`      }          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �b      ~          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   Ed      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   �i                0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   �i      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   �~      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   Z�      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   ��      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   N�      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   �      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   o�      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   u�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   ��      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   ��      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   �      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   ޚ      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ��      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   5�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   !�      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   s�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   �      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   C�      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   ��      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �\	      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   6^	      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �f	      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   <h	      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   Yh	      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   �i	      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �i	      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   j	      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209                        0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1623, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2312, true);
          public          postgres    false    220            	           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            
           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229                       0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 426, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 61, true);
          public          postgres    false    315                       0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241                       0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243                       0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245                       0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247                       0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
          public          postgres    false    255                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258                       0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260                       0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275                       0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304                       0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302                        0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310            !           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277            "           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281            #           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 6575, true);
          public          postgres    false    320            $           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283            %           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            &           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            '           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 89, true);
          public          postgres    false    288            (           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 72, true);
          public          postgres    false    290            )           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            *           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295            �           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206                       2606    18461    branch_room branch_room_pk 
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
       public            postgres    false    309                       2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210                       2606    18467    customers customers_pk 
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
       public            postgres    false    313                       2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216            	           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216                       2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218                       2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219                       2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219                       2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223                       2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225                       2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339                       2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227                       2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228                       2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228                        2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234            "           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            $           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            &           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            )           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            +           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            -           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            /           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            1           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            3           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            5           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            7           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            9           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            ;           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            =           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            ?           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            C           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            A           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            E           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            G           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            M           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            O           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            Q           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            S           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            U           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            W           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            Y           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            [           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            ]           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            _           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            a           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            c           2606    18551    roles roles_pkey 
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
       public            postgres    false    311            e           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            g           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            i           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            k           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            m           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    282            �           2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    299            �           2606    34590 (   terapist_commision terapist_commision_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.terapist_commision
    ADD CONSTRAINT terapist_commision_pk PRIMARY KEY (dated, invoice_no, product_id, type_id, user_id, com_type, branch_id);
 R   ALTER TABLE ONLY public.terapist_commision DROP CONSTRAINT terapist_commision_pk;
       public            postgres    false    338    338    338    338    338    338    338            I           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            K           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            u           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            o           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            w           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            y           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            q           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            {           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            }           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            s           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284                       2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294                       1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225                       1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226                       1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            '           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    206    208    3581            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    3599    219    218            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    3697    284            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    219    212    3589            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    235    225    3618            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3683    274    226            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    227    3613    228            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    228    3697    284            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3589    212    228            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3697    284    240            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    248    254    3645            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    248    206    3581            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    248    284    3697            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    250    206    3581            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    254    3645            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    261    254    3645            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    265    3665    264            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    265    284    3697            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3671    267    268            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    284    268    3697            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    270    3677    271            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    3697    271    284            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    271    3589    212            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    235    273    3618            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    274    273    3683            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    293    3697    284            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      O   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      Q   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[o]�u���_���Aź_�F;��QZlj�@.���@��{,QG�szor��ǧ<���X#�2Ɯs͵�w7߽�����7?\{s��W-^��������Mp!�q������:�n�j�?����������o���������_}s������77������7��<�ݞ�V̇ߕ������n-��`��`�0������ý�O�qL��"h,��dEM�pv��1i/��$�1CJ�S����ߟ~��',������7�|{�����ww�����z|w�����ۛ?���o���G��,z��������e-O
�B��u��k�8�V�� Ӝ�;�|/d��9����2lcWCj��
�sk#�4�$3�HAI��g�
)�*�u˲��/`���w��ko��������o�{{������ѹ���=�|U1�I�jFV\!Ia��C��<k��2J��e��!�{A͹;�a�$�=�4I�Q��i���S����	L`�_@��=�F�t�ՠ�\%�6"%~"�9�DJ�� �,ڨ�����q���������|��{��}����*=���x����eL�׹���U�H*R#jΌ��*�Jb�B
�L��$m�cN�H�`'�r&�I�	��)�zt@b�,��1р��l_O�T��Fd=�#ͺ#��/��}͡����o��O���J�XtJ�:i��C�w��D�2+$�ԑ��w��]W�.�4P�b9�*���=��j��@*r��^_=�"�)��]�D�4i�$0�3�5�f�Tr��,�Ae���M|'k͸_1�	���<�OUs����������E�FQ�i 0in�nH13���`�NJf�bEE���f#K8;�qJ@:,�l�fEϸ r�')�� 0Y�=f��ܔHIIƸ-`�+n��~'EO�����@*��E�i��(�$Ή$���sݴ1���*N�Nf��
�$��")�Ƭ"H�©�8�&��-�pn�m<(��!7�iH#����8ZiJ�3c��9�Tb� �&b^�Fj���Z6Y�=U���{����ʊBj�"���$��$0�3��ڧ��bbͱ̎�@�?���u�8%zr�n��B������l���zE�a�v��t��(\��kCRC�An��!�'(fڈt�V%��rH;�T6gfb�������(^&�ɧ�Șz��T���$T(�N#��g_w���GI�U�w�
���m�6�Gv�ggJXg7��}2t����k�L!��g�pu1�)c��0�^�e�y���K��֡!���;}�� ��޾��*O��3y��h�����m�4ۂ��=�����ZK\l䊴�x�O��
?Y`�vP&��Dm�[�5N��i�"�.���,;lG� �4z��̘!�;i�b��2U[W�����G�䦌�ͫ�M��I`���3Ӊ�YA�4S�K�3��Z4�Գ-+�b�IU�i��\���$���T�����`͕�m�	�27�7�Y�˪5GFU�i�u�|r�~ϑT�+��C��LR��:�%Ͳ3ibI�)$�IZ�2��D95����f��b9�
@Gj5I4+��ʑd*���ڤ����H<�I��m�m�X����G�idFբ$�$��{��/J<I�K$M�)�������E�xE:��r�f�/���3�Al\����N��5�`���z�d��օ�ae|�O&M�혾��ƫʤX�
�Y�%h���s�l���<����e�%wl�q!'�#�u�u�`��F$W�0W]��㢃�'1un��1sMQ�6Z���U��`�1���8�'+��LmOԫ�>�������������no߽����\�/8>���_^�+��ƈ�P�E�!+�j,F"BO���hn̉j�I�zD��Q7�9?�N�:��Ze���8Z�W�k�K�O'�\ѩ��-����	k�Tz��txPiUHeQR�1�>�#Q�rx� ;j�㤬�.�1��r$}�)�qO��1�;��8BO��K���t�z��bq}?�1�)F��#h��z��J�2�)���nƨE�����}^΀�ޯt�6�`��4��$^N�r�.��d'5fF�Y����A�	�n�G]jϽ�:UA�r-ϝ�l]L �x���b^>ff��g+?�(���3M��I&�	��TdxP�W�께%jA9�yZ�I���ԅ,��h�Zi�RHK������Ԉ��QNM 0g�J�>t��om���ud�峃���dQ�@�#�&)���6����F��jÝ�,���0�ԃ�0�Ì\kCg���L0(�)BٲL͋`�5�a{`�e�]��Ԣ� �QBeXeR�r��g#�H`��갋��:׊�uf�VH��9���C�+��:�,����������U��f$ŏ�z����ٶ+��2���IT}�r
ưk�+I���ucfe����YIs��F;P�5�����N
�<�\{%ΌPYXi6���l�"��#)�VT�;�;h��j�L
�D�rG�Z�8���M���ph�c�����\`ŉ�'��eɩH�jc&�r�I���i��X�IAW�@)&�41����R���փ #��
צ��2-�*��v�aI3��~.oԃD�SMm�� H)�n��h�:����ڛw����G  6>;��C�H�������hf
�\��ZkK�E������XNsŵ�D�6<*�Hc�������:�n���n�j��Ź`6V�T�%TG
4G�v(�Xv��2T ��gۮ���mn^m���!ظ�mn��M��~QW�4�0���uizV�2�5�#Ykx��	��?���?����<$n������'�2�������F�g/���t�pE��a׊�3� 2a�#	�Н�Ƞ0ɠ0���썀�k��\Y���0�O��o�;����p`�B�Տm�	k�7U�oPz<1��[��w"vcx��T L����x>�Fk�����F4�?M�YF���Q���5!��z��47l��i�E�仅FH��.��c�U��H
��@�9��b9.��rS�7Y`�V$,X�]anߵ�V�H#����9�KC[{P�w'�Ӫ���C��Fk���l:��M%]���c��,.6��%yw�f�u�4Io�2hNx3��J&5ǉԏ6R�PSfR��A��J�7�	yj�:�B^�?Ŝ�1LV�S$��6��/�6�>�	��=�8�u�X�5Pb��\a9�j�X�3�����&���,^��6W.��i�Q'\�YB�'�Fg,�|Ϡ��ٱ�FIR�Z�Y��8�d�L:�:R'�EX�1�Z�Ai�z��J'�%��F�{R�@`ZG�	5(Lȼ� "<��ql$�0V��`P�� �YQqi��4#͍��S��Z!ݨ�̕�.>���^<����Sltv�_� �C�LjQi�9�!�7
%7�(P�$�73I�rZk�X����HɸMO�VAfb�̐OL'v�����$k1Y~\��V;�*l�t*�DK|�R�����,oebg�"���C�:iCް���W�8q����e�T;,Do�q/�c-�[/~���$�#��^lO��dR��� ��%8C��	k\X�ϭA���E�
�[�"�[�3	���h�|\�K~ ͰVAƖ�NK�G��R��v��ZXK_/��JH'F����h��a�����
&)��a��,��tBG����v����s����aLX�d�;�$k��[��|�}� ��rRX��׹c=n������oN���?���?���u�'��:�!��"�iWZ-[����Yt�$r�oR�7ށ`�%X�_�߽?���Ǉ뻇��w�oo>Q=���_�����x�~�Q�d�*	븧Ă՘��SV���?�q�U)SV��	,��V^v���_�y&mZ����?>!��i,X����.�x&���CQ����v���z�,�~3���+��g��
��X����?4���Z%K�e�*L'z�MX[up�ັe�^���;��qbKRkY����Y�4�
2�:    3����k�N�d�n91��{5I�օ���a��e-����xZ�r��`Y�x��+jaYN<���`���,o�|fZ+H�e�������e"��)H�e�S|<S|� ��ʓ��%/ᐘ���`ո��
���8(}sȋA-�Z^��V�C�a"V>�E9W�c;��X#`.b
�!ayh&&���_��˂l��ԳDP�5K�1nY�'���f�CA��L���6c��`$�ҵ��L,�	+"�X3V#�Jn(�8�nbKZX�{'�Ji��Ob�2gK.���rN�"�´�� ,kAY��'!���@�p`�k3 X���0��ꅬFX/���RA�y@N�y@��bk#o�eX�_LM�|��Ć����8�ԑ`E&��$����_|��o)���j�+���e81�%X�n���L���a��ۗ2����kU˲VbZ�io������Z��ť%��$q1`	��'�5J�_r����[��}ւ��;spHX�8+tflE$A��l��؉,1AX��/[�fBy�l%9*>̐��:ָҠ����(����kEZ�gdlu����OHX�EU�.�U��5�[ �:~uf��k�0ˊo&4&�E�)`'f�0��N ���JtZX���k�N,LX�[E[�k(P�� 2䓘 �����J]k-#��ˡ^��a�֘�2V/#,o��XÌ����U�`M^\�b<!c���ʂ%�u�0t@�xB��Y򖵘�5�j*`�2��y��������:��G��LX	+,��ſ�W��H��P�y),ӉLk��<�U����R!�q2����8&,�����2V�˙���៾��Q ݋��žl����Z�4o�ie����Nlc-�ye��)$X�[�XFl�������jcW���c$˷a�݄u�w\���L':&o�f"'��6�,'"y�6�T����rHk�6k$��ʉ	봖���ia���;ѪN��bfb��z�u��E�+|�u}�����P���O��ߊOG=1o �H`�v0V������D��̰Q���C��C�6�/���hI>Yb+���(��q�GODE�2��Wsk+�8��$`��
� ),�tB��rb#�� I�r�\0[)�N�ܞ�k�dE�$�^_���Ns�/i|�#������[�J���,��F2�{�pkG����҉��&�u��چ4EO��[B��T����Wev��>n�)>�z	�=��v�v]X��钠��'h�ǀ5J��a�%d�"l���莄���K��U�T�e:�2}�e6F���:�Jx(.���{\�B�"J_���q1m�(����������VL��^�\`򪒸'��H`NK L�����m��H���j�֢U�fUy��Z=J�$c:�(\�B�(Sҥ�~`�#�H���w�;�ϩ�0R�%=�>�IКA�HH���@"�3�+��?��c2?���Ɏ+��;��4[.�%�'�Qw�B��#���[#i]A�A��:�S�礻DZ_�Ԩ�ǎ�:�����hЬR����1�>|.�`�Y`Hۈ��b�Q�h��l5R�9)뤆ك6��vF)�$�^s��*�Ԧ!���D)��H-�j���L1o�5RGH`"t�U7�:�3��|^����Խld��
0���w#*�wF�Ks��,�,4�d���;9��B9��H`n�r����4�1�5>� w�x���T,����zd���Q����a��a�S�،O����:R���iT�H���ւ#��̴)z�̺�C��>��:�E��4��q��o�XE�z!�ϲ\�;_ZW}��aܖB��ܔP��4 ��Y1f^g�gi�_�߽?����Ǉ뻇��w�oo>��/8>���_^�����UN��I#�Lb�`(��tj�I�I��/���t8:��ش��n|� sɹ��6:�/�Ff�����:̦݃iPA��X;�	4�@Ɗ����k�� �
�3c&��F�u�k�;*xÒQ$�oWP�i#�B,C��i��8�}`>����:�L�ҟ�8`�	g�k������H$�9���2s[���A� '��jH��HSϱ��H�07)
�������������<�o8���e(�8h����`� ��N�f���n�L&�٘N�U4�iƯy����r0�ۏr0i��6��{�i�MV��e�FJ�H��FJ�����S'ʀ��ט��CR�B��0��٘W
�3+cE ��Q40�T
2L?8,�� c:U"�j�:������f�e�Q��$X�䰪�����rS�����4$�L�>ؔ��"g��w�3���8�j���x$v��;�T��uf�C�B��LY�	h$U�+�%v���D�U�H#�@�S �zBQ0��"�l$�����QT���Z�@j�頦��	�0�~'���$0�Dz���Τl���C:_��z&��V/�f?,t'�L���ed=��jp�v��9z���`���a��SH`��
L��q]a3�<�2�7�0X�b^�5����8��m'
>�j��XN��R����4�Z�!3xIŌ�y�+��Ō�U�Pz����%i�s]C�tO"��ou��@e���V/%f�/;쒛�fͭ���/��G /�
��H�@2�2��>~�Jl��t�皎�0�&���I��k�}�t��k3�AGVޣ&$0+
�=�o
�\W\az�H�aGj8�b�o&�B�̼"����i@uPg�8)���T�j�H��RP��DR�x��0,�I���ؐLIJ�疪��H:�wsc��c/M��2i�(��D/'R{�Q5ᢪϛm�S��y$����[���iHO��0�)���n*��I`��Z�LGY���4����z�L'�L=qF�O��0�U��ε
S�V;G`���$�ç� `PU��	��<��nژۧ}E���ϙ����D9E9$�$�i���@�?_IEN%qqG��$�4�0�����ȩ��!uS:�Ph�!���E�%�(8�1`����F�
��x�e?0F'3�g�[f���[F3��#�z7�Lr0���$`�l"1pD1pFJ�'1N���Wa�g.���r�KRMXL��q�T�$�8W&7P�$R�DR��2zJ=����\�F��K��YDHj=#�)(����,#O�2�Զē&�� �ؓƢ+&��|vִ�(�$�N$��Y�{��"����!��q�z��+G���4�F�EV@��%�l%>�2�$�&RE����3��,�8RNR�f�q���$ˌ��F�s ��`6�6�i�,ES���5N,�*!�a�&���vR^դ�+��X��E���
���DĬ�GdӬ�6u�C3~.���sUlcfR�\H��I`JF�DX�M'oMR(ZJJ��*�#+�Q3�
S��'z�F�Ԯ"]�I��I�Bj���'M�<in�,�5��uj �:V�Z�$`^�d�ZT����3����j0(ːB��-�7�1itXP3:'	aK�QCRrh͵��]O�_?WX�3�������j��`P�M�9�e#�h�R �FU2�}���uF�3�HS�[FZF#��A�r���#5���v�<qźێ��B�`�̪�ӓ9��n����_(��ܼ�	�8�wcYf�ݔ�e�Fi<���h<���(6-,�Z�Z�ki<�T��m.m{�>6�~*�|�
�0�G�N&�����I�� c�q��X��D�0�B�̘!pR�)����/g�E�^�ø�ѫJ� O{c��*�F$~$~�$0��U�(*BS�HyUP�r^]R�MX
V�=�����3*ݗ{.�?9,����'����+U�
��
�XG�AM�+$0�=U{��n��NwR�dP;i��H�j$Y&��4��$7%�b��P��Wc����81+�B��бIls�g�F'�O��Ci���0�0����t�	)��\]{)��j�>F`n|v���jA��: �����b�fG7�< yyJ�M -GҼ+�����@�FT6��)�Z��Hnj���$0in�l�["�hN78}jb��� EO%ey!}��Du�R{��a��_}�    ���,�      S   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      U      x���ۖ�ȑ�{�~
��f~��wHf03��숌�$�ܔ��՜.�f�T=���7�́4GXd����ׅ}D8��v��wۛ���������r?<n��U]���띯�wu�޹��?U�Ou�v��Ct���v?�����}���>��q��:�������!ƻw7_��_NŃp��B�����C�5�������-~��}p�a� �P����ŀ��_�jBM�᰽F>T��T!pD�1t\�j��?��!|���
i�{1|6<�:.��!�#ٿ5؏��T�ߐ��	�W z�M /���+ �kUC �3��_����UC�w�n��?���݄�a� ñz��9_���C�a�!��v��~�y���r�����M��h�n�.���\�j ���ó� v�o��!�>������g�4�����fw{���H�=�����q���΍�T �=|��Fk͇B@���`y��nT��78׷f��q7z�#�4�;4"x��.N�P���<]�*��{��5�:�o7GA�㕪!�����uW}O�f�N���t�N��R5� Z��h-�;Q�jA�����f܈�@��f�8<�q3�j��ϛOWH���bc0k�������K�}�g h�/4"4�CҬ!����<��B@���a ��y�j���y����і_����������e��G��CZ����:UC�#>���.q27��]T5��w�v��f<3����ӗ��.��zצ�b�π�/bE��jP����~��ݟ��������i��ݻ�v�w��]G��j�ݞ��r�Hf۸񛡣4�{�RP�*GtW����^�>E�o7���6�����xrU�BCܻ�a����M��3�!��'K��PW��X�h��e\w����e�"�Pj�y�\x����x>�!�]�6�{�9��u>6���Z�p������d����#�W5����T��L�7.�*�]�ä���Ѱ��U�6���b�4ѝ{.�;�j}�j��>��ö��q�����`||=�����4�+����pX�0<�V���5&PjL�aj��u׶}����/ަIC`���N�Sq8�mӍ��W{4_7祆����㟻�>�u�-/���q�j_y�������^}��4���Ke{\�E�Z�|S��d��ǗF��>_2�ފ�������PW���@��l�q����jMg&]�X���J��5�Vj��o7o]@N�ҙ�U5��Ӂb�j�?]�x�����X��:����kC\�A�x�]z1� �F�@�����q�r�����5�}��<^8�Wm�WF�	�r�6iLg�%����;�R��C���|��� ��:ø�9�)X�h�z���&�?MX��E����W5�����N�j'���׏���:U��i�!��<�R� �i>��N5YKG�%kA�8׍+���(E_��A,ݴ,O#�ޠ�D@n����U���G�j�c792X�a�z�!����x�-7z��:`�����'��229io1�����qK�j@x��5���s��d>��O�w����/�������eH��i��I9�[�~�r/�\�R��':U���w�mz7�a�<�ߦM���7��px���y~�ޟvϧ��������.�Rf< �;�*��4���N'W�� �ѿ>O�n��+bwvR�����\�R�H�6��F� [�)MWܤ�s��@$�B��TϗJ̻�>�U���{y�����?��^�%k�c���\\�(nȤq��>ޏ��H�4�n/?��D{���D;��fܽ�/�r�q���:��KjER�-���z/�42,%5$�c�5{�d~"��-�� �J}���2)w�lY�8z�e��/qhe�RjG �{s�/�X��.�A��}���Ҥ��5���Fӗ��[�Z� ��U?��w֧���N� �������������gI�]:�Y�Hb"�������0R�@�� �ߪV5�M ����v���WjG�����������FR��Pp���������V��jȸ�\{�Y�@��o�m�yl$.��m�� �_��N�+�!5�s��sJ`��4
J������2Ɗ1~�ZU�0h��0l�!����R�HR����ՈѦK�ت�A��'�)7r�� #4��c�G;G�P�q�qPL e�Y1Z�E1ڥ�n���$�9kU�@h��9]�A|�BN���?� o��x���n,�v6���D�A |ke�ad	p�A�V������dS���a�?�rz>�_]_�iJ!�J�F�P��0�A�����݅c����������`:g��Ff@J�h���9��H#�H[������� ?��1�0� Y��A |��y1cxy�-5���O۟쏣��R�8hg��c�{U�8(�z<^l����~�ð��M9��o^ϰ9�p�!��"��x-4�獠�����Uj)Y	��4kA�������l�;w�A�47���0��:}*|�j���`yB�5��N�Û��ؚK��R5��\�K�ø���ʢħ�� �מGV���*K� ���y=��Ag���X�d�*�U⠳��`6ی�'�RC8�8����}�lS����A~��{��I������q������Q/��K!7z���
R�&@��~���8zMu� �z���a6�T U"i�R�s��5�VjG;�9��g�����5�h�A������)98U8@�f��Z���qԫ9����4�#%�6�g�q��x<`�*�����cn�PjG�����S2��Be!��I�`r.�M���kDeN}�AD�Z?n�߭L6���b6iG�Ib�8b�j�W��Pt%*5�������Nx��_�g&ᨫ9�c$�-��A(%��^� ڳލ�\�V1PӶ�g��<>k��}=���A�ү����el�O�Ы���[����a�S5���ħ�:���F~�@��rE��7b1��P���D@>�H>\� �)�3u�2P����B��wn,�D�Z,_	�  �#=,����~ͩ-5����Ԭ� �l�-O��1���m�_D�\�AA튣 ��H��f�� ��C��k^B�A͚�_k�KB ���t�CS��kIq�A��:�
���e��Atr�"���!\�t���]>z�jm+Wrȭ�� �_��i�����2�đ�IMge�ۤ�3V�:O�����%Wv6��� r��Ԟ��Ѽ����A��ԫ���4��K!���B�(}q�!4���z��e�V";.c��8��L��l�k�5�F������LRv�rɲ�Ԝ���{U�0�Lx���>�J�� ���Z�!]n�#O�B�8Ȼ>���_&��k�˰��o�|�j�e"��9���4��Q������t��D�?RD��/��lw����m�&"!/�y���)���SjG�	G��Z(f������[��5��U��-w��q���a�4�"�.�H�A$�Z�<�l��� ����h�
���Tb�Ip�;S�M��F� �&�7�@�W5�\�ps{��z2�.�� �A ������<�Q��d\j�^7;Kf�L���a��H�������oa�^z� �\�d�ذ��/�_&�7���fzK�ۑI�8ȳ��h�{�I�8v�V�ʥ���,Zj���OWb�d-t�P��A\Ҵ�M�d-�4��o���?7�k�_�I��w>�,�r_<i7��>�5ĉ����!\�4<^������D�9��GP�"iCh �1Y ��@�  ?�¯���E��˗q� :��R��:d"�˥�۷&��|�)4�����{B,r��!ts��u����B�A�'�z��G	�׫���9'`"x�T�NН�� �7�� �ڤS5�[7�|�<e ��'
"�{���H�:U��<ӭԅ>v������M�5���b��#�=�T �۔	9��    |�!\��������&�\�i_g �D3�o�Z$�y�_��0�*vSBC`�*�4ђ�}[���˩�uw���s;��=j��oZ�%I4B�Xh��٥:����Y,~�y�A���7m�W����x�<[(�Ayh�[U���X:"�q����Cgs�ȱ���?2���� �SE��\[��^�� �n~vy$����,[��d4T��x�J��+@ZU�@rYҷ�람.>s����?��@�M��!���n�@�E9�� ����%w�Ӟ�}��Aqj�d��b�����N��!�َ�~U�8(����U�q䛡�;�S��g哥3�dv<���j
�#}����Q_���W��N6�+k��ɸ���"~�A~�f~ ��	"	\���/�_� �hn�8M���#a!Ǻ�1圱Ͱ���đ��ۣq#���]�Dҽ�����Cq�(4�����pcJJ�9��R'�B�[ ��P�H��<,��F�Z�mj��Ქ�$e�� ������ھjc��(2�SH�R5%/��i����T%4�!N�M�9���N�X]x�	B��=ߘ4[k���� ��ǝM��ь�	}���DߩD�M� �W��w�����4�AH9��}ڪ�_��)�4Ի�@�`BC���ImZ������&�)�j���p��W��:Ա��b���֜~�h_���p���u&Y�[�5� ������H�i�S�� �8����8��8*4����Ni8�u�������w'�Чvu������.w��FKhR���m5?l5�I�A$�����-n�����@��z�u��_|�g�s�����UM�[�}��k��3�� "v�㛳��N�jX�f"��m�:W�}�'3�5�j�i����&���g�a��[�1��!4���m��4�L=��
k�֧��TlrD��5�R���ac|G\*q�aO�A$)8����k������Dʣi��A�!D��9��G7&i$wj���E��AD���g-U����AT�R����GC��)>��Ohoh��)<�� &N%��|չ��X��<)'��Ah'ol7�1����e�A gLߩ���V��A��L_��]��K��u$]q�!4��������FVyUCP�n��D�u(�4�&5uB�8���v4R%N��q��.�R�������	}k��!�)_� � �L7Ql3�N�/5��w�Wp�͸�q4|u�f|i�A���!�z|Q�
'Z\� ��{�ٞ�7T�a�H���I7�;8�
�hy��
W-�ٳq�S�4[?��'��Z� ��n?����O�A�:r��Y�8/�-rL���Y�B�8ا�:ی6��n,��q4�`
�E��� ��I�e�Qj��jH7��i+��]S7��ϏYMn��^� �ib��Ǿik�z�*��ǲTKhM���~��e[�U�[C��c�M=�$Mi�x��}��A$ܷ��=l�[�m/4�M�Y��d2}���A�I�i��,������ۺfE�Ȇ�\q�/4���fo��5Em��'qK� ���(.g� K0��&�c�j�lGP���L�A\����Bjr��ث�с5 uU�ӄ�p�����4s4��Mh��'��( ѩ��S��uűKhJ������Kˆ�B� Z��z�>mu2껢S�� ���sd3�Ŭ�A=O��j��&���p�RY@BEс݊]�;Lh��[[��k�c�n����r.�� n]�����$}�%%4��G�� �#x�T"�Q7D� [-G+	"i^{%A\(�ӄ���"eHP@��x�
/s�9[트�� �~U��d�v�����[�'�T.�'�Y�08�`F�jmV?���b�����Q���� j���,�� B͙�pCWwU��mγ�[yY������؆��y&��1
!�rz���Ta"�b�&4�k&
�	�[�A,�`��Ϧ#�0�� �>��$�*�O���8���t2�N�Զ�.���A�)�B�@8����a�mq ��T���-2��L�A(x��F�F�7�V��WI|��gq�^MhH����m�".4��ݫ~�t�QH?���eK�c�]�xFhH��ξ��}�j����_��7j�,�z�H�����X���l4IiB�@طnǽ�%�����rP�� �\�e�=b���L֤��T�T-7G���k��f��MW��q4���f�]��^���1B���N��������Ɔ��rT�� ��w{S�-�W	�*���ξR�E�A �Vב��%�� ��چ��9U�>[#hߗrB3H���R5$p�ύ)��F}q�&4�����m)�)���^��iZC��G�jHN���ji554�5���ll�Kn�V��A��uN� �`eީrR�������U[k9U�8O�9<�ߘY�@(+��-��*.{U�8ȡ�m�㭙�,B�Hȣ��#��0����u��P��:�n(�5$�4�wS�W8w��A�Zݙ���qVF�f!��5�V��v�Q�5���b-�5l3Uը�Q�y(F�w[<�I�8����f��L�js�[��5�s��u �s� �����B�@rՀ�+㖭E�a�<@;}QT*[�~�Q�^� ޲�#��B�8�N���,3�t �!m����<RW��2e��7ƀ;�U��A<b�і�Ma�^� >��#i�ö� � ��YIʆPB�H��B�BsLTir���!�)�ʩ��6];[qk�;Iȑ�B�Ph��uk:S�;hG%4��#�k@�An�ް�������.�4��_h��l�l-i�l�-Ҋ���E�:����#4���o�}���H�V�x�Ͳ��� ��o�M�gd4����PHu�َў�.�AmnHi] ��;U�@ح�D6��� ڮ�{ٱѰ|w'�_ �__j�Y5���U�56�Mm1���5��qoY�����U��A ��SI�qShI�v�9�"4l5��B�Hb�f
%�ѸܑL�p���4���E`Dh{�U$�Z)&"���k^�X��B�HȿO_���v9�Ah H��5��]�I]�7���{^Nf�XDX�q�S�*m��� ��:nwϦ�k��J$U�Hع���-�xU�8b�ߚ�7�jJb�U"���as|0���~�J&b�H�����ې2�YhZ�axLD��5�?�;��h�j�x�ژ��ũ<_�A��'�9/݃,?w�q���%!���1��5����pg��dkέ���P]�4	⠮+�8��[7kG����!4����#E|Q����7]R�"f�s��P������ΔN4[mT"Y7Qk�z�ZY�H�M��r�{�T"����&C&Y	"	k:*OF�=�� ެn>Z~���	�h��M~����D�q�'�Ɋ��bR�� �i������Om�-����U�b|���\f��Df�
"�5���ex6.X�*�Tb�P���!)��HhH���&&�2�,4����t���Ms\b8��c�:���������,���h�yt�zUb����ik����f߫đ�l����M��,4���맃-󛌆�=��.�z�~�~��2/4��_>ce�d6�=������� ���*)4�cjp|9�ߛ�et�ް�N��n]ɦ_~�"ک'��Y��&5-^.V� v��{k��+�K�� �x:����y�i�U"���J�TB!��q�m�$)y�Q5��gg�?�R�&�q�NX�@880|��I�rK?iI�Z�%��:�����EV���D$L�����!4�#������s-��P1i�W�f����fݩĒC+�b:�� �����Ͱ| �1y
��������IC8��jo����}fU� �z���beuxup���p0.�t��h�� ��i]R��Xj��\W��Y�0xz��q�6k�j�c}9�*�'�N� wf�c���d\l    �U5���O�&7�?#A��"�_���iK�_�YC8x�J�|cX�8���z��/�8"z�ks*�:��I���j	�[�%	^� �0]��X-U�qp��S���.�ŕ��A\$`%���qL��=�����Tfl
����SI��-,5���n{-^��RC:��Jn�:A#?�R��P�%g%-��Iq���3=���K 5�����;�Aj�#A�r�����6y�/5���������$1����vK7�	���A 6=��.�M�)5��}�a���g�ީ����`���F�V�������W5�#��ﶖ�Q�j�z ]�H\�i���y��d6�� �<�ۃ�X��FY)5�]���L$�l�l� �ܲ����=���F����V�D]�Hȳ>�GK�L���^#�D��Z��(ѩ���Ku�L����MU弮g�%�l6T���Sf�Z�N� >�oM��Q���U�j9���4���

�?�Tt�,�٤�T9Ufwg9g�ٔ��DaBi��[��l�v���y����ܚrŌO�A]NA�_=���qR� 
���8q��.BCj�_�ӣ�����R��܉��u�t��\�A�A��2,d��� >�?��b*<�5!O�J��Wʁ!R��
�x%�U�g��5���K��*B��Fѩ��W���ՕЦ���JGj����B�M�� �|�4��,���n��^ɰ��.�J�F�����J��2g�[.RF�<�\�����[K��lTn|���~���c!�ldʏ� ��+Aj�Ahrq�q���ˤr���4��Vr�
�@rk���3I����� 
��؆�d��¡ҵ$�&|�_]̇���z�Ou��W=]�EU�����vsT�j�������Di&撈5��DQ��D����1	"
o��k߶m��|m3@/�Q�AEN{�>��k{WW���BQ�/5���8Ud|D}웾o�:�,.X���4��NyF��Ђ�\��j�y_�����+�~�)n��!q-���R����Xǔ�2���H�(��Q���u�W�o�<���R5���X��eP�YS�m�jǼ1V�zc[wM�5A#�&�wl� "ξҼ��۶]�h�ؚr�?դA@�ǁ��{6k9�v�����jt�QJ�u�\׻ͭ��j��7��J�]\T5�����i�*q�25Ņ�� ����|���(E�]�q�k��Wk��X�`�9��Ik/;~��ͬk�E�b�Ŧh��X!H�8	B������V�@���Ƕk�-he�� (r��/Z�X���q]�F!�����DD.�ǉ:U���g�l��<��Ǧm�>=w�q]����+~{\IM�p�)���Tbjxy?�9�#�K��V7 ��~��Q�oQ��r� &�|�d2��94���V��D}?~�z)�UA�c���GtM�[W;�kSSpߪ�T�Q�ۦO�a��D{XU���\lsg	���8֪qx.}}9)���k׏[�N}4]Jgs��AH!'-�(�oTb��I�ծф��tLD�\n���EU�Z�.��
[U��8F��!"/{�H"��[uj҈�}�kU7ԧ���UB�s�~��S5����a*�xrwF��Z�D��7[(�u��u�H7�~��y�M^Åh/'��e���~<<u�7��k(�jOXԪ�R쪩�^=ɦ����(��(�M��� B�@"�PԡO�Kֹn<�k�ǥJ�ŷc� �&'Ƽ�{������������5����~)��!�16�^���NչҠU5���������)���ʌ]�!L�$�FZ>&� $�ׇA�ȦsY�����R���"@h��=L���U�T����鮣��
""w����X���j�Y)G&�#�� ��e>ZH$��.��Ͻ7YO��%kQ|#)�>lM
�*D��$�4��"F�`S� �ȥ[�:�DD�������#7�B�x�i�]��x�!��%�̄!q�]����r�ž�Cu~Q�)���~�RC�hV�>z���_׵;���L�T���R�m������YOS��ADyV�u���J�j�U"�=<�h]W�RhϫD�%Ɲv7��'Cz�:Q1.Rj爨݇D^� ���X�۱M��5�A䨏��ã�T����g�&��ƞ�O�ø�5�x&GW�A0=>/|���k_�;!���i׭�D-�9�p5DiNnܝ�K8��b�1i�h� 	(t��Ѹ��E�A@��Y�*Z�Ȟ�SPR!�9t�<i��q��jL�iCRGc����"[NhW��>k��tIUwޫ�Z�h�/5)r޿~~�H^U"j�J�Tn�6c�z!4�����:�n�;���YO��a"ʃ'T� �����fm�\�vܨ^8��Fq��YC�jrзz�{����U7b�N� ���i����ϫ�#�o��O�AL.�T#h�k���G�S�N� ���,������Dt c[Oc��x:�i|�BTS�G�j�VS�.p��H٬A͚&�ɪ[LV�DB����(my���7䚉�k��<l/�;7 �w�l�<�
"�FV��^�K�&֮������q�T���8����%�TU���bi7Z�,�՗��"U""�<|�h�z��^��9�{��I%p���MhG�%8�@�S5$f�U��Ai~v�F9dt\!��rC�[S�"P�*6�B�@8l1<}�����~N}}|J��+U�����T�(b�ӂ�.;��M-�BNyӶ�qp�S�@)���b���c[�2���DT�A�]L���f����qn��y{���f��#aB�22LG~2S�/U�@h�{�|ӫd��k�\S�F��,>�A@-W|Y��!'W�V� �n-F_��a�+1���3<i�n--�I�|�' ���r2c��'x� �,�?Y����T^�T႒U ��+4$�)
ZT�JSĠ��D����7�UuTu�ң�\�AD���l3.N��qpU���w)�?tM�J��O���φ5�����i1�ލ��;�8�驊iqR������	Bۻ������e�"�!@\�}�}��Lyj�5����g�p�dԥ��rW;k���F_��q��A���o3��h]LГ׃�4یEΓ� ��iv�Eڵ� 򷏶V�H%�� ��noL�D2�ۢ2_hH|�~[Ҩ�OC�L;ɘ�G�!�[BCH��x:��n#�$h��Fh
hףt���k��J�+��PwJ�$��e��� $υ/SK+6�YB�@�ˮ��A 9}�������闯ФA����� �O��A �gW�4��t�S5u_M��q�\3�tc����-���! <�m-�<�ɭ�����A��̤A��mw�a1�\�^� �aK%��Pժqp����勩�]ݩ��5w��(:ˢ�RhK3�z�
�&���A$�Y�ݸ;����,4����H��N̓|C�j+��]�5/>���pp�۷�u�t4SX� ���5���צ�K�^� �ۯv�X���A�u���Y��vD�j�W?zŸN�"�(4��r	�$%���Y�08���^K;�A��^� ���!w����q�:N��U�!Ǻ&.��A0=G�v�$mQ�&4���>n,cܳ;H;�1��8��w㟮Q�W��Y��1�>�$2Mg�i<c�j���^�$�?@Q�$4��[�|�7���V��dB�Xh#�xzP���4��l�#4��+���������buK"��Q�DD�wcʼ&��Q\�
� ��CF��aP��x����4�]��� �~STu��HU 8�
_�Մapr��>�l����qpn����g�he�d�[��B7j2FhgĮ��q�6����bo�=&�ȭr�J$��|B�@�ܱ|H,��
���颞m��=BC8�.ls�mE��Hڵ����u���Y�0>}M\�j���*���/7�B�H�k��ɖ��U�jI�`S(���许tB�u-�oT��oj�F�#�����q�y��=J'�KD�q;VS    ";�e��Ayjܷ�r�#�1�BC@��kHS\5
��j�t0�^o�lպS5��|���n��t�/C*dT��/��AH������eI�jIX���j�j	�>��F����SS3�KG���q� ���[��imQ�+4���a7��l�+��B�8:n��ۚYd՗սB�Hz>�
u���*UC8|��Ro[�B�ir6�bs0i�s���2:~n��j�{�������_����?��Xro�J� �X����?[9�r$�� ��g@S�)�,�D�q�w�?��I���A M������1m�^� ���KFW�	��K3kG�V�l�d�[;g"ɥ���G�c�$4�K�ց�E��� ��*w��d\�n�HX�H\.��}���vq4�5���k8Ӡ�?dt���I�4B���HA:kb*4)����֏�z�6OH���B�������?~��ߕ�q��r�r��sj�EN5.�jU˳]�G��̦x}�jJǷnj����.�ZU��8P;�,�����! ��L|��)������ ���)e��Ib����8��f�vj�ʭ</����3Y��F�Ӳ� ��@qG�j��[K��u�KhHn���c��&����O�ƹ��m��o�D���Q�n�}��4�J�qE8AhO�Z.��d��#4�k�6ڽ\��vi���f��k��'������(N�D{ߝ-������BBh�ϧ�T������)$�z(3���Lt|v��o�-`ئ�mچW��˙U:GJ8�T��>;Sq�d3:U�8���n���r�k��u��(B����P�B�ƶK͘u�X�[D��4l�5k����Q�����dX�X�t�AWh+9j�j]��C/�h��Th�_����d��A̵���9�{U�@x~�p���R���d��UU"���OƓk��6�-լA �(|�q8�*�Ź��|�+��	`\$�R5�����1⑌��ʬA <#�eo:�w�j�'"4�� ý�R9��kC��Z%���e�� ��r���S]�f<�����z���[�0�j	�$p	���^��\#�eBB���n��"��S-��q7�ψ5��+vZ�&W�K���2b���C��v�Ζ�ӥ(Ģ��� �6W��.D���+���������Fo@��|�:��!��R?��5i�g=)�*�+6�BC��<rx��|[�zU��8LqT��t_����p�[��.�C�v�9�5��c�j�N�2�P)�x�4��W5�(��KSj�9n��Z� n�xz��²λ�	���0�{T�?���g���\_�{�t�,�e�q���tP7��kR�n/������w1tQ����IhQ����#N��i���b��+�ȃ����HVٔKh�a[�o���pM�1�{7za���A��Of���[/AX�@���ax1����g��A$|7��i��.����B�P������[��A� �lk��Qd�[�.'��{���A7MoT���Z��U����`��#�1,>}�q��8����f�j�՟6w���#�|�je���(�3�qО�e�^��m���k@Oä|���\��xZU�x�|�_��\��U�j	P�GS��d���P��p�~#��S�dv�� Ff���9��-9�p]�*���}0���ѓ�jd�A$�Կ��Q/3�q�-ۣi�F6C\���q�`�@�ɨ�U������#���5�#r��
��hd'4��6���탍Ñ�p�q���t�b��a�&5v�X��	� �zg+ a��ҡN��+��l
A�)왂!��Aٝ�9Y�B�8\1�0�BCK� ϑ�Ǘ���-��e�A�A(a��ڞBҾ8�� �����+�m�}r'����uX�,�V� ���P?�bl4~��A GЬ/oX���qP(`%��c�����ʑ�K� �<���$�>���yT�ϝ�ǈI��xB��|�n��"�,4�g/jbD�ڪ	���K�S��ҥ���%���AD1��$1$���T!okkp4�t�a�k1��1k� �n�ϒ
�+U�@��7i��q�BF��aa�ժ=}Lw$����A5����Hԍ�Aykݟ�t�"!Zh����+8�"-4�#p���5E��t�A٥���ۤI�8�B3�1��6�.v��>����^� �v*��,:��D�5� �e�j� �������	��m�kב-	���*ԩ�%��9�����ϧ��w�ytEGT�An%�?{����\������ˤ|�A�6�j��X�ƅ�U��z�R��HĬAH�V7��)���Z�wʹZ�^���6���P�Lg�ѬAL-O/�a�V� $N�}9iM�=��+�:ܩH>��B��8_�VMl����ų� �Sv�6�+&���<]�̧|����TOI8/֓{�/�E��� ����RWfB�S����b�G�����n�jAL=�_�g����-u�\����n�QQ�*5����������ϓTG����ü� "n��ר�s��Z�y�Ȏ)R��:��u�R���K�8�8BIa�1e��O� ״m�y��ͧ�������n�Ǚ��~�;v�I�T����4�'�Z�L�C%
�L[�D�^��`����F�r�!5�$pǯ5 ��/����
���R�@x#}���g�����i�M��W����� �4?n,/6��+�A �	[b��fq�����,�X�	��[��n_��~�ɞ4���|� �CUɸ�� �jn~�����#M��5�#$�������
��;xU�@�m���߿�fhh<[���A$���o?���6�ʆ�W5��}��Ͽ�������Hx6�kU�@:����AB����A �z'ۓH ���"�������q�R6�b�6iKM,������������R�Xr�F
:XY��^�0ύ�����TRz^�j	9������~�ՆSC��S5����?�6z��YYR@ӫ�������4��Cp�����R���Ͽh�{/��2h'5�eaȕOF�ЩM��l4�
Ԫ�Թ�ag=�u�@��5��rĞ6�{�����D<i��c�V�����P�ح�7C6�,_�I�@BN�I�}�X��o
Ӹ:�Aj�6�8S�jS��V-e�l��ʕ��c�@nw�0Nm���^�'#��\cA�����DΞ�_��u��Z��z�0�< ��T2�Mw��bS9k
���Ǔ���ͦ+��j��!��nf�0��C(�Q5��V����5����'�{�h�Ay@�5$��5s�b@��0.�ݙz�e��l�'5�d�%i�Yf��_�g"��r�=�7u�jI.�8�����a(��<?��ߕs�M�x�Y�����,T�F�������2��QBØ(������o�p%����	c��|~��7ˁ����"�_j
�pג��f�0���1l�y:I,SJ#��(5�sxU�P��7��P��W���=o�� ��j�}���ɪK�b�K=k�4�g��R������4;��)K�yU�P|�
d�hOf��a(a��a���a$�s�q8Y�$ت느��0�&wd[�R~�fCɅ'��CfEɆ�0�������j�V���a$}&1~%�i��d� �H~���`�p��D�N�0�zj�l:���P\l
C������;~�ay��W�Q��S5��N���R2������0����s
A���۪�c}����>Yˮ�RÈ����/.$��!q�>�Q��	}���:�p��'��a��M�woV%���w�B���޾<�?��P����S�� �&�����f�`�W&�c�����4~��C�ᤆAP�����ހ��c�a�ث?�Yn��Cr��Ԛ�ߋ����O�>j�jD.M��n���F�DU� r���`�>偄�`� �9|��.=q-kA�'�>�!u�U���������d��A֝�A��,���7K��bh�_�I�(��2�
B���W5�g�?�RM�j;K�!-�6�����Ϊ��r�l�5��u��_�����nt��o7`{�*εB���3    RBD�t�q����l�w�B�p�ğ:�\"mt��^t�;�a�W(Z�����Q���Ŗ����黫¤7$��'�O���Z�莦S5�������\��,5��qC>St�S�OY�&4�s	�A�U����6���
C���ǭ�>��6w6kH�t�[X���šq�0��sn�MQ>g�п�0N�:>o,�K�K��S5���xm-�,�զ(�F�s��᫩�=�u��v������J�qKb{��͓,��H��M���ۧ�@����F������ӕ�-��˝��0��N��k16Yt��������/싈��0>�:}60�/E�d`c���kw�!�"%MhC�/����0P�c�d�4�����Õ�Kȅ�^�0�|ȧ����٨QO3�>�ݰ*��E��0r�_×��QJ�j��ǧ�o��k]�|jb(����1��~�y<�C*S8c��iH#{J#D��DU� �����-����Q�5�)1L��˷�5��n�O��h�yIB�@z��}��ĥ�4��rم�2`:٦TjL�AԦm:I�3u�����ӾRe�;U�H|��jI�Q+U�@x�y����(�#6��1d��7�j���T#i�P�q�r"�W5��ͧ�`��6\Fڪ��������H�\�b[<i	�O��x���V��q�<����#��L-����ۻ����_֪#���-9�l����LƑ�u}�����5$��Z�*\x�I�H��jx2%X������I�@��\���6��E�rw;���Y�@ȹ~�>�AR7�^�0ڸ�&2����Y�8xl����m��E��0>��'���d�-��JC���%7RyP�3(4���ܿãi��h7����0���_��ؤ	�< �x�d%I[�$�a$׍�>�d4�E4[h���L� �Y��(���0��:lM�.Ȩ�[m�a =7��?��B�@��Mũ�e�j	�g�7t�o�I�u�jLN8��<ܟ,7�l�5B�`(2�l��h�W�B�@h�
�,�������r�"�ɓ-QX�P����T��%YS�<�����n�?_����C�j	�a;�����a<�k��1�̒�P���eS�'S��F_������䮍)#N�Z��a�5o#@�U�M���t)���~�I�HBn�lݱ��[�g�0�²��9U�Hް�Ju�h�ܝL��pt�i��W5��v�+Fqd˾���ו�������~� ��[��m�M�5�\�����3L1�Mj��{GSn$[m�[r�a$>oבt����6�4�H�$e��a$q�W���N�0���;kH�~���抪�$N�0�<��tG=����pY�Í��d5Ԫ����[�3I�)��d�0.PG�� t�S5$�X�n�h�j7���wSd��]R�H���J�E�b�0j������ϿZZ3��T;ު���>�~��
����q�6�&�[Ê���Q�0�.�BkI\�j	O'���4�Z���A$]E��~������ʤa<���_��w�P����8z&�P�e�q�0���߿�8�S�b?=k�~��OS�<��.^�Y�H�u�:�^N͕��^��ߍ��Q�m��5�������?l��.ʤa$������u���[�·	c�����q7�.��jSV���������hE�^����P�`xޚ��U_�	#ᴭO������k���7Ϧ�qC��M�FB��W�vP'��.B�B�X(�`���f){�	������~��>��LhJ�(��M�¹�ַ�{��F�0r������H:����_�Q�ֺ�'���j�a,�c�}�� �*������]���a �ew�K���%�V�0r��@��ї�0�ȩ9�$�&W��J�0��=X���h]fP��X[g�&��{�Y�@�� ��+<iEdS�#G,��B�8x�����◃��������9��$�j]vjF�rR�x�1?�j����S�C�@�Q����������6���Х����4"��_$	#i8�{|&� ���a(t��<�[����u��a$�d_�{�Q�|�b��St57�^C�*��$�A$<Kk<�n-�dd5�Sx����ܼ��)#�����t����8N�YGRF
f#�+Q�����8tM�N�y���x���$�j
9���ߎ϶�����H��5����|�j
y���T1JFS�]�jH��UK�6iH� g?����n��� Τa(���j��F�E�z�0J޺�#�W~(�D����F�����Q�MT5��[�YlM&�.��z3X�f&��S5�$�Ȳ���pݩ��
6�_�Ѩ�r;kH��z���G��/2����M�qkIޚ�:�}y��볩Dr�闿N��Wz�/���3�y}��R��j(r
�����W��W5������nUCɭ���;�������nM���h�<�$��}��ᚚ0���q��]��lB�@��_SbGw�DX�@"�Ʈ$Y�����$��X�6_�U�����V����j�_o����
��k	�`ס� άa(�^GO;�ڞLv˭�a,S�-��C��+]�HZ&�L)�mJv��4�$7+0E��h,nD���P.����Ӑ���+�� �����v0l�,S�Rs���IS [U�@O�<n�XIbW�H
#�|�s0>�TE\f�	#	���v�#���nB�H��vck~�R�W�녆��]���)&��M�j��5�؛� �:�LՈd�5�:k{��'m��N���U��� �ߙZ����9{$�a ������js��P���y�)夥̟2�@h��nM�r2Z�C)����)��
⛢U��0��j��r�N��ݽ)Ւ����7�a �[O���r\bq(�����jl�ו�a �[�L��mn)]�ґk]�D�_��I�@�6���r��B�H79A�-j߅��xN��j]%!���K�0��m�n�_��]of#��|��G[�ږ̇��3iM�4ѫF�S�LM��h(s����t�A��'���p\յ
���ҳ�5�,�9#k���4���:��$R�y�j9�Ǎ��7)���&!'��U5��������U�����=��RJ��Z.�a(}�6�[?<]r��Q5��;�ǭ�4�̺P��ҭh1�RE��)M�oO7���?�uE���_U����)(`���b������duK�4�������,E�dtяMh��l�-���9tB�Hx.�:תBQ�����qo['l7xU�X���Gc��F���r}ŹZ��gcԂ�,Ե�a(�g�[S��l�S5���M�u���|�+4$�ZKҩFBN���`�����3k	��>��:��*�B�H(�0���h[\�
�����R��Q?�ҵ	C�����5Uuut��-��0��+�M;�._��Q�a$��۟�/k"��q�]��2��"B�@8Pp2�0g��S�칞���$���B�H�pv0:5�Xܙq�Kn����l�k�ϓKL�$�Zv~F�]�����x֨FB����h���X�b�a$t�ug�mu�/3_����m��xN6ӝR�jG���TJV�/�ʄ��p2�pk���(��� ��u�5�&���e�SelqG2b#B����ɾ��زq��0nJ��s�Ť,�a9I��1nT�S5��v����,�\L"����-���.����a(�Y?mn�Ϥ)�s���t�V-�x��"6����Z]�qA�8B�׈����Z�4����7�g���N�0n�m�2��ET�a x}�쌩b����;iL�O�-w����s��iH�j��[ߜ.����Ѭa ��)G��vK�6iHǣ[��GS��n��iTc�y���dJ��zQ��O�������>m�0���%�6I��U#q+&�Ѳ6GhH�޲ݘ���`��0��!��}����0F�a�����E i�0n�u0F]i9,B%����Q]?�j&��B�	�\�uk���SAP[������ɕ U  ��r�&4��8Ba�t$����B�@h�����c����	CɑW[��:7嵣�0����O{�:� ��0�ܮ�v�d�� �頷dac���,u�jK����퍕$͸����P����Tb�F��ً�0��~�6��s�����P�u�:Zncɨk�[{�A 4�����v�l��ҵ��A{Xc�dT������h�U!�f�R�VU��B>v8l��6J�T��UC�y��P�[�Y�P����ƃ���ThH˽���>=]36�o�a �����l�lS0iH?;,7md6�E��� ����Pb9�Bh
w+�~�Zr{�|�E!��0nW�5n���k[d
��{ӥM��Q�0�c�+g�M�+4�/��wKd5�"+4���k�q3�D�����p����7�����F�0�'�~s���LB�a<�[�I}�c��G����5Ӽ�\�V{U�@x2���UOw�M�w#4�����1^�&�"�)4�;����e���ř4%p+�;S�~�������Pv���^Zl�-�����}�d>b���b�4i
W|�e��T��-Wʤa$<�T?�\�M&��Z�5 �2l2iH��\uakM4��+U�P�a��a����N�0��ס���ңѤ���n7;k�����b�p����\kI���_���y�b��f�e���0��zL7����e#is�ݝ�/���a(o�בx�L�\�u��&1NV��I�HxF��	4^�Ѝłd�0�z��B�

�j�Q�×�ƀ��5��a?S۳�j?�5��{î$)��Y�HbNg��A�������~�i0M����F�0�6��$��fk|�N���G;Kj-ݪ��QY[aJOŠ��L�x�mg�6�-�a5z�w��j[�?F�r��ǭ���d��A��⹯�1��F��)�N����Ϳ/��<)��RU� ؿL��l5]{U�H��Y���Ө�,�a��Q԰<��b���0�.���_��:vU���שҬ%]èx�̉�X^!���+࿗�������V;�򥆑p�ɐ8�lRn��`H�p|����"|!5�糠��W�.5��B?���R��L����^�'S�:[�7f�0�&�幵l�YG#:;U�P�.K��l�U@Z��
���Q6Z����K	~2��/w���*�W��2Tj	W͞L��j�,�T#�@�:'��R�Pr<v�YQ�
�����`JHe��/�I�Hbn�gi��Vc�+5��}�}��|r�M��UH�������0�H� �S5���[K '-�@I����4P��r�LD+%�n� Eg �a u%� �d���0޺ޚ$����<�LF�穝W��)Z�|�'� �j_��b���0���}3��4�K�0��3,㟲Q�<�L�[�!�d~��0nK���6��-.	k{�U$���A$M�XhʹLV�t��^�0ڻ�'�R`�S5��i��fS_�jʔD�q�PC�z�����p���`+}`�i_X��»�	��:I/��aM���\�$�]*8��a(�t��F��lTP�l����j+[m�~~�0��zL3�V�,����l�a�;�.*U�Hx�%*(������y��:�.cH���pS��%u�zA�H�~��1]a�KJ�hd���0�8�y���2D?k
���ƸV�jy��5�$�ڍ�"'[�U#�r���dK�Y�����\�eJ�g�in��5���*�n �5���S95��4PH�H���:�k9ٝ٭�E��a !��YGҩF�ظ�d�Qy&`�P�]/��A�Ks#����������[d��F���7+W=�d6�jTCə��ׯ��,�R��ȥ��pr�����>[u)ͣ|(��p��*��\j	�^�����f��k��R�H��~�������	����x���M�*����R�p�)��b��z*��5�$���vK#i�QΗ�d��P�F�J#i�M�Q)Yj	�E4�Xd���D�j�5nC1&�~t�Q��H�^i��$%����K�zZC�d��M��q���������4�Q5��3�!�`�ڿ�)�Fr�|s|�7)ԃ;8U�`b����!4�M�!uC��{#G��r�'�R�8h7��=��f{��;�Y���fq�\c�S�ש���D��Q��j*!nU"���K��y5^0�M	�˧�ƒ�hm$�*�KJ�6k�Tw�=\oK:ٍ��Y�a,������\��:e.ˤa(��Y�~yR��{M�-5�"��h^楆QpQ���T��\j�W���q؏ۏo�O��t�V�0�._DϿ�2��u+5����Y;H�-���p���z�6�鋲 �4�Ω@��[��f]��>������fu%��3(5�v���ř��T���G��0���)o�t�ɮ�=Kc����*���	c�8���Ѵ[uԬP�,+5��O���z*�l�ܦ	C���o�;[�]��o�W5��o�vW?'����A<�kG��^jw�ޘNy.�����a �d����LE��R�H<�����Vr��K��qD�K�����A�u�x�*���TSP����P$�e�r}�lտ���F��ITH�[��C�V�P�x]�D�c���;H�6����R�8(����}m2�ޓ�j�֏�G3�Yjyֽ���u�k5�]��~d�0�28m.g���aC����PD!f�a(�]�R��F�R�S5��:î#�_��J#�m����$�4�������h�j�g�kNn�a$�2`޹vT�ש�r>���jw��n,.酆��*�������hUԪ���\ڎ&ڪ.�³���� ��W۪M��f���5�a�����g�Y�X8����5�H���y��Z�.S]/a�������a$<�{��'��SD�<r������w����,v���q��ݼ�}M@�|\+f#`纹^�2m�l�0�=�-��!U�M��0�<^V���Hj�k�T#������v��抰��0��C	���0N�:L+�����8m	#ᰫa��d4y.�jHn�r�7�d4�q��ր�T^�j���ӧ��&��UY�Vj	�V���i�j	_mm��ذոL�F�[���0�(�(5�b�+Q�b/ 4�᡻׫.&��L�a <�{�ɴS$��LuF��G�Y��
{y*�
��&�iDZ�jH���w�S�O�ͪ+b�B�X�|�8|���Gӿ�R5��7�_7�k�f��B��$�6ol<�	��h�ay����'
OG���FhB���zO��jsF±���p�ny6^�.KC�F�O�Z�#�r����&�1�v�,5�皱[�w<h���Z� �>�&4��d��pA�@jEr�qut�۪�r�
�z�o�5��.���Əo����Y�H8�u�����a(��n�oq�^|�fCix�����B�ԣ
U�PZ�!������E���0ڸ��m�����Gh
g����Mf�}u��Tu}��n-镁:�6ˇ2i	�l���7,f�~�� 4���գ)���־8�	#������2�S5�$����y����gHL��jHL ��������t�F�0����?���W�?w�R5��M����)
���qP�����6mR��ת��PZ����H��T�Z��{�6习����BjMͅ���t�8�	�p�ϬK�r.~�0��"��1GhI�5r�?}|�T$!	C��9���/��N��}X�P���M�"g]h��^�!̗�ѭ��^����A[׏��$YM��|�D�U[����T�f���5����X�ī��8��0�r�Z�v�����ݘ�b�Q�Ka� ���˿���:��      �      x������ � �      �      x������ � �      W   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      Y      x������ � �      [      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
��W��o5��YۜA(�y�4Ǵ�p�D��6g����1�U�ڊ�R���(�8��<�����Lo8�H��Ɔt��HF�t�K���:VQ[�8�1�;�킃 `t+b�,�C������-���{G%��9��o�aTM7�)��eW����`<h�&^�T��#�v���3�gX7Q�zm��h��������3��S���>'PPq��2 ��=�Ȫ����(E.l���������jƌ�Q��M�W��P���� C�V��q+��3��[�-p������`+��F�+����E�,�?�����Q/Xr�x����3%���~1�X�?�q�����u# �s5����;f���^7֊�e��>�0l�Q��(]�����!��.���ڎ�%��M�o��t�������.b��F�8r�4T|�a�E�Jz�����34�r&�P�(�b�aj��9֍0�	�8�/�!2:�!�,Q`��O!�R'b_�2�����Oh�~����x ]5)4(��)���R��e7��Ѧ�����M;�58��&Z1m\�U.��t���[Ix��V�g8�T��0f����Ue�g��-"���d��"����44m"z4j��m�P�����hC�P�+PІy�`M���_�T6b��_(^LԴ�]ƹ<6����n�່���{�xflP�z��f�0�U::�������I!V����l���0���*@yq���t�	W�.�gq��|R�5��1"��B�Pa�N͂W�F�9�'�VZ�)��� ��n��O��i�!���wx�������S�Z���lʔBM[�(�c����_��7r��!&�Ciy���!]���eEG��{�uܰ	��V�3L�8�0�Lh"��Q}#��\e5g3����μr,ǆt̠�L�#3�c����ӽ&�%RVy\���b���ᭈ)S�HW��NC�Ŧ������i|�7��yuM���eAV���i��4�+M�Kg1��A�i[��x��I*Lݹ'�0�I�H,��@��躔bV�D���g�Tx/�:�<hp����1&<v��abO��7F)Be�1�ח&��#��S-iE^�<��I"�i��c��\N�(���#��gE�"��`�E���1�z��C,��'�h�'�L@pv��c�;;�$�z$��E�������$-/���3�FJ�Q,/����D�y/r�3L�B��P1N�b�K2�<�x��`F䍘�����դ����FW'ƒUY*�ίtɈ�Z�����T�G������XJC�����V��I��ڜ1ܽ8G2l�m��|���!2�������!�=?-i�j,�B6���|!��aw������I�^��:.�O_~���{���w����؜��S:�<)�hT�-*�'/L�?I��j����:�(��	BG�ڪx�Ĵ�p,����]8��P�iwx<X��M���ܙ5�>�E��c:w,��pp|ht�B�v���J�Z�}W���PƜ�+fƩ�Ct�yb��ja1�1�7�4�2(�	G���,�X�Ea�@��a����b��hc����*����������;nH���|b��sE�i�)�A��g`"!b�����0�����9�f���t��EL��,�l���2�u�1��'�L�bA�D���~B�)>4D��:Yj�E�r��J�}�j���1x�\�4��\~��.�ݙ�VY]�ȅi|�%����S�1jFN����ݱ�O��Cp4JǪ�G�Ѩ$%���H=r���㦭��	���SK�`�_;��Q���躝�B���iK�c�mp�H	�´�!2�<�棓�kM&.�e�R����h`�!�{�� ��^.j*bv�E�q*��GD�n	OBإ����ϳ�u����b��ϭ�D�s#<6m�墷����W�Y?�%A���� �_־mɎ�Z�Yя3�
���-qd�)JAJ�q������6
X�H�v�Bd��F6
��u�Ex�;���k�ϴ`?=���X�dԔ8�B��cA��MLL� i��w�堽�=����׹yY`��і�/��hI��&W�az�$�E�-�Q7S�p�)H)��b��2�71��~��/h��g��58Ih�A��������n.�*CDc���v�锤����5r���q(��'I�V�a�eeX�8�W�Ey�ͭOx�X�`�����m�� 3�qQ�B-&j">�%H���}[���:��a��ac ��������,e�������b��AĬ��#���z�qDn0T���-���M���q?��������������Q	kjv�E��t;������Qq�A�N�O���=Zkx�=�D���s���d�8~Ws�c�|3s��O�0��K��ѵ�(��M]<������1��N��o,aE��1	 OZס�d}�ku����i�x��?L�e'+F�ݚ@e���q��=)]L�' �1x�,.�W�G�O�0�1քk�Գ��,�J�z�@ѯ����`�u�.�1'�B�Z���ZǨ�#��_IG����q���I�����	Cbo����C-��\��R��������B-��Eq�`"~E�ݕ2�LMeB׉��9�}�>��uq���S�9X�(ר��i��1�,|#�3-���FX�-��5�    �|Bhl�	Z��ƴ���4]�'�^Ю�yl�����j�Na��71�^�у(C�]3_1C�}��`�T�<�<Ԉu��b���P����7ɽ�}��a���F I7+~&���#�Kg�jg����i9}A��PQ�xҠ��I�R���UI���{.��\Y���D3�<\�]L4O4᱑Ek��t\ML��:\ Ps�|��L�Cf���^��nb�7"<f��Se��E��M&&����A����� �%���ѵh�OC���qWG��aAb:�.�@Ev��9�~�R:��s�蒼F����/~�XGc���N#%.����߿��ׯi�$:H(.��R�o���a���a�6c��$�� #�TBeR�L�8E|��>3!A��g��Qg�E�̬~�J+�Z��7 ���)a}����1(�7�8GQ�xZ�]�a����~f���諉i���R����Z��}.$�{-H�r)W�^X�1�#i�7��� ��R]T^�T������E�;��Ь��
:��h�b�t��@�c�ۻ���όt7���pXKJ�P�.�q�zb$��S��@��b�
�ao�C��/�d�D����](O��m9��B6����]D>��8�=�T���G�ng�"�r�x'������EG�5cn"Q�{@T��[�h�u��S]$1+�ٛ����y����Zny�I�����t��G�H����0��^���[�&�Z�%�`��C�h6-���AX����gr�bO�4�D�o�Dhl��v1e�I
kF�&�����M��u�H,��b�ſY.�d'�/DN��[6��G{%����F�h�n_�p��	6�%M�ŌHտ��(M��v�D�j]�F���Ěr�yge95$۠#�d9����zSO�-.�q	�Y-ϭֵ|��m�r$�dB���Q����h��*C�S*�*'&��f!@��ADzOBö���D��X���Sb)%������!G�lI4�1��L]ճ3��4�9�b�=RG�d(���!;�r��!3%�;Qu�48�MM�C�N$���NIM8���#d��Gr����G�#]f��bb����1�v<�o���8��{F��X2-B�etvK�E�eKw63��e�f�b�'�����˅���:8e��#VnF2�{�EE~�C"3ɠ��5n-s��L�ح9�ڮ���Bd��K�GSQ��X�_���D����
�񣺨�=���bb�nk����(7�1��U��5,���*��|�-lXm|q���P����,d>Hb�Ѳ�W����&�iU��hb��ƈ��3=('�y�OTָ&L˿#�u��U���;���z�]Fl�v�^�yD(�[��O����c��Ȁ=�����i11�,���4x����i���+�eIZ �Wd-�.-SNC�b4^���&OD��ot��M��Վ�=!zF{9Qk���&&_?+<l�*���x�4�ح���4�'�Kq��ư������>L�ʱ1h1]y��M�����sN��kx�_��Ļ>�:��dwlɱo�0]x���H����C�x(��uډ��p#��r)��Rqϴ�����v�.�o��O��k�>-bF�����%k���������]`<n}usL- d�)�l�b�U����HεJK����T?1=4����DM1����T��4��������o�~���۟��U6��+��S�M&���i\J,�j�ˎT�٫TZ!2��V�b֛[M��M��Ux;@iپѵ����k����u�I,���.2����Xu�lL�ߪh2��d��;�	��F��8�_ij�,�h�6�B�w���:V�E�^;�E9�a��F�Ɍ�|2ڱ��*�a�(ǀ�n��ED��4F����q}zd�r���M�_�a'`2�����<��.t�g�S5fZ�&ִ�ِ�q�����;�Ht�b���@���n�D1�>Q�[2د|�;&3O�ӈ��������u�&w�0�0�_6c�.(��7��6�4܈O����\<֣�H\�P� �)	� �� �<^	�<�!���T��မ�����+��TpO�.&�#<�~񰘹������dbrQ�[O������~�����w�r"��N����Cxx"23L\,��e󜄱N�\p�L���9�eV"�#a ˳�6(֡k��a�" SiU���Z�fEw����7u�c����m0��kt�� <�Ӿ���p7&6�/�u��[�P�5��U>��Z�Ak>�b���v��!�V�R�/ard����]D$#�ИɌ%�o'k	H�	f��1�j	<�[ezt��*u����H��i%��j촆���LLݼ�W��Tu21m�B�*A5E������/�x5E����Y6\���DN�yx��g���vSs�.)p��L4�(��IZ�꘧\w5��7q���.&����a��v�hf�\�iDvW�<�+~21�a�Ɨ4,���8��V��Q��3;:�tg����EF�H�UlT�-�ܚc��́�.2r �8��s=�'�T��3����Y�uW�z�����]&V�o��Ĵ���+G�kp0&j)I���$�b�3��f";�&��ĶO������}ks��ܻ��=���\��G�Qm/1�>�W���� j�u�G̏s� ���>�g��M]4^����Ē����!�ubf�̕`��ؒ�/&���A!�y�+i��&����=�WL�y�5ٌ-��yX�!���,�#� �B�j1Tx\l��օ�0 @)60z�p�0���xc�r}��w�e�f��Ǚp��d���4?��W?��M���ǉJȑD�Z/):�31�C<c�8���GD����TX���f�0��2ԡ��l��Ҳe<���t�J}�w�u���1L���3��=�ȅX}5����$DV�\�Sޣ4�:ڥb/��nQg�!n�}�*��fbb!�+m�^�>"Z>�A��V'���⟘�$߆p��i�HN��;�L2�v��a#��ޢB�z�5y���M����^�Pj_K0L2n�q����J0���^��ML�Ӂz�#�_]A%	��j$az�.ahe�-&j�.�a�8u�Pj��l�}$.�J�q��9�cś097�o�րѽ��*�� ��}ԕ�(��������S(�%�0�	<��[0?
0�LLr1�3������88�Z��r�q��(�����Ypv��"$�]a*�������}��(�J&��]�I�#44;�H�|]a�����ɉ�JE�s���}�k�����Bob	�?-yT4�t5��@"t$e�IY�����z	�&F��*����҉��!����	1���7c�RB�t�Wd��l�_998N+��QٹԕKX_�/�#	�4�����Q�T^W�'�BK���+����aj���i�큺�hu��N�?VT���rU{,���a׌���e�\�䥌�8Gz,��Sx��.����i����q�9�71�m�B��mT3ق�~�LL�����#uNU��X�w�j]⢎O�Ɨ�5kBF:K�a���g	'�."�	�ٕr��pYM�n氡���ʉu�t�����>2�IǨ��������fb����T�F�O:6�G�u�h��>��4���`��v51����4��;`���V�CxD�I50*�o
&�<�#10ƈh�c�3��GT��XW:�]Č�k����t�Gr��X�os��<����d,�O��9߼9��g.}ԓ�o�v�ȃu����}\TI8'��(�F�����ĸ�7�]�񕄶�He`�	� �.���>������Ğ}��ǭ�E���:��6��	G��U�Ca11y���v�Y�U\��Bx���V���a���Yw8+ha6}���7�Ad�n�L�g�H��_�%kx3�rL��/㋅�`Bn�d1-"�X����xK�ʰAق"�]ddAB%�$1���j�����$�t��s}lԛ�� ��]<z[�kd�=S'1�L    p_��t�\�1���peX�Wd�W�)��.Un&F�H�3V��^0�D�1�s�gq&�w�{�>lۤ���"Tn�W׮NAcl�M��a�ȡ#��.��ajǱp�p]wr�oH���,���"�Ĵ)aQ,�7{�$^�E@�����*��XG~�$r���
u8�P���BJ̍$mˎj�S��vI�;cl��GKC��a�.}L!�����ZؠeIb��4btS�L�dQ��(��r��r]"�����I9JG�m�G�.\�c�dJw�H����Q�)b~R���Ĵ��{e�����y�GӬϔ�p�8��3ur�<P�I��[����-��Z�1��ݓDp���.gX�(�R����a��X�..רUti:��@:c��i�{�f�q���v<^���aÈ�b��A���=��9r��LTC+őF�U��4�dbr�.�d�ėk���01��[����] :�tmnd�.��B��`�<-ڜ$��/��N���W�$t���Mc��)�v��1����~Zc����
�~.�DmF?�Xǎ���4Ứ�;YI�k����22�C��,�5��G�i��$Si�5ȸ�̏?�����_�:�U�h��>@c11Y2�ψQ�9u2Qj5%B�<�ZG]'�hbZ�7�1�&U�ٱ��ݕc����}���]Ë{���c8��=�9�MD�;�
b�%�z�T�p祽L���si���-�����x������7.�8 ~]�����9�?{�1�(�\$���D3�ȋ3�!?u� #�;�N!'���ϭ3��(�Xl&&�aBd$��Wo���LLpg{�#f;t��|��G�C���;�7��Qg������0%�4�`H!�.Ж*�]�Fq�������͜�3�l�HH�>խ�č�#�θsi2�J*k��)�Z	�����ig7ب��C���ta-&&�I^�L�Vm�|��<��a-ՋG	6�WOШDDF�*�	��,�R�(e�g�ss��t#���ܠ�ogDd]���TR�?�ujbLR��g,�\��y�K9gjO�ӆ]U�p\�[F��m���|�|�Fs6���B�ÙXo�]�|��}*-3�|��ob�ef��'�"-�y�4n&�d)�G����kxM3�A�T��A3���!Q����+Fv滯)�x~W�]�`MӶi�[\�DgH��^yTE̹�{���
��T�ZJD�W�W�V�#���J���Ȑ�
��hq��g���8���F>~h�T�%Ɗ��_����5��_"<�`���Iz��	�3��ʲ�k&~���|����/o�9�%�W'<⮎�QPM���F~�#�0�P�c=W�[��&��c.t�
y���e���5�`a�����au,�5_�b�{F����=�f���E[�o�%7瘦'�O�HE��� �TW�Cv'�0��:����o�>�����/>�����&�����E+>S�%�f���2����i1��8-��|��<R"��o_~���׿�}��Jjq�ඕwt��8#����	�.�jL�ǿ�c��Q�[J���)Ѩ���0簏��w�b.����Me��	e$,:�.����prÊr
��R�,a�a�D	H����g����JL��"���:�4�$w�z�lD�Z��b$Ua� ��'��X2`u��� &��Is��a�H��hꪏ�x4r����8�����p����[D#�z�H����2\�0�v��M��4��c~��3�����J�zR1�0˦U	�ГbARQO�AFғb4d��8N�%"��J;��a|ɭt�T�@$Ls+q j�ţ3��$[&-��`4����f�c�����܌�JDB�&��ي6g'&I�� \�6�y01M!�� k��GߚU��X���[���ڬ=rtmA���n��+����r��ݾ=Uq�I+>{:��V|�M��8�rnY9��2�}a%�e|>���2&TFR�\v�J!W	g-�j';`��Np�t/����'N��]mH�n����9�q"m1+�Q�YF��Ƽ�0n�8oF����
	��+ƣ31����Z�]��D{np�r���by8~���T5D/�xs~e��O'�̬Z�)&��wc�?�j�ktY*�g1�EV��
$�?��S���f����.
��77��u61�S�EԠQ�T���8G��(%���q�o�N$JR�kqs��c\2Ɵ��4[��`����.H���tڣ���g���v�� ~�./:HYˀ�H��\
8MyFW�����c(�@$6�"����+�Y��Ě����ee:\��8�r�"Mi���jb�E�bP���7�$<X�C�4ߢ��hb�=�e۠������T����P�|���{�Q~:�*%������&�L{ϴ�S�F�#' ��ũ��_���q���]t~�����z�ԏ�L�*߬A@�TQya��p�$K^Бc��vR��������R��p�L:3�%����J������gO��&<֞~MsH��Gc������F�ܴ��-@��C�o��?Y��Q-R��"���a7J�"~!�D�B��T����b;!�t̪��æ�o\���#�	�2f��31�q�y@=�u�y(r�����?l~|lU�Q�,���&z��/G*R��5�hb�����62�G`�`+��պ��9��O)u�X�a��~Jl.�Bl&�R6�w�͂�����!�f�x��R�jH��f�[���|��XC�J�<���
7]�3(\�~6>� ����,C��3i��čs���Xn�sL5I\�~��fb�暌nۻ��-��X�1>R���h@�Ť�-q!�r���0�w�Z�(�c&���	�i�i̅r��J�e㓾��1��}D���g#.����ie\e�J9����r�o��ظӚ��s���<�R�4�L�s���IĮ���p*�b}�=�䘐t��-6(���G�w���S���=:������<�o\N��l�立M�|%b�d�a�_*�>�vM�/��m�#aUؙ�]ZC.�l��s¨⨃��H h��j�cu����S������v��_��|��b0��Ui�y�Y$�+��Rc�CL�=���WXc|�X�O&�ʫ�m�P����x�Wfw*JLl���n�A�����������C�M�y���TV%�cz4������FО6�5�0R<V]�I�ZË��w��N�^+{<t�ȅs�'A_%�0��������w�Z]D���}��|���G#�b�b�i�~�6;!7�,��U�Pn��u4���®��[��<y�hSK�uH�G�a�=�<k.ǔL������<�o�y�M�yD<�]?�����)k\��ǚ���<�Mc��玓�������k����_��&<YǪ�ăE�?15Љ���Oq=~�dk������8̥�!՞���n.�+c1���1��9�Z��s��Ĵ
k�cH&ֽ�w�3��:2e�ڀk9.�˪�I�euq����%ܔ�/3W����������;�U9$.6n�n�3�����BVG�j��.a�����r�U�Cc���	�{�A-T�����%j�k�j��=�aom�rLV�bl�M�6>���1���m�.Ļ�\�[=`��������n0/�� /��������/�}�����{I �[m&��0O�T8��b���2c�+⼉��h�;ñ�F��M��QxMXJ������nIF�<�4G #�O�"�Zt�A�*����b��J�u[E��Pn�f��
	"U�����+�1�]\�	��B���d{��ܺ�r�I63��&��O�V~�a�G�6�<�V{�n��\�6Äo�e�b>��8�|�C=S��1��#C�����n01�c���]���3b!��>l%5��3���B�ϢNh��p/ժ��e�*>1a�3��
O^+ƶ�v71�Y��F�7�U�h�4�D�r������~|�/����o�?�����1Eo�z���~I�'������3�曙�a��ʺ�cK�TFO5��dc��|���P    ă������H���3XDye����!���L�~�< ��g���#��< �š*��t��!����0@���/c=݋sL�_W����3I�q5�i�u�r��C���q��V�7>ܙY�v���L��a2�]8>�:$�p�t�#Z������E���}�GN�VL�m)��T�?1�<�kp�*'��bzKz]�3��|D�f����ע�Ls�P*$���ɷ���M���aE�H�	'�<��ړ�o�.7�9G+����P*U��8�j������k��H�_C<H�ζǬ2��X����c�*���n���}���A�������\=�N�6�;(�a�=�0M&��
谮���z2~31��8$�Ri�?�ߜ��|�Y�h���u�1u|k�@{v��fũ\��f������.ėZ}�c\W�P/L���\��fy��@�zk��a�ֽZ�º�����c�CH��2D�^z%�����՝���0�띞y6O8��z
EݛC�5s74Ԏ��A��J�"y"3i��Л~`�PI�0M�]��4?�Q)/������Շ쮰C\�dk� ��t���EߢQ���)��<��#�)�݊͝1�LN��������xG.f}d}̤Q��3a�>��E���{����l�z�p����I��Ց�J͠�<]W�hb�:O�ڂ�%p���\A�C:g�3`5��F����ۺ�aN��4��������֍?����Z���Ϡ�2��������Z�f���֝䂗�$��������m>�|+U���yNU��G1�/��s��)�aJ@����Q-�5f�&���x��=]���if�j=���$�X-^&�੿���Һ>q3�2������hg?F�&&�ٔ)����U�Y�B�5η��ݏ��6�L�j���9�&&6��T֠���Y�c�hb�r����?(=����T�W<�Ls�p6�v�4|�E����L�l���Pβ㦾�c	�w&��3�8���Z6�Bl11��9!��Q_?�q]Z���甂VZU~��������R��p�*�wko�M��l��x|����3F�C����
#�B�{�y��ĪZ�9�c��jb,<�S����Ek�W�/Đ�t�M�$N�ňX��ƅ�&�Sm��۵�UQ@�e$	;�}����:��R>���R�ȱ��-&֥����66B�Э�,�X�Ŏ;�����w��b��46<^�n�=�*�LL.���$�]Dvk>�*�+�̘�z+o˰�bp��Eb��Rh������^)�G�CA��V;А�Rj�}撀���=h��Vl�k��cO�Fd��gLn���r�<cZ��&i���61"�V_�14RQK��}�B,�
i����P�HI¶R/�.2b�Wvy�'�����p>R~�5�jb/�4&I�PR��V��Ñ�b`�81�� >�6�庘�_N$���k�z��ň=�*E֕����C�m41�"{��F�~����͂�0�م�����A�`�j�C�1��݇�����nb��=+K��4Ѷ+���Y#����6��P�L�~�I����o���zx���9��p�j��,�ߵD��Fd��|�Y�0Uu��d�,�v5���k�ABm�yi��s!B�{&2�ӹ?aaB]?�ѩQ�ȕ��Kh7�L��ҕ�Q ���x,�����u��ae���\��`�Q�/1�1#����j������Q��ʗax�WNcp�W����I�ڞa�x=Y�
���c2 i2�H� ��>�k$�̰j)PPSF@>L	�jSD)��zŕ�މ��j,��F_]�k���)Z&Ki'W�ly���M�p�z�_�n&&�*g<��He��v#c�$a��m���Bj71�@�L�oSu��$��B;1c&�ql�C��t&$"LYɢ���S���g���ed0&���yHޡs̬WM���o3ˇ�Nj��a��L�!��U��#��Z��ς�Ei*�b"5�g<6����:1O��0��k�(�c�Q��i��cw1X,�S��Ɵ���-���o396ˊSV��d�Z�/cb�l�3�}E�n�b�u}D���ajT��|'�Rpv��Ƿ$���l��Y]�M��7a�y��X����A�a�q�U�#�8�F�ML[X}�:�&~.��a�in�)+��ѵ��,�.}�I�lv�Լ��g���hjb��4�[4����
�.`�t1i���<�� r�kC�^&�a�D+�T�3��!{&0�����CSg3����n�h?aYվ���*x��s�
�����>y�c�	�p��F�����2����fb}m�O)�Qn��6"<HX��rtQ?,�v�&&KY��`T�����$4U1���Mw�9�1Ya
j�n�-��r������LL��qx�����D���x�/�e���T(�)''���M&���D:ȄYP��o�N0�r�x��J,��2\s���v�0�5Q�ͺ."tND(��,x"�lm�ؑrϩ�m�p��PrL-_��g�dw<G�&�ew`�H��]�$4c9������5���2�F��JsL{�q�ˬ��E�����kQ\�>�7��㱎G���\�����k�,ԐcZ�z�����""e�Q���t��[o�NNjАL�k���4����tXK�&�cx:��d��$}XMGĤ )�AB���ʢ�9F*V�T_�<�6���"��媐�<��A��E[9�����"��:��H���T^�k�G�[>���$����ۼ1��6o�0�Ϋ4T5Ɖ��[����IX�`�SP<�-�G�E�(k,�.��V_(b=R���D]��=�y&D��<܈1P�tZ�ky:��N�j*~�[Y��
��L�LJ+)a�+���n�"�s�Zm!����v��r.R��D
B1�w�b�~�9֊�f:{03&ґl�k`gb��@��V�>�������*wLՉ�a��o��n,����u5�W� -f� �q�F��a����'��7����T�>�ۯ�?����������wҶd����gj�15@�gǗ�vct-��x��.W3�}ާ>�HBg �K���蒧��#xd]r�>�Ƀ�2�4�K6�x?����zL���e�m�gϺ��H�����B�X����x5&��߅]�����6{%c���B��58H>8�c�q]KH	qk���q]��K�Qq�!C��6}&���*�c�AD
t3�{�.M�޺�[np��&ZU)�V�>F]�r��*Py^�$=���t#BE�{����[&��dP���{(Z�M�fLW��AY�2���-��a<�/hPv��&s2RȰ��?���^���=7�`bj�,a�\� �5�hbZ���Al�wv�nY�;f��ϗ3���"z]��mЎ}��G�|�^����휉�UZ��%pQJ�[L�*-ʃ�|l&�715��AFJejP�R�(�,�,c�������$�����VJ~�)<��:�Ƣj�i�hT���%+�� *Bւ�r�&L�%N~�"�GELdD6S��JL��yqe�A��+�*�DR�_����yY`5T�w]����cwLՙ�"��߉yT������R�9�f�\��E|�Q&Z��1$��7��կ&�Jؙ�h<Y���
�ἡ�
��~p�X	�h��P��[<^)89�>�BRc,�L�#>���1FF��*��H�1���X���@���$�b#E�&�[��Q�1ś�	�rF�|�he#E�(b_�wv�K��:��S}A���hb��J���2��H��$�_4܌�=I�E͞$7�g�,���bbz�

�.��Z����cٖ��-.Z&�*R�x���|i�cr$�t�DWZ�'�L�C�zƩȀ@��֑���XQ-(O�X]9��җ;�*�K?mb�p����~11��.�L���!��6~���Z��'�jHm�y���I�D{�\T�¦O�5E����'��k���� ��+$�%��l��öT�d�&&�T�)t"�:%�v���F}�i6153�x��nt    �SK�_��W� M�ݛ�i���Sˈ(��֌�n�.}6ʃ�����^��>��&&�kI�#O����ϩJ�v� ^A�s1�g���GS4���v֎|�k0��LL�9{�$:x�-�Ӽ�T�V>�$\=��\�gǣ�]D�(
���~�uqP0�X��Q{LLv�8�*������N�]D:�����Vn��D"��y+W	��E"������wx�0��uH���i��v���f���jc��Gg���v%V�
\T��1��J�c�m]Gc`��W���Y�X����B�y�<�Q�G��"fL�G�v���i�P0vw3]�U��tC�>g����iټ���ţ珞�-rV�T��1%+�qP�"5+�U��Q�71U��mQ���DS%b<��V���R�Z�;P+��Q\�(!c�լ�����S\o��kS�\ZRQ�a#�.6ZN/�A|^U�u(����~�7�85�1���	��5c�}��fdNs�Ơ�"� }�DX0
�v��h�l���di��f.�
.�ц��>��"�U����Dj�<��.W!m�B�D��v�)ɛ�`��q��(��N�ě��#<X��.]�o�4fi�<��P�P���W�И{J�|�9�c��X)��;u����ѡM}q�=�"�������Pt�<^)Ǻ������:W1d���H��]�"5q2����8ɩ��j��% �-�1ɨ)Z-��5o�����)m��>+A���)�W���E���ԲG��VL��iO$ƃ�o�5N�2b���M;C�m�h�<�]��\L�����2��0�0,q�����&/��GE\q"j���H��N
\1n\��Ȗ��8��g��;ƣ�Y%N�"��*6�R̥�S�T�&y3�0P���U	Ӝ���F���`��{�QBn�y���������rAFxc/D��rWE5�Bh��:5G�|�������bk�u1Q�N��L����,L?15m�$��r��c�ҘH��w�xtwi�ʜH�z�M8�b��;�D;�0�p��f=\d�W|�a��iFݖ�p�1M����ѹ�GDI�o�Pd��!�{(aM|%#M8�Z1%;c��$ 5��蓉i��f��U�X�HJ��QR���h�~�.�J;�X�Ğ$��x���A�<����0R���o�>���hb�c��_u�S��+�dNL�rc6�(��HW��'��U��"��nbL�%�∮ѵ<�#�㧇&�|�b�!�i|(5h��kǈ{�P�0���V$�\�W&�.�PD����'��u�y,�7C��.2�SٷP�-�[Z��l=8.ٸ�y%߱ѝS_��2}���o����f:���!>��������n@%�n��b�\T�(�q�>�D*Z��t�gS��,���t1��̈́�.�Y袑���r9>Iô�L�I�X>���j���Wщ-
�&F�\<�g��ڮ��z�;���H3��If�v�J��*���Y���XG�~�Q�^G]d��=���Ӱ������FyP��Gg�e�������|�z������o\�?amQ���-���2�fPCه!a����O��@�Ĥ��1�];�S�T!I�t��svs�" U����I�p�$�Jxw��*�(���F��.+?� ����FR�$�6>F��Cs�
<�����$���r�s�0Һ󸦰s� ۣ���i)$���ꢡ��$6��]-��j��cd�Q��]�kd�c��.k�lE�ׅ	Ϯ����{0�	Щ6K�DÑ!�F���u�%ar͎M��� ��#��x͠!D���ZC�^W��u��GWࣟn��t����H���w�����$�Z���Q��q��.&ܬ�x�6}�N���3A������ �܂��Jw"?�<�.&b�b���b�Y�� f>w�����5�P�S���񌴼�\1�zM��dP�����-������	GpV*���ά�8n���2L2eH�96T�L�ʨj0!&]c�i\�hq��i�v�nx���܈EfG\Ge�X?���S ���E�{���
���Oq��q�� W�`6Ri�v*��Tڙ�CW7q�or?�/L�M�r�<J��ܭZ�u�ǁ.(k�GE{k0"AG-�Šb\.�p�={�P&J)d��R
Ii�tȵ&⇛�5��XJW���C&��$_#�J+�טFk�,a����������ť�㏇��FD�66hH�F�c�"=E.Pu���0��G��ΰ7+��+	�2�<�ց��ցnXI��n�&���LLM���n -��C-���ug���X�͍�&�rA0i�&�!����4SiD�b�&�f��:ؙ1�MLK�d<��~����f2�����Y�q��3�C�G@��2*��g-J�#��kdZ��m���26�gB�S5�&4'.��!��\�Oὼ��)��W��q��K��Iϒy31-۔��aWIDd71%�h8"�g	��%��5�m�c��" ��1*r�5<}򋉩�#v#>����hڜ��gR�7x�5���̴�K�j�v�̔a������Dաc<�w�����a$*�K7���͛0Q���b�u2棕�%� 9X]<��'1�1.Dj-�]m�˫z�H��:K�S2��W�ȉ���_/8�ˢ2�h[�6A��38<�9��GG�RC"��(iM��3�#�����X�N��[������?�K��4k��^o#���8=y���Cx�����ߧզ�x����o��f�g�Tl��&�����X�N��0��e�(7�X��`#�O��t��k��v@�����cvQqM��L!���ڠ�c�=�9۠������!?G�+��q*���4�x�{�""�I�P��i|��r�x���j��"����31��̨���m��&��	��a�*Dd51i��N��:���	>g�*�/vz���2�����W�R���n��3�	��j�5�kt���8^=+�4Nƻ�?����4^�p����/U��$��LL� Ï��/u1Q���"��7�Q�{�E�����w6�b��o��^��S]/����l����F���<�[��O�e�y��sVv����}��:�It��<a��*�&��$�S�~F�����"V"L��?>�E�&��d�W
�A�b��d�C��i���ۂ�#vc��rj/���Č�w��K)	��Hv�ͤ���e9~��86~�<�ѵy�<j��J���#�/3k�]�_���S�u��	�ɕ��319��Q����k��rb�p�d3��l�Ǩ��i��.�Q�؈5u2.�,��M��A�x71��`��*&�<W�}�㸋H�Q���l&�����C-+�)dT>S��q�_��	��Ic��yt̩�Wk��X�{�azV��&Lչ���Ty\X#Y�C���Xu��vFEn�ދ��#�����.T\��w�F������!A���OL=-f�Z��3t1ѼX��礎K�Q�b15Rù�)����!<<�����ߚ�e��Np?��C�.&�:a<��Q�����~b��'����Q��pÊo�"�6f
�R��aLȓ�O����Ǣڧ~��ꕰb`�+9�����S��7�V�WJ�[��+��5�%x���bi�{'��q�r>�ۗ��ܾ�q��M�*�����L�M�+��Q�`5��������9|��Y��<��>��:c�.:b'b9�[i`ԡ�h\^�[��kV^j���B���9��2���ث|��Y�VۣY?'����ԇ���}�9�n�8t�m�t�L>�~��ѵ��1�ыy�r�
	��[�{�w^�0ˇp�u3>^�t�^<tY�p}(�;gbL����[P�V�	�YP�����*L��'c��@@R��J�A�� 5!BS�T�@�[LL�c��v��"�JC"�T��!�U:�NL���運eL�(�E@�E@c@[��vL��2a�İo�&������ gT4��k�����a�A}9qx�A����MS��O��4�&�R;Wr��g}31��Ix�r��    5Ԭ�IA���V�E�2&Z��}Mg�u+�NL�2�q
�礋��eJx�8���E�Qggb�S�SQ�⌈�öq����כ@b퐙KޕѵScZl��2�����<La�>���Ć�D�Rר	Zk	�6ȕG�{Vj>gp11-���O�ٞ�D1��Ğ�v�?�����˷_��������~�qB���h,��;n.u���MLh.����ɂ�
�#έeŉ������-M��g4��je���N�ˣ%a��b�uՋ��/���9��n��o�IX�<:݈+~̬�?��Dsgr�;���OF�V��T=:��.�N���b?꪿z��˨l�`�"��}��5���ؕ� p9sRq�J���z&)�`-d.L<��v�0�C_PI�+�71Vb��#�<�@(�t����"1���E���}q!:���RWVvй�n�d3L�R_F6��>�.�Yv�xڞF�����`������AD�|#�I�ѿ�Q�2�S��6|�m��1ў��,���[�2�Zቩ~z�E��3&���H��P�;�T�Ȼ+!y���x� ��3�[�#
@AOn�Y?������X߉�|�t�Q��t|�b8����_E����
1fK���\J�co��1D-�y�Y�o�P~��ZOf@x�O�� ?�,�N#�,��X�}��ۗ_��g��9o�k�ߺE@J�*GJh�V��N����0�)�`tgb���[&Q��e䰪K����RDeO�e���a|5C,�T�ҝ��!y���IGݠ�n��V�0�;sG�p�k{1a4��|�U��}����C����Z����Hѓ��,�v|��}�f��I@0�����4�_M�+�w#vL��#f�q"�`�"�b�-e�|}�W�6��a]y�]T�����i�t.��9�y�h�}�׎[�W��٩������Cu�.��S9�i�2ׯQ��w�����078[����M9��Y^�sB�h#�g�7���<�n}���̄711O�u��a�`2���'�y��j�����KW����+w!���RيܡӜ���*�M��(7��U��؋I ��&�<_�UW%1�|315ԠB�]T�V���1(�G���m��E��)E���[���q�l$�Ck^4��c��E�u�%G���gU�,j`/�x���[�2��@G��e]���c������1v�x�P���7lxU9��7F
�����`��Ĥ��c/|v�LTy?��+}]�|�4�
;YGt�f���2�:��ַ7�P.RT���q�x����v�c5�D)�sa͏uV����v]\�
����pm �*e"���6X:����t��&(ֺ�Et����'{%d%|JF)�4�G�2��A���:���h���v��G��qږaD?�zR%��E�.�0�f��Q]44����cVW��������KUn���R��_�R�K��D)0ZH�Y���1�8�3�8>%W��`�>;L�����(���JJ�z���Sr&%��h�Q���Ex,C�&�q1�;���$:��\�$�Ǩ��IIt��9���]o��s�1Q40����x{Ś�2ⶃ��o�R��t��jz�L?�v��.�e�w��[���<r��L�Ո���2g�9�����?Q.ٱ��.����bK��T�09Y݁�t�7����ȱ���Rl��Xn�&����t ~���Hg\%�jEU��LS�.���<���W���T�K۹�fҗ(ш��u�\���	3L�c�&i�4�[,���M�k����$������ML3})\�S�7Ӱ��]��_��E�^��&&yZ����L�=y3��Z�>M)��`��C�-�ۢWLpj����z	f1��DȚ*s�cd�铿c�5�Ʉ ��¬)W���[n焩�ٰ�q�"��4�hr2�����?wͧ۪�ZOY��W>���[��k|��Z�͂��{��W;e�V�Mx��ݗ�J�*G=�c�$az�h����b���0=7�=S�db�m���.��ǘh�뜇T����1NH΍QD.���X�K���fǛ��؏a�a11��gN?�Ө��i�>�!��Q��Y.ϰ�~��k7�0c���Ǯz��G���Z	�<�-&�������;�d=���G����-�c'� 
�Q�Xf���sd��>7��
�
��2{i6�k���q|���]+G�<@��Gg����m[�E��Gǯ��\3L��3#� 2��I�������B��$6舳	�LLt\6�H�6/�~�܉����}���fA�D�`�$���?�`�����"�ǻ��=Z􌫉}\\uqX�|�^`S���PÉ�b0�j%/� \�&&�An����.\�,��i�
��g����$�P۩>�lvꉩ.�D2N�K蛖�X�4KA(�E�,PZ�}\{Bc���;�Z�3�9&�ۯ?��Ps#�Q��n�3�8�[o")f�����Ԟ�6ךp&��g�*	��x�(B-k)}Ǹ���SqǏ=�2��$q^	�w�Sy&�0G{I��PoǛ��&��/p�k�ݟ�=z�?�lG��uU�Ҡ��o��p�[d�4�T�L��m3\N�Ul��ܞ�G<�@�����;��G[:Z���dZ/�D�*p�TN�԰y21~�\�$&
���	
mݿO
c-���0%��Ti��h���4�şa�@���ȁ�Tg�`��,��#M��wbaÞX_"85�$�m&&K�6���}T��'9�w�=�T��m�'�dXc�tp���vS�Wsڛ�f7�*��$o֮`U����W��' ����0�+͈��d�M�)S����F��5�xW�IOLL/&��	f��	�a> �h��\�^�|��O��)"�YԀ9�D�!9�����v��.����+�Z�� ��v���YD��� "2� ׭("�]�&c<H��T3��2G��TEb��=ro�.&��|Q��8��o�.
�(2���	6u�0�`�YpKE5�絨&�0�
��n�HǒK�Y��cbZ,�:�q8��ʉ_'gb�Q�ǋb�E�]�k�I�����x�;k,	�Uy7K|N&�f ����.&Z�w�/�}3�X�I�F��T�c`ܴ�2L3b\^C��׭6b'C_y��[���y�۞�7Kj�MvN��Ug��A^Pt5�S�z�#���)5��&Ƽ�D��÷'}61���x��V�Y���X�C�؍��Wo6�v�0Dy�
���4���ף���Fr&����:�%ܳ����dO'�z��SD��XC�Ne��Ω�RFr�&0��Q����(8IT�A���*������$<X�/�0�U-v+��"��b4z<31�>n&���T��#zf��^g��a���f�E85w���r� 7��T�����X�z�w!��@N���[[��9��#<��$�Xo8;cIڸ�d__xtm}�|cOc}�%�U+���g\Tࡳ����gTd��4�+�rNL�qr.�`L���`l̉���ţ�Z8��>����Y����񈬒l1C�."�Wb<fؚ��F˧��}��澷me�:66d$olB��#�K�&��f�7)q�
�O�B�C8u0)X e�ԉ�"	l�F�&ZX���
�de�4���W,"֙�ļj���5x�s};�%R	F28��
�5(����$L9��2��<P�2.`SNM¤�)N�^4�HNeDzRe�S���4��
%�3���-��j0����]����u���.AOE.�B-�K��&&�X�� M&�p�B[���Č���b�a��>�4��l#:~yc,��x*�^�X������6�r(V]�X�s� �zh+�A�1��qo-Q���Z�i����?��u�t���6��㲐���e����t�G��|�e,�t�"#9f�N�{X�~01RW�_}z�ѵ�'�A
e��5��.
�OLͨ������o%)wL;�	����7��,���p�����"_R�%Ω��b矖�t31�;	�����T�7�2�O�쎩�>r�v�骺�u7�����    ���[Y��N�it&&����6�Ć�wQ|mZM�8e�'���6t�_Ì
��J�Ix+N.L��l�1<#�1YLL��pR��[�2bD��J4��S�81O�1�nbZ��AZ����0��Lҽc�#�s���&���Eh�0{�{a���"�<?F�LL+yf<��Vi��Q}�w��S�y���щD��H�v"U�uǰ��ɕ;&a؉t%�A_A�Z�u�hֈ�m����Rn܄iɆ�G�����ҷF-��֣��^?���k$>F.�l�`Bn�r
q/vYs���AJ�l�ا��
���o) L�*<���_��F6�_��S���4�+�߄	���G�q�kY�f����y�"�"\V�b��h١�����;+��[�际��k]D$�=�A��2g):��S��81{�2Ѳ����v6Ҝ���c��K1W��`��� �T���Ad�������':dWR�e$k��}ajsܜ.p�_����h�6x|�I4$熍�������b�5B�WhX��(��K�br�a������	)i|��5�k����SU/���'gb��>��C�����Ol�\�.��Nw$�cYؕ�}P��ɀ�@X��z�1�lbJ��Ecܫ5;�L�kݧ�G�8Y��wrz���qۂ5�c�<
SH6(�M'�\�K��_�uO	�T���E��'>%@B����bi1��DZkYee��>V���3a=����f�n;1nk�_6�fT3�E��^1�D*${�����aS�YW����r����/����5oP����-��ƣ��%R8��v}L�Z�]���q�N@��}����yi�?ϋDZ�Gb�mk[�]�.�J�y�\��m-wݢ�K�ʃ(?U��cԭH۸01�?��1)�Iyt��tQ��x[�����G�7I�H���q8��q��A���aPob�Œ�ݿ�����o��I'���HlƚW�B^��s���#Y0�@e#Ŭ(RN^��Q�g{�;�<��3>b�c���O���ؚ�̑�x-�Q�MK�4����������o�3���BL����J���*tV�i�bz{���w>U4`
�#���`��~w�Y�~��H1yX43?�M}(�v�Ę�T�:�7�|7���!�O��d�9Hxf�F�M$���0%rFi,����D/�${+�x����?t� ���l�<���ţ�t�#kRJɑd౦7�K3L�r$���밋��l��5x���>&G�E�5��ت�%LϮoБ��d�����؂�]T:saOn�/�.�f�R��jf(1��tU�fI]d�M��q�����.f[�a-��ĴlK�P�Ɖ(q�1�r׵y�Ծ������^r	R}϶;w�,�z���ȍ���uq��eRb�Tڟ��|��&D�zq�j*i\b�3�q��V�H8�0+���V��yH��k�����5;�%+bՆ�u�[�Mn�36��C�c�ZV�c6;�e�dJMڄ�}��ۥo�E9tA��.��yԌ#Qr/�;�W������L`w@p��4_�O![,��$���ۗ��x��_͕���l�
�KJc&Q��.ނ0n&f��W����{�����(�%ϰN9�˽۽�@o����ؠb�MT���7�� -E�72N�����N9�o6?X�zO\�O~51�@�}������`�h������yR -��b�v.�K����g�Wܣ)�3_����Ǆ�uy�I��F������&]�aZ�Ɂ�ll��#"�7xH)����'��[S'1���BNҞo߱���{��c»�[&"�3	�XL�qa6y���\3�c����Ĥ2�:�ۤ2���UL�~�H��t˅��>o߱Vt��*Ħu$#յ^Ö3�0-�Y�UbQ�n�������B�@�cV ��	A���Tk��Wp	�2����ͫ�ab�3���<�\�#��V�%��h��`8>h��5z�<�B,�aib���3��s�D�w��4�����%�wLUv`^�	�]L^�{b�d�WQ���?��u2L�G��w�a6�Ǎ�ߙk�4��j�u��ɒp�����Fm��Mm������ϟ����cVp:�Vp.d,ܓ.����K	���5e���*}4��"��:m��])�A���u �_�@ceaПۥ0ڍ��x�Q���CjZLLUK�䍵a9�ʖO�+���Ě����.��j��
<1��eZ�l���ˢՄ��++�m�	�b:`y�'�4�"Yл�6���N	��I9��0���20������9�l�>���%��~uQ�1�&
y�b��PjJ����ߝ��ԉ5�_w������5�lb�W���8i�Xq}��t8�X%�PA�V0�bbZ%%�C��XML3�q��:�H@�b��T��(Sq+��GM<al���C���������)�5r��	/�0F�S�Hh��2-�x�i'1�L��d�H$��g�tW&�{��°���@�fD�'3R
죠I|���}����Yu�&f/�$.Li��w`�ed�^���x2"E�M��j�t|�2Xsb������Ք�4�31-%��#Qg�7��=�C�K�0�>�G��5�C���U*(����:�Z���%\���9�ΐ?���X�����T�Cy����^$�:��J�T�@�E���L4�@�WU�iT�M���#�P2rF��Ԟ�8�l|#;����\TW7c����9I\��^���ô��q�\;��L����F�N������ܪ؝�4/���;�Yg�v�UҠ�b�6'6�SU�Re�7��s���$o?���ם�'��<4*[hNrkl�aiz��Aiz����cl4��1v�N�Q�����'�$id]��&&�N3*D^�:l}H�gS�I&��3n(�0YLLK�k�0��\'�f�����P�:�(_��Gv[B#{��T]L�r��a��a|y1&�:�=^ 
�u/���	��+�����l���Y�F.�O��f}�<��������,���F��ҿ�=D&Z>#�J�w�+�D7%Sm��*�*b�D��wy�D��*�^��>�\(}.�؉��#�%�die���c�#����q-[��CkL�z\��)���4�hb=~3	�W%�[H����0c���S84����z��} U���ZĊ^���h��uĢruv�^���vb�p'(\訩&���jBhL�(�z~-Qb{21��5���1�V��R�����0���&�o(a��J_¸���\ئ��a�_o��j���؎�1�T�h�$�e���zfX��	i��Ĵ�CU�`<^I�{��������/"'����?\?b����4���E���[:�������^�o����d^�����%��6R�a|���<��!��^�0���MLv*IS�|K�qv&F]-N��Bo�𢫅�E]D��̓��`��F;�h�'����'&����E:Ɩ!����@�a�I\B/����0��O��^p�&Gl*�|��+��&�!5�n�x�978������B�@��h��_/n6%0i��ML�I�<T%��5%J{�j����y41�ku:�g��P,�^��i��+!��`K��"�yb,m�'����]�k�h�Ǆ��MC��pb�������J2��>�߈~��y���W��$W;cVrQpbj w!�X���D�r����9%F� U�*t*��'�bv+��N� �G�{�g���<D1k��u1kJ��ԩy��QY�{by����'�����X"� *��?g/��'֙NCv���ˌ��^�T�E]�0*�%i۲�=��p'>��w�����bl�G�A<�F)���؋c���Q�#�j"��88���x|H��#Z��r�J/N��:���#�4����`<��q�[)n}b��ܗV��(�Ř��\���
0�*�cO����^�Fמb����5�̖�$a=Q3�@!�Q�f��5�<Ԩ��!�HuNUս~r��|��L%��%�&�)�0�����N����L!��,    8����3ur�[<1�+�8��T�����c��a摂�~@�|�&L�"�nQYJW̉)�n�Zb頰��&&?���ܖU9Qx.֖^�X1����V1Si41����ˬ��g��Rf��Ӷ������.N��"�}t�ȗ�o���1?>�뷷����7&��H���B:I!�|b�&�y��ȧ�	����-��<Yl>��m$qh�F�XG.!��<W_�:bd�+�Aĺ}'�W��sD��:��0��C:��3�)�G���5X)�;��&����x�Y3�	{�|���4yW�8[B��e���N6�Yv-bơ�:�5=��	a5#Cv��З!�����u�����v�|��"�q����n��LL�Ą�|��Kr�U��ȓ�i�K�  ~���0��y�0{����쫭U���e��)�����\�#����Ɔg"�㎼�zi^�3�D��]���כ�z�����>�vYI��o�u7�0��uA>47�����RJ��>d���a���j�t.ꢝ߉�*�g䲮?)Ø���5�Kc���"���翿��88��z|�������|H�����H���Og-��ړ���c,��i4�t��/%f�$��|o������0R*�J�VXD�5:�ak�s�l�e5��P��'�Ae0$���ȴ�0����xP��7Ө�u ��u ^��Q���X�jaDf0.be��\
���UY��S4�0�8�p��5b��4�E#�p��|k��������GJ��V�Hy4�E�B̂�s��w��0�P��s��FoN��E�{�|������3O��͹�����չ����&�-1;�1p�L"&L�F�C�1~w�\XGf%�t� �c`�S�5;*R ]�ź؁�W�,�ƽ�t�Z�P��L�$�fj��9 ��.m�N�������̉-��Zɋ��#f�\���%,�?�X�bV��V�e�|�&�w����qH7�on����99�p��M��ɦq���R��	{��E�n�����`a�o#�~|���e���Y^1�[�;����ε|�5 ��\�"p�wqy��[F�m�����S�����@`R�+	k~0��uq�����������C&�~2�	!�ٰ1�����v�\���Ǩ��ݥǚ���ry!GX�jS�C*���LuH5���c����1�f^�S�����dpMFU2Ƣ�������t�P*���"���I�5�����(\�7�rF堩b3�
k15�5�3
>���dTH�A�_wu-􅉞��؀f,�b"{�)셪c3.�Q�LL�W5���*FD�WQ*8�W�=r�*2��<��\��Ǩ�ĚӢpY���k�|L��=s#��Pr��@��E�Ht/�Q�Un�1ve&Ĵ_�K��-sp���
H&�~J���mp1�٫\�o&#���yx�p�[�Ę�2p�����v�}�-2�gz�L�F-a"]�^��|�ؑpơ
�J�/a�W'+G.�W�1��"-.�zz����Db`9b����W�5��`8ob�26'w��]������5�"�"j����	P�����t�դr#���g�k������s||��Bخ�e�V�˸�~������n�^!F���`�
ݸ#�"�y��8%��&g�4��:e��+:emb�ú��1Z��:�~�>��߅d'V�M�`KQdxab/Wj�;0>F]LLαjp��uQi59R���|�]�ivEӸ��+�Kz��r��Ǡ�$L�r7��g�\�3�M��k-�R���t���^��zg�Y��9�E3��]�B�~�_�a��
���H��Vr	�$e��4���>T6�ؐZJ>�y�7�0RprL,x�0���ocL��S;W�H.��5W+b2�Z�Y�j�pi�m
�����DW�����l�ub�l��C1�+��2�5�&��
�����k ��5w��XG�/��7-��9�7��|_F��kB�y=o&���_Л&}�b"g�6�(�-.��%�V| o�*����LL����#���cT6"A��d2y�#�bc|E��9�bbr��r!9h�`���n����%��b"�[�bo�..}�Z"_�{I̅n���=19u�*��~��d[Y���}7���~$�"������~�92�ξBvg{nܰ���R���Y��Xc�?��`ߍ㍴a��D;�nb�՗�D�G�f�e�ٛ�n��7��:ue�uS�1ک���ì�����v:1=� ����m��s��g��S����9��D���;1=ݕ�Fl���դ�h��0~�I5�����Gp�p|�'
v�b9ǈN�G-�UG�K�2a�a� �����y��I1����7@�H6'Q<�`r|719��SWQ���Z�M�jͱ�Xɂ ������n��5���hv�e�z�$��jb��}$1�eZ�o�)�E�խ�K�+�p�HJ���|�>�cj+&f�B��.&zA|��-��ťY`vq!V�F,�.�_�҂&����+�z�.W��1& �\P����]��\��eX1��s���b���,��ZsLm�A�}@�0�L����A�0�ʔ�d�=98�;��E��>��6%#�>��lb]�:��G�y��t�R�Nz+u�Yg6�mPߣ�d���Ƽ�)fv��1��&�����6��`�m��5VHh�Q.لu����G���#�8ctp߶�6EEy�&����	��BF�C��Y�����O!#m.����v��ٵ¶]�s�'ǯ����]���'�x|԰C�&��"�T��CO��H5Ǻ��3:�c!<���X`T��/=��>�&�K9��E����dV�
e|��:��)a�%q�(�W�u�.�(\��x�-�����B�q|�pZ���q��3R��0l��ִ4�zD�=|,>z���C-��;YO�y�킄1'_��n��;10�u�1�:[e
�.C��H������eOfM	�EFVB�T�0�AK�rϚ�;�%�a�ؓt�*�w������l������կu~'7��%Nw��$����E��{���b���K�8�����t`�L=b˹(ML[\>�Ĕ�qF\�V�����O��,���H]�D5��{���ơ������׶��`d9�shڧnѷ�Ě~���u�R ���@��iл�1�j�n'��T�F�Cr�K��/��26�W[��\���[x�����g�Q���!��*�d��$#��a��X_ﰁW�b'�vp�J�[���S�S�8�v���l���9֪'��iA��^�]D�M��l#�D�]5Ƕ���i��Q��!G6��Ǹt�x��'R����~�˪���\LoL�sセ
mU�d�w���f�����ckqV�u�Tٞѱ;��=#��S�1YM������h[�q2G����c|�\U9�d�Q'�ͱ��<�\���a|ճ�F�=;��"����>&�F��(���<4m&�����-��s�N��6�)h�^[d�=��٥ـ~71?�����������=?���F���^G�\��'&��Δ�tԝ�N�����s`2�U=���VS�!q���!�i�`]?�U���g\C�M$��:m�(��L���v�G�C�]d�R�r��k�SN&���ZS�#Oϳ��:�۵���Ά�HC`dp��?g,}NLTLmpQC���*d\���k�2���*�[�/��DlWZ(THʰ��U�%i_�B��_�BO�C��ǩNY�B�w&v{��7E�+d��C�]$�|�E�=e\^�=}؄܈o�:|���"?��Ď��y�n�>"r�S	���H�����:��+�����d�SU�sbx]'+s�"+�����ӝq ]��8��C���Q4�F���J�ꗝ�;BJ�����K=42īc�o���4�'�:hT�C?�ML?�R�n�i�IT"38WQn��n5���cn���E.qj|�m�>*���__������ϟ����]g���S#�l�&�6߁���E~�QK�6a�BƑ#�JJXC�Xm��񉹲#rq��n�������    ���+�b��T%ɭ��j����ԩ]�I�>�T�\HR�u��'����T�\pFD�o̊�t^�o��.)*ߜ�	��X�E1�����E+���V�9�1+]+�q�i�L�
��
����W� "*�1�r�2��c���vr$Lܶ+3�T��P�zv��N����(�'��^�� 	i��2IXG��B�	i��fJXW�c�}t:=s:7;=p)Y�x5�?��&�spEӤE%�F�a1�Q�<+��	����y�.����Yt<�	G�SW.�P/P��O�eM.��Z���3���Y�019�}]>��/A�YH���+��Կa01㳜~P�U�^Z��]����Ȗ��ȹ(=Z\^k�AwQ�t�� �nb�������Ƒ�j��R^��\�]\:�|b��N�-�kg���3�k2�{����~�.�v��fS?9N�����(�������X����n�^�ҏg�����d�̕PFR��O�Q��)��>#�e�3:��J�9y>��,s��}�&Q�I=��q�)!un�1�V�d�ˌ���ni��lM���Ƹ�U/Ǐ�������{����c
�c����J*#��{+�.�ލ���Q�&n&C��-e=Љ�J�$���ΫF����k��x�b0���ycq5]�����|��K�����7	�����/�=vp�&�*�r.���1��G�6[��Z�֕W����Q��w�����^��&\fbGU1�=
3��h^�_�-�h����/�y�8��!�$�*�/r(��9	:���X�p�C�X�������d������6f�K��G����Ǚ{��E�z	����I���)׾F�\�:���#!?�)�c�η�߶�������#1�����f\7��T�~	���*b�A�)Cώ05fH���a��?g,��.�1+����E��<F]LL��P.��L��pQy�U��BKm�],�L������u��?g*�K.�5;ѯ@��~ʅ�[��51UǱAFcR*z���l�\Jc?a\����41�zó�(�P���S�)b�ǹ���s�dÓ\^�֫������>:q@���/1�7f㆑x��^.�y}�,���ڰ%}��VQ�����"������˘(G-DT��d�X��]X��g`��En�F��n���EC �X�|�>*u�~�T�T}������G���J,Z����0�R��v)0|~����A��9g�h����m��#�x�I�O�D���!�N��(�0���|���h��N_���V,���5��"oQ���(���+�7ڝ2jCiO�{��I��·��-�4��Aب��E��4���-��k�-v���A���0��u0���.r� �B��j;7�\q	#r�w��6�Qa\f��~�#����D����iLv����2�S�ȕ��01����9�O�%{�+� ob$ә�2`�r��r���ż�ob}��Dl��]�DI*\xB�ߋo֖Ϙq�U��ly�%��I�l���W�(kH�F�K�>�e*�d����Ә��;�\lK�E.�w��$%�z$ľ����3��=֠�&�0=	+-:��z��v,k�H�kmL6c�GL��;Y~+L{�""�}[\��z5��|2�2�����:���>E���*��M�J�G�7����1q&֑� c.�W�(�Ief��>fITb�&\�Y�ȸ�M��ra���ʍq���u�������b�L/rQ��D+����)��U(.��<asz�z�]$�7{����_�|+��u���c�[L��Jנ��	ݏ��b�+���W��Vmb1�k���ݾf��WTw61��>��)Ʉ�˔��7�]N������m�c��U��䪝ML�'��c'����^P
���Ce�'N����Cl��պ��bb0+����I���&jSR��5��XW$\�nXH1s�#!�JM=�4���;����wXn�g�(DR�V(P �T�)b�B�Bx]T�6S�um%� h�q����������ҝ�R>!rFvhl��W�Z,�k�^]z@Pڍ#����1Cs��v&g��X��z6$2�wԼ(et�JCgO�.�;����^�-`�F�Ȧr�b��&���D�7�G��&�Wor.��6��9e������˭�O��%��(HT��m"zI?��ٻ�Ga�����j#�|y������I{��>"��΄�G�ML΄hp�u�����pV~�)Ҙ��ڄZa_�#v3o�;.i11]�pY�0�Z]�c�t�u2���H@G��h�鐡�d���E��r�Y^�xk��jm2c^��%Å)�Dc
�V�t��-���;��{W�lƕ���D�������!/m���n�;��Ƨj1w؎�S�厑��r��ץX c� �ql,-�_��˻��w|fU&��HaО�pf]$�x��S�)}y	��}9�vw�6�t����0���;��bbjBR���WQљ1N�a��ĄEt��M���a����.���!,
�Ř��ۭke���A5�Ƹ�"�L��T�-��i�w.�u�Fy1^�&��#!��cEo�������밓�U�%���;�.L�0�)C�v��ḛSv�!�]��bH�K�.���^��XL����:l	|(o��Y�e��!�1���g#�,�.�.6���1 �	��&�{
�3�z���vs�Eꝉ��sj��G��9�k�u��q�ݢ�<	���]��%����c��t�5l�I�Ó�p=��(`�����LVӅ1,�T�8�7�]��W�s:���6�.�:Bg'���o�Bw�%��g�U�6�"e\HK=�;��ҙ;&�U���X�tW�ۄ���]tzu���������K8�w\uP���Ձ�0+q�r(r�ߕ��wm̆�l3�A�>�^����A���Ì�ML2:��:�G)�@WhYz{�e�����s���@ߒP��llt=�ƹH�n��+�n{����IL�L\���n$��7y���(��_��rtÌE/��::���`b����\��׵�n���߾|���?�j��Zpۼ�7[V<1�6�yt0�˄�w���ߎG��)�;�[���A6ẚr5������-�+s�%������A�ŔvB��,��>��S��5v�%��8�<����|�L������ov{o�~����;���osxQ��A��W�����^����M�*
s�?�����Z���L<@�2�L:{)Eb�?�����?�?�LL�l1Q.��6�@��E�P./n(FL.9i���T��sQ��Ҩ��0=�s����"d�Lǋ^	��������hb=1O>��gl��?����Wb���>��"�JU�٠6��"~�����h�E�1��'a�El-��z�>�|���81=�>9�!;���,&�|ÞTf��g ��GEN��T���>*}�J�Փq�D�B�x& ]��'�L�l�r��s�Ʈf*bϷ��ϟ�iW�l����)�	l���v+Z
kph������	���*	j�##H�@�*++P�����������/~�v%4bI��F��ё%�.�����=	4�R��E%�}��Ŏ�5��P�Ș�5@����4v=���j >�e�S\�7(Q��sS%LDj�'���������ECaX||�z#=�,�ۗ��+9���R��XY�UOQTX5k�׎$����&k��ҋ� ?R#���x�q��ȸ��dcs]^��1u. >��Ϙ�|��wN���8骖<a�Q�
&��-桎��./d$L����fHwu8j�0r֙������.cu�~����]�'y�.Lxbz��6��G�o)��w$��6�T���N������de+L�de9��>V2�VΗ�&�>�>�3�0�^�z�����R�V��N��w{ƐZ	c�'�y�dD���R��+ �bi�R�U��8|2	��ѽ�&V�O���Em�N�:�u ���%v�G�ە�71�P<B��T^�h�a���R���:L�{(G�Y!"Ƽ���2.-E�9t���sN� C  Zԙq����NZu21��øȥ���w�����jE���W$+�B�H2.w*��22!GF����9(�田M:�E:����i�c�[��XP���I�V kGF:XOk�k�;f)7_�{-���p{������bc�K~P&��")�	�5ѣ�������a�H"�66�!7�;0��t}}+ƫ�[1セE�
��n�jb���Y�e{�b�]��P,fdH c�Y�|ꎩ�29U����ƅ�6:q�!�֢qeo0l&ib���p. �i��X��Jˎ8�Z�oGq�=a�X�p&��K�M\���Ah"����������V�aL�k7�$2�b��f�S'y�+
 ���\�cT�(���_	��&%�
ũ��騅��jbM����A����n-�jK�*�$g;��ƢM�W��iPsr2��#s�W�1�:�R��Ē�db-�*�G5tdlt5����l�˅�;�'c�&��AW�6Mi�
R�S$2=w�&:�u�`��#�C�Y��볆�|�S�z���j����	��睊���.�.W{�01���}��]4m"r����L./�%\�tɎYv%{(ʾ�����(����������<-W|Z�#s�M$�0zj�9�n�1�p�8`Wg'w,���s v��26��[`qL�^]��Жj�7T���f��ڃ���ج�c�d��Z�c O����dx�'����4F�4F�T�T�㩄)Q�c��t��&&#�4hh[�Lk�ӎ���U���F�|��4C��K��U�Y�ф�l1��m�^���/������w߾��dcD�#�I�F�tgb��s�gb��2&���s�&.�����[�➻�l�ؙXC�f��\m� ��Y%�){�lt�V�m�0<GA^�����	V�嬏6�K���r��n��k��!�[/�������,�N-3�?�� ��~��NF.^^�NGz���;�H�n%�R�@�~|���b5��ʗD��`�_f=�ǐ-���YY����C��Cd�Z~6n�?��x3^���Ǯ�3�64��W 9��r��v]!6f	ǢЛX�f��{���������qK���.C�?P� \�R��d��ba�����0��]pӋGI�6"r� ��wz~;-�k�os>b~���jbz~�q�g�+�eרq͆]ʠ� �1~*Et����BV���9��o@M灋(�x�:��.� \��/�Ta�5Lx`j�֊��|a���.�ŻX��Ȗ�����Ӝ�������.��σڠ��b^��Ʊ�jb�Wz�D��rNS���lbl
�H�Ae�xK\w�g'/�D��rq�2;��ι�QN0ٳ�Av�޸�N�wㄵ;YqW���[Ű�
��0B�1��|�H�wx�.��m��oE�:�j1�!b�Tl��6St�yTR�ֻc�@�gr��O��mu�P�!g��N+�nu򦅹�A�eJ���x¥���<$�������������^Nǳ�"|]`W~	�s��.�8(.�� 6{`���|�*X���WB8��U�_%b7�_�ʤRf=�!S�X�������s�FO�0.�S\�\^�=a�M���#�����ML�#R28<(S.�/��i9�
`_�DD͹Ԩ�*�6*Hǲ3�S~��`3E>��e�v3Ga��[X�!�+_q�t1 %3�R$����1�PN
FC̀1rs��H\V��p��4�'-v�G�ȍ����b�m�M��d�<�E;s��T|����=V�Z�a���
Fd���Cܖ��_e��Ҋ�5�z���7�����{�A֚Y'�^�Ɠ�t�+rX����|¶W�o�u���J1ϫ<�[�yv",0�����֫ :Q�|}m�90�i d���+BMdZ$��ъ�xo�O�¹�3�)Y�L�S�"p�_qV��1MC_�"�()UFI_���M��2U��ɥs�w�Nn��K<���CRvȳK;֐I�p�x�f��ML�$Ը�-	��E�/,Ã���eÒZ��뷗����&6r���żηq�������~�㫍½J�ӌ3������G��V�7Mld�r����4q�͂��c�7��7�;riNl���8�\.K�1��=r $W6�$FD��T����].�� s�C�
҇|�́�r�s��q�u�C^ ���NX�͡B��� ����~<��8c��B��Cp7�GHg�����y�>�M4����e����4�yq�&��Xz���Q�Ԍ�\��\�����\��c�S�g	%yhe"K*\��,cr+!;y��e���ee&n�����'�M�jY|`��
�fu����J�Fb>P�4� m�z�����<h
��D֋V��n��˽����<���>EC���mG����Gf�x��X��z{��~0�m:5<���\�`O{QL�ٯh����^���b���f�K�6�>(h��31U��x:M�\�kI���UKz`���Ӯ��&�),�}�!ܽ:_�0��3df��X�Zԕ�p8�'�O9ܥ׎�Ut�K�c�ry>���n�|
N��ݥ�ㄩSp:�Ʈ��=�<�+`3�SZ<�m7�c&F���n�o���Y����t���h���e���QY�Q{.�^��x���7��j3�Q-�����v11�)����3�Ķ�\c�ƜdX���QH�U��,C�KTt����p����S3����#�-v���5Ҏ��GmW��5�*�C�Ux�	�غ{(�[�=+.3�oE°�o�!bW2���6}��v&&��r�L:Q��ʰ^�N������*��]���cn�w`j{$I��v٬��V�ܻbV��^��Y�y�1^'ʝ0�/�A_���v�b��ߺ��F��}{��� ���,���i�T�#b��{x�.�� ��D�	��am��6SX���"#ML�4�;�v��]υ/L����脩~�䞻`�ey���)�������=����1#'��ca�
�x>G��GGobM���PJ�j����'fu�
���N�.8ܸp�%�u����s0ġ���k}���G�ƾ~����'Ж��o��l���2����	�vG2���&v�6����E���K>?����]��񠾾~ߎ�^~{y���s����͛7��b��      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܹ�Zn#g�:~�~E<S}�3c�w�F�{f���#,rI["���T�A�
���P<Թ��j֞+*�U��!��'�緯����g�W���tn��-jܽ4:֓>�7Ұv3Ϸ���?a����S6�A�ł��%��ad'ڌa�t��t|�F/�?�Ν�ϲ��iDCcd�`��60:��a 5����I�<�QXJ�V���L>��4q�få�p�!F�>>G;gNO�K�ޫ��Pv�+�vt�:'a��P93N-��/q��2��Lޏb�\7 z��z��%�����E�$��e�����~�I	!�A�+�5O6=���1A�另�q��),���=�-Hk<Sz(Hk�G�;�AG�Oa���nS;���6�U6�^9�/o�z����&��������̠k(l���i��\�{ҁ\�9�������-*l�'����S��{��3F�m�Z���BA�<�3���i �{����,��(9e4��@��L2;,���R�J��e#��Q�����:�>������soeew�;��^Ls�s�fuI��
�0�l���HW�)L~��o�R]jV����G	�Z2�M:�&\��6���}͑n��!�-+Uii(Cq�O���9�����`l���c`���CL>:޼����4�P��SWNȖ˲�,����3���c�s[���en���	�Au�R�_ʦ�x��_�v1�h|flA��{�N��i����{.q��$�a>{k�zq�l����pSmF����M037d�=����?>���M�i�-���0���/���e�̗g��&%>��m��Wg�ǿ� m૳`O��-��5O�Z"�M\�<2%I/��CA��+����d�+��zx�K��/�ɵY-l��o��]���'�P�%+�=is��eR��]2
�߈]ڙAX�@�R��)7z�0�ƽ���nAS̥v�ك�=KGf�L�9����ݍ�K[�Ncއ�!�)|�)���*[x�����K����c;�G�x�aJw@��>��W�q*�<��٪Yv��G<�ŴqY]�Ô��{����F��0�j?�Yk�y�IZ
=<ȭoĽ������vpۆ�P&OП�dT���Q���9-���,�	NS���0�M��N`�k���;�h34�z��~��ݐ�07B�J��#��x�3r��J��=�׶q$�X�̆]Or�hq�3:ɩ����k�zt�����]{XHk��P#
���>AE6�]h���oI��U�����l�������z1AG|�|�A��6e�aEd�Ф�|L��Oa�w�0��]��_ec�;�J��$.�\X�����p,��;��w`/)��hB��4w�v���ĩc��"�IJ|9���N�0����;p9�<�`3Q�����qF��u ��g}��"B�g��ϲZn1���o��l{ct���y9��^�����A:$Y�'I�C��|�`Z�����D�2������^
^DK��U�\\�sBp�
ʆZM���G�:���ُ��,���6W�ɊV��d}��	�o�@���؈����Q�F@��յ�VY7�>_dw�R{���m���b��D�Fcm��<l��3y�����mm�"��Q�>�NQ	�r1��T�M� �yӓ���1o�
s����4�Lȴb�.�{�ף�H|=���G��z�q=��)�j�y}��l �؃2���kܢ���:�f�0����@�p�	�rP6�g����:*ł�]p�>�E6ꂓ�!ϋa���z^J�B"J8�y���Ru2�Q8i �z�PT-��������rBN�`���$&߱���QA��� `�@��]q�l�*z���I�N��R_����<"}f�F�k�6���g 7(�$'1�E�z�+�l0�zV3����\�(5��}�� BHM`A��&�c��9�JN��G]G�lH%��˖>�"y�92�X*���ܻ��}#�{Va#���0���P'�	L�����C����)2���1����a�!��f.��]&6�&)�v��7PĹz�w��a]Q���G�YtA[�{������R_z�s�����gQ���y�=�Y���H��_����v�������f��M�H�&9���6�(3NդE6�eP)I�4� ���l64@�<�;�i(O#��_[c��C����}�>���o$��(-G�Y�9��YT\��&��,�1XyA�&?����NzWك���*[����I�	��W-q5j-�.��?����~����	���f�NW���9̲z(���^7���[9��<���ڔ�ܓ�r{�2�|���J�V�%�5��Bb�>�1�Ӻ�(ix��!�9"�pf��CĠRu��V���o?L�uP&�&1;�F	�=�m}��lH]�mR_a�z�>�� �A�����9L�i=94�6Jw��y�z|�&9�(=�![���Ά�:�����0-om���A��G���l���������������c`r�h�.K#�Ԟ�VW�!�G\���4��[�b���_J�^�C�#!�yR�����P�#�Tm�����]?��=���]R��m�fnh�j;��/ё���Α�j�%F�<�;�-�z����9L�kKm�8���U�.��4�Z�M�:C&{�(����$�@��9L��mW�5��<�B)({n���_/S��9��S����L��E�'��aZ�إ[���o�y9����غ*���]��ņulT���,�3]C�i���U��=d#���)3�Zʼ_�]q�<v����{0��	q�fO��~zwٓL�k7z�y�d�%8���Sh���"�ɍ�YN>��t��YO{�����Y)��G��:�(���R�5lR�r	�ճ�����lO�
N+�`��e{��s�f9=������|qi��Ky ����d>8�^�/��F���`�[f�,�C��2�4@ۅ.���Q���s�[f��v i��p��L>���4�!A0��ag�A�L�������D���2Y�
GIEy��~n���1Di���c��6�?91꓾�G@g�g��m�b��ۢ��36�$3��J�n�M�
��������o��[�^�"��=d���@M�~����C�o�l�>&�ԯI��}�VS٣�5ݩ�l���<������Ȁ��	6O'�Y벍�͒�Gӆ�hz��-�]6��������I2C��e���Y�<I�K>��^M�@5�:h������!PP)u��^H�Bj�NӜ]D\Ba�za:��x���i)���<2&�7w�T��
=�����+|K��ҡ�v�7���&�W�O.a����ާ|�e�Vy�L_��� �
©���v��=��J>���D����O+S��O�~E�xP�C��@�č�^H��A�YL'�����$E6;JPT��x�Lwhջ��H/�ZO.2a[$���S��B�#׳�l�A]�Kj��3Av�|����^��L9����bM��=ec����Ә�B�.��z�oࠫ��P�H��S���'���p�W�X�̆W����F�sk�2i�f��3�s�=��Ho�xE֟�|T喙�e�	r��%i:@58t��J�=G(�g�f%U^IK�10.�W�y5M���Y�'��h���g۬��#H�%��]
c�^�h�͌a�%�t�	�6W�9��.����nN��=T)�D�K^�I��i®͚�;����]}���h�i+'D��E�ɋ6�oP����O�p��w�Is����~��D�>ԑi��1(�o��S�:�CB���	g������_�e�2����ѧc�y�w�20����	4��$�gEo�~���ҥȾ�ҏ��f>�d?�c
�,Zk v  ��h������u@1ɷ_�����e4l�G��d��&W�"�s<��F��ݺ��2���q���S9m�C8�M|���m�J/�]> طߘ,E�s����L�j,��Mq�G�����r���I�6�QvJ���M�~ʤ}65�$i����.�;<�#��[���	��$���t/��:��:� ���)6Z�(��w?ƈ�*[�C��ș�{�<j�IC*�H]��N��`�+'�u�4Xe�`�Ƈ.�g���a?C;]C]�us&(�5o�we6ʘ�fu7w��I��^�;�^�e(���1�@~6�8lQI����D�N�^�9�)<�,F�$p4{�f|ֺ�.��1uX\箄t�RJ�U��G7������I�S{�\G�F��p�m|H�U�,��枌�	懳�פˍ���b@���Hc�w_��}|�~ʔ�Q?�����o_��v��{||I�Z6���?;p�#-��x�O2��z���u���J���<�P�yq����v�z[���硆~q:�H�R��{��s���;���FD�;��d�;����no�*N/n_�@�&:@ٳ�;{(�n�������6����?��Spk'��ys#M]o�"������9@�t�ZNkؙ
�<�1��SP&mm�&�h1׸���"�g3�\��e�1�^��a�g��(��Rn�4?d��fz�ͶB7V��<E����TEwv��):�����~�%��'�U���҉��g<�.)C'��ڪ�+)m�r�(Tǔ��x�D��OC���%�f1UNo$��FH����@꧲�-]�C�(ݽqݐ��܉��Ei��[��|C>��<����6=�O_��]��u��ՔIM�]��J���
���N\:�iT�C���ފw��=��W^	_>���O��˟9WsE����l5P6]A�nU]�f-�΂��^��b5U7�G�ϴk��Ϸ�y�劧�e%ē���C/BE[���m٧���� ���*(�gx\kۣe�Rta�!*͂�T\`�t1�T�ǀ�]���U�o����J~aK
%9���P�78���;xj5�ȸe|Hgy[�R�LνЗ��'���a�2��G�ْ�G� egr�(ӟ�P&����.��z����iӫ�Cqխ��Me}��h�0o�G�V	�U�f���EW>�S�r����`�+Ӑϊ|:a1&�vС��1G���">R{��kk�2:v'��ڲ�Tn�����к�e�U¨P�������У����o߯t���et����S�Ge�|x�t3/!h�ݏ�O������0�B�N�I::+7y*�B��1P�����W1��Q"sIC�>�L�R�w�j;����_?���1��Aw�$uЙ:\ �����H�m�*�t�*��娖����α*ee�=�����R�~m�G4�Zӝ�.���	��
\�k�c�>���d)]\l�Xi�+iZ��Q���G��&d��la���.��v�o�����8JA�4!�m��c}��@̕(��ǵ��������q"C�D�4@ӗ��L��1�SXX�[��s�̋мl�/���1i�l���#�2��4�tFX��R�U��`�;�bǤ��d:��-Vy��B�������-��o�/��ّe}k�G�f.=ɬ�y�����}�e�;�݆mB��7hگ[��+���NBs���P6P/άhp�M`�jRL/���LX���q�����m]��#*|Uu�k�)J��P6P�j�q�]	�������.��W�!O���@�F��y�zQ�����J[�x�(�|���|\v��h�S��)Hf��Pvs
���PQL2���g�Ҵ�⤡r0C{Ҋ��cѨ��I�A'T��K�<�i��������5�B�&G(4uM�Ò��-��pC.��0�(][�:�x�d3k�3
.�B��غB�'��h]��(;�u���;u�p��b�(��X����E����j�렬�6�}R���<�!Md�����]z]_u�C6�&��ك6���Ju��|�����Y�Gp�ʄ����=��[��M��I&�U�bⱯM[�tM�;�Ɩ�( w�K6�S8�5sKu�.�PW��\7q�����?�˄�Ѧm��g�k�p��I|l�l�B(����1��1�l�,�����m3��n_�g�j���篸����#�2֏�nM���9���[2A�'���3��sUd7���,i,N���v�sN��x�y5��`��4�2I�Eu\�ݷY�\��LH��t�1SY��d�H}��Sv�⮥FI��]K���G��Ӿhy��m6�6���>s$����G���WS�3WW�!����c)�ۈ����7��q�l�����ƼŔ^�=���搅O�P�C-|�Q���܆�X�[�,�_�(�������Sl᳘?�¿e����[�;���A��y7�0�͢��u���.�[1�Թ"Yȫ�j�q7�v��M�t��N�������[r��[Sl16vb2�Nf�U[�r��%��$�$&���l����Ԣ����Z�a�f�I�1r�)(cþ{���ђ�e�=��l6@O��{���I&uҵ�Y'#�-Ert�ʩ�v�v������@n�h���[u����P&�Yg�E�a�
�1Ȼ��Jח��n�T�ݜE6x�K�5��4���?���.w�I6�8�æR�Ť#+ 2�,N|CމϢE��y�O��N�%T������25M��B�W;�?��H�ә��s��}���Y-���Y�>b������μ>R:��C,ʞ�>ґ�YTHe�vgh+���S�ʤ1R�b����(=���n�s�>���o|��۷+��a՝�(��:S]F�L�x�j��R�6]�jYӷ�͊�Y׎���O�ˤ];�$�K�&�(_Si>۾
���j�l�oKjW긷�쉔k�*�Ғ�mO���Jm~�Yr�l�q�2+ܱ�� e(���эk
�m���!�@ك�9[{:
��YW[����+Vtqr�;g��lQɊ�G֠����z��O|��ݭc�X�<��f�����5�5dr����G-���Pآ����;�E����+~��j�s%�����W�6���23@Y/��Esf�V{�tͧ�z�jd�Y(���e��lc�C-g�����s��l�L��n�՝+�춸��ؿ+� ^��e?p���^6o�n|fAta�,!�Ђx�D({hAܓ���6�jH5����d���־�X�.�,F�mDX�̈^nrfu}��@A$ZPK׷�6��e;m\�<7u
�z�h����Q��M��)�9Pe3
.�^8���5���9����l(Unh#�-�΢����Ԡ�l��*a���b�#K[πb�#�*�"4�b˃=Sl�1;�ɴ�����=�Fwᗳ��:�][����2�,��P&MÜ��+�n��Pd�x8f*Qb�3B0�߯��]�``��s`l�WL��b���n�=Q(��[d={��r�a�rhIY����\�N �Am��gw��E"md���X-f��2I����F��MN��2a�)Ki�tذ�/w�,��v)<Ʉ3���)�[b�+��Ny�@NC��)g���� K4�ȕcnr����#�6���B��l�Α�	��r��9wxT.��]=L�$���(k���]t�l4���Z]���w٨�>�+�3!����[M2q�^�"멸X�-�}���1h��ݎ�m�g�������O�>��n�������9��sX��%$�����8�x7h�%�j��Y�e]�c�5�R
=�Ս���[�a]g�ow��O#�u���dz[TP��U�Q2����|���H^3gN��׷?ӆ�����˗�"�t��5�ﰛ�� ��el�I6�#S��H��t���(*tB���L#})�=Ɇ
Z��&[E-^){�ЙT��k��I6V��U�wLQ��[~�����_B      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
�����v캑,�������[ʙ���N)Ɇ<����t��z��F�w&OV{`�Qb��u�`\���y{YV� l96�y���v8�w�`���*#�]3�~gG�����?a1�s�㏏X�S�v�����X���2�D'-��e]r�
ME3�F�=��p�]Q��X�}nɚ�*����E�y��0��y��ں���0v�@�nc9=Uyc�ǈ��k��O�`�7��Q1zD$l��X��ro�,��C1@��j��j
jB��;1~�H�����u����·���Q髸 ���dIht�'iEX��:��=��6��L���S�G#�[����|�%AA2;�%*q/Y�←�fqm9�OXx�Cy7�V7Ⓐ�pa)�E�0�):�Y�}�F���[�̠3�$~��84z��A ��6%۶)9P.I��ČH̄$�:���»?�K
�3Ҩ��00�l�m������w��{	Ms�+�&h��%��}�����AⰓ�aաg�#m�IX����T����	+�z�X�8{-��*:`哀��(������OlHV�������Òl��JPֿH7>�<�����
��;��
(�b��mK$=q��2��*d�� �y�%q�b<kZȼ�HW����{�vL۶c��e�r5i�&m�i�q#�7�?�� �u�"טg��m۽OH6��r���.�0U���ɇ�?��nq��Ey�p^�>XP��3�s���ǲ�F���S��菼	]�ɬ��EU�@���XD�]oٕrc���WG�]�N/9�n��hE$.Х����qU��gT��_x��(��ma[����Q7�@i�������V�8#��L	esf��fTC��W���3����!9rə{(4�^��;�MI�|�]��.��O��������v�۶;=|v���B/��HⲻNqhD7א��-1�͂�tگ�s"�k��Ow�H�	�Xo�֜�wb0�\ȭ�,ܕ�M��$q��ݽ�ջ,���$�^s�ĉΚh}Ւ���B���mqV�d�$�y4�}X��qp�ЅLg1�<)�"�]uX�����a�ߐ�����%���矊�q^�g� �X�"1;����� �A�ת
;�^�Ӻq^���Ccp��!���m��>p��(f���Ųp"s�������eqsW�@8 �p��N�A_^�����NvY�8cyX�x0*�h���/':�v�Z,j�e*�m�ˏϭ���F������A�w��	�	�0=W~,�l�K��,t_�>|���a�E��f
?4M�E����E\��^~e��',H�r�$ٗ׭˪boZ�پЛL���u	�E�2��p�I'��ۼ�j�,1�Je�~?��αh}� C����/;��X\Q��`�]���E��8e��8#���qx%�}{㔤��:br�ݾ��γ-i.�a�$�H>/�ϕ�
����iL���寰,eMVα�;�iM�8k�㢧�>��=|�n%����9�&�pJo�    p�9(�V'�@����օ�ˠ(����yI86��mV��2.K@�P�������[�N*=N7l�Ŭ<���d���l�M���UԢ�x�\�8/˛�2�Mm�JERJ�|媜�~Ufe��T-WE>�*���t4,�Q��O��c^�Y$��CF��#�>�%��d�n��,$=H���3 �w9��J��޲�#��GZ��9G����*�z}d[B�{��n(Q���;�/��H����+M���E\.�π9�FjZ��R�ٵ��\�%A��ή".Y��߀��8��p1�@$�������.KE��iͦ��*�Hn�=K�3�c�G�YZ����%K���f�$�3�Gj���/z:���$Ys��&��k���H���p0�}�h
�<ró�T�������X��Tm��rp�,�ѣ.���X��w�uy������-f=X���I��䤊QۼFv�i^M��RY�+�Q�$�PV5�%j������*���XJ�����4Fnű���y��'%D �!�g�79=ܭ�}�Y��G7Sq@�\V,�<CBc\��B\��Й� �8�a�2�^([��;�TfI��2�~:Ab̡@Y���l'�30`��cYD\�R0XT��kr���cȅ���������Pl,l�����$qs{����LX��=z숅=������RY�3Xl��t� A6�Rx���; ��{�g|I*u�Ӫq�}]��,Q�H����θʾ����X��m�3(��Ԁw��¬�a48*WiC���%M��Dr�],t�-���>�yAC�x��r�x:D�T�߳}wΊaU��Je`_��4hhUk�y�}���/^OX��m���.���?`q�((�� �,'���s�(K�Vx�X�G��aQH��k�Mg��e��LnJ��8y�W�����!�Ua-��,>`~� �	,����2�Dg6 ��RKq�@�l����������ݣC{gU4�A����'���
��N�&#Y���#c^��&.��X�{�u߀`�v�a8k%Jo�ơ8����sK�:Wh+Ѽ��/v�_�f�Z4�}F'ь� D�x�D���ƀE�Fc=;x0�ƜE���x�Š�'F�x�����Tu�D��x41���uv�a�SG�-B|i=�*����~��Hp�����������j�,�YҬ)`�&�����W>�
Th,-��޲�����^��������%���ݘ*~��N�D��ܱ%}a�׹1 �3(�Ӡ�E�TR<t�7�&?|Y:1��Z�\��8k>k�m��6�<�\ZCa<�*.�������ZY��~,e��%��N]3�4���cK�����^��4h/��/����4�$�,���{��^v�5�g1��7ɀ[0�~zk�-��$qY�O_/o���
G� /&�5c[��V�s*��VD~6�Q����"C�h��XxИ�	q��'��B���ɯm�@Bc��\�⼿{�g2d	L*����:fMR4-�5j�.v�o�hP�Ƶy�h/��R����I�l���Ҩ�t_��儜�\��7���p����ǀL���5 �y3,��R�uͲ)=�L+�Ò���g�
3����&����I��M2aY���miM;���"��RW�����ΛH�4����M�~�~�w�Vۻv͇Ͳ�"�6r�0h����������B�?�ǘ²���I�0Λ̔��,l6t}�6���� �18�Q��[/כ��Yo<0P,��\�7���<_l��aX�=�z,��32��˒�˯_�����<ͼp;ʲ�*��̫���je��Gq�쥐;6f��6��a�}����F�1Nh�����Ҫ=�*8��z�OD"�P�)���bu�w�@핽�P�(9?����׻�3$1��=�0lg��7f��-.���pGq���	��d�
Ĩ�y�^��R��U���+�_��hğ��R�A�N�va0*�l��fK�l�I�l{'q��3[�V���K+O3$;�ۅ�C��k�0]:�����$���	�y� ^Y���5��	�vؒl�ID	Hӌ����ˢ<�ܲI�F�X���S�,ls����ˍ��Z�VV_PMF��k�im��Bb/$ea�|M>��M�J�	)=��$qɍ}d��^4����_��L*N�
&�ɸ��h ��z�]I��]�U^c`��e񪷏�~�d��g�-�˅�te�$���n/�.�ߑŇ@���qvҫ!k��xYT��oZ���;;$<����P�?r#*�~�5�����Xz�O2�IH�VE��d�Tj��E�d)�����c\l%��>��`+���6�՚�4=ǋ�����籀�=f��}1�E��΅ћ��I=�rc~.�-V�%��{Ò�f(8���:����C�M,g��~���e�+�E�4�IMT!P �N��rp�6َ�L	��O�izҕ"�aq��X���t#ζ�xٹ0�7��9�-��㸟�+�,�P���cM`;ۼ��4 ��ת��,����A���v�z�9bH��C���X%(�~M9�"N�kA��qP.�D���1l8?��!���:`j���qQ��|\Ţ�a�CR��� x�|$9� ׬f�$���ݭ��~��u�����
CƑ�L�at)���:bj����@I�'C{�TK�F"������0�*����AY��qL|_�yUN�`���3��/֢�`Q�sX�uO3�<9W2��+y{��W,qU�\=vH����7{��E����Hqɳ�"�X�������k��}(o��`��Z�{,�b>~�/L	���(�ʨ��7w�<?R�p���N#�#ƶPz@�����K�ӛK�2¼@I\s�O�|���Ժ#m>�Yk	��4{�d;,���V�o����-~`�3��F.�3@�K�!� ���7agK�J+0�:ϸ{#��{#�W4�bY��,�\N��".�,m�h�\`y������o[���������93��yYn���DҠL#�k�Hء�^�i��ī��/��K���U���[�`X�l��R��"<����^���Է:�b��ZG�qig"%��/�<�����ԃͼ�"��j��d�fZ3Xl3o��>Z�ϬyA,GO(�h�g#J�'������HNMGӺq��G�	��X��g���p����Fjق���O�W��������oh�����z��N\�eU��u����@{����Ji@���9(������~��k��^�q@#{$U��sZ/��FGO�2,l��7�q��h�@�#�A�t�e��~��n�e�}��[��!T�i�_��a�J�g*�vYU|+�d����P[݊[0�Pp��7���l��7��o���w:���4ra�bE\o[rK�-@�1��I�h%�Do{GLnvTtXx+���з׊��w�gPT8��+������Z$n�v���T%��'�����<�z��kV\/�g��AI9M8�4
�@XM�����5\d:����& P�b�7�1��1	�Ј@XS_�3��N�F�T'O̡~y7�8Ь8#�����k>�h����8�����u�QA��4;�u�*Z�`F��y���Fr��(`��B��ZI�4���PCE</V��EP��b�Q��jV��\~a�v�'�U�I�󂛌-}�a�d��~����M����ծf�y�}��i���_��xl���Eaw�vX�)�.��y����G}���J�B	�PJ�e (lP\�\������dW�;K*H����;���9Rq�aE��vχ�8���t�wZ��
5��(���|�<�Ȃ��l)�v��62�a��Fr��2��KKꤘ�Ȧ"�
.��Q"��>TJz���m�7-�)�$A͊˪���S�ˇ�W����`8W?ԡ�����b��}�������`��x�tx�p�� %��Z(8BL�0������
<�n�i���b@��c��,~ؚz���,ySʋ`����Lr���Q����M>�n�I-�����=��9�����ea�y�?ƈ'��WA�K77���F/4��]Hq�p��e�    >�R�w.W�LQ_Z���E5d��A���(z��p�?����-f��Mz�Q�c#�t�qњ����4�^�Fkih��9�Z�[Ve'^O�Guy�պ���yU>d(�
�ݥ��`1c�6�y1 ;e�͹{ c�Mi��eU:2u�T�P�(JV��Z��/!�iH�k���'$�pm� �և�A�#M�° �0,���]�uN�V�#��xT�$�Ho��x��O[*��8�SR�mr���b78���b�c���-V��[�t[��?\��^�ŌP����lYT!��6>��fp�������n�!��*�Z�؅!(8�58�%i�D"[O�(a#�߼��J���ਫ਼g�}��YGo.�kߒn���UZ+����⒞�:ʘ-���-G��w�# � 9�\�"�>ua�~�esJ�y>�)�6�w����EՂ�c&m>;0���s�U�e}e�����ۛ�������2M�v�un�U;�vɌhk���>��`-Zv�N���/� �۞ga-��LGs���v,;
��Sf��v�ص�����O�/{����G��%dXS��ة���`�W '��p��:�oW�?A��8/�pf��i��[��.[�g��Zq9��Ytv��Mw|l�H�zX��֝�"�a�VjN�q�e���>}�{<��%��ډ/�]�6���~�����%!AR+Ֆ�p�A���F��J5^[*�ڲX�MM���хu [,�����|���x��͔f@������_��h����qF���3�B�����T9�����Ne�;�)��b�|�Q��n͊3�G�
��4����l�N���r��e�}]ʎ��'=)���\��GG�\��Ҁ��1�'�>�5]����t4J���yAN�����AK���j<��v��E�h5�ս��b_o(w�i<1uxk�����D
л�Nl�/~��^��;`�yw�����>��qZ�s���b���aYv�+�K�in��b���$q���<7"T(
{[!���$[$T����W$���S��!�͘��Do҉��	k�Uo�jߚ����J����J���}�%р�hޢ9q�9Qv�]����"ДU5+}���_�� KC@Q�ճn����U�_^I/(�{`��Tq5�k4i��1�B��Y-1C�"���*t�_�ce����*Λ������eQ�T����;�`�C�2Yph�&��M���`z?:�
��T�@�����p��|�Lz_�E[c����%���R~vm��6��K�W1��4p�~�^\��_o�?Ҕ�<- �JǚJՙJa�{���b���
�	�.�$�{���1���0�s�m���٬7t��3I���Vb��
ۄt��k���L���4�eR绤�A�?"�q͇�������	�L�k�`����ʆ_�0p����b���V*�b����}ؚ�cYx0�8,�ir�|�L�m����Ya��a}}=����U{,�8�ҧ�~Y|YJ!3�(+��$j\p�*�7�{oL�� ���R�a�e���8ߖH��x��91��sbp>U�7i�������}�Bn5��h�4���^r�������4k�&X�1��tN*�
(K7��Uq�W��0����C8��+�!{��
�3�������ʛߑ������_��D}qT'�:(l'8e�z�)2އ���KO`X{o� f;���÷[m/.^�sX�p�"��N��s¬��P����
�,�b�ut����߯�.�c�(y�0�`��`�|E�Nѵ8�0\2�+�mZ��`P�QNi<�ٹ���~=vXS����P^����[+�����ݻ%��o�%U���(��.ئw%��Mq것igq^�g��8%�U>В�N��b}��8��ʐRw-D<��|���<�@�DPie�,���`��.����:'�c�C8����~�`U�R ɩ��.��G�6V�1�m0q��yj9d���@��n%qM��P�'q��S�R�G��-����X��|t��>���"'�IE���-�A�����rG���㕄��$��X_�80�W㐙\��k߭����`�H܈�1HD8k9��0�6�:^n/VX0>��C�]���5��+�����IO�U���1����xЈ������׿�����o�/T�8ߣG���9�k�k�`4�F���VҭĤ��i�w��;k)v�9ok��O/����2*���'q��:�E�7�5�d��[ +*��\g��8`�.N/�Ɩ�F���Ԙ>J핒��;�W�ŕcS���r_p|��4W_D�C)+��lfȾ��a-K%���f�����q���"�Ŀ�U�+�L�c�ފ(�������K�7}�i<�N�9H3g4+�H��.`V�+�ʑ����+��Z��o=�5⼿���Q	�/�:��]S/�s��5��������		f���tt[P�Y��z�Be:��K����X.1�_E��o�����q���b`���Qr�:�O�L�0o�".���}
�F���h;Y$�)���6].T��G(M;n�R�y{�t�MMVX��uj3��x�ຘ+�ή�@Y��� �ǝ�q^��ˇ��e�ċb�"-����z�k6XN�sר�\&��q�ɖ/����'6_DP�����H�N��3-H�t-���E���V��������o���rU͘�1�r��Xs�e�,83�J,�]ziK�\���}�x�������-졣擮�C3��侇�ʀ��S�j\F0I\�\�$P�>���-�."�.,�N�f8���J�8���Ո�5���(�-f�$K�B����ה�SSa#.���Lr�bhF�F�@.��-���d!g�X��Efs��BR'R�iP��=@�.��8d{U�4X�ȡ	S�R�yw}Zqo@n=�y��HJ���!�)I��5�X`����o)⒝��0�^`��m`µ���b������!w̉�"�G�-3��|�@k���5�:�@���;����BB�0)o�aR�".��1�O�u�g���7� ���aw-��Tf��]j]9���s�������a��t��D;�$�C�d��;����Z�_�X�z�F��+��T��3��!?�uHN֤G2�j�7��uH ��?$ץFl������˟5�7�1&g��8o�g��Ap���bL#!�K�Y�
O%�l�=�Y3�$�������T"���ѽ�� �O����r����.z���rq�^w�U�٤�x�H�n������NI"�3ߋ�Z7k�g �||`f}V,ȷ}��$��B1�����i���}7����������C�> �5Bi�﹂o�����O[Ǝ
c��0bY�E��T9ш�&�ʛt�S��G��;���ilܺL�qz�h�κP�5n��K���p�{���a[�����ᘳK��\�N8���v>}2�\��%7��8�Z+%�E�UC.����$q�0�=�0&���(�$W�K��o)T��pE5�|�D���.߇+�8+�-G��>I�hJS 9�\%.�D7P�ܴ���<�~��h���?�[!Mp�a���ڈ�E�/p'�>�# z���ؿ��?F<E�W懏�y~��QG{A;
Z�Z6���w�ݻ��ok�(�jǔK#�k���'��W��1HEk���B��t*�K�bR�MҜ�W`�>l%Ρ��J�����b�,����H/�F��F\��9��yho=6uK���*,xQ�u&�2�}a���fY�8C��%.K$��}D)�L�q��A�Y�	�uQ9=Ӣq� �"��/�L�Ѕ�3�@L���a�(�K���&���T�DN@��,ɗG�SD\�,	��
:�Y�b�(�z(E�熁��eM��b�'.ܰ	�Wy6��T3���\T�_��LqɅ��7D���"��PXG���T�(�ºS0����+�E��~fMt��~bnZ 	T��h�i����>#?H�a��j�%��/:Ry�h*�3�/606aДk������bJy��R"A Z	  �2��;
X�i9QUFK��b�� %fUY�x��h6\E6�H޿]��u�!�:�/��A�~Q��?��3'1��瓸���uw��[ҿ��q��H����+�#����E��M�dw�=���$��+�bZ���ݫ"$��G�Rawp� ����e~��B=�bc���N<��+.��/w�s,F`�E�%,���f�"��d_.�N̓H\q�ryx���]�M �'�x�
ܝ$�6`p�ٵP^X�9CI��%+8�;�
���6��T�P���`X�J��
��`2�d�l^�5P�r��Ύ��	�{���|���'�P@D���
G;M����ڋ�kn�-B��4�f@R���b�����$޵�J%l�
ʴ��=Ԙ�ۇ�ɇ6��C:l��X=us/���Y�$~�Q�����oP�d��qNS�Te;�W�,�G��A8
4��3H�f�0�r�:'Z?=ʽ$n�3�R��xWqq��0@fk�!��xxq��pЭHWY�^����j#.��I�'�]���v>t+�[���E��<�5V\\��0���ͳ�.Ϫ�t�ףű��^��8|����N8���p�~��=[I!�h��n��t�@��ô����G�|]1�d�D1����M/����f��zSʲi�ܫ-'�R�y]��ܒs�D�& �x`���#)z�"`��S5�p���v��7��M@��#ݴx|9��2��;ȕ���z��F�F�Y.
V�^D���i�)�(��a��4��Y���}�ITX<l�p�^B��2L��^��Mk��Q���Y]��O1.S!��dWY
��md�`=�I?>Y��8�����zA�^�����X�4.r�#����w�\��»np��#�L_`K�d[�.K�,���|�Z@ωt�K5���b�*}�n쎒D�
���Z0H̺��f�/�*�\�qVY#��B��C!��xza��;��c���w-q#�$��.���X��<�o�P�F\o����|2�*����r��nY^��R7l�*^�\��q�G0��7㮗��4��e���ղdΝ#8%<�{��<"��u�;���r,�9��<Z�a�W#.���_y�3�`�g�H��r����'��v�QcW���S�{U}4����e��fZ�	K�P#��e�X�ℶx���(A��y�U�u��֙,�-��y]�~���%��`��\�O��8��u(A�h��L��`�LEzkC��g01;Â>�a�Q�v�l�0��f8ـaa�@��q>��ܼ��p��u�4䎱��zci�&��~�:��#�i�q�ʻ�e	'�$�L��R`Y�?A٪o�ϔ�5��.��EP$��Q[pQ�zP��-�!�����.o?�����wo�<�K��D��w�5-=Ǽ�t�q�e������!�M;�d��a@˲YHIg&��Vә�w��3��w���>��Q�=��z���]	e�����8)K����-o+P�>�;��-�<�Bq�f�� Y�=�2�Ig$7_�,�.<gA�d�c�����j����M|��q\�y{=�}��2�i�8��k}��E��˞��/f�OE�<�7~%�~YvG��FQ��鴑p�%��H\\���|�A���� (��c�&��]16s/��_3��2�Z0&R5��o�SDɨ��[<uh�F���ô�e��gE�:7��1��b�$;��o��m���a��XM�8.�WznFe�p\�@6���?�k�%9��ny-�C�C*M�؋�:(q�m/�>#mK��Xڈ�Q����#�J`�v��*�?�]���8��:�0v�ߢ:��E?m3Ư5�+����m)�����#�⤩E_��b��n�G�2���eq�}�U����~q�������K��cGX�9.��N��#�y�5u:��-.�b!�~di�eeC�x�q�$���>z��bJc�"V1X�
��/������2������ Ğ�0yYU8��W��4��>�-U��^�pF�t�~��؏V�Y���=r:���I!�N��ha�P�����~�E-R{)�'�x�qq4�TZ��sS}"�l���=>I��̲$1~������-0�tT1V��ˁl��=�yM��h�6�b����X�R�l��4��b徃_���I�YtG܈��=��?P�4��	۵&Ͱ&r�8������D��(�0�=��aؠ��ئUi:��chVz�Ǟ���^?K�2yH�D�^
��o������`q�:��QҊaA���czg, 03�$.{����N�\�8 �DZ-��͂t�)ۻ�3������>�8����U�"AtZ�	�iQKk���/��ڦ��{>V��2�E�Y�_/��Pd8�v��o�������?|Mom      \      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��i׶׭d����l^���m��d)hY	�3����3��a�~���MV���A���S��ւ�*��hP��e4ʅ�Z�ř�]�L�؍5�{��pm�&�y�:j���Ge��Y��bE�=G���.�s,,}RxׅΊ /-fU[������+
�7�O�����q�����B^�.�%vv��F,��9֑�Wb�Mt�DX-%DL����J��5d:�]EoNo�y,�b�DȜ�r;�L��,�#�Y��6�:�c�1���f�=T���8`|q<���w&��� �yf;�������Yn=4:�4��N�a�i�����#�ɂq��P_r�����#A3�*��86��N��A��]l���ǰ��olǁg-��FG�M5������Ʊ�B��wK�Խ����e;���y~�x'���I�����d2i�`�6 �y�H���eW�
°!wT%��=�I��{o�!2�#����^�-B����#���C25C�nY!/rb���g�[�adf�#�	r@�і%����SN��ջ���F?v@J��ErjE8$���X�h�0R$.��U{c��Q�a�0���.��c-l����V�d㤀�5����tZmO@����]4��M_�t����5o��{NE��Rג��О��9�	}�Mh�fm���80L�0{{�I�� T��W�p��h�U�U~�I%�9�UQ�قc��mͼ��w�IC4�yiG��(�4���0x���`���6!lT �o[�?�^ϴ-&pC��-wWYf���\�W�S�:E!� ��/�a���(��az̀ǪYsq���$��x�v)�����*�(��޽n𱢥�n�#������}��s���Af�ݠ�j~9|V�����z���[����sV�?�%L�% ,B72J7�m׉�lK�G�AXkƎ�������S �U�7f�(;8j�jQ�V>;���[s���A�h�y�õ8)_���H�&L�0^Ƚ@��P��G;�+���z�6���Vy�P	̠�[�hF'�{P�f�W�d�cL�.<����Ǔ�p�`��n�z@�s���t�a^j�D�ӣ�mc�3�ބ��}�kFU.�Lgk�}>~�7R*���Z�����7�K	��� @��o��onT ߜ����vQQ���9����SHF1hz�x9�J�����P���t�^eL��,���3�2�Z<$C��ޡ�̴��,�"z�X�/.V[sUm�7�o�JC�����m�K[��X䪷%Q��ПOr��@�0�5�%mG$��5���p[�J5�Y���ٟI�{Uo��?ʶ���Ua���m���>����v��r:�Ђ��/_���@Gݞ�ӝ�0
NN`����lH�:��0����!���&�Mcb�a"14����l\�h���Z�F�H����������_������M	������hjׂ��g�ȿ��9�/">��W9���\�M��Nwf�b�7��h�l\����8�nW��l��b��n� �g�YNx���q��|��n���X�]Įڀ#��zG���Y����7������+?Ai�"���gۨ���GiL��h +Q�����k�f�4v��q`��G�vXv�V`�`�ɕ8��Ŗ�=���~o6��#�����u��104���2F�����%{����$�ɧ���H�d�|u�#p9&A3$}��H����0wR�ڜ&�Jf�u�/�I��sjT��.�����;!p��`vg��V̿PZT�[픾_��
B_�0_iؠ�K���sM���s�w�w�ʊ�^/��0��)̳���%P��"n���W�Z\��B��'9�f 3N����2zcΐGU��I�*��|8���"�3�s�H��ݳٔ��@<�jC��t'�\A�E�m�t��A6�|�FM&��-�I��A6��� hm�H�1���Wr�G�շ�V,�;�d�@��H�#����q7��
��Y���ӯCR<��őh'מr+ˠSU�v�6$S���?����?�*[�b�)7|�+"I�Ok	�����^�3���D    ���l�,F��F�{�1Å�t̋�
I�<U�o����ý�f�昧�DЉ9/��J"p�eЂy9�'@�b wO,b��Q~�X�o�fU�u�W/2�1u��S��LZa��|u���0���|�6_��O<<�y��j���ս�w�On�t��.�e7����s��=���t����@���d���?"A\�U����Gze�O�n��Lҭ�Ef��s�a��ard�䁗�4dz���9ڴˠ��ph�����th\.�i	�"��0M
�O�=��svm
O�.�ꦝ'w������ �L��5⩿D�B�-'�_�0&������@.�����(ז��B0%
��9
� J8О>����@�*vyft��=�a{`d$+�'=h �'B`����Q77M��n�ĺ0�.�{��H%���� ����!�C�\��72$���0W䆧ӓ�#"���k���5�}��#�#/,0�Ow��&;���6�zt@2�a�˛Ɍur1�Ǜ�)a���5 i��3�wo��vn:�8w\���C$X$��1/o��E��y��wF2f}�f�Xޮއ��A�AĈ�j03`j���\�Pn�iP@���!�}:=ݩ����H��|�17"a6�
��
<f�H�C�׷��E������H6��̈t�x��5�#t�ݡ��x�J������Dr1�1�W6�+7
�]���^f�1fڽ�F���?� C�<��3Nsw����3Afq��2����^]>D�B*	�a��#m��rj�X�5W��G���?��B$:D�_ǿ���1��s�Zڌt��Ҷ��3�X�f	?��hF�U2b�ٺj@!�^�0�Ld�v����U+o�-=lb;��� "Rr`x���BSΨ��ID�Ь��Z�>�����\��a��N�_.w�|�����?����/��7��o�m=�"�>d_���~<��ЎA<~$��M�s#Ȗu���OZ��&�1�cj��'�0`*g����ƕ�z��v=d�O�����2��_n6OS��0�V���pK���|/m�����+A�Q�&УtxIWv��>#Ԉ)�V���I�f8M{(b�&��s�m�ts�qs���~b�B�s���M���<'�*~'yֱ�??>��l�+�X�_��a�i�ak�X��
4L9,K9�0\a-	ˌ��C�=�U-����J���#�c��KS�<I�:f�{������ҟ���E��k��2�s��k�ZG��W��ެNy��V��xE$��Kܝ�������>d[���A7������݊�q�l�Y-���7W�v��G��f��,;gw�^R���0�z/����P��s���S�e��t��<��X6�Q�4�>l����ZB&���Or��YO���N�V��+o��Y��#$f�2��֘Cg��h,��#�u�Hl��h�8����d�L�08c��ԫk�C�&>���DV'}�"E�L1E�ZO�$
vF-m�ۘ�='b����0���D�.� �^CD�����M�A%��O�O�"3���@@_Ʊ�=�*p�l���$�U�\�`"*0R	ৼ�S��{�-Z�N����P(�#;�J�'q�Wȧ�}���@�@����qˬ�������w{wJ�Y/����R���B�'�����F�{w	�.��[E� C��9[�w����yq��:��T(��I���*_Z���z�D�P��{�ܕ���;��`,�y҃bN5��Dh�7��14�m���V����6 ��ͺ�T["N"y�
�l��R��Õ+��n�g7�J������I��>���R��X�.�~r���mG��P��Ǐ:mB�-�*V��������4o��ƽ����8�"�A���^�M_��yءɈetr+K�����!Յ�:"[QW��ʶl߹U&�)д
9i���3 �2���x��i�s�V�kk���u�X�CZ+ꔟ�Oz�q�LD�9�� �N�m[x5CU���芨���FfK�E��!*Ķwj�F��{� W��:��	&b��g��g��^A��M��_'m01���h!�6-���2N ��vMA�H䯕	n�^ŉ_E���T�+�p8� ;#G$�:�충��O�X� R�(� �<�w�\%��L趒���&�k�v��q���;��Fz�� �J�1}�V!��Y/|#:R+��݀�����)&�A�X�_�Вj���_O�;6�Cww̯H�HСq&/ 'F��.�o����$+�Н3em^���/ g�+T.�4bĢJJ��zI[���Ơ��q�_�u�jPw��V�m"�q�XEH/��E�t���-H:�Q�E6u�����;	� ��m�*���er��+��Mź!�H>�r�й[�$w�q�<*ˠU��?q�<�~h�	)X�5b�*B�t��8�eq ���yw8��b�	��c:�i*��3c��e��Zѹ���:A]e-�q��ue�n��R3�<�.��^Z4�:&^j9{u�c�[M��u�7FOX�`!r�g���m
W�ۆ�J�]�ֽ������3LKgQ!Ν�5fķ�1;����\�3�!���B��o[|=�٫�c"
捼@��Z��B:o��؊z�N�&J�JN��B�X�M4��w:4s&xjD����i
5S�����$Cg7��9?�L~c�L��,8��s�*YBl����mj73�ԈѪ&��o!{7|��M�q��"[j�һW��ϵ���F��t�"��\!$���R/��8�皛q��b��5g�T�ș�M����\<�f��OA�IRW�(�pD�+m+���)����̲�%>+��W��	[��*�F�L������I��$w�,�F'���&��fg�M��-�Q�ɈVlY���"�{����9���jhl���jw���SeĦF�6��MW�k��U��Dm�-qF��H�#Ku{f-#vʵ�.��4�n�;F�7D��r��{�+|[+�L|� �����nr�"�
R�a��T]��n�_����:��|K,cM!Q;=|�@S�;4��H�K@�W�؅��~�I��׈n��fs-�d!�~~���EV�jT�	��I_���i����d2��	���+��7.�+07꽄�y���mf��K;iּ�op�+m���_�y�g��'5hq�ק��wL��k�{)�4(�*>@ Lb��osc��p�T�d�N9��bE�x:���8
���c��"c5m~=�ҝ{+0��e���p>�
�����}f�̭�����}~{{�3����n�S-'4׈-U}Ҙi��ZP9�gW)M��j�8�۳��ʬ(T�%�>hw��q�]Z�S`��F���6�D�잰G�� �z.���a8	�c�t;�M�N'��4�˪@���rx�"�S�F���{qd��!�@.a��KĐ^��7w�g������
1-4��}{��桴i���aTn㯙4�$�&�I��b�h�A�7xoZ,��@kz�$զ�`��+�O
.�s�QW�j��^��.^Ťm!�M�5�|��Y6�J���Sj���nɭ�������9h�Й�?�����DC�	6�)hءz'�A�/�(?�F��3T�̉��&I�ޗ��G�ր�!f��9wU�i�ak�s�9ruK5���@H#c���Fּc.��p�� �VK@�L6^��A�Qt�<�^G��[�3kĎFVU�L�����xs����0C�A���1'�*c��U��bhȐw���Zv�Fze����yx��2��DHA��&c��^լ�����5W�<g(Q�A���Z)Z�>�N>$$3�
ȾOR��ܨ�d`I�&�3�Y
L�Rp�ݱ��3��˚4O�3%^|-6ȶ|觃"Q�����,���WW��gi�X������I�c��)�R���{�����o�^j�t�u�H!�Ė<J�dN�s������5�P�G��7��T�k+����HN0ı[;��wr�Oz��B2S����)���:4�e�}�5���:��YF��i�����_����;`yRSPE��(O   Z�����_>p���Z\�U���0��C�@��c{lί��b�ʯ"\n��rR4��ąFz�mq{�.���$����kِ�O�k�BZSӲ�7KkȨô��e�e�c��p���eÔ��ТS����&����m��؇j� v����^��G��Ƽ:v� ���J ���������A�;$�`Y>fH檎��U�r$.iY��pO�G9��q�Ԋ��Iې%�z2�Fn��-��9��"�q�z���	��Hߊ�i���H;�[������EB������R�NNڐ=)�K.3Y*s��*�Y����z6u�i�o5�"��9+��ѹ	�^0��r){s= �]�����c�D��<����~k"|zT�@j�N8�A�f���m�e�֨!V��n��!�]0Έ�ם�����GF0�"W$�;<I�()f����}�c�m�s�t���*7���o��� "�c��M���=�@�0ꋤ�I��\��犭,�x<?Kа�u��5�%�����S�{��>d8}���p�)?|`�1ɸY���������������|�Ln�-��1�HqM�Z$�ߒ���H��4p�40>4b��]�{z�~e�w*���U��!?����$1N�K��p����~�WQ%��f�?��������6�4ɱ4i�;��*�-'=m<�U�
i�ˣ䒷���8�k�q��/po����QP���f���,�K-��2�	���d�7��Dܹ*}�o泏������TƋ*7�Er���ލE��m9�U�b���޷qu�C9H�b<ϛm���5�T�2Z������
�JO�x��%-��0���z�vy5e���}�����H/1e�\o[��b�$L��Ǘ��F�=�]Z9��W����|ur�8��a�x��V=prgI��)�H�5EM��j����xO�u34��{�1#��x+ҵO�����r��Wȗ��F�N�G奓z�v� Y�����?b�'��K�w��ϭ}	�|���_y$tp��L��M�
�S��o��Y����X�a�������r��xX;L����d3q�G���_`¿@��
���Hk2�ir���$���+�ϻ?~�W������ ��+V��zQ�UF���>
s7�����1#��L3�ci6=
��2ǌ"�2W�߳��+g����p�/��J���3��MK��~6ND8���q'Ǐ��^ϟN7����(����8�&�U�T�����Y[H�a&iޝc���d�>��&�N���<�]�^;�3#�?-o��J5�BP����)GX�:bm�9OU;����$!�Gqĝ$��(�1=t���9 ��k�%%O���2#O\m�E�5�ђY�=[v[[2N~&�E	fS#˦\\3�3Z�L���$Rj��c�	�$�0;ibc�]�) ��k�>r�He9��a&�2���}����ި�#:/g���W�����A�3��f�y뵈��G��L����Y��:�/b&Q��k��{���}�������Y.�;Hv�T`s������8�9mi��㜚b�0�"��׌r���nU�V����4nA��c��YF:�����^�7��o~�������|��twfdW0N_�&��Jm�����|�i���(-�u���:7����PF���ђ[!�Ё���I�@�_��L��9Ԇ���F5�o1�8g۹��s�]k֫���m?�"�W3/�\_� n6ɜZ �>���iHc��'Y��"7cƭ�d����;��1��߾���h%      ^   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      `   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      b      x������ � �      c   �   x�u�1�@��1(>;^���tW����_�C;Z9����~�s>>��}������V@7ۀ�b�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i�i������~L�P3      d      x������ � �      e      x������ � �      g      x������ � �      h   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      i      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      k      x���k��(�Eg��L ��x:qG���58�L#��:����H mq"�~��>��_�;����}�9���Շ�>?���պ�R�#�Ȉ�	#3F��Y�掿	%t�3��η����+O��na��։F����F�����n���eK9Ԑ�c�����ϖ�ģ��uk!�h=��`�
���퓅�,��%��֡�e�?I����]��*��x[bş5���X����:��ۀgEpo����l/#���ˈY�����5!bM�X"�s#֡�u(aJX�֡ķ@�C	�P�:��%�C�P�:������[H�C��o!�)޾u�⚀�O��U�|@��u�;�s���`�\�c.�1�v�;���H,[��v���]z�.�P�^�K/ԥ��v酺�]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إԥԥԥإإإإإإإإإإإإإإإإԥԥԥԥإԥإԥإإإإإإإإإإإإإإإإإإإإإإإإإإإإإإإإإإW��[H�CԥW��[H�CԥW��[���G]z�&|��So�{�lE�����=pBB���~��Xe��* ��f��{�W?@b��x�$�Ќo~����H,��|��ş�@�Չ=e�U<�	S;+���.6�X�3�� ��u����o>'��o>����|�������H��f|����|�Ě0��xϝ���Ќo>@b���H�b���H�C3�� �uh�7 ����$֡�|��:4��X�f|��A�k־��9����3��~�U(عw�$\(s��H,!�^Ͻ� �A�{?@b�R�|�� �eK�w�	�OR �*�������-	&u��^�Dˑ|U�qR�u��`�ؒP�u�� �����/o��ǹ=}�|zJyư�5�\g[��e�}ʁ�R�Շ����h�p���>�I�>�iТO��=}x��E�k�����A�O'[���l������)�s��>9/x-P�{�� ��u��^��x�Q�{�� �Of���{�>@b����K��u��^��X���=��}�M�}���z�~��z�>�*��K�.����$-u��^��X��i�{�>@b�R�}�� �eK�����	�OR �*܊�^��#������K�����a����q]�z�{KCs/�H~<��������$��441��}�Ĳ�����˖��s/�H�5�UF]ݹ�$>�PWw�� �u���s/�H�C�՝{>@b������7��QW�Ͼ �ܟ���h�3�&e��\ �� T[O�������r�K�mr�}�d9�u򧒻wǿ����I������Ż�>�AIGs�>��CM�-^�w���&.��ӓ}�z����.^�ښ��\������Z[�}��v�h�냿�k����'�gL[�.��s�u��l1�֟&{����bt�U�Heo2�X@Z�HGj1"���S���H-^c �i��e�?I����y��*�r�0Ċ?����5���k$�u���Z��'��1z���u1���iQ�m^+�#��S�H�sj�%�LcҢK�]2�|#�:�E�$�!-�d �i�%�uH�.H�CZt�@bҢK�]2�C\��i�%��0�@(5���*���` �B�s$�����@�e�g"H,!�$�˖:�z&�!!�I
�]�����`H��<L���h9��j<N�>��8�%�����` ��R'�&a�;�`~>g���﫤i$�����=��/�$�=��/�$~_����S�Vk�^f;����d�Ւ��z2������֓	$�!����M䚀����j2���Q�	��B���.1=��@b�R�YO&0�X���֓	$�-���d�eK�n=����$�­HO&Б�BS�]M&0�,���dC@\׹���肞L` yo�գ1=%�@�B/��� �eK}`=%�@b�RXO	0�x�P�UO	0��TBV=%�@b���` �Q�UO	0�X��ê����GVo�&�wJ�<����y(��=���~�?��m��7�����������~~���8�A������VK�K��q��§G���)l.����&[�UY��p���G/��l)�=������H�T��]�B:P�t �-v����������S����������Ϯ��xh����)�8٢�ЁTմ؆�O?H��ϯ�ヮhT4�ï��.<�T8�����|�����>�@���W�:�Z7�1ԁ���[��
hN������@jt4K���,H�Cs�t�L��\�_d�Q�ê8&�Q�d��?iՁx�l���:��F�5��c�gG�A��
 ώ�kT��G�	Ϫ�KT]0x�!³��
U*�H���T}��l�����TR]�ޞ�������0B�yZϟw�W���h�f:��vi�������jTR�]#�}�n�F�4������Җ�KI��}О�-���3�Vigw~��k%�|q��0��K���Ѿ��gڟ���J�R�8�A���~�k�����Ρ�g���-T�/�(G�(�c��s[	nOu�A��,����Z�+W�de�`��Q�t`���r�\_6u,[�\f����U��]��:� /�+���`yƣ���^j���˞s�`�*�;���!����յ�����:���GP{���5��%����^p����O��}p�^6�x4�n�C�%�ٕW&��Li��_�m���W�:�n�0�?���xo������U���^Ҟ�X���^b���_��@�6�w�:�����G�:�* �թ/��B�'����uH���O��%LE
c���u]6X���Ӯ�h��d]��^��o��eLM#�G��u 6UT`�N��Ta�N��@����u =��ؐ��]Ŕ���]Ŕ���]Ŕ���]�"U9� ��|�do�oY��ͷ/^>߲����-�@v����]��!{:�
��ٯg�o���?��b�;���c��O<����ӗͻ�.o���\��`��ߐ��Bm/y�n\ĵ��!o��']h�����b�/����!�0��n���^�	R�ڏ�84�P��b�I�#:�k�Z��_t�3��{T_���^�[w!n`Z��hq2�}��_C���䖙��\��T]\�5���Ә�z8�z�u�?���8�]L�0�f#�7��6rt6��X�ø�-�:�'�o�Y�l$���i#�|N�l1rtڴs<���s�- >��4���762c$��a$Ȗ�8db�!��0�Fb�7�\�H��a��Fb-!L�0&`#���>���:۶��ke�5�q��	��T�l$�ʔt��	m���`#�JQrl$'=�)i6k=��3�OR �*=g��l��U��IϙJ�-Z��k����4{�ؒ�S���`#��sl�(��F���YŪM$��Qb^��H�A�kR�w�m(y6��(���a��$��?�� �ɮ��yO�x�o�m$^b��d�����3\@{��Ly��ǘf[�Q�6[�jW!�e����$���l�~lsy�ck�4N�o!�"a60ྍv��ǯ��f�?o������V�ו�i�z?���Bk���K�(�'�%JHq��0��g��3�m�5�z�3�v�M��upm�ӡ@���J�՞|�}r�ħ�[�A�[<7��53rۢ칺<���RnZ������G
~�Q}����9�{�W�&�ъ�9�Qrl$ދ��Ol$ދiDLI@����)K    � �@(%�F���(���`#���(�6�%�F�q�(���`#�&�(�8'��$�B��%�Hl�h�n��`�i,X�S�lq]�z�{Kc�J����;.��V��u�-&�6*�
6��/�4�$+�H,[�S�l$��:�q8%g�F�4)i6�4)�6�����u���J���M�}��Z
�mqaYIb����GMc��xFyvd��`s��`�h��`s��`��Q	�Q��o޾����+����~=��3�����A_�\�d{\�W�E����t�����5�ߟ���1�|��bۿ�R]..R~���է2(�A�4�6z������3�gH��R������nk~߭��}�ť�[�3@և.��g,;�T��诙&���-Cu{�e�E�� ��Ŗ�by̭~�P�u�p4���Z慁T�V�V�R���o�Y��S9*H>��*��>���`�Uq%��b�r67TV��H�m�+�N%��@�Y�[-g̊�ӱZD�@bcrF��O�Ry�g �j��� >� �����=d�>Ȅ7��oU���Eo�I�z$�
Z�@b���$>�hq1��j�ͣ��2�X�Z��@b�j1*�;�CZ�JC��B:�G�2��8��H>Nh��|!	ט�/d �8�ˡ�H�	��P�OR �*�U�|!C:|U�aR_E�2Dˑ|m�qR�A�2Ɖ-	�7�|!��V�2��S��YQn�t$*�B�(�i�$� 흂��;�p�|!�m	���|!���૚/d�)P�2��!}��Y�o.�L#�l�'ut�L#�'u���'u��cg�����:�j����$�,u���%�@O 0�p��	����z��Ě@�r5���$�B�'�Hl��?�&k��C@\׹������@` ���/-�c]c�I�z�����u���eKs=��@���3��	�h���'H�C��$�!�?�	����X������ ��@` a��J 0��J��S��T)	�7�c��)��@`��	c�z�GmU2�0j%y��a ��=��'a �f�Q��tҗ���v�o��� >��F�=S�Ҿ�K����ym-���-�[Yڷ��l�s�ִ\ZٚK������kꈖ"�ZFJL�\*�Y�����ۓR7��)n�����������3�"g�/��8/��S�R킬\�ť��T�}mז�m���~���ʮ��I�+�&�-���5��Juۗ�u����m^�Ψ[)6/+��Z�}i��R�.+'K[[�nK���Ty�A�_*��v�_��k�����jHX:��t�������p���ґ��SHZ۷��ޥs��,W�miC�ځ�<�H^�na��ĥ�7��-�Ӹ4,��|/k��q��4x�joZ��i�H�n2i�朖j�Rp��_�/��[}Z��ҵ��bƯ���#�R}+K���B˯�O�ҵ�����v-,�oK�}Y����]�����u�t-��ka�Uqw�h:�
Hϸ?%m��d���n��d�H����3���N����M�?�� Vqa^nk�d��k�.շ�t�׵#]j����t����K-R]jC���t_���jȾt-���_{9���ӥw���:K�>����c��Պ,}�"Ký��:K�^��s�,�(��3Yz�)K�e�S��Wm��a�,���}������FY��F��\��'UYz}*K_����ӥ���T���d�e�,}�'K/ce�cY��F���.}�$K��һ]Y{��銬���K�mid[��/�һ]�kG�����4V#K}��-��H�,����x�,=����������_X{R]z+K�e�}�,���Ҹ�,M�Kc\ai)��`�����X|��as����/-�on&��~� ���}s�)���E�C��U�W����z�����+-�1�$�:}����os�?��7ƵBIo��|�;q�c�!o�c�o�^MZ�hxƴU�� ������k�֜�?q�{Mӷ�����,}G$K�N��waiL/,�	k�fK�'wsm"ZJv���4��ݯ܆&X�]|��6S��ַ͔��|k���o�y#m�O����#��j��2"�x�����dz������6���zɹ�CҊ�*Ն�� ǰ�=��~�J� �c5������T�NH,Z���!!����M<+ZIUɿ��3�|>?��:P�3���Y3���J�2C��`�:�R�>f�+�N�\�@�Y��$��^�T�j�F$6&���TJ*H�Z4rE��+H�\�@*�o�����VA�pj ����H|4�j�H�\�@b�j�?$��V���z�����oB+߂(�#*�����!QY$'�|:����kL'W4�x�����$��r���')w��**��!���0��"�W��$_�x��o�\�'�$����$�[�\�@BOE'W4fE���#1P!W4F�5H�p0�X�4�w�������䊆��W�\�8�S�F��#rE��Tj{S��F�a ����1$^��E��$^�Թ�����k�>�\��:�G'W4����-��$���\�@��+H<N���ku�UrE���
��N��#�ѣ��J�h�i,X��q]�z�{K�:����;.�����u�-&?����/��1��$�-u�urE�7�Ψc��+H|����N�h �Q�Q'W4�X�����+H�C����ob����7���J:����_�\Q���:R#W4���+2R��o*��8�SQ��3�B��#aLS'W��O!W4��cH��5rE�0 ��+�H�\�@*�FoqT\#W4dK_��+�����}��Uз.���QWZ�7P��D�Xw�"�+[�($�+)�<��Ƨ��|�J��η�j\I��!Y�;Q�+��;JH:���D�b��;&B�"<�OW��wz��c�Ŭ� �|@2��I>2i0c��KP��(4�@z�CW��w:H�蕰�o!^���!�FDjٷ�4����=���,�)�|x�<�l5���w�Ǥ�3d?z�~ߨ�[�s-�YR�Q0�C�{�l}��am<���m��vb��5:)�5e<<���]+����^�t���2�����j�O~�ks)��P�,���/~4W�T�������M���2��+G�v��Yi���dzQ>yJ<�o+!&�^�.���q�?e; ��iz�����{���!�</�N�����s]�S��]��p{�ϗj�S �;��ێ��q~�vҩ�yx��t�.n�Y!]�LK�{'���l%;W�X����3_�W�v���-���u��%r����=:�%����g'���	튙���<;�dvG�UзP�ϳsVF���n�h}��畢��6����!ҍ�t� �`�I�"iT���ioE֦"=�H+Ҩ�4�B��
I~G��¦i��
�^)a�A�t�t%_y�dH�W�N$(8~%Ay�tv]�]IJ�A!�b�gt$Ȼt�$�>HP�J��
]����� �(��t�)(8.�jG�哰�8��t1)(�~%~x���ԯ���<�!�E���
�F���[�ч?�o}m���nv�'��"~�]N���J���d	��p��->�Z��V-6�s��M��'`����ѝn��&Ἁ��±������\�+�z��]~���X��9+;9g�	/��w4�&��g�����7��O /9�a�x�{��f2U9��sL~~2z��wl�l��
�>�8����)>#�����m��]�y���me���۽NCm.&����[4v0E�NA>A�0A!�V ��9�u��^���(�.(L*($�+Q���{����h~-fWZ�Vпl�0�~�*��x���۵�{�^�K��xmЗv�C��?N��Q�e]�m�yO�P7)�E����PIu������~����D��J����u��_x�f��ԩ���C+,��@K�7�pV��5��ӷ!�g�Z�^�Vw\�V3�@���\ ������s�n�þ�=���V�g��i���    ��jp~���)�~���j��W0���JN�1��G�~��~�e�q�����fN�����?���M{�o�Y]��1D?��/��}*�i�ts7o5^|���\fN�MJJ�pCI��Ucb0R�56�EZ�S����&��	�t�s#��1�4�7�G9�M�ő�.��g<��$��=��*���r�zȣ?���*�Oo�o�9�/�'�9]���-��W�����o)7��|�K�Z�]��zP*�H��Z��&�S���.�3����?b(>N�Z�C�VK�@���S ��c�+�q��|�q�]�M�ze�čy,��V7+Q�������h ����̙�G�jz[}�~�KM�}��߯ /A��J���>,�y��¼` ��?8�%uϼ��k�q�n셩N�`��A�VO�@"��L�N���A��ۉ?��c�g5G+�bn�g��ma����ze�4���~��^��5w���B7"�n@{��a_|�뛔�A�3��'ߕ�7r����a0��b��Κm�|�>
�g�@b���1�x��R.��
φ�Mx�Vy6t ��γa �7��lH>N��E�g�@�5��lH<Np�y6$�Ry6�OR �*��<�t����d��h�l��H�6�8���c�ؒP�\��0�Xo5�	�f�gØ�x���@�g�%� ��������4�xg`�g4x6$�%���y6���T���O�φ�i��x6�)��S��j ����H�8����lH�8�s��l;��}ԹԹVy6�/B��&`�<`�<`�<`�\��0�p��<����:φ�Ě@�r�g��$�B��l�Hl��?��lk��<�lr=�����g�@����<ƺ���t������<˖:�:φ��^g�1�y6$>�P�Q��0�X�����lH�C��y6$�!�?�<�7��Q��<�ŅA%�g�@�ųa}�#ԧ��Tx6)<�7�c��γa���	c�:φGmUx6�0j%yy��l�Tx6� 5\(:φ�[�x6��G�qĳa��
Z����������5�@8),�}I�����˚8�p�%{L�m����me~���D&�a��E��LVY���g��{8$��	�f��Z��B徲��-�R�����&��=d�Ō��=]���H��+��(f8��3~M��g���[�}u+�ܰ	�S��@|�o��e����ֱ�WE}Ɏ�-���O�*�lUJq�ͅ�������VA���^�������Қ;���I��� �%�3��iF�FH�Y�2c��|8�cm�$��x?�_O��E[D|�^��ߒ�Ot�c�Έt��ouO9��c��C�^ZQ_�a���vȱj�n��7<z�q�}9Zku���<����|�TŖd���Ԗ��$�4�5'��K�V�L-Kk���	��HK�}#=ΎR�3��@z�:��Id�L���ܔ碉�Mr++�RSr��|0��IqlLz,����o(W�I�x������Nҙ��K�r[�.n�k�^q'1__�����ü�-�C�����/����շ|�2��d�*������q�ʽ�_C��}�;u_��D!?��0�D���=a��B���#L:��FX��jW&
��}-4uO�`~��=���B�u_�͔��{:�f��
��B���D�Y��c0Qh���L�=���B�|O�`���'V0QH��Lҍ{b�$_��D!�ߗ�6�E$? V0Q�V��+�(b�
&�h�X�B����X�D!ݸ'V0Q��@a����B��<?�H0Qh�Q�u@�`��Q�z@�`z�L��˸E��B�BW'����Ed&
I�ES��L�E2�';0QhUޓ�(4�(�3 ;0�l�F]C�-��R[i�c�(y:��j��:X���f<�xx��^�)����ߵ����1?C܎��,�������[.aۯ �oL������W1����a�J���G�{1�.я|��Ըw���Pݔ�rGr�w�k*��^ѿQgw;�^�]��y?T������W�.��z�䏽�Ϗ:���K��/"��>��w�M\A�<4�-��P0k@=`�mH��1Ml��� ,�;�fz@`~�3�r]y���(���Ϻ�͈tSWӋ-�g��tإ������M~���51cmL2�W7���ƾ����[�*/}<����Ku��V��ݭ?z�2���������J���?H��b���o��e�yBc�ir����z���b���lϕ�Of�"�cfZ�䲕���Ɛ?w��<|1���Ǽ�CwJ�?itf�x>@��H�a������yz꥞�#�����A��Ży�n/BZ1�G����w�SOf� i�QF��{�9���"O�6������<Yx^
�_=������m��/�]^dd�b�e�ʿ����Vt/�R�1�ʹ�1k�m�W(�{�H�R^�X͔�VdY�o�W��O�9����~~��r�u���8�����8���i�É�S.�S�����u=�m?N�o�����U�ɽ�ݵ���X�bik+B���C!Z�c��oݾ8a��Hc38�k5Tg���H#6kg�c���F��� �+����jq�7�-����_�h��eZ�Y��y9�a����yv;�t�;�1:�)��ީ��#}���r�HRם^����;}��p�&~H{�����g�p��=�:��.�X��8���L��4Z�{���=�������MB9\���I�kGݣ?v��V�*��5m�����VO��+�}<�~���Dj{��N�k���]s��L��؋Y���b~1���pX�0�Q�5�Y��&�V<���煉��Ԗx��*�0k��jۆ�aI�258ٕ��Dגx�J6n>������O���a����s_H��իoƽ��+1�?]<�j���v�w7�ü�oX�~���?��딐��FK#�J.�:�	�̑�Q&�zj�{��<P�v�9�R@|�d����:0�J��n���"�zG��NrWk�������TH�uI�lw���QS�<3�Jv��D�֑\�JB�xV��O�S�v` �|~��t�B�c�U�a�#��
��a�j��R$�W >�
��ĳ�10H,[����Պ"HlL4:"�d~H�Z4:"�0�H���@*�?o�A���VA+�d ����)H|4�JH��@b�j�$��Vf��z���8`�oB+�r��@(��@���c �8���9`$\c:����.��c �&P�C�1>I����WQ9`��U��I}��-G��I���'�$���9`$�[��@BOE�1fE)�#1P�1F�5H+5k �i�f$����s�HlK�o�s��_U��O���7q�5cJ���j�H�8��/N�"�0/N�\�0���5ku�U�s�H�Y��0�K��c �J�9`$'u�u�5���*��I
�]��]�ё��Q^�1�4,�0����s=������@�_Z�0ƺ���t�����0˖:�:���^g�1�9`$>�P�Q�1�X����s�H�C��9`$�!�?�0�7��Q��0�ŅA%��@��c}#ԧP[�T8`)0�7c��)��c��	c�:�GmU8`�0j%y��q��T8`� 5\(:��[�8`�җ�Cu�c��0�b��j�q��n�Z��~V[~�{;��}�+5�1p{@CR�X��"h&��^=���rK�4�rHR�'���-2`u\b/����������N�}���ю%���8��^c���{)<��1'��=�������C�'�h@�c��N���4QȨ�����B*u_g���m�4��l��aT�7qH��t@�RA���ܗ2���3�~_|��5�2ϓ�	C�~?�LF�E�n���*Q��Qº�rO�a��g������%����5���-Z��b�&
��5L2��&
&�{9��0Qh#��ְP��&
��=������0����Z�D����FhJ��ק�x�k� �  ܗO7Q��Sr�(���&
i�=%�����P{����א<�<LҎ{*�,�=���B�qO�a�3�$����&*�%_���)"�/)o~�P�`@�a����D�8�=��b��S��~��h^�^s�Wݸo0JrI��'�$uW��$��\��\�]�R��t�YT\b�`��mt/a��4��y9�eDlE4�{��%W�ȴ�%��됯�e���Ō�K5 {�P�d/&
Y�{���`t���(�A�B�ً�b=D2d!1������IY t!4 {1Qh\(�> {1Qh�P�o@�b���Y|����^$�{��V�=ً�B�����*��{�^�\��������[pX���f y�gy��Y��Y@+�����kU�+�!k�9�M���{cpm�Z�V\{S�a9:L�:kO���b��aJ%v
�Gy[��yi�
b��e��r�W���f�w:���-U/�������_P�j���N Ϙ��K)�~i�jj׌��a����U�~��պ�����q2<t��s4���j���n'�h��������Wrn%���fm��c�wkQ^zYZu��J�K*i^J���ú��CM2�^����J/C���*����F"�sW�_C�D5�+���nϴ�#�X}z饸C��e/��h��Ν1����8�3��P���~R���~,��e턧�N���+�jy�
ľv��W��F�Ҹت���%�
��e�����^��Vo�9���$� f�]=5�+��`g;=A�%��������Iu^�Z��^���fw����1I�V�}~U��J�-��F�,|�(=z	��2��ܴ�@�y%*�U��W�i�a��ma�:?1��$�����-��
���JxC!�'�a�ZZ�q�l��w���َwT��E�{j3�z��]�R�u�Q?�������n�NNU�1MO�~�b��G��c����r���Oz>O�鵽o;�7����V�t��s������B܋�6�\��Z/��1	�c,u��'�E#�hD'��+��?LV�_�m����W4ΦgJ۾;��0�����U��(��[To��NB��/��6�B*���dM���׆�^��me�,��a+�\;���F�xKS�c�w�FҞ��J�����8�����У���K�5�<����gaxÕs���"t+���o��I\��-�v��@O/���&��f����m�=q���t�5��������c�      l   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      n      x������ � �      �   �  x����n�6��g�B��pn����E���"]�&@�J�)��%)��x��}�#~�ɹIt�D�������5�d>�0�ʫ�-�_�������?>}��w���������燄�}}�!`Gâ]�ʪ��+�+ϼ_�}�v� ��s��g�<a����73����t�B\UG�M��R��W3����b�0�ZW]�:�P	�P�˥jm=6���D�r��|:������{�i�֔y�4�i3,��|���LX��+S=��}l�n0m��-���� Y���AX�1���=�"1����R����J�π�F����q锖Uj.��%=6�)_�E��u�:���?+1oȀ�h�T���Ҧ�l	 �M<es�0�QOF�p���-4�\z�w!_zԃQ��(1o�$��4�����;�Qb��,܏�ζZ����)�M\zl��&RͰ��Aݠ��y��&ͬL�Z8��K��
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
v�2�g�h:z�o���[�H�D-�L�"��E�?�X�P�?(v,�a��#��;�{�_V{�9���"�i||����y���{�O8cU�����?���o`����E��M*��� ��_�Y���>�J      p   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      q   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      s      x������ � �      u   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      w   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      y      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      z   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      {   �  x�}�Qr%!E��V�dJ�m�2�_�p�u���T���7�����-Z��~I��6�=(��T.�B�Ԉ��(��Q���A@B�2~a(�R0��th�L^��m�����~�R@���d�je�Z0O���ꐋ2y�٩�����-����lE�W�2���������'l�T��<��JІ��'sl��h)����ep��J0�;���i��[�cgh�B�(��&s+�94��d���3�"�Q��� `e�C�*M��f!u2�=FS*�ٿ�k��$}E�z���RH�!i���(����4�S�A@67�}�A@�ύ���fHl�4!!I���%-$$y��6U76���V�<���A�u(��-kͽ!�ypc:�!iҭfy��,$�gm�\ l�|�@0�7ˡ�y��c���<s��*}����� �\1�}�Г{0"�����ͧk?�A@�Սu�t0HHnL't0�Y�&���Э,$rMj�5ɸ��R�����D�7��a2$Mv7�M ,��/��  ��5�0F����P0XH��`�VVi#,<(]%��$��@X�C�:����x��Kn��}D{��:��B!��k�~E��X���Eu�)ٱ�F#�M,��� H���mDoA��4n�q3R�X�ָ���i�DPC��Ng�� Hup��#z3�7[%�[�f�^rc���ɫj�i��C��3z�sڍ�p��5�ȝF#�M��p��P�p�ן�!������ۍL>��-�R�.Dp.����PA��F���ंg�>J}9v��r���PSH=��Y��{?<����K��p��C'�k�-�`�pP���M\����x���*}s/ݿ�:�!����=4�|�����E���%��_���P�`H:y�E��Ӹ-��R��06��!��4V����W����˚ZÍ�����e�0xH�N������j䐺u�,r`�$��҃A���il����VauPҭ�Z���.�vK��F��'��UZ�M�f�:��W��5'f[������u�~�]??�WA]F��|߽WA{
�������_�+��SA#��#j�yY'|߽W���%ۢ��]ce.���n�?O�?3�2�
�$�����ne�����z�F���      |   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      }   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      ~   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �            x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      �   �  x��Z�q#9���p���;��`�cI���	�3jT�-�I��X��G�������j��5|PB�~�k��RI\?�Fy��I�pA�ߣ9����Q4�sjX�k�$�@�V��$�em���$7��Z'a��6߃ѣ�ܲ)�k]�Y�[�����r�;.���� )?��U˺�F{.��e�ֹ�3'��O�ƥA����>�s�7��o|0|"u!Z0*��Z4x9h�T���7nb��ha=����9؁�E^�Q�ZC%�N5�D�s��zAi�ql#�T��xS���݀Vo~s�5P��`�'oo����8��&%���I]o����� �"$�	����!x7p�W��Ձ�����D����=���m�m�W0x� xu�"x� zu��Bt�F��7��v��X�ޫ1z)y){���JL�h4���x���V��s��s��s��A��A��A�x�X��HZ�g���f�����x�U��g�Mlߙ��=����6�6�����4�	o�RNpi��S�[I�#�M�<� ����3��:[��sރ�Ms ��s�D�t�!��V#Y ��t��$�A������`���C�v�+�5��/�e��\�� �ˮa�=⧬�A��VqٰH��:� �*)�Taд���>��j�I��m�Ԭ�ߠ�'�� �c5�����bC���@SE\ݜ7�B�X�lae�фO$������
�
֦W��ǭ$Ӽ�Ȣ�A��vm@q��.Uy�!{P
�*	Q]�%9�z�ns���U�(ͯ���#M�?�F��������Ց��(!��V앺����-���i����+���px	���j���z�e �LM@�U����sh��/U��F�K{6qc��&����#k�k�B�i�Iά����#kc:S/����*:?�8��)ʃ!���=����`3����94��<�Q�(uz��v����To7S�"Tg%O^Ę�Y�x+yp*��������D�N�f�����Ɯ�C0��䝢�wr@�I"�+OPo�A���Z� �ף�Dx���i�I�D/-�Fa^�e��VfU�.������]�ze:M�Gqh4y=[Kܣ��[x�!䝎{�d���͖�مw"C��!�#&�%Sxj;�o�(x��$�w�Dś�;�'�x/���$��^5�D������EX9�ף4�p#���v���c��	�
�K�`L��c=�x����U1��-���iΜ���*n�%Ƽ�zbm��ʑ�� �e�t%}��W,���(�_�,P�B�h��b�@�@5X_��	t7�@�ɧ��c�K�����l-�"�m�a�{dň��� ��5�� m=�8�N
�QX���IB���
��N��6�������4�kʁI��Z;D:�ߍ��Y�W�w@C:�6Er��x���>l��6�2*�3�Y�;l�5�U������06�yюd��$�y��	;�g.�c`��[�hv�ll1��L��6&� �5��CY��1��$`�h��fƀ��qtl#�%ѿ̻9[OڒQX`�j,��{;:l6/�`�N7#A�ٷ�y�h!	zw3砍��q�@5z�|Ԑ��^w�)t�j>D�ѸD/�L�Is�T���OCIS�c��:f<zb���KbJ� 8��R3�J��3E����_�X������� �      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@��w�B/���gI{����-�@ w����j�����B6���|͙9��:o��%����p�7��k����r(Ո5iE1	'�W��6����on~尺�����f�q�i��XG��/���4Ұܿ<�9,o�Fq�Mĉ��8Z8��p�r��~�t�.���v�UL���(�L@2���p���}������K�Oz�����1���7�7�TT��Fv�s+�36�",�a���c� �T-�tS��j�j�Wq��|i=��Tئ�&*h� ���5XI�̓�����8��#N��8�w8��j����#Aw��#�jA����O%P�w�x�i�:�$,���n�����&�Ϸ	�#Β��&}p�k�U���"g:��^��K����z��#���u�ٰ�����c�F����uђ�l�ǈր�B>o�ƲX �y��3D�a�g��T?�� �7*6R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-�����3˖յ�wfcb�
�ז��v\��O��6�qb��B�Z�%2
��,|)�Ы#E�2�R�?�����(�W��i�>'�;hǠ�z���6�0�C�<�6�{�?��걵�:iBC�Hmy��}0Ů�3t}-�C���u���I��!�|�ee hs�.��5�.���jb7Q��^�����b|��H?���"�Yz�^&q& }����o^��f��D�����.̸�tK��g�-��pR��=p?;���$������@���?U��Q��y��!#��g]�}��*�&ޒ.����K|Y��ʖ�S��2�$YQ?)�0�x���NA?����+fz��{��!#�G��]�}�mO��1̀���4���~h
[���d���e[������I�*DQ���h_���-d�Z�s{3� #*Z#���xن:/L����|6�R-�_����^�ゝ?��v�Ql�oY�G�7�R�XCSӾ�4 ��y��a�5�6�$#��������%��r�4+�[�緞>�_	���ڑIt��0�2��CU\Ci��n��H�`P%��>��2L���&�7 Q�7����­u�w��iKm^�E��8�Ƿs����[D7Zۢ -�H��/����d�!�,� X�5(��Ӗ�e�ڏ]^њ�׎~I�Y���Nˋ2Z	��o&�żҖ<*->�����M{������������S�d�TX�J����!F��m�����@0k3�=�5�W�J�۝)��:`�u��Oi�%4	5�������dm�7�Xm����+ˠTW�HQƕ�Qƻꢬ3���U*��ˣ�z�u{�#O�|���(G�or7��1P��&A�μ�>�/
��wD��������})�-N��U�\�e�Ŀ��h�ik���V�-�9���_��tS�nHb�8�G?tЗi�/�I�)Ԯis��G�y[�����x�;�X^8S-���1���&B�w��Gχ�{O� ��C��y�\"tg�	ﳻ�P�>dNH�ςz�u+�6��x�O*mF�����.�ȞYk�/��0t�c")�I��k!R����s>d{��a�c���(��R+�*^��C�s�\z�(�����.���]S���%�~�,{5�m�䑴F֕ҿbd��?��>F«͹=M^�q����t{�<x���el�U��-b��ʕo�{�}7݂5���i�>"�&.����4��23�gĈ)�U٢W�V?Ì170Lv�5�\�����w U  ���Q�Wu��?{qA�CY�r_�����,k^�g�i��o�Y�:Q��o s�����Sr/b�?��R���k�[�A#�j('��oq��
�8_�ɩ������駮?�C��&�s�Y��W�lL��1���Ӷ��4L~��B��P������6e-�T�n=1+�.᾵� *����S�*���X�hSM4#e{�l��3��&�M=P��WMi+e΋���XUb_$Ŝ{cFL�1������g���B8e�*��a O�����Y�{�s�Y����K�l ���iV�:�6��8�u�iP�_�Ȝ5�S�1�Dz��>����@3�}G?$�n1�����U��Moj�LK��n�X6�
���UT�EiX��������<������D�����懲�	b󝿔�)�F���-��^o�И=b�$J`\����
�16�LLj�QrOx�H�v@uӕr��>WK	��{�<�| 4靿�{L3�A_����#�[�I�5�N�Ԉ�U�}��iRW��YV�m�SS3\E�MR�Nc�2kZ�Y�f�.�@�G�m�OӠZ-1�=�"e���jш���(~$k�y� ��i�6��E�������'�Ґ������ϻ�1�Zz�K�K8Lj�O�ޗ���DާW�L#�"�m�2�C[y���r������ _���A��>K+|E9�$r�rNe(uY,	G�ݻ�Pmu�̬d�DY^�t��������1��QL�=eB�~:JZ�vOQ-}�	-��ދQP������ple��+��n�C�u�p+���4Y❂F�����8��ΐF����~�S��1t�n�V��=߾D0��1���W�l�ؐޫ7�#m�ǴO]�ՎI{�j��A�����<oG����m�4q�Y�=$�7LP��#����h~� 1Wχ���[iۂ��!�
Z�˝�x�A�a�c^_�+�(!�Y\��W�Q��S��I'fƻ�~U�	�~&��2��EѨZ\O<?d����E��֯S�U� ������($u�5ʓr�n@v������͉?R�F�=8���� ��S�'

�������(h�k㫪������h_d�<�u]p�!3��A�|�mA�ȗ��z=Rt��Q�8�����6��S���bs���=�EQ|�E��i���>i^G�p��;E�1�b�l_J�9�M�R1=��/~�=��.K$588R������x��M��^R�F�d�t�ǖ$�=�g���a[r�k"�t��ŷy�^"6�]�|��A[&bt���md^a�vj��S��^��s�&'�!4@�bC*�y�8R�kw�	�Z�5,bp���Դf���Af^Qݹ�[�r��a�5�c���?E����?�$O��S��N)wQ���"?j8�~=��^�<@�'�\1azZG�_'J[�N$�}
	R��F��@�:�Hi��=���]8��=sOY��J�Yf6z���Hbr8W�\�d��b8M�T?�0l�B�.yL��z��u��!y0{髹�0������<l��"�=}��p��z���r� �B��_Rt��ẕ%o��~��h�`B�Z���L�{W���c#�&߬^��~Z��8O�	.L��^~��1�&z��d��՘�^�Lw�����[Gy�����^RYyؿ�ś���o>�+���UU�{�It>L)-^�H,�w~?������O B����_+m�
ǜD������@�m���"������b^�_2�����M����׋tQ�,�P=%߼$�bjo�� $�YI#���i���$U£J-``��	�&�S�J=blڔV�yL~M�����I/�?��)����[��^��FQ^�a��,�L#R��/W���C���o1�gs����������.�B�w�ޗq�\{��3`��tGS����'�o1P}�l�ä	��q������z-<�GqV���G�f�:����$���%�!-Y}P�!�wK��ר>ԑ7��^n�^��K�R^n�"�@�΃�r_��P�j_���Q^��	G��Dޭ���y�]<�3w�`�\Ǒ�9�x�)n"���)�K����8�?��k�l��`�@�XG��;H�rw��W�7z6��|ls|�¦��ڤ�ir��F�ҲVC}m���m��2>�6�vaO���ABy{��X�r\n���'��8�I5�����8�N�`�G�t��e��� �{�*�FO��S?c�A����>�6ש��x���,�|��!�w�(t��G�_$>P07և��w����Q���V�x�g��Y�V�0�L��X���_S<��p����ԀAJ �J��`��1�+��x&�������r����Br'_ofl�&���"c)��&#�0D�"��?낮�;m�8Qz)�~-�(�x�[�(F�/;�����kg�R���և<߁�8`����83(}�[K:��D�e����`{㾃Hv��u��������HL���Vl��(�(��n�wEE(��j-��}p��t�P�׮j�oO�f�J�"����!��=4��b�S��/%�9qOY_RB�����:�7�i����Ng`�����M�x-u+�����΀!(b�_e�Fy�!8CF����� h>}3�f�����}q�d��(�.�e�@�Rnx-3��]�5U(�7o6�EYW	<*��@i&\���=wA:r�������s�r���y;P��ݟj�`w�)�-.�i������ϫ�Z�td`�h�.1-���R�?"�mY���i*������8uL�m�(�#~G�u+.�,��uUv��w��C�X�G^�cC񶫖��[#�D�x}�.����R�X'��R�����丿� ���]2N[�n)�08a�R��g�do(mѯZ�:h�[��6�K���S*��A���r�����
�����W6��p�Okስ���+P��f��9�ǱU���1&7�*"?X���c:`�@��͛몶�aˡ�7\��4y���_��"ﮫ�#��t-)�m�s���S�>ۥ��`#&xX1��?�C�Mg�bh��n4�L:`&	�2ռ򡕈�?�Cv4���m�­�x�xm���\ro�"�jT0ߴm+�{���ltmmڪ��|k(Pz�F%���uz������7��<�U?~1ɷ[�r �r�6���^��UMZB��.��ݞ_�u,�X����Ð۲�)Z��<l�)t��_�����{�������u�G�u�m�+רͼL0�7f=���ǟ	�
^m3bZ^��X�=�Nm��:�����^#�P
Ν�l�<���ð%����D�5��=n`VX�s�MO�����uZ��_��D������A�ɔ ��-M�#�1vўː�g������gP�      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x�ͽ[�$I���+�Qz�o�~�[TvtUug]��5��XH�fH?�s����r�1��I���̩�^;mW�������?�=���������CS5�/U�K]>~��/U����G����C3͇�޽~������˯�^?���_�����>=������������������C}���������o}X����K�K�X&�x������r�t�훌�m����������|�����|x�p|~��&��2o?�����`������/G����Ў�Z���ĕ:A�������w�^�?O��^?����n�'������ۻ��ϧ����q���p���Aֿ�8C{��on߆��j"����,^wx}=�~��y|���o���z��/�^`�q;��^NO��{���7q���X��[7������ӷu���|:�����#q��C=]ƽ�2ַo����̇��ϯ.��A3̷o"��A3U�_O/.��S߾�`��Y��3�J�{x��7J���������������r|Zק?|:>/�E�������|�ME����=~]�������O���y���3^���~|��`�Y��z�[���oO�?�<}y�/��E�\w�=~����������������t�;�TM��_�J�����s���A,L�ſ�<h~�?�󒸃{�]n�O.��_��e����}�����oZ�sF�~[N���n�e�~����û�_���ߵ�ۦ�o�D85������:�~X����y��{��K�ݾ����dh�I=�`0�c|�M;�g(��|��kS���7Lw`����x}h��RUW� O�u��<S=�L���]3޾�K�{��a\n���Ͽ�&��Ωo�d4m=N�w��C1\@\~6�o��HM3���G&�yՏ�}3��P$�N�!���,M's�C*�͑�)OI�噤��94���<ԣ�-��bh�0'�Q��rS�oʘ�N�$A\o�s��ߦg�7I�^� vle�P9��x8��E��_^+}߂�o����۽����6{��}�g$�A�LRڃ��{�[1� �C.��Y���M�����S��\3	��=D����p�2D�U
�Уw˭��߽�a��ӷ������f�}q�'�r��en�+��Y��G⡕�B�=<�g�����I?;ã�l�c3����I�^[D�h(��T�(�ѴFD��'��	�f4W` d_����k�@?�c�������?�����]��3zE{l���)���|q'�ّq�h(����x;=���7����r���F���P��6�ݓ0!����Z��tdC��h�t����iF�/	ƕ�e[� U��_�e��dǳ4��G�VuuESE/@�9v��=�C������!������<�B�T��[�E����o�*{��ߞᮮ[v7�53�Z�5�Ð�+���N^og��j��sc�pxᜢ6wL�[�۰E{�&b顮��ne�����L��G��;�D����D��\�D�P1��10T�w���CV(Z�C�ަ�������z��=&��嗽���R��٣R��tV�yN�u�8AŽs��~,~����ֱ����r��"Od�ӉIX�rJ�FÇ�
�cVH�s��g�Q��ߴ��7�����"�\lg("!C�%�7A�Ȅ�&Ӭb0Đ�zUVXBĄT����p�E�e����.&d��*�?��(����S.��k�z�jjk�
���>|nU�P3�=fc�]�GQj0�.��K`Ԏ����j��Vd�4���=]SL`t�"���6Qlq��7W[�eMK*{oh��#�0&�������]��a0�7G�������p�����裏��gW��+��r�p�&�p���,"X�����$�����˘H ��
@i��*�������7����X�`�ΤJ%����U'�.[&*c���:Ȭ�4�Ź!��οi���8�	�C�Peg�e��ݏ����C\ىR^�u�D�2Q�^�A�1U�P�C�z��xl_�Fw�o���A��'��Ca��r|�v�k�i���}a��(\���M��, �o�kz�B�^"{��;߾�`8V[�J0@�P��R���2�p0����u�-F� �FQ��~M"�wT�20z�17<�q�G�w�M���;]�S�S�Y=W׬Wu������E�p||��p\���=���_���5v|�%�%)A<� �?�R�{��T�C����ҫ|s�W�H;�\�I5.=���Sݜ墲LQZ�b�:CZei"�q6T�XP�Թo*x#F�)Q��3,�2�}�I�"�0��I�p���J��֔�p��m��Ĵ��x��}+ܴ/EW�\�2�R�S��@��f�	����'%���w+H�PPx�P��l�sES�T� �H�044�߲�I=�}�p聄+�#N��! J2'�ʌ�@���a���J�Az��LSm����`�*G��މ�"���	�����t)�)��ih�tS��>I �A1K	W�LDhE#1	�P�L�)��z�y�Peh[��}؈�rB~�����u��ka`ى�I�ڠ�2��!�+!4��:�1Փ8 �z�0���iB�k���}��)x!��G_�m7��4"�N����B��SH2@���(��s�0��&~E(�yv��`��J!��)n-��Bc�4���w��I Ҥ���#K�^�1�#=�lM	*Ay@�[����<;�N�ǵ^���F�j���s��1uʨ̷���)��"���_���U�s��i,L�j�^��{S!?�'ɂ�����N�S�E�����IT<8�E�] ō��#��Z\�զG���c��&��L�Cp�'	����O�J�/<+	&^���9%���R(2D8M�1�]��@P
l3?xr2}�����n�D�1�6�!�!��L�?骙n�LFzp&�G��4�,|N[��2P��C���)!��)῾R ��UF�ŕ R��C�C�@�n�I�� ������H�d���=�2�=zZ\�������p}{1��޷��Z�,^O�I�FJw���q��2�VW%�(�o����n�ZE�a�:��ˑ�7{�*"-��%��d"�o��!EQ�E��Y[jRLR����V8�y@I�eC2���m����կ����ٕ�2�pb��GS��'d��፳��u7%A&T�F���H?JZݳH��={��K?�K����6��c�.������?/�������29��o������a{y|����i�KO�ߔ��YW,�_�`^�r ;
��h�oԗ~�40�S��B��Д{�������_y]�� 0��P߾�p��P��I^�{�A(�*^.�/�]�w���i��$P& Bq�$DpxF')�4�Pz�O�o�(�t!�;D�*���pp�j��M���.�'�{�����(��!�´�	���_�- �=����ں\�LHP,{����\oNjA��vhT|;	%0��n�S�픪%��e�h
����݇�;(�wǧ�������¼8��������R� G�g4h.N�;c2Z,��J�|���~{^ˍ���k١k�ҥ�؊�;|�LK@�o��DLO�M��,�J!�͐��Z:ZY��v9:KbC�1�5�G!�Ap��-�'��3���I�ZO��6?��0	��v�2O�wϧ�����Bu�p�%�3�F��Cd��gGO�UG�Y`�#wx�u���<hxc�������ܚ�2yT��]/��9�t�����Ɲn�wʧ���;�l⭷ʖ�sx��}�|:}~=����z^~�lh��UMX��㩳U��Z	�Ά����@,�<#�Dq<ͅ��lQ�{f��8�p@g�r_g�\18:SJ��'�Ԝ/���Ԟ<��&��@�.o.ad�}����oL�^e"� =�zU��M�Q
��/�l��*�1��0��� ��O_&��yJ/���|W�l� U���~�8z���w��Mw�4    h�~+/�H�[KU�Xm���ajE���k��ӯu僢���4��
���k�9[�-������*W@=��"Ahi�`e�::��wR���[�`G�z��|n��J`��H�j�g�cΠ�_	vCZ�_�p��z����W��jX��� �\�Ax�;<-��w�U�`�H�v%�a"ո�;�,�|���Oʖ����=K>k/-�1���jM(O�rX`So��t��X�-X̀ŗz<������}�dkb�m�ޕc1���<;v�ޮ��v������p	�q"ۃ}-�a�h�@�P�ڣ
��
U2@x
�d��x��dHJ�X'��
;Fҁ^�xs���e�K_���Mݙt�+bW9��%�tR��	��Q^��iO�=?[�i��ߩ�	�0��� ��i!4o�i@�_�RH{b�Z����)�9\1&Y$�
v��A���Y�]�X.�D���p���7FJ��|ɶ�������4$�Tg��=��9��:BH���:����o�R����#Q�5�%��ڏ�#�^����+�1[h�����"#O}	�sv�8L|��E��>"�[ �o0iz�\�����Gd��3Q��E�����
iwI� {;C͙ul�ڧH�~�%#�Tg��	m�#,���S�<ZKz��<�WK�ܣ�rG|#D�C ]j 7�'CsУ��1VPj�� LT��@��C�B&&�Q������ 7	J�ݡ�gz,���LB�P���-�*""��_X������
pM��XؐF��	�2r�Y�Әgx�3$ư!���7퍝��R�b��_�Xu�_�����$rĳ[��?��b�K��Ghp� ;�%��lC�In� ��)�%K��oub(��~�x�'�YG��ܿ9R�bz�,3/-W�N A\��1��Ľ�N#B\;28A��$��QJ�n��LӇ۩c%��o���c"rT���E��*~F�4�/�P��j������T\*���ّ���K�s'�?�{����H4n�q�XzS�.��s���H(i���4@G�h�.�`����-S�����h� 7,A_�ᕚq�����<&vu]V�;���?���Wj�Gg���{k(�Rj��P�-��t4��_*�
�!�{>��=���Z|z�[3l�}��~�(6s�i�L&2"�Q����p�#����h(��Y�}�u姅���W���f}���/Bq˷+Zi��)�乁���Fdb7wFb̖�XL��+��DϹ3�W~P%Tӂc�dV����R��Z��	n (}D�'Ͻ�-����kUJb��jp(:�m�Ѣi&���Ah:��L���BBc�h#�8�(e��s�6e��c���Oa�v�U|q:&��̿-m��A8�Y�iIv�Iz	��1#}��J�������#�(��)�BO���k�e��0 �;��o+���M�4at;�$y{���6on�y-�ĽBv&���T�i��S�k(�1DQ���dfE��#�̕b�J�w3s�Ұ~,��٠�P"=V���Ԗ�Y��wbd�2O(I,r�bUy��z�\h�&J��:m��t�P���$XȰ@��<EZ9~���<A&Qq��v�-��s��]i+Ҥ�R3r��4Ĵ\���杞���Р�����W5�'�:b���Hry[墾}wL�����U�ݾ�~"Cn�(��C�E�|y͋cp�2��!=��(�����[�T�0�S
�0χ���~?�IzPڊy)�+&̀��m�73�~5��Y��!D2�&1zpSda�4�(���fG� �䱭��m��S�f�����+����e^]�����
B1S7#8)�[���-d�ó�)�����ʏ��;�yǠ������ͭjJ�Qd)֖19��Ĉ�d�p4�v(>���ǅ����̭�&�q��$s�1�V4�tiBW�ǭ�-üғ�OB�{��X��+㶪�t��*A�{k�X���`�_��	�r#�b�z.,
��Z"ɼ�-U�F��eJg�l��:�9�����F��D�����Rd����~��7yt�0�W	�h�	a�ʝ-&9Q�l�
��7l�v<;(V�&<����;�BQ&��Q����(�#�������*:���K���ې���B^�7j����aA$&�_���
Ef����S�e�!��n(z<G@�ͻ�(������u���}c4ɸs*�t�����׽�,J�A�m�<V�� ��훈f�r�C�S߾��J�9�<<}Z���-+!<���}��z�s}��MW�N�s���-�M��0�3�ڷzB��23C�aRǄ�+�I	1��抜r���(�	�p��%��-�A�{C����7��im�a�&X�⃶CD5s:FG-#���IQS
�~��g�F��#�`Эb��@�q���;˘���ɱ��xd�M[it�/2�4:cOF����L掔ȅ�b�KCa^����hE[r테40���aGCa��B¢��L"��
�2�lO�P\V�-��X���Hd�BF$�G�h(�-�"�PУpZ2)�I9$���x��͛������1M�>k��љ�s!S��b�PVD%�LR]3����:(�B	f�0�TU�sd4" #����E&���Ǫߣ`����,{��BcLca�H!
��b�����h�����I�Q4���B�M#1��@C)Ƅ阚t�nQG�W�3��s�"9B�����Xj�iD�[�g��vw���&w6��!*cH΃#ǯy�G�A�co�U����\u�g���i>:u�2S�y'���$�NRr��m�.РGWz��}�
����Ȇ�sGO���v�	�1WW���F�ٝ�`��Y�p�ڱlT�q5u}�<�U�wm'$�4�*��(4�ً��@d�\�@~�Y�)�_3EǊ�pW�"��0���B#��\�z�1�I8n�!���Q��y�4 W�.�	��)�/\���5^B^3�B�[ �d0^^O�O�?��'�q�������Y�x�
�$�|0�E"	)yGvt����@(~^���'�~�1%�Bc)�mo��c�i���d��������J����Ɲ�h`�ڹ`Lsx���n�,���2G�_>]�z��b���F��%$�E����,b���Q�PD(�UJ��44�X�'3�{�W���FU�^5��G7�6������y���Oĕ�nl�1	��tg p:f	-
=z�O������Z�o�D�i�g�V�ʪ�P�7PFmB�n��á��B�Q|4~D �I��)�WVգ#� i��7W�L1"��0��:;��
��L M�[�~Ųώ�4�FZ�^�&�  ��� vt�=�� �	�Y����k[*2"r�P����kʱ���`�)��:�V�H%
%����ʼpS�F�[�8�E�Tz�ы��fB3(4<��/�|�D���,nW(^���YoB�@(�K���E�zH�XzG�,���G�;F�_~t�;�L�e�m�C��Io�]�g�w�$(2�}R��a޹�k�h*��5d�NV㛬�n� �+�v��߾�tQ��7IѤ�0O�O�(�����a}�ðaL�o��A�<�|i�}!1��=KC�QH�X�z��I����w��������ʁ>�|[~n��~� ff2<R��lԷo�lZmzt&3RDwI#a�s
�h,F%�ΒP{o
��ai4�]/���Ĕ�y[9bw�&c5c�w�]G������KTv�
��s������q��w�I]Ŧ� *�� �3\� Oo��ϗ7[�<���Ϭ�.�.?�"��Ђ:D�c�����Ĉ%er�i(��S����8I �j"t/�X�Bf"i/��zK���;�������lᘠ	�R���{۽]��jX�J��[�[(1)�4�־p>L+P�w-�j�xx���4����/��}Իx�N����A�(	���Π��f[9�n"��d�4�4 &2"�_���-dB���R*ݢ81�e�y���=��8-�%*# )���&�%��m��x�� �<$��3~�b��5,�+�0_^    l����NtrJ,�.��Foo���d�w�։&��ʕB:P4<�n�h�wD�Mn��>�2��E#�XKZ2�Z����>ޞ�ݳt.L����uR0r�ѱ���g�^��:�9U��x��byU\_�C��`\`y��m������y�1���0)�2�Q4�F?Ú�z�`&p{8��7G��jb�c�}q�\ ^�[v��-�)̚��&�Ĵ9Rf �VG�2��r�q=ev_�ef��}劚��׾r�NE6�<�9 0����=��HO�ۻ��f�q�a#0���4˔��L����� c��`� (�Sĭ\�E��4澉a�Eh,K�:J�@e�W��T���!(��R:Eޕ�Ȅ[���H�2v���4mƣ/>ֻ�O����ܗf�vbj�"0�:H�npC	ۢ��T�#���x��^U&���0=�$�pşJ&�C4�J��H�X�7*�+<!a��.��N�<y_T�Ҭ�t6��x{���d���\BHLK.����R!G8x.�6_�߹V�߻���[
 &��h�:E��VkG==�F��'�y�]�VM���]���MO9Q��n�:�2q	��x���^N;b�����^3��DBR�S:ByZ��=&"�~0hymfR��	�'�+7�ަ����v��tO�Q&�,z2B$��p3ܴ')~�|в���Rx��y4�1�D�����W�r	�_��gr��fu�KD�c��I��q��@=[l*�C�rl��υ��\}\���-�C��"QZ/��Ţa�(D
�!T0;)\�:A�`�3�(�!��`�2���CuN�Q��G/q�,*�A(�qe���r��KU:� ��& �_)�A����S�T�4���o�t�A�-��C�J)��˖<Pl��@T	�c�����IU'����L�TAPl�:I�U�<�ht��\?n)>�}r��}rn��YW0���V�lA�|,��g��n뿠�kj䐨�9�Q�����.I�2vM=�{�D8���@�cZ��� ��2g�n{�hT.�%�s��U�0�j5g޽<-ߧ�ǧo/o����ۻ���g9}����¶u�c&*s.�Ŧb/:^d�@ $�M��ʸ��F)zt����:����-a#ۊ�n�K�J�ԃ�X�v�2o9dT�t	��&�]�b��6FV!��Q���8����W+n��Ř=��Z�����2���j�`�&������1U��X�W]�1�ZY!8�7&��u�w���6�F':֪��F��NI6��j�T�hxc'y�U|R��q�plՁ���.�x'�V�D��L��M��()]��%��h�p��ɓcy2	krTy2l �<60�N��z�m�
���ekLX���ej�!(��M�1e�(M�&'��/�Y�3��SC��}L���$�JTzf�:q�+H�c�Bu��jl�%�O���"���&L!��h�e}4�.VH ��I�'=h4;���P�c��F5�K�j*dc��%�x7/�����������qy=��u�����O"���"���֣��6�&�U^��%ukkqk.��YD���G�4������tB�mGD���z��3J�%n��q����H�����g�7B1-��'�<OA�q��T7�ȷ��.DhSxzrq��vJ{�M�40ń��x��h�g�=W��A(�A)0��vՊ)�Ds ��KL@�{2e(�2�T��g�:i��:M�vnB��n����2�eR��S��k	�M�Ȼo:�\7b>Zt��y"�g�2.9�Rb��2��5I.�2c�a��` ����I�Z��8�H�n�H�8�m��:eB�z�ֳ��t9�Yۜ���BpL� �r��f�_Zb�*�\	%���u�/#��zz.��W"�B(��qe׺6Zh�{	�D�{��A���O$͉8�� �in�Dz6b�Tk]��rw��wŘ��86����+j�!t�趄��1��d�S��J�(񼥞4�*P+Lrp�?"#$�GP
̬n��j��9ML�5ΔPJj�QRI�׊\�ѝ����V��T�ۘt�G��T�UcJ�gF��)��I�Ttk�Z��/-1[US)�FxR�H;���k�;G|�|g��ՋИ*��h�r˫Ah�K^`F%!�_$c1���6=����E��P��1��Ǖ@sE��m��)�#$��u�P��As��B�-ͭ�e��,{�� �8h:���&������I��ޘ�U ��
"U ��14��6��Z�z��M1�R��\��j5���\셦R��r��J��W�X� ����N3�̩x"YØ偰����5>��	�鮉����훨��3u2�]��>�gme�1����Ā��`|�>2M �c>�9J�����Le�n��sm�$B��iW���S����M*m"(�l����2�bk�A��7A�U��Ù��0Ԇ�j���tFUB�p�a. !��b,�aYT#�PL� ��!�;A���NQ��䷈<;��?�?;�I���QI���R�
8zy�ff�^ŐJ�+R�kY8*u�|ht�vR�^��P(S
A�U��d���!�0l/��i� k�(���I�I�BPlc��̟��U�	��_.Ųd DE�)!��aʵ�0�=9f{�,�mnDUDn�}��!X�;�wvK�����~_W*!x
�,{�׎i���Q"�D���L�	!1Q�Jj��wL��z����1ђ��^T"�1��@���pQ�/��UK$l&أ�4�V�Q�j�5�mp�`���b�����Q%����v����݅w���d�6�uUKk�fB��b�n��S奄��bu��#�i�ƚZ�Q#��H��Gp
L7j
DD`���
��Ȕc�h�}�҅��>]�H�0�a�N��0�I��K�e�L�G���ǻo*��k6U7�Cz��L۰/��c�7+�3��$���E`��nn��Y)1r�f�	]�h�"K��t	@X�MQ�JN�i�J�\�aː�t8���lp�Yټaθ*9s���5�MlZ�
i�$YA)�pTϤ;	UDX�����`єb3��d�c#(��(��w�*�����0i%6�+�@ ,%:#�j!�ᅠXr�y���y�����GMU��%�
�"4�+���]�tg&�!���О�E��E��xC
=\fK�\FL�N�V�M��ʼ����J3��(�_o7�^��*����d��(t�jW�4=�l#�Gpl�UB�a�l�����Ty�9�"��3U��>f��qu1
h5���0�\�<��ȾX���Mͼoj�i�p�2N�wP8�����7�l�UQ���������49�EU����Zc�3n�Ϊ2��԰��]��4�n�BXJ,�ܻJ&_�n��E���< ��y4�v���̟�qQ4����^!�b�z�mo`oB$�qb:x埞�;|����OT��|B\���j���G��#�R������4M�����$��:
!8�z���b2�1��[F�&�U/�D٭ǌ4���j)��P�R�1�E�0�^�g )7)��8h����(bb�<j�XL��@�� b)�^�#Μ&�/�#_��y0���v�yUI�����ߩ�.3pt�C�yu�q���h��R�$xH�1�C	��ؐ7J�F�wC!��gI9�
B��e��uf�W��cN�!w�n�&�m����k�	�fBH �/Q���rJc��$~C��Bӄ�8M�{�4g��9_z�ҷ\Qr��oې;�Ch�+V�,9S�KS�X�,Lk��E����Z�1��~�jϴ��!|�cb�V��z��/d���.zq�~��q�9�گ�M3���^Y'{u!y�4b�*f�f�@�۱�y�P���gEt��PL��̻_�&ԗB1�M!���Q��]�-��-$`XK��Q���6�8*D��+!�M����M�2�"������!�n�$3��(Q���P�R���K�� ��Y�kx^N���q�4iN�߮�@1-f�q�%�    �|�)�^N��,P'��Q^a\���Z�{��߃�gsÒ�C��o�A(+��Jt�[�/w�[N*D#,��7UV�e��K�ﾨB;o�SHX� �hv1�I���jv�ߖ:>���y>�|����û�_�������Ӌ�����̥�Xv*�ݓZ٩�鶢f��
�V�e�
���˛����B�k'��J"0�$Q�&x�學�0�BW�R�"��%'��in�;�tAEHL���HnY&X������ f$���Q�5xc��3��t��*��1���@	0�Lz1<Bc-�"�ոh�jx�����/��*�K[NuwJ�j��:�c(���/���cP䂤	9&F��=1��Q��99�R^���JC�u�!:ɍa3d|��$�Y:�m�k"�ļ�ju!��s%SX�)��O �Pd
�"�T��$<�B���i�3�yT-~=��B����1,o�߃%�頫��
���<�������☆���yɦ����o22˂����m�!�.��+5� l�;�b�nV̡���խ�U{i�1E���ʤ�9�b��Bמa\;E���������|��XҰ�
��SS�UF�J��L^��+���xU�^OD��7��|��))�X�bH%���t�c��|4���C�-a�xzz��X�I�Z�J��SwUq��j�LF(�S�z����L�<q�S�U��5ϟ��I��I���������Q�r?�:�ZQ�:skԓ�)v�RR�|wh��w($�G�X�|`4sb��1��t�F�&�$����j�d\�|b��	��hT���5slq��������ukTp@����ͅ��o���es����6���L�	�)0�4Y)� [�MC3��GG�����DJ��r�QM`�D�Uk%vDpl#<h�.����ɶu��0��i�RZG�Vc�f	m{�F�x̳���-���������23���훨��;�2f=BR�do���W2��V�BVޭ�	���FPl�UUc�;B�-QQ�v����Z��K��|AB\ٙM�e�k��Y���s`������'�a��(GS�U�QO9��ApJ��x�L�gL�^"��fΙr:zep�P��KC��KW�>����#�� !�+�F�
c�k��;X�X�?�A1&e
\74wؙ�M��+��Uj���1��S����+j\j33��BW1�b�-�a���uw�����Cf�V<�0"���Ad�8�L
�X}.�����Ny��d*V6�J����i��"S�A)� _�x���29x7�]SVxP���X<���E>�4��8�~徃����R�4w�\�bt;Bc��2���	���p�x�T��M�ށ�:iC$�5������������ٕ��php�-Crs5��r�1iq�=���ќ����zS�֊����~?==}8�4^��+�o�V>fI�/�5�݄\��X�MK�W�9�h��C����xB���M[1w�L�]��"���=�1}�)^fzd���L�b��8��ЭW��RV�z�%�*=&�BO0Қ"BPly���)��C��{��CX~�Ʋ� MD���e
��m�Є�QDS^W>��X�1wt�eF�'B�C(�8��Cn\ �������ʐ2�Ei�w0�X�PL73���qA�B�u�bB��'�Ų#Q�D_.��=D3qm����M$�����4JUNt1%F��ތ���61ƗWH��-�B�����C�rPEz���2��*Qt���	oL���)ckN�h�T��2W�w��W����Q�)���V|v��
U������Gx�s�i6�1e*	!(�y̵�s�UW:�N�Cy{#�1>/�&�Z#2	�B1���Z>ͬ�Bd-�q�V]�qXZ9 |�xz�����?Eٽi�s2z���Ur/Bc~��-��W%T�b�����%��NBh�w�p[R(�	�z������B�	�1E&�.��8{B|������~����И_?40'�&t����NW�4뜘�}a�������)���N�����8��J��ИJ�jޭ�CL�qn�l����c&�8%�����Kvn�CH����U��ևk9��������s�n�7=�-�Q�8���(�
B1=Ut\���d
&�������c�i����Z{4�Δ#˦Fh�L2�z�J;���Q���4#92e�u�zD.�f���\|={� �[�d2 A��e����м^��kX$�����v��1Q"�&h�c#+��1����Uө:b��G�k��)����)�䚛�+3^��o�8�����mn�d(����$���������a&�+�5Y��4���<����#B�y�ŸMǹ��:�4�����o�F�-bO��d+!: a1޴$������;Ah��＼����]=~�\����|�g%'#�1�L�"z�k�d��SX�1���hQZmRIb)�F�Z_	�J�������ØŦ���(�"mR�D%hZ�ǧ�����+�����eJchdöVZ�5�m�u@�!8����0h��~L��*BR^�!`s]�O�������~qǔ�BUJ����B�߶.�&���H�9+������$�����
��m�[�?�L����h�(�ih!!�i*'K(��F/1�����9ژKXDaNsw��tY�>��PsN:G /)��ɛAs���g2��������� �V1U=_�;7��A�����k.�v��߾��?w`1�>Q��D ��Q�B\����9�Q"u^M�zU�@�*��^�)D�\���k�hKL[p�hK��z,�
Ŵ2"� �z� ��k�5E�Q��@fbM���ɴ|zeU��)��}�F#���t�Ĕ�]�/�P�*cS�
q�WQ��'0���7Lsݳ�E�I���/1
	�2I 0ݖT!BdN���0�WO�<|�nL�0'"A�1��kR��#i�_�W���R`��Bz �&Zv)��.ET"�͔��I[BPl�à��T�F�?p]s!��.����.�׏a�@��lo��	�mzN�j*,k�cr�V��ZϤz(�H���P���B������$:U&	e���[��t�L׷�4�j���?#�1���ڳr��@B��2=r :�r��(���Cǅ��Y��"��Ѵ�}��I�bH͔ԛ�J��u��B��b�=�in�m*�"$�"n�bþi�;n�h���Q�����1-�E`UT;پr�Rv�vw�v�x��n%����y1��3`|K��><��װ�P�"�Lz]< �-�"BѕZ���%�<�1����o��00</w�r�c��4��O�Ed����������_a����[�Z(�Z���~�i�������jL��|:��.�p�e�o�D0�G�x�7~VT�Rmյ���\�N����/1
.����ϗ�ϧ������Ml����7	Zk�$�a�CK�� M�7<��pR_ӓiז�k\�����}��p|���6'/����=<�|���������5}�e�g��D�z�"5�6�T�p�FeRq� z`�KTw%�Z-SU�-�k�������e����͖ioBCY{/�����b���x�"~"�2�#$ܥ���|2�h$�z'M�CM��O�LX�F�1��=���c{�&�q{e�0�5�tZnWv.�Ѷu���7c?
UϦ��F���J���-�|x03�M���f���훈ǵ������Ų<������e�>~����������q����=���_����ۿk��;�؈��o�"��2�7��x�@���%g ��B�U&n�b�p�&ƍHɘ���L@�H 9zH�_�w�H`��¡Gg�>"n���(^��EYO�Z��?�{�t��E�˽S届�8U4��|U�;}PJ��G]����>6������[߾��K`{�CS0U��0O���	@a�~El�l�x��sJ��`�-4��Ϥ�YH���7n�f̊�]$V��n\/�ͥ{�M��@	}L1���AH�0(M)>y�e���xvޒ˚C�    �.���4�H��Zl��8�NWux������z����/�p�&^��P[5}r��V��������o���/��7J�G�E�[���&n''�� @�ET<�̖'��&�i3ϓ��Kϋ�Nk�e���˘gF8��1�B1�`i(�6������*Fh"Si����/�����Y�M�@t���8�e��L/���i4|0K�i�9�RBT=������љ�\����0e"���$�ڪ+*�×͖
r�x�$&���2���]�8�\�����'�",y�������O�ewR*���ܕ�ܜ\��InZ��_;$��^�Mi���h��	蒠��p���;�wt��2Qa�DEz�ed&J� ",��VHX-���aX��b�Q��0o��U���69�\y�̍�F7�4
w�m�!Uϔ��ڞ���M[�6"�Q���*����7���������nW�I2�[FPl+�Ө\V�wG��V$Au8�O͎��E�S������B/c�*_ptӢ #U���Ӧ`7��Fӓ�bv��'Ӫ��B�w���C��hȤ4%�����M�aZ#��.)���E�R��q�;-�~��A�u�.��E �\;(�CT�@HW���C���F�J���p�����&��2t�p�Ra1�H�0�mmIQr������"(�[��=Ac�Yc��M��]o�i`(�{����ߞ�����|>�|���������o�)=�4�ϊ؁N����	��v�$[&���	��՘�!(�� �x�#>OP;��dܢ�n�5��p��~z��J�eqeo������"(��D�ndL"�L�[��⧚�uQep�z8;��"=c�m�N���"Fy���5QM,�p� �n�4*7�"l���9')����[(�:#��N}%�N�@�����^�:I��g��[:�d��Z��^+U@	 έ;(�a� ��3�����w	}��V1`1� A�uiTL#1�b�m���T_/��Us���������/�_������z�������?�����q/���4�Z�Z���z���������ݷ��	�����������i�����������K� �no��o�5M?�U/p7cفI3vIG���,m)/{��a���eUu�anOO���w���W�݆��K"wz�KCE��9�������(��B�O�ϯ����7�@��×�i?UPyU!��0��wO�?A9_����6)��e#��?+�į��us�͂"�:$�&�Bl��Z��5`�\�w���KZ"�Z-��7��y��.hJ �:�b�T$�_�ԛ"���*Y�KE�ܺ�[<�l�nh$�V|}���}z�>=>?/�؂�������s��'���Q��t&��;��6�rC6*Ʊn��w˹R�#Z X�S��T ��\5���އ$���b�!l���ގ=Bj{���9�L
�����
���ɲiA̽[ w��@B9�m�g��<%႖�Ƽ�@se�+}�&�������RS�U��3������?�u�mE�F^<���t�J�.��2W�&2��h"_rw�`��(�l=Yē^�C��s=�v�*m�_(�7T�B5ƙ?����i��'a�6i�nW� 'd�^������A�M4���S���ڤQ��1d�\�5�-�-��s��p�@�^�a����WC��/�����̯�׉�����7B��^��Uz���݅�MB�o� ��'��^gx����)ߑ���\F��J{���04�4��*q�o� TI�UV�����[D"?����w�h`i�x#4߀�G$�1�߼��Q%98?2��`M�a%��E�)5WinW>�J{3��4�R/�),�=x��OL�!�1�P�RCe0�iTiwz6��V#&���]�F2���*P��>���v�P�Ē� �����M˺����������$Q�+ټ?(R����?Sw��S�K��چjL��]��{�#47�y�kR�2�����&!*���JS��3&!�4�)����y'�J��l�|�d����L&�Խ�/�c���!	U>�4W������ ��ki�r�h��B�.�uA����p��T1׍i փ���;<ZX���f���Ą�'�ڹ����ʳ�t"@���4�������������z���������K�}~����I�Z6�����e����+�⎽���6g����� ?����u������*��*m����[ЍA�u�B7����f���W[X��XI�G�ܤE`s�R�up�~��H�\��2YT\��&+���%���+Qș+�	a���՜d�*l�9-�.����қ+Q�*9K;�·������R��Ӥ��s
�*jg5���l�H��Ӧ+� 	��h�gD�y̗�G�J�g��!a5��)��9^��-�4N!A�%�*\����|��i�.b�ךM`F�����+���dT��*l#��$M�C2&ce	���~����R�O#-�0�H�J��-���i����<�|� =W�
8[i�G��4*�_z���|�2=W֙ �5k_f��'z��|n*�*-C%�A�J��#HTiRy�k+-<(~A$VZ�G4Pb�ֺ��
(eBO���E�J{��wVZfkN+��e�	E�JfK:���"J��Nia�l4$*�9�zc����ШL��tU����m���I�iU��Ҝ��d��(X˴�w!t��|���:�E�2giiX�9�4�:ice�OF�#�9-tzr�TɂJ;�y���B�-�F��6'K�����O�5uE�Js"2^�4,��$�D�(��E�*�������.-Rݗx�f,HHQ�cٗQ�I�Jcd�U̡7V�d;d4�������m��t��$�IO$���I�i5�2�&����sK�ӊu����M�HQ��7iTi7OF�	˺�-�e[L�����iTi���JL����Ɂ�� ��(���L�K��U&��M�Q�]e��1I��+k��*M��n��,seڔ�Յ�ۣ4CE�K�VD`{sfv���r^��^��n9�:���U��S&j��a%fd4C��E�	O��q�"{��_B%Q�sё�4 g�>����Zc�!޻:��P�j���GJo��:�8��;쭀jιHj���H��F�&�Ή�$�2i)������D�2E#�����b�@��Xk�CF_>�b���كCf,Q���)-ST�MI,şѩ#a%V%�j���Jf�HT�I��opbՙ|�&0X��P �Ʈ�h�7ٺ8�X�a�l����D�iHk���&Q�ed�S�i���#m����
B X7i���xz�CK���4�8�6"��h��O\�k,m��B`��$�f�_*��h�����U�e�s������6GLms��H��2�|�}n\�,��#C���F��M���?N�V٨`j����� ̄���p��`_��/��h�&134߽E�J4B�y��mZ�J���Y4��;[��J�rK3�i)G����5 hP�%��&v��J{��wwb�aFX��n���a��-��N����� v����:��J���Ȁ�u�7p��rk�ͨƞ(�eLEJsf�}s��Y��=zcYK��;ky\�*-�Nhv��X18�"UK�--���A�_���&ͫ��]^����F�:H3:� ��v�u��]� - /�U���9�~zz���K����������ۼ�D��~^����Y���e�mș�K��}�����*�m�X����&{�Z����^)_����	`Y;�t��4mP�8�ZK�J˫���AY�ڥ+=�n�IHPi�M3r��T|�k�Z���J�^2
�ɲ%�A�մ+߳C���0��>�N��l��G�v|�TU�T��@���KXiO�t][c2�c��]Is1ܥ�tYT3�i�gԊ�J�|�*�7�`�:�H���]��M�D�z���A�!�D�K>T�&��r�k6���������� �O�^P�ߟ~���G���������������ǿ�������xFҞ��T���i>�����۷����/�N�ǯߗa����|����\~��۷N�<A�Ϝ    {7M�����}=�~[xsu�C�Δ���8%MĞA�Rg���"H�z�����|e;x��I�߾�s��w��b����o�d,�[˽gׂ�s�L���=�~{:������u����L��|������!�ܓ���z���)_�x���)�Vk�y���s�\l<�Y�>��\\?��v�Էo2���q�>?��A���mZ��1��Ǹ����gWqq(.�Z-��������NR�&��!b� ��Wܺ��n���8>_^��O��\"��]��S_g���x�u�b]H

��oo��՚����(���z8��N�>^?~:�z���f�`����&>���$)��1�@�Z�1'�~��R����X�"�3/=lH����������O+��x���21o?���Kw�_rw$�
��Z���x<�~y������~���������'�^�#��rS�)x�y;���I�_
2:ǲ,�e��탁e�d����������9,����-��7����E����D\�{X�
�diΕE�m�˂�״M�~�����7�&����u�͈�G���}�O�"9żzs=���S��"h8�Wl,�j<?�f�C��Y?�3'��֜���7'�4h�s~}���uϊj�ṷ��SԼ�|��Η�Շ���7�ɬg645���s���Q������c\�'��Z����ib|e������!B̠w�\�G�ob,�W��oM�_�g�+���>Y*`����O&oh�f�EG���
 ��!�kRqu��'H�2E�	�c�jdJ]���#��O���&���;b�dAnb�u&�!����\<��F1<�t��[K�����݈I5���]���ؾ��o�6F�fߴO��v�1T�&�U�QPͤ�:�ZVK�XStRd41�8��D�G+s�S�/mq���c,Y���*��+ơл�V(�ZA0�n�\�b���WNRW}������id�ܚ��v9��x��˗��'X�T]�\~���H��اrh©H��-Jp>;��a�{��3,��POu�2�$�j3Cjj����M��E�v1^�iY�Ȳ���p
|ú�ka^wk5��8A�-�������t�ۧIt1�V�QϝS���+�VN����,w1ieZ�ƺT�=��Z������+�2��vtHŨ[4VX���-��6�*�3���<_� Ncd�qZ��P�16�Z ���������]ă�WX�c(E�nCi�	t[����ۄN"
��A}��Om��l���L��ǟ׊�M�_�*���TX���)h�0�2�� (g�V��RS3L�p;C�6M�L+�v1��Kٛ�i�Q
,1���3��dd���XY��E�dU�r�!�5Z��b�L��c�5;�g�.�w����ީ�y�59�>�%�*;��2z�"������/��"3C$+�sQ�W�;@����k���s�6��z�����ut����T3ٺg�M!M_�^�/��K���c_`p���Ɛ^�Iq"�3�z��`���o$�_���^%z�J����u��8�3�x���NY�̚��ĸD�����Q�_��Xn��xGԴ��[TM1&��0�b���.EQ��.R��LZ�n���Ɍʂ�;O��n�a�ٞ�=}[A��|:�����~�}�z3?�/5;=���>=mA�u[�ʺ�T�_�W��Gկws5��}L~�/�1��J"0�Mx��}Ӱ���c/����x�8Kɕ���)�F�+O#4,�ޖ?io�D�'�ғ{�cY��ՆfPy��x�Tv��jz{S��S�ۛ
k[2���r"'&�U3�>�P)�)\|7M}�#J���F��f��Բ�@	�� �����	*��
J���ŖOu���K�i��Y>����$+�')ci�$���1�������zGx!������屮U��cl�-1(-
���k9	�1 �)���L3���s���8�W��o����E�*])��A�bd_B:�b̵Ѱ�����r������Ἅ^��ȶ��M���W�l������j@��M`D&�(0A��E e^Wf���,���A�U�Ѩ\^X,&� ��Đ�gȇ,竣�WcP�y@P:�>���ߴL�����!1�b���-�#��B �$40�X!���1���+v���g�+��jT�P�~θ@3X � ��L��LdA��JH>��[5Bӫ^��pF�P��1N�}6����?���W1��z�M��w��/g��q������G5��6���bL F,�!Q1��4y�r`�{��e�*�e�K[-*����O}+{HQ%�4=���7������j��urxɆ��jdC�RA������=1$lgncH��x�L
�"(���J��1��J�j1�6@,��Dp
Tr�6ݯ�u\IŃU�G��1��: (*Z7��8'1-����s�z�i�s����l��|��
˛�����.6}�ؤ�#,�"5���)z`��S���������ЪDN���u���r-��A�T�^�ŕX毓,��u)1�?���A���U�����J��X�?��ME�8�_iv����7JH�H�N�Q^Ͽ;���;�-�y�D�
�Y�8�S ��������^5����,%TT�K�Z$����)�oCL�N���\��i�iU�v��>���b��ӣU[	�^��4�̃fl��#`��Hs�bZ.(N��O�׌�14�Z������'���h�o*�2ɽA#�3xy���{W�e��W��m:!,%�A��M=P
Ԏ���"�SZM:�S�n,����i,��]�h�Q��ɡ�55��oχߎ����y>�|����û�_���⿁����x��o T�n���
x�6���o������aL�u���-3�H�E�fG�P�sc�5�mt9�j8�Rݼq�W �y��|cL�H�+`d
濐a�o�I����K��p�E��U.��ѮYk�3�)	�	��sUr2�a���>1�|���H�}bT����dڧ�wƨ����H�	�h���G��\�������-�F�ٮ�'�%���	���\�>�w��ttg�&�����LoW�H�F��U�B'�����$�G�D��05���Z�B4�q�B8+*�1ܷuY���T���a��ĘTj\��*� �RU�4�jQk�-�0���� Kϥ��Z��A�9F����<O��pER�E8�u�ATd:�r!ꙤCT+Y-?f�ܪ�z~�:z��������Z#�)�'�]ՌN1�����x�$R�(�\q��!��5$�N�x�s9�v�� T@f@e�ef��sY��z���Z�3�_�Z_+�"��~��q?�[j}�}'��G|�=���ғ#> 2`�����n�.��8?��iX�r��-����V��PSzq�b�\@\a[N��UL�W����U�ַob��
$��M�αi}��Xނ��f��4���D�S�@)�S�1b&'X�ʠ75S	[(X���a4,��Vu��+���j�ڕL�A)O�UWL�A�$�z�*�~K��oL���}����)6*�b��L�2i�������y���vj�t�điX�<]�����ĳPK:z�ʹ�"/�ڬN �S�8���-qH�j�|<��r�l7�WLW]'���x�MFc�lIsK�d��mYUUeDhL�$�&f�A��7���t�APJL��o�g�������nZ��fV�����3��P����7[�fF�L3Pn18��Z'C+���1��$ޙ��Ř��t~(~����i6�+�������C ��I9�)�)T�Eۼ	�5���Wa�%����������}� 5�s������<���"(��	�i�� ��D�r*.3^��E��I���@?S_G�gB3�<��Cƺ^DL2�I�\B�K�/殖ɛBPJ� >�N��BT&�܌f��O���F+��n�CN�b����F<Va��}��"��:��,.#=����"z��D�4%mL���z�e�!���6&�]��پ)����Y;���i��)�ER�ns;������S8��\_�^��dP:����k�(�F��PP���    wX�Q�o�8T���2�!�>��(GD���=H
������L7�啭�ڠ6����6��e�zR����H�ҙ>bފn�^ŝқ�]��'�B�l�zkr��I� Ŷ���i�_;p4���
�8A=۲-�:�nA}�	Z��1'�g��@׌0t֍_hT�5F"�*W��8�M!���,m�ɕ~�O����[�_�Nc��+�c��Ok�n�OxW �o"��b��3ML��Č!�X�ǟC,���%!t�Ax��M���%�4P&9��ܿ���ƀz<�c�i��r(z�Cˡ�|L���<������kY�#(ݾ)L�	����4�i��+�yU�mc��Pd�kP�=虊_���>&��&��&@�TXC���9B�-b�y��V��K5�<��[���h���p&����B�%��G	I}����p�����[���[G�s��׮�j�;U�]L���M����4,���S�1��w;0���pd�1�Ԅ#�������t���1��6�QK;����7%�N�]ߡq��(�f6�����훶�1��]��F�A� w�`L+v����P�'e��_p��!x�P��wa�4x�Jc�����p������(px���;h-VEe�b���Cp�n�]t���]��}Y�S���
,�f�w����>��XfHM1��Z�Ԋ*��a|ُ�%VuЧ2�ɬ�V̽l�����p�e�o�2�a�1c]ČTN�Ѵ�D�2k�cEfB���R�1F�&5W^u:���}���R�1��Z���5����DCu���yF�3�+����в�g��a�q"a ��4@���ׁ�%F0����>9�N&F����HhTL[:1U%Bc���7�FL�K~�;���H�<��Ͷ"�h�;��[�Q&S��`0��xj\G�0��j�1��ؾ�1��Cg F:�*l͵��  ae}��j Io>�H.m!2/�!5/�MP��}1Ĕ*��&"TF��$j� �Ԟ0P����"Ah{�)I"�G�%�'���@If`G!z�z����m����M<:1;,��8V�-"��˭H1ĝPb�b��@�S��K�S�z��IC�|�,BT4]�@K�FO)��޿⻫ ����%i�R�8��#�0��=�	���m��4*'�$�G�����ɽ��	�Q��+<��g����no����l]ޜF�T4�)��7-*C��*e�F/���f��2sJ�Ki8���Ntŗ��U 7�w��pl�S$����V�=Jc�WZJ-DpL��3��8����)�칤�q��=�O��%]'��3D�֑�4���
4�@a��zʷ�b�J���
�<��4�T�P��L�>]ފƼ�>̯UT��V(RG�K)^>u�W���A�>: �=�����ݾiL�n�^�-'fq�^�-�J����X�z��
Ƕ�,��.Lu�"2O���1��r+�|ꈌ����`����M��g�e`+��AU�f9ir�ML� =7�I�H�c�4���`l�S����K��O�aJ�3��P�w�M��f���W4Ņ�6F���_�26���̓%E��4��V3�t�c=�:xy�ֶ� ][d��e�!�]��q�ڪbq��&&���۶�pB�������h݊u@������#M������x���*�ML�L�K���4�&��Wdd�Dz�Rrhx�Rr���h�4i�6��֣�[7�KsN�*3�Lx�F��	��QV��1'Y-���3���1ݶU��]UZH�+�m�ʲ>�"���%���δ�D�V�Q�>�"�S��!B��_��o2��]����aT�μ�3���h�]��Q��mQ�^n�
%[:N>�Ȋʯ�P6�޽���&�bӬ����8z�aP�KצobR+4m��}8��mF�|��^NDZ��r�cp�/�3�k�-�7�q�:���.��cޫ������aR�����Ђ�(�(a8
;�3~����u�b��zx73\7���J2]�Ì^X$ g sV$�2z�q_|��߹1.T��l�@�g42���S��Hֽv�������[�ӱ�i��X��E�d�	���dA-!Xǔ�T�v1��j!�ޟ�.�����[n�.�>$�)�z�ER$9����Z- ۢ���%�#z�큲g�>�o�E�I�K����	(�o�p(b����	󱽃����12>���Xk�U�ѩ��1dީ���۩�k����g�w�`r��}���V�m�7>Sd1L�� c`X*E1�㨨�1��_w�B��2�r:#��mg<�~=��oܮ���� ne����K1�q�\�V/�l(�9�80*/E�q�Qy����ߥUd��wV�����z�;V(�\�D e�E+�x��������ި�&�����U����41���&�3����*�����j�t��2�VX	+虹�+�Z�������_��t��1&H������=���]A�t�"3ƈg��U=_��-Zsw� ��2m���훈ύVh�mǘh�^�v`44������6\��KYyb;�����N�BEVl_Qş{�/��C9#�b���5��~��iG�Tr*^�M&��.���#ԛ�n��<�BRdR�[3��L�`�l<!���P��2�t�8o@����V�;�� k� cJӊ(� �r=4����P��%U�M�ɀ�����m�H�B1T%5�t�u�n�
aJ`S��f�~�T�,.4x'>eS�lbY@�O�f1}��e�H�J:m�qdb6`��+��;��yb��.�+N�vB����O�TL�&�c>��e��n4VBz��^��&��� �	PE=�t&,,�Xl[�aX~�D+;�5�+g 7�)������sB&|A�i4���,
wb,�d:��h�E1�A�_	��15D�S͑q�j�����|����2z)�=��F���U���;��A뎃㡩6pv_sSeX�"*2�2U��O�íiR�q�X���lz��
�TBP�BP�	V4��S�o��I��XlE��p�-"�Gpt��#�T}�ʐ�������r�2���:��*lh>��(��-���Z�nsŪ�#[�-	v�SF�XX�y `�Q�����T;�$�zBpt���t�W��2J���ux۴ k��2~���������Ù�~��<[�i�}�Ǵ-������g3o��D�1��f�/�wx�`��7��keJ��:?I��N-�ׯ'�lKH�:�.U+��ØCr������o���h�Ը韚�}D�RT�ƥ�1E����{Kr_�L�֥o��T���kO�|}>��8{��w<��t�u�y�MB�4��(�恢u��=SQ/�g�����U�ZF���8��)3���xQj���h�Um���N�?أ�X��h]FB/�<�)�t�ڀr��?w�u<��-�F������,V$�eNu��>@�eQo0(�)ĐU"����-�&"�j�<M�쌥��T3ζ���_�޾�3�ջ�r/E�eB8Z������h�6�]�C�۫h��&C)/d�0n��|�����#Sè��|MLM-=_���aD�����Ƹ�@剭z�����)UF�]��	i�#y��6���|f|Ô��F5֡T�v#vE=��6'fw��-��i�v^����_T3�ٖXflj�xz�Rc۪���-�e��u��
)L���F�bn\=�ʹp�jq&_��IL�@�+��t��ѵ^���i�t���\���r��Y�s���f��� E��
]�Zݎ)��Z�2Ff�M�O1���	����]�2H� ��M�T��.���3������Z��	���z��T+��^�]<�C����1!.[�Uw;c޳39��G��7�w2���<0D�y[Ę��K�sW�k�j��"�LU�HF_`qЩ��4	�>���#(z���.[��7���Պ~yӿZ�/>��:}L�C/ չJ}E�sGk�n�&Ś�+7�5u�VN����Y-��]m����aLI2�X�s��6*�i���0 �u?-���p:>?<.������^5��Y��O�0Z� �  ���'��K�#��1��;$�@ǳ���[s\�û�O�kў����^�M��	7C�w�5譯�>�Q���=4>��f=���KB��cBj���*&�;Dp�z��[�S3 8�H���+���$LŬ|�(�;[�b�+5t(���
,~s���m/W�H�1�?5*tE�`T���f[�э���wcК��X�acI�|K�H&��cL�X-�����
6�l��b���L��g�&�c:�j�M�1@�ҦWX�K��}[�u�W�� �W��J8�_����["
�_���Pj��*��A|��S�I����Vs�WT	'�K]<��gtJ�KM��4�%^d"��6ޑ��z���<�d^Ě�fp��D
�ҋ�4VEb��Ck3�mE�Hp��6O���
��p��R�F  �Ac{�� �0y�F!�J?�ӇŶt:<��%�
r� �w8�S�tnf�����=\)�8���:�*}��9Z[�wn�珬�_��c��1���rrSC��q]���y�K�C�Sbс�δ26*�ôۃ`6���9c�
�^��(S�T��r�0T/��4�����]��l����i���~��-$������#.Т�_�����Ŷ�*�ʟ$)�3�ՙ�]�T�h���b{'Ӱ�����EL�t���ā�evTn�@M^`�aEx�� �8Es��[BV=/���C�ua0���ݾ��8SzK�o��:�{�~�|^ZT�>��us�M��Z��!IhO���	eZ|B(%H�`�V�ʉ@v���A��5�����yw.�'7���@�-�I�*H�5�dުEvϯR�����H�l�׮��Ox��(���M4mbR���w3YPh�\`bI~� �L��l.�4�%�X�L�����y>�|����û�_���⇳=_�w�%�L�(���B)�H�����|�lq;�3��!$>������$��঒_Õ�ň��,Zl�\1�qU6Ƕ���L�{4��lgE��i��<��f�D�:����]:�t��ڑLc[݅���������U���3D���	�i�{Mi�g�1��5�R1������ڟF@<��֟�n���1������1���s�M��2W��k�!s�f�zdnc)k�c:�� f�<���kES��f�ܪx������������1���b�}7��ER<�uL�H�p�e��V,Af.F/��B)0��N��3��)/cr����b�&6^i7�S�(j���|W��'zT{cjQ��I�(�2c4uYy�+��*s͋U��+���̍�`(�^M�)�]�|w�
����Ð��ƍ�p�1�!s��lzOW�vzQ�s���Bj/W SˆN�x���t��Mv��W�����:�U��-��n�-�n�6_C��SS�E"XE��ms����IY\�s�������}q�cn�^�YP���m�RS�Ӛc�a1)��e�B.�_�V�"�}9Fދ���on*��N8~��b�ʭ�"d �y���XO"ո�ri�&F��������A!]�4��a����i�# ���|�j��ڈ�'ՖUdy�S"�ɤkF����Zt��+�4��]�������&��ǪٓM���Z����9\���082�(��Ŋe ��q]()��'_5u�m����.�����u1�-=�j;�>H�b��HL"��عs�b��.�K�K��tE�������lC�j�3]9���0=���._��|��
��;��7a��6�9�47�(j�����&6w����o?�f't�q@� Mӫ�I��l�6���$E#���h^  �W$T��P�:���^㮝Ҧ��X3m��i�ź�r��TJ��Iyڗ���ź/��EW��+�x}�u�VT�5<�v��</G@�IňQ���D��9Y+*��� r�{� �]S���ĭ8!W�u��u�6�޾i�&P���?�9��PdE2��6��`��|����7qEc
�j��CRWe�W���=�Z�k��o�#���[(���0[�j�U���D�I*�~j_d�ԡ��;=A��o�{�:��1+�bCR�=_T(����ir�1��B)BSϣ�`X*����Ġ��X6��$����>�B��T�<���Xok.31q*(�;g��[��Q(����`k�F/cD�w��ExE�����Ĕ����[�^��Mߑ����I��0���@�N/�+ꕡ���[��J�͙�ǻo
�����*�ӑi�.c�P�
2�q�^���8#L��+M��L���Ŷ��T���Ѧ�?�E(�M�V^��
Ǭ	gH�����2��a�ɞ�=}[=���Oǐ`����/C{�&&�0�!��N�Y�����������𷇿<|�䛒�2��gu��}�e��,}���6:��������� ���������۟�?��?��?������rh��ִ,��@2,C������O0���_O���I$���n��,fSȜ\��H~PA�?~7)!1�"��S�]~ ��b�25}�>�IF~��*�����[���!ô &qZ,� $�{��+IPP�`��9�I��k=�m����ʖSݻS$�}�ׇ�/����ûo��//�璘�>/��O�O����_��'�},�������_�;f��9��`�P� �.�*���nT+m�
4m��������O֔�����2O��������JU=C����O���J}x�|:}~=~�ސ4����3��I�=��~���I/\�&��7o���ڴ;�b����s���vj	�.�&��j�拝+4U]�6UW������Wi�Å:�}U�i�y9tI/`�Z�iO����i�4����� �@;�={��~5��;{S*�'pLzmn���N&.�^"��:ɜ��r������ ���2߹�Q��y�}�å���Isuё�`|-�l�wI��$�%��I��M/t��i����%mw�������	+���gvҨ���%� 3a� �6���\�u�i钥#�dS�� |CMis%}LIK������Nh/(t��"4�+8Ti�fV���6_��p��,P��oN��r9���/��l���vH�!r�����*[�����:��Z�@�Z�tnOO��?�ǫXl�o�s�}�!����=\�!����*͏�d���Jc�Au�T}9�9
��(z�Pe��sW�ɦX��`L#�����;�N~:�d��7Ab�*��C}���^��0��U4���D���Ш��Z4��$�9ͮ#L֬�˓��Q��jʿ�i���t�i᠌�e�4Zs��O��qO��j�B[bnG���ѨFZІN�q�]��1K�L���Ԫ�iZ����L~�g.{��M�)+%�H�7PZ�'�����4����f-�$���Q�m-٘]k�e��*�:�&��]P�bDU��)}Ӯa�wL����ؙ�vU�!|�6i����}��5X����C�����q��>�@wF�?�	'��2���X��K�Y�Mm��9�ӕ�>scs'�*-�+_X�է����^Z&��=էE���DQr��+�r��(�ݚ�� �5�nwiS}q�X:hcM��j@�%co�J�
��*�k�.Y�����~�Q��¹>Xf�؞E��n�|�&��&��f�ШZc.l�I9�,���ճF `iWg>� l�4'9�:�J�U��z�C�WA�Q%���}��ʰ���U�lpN�q�7�*�h~UҴ�ٶ��V�I��;��4�z_T��3o�=�)��0m��	ZP	^K�.��O�<�b�՜�݅+��i!,iEP�����)��>�i��Ư�^i��ҋ���[D�2R�	�/4Jo-��a���N�J�W��f4��9�.nF"�F��f���b6����T$_����ʼ��hE��f[D �*���j'J�5sZ�#��G{6i�%|q��%���}��L3
`?�Q��yZYN�k+��z>S���Ӷ�(�8�i������&~9$V^�!�֭ޖ��]�m�4�$ܶT��k��P�y��gjX������������      �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   �  x���ݷB����W��ZY����UR*$�yQIR*��_�����{��gl���S̟����kJ��!���s�mc��=5*��� ��O�dc��i��-f�f�el���ĥ�����tƳٞ���yR��������$�����Z���e�>�t�d� ,!z;w���y� t��y���o�`k,K�ݑD�l� �-a=t��ڧ��wnA{"[���g��6Ot2�=�7+G��F�mp���M�v��ƙ��@-�Z WȘ�L���03��c�Wzb� ��.�7�,�<���.v�2il\�8�. �&�t����ԙ�ow��;:*�e�n��&�:̌�-�lP)ÐE�Y�#9��#^��C~b���d��!��4  R�i�"�LU:��/�Dz��:�����?��Qn^�G��[���`?�0b7����Τj�&UQ	��AH���CS<�C@{�ܖ`3�Jkw�5u�nR�<�[�-�zpÓt�8^c~��M��Nf���[$���B��}(�{>�����:O�s5���W铊� S���d��7U��tMkp�j�Kox���\���A���2���;�Z4����A�;2�$I�?�h a	�*������'��6aht�No=���q��6I{���i�� "��4Ʒ�L4�"a��ń��T��3���5��j�B�J}+����,����I;���gz�mv1���t��������?Mw�Gz����*e/*6/�YPҿ��k�ř�B4��J����"gs�,yh����2�u���H��\*,2۲w����H2v��Y�Ye��UV�� ���� ��PY��_T4��:�\���7�wM�׾c�6���������V�?o�S��ԼQ����E�VͶȯPO�������&��`���/?P������4���3�+ʝK�ɏ�*۟�Cw�h�ݷg�)y>^��B%=/&�
7�VnQ��E�<z:�J�/��X2s�^�7�e7��o���4��:˟�1jrq#Qı����-�7Z�{�ՕM����[�\���Q����یDwRdT���P��߀O(F�}�"�t����H���e�'�(��"F�D��.����t}��읊D��b�/Չl�,������0��8PBw���F��G�t�ox�6��!��z'�̭ӥ���Wt���̩���/�Yc1��W�B�[�z�
��V`�ne�wdö.��c��:܎�l��i��E/ܨ�Վh��_���ZY)+�W�ԯӊ&�ɧ�0�6��i�Nd�[��@i������K���(N2+3q(�}����lNf·��"עq��e"�����c2�������D6�?�d�R9���0$2ev��Q�i�s��jB��F���L���;Iޅ��/I���DEe[��)���ee+3M~�4��뼘`���F�Tͼ�4����hFҨ����$����/M��5����֙��׮sn�R��z��j8���,�v@�_{�"�-�>CH�g��� k�6��3MK��ƫ(�8�4�,'�T��E0�׺�#���O#~<�V/2�k�������0��U�|]��-4��=�,�&E���7�ԉb���n�m��;��T94����A�;�rڙ�x�vk����y�XIV�X�_���8��")�k=u��8����Z��ӣz:Cɻ�����y�'���1	v��U�����Z��"�J!�X�~�֠p[c �wG�*�@�*�bF�Y�r��0
��LU�T�h�i&N�e��\$�BϺ'N�z�����-�uq|�^T�$��lDߗy��Q��z�
.k4���)����?����U�v�`�5z�J$v��9O�6ͱH]�W>)U�J�σ?��oɅ	C*F��ے/)���Z[��w��>/����.dG^�畏oWǗ!w�E��z�}��ja��3�q�Y�l�*��*V��
�O�l��tT�x���1}{m�f�����^���Q�x��J��Eo�ċ��us���︣�=M+�
e��u~��#�����B5�&ƥU�fA���Wac�(�|&&k��R]X��e
)0��j/(ǚ	>�S#އ<�7U���>>e/�9���Y��[8Ҡ<~j6��$W����l̹�腾����b�HX�W����Q�sW9\���//`Vο��O��V�dN���٨�j�ba�      �   =  x���An�0D�N��2��Yz�s�D��O<�JY=F�0��%/m�{��M4ۑ��a�K�Y�{ӫb9"��T�>R�1̾��'y2�qS��-ud�0���Uc�Wu�1�1� jO�a�z�m�ooDݳ)cp!�Qc�D=Ӟ��ud[z�N�9]����奄|�&gp⥍u�����fecp�ն��\A�����1�Ҏ���^�x)����b�*��_�X���W,����{NnVJۤn;�O����m"�3�1����w����l��o��S���o����8��z:�C|���&[��j��1|����      �      x������ � �      �   o  x�u�ݭ�0F���4�����El��:��4��y:��X��# �?��s�9� ���b(
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
�����7�����<�,�][�F#�٬�����s���vs�#�؜���p�p44�%wGC���ѐ�p4$�s4)`�%��i����]Ǡ�fy���Ǡ�fy���Ǡ�fy��xǠ��=G�Fn��=G����o������A�/)�7�P8ox�p4��"�h��E��X�����^GC�J�F�q�5��)-y�\vBCRj
GCR�t�R9I������v�А�j�hHJ�p4$��h4��VK8jV7j�+���5���4��hG��v�5���pt�����V�}x*�hz�f�0yjF)5#
GC͈��P3�p4Ԍ45�=G��&�k*�h��m�ϴl�.��И��f�!h�k�p4�5s8�%�y�6�AZ�X�z�6>ҵ|*3�!�A��3�}z/u�~پ��#�����E������:�������h��a�(�0�(�+t�-|�jeG�s�F��͹����ȶ�t��{�G5_.��#��#��#����F��K	G�t����E��cИ׺�O�1h�k�s�1h�k�s
�1h�k�s�1h�k�p4L�s��1h�
���c�P3�s��!h^ySxES�傞/;�!)��ѐ�p4$�8I1	GCR�«(4$�,I1GCR,G�Ѧ�m#)�����)Iq
GCR��ѐ�p4$�5IqGCR��ѐ��h���p4��W,S+˄C5��Nh�YN�h�Y�p4�,s8j�%5����e�F#��s	Gc^�f^�r(�.��И�%��1�
��1��D�ѕ�K	G㷮�C֦�ԩ"F�����x�*���U	GCëF��9�Ş�����:w�.{o�r���M?9G����;�`<�a����0P��E��4H�aH>r���
[=��խF}��Q�`_�%�%��Թl���E3��N4����NU�a�h�s���� M��4l|7����~7l��wN��/<���'�7F�6�1�;)�^-\!�*VF�)�l�:I� �by�I&S��8�߿E�����Yj�]�b���m�t}������-�ޓ$��Q�&'�'wgH�R��!Y��-�Ћ�S5��h
G;���@K8� ���
�E��"[�xhZ��޶�V0��1h���p4Ԭ����Y
GC���Ah��q8jf�������ff�ht�m�%���섆��}��А�&����-��А���S�Ҷx
BCR�OAhHJ��)Ii[<Š�Z�OAh��oլ��^�A��p4��k8j�S8j�)5����e	GCͲ���f٢�p����h�Yި���Ǡ!)���!)%��!)��ѐ���hHJ�`4#�y�K	9����B��y=6�BA�uŴ�E�;������������� ���O���1�3<���W���tԀ�ъ�;95��ܷ.���4E�����&���( a
  5����2��E6Վ
k+o��09y�ï@�`�t�.�h���\�/aM��|ĺ��Q��w֮��ݦZr�!�ɞ?��0|���mb5�)1����g@��U��4�BoD�6i�h�!�8��/Y�*m�\��j�\n3kl'������Z-�x��8k�I:O���Ԛ��K���*���6}"� ���?H�����è;����Æ1?��a�N��/���r�n$	uC�q������n���B,1eJ���vM�K�j�_A,��m��Z���v�K�vD�n�e�%K�
uC��@H7DB�!
���g���~�Zr^t�u�%f��n��`f��NECZ�5x� �OjC����rI�_~�; �c�D޲;�"P<��Hd�P>F�Z��҃f����ꟽ�]��v.�
�v��kc��:�7�9n�Ѭusf2���e6�Ym�]ǠG��m�q#��/�F8����V����ID�!�a��^��n�G)�G��|��8�1_����� W��8�2��X��O�c�I��#
O�N�#�����/�����miA�\�8��	p��� �y�Ɖ�����Ea�x9�k��0�-5�C���Cs*����NP84�";A�Т���C�*�m��NP84�";A�Ъ���C�*��?�M@!�g9� �¹� �¹� �ȸ� ��x>��r"�5��Y��	p�L�F-??K�(8D&�9��(8D&�9��(8D&�	p�L���������笨���\�ႀ���)����L݋:���c�A�c��~��dW��$���Q|���[e�7X7�7������m�l�����.`�x6�y��l�)�x6�2=��ؘߙ���[hk��Жl�lhK�x6�%�x6�%�p��S�����4L���Qyܫ퍱a�v���]3y�]r't�L�G@��\~ܿ6��A:�����Z"��G�Jf���IePy�S�{TU"�
�FRT��:�I͠n�����R�Tܧ2������oQ�%�ZA��T�6Q��B��"��&�H*��$�
m"��B��"��&�H*��6�ĩ�l�c��3X~y�1L��ت7\��X.�j(U�)��b��B��c��)�X.4�-��`�m|�4�O�ۯrTm
Ě��ظɛܺRFC긡�椾iE6{ݜB�E7�A���n
��
*�h�5��|~nO�<��O#y��~�����7Fvk�<��>�t?�8�w�T�/8��J�#��1͗]���)���D��Η�V~�(�˥Etm��`��J� �T�U�!�7�S�GZ��R��*��AT�8"�EN�#�]�8�� G���	p��CI��X�����ju{�{D�$��U	�+��^�]L=��k3�SHC>��8�6q��p
��:�#X}o���D�A�R7T(wC�A�J7T4U<G#РB���E�vRΌ�(q8�]�p4~Ӥ�h4#I���_%F�@3�U������<hf�n������Y�!0�vC`~e��<���x��m��;y�Q�f�`ިvKy0oT�q<��V���ڝ-f^-f���=��A�e��l?���zmW�p����!TtwT���ӢJ$�U#��ǨIE�F�8*�;��i���+4�}��	�2�_�V����8���c 6l�ɯD�mɨn퓍����G��]�_He�D�iR��M����q$����qj��ӛ���m��"e�#2=,`kWY�"�>)�B��%����&&-���n��XܧT��Z��%�R$/�Q$�q$�I$K�Y$K�y$F��s�v)�Ai�'*�%��J�&�4ȕm`_Z��ry{�Z���r��[���I�\Y�:��S$r�I�\9GR!W.�TLa�H*D�-�
�t��cbj;&�b��r	&OyD�S�Ӵz<��9yf�\Lm��`�\LmT�`���k#��kh����G�q{����Ǐc�B�%�	��̘ ��1l|/�����fݠr�l�h�O�`�^{��-�ed�-��r�4O��N� Ƒ��/Ќç���hJ/���P���Ͷcy�'/��aH�_��G=�Q�f�jX��Q<O�݌�>�w��ɌMs��+S�A���i�*Yv#��0��(�0�4Xz9}=��6��꘧1�*�0`�e��0���d��0_Q$hlsr���(tn�0��zE���΂T6�����l�g ���T�R�!V��A�J��U�@�J7�`U�!`�V놀�[���T�s��E��4�`�˶�`�m���l�
߃���r�c�5<m��iA�Ңx5���g]M�T:݅&�@{ډr��T�d9o�_tA���M���q5f)uC@ӈ�!�i$�h��f�r��,�w��޾w͟>s�0�6����<�C�ts,�^g.�:��L�X0�PCk=���]�E����S���h��k�Q�Ӣh��X3ü��9�������xb�^��t�o�	����1����n��0�8̔\�5��.��G�W��i�u����0��t�0&�H�-R�;Ø�'/�`��/c
�M���]x�0�`O^��1��b�o�L�gF�$Ճ��do�|{{�.G�q     