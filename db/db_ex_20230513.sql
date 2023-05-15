PGDMP         7                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    210   �      U          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   Z      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   ��      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   ؇      W          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      Y          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   �      [          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   ��      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   ��      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   $�      \          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   �I      ^          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   |�      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �      `          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   4�      b          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   �      c          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   8�      d          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   �      e          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   �      g          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   %�      h          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   B�      i          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   y�      k          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   ��      l          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   :      n          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   $      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   A      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318         p          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239    %      q          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   s%      s          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   �%      u          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �%      w          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   �&      y          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   (      z          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   68      {          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   :      |          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   �>      }          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   A      ~          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   qB      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   �G                0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   H      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   ]      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   �c      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   d      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   �d      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   Tm      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   n      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   �n      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   [o      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   �o      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   �o      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   p      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   �x      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   fy      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �y      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �y      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �y      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �y      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   �{      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   |      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �|      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   "}      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��	      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338    
      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   ��
      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   F�
      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �
      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   V�
      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   s�
      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   �
      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �
      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   ,�
      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209                        0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1824, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2813, true);
          public          postgres    false    220            	           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            
           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229                       0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 517, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 498, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 76, true);
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
          public          postgres    false    281            #           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 7929, true);
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
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[��q��G�b��~��HP��t@�q�@��1 H~~ErT�hJ�3ݧ�'?p`����VU��]{�7w�|�ͻ�?�}w����׿��&�|��_?�|�Bʟ��R����+��zO�����������������M���˯n������7_�{�����o�������o�|s��ӿ���o?����o>�U~��_b�웟�*O�*bX��ZAZ+�KX?|�������!�����ớ/N���ûoO@���������� ~��y���ڑK	+2�Af�J	�$y2h�dИ<�y�F��y���<*3#,2�J$Z+���Z��H�5���V�O�zT.��o�x��,!|���|w����~{���ׯn�G~��_�c��q����Wg8�~��'�҇�����EҺ�e΢�$�)��?�X�5��ë��Dz������7�������Ȝ��쇟��'�����'M@&VHX=!a&�^���NT1��`��q�C������Ǐ����')��ݷ���7)��C�Ǜ�{����˯�޼��=�����6�����V}��9��,��V]v�����KN���?`Űd���X�#�$0�+O����1�p(A,�'X���z;Y&}tX�E>?=69I��2P�(���`��ka��VAZ�U��\X���(u�+#�Ս#ǉ�a�p��Q���`̀�5��jHnM&�2o�0��xͶ�sb&:1���s������`ٓY��@Z+$����9�&�ha��]�W����Zn�a歬�[�"��U����r��,>�Y|����8fvp�շ�qH�3V��z�I9t���7��Hj�������^�X)#a�3X�s�l�y���FP�r����V�FbaZk0a�%X�,��(=����A1�=kA3��8����Ԑ�*3AtS�VC�jSˉĖ��2҉�2a"����ܺɣha9N�⻀���*�[�9[	�G0.������ �w�O�B^��塑xFyL޲��ˮ̀`�iaa�U����,��^F)�!a�C��6V��6歸�����ηHNHX�����+3aMd�8�����I��-�q�Z�aՐ��'ֱk����*�c��EX���Հ���xE��.��Y�0���Ŏ�I�Z��D�h�����Hb1�bq6p�h5��_�}�yWX����¯�ZPnQrgM	ˎ@���$ned���l��؉,q��5�ĭM3�j7[IN�&��>����+
XO;��R=1�ɵw���>@ܚbky�/HX��*��U	��-P�j�i��k�a��of6�l�=��Ղ88��x&���"h9hay���ӳVf:�1aU&���[���(X�� 
��E� <�O$���Z�ᖹOa9��	�"a�faa�V[ˁefl$'(��k��5����.NT,qZw`����	kV-�=k1�ev5��g{�i�������n���`M&�����u���u��4�(��:�i-s.r^�#XX���dTa-VLXɭ���*ֈˑ���៾���@�g��Źl������i�˧�	K�O�v�Z����0�)$X�-n	,�[v� �V�z�Z�v� k��`��0��.�k���P~2��y�<9ܪZnyND�>���,����:6k%$,s�	�Ć�u��1��\�`��N��)�Z�Hl&�z���NG���ҏ�n{s2���GL���ǣ�\7�)$0���=m�=ǟ��6J7�'*?{(:���z�أ%9}��2���(���q��'�س�|��}�֔H~��q,�P)�$,�DXx�"�rbc
&Ճ"!��}�lM��ꄊ�}��Ok$��rz��&	̙�~M� 	LCU�}������'�$�=�H�~/n��$`�p"U�L��u�VmC��T�-I��Tm���2�qf�M3��^n#��Ǵk7j����̔��cOҲǁeK��a3d���l������f��%����}:�2�d���e62�|�N_%"4.k��3/�B�"�\.�����lTA	i�D����=[1uݐd�U�&�:)�$��	̹°��;K�6Ȝ���o��*Z5hV�C�j���%�y�p9JF��.�����D��<0���	SJ�����3�	Z3�ԐD�P�D�%f�wP1��D~"�;3;��nk(i�,�%�5��!��#���[3i�A�A��:��:�	wIi}y�FM=,�������ͪB�ܑ��$�9/��U�<�!q�����+�%6@����j0�I�$5��qw�3Jq���5��BLm�Q؊I�b�o��Ņ֐|�~�C��� u��&Cw�Q��Q\�O�畦}ŧe#LU��fߍ�fwF�+��Y)�<4�d����}�P������d|ۘ�eL�;̞*�_fV,TU'�{��k��zc*$�Mf�-;L�bc�����:�L�
�Z%I)����2smDbOV�Y':�n����(��h6��"�<�[Էz�#�z#e��r����:����q[
uwLrSA��� T6��1�:�<����ë��i��û7����߿~{�c�{���������0�i����f���2P�0��uj_I�)����
�pԾ�8����>	倹�\�i���F�Q ������q��w�iG�di��@?�H31`N�X��]�8*��˙�J4
?�']<Q�MKF���S��\q*��2$0C��]�T���ݧ�Gr��H�g�4��\�u�s�k������9HIpr���2���-�J���:%'T�@��A��D�e�D� sr�B�o���}b'��o�9}å:��P�q���1�`� �N���,����`6����&7�����]Д��o?���}ݴi���˙F!n��>��)�2�4R`U�e�:uV0CQ{�I�R�l$��}U�ƸR�?W+�ZF����R�a��a��0�a(�L�8}_Y���k��9�S�B�gR�*$�u���M9(71� 	���ȤA`"UϢ���,r�{�Ğ}��ƹ� ����p*�Ϻ#�@%k]�6:�B�H���F��t�IJuŹā�}�D��t�F`��D*���IY/3�F2i88IEGpRK�H-q#��� �D�߅�A�É���^F�ڕM]!@]0���L�3��D��x�0�D�Е��2�&���z0�j
�v.�����%8=�� �����`	��R Π�$�0�q�)r,�V�K�v�>�W��-��Nb"i��('�x)�C�>ݸVx�%/I���S��7��k�1���b-��.E[9�5䘂Iɱp魖$�c&�z�0�}�a��$uy��2�7���<��w�2I�T�e
)��}�ĶNq��3�$P{#�f�E�zL�q��td#j�A�B�9~S��u�
��eR���)F�n`)*�W$0�44M��b���9A
k�R>0�Z<R�B
*�LbO�:��"����� ���}����"���þ\���K���JZ(J$0����=�(M�X���m���D�H[�4���o�.�!=?���*$F��nOULf���Z��DY�����
�y�Pf�8��܄���A��՘�j\F�c����}���X#U�F*���N 0(U9`R 5m_7m���R�R �碖�K)�tT�!U�IJ9��PnJ��;I�tR.����d�A*cߒ�Q�tiH�Ԁ�)5�@OjQ�d��3,{q?�mdW��`썖��8����,�����[F���H��Mv�I�^hѻIƋ&RΨ\�%3�2N�/�$���8����[�^`IԄ�`Rʱ�z�,Pɸ3�� ���ؓI"'${�z���T���@U.I��%BR�IMyB�+	�2���YF�^�$�I�r�I����I�5��umD��T��Jņ��d�L�8�t>P�[�0qH6:?����\�a`%��]����'Y&��EB���Ӿet�QyM�)��Mcw\�`:�2�w�T��Fs_0c��4N�ۢ)��}}����%��sX!�� ��IC��^�q�)�e]uJ�J�p��%E̋|� ӘfU���	��\���[�6FV")�F��    ��Ud�H˽���mH��WII<�by�F�8:L�*{�F	��CG�����$���Ж�4����]df���}�S��X���EL��M��E��ѹ�Lj�CB5�eHT����s�F6Ԍ.H(�p�������k�bF�������֚��}BB$��"�T��j�)>��l$�Z
�بK�/q���$k#��`.�4b�3�2�.�H�]��F���WT;I���n�H`���0�z{LOH�S"矾P����z�	�l片��,co7���ب�s9���)�Fyhayֲju�{t��ǾYh���y(Ґ�����n�Q���!SN�$*+���8���+�z7�FQ�)�3$EapK&I���h����s�xb�U'u��1�F�d#R~N��\I`:���{�Эa��j��x9��Y�]X����=]������=W���~�a�������tO�b]J��B��FSH��ڳ�uCLu���SA
(O��{��j&Y��LwW��
	Le�P��Wc�w#���Tȍ4�O�c�<��=�0&i|�P�U#H6���Q�gm��H���½�[G�^
�XM��H̍�ɵ��Z������ � -�X�9�M��ɧl�<�%�&���3iޕI���M"M3*�H�)�Z�Hn�Ю$0e_�l�[2)ќo2p�����AbO'Ey#��Aj�&s�=�V�-���Q��x X��7�
��R�`�6�a`\7u&{�avQG谓2zxu��鯹�{x���M�޽�}��������_�z������˳�2AFI���A�]�:����<�t�eb@��r�n�2H��Pw�mzqQ��QN"MV��C��v�T��F��˂�v���/}6�)Pi(�r�`����ؗ=�vI�DeB��j Ey�Z�2X��֥5�����qA&�B�QB�2��!�jd��k(Ґ�d���-S�A��e0���
VR��wa\WH㝦h�]ˠ��"?���|�a��i#����e6���2�?/���:i>9@`.��'{*I&Te`%cP�u���r]�l��m��d�W&(�j ɮ:⫁T8;茦�����H��A���Z3-.��9�C�ھ�b�b��AK$�T�G��y��I{;E���x'��V�$�ԐFRK�A�Ge�kñ�JX`�_'����N&�I��̼�PI��|W׍tRڙ�;e#о̚a�࣠�����4� Rbe�ji�J����¾�m7}��͕���y�QmZ>�F^�ς�������Lٗ��&O5)B��2�\��J9{�MO�H�]�� 9����6U�H������(e�%�쫗7VMR6>��aM����eu��L�u��
	LV(v��
�x`���(��l�;�aq�F����J���lH�U'Mq"	LWt�nM�L�׉-u8�H���KR]����H�f$��DI�������$���RL*wRVn(*KN]���c*�4�g���vԬ�Im��;I��ŉ�F�(�:q�N�$�SQ�9�2�W�T��`6νt�4Z����w��k$i�F*]4?���N^'�4�D���e���/�Fp��VRY����)8��g����V8�����"A��aj0���bq�����mQ���tc����dR�\Hc�*��7ұ�$M�J5�z����^�A�8�D�j����C�������x���Zrˌ}-��`�ٔ#���▃�g~���s��r��a,;��(����<�[+z�L�e�r~��[�2�l�}���E`�K9O^0L7��/�'���_��i1|�YyV���x���+T(��&�Q�1��4QQ�\0��Q�F�WF,�����`H�<���Xr��L���PYy�!�F��$�|C*<P�����-�:̪��n�!�I$0�9?.$eE�t+þ�xk�R�?7�H⦐tzUT�L���$�}.�pk�I�:��HCZi���7�^7E�Rᮤ3�F*+�P���_%	�����̭�J��	Q!��5q�D�W���$˜'hL�ҹt"5��t�XI`:�3�Y�2�L��&L�a�����L��DZ�I�#�BZ_q��}�+JI�$*GT���9��]��bu;Ov�\s%ƅ5�a	>�����X���8�=5?��.��+�m3�4��K&y�Ʈ#��r$��MR����6�{<09��(����b�d�,w,]a_43��PT�cu��<4eHi�F۾Iq#�3�^DP�ns_��OI��)XTIB��Ӄ�Wnl��:�G��\��ಗ
��H�S�j.E�Z�xԤ5�Aql����U1�t���;�P{!���طݳY�P�/�H1C�ڮݥ��Q.R���ѵ�յ�B~�60�I��}���_(sHjQ{&EX#����z@��eH���F|H�{��
l���f�<$uqi�
)�d��pJN�]Ӡ��G�����am �m�f��$;
�Z��h��sa���z �h��F��g�Q�f�3�y��zzJ҉�y�"372;H'�D*�绪]�8S�=P%D�6�5�\f��v'�k4�Ğ�����a��}L�5�uGo�x����M�O'����*��S��*���&�ҟv̲�޿FXP��81Q�R8�}ݴu	T�z�\,7b�fg&���u1�W�#$О�0����`KO�1Kz0f7V���IC�LR�����0�̬�LQX�uS�ɼf��+V7�YﰾL�^�pl46r�]����k*꼛��G}�f[[8�2�1�h��o�_�e8h�B���1H=���J�LDY��Ī#��Y\�@;�)�vEHmh�%�]�5�#��m_ɼU�� j���n��!��Bj�
�2+,�I��v���^֪-Vy�B�����ŨY�r*	L!	���r��Hq�Qs�>�=i�X�*�4����re|��b���Ѳ�$��KU�;���Ju���U�Ze-�fE)3Ҝg��{H+5��.r>ý����d�J�m���FfQGd�Ƅ}�6?�ej��&��@R�R�U�٧�ڮLR��4A$7��XѪhE��0�A��*��Hbϊ[
%�����>Q�(���y��4}����A�N�yꞨ��q�2�����$IX��=kG�v'�uVl�*i�?�ݙ�ѿ$f�� yym�}[�m��FՋ�@Zu�aR %�g~��A�V���B)�"h�}a���ry�F�������HX��Q��l48`�c�z(��cm>
2��l����a	d�*q��d�L���8k�����7D5��r�py>>�@�O!q�-�?AZCLj/�2�n�*�RUлd�~|���"�GjR��fՓE��pFq��k�1�||E�jR����6�?�~ڈf�X�H��H,�i��pFI��J־9gc:^ы8q���/�r���w���}ǯ�j���x`$�J�:3���S>��JH�I�$���ȱ����ҵJ
b�P!�DRy??,�8�J
��|@3���΄$qX%'����LT<��:jO�pS3J�LC:�. �<�2U|���b��D�v��ģ�|�r�t�F:�҅b���4�(���3PJ��A:�i��ܚK��<I��u�b��X4�����B�1�
z�45��W�o��J��ɠ�}�+H�� �/�$b�������A<�	��/�����2[o����E`��DR9�����2Ё�!�)@�+$�ER2��I�łV7�9Q�a
��I��f;�SX�IX�?.��9�j����@n��xgr� a���dR� �g�&&,�$��vDJ�	+1�V��8�N,���X4{ꔨ N��N���OÊ���Xv�/�@�� zEZ+�a9ֲ�B k���-A�X�ܚHku(���Z�2A���U�51�D�4�2�52҉���-����L�۝z���|�?��?|�����9q#�����ỳG���������g�F	ϴL��=��A�tԛ��@�/a^��VaL��s��g X��R�r���Z�i�ʄ�
V�r+#a��� '61�����?���%2V��r2꒽Y1ӻdsT�p��?��bX���[���Z�"�e�v��e G  �@ֲ��Aֲg� X��Z�!���¤|"�J����b����'~3�A@�;�yZ���o�)`9N�O5LJO��9��ayNlHk��	���;g �W�+3kGrk�ay�t0�5����
Hku���bky�:!�8���O[+[��1��։ X��c�.������+���Y�"�e�jbkyN�r�3�x�Nw,>��z�|+�AȉQ�D�TCD[��5k�� �y+�K�����VaR�Y��h@N�7�@�*HX�:qp�8#V�ZX���r`E��<n"�bE3V�Ln%��<XP�'$���U��XnQWJ;�+>L1�zk@�Vc�
RX-?My{�?9�8��ux��U2�Zi�Z���`�7RI�:�[PX		�Cai)��[�=�b�3@���H����0V��r�ؐ�*Px��cS�V�N�
f:=���\��ٴ�1�`%"�j�3��W�/�ֳߟ�7��(~d��l�.3�$�-�\�g���e���������x6�3�c��z�H�*\�Q!ʉ�$�ªHX�Y�Y�CEbbF��4ÉZ��-�\��L��gr�I�2�Y>2{�´V�R޵�b��������V�=�{s�������w����3?�����4�PT|��靆j�/�o
�f9�|Zp��b@Z�V���Aˡ���r�D:��ZI���Zm�[��p�33��N,�q����-����Z+���D1�Hdf���IKy�Z�,�Y�j#с:���>14����ӣ�fOS0_�Nͬ�Fŗ�kդ���Ă�U��j	�� @N̿ka��y�d�&��qK�NW��jD�27�P�V�DVFFbs�K�La�u���g�}�����      S   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      U      x����v�H��{��z���݁b�1��`��Z�&��j����feU�����p3h�02�3���/���07�C׾�ޜ�ov������~�m�U]���띯�wu�޹��?U�Ou�v��Ct�����o���H,������v7b��ݟ����?T�Cp�����|y�u�>µ�
q�Og����kKO����-~��}p�a� �P�n{�l@����V5�&��p�^#��w��8"xܘ��W5�����>�Ko|�4�>@��p�������v܃T�ߐ��	�W z�M χ��+ �kUC hg<no�{��P7�� ����)t��v��Y�����8|ٞ��A���k�O����k���Ф!�����"l?���5�� �>xxx2�n�-�4� ���n{���.~�ICh3���o�W��GUCx?�W�b���ў�! �n����F����+B@������ݨ��op��f�����H���/���� ��n7�W��=�=��b�=����@G�R5����|�_����Sn��X'��f�;����C�T!��}`�GOԫB�d��� Ќ���! ��lw��@Ўθ�!�~�|�z@r������!��?��\z���x� �6�F�fqH�5�^����YC�A�o����w�� �w����tu����]�4�>������;��SҲ�ߪS5�v�����}cK�̍�hUAh�]�ݼ������nx�r�ߥPZ��T����E�(T�Uj�����~}�˿�J�<����0�b�{�����v^����������~,WA�d���:J�⫗��U9���e�NzUCX�}��m���m
*)oGC��x;�� �w����-j6�~�.̓����1N�j���T�ޑ��e\w������E ���|��<߯?��|�;UC�]�6�es�M�|l��.\j�¥/\�.?��v8�����^��~:R�3e߸��w��+�G� �W9�{ܔW����r�"���ת���w�q�_�]ݍ����+�Ǘ��!0|�]O3zX�W5��Â��i�
&�/1�RC`�S������{Ƨ�x�6M����|<���6���Q}�G���9/5����0��[��m��
����������~ؿ�������!]^*���-�J盺�t�ٲ_UCh�|ɸ+�?�k.�+k B]U�.	�fێ�ķ���tf�5�erW��/��R�`�d}�y�r���,��A��@W;�����W����+U�`_��^����tb��v?�c��kD�F�ǏM�T�袼�}��E��{��<^8�Wm�WF�	��u�4��ܒ���˝y�A�!���r��� ԯ�u�����)X��u�=X^��_�&�A��ƀ@	Cѫ����t�?��ӪD�I<������D�N� �4��KI�A�i>��N5YKG�%kA�8׍+���Q��DU�X�iY�F|�A+5����Oo�W��R��!��ɑ����ד5��o޸ěl�qG^�� ��Ŵ<���I�����kG�V� ���ik�����#k���n�6<n�}����_6���������㰥�r]�~t��X�M�E���AXͻ�6��	�8|�o�S����v?�G�s\5O�����鼿{�_�%\
������Ş�z����J��<�#E�烛o�ʇ�]�T|Ea��%W�� ����dk1�銃�� �t�����RC<����C�y�އ��/�t�|/�R�����G��+�DbBr��=(�p7dR�8h�������o_��?��D{���D��i3z��G㋻\�A�{]�Q�bI�H��B�*���F����$?v\��O�'�t!���P������Ii��͖5���_����V/��p�ro����߅5���ڇ�a�n L(M
�{]�P_�Q@h4���t�[�d�v������)$�ҩ��}������_�6��<��f:kIL$��������FjH�d�[ժ��	�߿����^��J���������_����l$u
�jI�H~��?���
BvU��� a�K�R'������c#q)t(ns���~�%!@�}� #��x�B�J	,V�FAi`�t��>]�X1��Z�j�������X��'�D�B�F�6]��V� �S����ዃ�� ��9vv����� ⠘@ʂ�b�
F�b4��n��$�9kU�@�M���r� ��E��Ц�yx�؟H��R�@<��o7����2;Qj�Z�Y\j���6�s�l��� �O�����W�i�R�@hG��#G�/_� ��CC_Ə���c��/��������`:g��Ff@J�h��9���Fx#m)����S8:����OǍ�Iɺ���;�ͳ��+o�A�������8��!5��<�U�7�U���||��_|����5��єsy�����|� �B��8^B����Z޽J!�"%+A\�f"���?�y���u��km����i�Z�>�S5�����F�<��D@'���VKlͥ�X�D@[�s�ø�3�?U5�E�Oy�A/=���eU��A;�*���Pj�ݿb�M�hV5����l3��K���χ��ճM��Rj훏�����L�_�T����~�~X��zQ_jm���8~ͬ �Kt�A �����T� �Ro6�=�F�
��A$M�0WJ�u�пD�J�h�B#G�R�8�����c�-5�#��[?�>�!�j �������QW�w� �z5G�\�q����O���l3.���]E;�qx:���[)�����d����Lr�PY�@hK��^09�&�m�5�2��� "�Z?n�߭L6����?�4���$�U�U5���U�9"]�J�`�xV�	_���IC8�j��Ip��u� ��� J�j
��w�9��*j�v�L���c�#�/��R�0(P�u{{�}�����!��Aq:�U�0�K�;U��� >��Yo�7n��A-W�|}#3Y�KMN�A��	W4��vϔș:z(��j`�p�wn,�Dr-��k ��mat�X��Ԗ�@�(5kx#H<�s˓�A>ww����+5�!�]q���^���0�&���PjB��)ė��R�h�|��CS��KIq�A�?ru�G��zU���nE���YC���h�]>z�j��+9�+'4���W�z�d35���q�zR�Y��6)�Á���ӡ�������f}�!�B�6�'�r4/��q�a=�j��6�K?�R�@h�x�e!V�����B��z��e�V";.c��8��L��l�k�5�F������LRv�rɲ�Ԝ���{U�0�Lx���>�J�� ���Z�!]n�#O�B�8hwݝO�_&����a������행�����D���F-nn���҉�5����"���x~���h�u����I�4��v��nk��(�K�O�A='Y��P��)5�#����nHX>� �:T1sx��^'� ����8�"�.�H�A$�Z�<�l��� �a?���d�
���Tb�Ip�;S�MNb�jH�ߛU ΫB[�ps{��z2�.�� �A ������<�Q��d\j{���%3�l&oh�@XC8h>����渻��-��˝�5�$�7Y?6ls������M�*x���ҥ;2i���8ڥ=iG��Nފ]����EK"��t�ӕ"Y�20i�4�j�9Y���+D�7�o���͵˯ɤA�w���~�OD�M��oq"s9��k1��?C�ѠY�8���X$m�;& ��g/�:��_TjAXA�|g"���� �p^�C� �\��}k��l�	�B�Z���7!�"�OhB7��]'h_�(�D��DA��(A�r�t� 6��A/�J�	��u�D��z��M:U� �u���w�SR(�D�A�zoV�i P�jA�g��#����n��������4\�|s�a����A �9�7eB�    �;_;�C��ė
�R�`x��N�`^�i_f �D3�o�Z$w�6����a|UxSBC`�*�4ђ�}[���˩�uw���s;��=j��oZ�
K,�h�����٧:����Y,~�y�A���7mNW����x޼X(�Ayh�[U���X:"�q����Cgs�ȱ���?2���� �W7��BO�����j�A�� ��H.4���Y�b��h�T �\���W����䲤o�%�=]|�&q�����N��!���n�@�E9�� ����%wߓO�>��Aqj�d��b�����Φ�!�َ�~U�8(����U�q䛡�;�S��g壥3�dv<���j
�#}����Q_���W��N6/+k��ɸ���"~�A~�f~ ��	"	\���/�_� �hn�8M�����ƺ�1圱Ͱ���đ��ۓ�Iy��	"���n]�f���EDA���pcJJ�9��R'�B�.�Kw���CD����A#I��65��p��J�2�Hh	�Q��Ptm_��YN͆)$U���.��i����T%4�!N�M�9���N�X��8B
�2U{�1#h���A<�;�ˣ�G�Z����S5����A���#�����
R[�iB��r`u��U����Sri�w�
U_�	���'��i��>��Z�ۚ������A@���5$�P�.���O�� $����F�"�(4�#�׮3�ڸ�E]����ئn@:LS�J��Ĺ������Q�A<�tN�q�3�E}�� N�;k�>���޷����t�[7ZB���\�l��a��p'��P��J���B��6�U�+��;=kG��'Ծ?�j�:�����8
"��u|s���)[/j� �o�׹��C>�I��kU�LS���~6ټ�?+5#����A�eos���f깸�UX�8ho}<M�F!G*]�@(�j7���;�R��{
"�H�Q��_��7.6��G�<���B����h�c�Fr��:Q_4�DD>���@8k�"5��T�����>|�1Ĩ��cι����!�C��LM�b�T�W��:|��]&�Ĝ�"!b�䭣��0�TY�,4����;�ԪW5��㷛��Ks�K�|�X�@8а��+�=��p�԰��lD�a�W5��hH�[��H�lbQS'4���^mmG#U�4^� ���A���� �3�o-�9d4���B�ã�&�mƗ	�q���qGٌKhG�7Q�oƗ�ʈ�� �RO�jA�D�W4��^u������A<�ds}��l�/�BC8Zl���U7{� �z�f���D�P��B����
������� g�aqޘ5�#�1�"�t�m��+4���T[g�Ѧߍűb� ��La��(R���T[���i��tS=��R]�5u���������<�Ub�&F)�p웶v�W���z,K��������ZZ���APu�54�ul�)�B�@��)͖]��v^� �[e�6yέ̶�����,�4�L�`�jwR}l7d5���%�~[׬��Pb�+���qP��Ͱ��)j�d��-IX�H8jk�aR���"4�.���s�����!<pj�A�f,�2�qp�����=fc�jGր�UN½�w��i�h
�Mh��g��( ѩ��S��uűKhJ������Kˆ�B� Z��z�>mu2껢S�� ��sd3�Ŭ�A=O��j��&���p�RY@BEс��]�;Lh����"�._� �{�)��6˹hB�8�u��fs|2��E��� ᷂���S5�$rDmt�,�Z�VDҼ�J2��Pܧ	i�E�:���`���^�$s��qW�A$��t��j�T!�io���S��_��f��l�u��A�~�K�u��$4$O8Y� j���Y@{A��3�ᆮ�c�\fO�4��+4)wy�kk�L�1
�������Ta"��K�5	��r��� �`��O&���vE�ShH�W�
�X�'BCHwwy<�R'Zj�]w�B�@�� �R�A d�hհѶ8 �c�F���ue�� �	<N[�F�7/V��WI|�gq��&4�YQ��6C��۫~��
H�<�~ 9	˖�F���� �>��}3����P1N�!$�Zso��Y��r�����/�,�I�h(�҄��޺}K�KKI���A$��˖{�F��#�4$�I+m�^�Z:G���ֺ��a��8j	�hr-�%��6�", 4��}�*S����;iG[����2�QEB�@x_�;���hٿJhWq�;�J]���𶺎�-.���p��6�ͩ��A������A�Ht��A ��~nL1=6��4�A ����ޖr���A���5���pt���,m���QSC]�8xX������j��Ai]���}�VfO��j/G�>��Z�Ѩ��x�����ø����BY�l���Tq٫�A���8�n�$��`DB;�a<BX
S۩�Z�j�Z����Y�@�\@�y7%x��-�5���V�{Ӏ^2::ae�h� �T���j2�.�YC0��(�rY�6SU��Au��b�|���4��n�>o�{�$�6'����Y�@<�Z]R�1g	�A|��)4$W�2n�ZTh��c�E� ���ո�9jBܫ���[�p���Yh�	XCT�e�kG��|3?���m�LY�8�w��1���CU�j�X�ٲ#�)lګ�u$mq�DD�;+I�JhI�Zh�Ah���A M��"2d4eT9U�@�ܦko+n�r'	9Xh
��_��3��vTB�88��$��k�z�}�+ Mq�B��/�/[K�$m��"�A |Q���/z�"���k_$�.y���7�l���-4�#�oS��e�C�A R=|�c���kF�RZHC��N� �V�"���_h��w�^vl4,��IC@�� �חZrV��A$|Ue��tS[��*a"q�[V�줃�tU�j���ԫ$�)4�$w�ڜL��lk�A$1�3��h\z$��4\��7�`�m»�*�X-���p���5�p��ZV�A$����_���v9�Ah H��5��]�I]�7����:<�����
��6��U6��A tmu��L��d5�H6����j��T��U��|k��$�)��W5��C�������v��V2iEZ�-7h݆���B�0(к�+X`"�d���q�ܱ�F;UC@�c��Ɣ���.N��j� 
<Z�y�d���5�#�,	�]��)w�Y�8�A�:w�<�NF���*k  ]�EJ�� 꺲��-�u�q4�9ʹB�8�y�9Rķu�j��kA�SĬA }��Y�*UC8x���v؛҉f���A$�&jMV/V+kɺ�Z].���A$~U��>�d�$+�A$aMG�ɨ�������!��HhG�Vo�WHʫx�A$x����h,&u��j=���_�A �Ԇ���t�Z㳄���2��$2kThI�a��Óq��T�j�v���l4�� �g�%LLFe�Yh���q��7�q���&��묞��϶��~_�|s<ڣ5��Y�Y\T5��������#���;W5�#��6���M��,4����OG[�7e{�! \n���d���e(^hH��|����l�x&-�i+r�խ-4A6c�URh��"��|6�7����aB	�Tcu]ɦ_~�"ک'��Y��&5-^.V� �ZO��xOW�e�\�A,90�x2ͅ��T�ګD��;ו(Ω�B����q�1����F���u;�dJ5����:a����u�k&�K�~� �r�DK&�uT5�Ͻ�� Q�8H�:9�9B�[ChG��e���Z�šb� �^��)˧���u�jK�x(�� B�@xw�ue�l��qh���S��f�<�M���Wӭ^��3��jm�7�+FPVG�WW_=G�2Mwx����N��r0�� ��O�R{���r}����n�~۬��At���l�̟l:������m��    �<�f�jw��/Ln�A�f�E��2u�K�_�YC8x�J�|cX�8���z��/�8"z�ks*�:���4YQ� N�ZK��A$9`��#��Z�f��.Ϧv'=]$v�+�Y�8�H�(J&���4�{\[/�ѩ������7���>*9ZXjA?��Z�|[�� t|a�������J"�B����l�h�&5�����4�/�� >��nL���ю��] 7��3�l�ſ� 0�>
:�ĨjB�o�-!�d�&�V��P��h
��6E�� �3���p�=�N� �>�'� �h�U4�R5��X�䨽�A9����JV��9�D��Os���٪��TR�H�d�o�cu6e]�� �Rϖf"�f���f��-�?[�߳���jD�A 9�j%I�5��vև��dɒIV]�5��A$]��X���A(|῱Tw��tKY���TU��z2]��fC�jJ=ev�e�Tb����491��O�ZU�@h�ݟ�KS��l��`�CME���0�M�J� ��Se�w�s6�My�K� �&�~��|�fk�jJ����}έ� W���D������]='u��}�)'���ABhAM;��3t�vXjA�;~�N����k�5�����'�BpAf(IB�c�δSᩮAyZU���P���W��+�:���X��AM^
�W�t4�N� ��ߜ���6u�W:R�xo�o-�p�K��g�f�7Mv���J�����p�T:4Z��d�Wr(�� �9��r�2Z��2H,4�$�@�Z*_f���B�捩�B��Ȕ�A�w������Q��'�/�ʱ�Od� �[Z�Q+�ɭ����$�j(ήB�H(Tzc���^� ��%)��YCH|�j>t�M�����{_�t�U�����I!�}�W���=G%J31�D�AD ��]�� "���$4�(�yƮ}۶���˵� ��G�9�A�D֮�]]����|�ADͫSE�G�Ǿ��V�� ��UhP�M#��gԏ-��5گ6���xx�AH���ǐ��Xhײ�O-�����uL��*Sh���!L���v��S�m_�}K�IE4��A<��z-��͚m;U�8f�X��m�5}����l,ޱI��8�Jۅ\ݶ}�F��֔���&
?�߳Y��h��kg�軺�ƍ1�@i��A@��z��U�P�����]P�<�����F�px�JܫLMq�/4���n!���2JQ{��n\F����Z> � n�u|��ˎ_�љuM�nѩ�~���+)' �AH�]>?n���|l�Fu�@+� �Aі���u���xj����(D4Y<xU��h��q�N� "ڳ�7ZF��U�cӶ����;]���.�q|�}{\IM��S��]�����ީ9�#�K��V�@]�[U��ڷ�L��r� &�|�d2��9�h��[��S:���]�u�4P�W5)�����5�o]��]����V� ���ڬ�6�x�H�U$�aUB�r�͝%��r��X�������|c��]?����h����zU��BNZ�Q&ߨ���ծф��tLDӼ�t7�EU�Z�.��
[U��8F}�!"/{�H"��[uj҈F?͵�6�'�ժ!�9_?JԩB�VӰi<9�����{%�������uݺ*�A���/7���k����]���Xߏ��N���t�T"�	�Z�U�]5u߫'��P�rE|��I��2DhH���:�i|�:׍�|m��Ti��v����Ęg}����jm�4z���fb��G
��AHo��׾��Su�4hU��;��Q���P��ʌ]�!L�$�FZ>&� $گ���ȦsY��.��R���"@h��=L���U�T���鮣�h��v����X���j�Y)G&�#�� ��e>ZH$��.��/wo��>aK"� ��FR}ؚ4U��lI4iD^���]L݃"�n��jC�ڇ�:�tj��t�(�W�Z?�r��!��%�̄!q�]����r�ž�CuyQ�)���~�RC�hV�>z���>�kw�#�u��+4���O5���.]�ח����zU��($���XW)�F
�:/�D���p�t]!J�=�jQ��w�ݬ�`�1�DŸH�AD�#�v6y]���J`�n�6}WDքq�F}��w�RM�[�_�� �{�g<?�Jֶ�W`Bqt�S�������	iD4L�nU ji��+WC���F�L]�1}^ǤAD����$��5.��F?L�qR�g��h�"{�NAI����-��I��<�˽Wc2M��:+D݇��rB���Z��I@V�K���^}��E�~�AH������D�ZhQ�W��rS����A\�7���uG�V�d=9��'�D�O�H�����^hH�3�5߹��訾r,쩍�r��մA����)s�j�Vu�8~��AH�[�Bcc?�W�#F����B��\
�F�*�F%o�l����A<���Y��g���s��@ƶ�����x:�i|�BTS�G�j�VS�^�h��Y�8�5M��U���*5�����j3���x7�/Wo�5A� "nOyܾ�k��x ��
�zyD4����=<��M�]յ��H�ǵR���hW��&/����.x�K�hy�T�~5��j�����7 ��U�AH���'˙4Pw(�ڄq�\��
�9U�@bY�Ѩ�A���aoj�CF����A -7T�5�-�����a����p�����9���)5��Tb�α�J#P����!\v�?�Z����(�mI����~�R}q�.4�CǶ�e�鋉�R�8hw}0.b�)�׫��%����2&����5e��0��hL��T!g����W�t��Z��
��VY|B��Z���ĩCN����A�Z�����Wb���3<i�n--�I�|�'� _vx>�1��<iW�-C��h*�s��pA�*�Pt��-��
JSĠ��D����7�UuTu�ң�\�AD���l3.N��qpU�N�Ļ���&D�r��IA�g������f����]F�C��TŴ8�AD����	Bۻ�򖉌�e�"�!@\�}�}��Lyj�5�}���e�A2���H����x��W��@\�j��F8�[Ì%6Z���p��`j�6c��$4�#r��c�v-4���۝��{� R�!4������'�������C���ր4����.�'S��a����.�;��϶��H-	������(��A(���m�G%ȕ
_\�;�n���2�]h�����튬�A �ˮyE�@r���)O�/_�I�8ح=�� �*U�@h�]Ҩҽ���s��h�,4��皑�˗���n��O£�ւ��� �܊X;�h�[a��L��8�vg�s�e�U��tP�9�U�jW[�_����՝�A\cqw~�EgYV
bi�ZO�S���S5��w�a?z'V�P���t|i�ىy�o�T��be�٢K^���;i��}�>X�HG3�u��[����6]�����޺�j�e��A��n>w�>�ѫ�A���A��Ib_���P.������z�1k'�~<hi':H��Ы��5���}2�Vǉ7��A0������5;kL���iI[�	!�´���l�/�N�qL34.1�����k��U�~�qD��#�L���h�ة�s��;+I�P�4	"��<�����Jv�"�Lh9����������e;�A$\q���F7���*V��$����AD��nL��dr<���@�A��ÐQa�ATr6�2�<2�n��yGh Hǳ��U#%DU�0(�×a5�A�\`� ����A�[�����Y"Z��q�����Ѝ�L�����8��A��Zww��[��a�V9j���j>�A ]�X�$]B����}�tQ�6���!\�9�\�&7�v��A ��7�;�Ƨ���T"q�U�q����*4�����l�@M�!Q����6��J��KG�A ����A t��M�֨q�䮻�jG����ݣtd�A$    �c5%���P��đ��},'=2CQ� 4���ց4�U�� rVS��i�z�g�֝�A$��~���j�@��2�BF��B��ęY+6Y�,�T"	k�{�ڪDBq�����Qo�}���LC�ґ{�:N��5]���u�B�8(vc���6�"�)4������)�EV}Y�+4���3��P��9��R5����-�N����.�� �&g�/��I����k�7���sSEU�@ܻ￼����������Ē{;T�����������Q�#Q�q>�2O�fY$*4�#�����}�a�$�r4��4	䷿��W+�x��{U�8Z���[='�/ͬA�[��u��o�5�$������E��.�Z���B�@r���
�qe��#a"q����N6���|� 
��XL�n��i�]���&u��:��"颉�� ���g��[?�U�U�<!U��"��_������]���.+�^>�6]�T�r�Q�<��n{2�l��7��t|�������׀�%W�jj�C�e�a���/4$򜉏�;2B��}�>�,3I,�>�A$���ٮ�Z�r+��B�@rv���L����,4$7P\�ѩ���~���R�@Fc]4���%��X�k�qL���'m�\P���Ϸ�_�u|uR�[j�*͵�y\Nēö�16Y����Z��v/�z��]�ä����������~gi`Z|'b"�wo���������i@)Ut���qJI�ʌ*�AD!�������`�)n���J� ��zf�Α�;U�8x���T0ٌN� �0�;������Z����e��AH]n(�J�ƶK͘u�X�[D��4l�5k����Q���z�ɰα�.4����Vr�^� �@;�^�Ѳ�� ��s̓�jU�0(�kM�ms$;�������V��R���d��UU"b�w����b��¥�5��o?�[e�8����{��=���U�Au\��7F<��vqB�5�g�=L����PM�D���t`�W[*��m��2^����P���T��on�Tס)��YO ^� "�akFR� ��.!�~<���5"Y&$4�h��J[��]wJ�e�>zSa��X���b��5jr�����+#v�)<�k��w���.E!�M����2�v!��D\y�'4���7�7z�4��ձ��w��Y/�I��x֓r�"����������ԫ��a��Z}����E$4��&ؚt)R����AV+wҔ�؅J)��yU��ADy[��4�&���Uժqp�����N�:�&�7�����\��9(����	=��R}�t�,�e�q���|T7��kR�n/�����F]����D������lZ���X8��w��VF�Q$�l�%4��a[�o��p�&��wa���A��Of���[/AX�@���ax6����g��A$|7��i��^A)Ӆ�4�4���nu�qPē�QKG��ny��4�����4}�Q5��kA�W5������^�lư���đ�2g���A�������Tq�[U�8(�l%G���5��|��zuR�}W�ˮ=��E�JhO�r��iU��?���d5��F� .�8nO�l���+DB�j�Q��N��ٽB�8x������:���u�������T�FVǝLV#"����6�z�/4��o�v&W�l��x{g�����V�QY� 4$po?�IG�%kG�L�M��Nh9��탍��v�T�h_�V�1R�-������1b�B&4�6�;[	���!���Ϧd�)ҩđ�S;�"�]h��}07��Shh	��9�{>�zْ�X6�V̯�)$틃�� �Qښz��͋O�A� |c��s�eת��r�'SL����hH�4���',�A
X�!���p�j*|�r����5�#��yev�W�2*��N܋cĤA@<!�x�K7IUy���51�vmՄZ��%��y�����%���AD1��Z��ӋSw���nkkp4�t�a�k1��1k� �n�ϒ
�+U�@��7i���A���r�����j�O��"$0iF�~��s邺Q5�#��V�$��	�B�8<��_�Q�h�A���X��q.�=�q�-uG�t�&�
�d���X��)3 �tc��6{U�Pک�N��T��jA��l h��I� z�z>]'Ϸ��!\G�$H׫P�>X�������\�>��}>������Q�1����9th�F�s���:�/��!ж�pPn�:6.����S��_D"fBʵ��dM�5@�
�)�j��zգ���:�C�3]�F�1�<�䇑ZU��8e���5]}WW.u�S�|(j�!q�쭚�|i����N�Y�D����.��tY2�f�-�7kR=%�<[O����~B�Xܛ��(epe� ?��϶�xdy�YNhM�&����~����uwU��N�kQ� ��߭!*JW�5��~�tu|��e��h=ݠ;y��D�q���s.TZk6��1EjR� ��N]j��?�$�PRC�xL���:��5m[�p�c��r1�!�6��LNa��o�I�T����4�'�Z�L��J��(5��w���i�Z���K�CjI��_k@�ž8kH��/+H(�KaG�d+��V��#	h/Ҿ�:����� v�w���Fc�x%5$o�f�Yl��p�z�5�5sB����b���l�_~�'"�:_;��PU2�,5ħ�������k�H��t���?����[ARw�j��������Ƴ�X�DB��������Sٰ�q��������	�F}�jHG ���?� !��V� �~=���I���UU����?�f\��M���&c������_����\z9~WjKn�HA+ޫ������JJϫT#�M�o��ϟ������TC�m��/��;�ZYR@ӫ�������4��Cp�����R���Ͽj�{_a�e�Nj�4+��6��S5�7�J=�h��U�s��z��R�Z�k	�=nv�����D<i��c�V�����P�ح�7C6�,_�I�@BN�I�}�X��o
Ӹ:�Aj�6�8S�jS��V-e�l��ʕ��c�@��a ��0���^�'#��\cA�����DΞ�_��u��Z��z�0�< ��T2�Mw��©�5���������ͦ+��j��!��nf�0��C(�Q5��V����?kIÞ�'�{�h�Ay@�5$��5s�b@��0.�ݛz�e��l�'5�d�%i�Yf��_�g"��r�=�7u�jI.�8�����xE�P�y~���R��6l4�EgQW���PEj�'�������T^G	c�������Ͽ�dׇ�{$4�%����_�[�5���R�P(����\4����<�a��c�IbјRj	_��@��ë������V�Jվ�|��e�v�<wU�����p���NV]�+_�Y�H�I<�P䕪�0������ɬOY�Ϋ���T �G{2�uC	k܇�jp���P���p��I�U�!�a$M�ȶ�����%����̊��a(\�{��1��@�R{U�H�Lb(�JF��%ȤA ���/#�%�]Oe:U�H�E��@�fCq�)4�=^�=~�ay��W�Q��S5������R2������0�e?ޏ�S
A���۪�c}��{J��eWf�aD����/.$��!q�!�Q��	}�����p��'��a��M��oV%���w�B�hǽ}ޕ?��P����S�� �&����{�h0�+{��1�\R�x?��!��pR� (��q��`@�б�0���q�����ܦ:�&���v���Ө�ګ�K���۫����9Q�0��A{�9v	��@��Y��aж9|��.=q-kA�'�>�!u�U���٧�����d��A֝�A��,��ݛ%�l14�/פa�|�~�Ia�ʫ��3�w��TFS����%������j|g���>��.u�y�|��g�a0䍎;�ۍ �^��s��    0�f����7�o\{9~=�vŝ��0>�3ןH[��!�.:ܝӰ�+-EQ[U�(xp��嬽���@��0������c�s*���V;���T��c���ݸ���c���Q8n�g��y��)K߄��x.�8��
����qT�a(�6�ۚ�S�h���f�<��vKV]�84�F�p�͓)#���F©Y���%t�sivt���p�����2[m���a$=7;���ؓ]G�l�jK��z*��Į]��˭>�<ɢ/��0rZ?n�>��T�?��a.�?<m?]9ڒɺ�D��a�����{�^���ɢ���0>���>�l�/"�B� �������0����5�!;����:CEJ��0��_���0P�c�d�4�����㕐Kȅ�^�0�|ȧ����٨QO3�>�ݰ*��E��0�.��/OWwLGi(��at�ߞ����2�uC�y4����B�@g��fw2��T�p�ЁӐF�)�ɗ���A4bw�:Z,�	��k$Sb�J��ok�ܟM#:��	.򒄆��|#�`�ˍs� ���	d�t�y��mJ�����Dmڦ��8S�j	;���(�ީF�s�V3H�Z�������nF��Q5�!o�Sp���;�N�0�f
e�*'rxU�H�|*����o�e���a<�t�鉴i�X�œ��Ё��͏�8:j�k��S�w���ej��0����m�l$��V]h	�Lm�YdӇ�f�0�<����| �a �����P�bw�4�����GS�%n�M���r�7����]hH��� �^D�f���������������j���6cX�&g��]��7����R�8��?ܞ-��Y��f*5���;Kn��2gPh��ǝi��h7�K�Qh�n�fW8iB�8"�:�?YI�Ė%	kI�u��0�u��s��G�8�d�z=��Dh
�E��Vd�uŭ��0����ڟ�o��q�A ������V5��۳���7¤�W5&'�~z�ϖT6슚�a0x�}�c�˫\�a ���)�󅆁����;[\d6�dK�05�9DjI�!O�a ���۟�/OHw�W5��|������Ch��>mL5�d6�}���p���l
���0��0�ܵ1�bĩR�Q5����f�1� �^�0vb�O�FL14��LFr+f�ǖ:n-�I�H��J�T#i�a3���v�L��pt�i��W5��<��8�e_ǅ������b
���ҷ�4���@��ֺŶ���B[���x��3L1�Mj�˾�)7����-��0���u$��a$�ƞ�����!4�$��
��ک��yg�ŏ���\Q����F�g}��'�^�0.x�1�!���Z� �\c�uk}&�3��LF�e�5��{����+V�������p����ej�LVC1�Kj	��Z	��WLB���׿~���o��d7Վ����4���o���%*(hܾͣ	�fkX� �:��ҥ_h-��U#��?���UKV�S5�����ٿ~�r�vy�2iO&�����4ԃ��%�,���:�n{�4�g����L�)v�O����_����%����Wg�0n���Ss����.������Q�m��5��7�����,[],�I�Hȏ����u���[�bo�B[���~�]�5�զ�RC5X�o���ɊB�tUC����550g��(�F�i[��K%U+.�0��o�L����")4��������NvC]�f���P~��m��R�<B�糱�ZC}>�#��0��PBq� 4�sc�o�>���a ����G�#�_�CG[�ޞ�FWī���P���qx�����»�_�'�]v�}���<P�jU�MvHS4�95ǔ���j>_��c�GK���j�a �k�,��¾�7�5�[�.���PD65�1r�2
*4���km�ߌ ~9XYh�����t%IV�S��0��R�Î���(GU�X|�7�R���J�0N.���@�l�Q5�.�n6;ӈ$�|� $4��������.�C�k������F*�u����&�<������?f�������TA�$a"�YZ�YtkI$#����#4������L1����?i��Ԝu$e�`�0��Ͽ�Cפa ��>m~�����UC�M6����q�0�)�YÏ�L�ת���.{<�*F�h*��T�ւ�j��M�� ��O��Gi�[%�"�3i
9�_m���h�P�B�[7c�<��E���0rd����DU�8�5�:��k2iwq���`)����N�0��"ˎB��u�j
7(�G�Jv�0����vk=��+_d8c�N�ikIޚ�:�}y��볩Dr�闿N��Wz�϶��3�y}��R��j(r
�����W��W5�������nUCɭ���[u
	�����X��Y�l�QI�?r`6�w��&���a�îi�\6�a ��ה��]>� �ȩ�+I�|�G8Iy0����d�+$h|-���'���B���vxXAu#avJ����B������'���u�5�e�e}{hRq�kI����)ŽM�.U��#��
La6�Q�a �K0|��4ds<�ʍMhWx_�[[;�[��c��r���)���a �'C�6_�$�+J$���x��9�I�".�鄆���d;�����k7�a$\I��5�o�͉+�z�a$t׵5}��&eS��A���P�&B�8hwΦjD2���:k����4m�$���T"i)@p�3��!��r�HX�@�%��)���>+�V5�q�"S�IK�?e.��0.�ݚN�d�.�R
	S���7E�<�a �Ֆ$��r�4��{S�%m��oB�@ho=�ʚ[�q�š\hﭏ�Pc;5��T���T8��ҕ�A m�k�H���l�0����鲜�6�Ņ�0�MFNF�����B�@<������FE�%	kI�V�֯��.�7����|
����֯���a��LF��(M�����T-S�:2�\ �a �j����=Wu�)k3����͚n�ڜ���'�9���D�0oT�Mv����MJ�_lm����&��U5��������U����{<��1�����\B�P8��m��~x����F�0���dw[Si�u���"4�[�b���z�)M�o�7���?�uE���_U����)(`���b������duK�4������Z������0�#��JZ��-s脆��\�u �U5��������N�n𪆱�>{v�(����&���s���Oƨ�Y�kU�Px�=mM����N�0����BIQ�"VhHֵ��S5��6�O��1N�V��άa$ܒ�l�K��R�< 
#�P���䷱Ѷ�2m��K�RG�ʭMh
y��nk����'.��0��+�w&���8�FTh	�c�'�˚H�ayb��6��Ʋ���0��?�EEs��T4{��b+�b���0.����	,�̅��8�Kn����l�k�ϓKL�$�Zv~F�]�����x֨FBn��|2}��j��c��0����Ŷ:�ї�/B�@���t<'��N�Q5����3��U2�a$�;ܚj�:�����'4���vm͸ɨ+o�����T[ܑ��X������zk�d�QelٸIh7%��9�bR��0���e�U�T� ���`��%��I�B�8�<�Ŗy����R5�v�O��3i���a �UK+�n�����q��V�p��A��k����r�N�A��7�g���N�0n�m�2��ET�a x}�썩b����;iL�O�-w����s��yH�j�=Xߜ.��e�h�0�܁����F��6iHǣ[��'S��n��iTc�y���lJ��zQ��O�����Յ�6iI�~��M�d5FU�H܊�:l������l7�d5�"-4�$p��`_��)*���pC�c�"��q@�5��i�QWZ�Pɬa yT�O���j���m=Wp�ڦ��T���a �    5m%l�t؄�4G(L��d4����0�`���|l6_?�a(9�j�AV�㦼vFB[[c�iOWG}�F���nM�d7��,�a,\õ��nTci���������Q�0�|٘J��hW4{B��gk�>ױ��j
�_G��rKF][���9]�M�[ds<P�[۬a����&�2�(4ĭ�hMFC�jm�kV+mU��a(�������Oe[^�0��e�*����\�6d4���B�@Z������隱Y~�'��),�F/��I�@�i��`�i#��-�]��t�]���B�P�[���֒����/
����p�­ѹO��m�Q(4�gzL�~d4��GU�@xr�����6E��0��2�-���H��0�_S���$R�@T5��;����d5��7����8���C�{ɤa ��>��sK4��ul~�H���y�f�w���j�jO�����n�)�n��������ar(b�B�@���HLaX6�,_�I�P���3��'�i H�j	�aǝ��K�ͶEB��0�aw��G��^�I���p��'[�KO�[�r�LF�CM����E�d�0��Z�/�&������U��D�ٺR5�ލ��	��Tcq9�q��X*=M
���v����:�![.���\͵�d?�����˹�ϖ;k6Z&Y�Z���t�?[].Y�0�6'���Q��>��ұs���+$`�e�R���6�q���ND�3��O��R�n,$������xJTP�4�P��r4�5��(�a(��i8�ڞMV��ɬa$�v%I��Fs:���d��̘5�����4j2U�@ڼ� ��5[�kvj��=�YRk�V�0���
Sz*m�e� ��om��,]�Y�8j����h�նh&4���ϻ����d�� gC�����c�AӔ��M����Ϳ���<*��RU� x=�r��j�����4S�����QY�R�ڗ��ayd��<�a,]���_��:vU���שҬ%]èx�̙�X^!���+࿗�������V;��K#�:��!q*٤�
������c9g�E�Bj��gA;���A]j	�~J1�+�J�!V25Vj�?����jX�1���4�/ϭŵOf���TC�C�,�ϲ�ViqN+8X�F�h9�VjH�SJ,%��h�;��
&	U�� ie"��0��=��Q��TY^�F�u(N��R�Pr<v�[Q�
�����`JHe��/�I�Hbn�gi��Vc�+5����g��]�䤛r��AI[���q�7>�HAF�j	�� N6Z�����n-i�l5���4�$VJ�ݘA��@R�@�JZA��M�a$�ޚ$����<�LF�穝W}�-Z����A��j_��b���0���3��4�K�0��3,㟲Q�<�L�[�!�d~��0nK���6��-.	kשׂH��-R�H�ܱДs����0��a$�ȕM���f�j�[�$�ͦ�F�0�)��'�
�����wa#�\���V��v�_X���^�su��D�0�&���[.O��.�V�0�v:�X#Gd6*(h��rp�r���6�}~�0��ڥ�v+P���A(<�k����w���J�0v]עD���ؙ��ԙwC�4���jm-����W4���v�
��XRJG#S�����)��xMf�!�Y�Px�=n�k���g�Y�H�V�1^�d���a$]�<?�mai6��̵]�4{6���,AX�@:vdW�t� ��a$u��ah�����B�PFj���8��a����ۚ[�I�r�u$��a$1���$[��3K���z>�5c,͍���ꛒ*���so�9fPjU�KwtV��p��4��Q5%g<�_��&�<Ku>"���ɱ�/�}}��R�G�Pf"�2�U$2u��0
<O׻��V��~#����v����z�ڿ$��F�Gܗ�6]��L/��J��0����8S�0��#$�[jIÍr�\�$����%�TjI�mr֐�J�R�Hx.���"�$zU�@���pc�1���UA�T���AR��˙��0��5$�M6kq�Tj��=|�~�?YM��U�H<��
f��K�R�a$!��7����I�����0�����l��k
W��9��{9��A��v��V̚�u���gc�r��qs��O]\�jC���G�&����U5����N�ir��x�d7%/�
kK.�5�� �/)w�Y�H�����z[��n�/-�Jca�~{�]-�f�u*�\<�I�Pr�����b���[jE\GѼ�K�ࢮ�����Ԝ�R5���߸)��邭�a]��4�Sel�r�VjI�׳v��[U�2�����m6��e2iH�S�n��`ͺ'�,߫�B��J�rgPj
y�Ǎe3u���T�a�S���]^z��sw�U,M�	c�8�����:jV(F��FB����t=v6[�iB�P�/�������Vlק��Ucᛮ����ɦwŧGh��Z�Ѽ䲗����7�S�˭$}�jm�_��j&��IP�a$��y�׆K
t�+9���R�8"�%_��t㠽u���~�Vc�)�{U�H(�y�>�i��_��J#�~�$*$�V�!]+H(a��T"�1]���f��Kyl�ak�h�6M�IT5��֏�G3�Yj�����y�N�0j��#.��I�8���x�]��-�k�5���C�������z��6���ȝ�a$�vI�R�Uj	����/V�TӨ��NۓuWK=C^rrK#����QU_�j���H㟫�ag����ƒ�����篣UQ���ri;2�P�U]��gC���篶U���f������T�`e	˳�a,��~�z�φ����n-b�����0�V��w0k	����������(�\�!��%�m6�q�0�c7�o_�5ǊY�xs�\�F�����l�0�=�-��!U�M��0�<^V���Hj�k�T#!����d;�x�CsE�Uh
�]ס��Oh
'b����i�G_�����p��0bo2�v.�jHn�r�7�d4�q��ր�T^�j����O��M
'�����0��"I��^�0��ڞ��a�q��#4�$�9��	OaQ�Qj
�^W�t�/ 4�᡻׫.&��L�a <�{���)��X��
#����t���^�ʅ��p�Bä��h�֪��ƃ�����a��ظ�0�:�(�_�d�����T�`���z��l�UHZ��c���탍�<�ҋƐ�ן�>Qx:ʕ�7B�b^�{2�V˘��0�������lx��,5ec<U�jY> 4��˱�gS ��������0��k�n�����kkU�H�ܛи�$�͇W4��Q$�g�QG���a .�q� �~�a$t���|4~|�U�pg#��U(�*nN����Mv���ũ.x�ٛ5��%{�j�)S�j(TCi9�d
R�v��bB�@�q}>�l�=���5��0�|����f�"�*4��(�����Z�+u�m�e�0J�l?]oX�V�2�Ah���'S!Y�}q�F��6��l5�e@�jIx���~����gHL��jHL ��������t�F�0����_��������X���&��������B�8(����^��6)��kU�@(-k�h�H��T�Z����\��K��!�����n�l�X����q8�ϬK�r[��a XE�c��0��k�t6��i�R��$4%�怷����;���aC���+69BEκ�0n���C�/5��[�ѽ�W+5��\׏��$YM��|�D�U[����T�f���5����X��Ucq��aC9[��N;B�Hx�ݘ�b�Q�Ka�a #�Z�!TK�I�@��+H\qy"4�����]�G���'bqa!4��n2�lK"6K'IhJ��dV���%4%Wl���&d6�"yOh
mm~2m'��8��0�a ��MF]_�b�N���t0?�P���B�+Q��6Eh
��'�v��N(�B�H��`���N��0��]{K��l�P 3  P�h�@��ѼL�.5��6��`Jv���CB�@h{�|�������?���4]�jT�~ۻO&瀬&'�R5���nw������O�a$S��W�cC�C�oow� ���#8iG���qK7�mQ1,4�$γ�Lq6��^�V�0�&wP>�.ɬ��bB�PZ~�א����0���a><,YId6��g=kJ�b�����?�f@i�d]y�"4%�������O�a$57�����Ɨ)�����?��
m��׍�B�0���&��׎�XhH���G[�H2�: �����3{Rr��/*ʄ��p���L��el�|(����&{������H���3e��~k�����eB�XzN4ܘj��th
[h	�梙�\2�6�j������.�X��TC�Z��6����V����N�1��hr�WY�-4���ٍ�il@�jG�7�h�d��Gh	5��٨/��B�@����ْ�KFSX�V5�v���d*}h��ŋG�F�C�GS��ɳ�b�j
Wu�CI�`]�Pȏ}��qlro9�@h�˓IFe��	����2�&4��s����`��v��.4�%�}뫓v�"n!4�$�[I�V��X~��F��r�B)󔄆������i)�� 4dN����*w�j�{m�m:w��k�jIǽ
W��E'V�a$���O�68dԕYB�@ܻ���o���´����mVhy�۽�䎭��:Ph	����Ƿ��l�̱���59�l�+�O���p��l��BV]Y!4����]S����#4��VkN[�|e�a$��e0u ���&B�@z�9L��h[|���������B��b#��a �}hS�͝!\�j{���j����
�UhJ�͜נ4E���0�țɭ)pCVS�Z�jI����m���Λ��W4���*�����B`U�X�|h�-h�,�ɤa$���?��~��(�ʄ�!$-�v�/�O�Z6[�:�R����޸պzY� 4���l5M�,�텆���5$eVhIȅ�O�{}����2���E�E{�W�H��F�xU�H��n�ow��{(�h��1����`��ٶ���B������t4�r��ګ��S�V���t�A,\�EW^6���$Y�"4�$W#lL_e��{xU�H\�}�������y��u��0N��'K*Y��P:+B�H�a����zHuEEhJ��[���)���'Cire�1��#�1�pB�X򠮕0ev��0N�=?�-e�ֽ�a ���o�{����n[��	bq9>k�q�>24��q�pY�"��N��a<J��������%c�B�@x����ʈ��wNB�Hxx���p4.Wj
P\lc!o��lYz����<.�a,{�'[�>�c�EhJn�5�FgŲ^�\��u��&{��ۄ���[;���aY��iy;(4�W�q��f���)��*�C�9����L|�x)��B�@ܻ����?���u�'�,�F�a�/�/�'
"�v�0�k�ý)
7����a(�_k�?d��HF��ƭ6.m��qp����r_:u��a ��>�{S[ݞFS��B�X��L�gˀ�>�*Ս�A,\���yU�P��Y�ՇOf}�j��(���
����5m�9����vc8�
Xn�r!�J�Egw�a,���/�`m�[�Z�0��#ױĥC9iKn�m:}�Q_��B!���-Y�����$4�$��ZC�,��Y�H�lcI��+ʳ+�4I������`p�f�bחF�����ɰ`��F��JC�y�:�6�1+R�Px��J��I#�m��|��fñ����������e�w�J���U5�$O�2��U��+�j	{����B�͊(��0N������(e�-��I�@x����2�v6[7�����kY�S5����O�IH��U�j	O�6�%_�v���{���h�������ǭ%Cq��������۹d4ҵ��a m��hIƛ�.ܔI�Hx�]�+U�@r�`\'���v���U�B^�4>�3��7����l46�����z��Y���j/�R�H<�������j}�L� ���6l�ͺ^�0�ȩ��o��d�M-Qo�a(���ϖj06���"5$��+IZU�H(���y���U��7�4$���z�&�i�rc�4���8��q�m(i�s/�9R�P���T�l�UCq��mJ��r����6;�Y���ѥ?=k� ?ؾ��f�����A[췳��q�^��Nf#i��>l�)������� �S5����~O�i�<��a��Y�r�<���{U�^���q_?mߜ��̹�ˡ�UC���t�d�SP�U5����o��26�Lʔ���g��f�E���0��� ���FU�@��4x4-��H�f)34\[�
�����|{�Ƭ���3��7�t����R�Hr��\}���
�����T曌��*��Oj�[�������H�����{�p���y4�M9�Cj
�������B$YmSC���?kI�7}��7��A��YB� r������t��R�P�m�G�C�
2j%4��喭�K��2�+Y�#5�� k8��Y���,���f�k*s�qԔ��������ȭ�a 5��[��E�a t�N��ƥKU�$�a$ܱ�lM_����;U�H߹����hj����R�@"w�0uaIVS>tq�&4�������-A#PK㠓���c��幼�Y������"��X����ҁZj��D`b9��ˏ�C> ����=$1�b[����H�V;���3��&#�Q�#�2F��:ۊ$F�C�!�]_'�V*�o�@>�Y�2��@ZD��+:�}�b8$F��� a�|       �      x������ � �      �      x������ � �      W   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      Y      x������ � �      [      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
��W��o5��YۜA(�y�4Ǵ�p�D��6g����1�U�ڊ�R���(�8��<�����Lo8�H��Ɔt��HF�t�K���:VQ[�8�1�;�킃 `t+b�,�C������-���{G%��9��o�aTM7�)��eW����`<h�&^�T��#�v���3�gX7Q�zm��h��������3��S���>'PPq��2 ��=�Ȫ����(E.l���������jƌ�Q��M�W��P���� C�V��q+��3��[�-p������`+��F�+����E�,�?�����Q/Xr�x����3%���~1�X�?�q�����u# �s5����;f���^7֊�e��>�0l�Q��(]�����!��.���ڎ�%��M�o��t�������.b��F�8r�4T|�a�E�Jz�����34�r&�P�(�b�aj��9֍0�	�8�/�!2:�!�,Q`��O!�R'b_�2�����Oh�~����x ]5)4(��)���R��e7��Ѧ�����M;�58��&Z1m\�U.��t���[Ix��V�g8�T��0f����Ue�g��-"���d��"����44m"z4j��m�P�����hC�P�+PІy�`M���_�T6b��_(^LԴ�]ƹ<6����n�່���{�xflP�z��f�0�U::�������I!V����l���0���*@yq���t�	W�.�gq��|R�5��1"��B�Pa�N͂W�F�9�'�VZ�)��� ��n��O��i�!���wx�������S�Z���lʔBM[�(�c����_��7r��!&�Ciy���!]���eEG��{�uܰ	��V�3L�8�0�Lh"��Q}#��\e5g3����μr,ǆt̠�L�#3�c����ӽ&�%RVy\���b���ᭈ)S�HW��NC�Ŧ������i|�7��yuM���eAV���i��4�+M�Kg1��A�i[��x��I*Lݹ'�0�I�H,��@��躔bV�D���g�Tx/�:�<hp����1&<v��abO��7F)Be�1�ח&��#��S-iE^�<��I"�i��c��\N�(���#��gE�"��`�E���1�z��C,��'�h�'�L@pv��c�;;�$�z$��E�������$-/���3�FJ�Q,/����D�y/r�3L�B��P1N�b�K2�<�x��`F䍘�����դ����FW'ƒUY*�ίtɈ�Z�����T�G������XJC�����V��I��ڜ1ܽ8G2l�m��|���!2�������!�=?-i�j,�B6���|!��aw������I�^��:.�O_~���{���w����؜��S:�<)�hT�-*�'/L�?I��j����:�(��	BG�ڪx�Ĵ�p,����]8��P�iwx<X��M���ܙ5�>�E��c:w,��pp|ht�B�v���J�Z�}W���PƜ�+fƩ�Ct�yb��ja1�1�7�4�2(�	G���,�X�Ea�@��a����b��hc����*����������;nH���|b��sE�i�)�A��g`"!b�����0�����9�f���t��EL��,�l���2�u�1��'�L�bA�D���~B�)>4D��:Yj�E�r��J�}�j���1x�\�4��\~��.�ݙ�VY]�ȅi|�%����S�1jFN����ݱ�O��Cp4JǪ�G�Ѩ$%���H=r���㦭��	���SK�`�_;��Q���躝�B���iK�c�mp�H	�´�!2�<�棓�kM&.�e�R����h`�!�{�� ��^.j*bv�E�q*��GD�n	OBإ����ϳ�u����b��ϭ�D�s#<6m�墷����W�Y?�%A���� �_��mg��X��[|�{_�XU,�Iw�X�=ۚ��e`��s�&�U�CF0�2`xaCU�X���H��<q�_ޛɂ��Rו؀e��x�Ɋ����v51QxAd���砳�=������y�`��Ѷ᱓,m��c_��g�>9�q�b�{����2�AR*�XCx�2�712�~��/��W��58�h�C���������\�U���Z���+)Ik�ȇ{���v�P
OD�V�a)TD6bF��y���FK�+6/ؚ���h{۴6�,�e\��P��*�ǳIs�5�神\؀�Λ��R܆�zOX���g%(�������+-"f������E������j�H� _�d,�����
b�/����o_���J�Ssjc(z���#���LA���GHurlt8I��z���`�'�PL_&&�5���OU�{��"x�1�u_�aח��յ�(��MC<Ƃ����1^ț����6c ���Cc��V��x9����~�#�NV��(�@e�z<��|���!&��<���+!#S��3L����3�l�W�[���-��F���5��Oڍu�ɫQc��k ���1*b�&�w2ѧ��g+N2ll$7��U�K-d�\��O9�����B
-p��q�`"~G��M2i��Z�uacs��\F�S�.��}eya�9�
b�^u31�#<&��7�>�V���0����'p��'��%�    	�q�$h�+�ab��tŞfA�V��>�ǿ����`��{��0=�64�յ���?vni�}����G�C��`�$f�p�	=k�n����3L-��H�1X�P�3����^��
`�;3���ML��wBEm�I��&&�Ja�W-a����su�['Ͳ�p�1�2ф�A6�aJ�ؠ�nb�39�a�� -�)�����,a�	?<k�9ML����rJ�Q�\�bb�x[��TJ��&@!<8�ch�j?ٲ|���8�=+�й0���1�cV��۽Kq���C�K�s�����>kn&v)�q�������#^��5�0�2�'�T�ch���2���p�X�#9u��;�PY�9��N�&�?� �%t�'CɨO�G�TV�K����y���npJ�X�s{.J����Q51^�����0�BIJ?+z��껉iZ�C�q��x���>7"��+R�]�U��76p�F�HGz�;d�c�SE�!*o�T������U�;�:��l��&���J1r:�f ѱ��Ct�ß�tw���q�HJ,���W]�ʡ^�o�z*4[\T�0����0@c��I�i!r��d���{[�����p�y�ȏ���N ;�2��,�q�)v*w�w���~���h�f��-�JV� ���z����H�*�^ٛ��J�<�C��>��G�i�c#�^,7|����^$�#�����-V{���`�'�=c@ز}Z�a	�^���uő�i���o�Dl7⸽�0e�TI
{V���ણ-��4�Jl�b�տ�.�d7'�_��`��V�M�
�sELn�ɦ)Ӿ����66dM�������hM��N2D�]�G���ĺv�y���Z��БK��
�bQy�'��ϼ��Ym�Wmh���|�W�0 �	C�G�^,�SFGSV�B�RUV�0q�6+���"�}Ҙ��L�/������
��%���$��0�A���#ϤI4�Q�[�A�����i��3b�]RG��T1I'Cv��XoBJ.�t����ir&&����2�H�10��ZpI���Dș���Xo���~F�� ���:{��c:7�x(������h�LL��JE��D2=B�2�t�H�G��Hw���mf�j������[���2L��;7#�ߣ"��!��(h�f�b�e�љI�5W(�Z^T�"��]z>�����F�$'n�ب�V8��/�UW�5\6�}k�xG(�#�܄��&�7ӂbհ�ta�}��I\챰CL`�����@_�{P1�沑�A�U��"ߔ�.L�nZH�ʪ �����I/���8y�o1���ׄi�;�]ܾ�a�������w<�aơ���N�G��y�����//�c�E&�!���7�J��im���4�����7�X��ʦS� �aD�@�9�(Z[\ڦ��j:�h�o:��-��06�o|��
M��Վ�=!~Fg���h��ML����d���!*��C�-<D� ��؊+4F��t�$�#�h��ӭ�8`%o���M�Ax8�J���~��&������5��+9W�m7�[�3��p�!#�{�^�N;��H+�\jw��ܳ�&ƭ}��ō�C�����b����O��1��˹dZ?��?'��\���O1W7��BV��ɦ!&ZW.M��\k�t��i���/L/MA�jx��1QKS�GL3��(��46k������o���˯|������\-�N% ��׷Ӻ�ؐ�! �u��%�w��Jd*/<�-NE՛�M̜M���x;Akٱյ����kup��$V݀��9Nb��n�9�.�ig�B�Ѿ@��5�t��.v5�pU�yw� o����&s�7�U9�a;�F{���d�c�[!�0єc�[^""�r`����*��2��M9�Ti�{��	�,&�]70��S�Y:�r�Y����u��uld\$a\}��1���Xgx&�R�M�8��j�H��w*1�ye�f<��$�\˛{��Z\aa�aĿl��]Рylq)m�i���V���4׺���_F�����M]xH�V �<���N��.r�|�z>0�7�ޡ��.7�6<�a������x�Lm}ex�|$���7��˃=*�>�X���齾�nvND�����|wOLf֊��͚���06)���I���6�4e!�8R�2��rc�L����L�U廹k�Jx*b�;~�/ܙ2���W�6w@e�����AxH�}�Ǜ�nLl��I_W�B �U���lݻ}����6|��Dkc%<�biK..�V�ڑ/a�d\����CD� ��X��j">:�.&&���T��1�z	:<BZeyN��*m��������N~�f��J��31����7p�GL�U�^^�c:B�!�h��<~���c��"��!s�w?1��X�';{��J��ibja�%.�]c���%�Q3����u�}WsL��T nb��)��w�GW�sqq��}rdY�"y�W�bb�Ò�/yXvVW=,qYC�t�n�gvv&6��Ϊ	�a���̫���G>�5�|#YjCd�.I�ODs=�'�\��3�n����}W�~�����S&V����i�2��������$.��t��;�|JlY�5�ц��1۾��e#s��I�M��M)s{����,���GcD�w�%�q����P�Psl�{���P���&�����T�i���B6�DR�1�7��.̔��+�đX}31Uvy���7�N1M���g��.��k�=Zm��!
��Y�F��.��f�p�8*��#�aZ@�Vl`���*aҵ�� �l��ޥP�f���Yp��d��Ĵ<��W��<M����J��s���ޙ��!^�K�9���P|>�� +{_�LF\׃B���ۖ�.m[�^��BW�Շd�ٴ�&!�y�<è��\����R����OBd'�	+5��3Jsl`\*Βk��"$Mގ�9CG�;LL�#�g�-0K>FD�30��oM:�*���I���.3� )I�����"��k�1��{T�\��'/�2}�1�I�E��5�a�q�_�*=~cCC�,	I�{���d?�=���UTR�`��F��vq	Ck�1Qu�����4DC�q곙Ι� ��3H?sBƚ7�87�o�րս��.�� ��cԝ�(���eiib�G(��e�����-��LS�\�������e9$7O��o��b�o5��V�cn��8	'D�ۮ0�G���bc�>tF�m�	�t�ėj��-��<&�(�vmA�Q6�0֩��aN�Q~lu�P�yx�W�Ml��/[^�1�M.\��Y�CFr��4�c@���,��Ĉ���a}Q�@W�N�����x��H�����������^�aʶ�vkrp�V6F���k�+����_BG2F�i�eOFq��Py�џp#y��3s�<sE&0�ԉ3x�ӌ�1��$���l��!��"�"D��oD�S�^�r	��2����X&����T�.�5�����6q쵒71-m�J��n�29B�~=LL�~��đ��Lյ��Iv�]⢏O�Ɨ�7kBF:K�e���g	'�!"�����\�'�Vӎ�y��K=P��N:�5;����|�1*��ߺ���vq�X�#��ġ�哎=##�y�}	��y��~�X��#��MLm�a>����&����xR-����A!����"�-�Axl��o}V�BЅ)С��&*��O��_)�k-~.,�2��y6\��q�X����k���[����L����"O.4��r�qQ-}�3�FYr���L��{��E\_��V�Nx��=��n����{�M�5���O�,�4`�i������y�Q!�*���������Ov�Y�t�h�
�A*�G�l梇�ab�g�aU�4C5���J6�C(p�]&����fs$�i�aW�	_�;�be-(�b����EL�q!��V�z��4Y"#z*�h&��=M�v�m/�[��l��+�΍�Q����V�1:�\{@Ʒg$��i�K��i    =M�5��s	W�dE&�	b�4uݥ���Ĩ�iq��4CˋF�H�aLy�Y���dD�t�����ѐ�T��������%x�����">�9t䛫��/��q�۾àM.� Y��D��i��U��ܜ5��)�
j�/7w���>���&���e�֨�yH�:�4�Pbn&�-��UUp.L	n�-n��6?���]6�1��)�t��X^/hݒ�0UFL�n��o��&e<p���\.�_n[$O�"y�&�ER.��եM����<⏱2e�p��ZVwt�h�Q�T϶�0����a}=ɼǣ�gNhxX�}�Y�(�C��[O����-�������O��n�@m�SVX�*�V�_����q-��{զ�u�p�e"���y�4�3m3�8d��,;>n�x�a[È�b��A���=��9r��&j����Ƞ�F����,|����$|���sp	�/���Tߺ�Z��t����(:	\$����yL�Z�9Iis_;�]���m�0�?���F��*[a�c�a�����^��5��c#�Z3�ތ~1��7�kn0��"����Nd�u!2�2W(2l���l�=��g�i��E���q�������f��AUI�a'� ���d�<�D�^�e��ҫ)��4:�>�f�ڿ	���0i�o��߻r��\{|���|hy�&D�1������!�Ó���P��*s��w%����wͭzd�ǻ̯<.0�+�_�|����r����,��>���k6Q��A�"E&ZPDn�����a��TO
�0��~�:3�m�&���ab�;L��D��d��p���Ą�p6�'b��a���c�<�>!|`ǍV��ҋ��a��4�
��B�]�W��2tQ��f#��g�͒�+�l�HH�>���ĝ_G�:��!dȘ���і�Nj%l��>`��Hov��Z=�<�鬯�fbrA���W2ǰK���K��s�x�`�|��JDd61����Ȧ���j=��c��!$��:�댈���Xj*秸OM�YJ����+��D��R���'�����)�f�J8�]!��0}L̖o�ђM��١� ��LlTr�'/jc?��� ?ԁ
���7���f�ɳJ�Aj�>͇�1[ʐ�@. ��8����!b:�Ѡ�o��t�vH4.��~���Z�2��ru��=MǡM.�q��ΐ��1��ʳ+b�-�sL�W`�W�"�*P"R�Bh̸s��	)�-?Pr�H"�H&E��@��&&�%	�y!sO=~�T�%ƚ�6�_Z��ehu-�Dx�!x<��=���?�O�S�<�,������|�����>^�$��ޓ�H�:�FA7M�n��#���x���q�B�4�UK�C�P@ț�H�?l�w�Q˞�c�����|����3�`����#lvl=\��J��Bܜc��<>�"i�W���]Mٓ�a��u�?������NS/<+��y� ?���4�L��ش�%0UX½`51�8<S&pQ�8=&���c>�w�GB>�����~�����#�L'��<���㨿ѱ��P���KfDF���	0�L���S�F�I��8S�Q�����p���
��;B3��Fr��z�V6V����	-YAx8y`E,9�lc�A�0:�b���@gy-3����n�.�ZN%v���b�6�Ӫ�+զ�c�ăIMY%d����C&����6 �d71�tx�.Rc<���3n�l����4��p� f���TT42l�݀T�q^��˥	�zG �i?�YM��x<��L&Ff5��V%e?�X2�zhU���X�T��ꐑ��9�䟉��E��XZ鄯qX_J+�+�-	��J��Z�,뼈��I�@�"�������f�kϥ���ڭ�JD�tW����l՘��,�Y	�Y��:����y�=;�cl�*�N��o}1�7Ä�6��]Gp�@��>z�s��W��ۯ/WC\kҚ�^�.&�5��B��2N��Be�c�)c<6P�R��⋉�)cBe&�����T�q�q�Vt;�c\u��dhy�`-�=I*��j�k*
?&$ls�b!m�Tb�<��&64	�e�a��q&&~Y"k�,�b�<���Ԏc2�k�q����y����7����p^eQ���s���05�N��U��SM.��Oc�?�j�ou�*�g1���&��H��Sf��������ď�jb����A�1&j�6��u����$����yf���H��*{qs��Ǹe"����j��u��~�{�� �+�Ӟ�9�C���?
����f"���L���*ʥ�Ӓ+�rW~�+@��"q��V$<X�^���H�&ֵ����i�*���=�ę��mf<�5�]�򻉑-�A�[���ZU��`��&i~D�����xN˘�Ig����R�S%)'t6?�=���{�Q�r �$�����~�M�+{�/���e+�����48�/�z.ȸ�a��.&?M�x�J�p�G
�R�ћu�J��X�tOb��9��l'��XL4�k7U<ǭd2�Y3�u�v��^h:o���=�xw�h'0ᱏ�kZ�(r�M��k"��#����i9ۀp����&�	���۳[�)�ELuq�i��E��(��<�6��7��	1�c�t�>b�8�2L5��qO�1L��i�3��y��C�C�tl��t��q4=G����.g��Uw���Hm>����IL��H
�P�?.�ـ�Sw��,�<�4�c˯�9��)�g�bOBm�a�A�β������{ڌ�7S*��Z'R&,�����-{r���	�i��^���W �
w���O<�v���31+P{��A�+I�ഖ�r!`��!I��=�09L�?\�q�c{��`q�e��]&����m��1�EK\���b�y�ͧ�q�L��X��R���Z��8 ǌ�o�,[��m܍���9��͸�{��u�q/�I�r��,���.{���13K�
J�ִ�����c�&�&��\��ӝy� ��E޶ءd>�1B���ɭ��v�)������O�G��Gv�({|��5�f�y%b��
��!$��T\{.%�~X��o�	�®d��nr�e�>�FG̬G����!��a��O�_CZ��Ǘ�k���o?�,��*���-����!��=E�_���L���:���2X}1�wn�׆��!�1q�<�?�M؝��'�oC�������o�|6��a��I65��*RY�T���Tx+s�b�F�@{9LL�|�TH�X�qO���a�f0.X�7�x�p�'�A�-�����������j�+ ����������#�@�a��`|�-{�	�E`9]����eO�� �_���k#�-|�obcjɾR}4�x�����rLQ���l�.���gY��XF�#��c�0_)��dX���y��?�Vx�����|��۟��꾏��׿���Mx��U'�'��~aj�7Ŝ���{�X�R2�O�Qz㰔����$uV�n�b�%�c$%@5�Z��k��Ĵk�c������?��L���^N����c�MY�\�$q	_��/3Ow�j������N��'�57/���{��=���ݑ��d���hd;m�ll;Цݡ���m�؂ýà��kj	�F���=L���Ӳ���]��;���{}sL=n����]�.k��a#�"�'NtrU<��h�˰���_���ߌ�
\v�5�dou�X�ye�[��nv؛_fsE�71�m"��V86�h�����1
�[	5����=
C����<���HC���H�W���"��u�X�)�R�g�ѐp!%����B�I��aƪL�<�-��e�����!�����,O���%��嘥u$��XQV��a���E�u��_s8���:kvS�}䮷&�V��!ǵ��8�37���12�~o<��M&�}l����Z�=uF,;���QS�A=�YV�T*|5u�`愻xkvM�,�v�	�8O�9Uxr[1^��iO��2x)G�1�������Osa�c����O?~�H?���߾|��??>?����ǿ~N�'Ϛ����3��"��0��ʦ��H�tF/-�Ҳ1ǘ^d�;%4    ��l�L�03��K?�M�wf1��\�L������ ��������0~��D�����c�}�����~��l2�1���.�$\��Ƶ|�3���1��"�c��ͣ9o|�ff��9F�
07<6����q|�X$����G�*���9`���:��9�b�l[�-Jm�8�����]���v9i��G��Z���� �4;��7Y�3-}B�I�%?�����Ái}C�:NymSړ��.��V�>�&��T�9�A���fb��X$�_ýE��5�Ń5�jg̚�������2fϢ���W�8��G;y1����5�Y��6���sJ�AX����Ęt���tS4W�36�&Fu���CF*u��g�t�0�3��=��d_��ko�i����X���k�7|av,��6�\E�7&vw8h8��Br�͏�X�U7�;+(b�Y�B�~/�d����#ya_e�cC��э!$R�b�]zG��߰���79=�2sc¯we��s�z��*t+��j7�w܎�%7����̬�r����Z����lb�������w#�"��*��u1�N�!�V�%�Ʋ�C }�t���ئQ�����d]�|��}
���˝1hBN��H��D��=ޑ���3i����0�ykQ8���㞻Ŀ>
�i�F�p�fǕ���k@�J7ͤ�<ݟ����}��W����a�Ss�׀��^/�?>�\웉�ı}�V�E��;tb�L����M�w���**A.3n,Xj.љz]M��4���ǵ�D^o�����c�0).���`�[�r���5U�MY}�lpY�:f���\�)�~5����G�q��f�LLmZ��r��t�~��aܪm��~~��c�y}�5�o���I��utr��2�����g?W�&&�ٔi�j��]�Y�B�uη�w�m�c"J���A�9�&&��T�������SY��p6�N;��d��?H�>��%��73ܭ
��í?%k���:`ő������Yvܴ_�؂���J~��lm��!�����	͜��{���Gp]G�76��甂WZ�~���^�����R��p9��w{o9M�H6�T��}��>X#W�!G����#�F�{{x~�IT�������XyK����Eo�w�/:Đ�t^M�='��H���ƍ�����q��٪) �2�N�=��O�db�q)<�rkb����6��`���6B�P�p�aLgq��j��7���F%Ǭ��Sf'�k������[-�w��"��u/O
x�՟̨V-��2���>y���@�����`�x�7N����Wǫx�9��9s�����x�|rG���X�^g�b��\c�rg�ޖc��[�I�V�������K#��)���w��b@%�16
��dl�!�f�"#Ffe���D���؈����%�ʻ���/�<$-�BI��[a��D��m������	���:�/7�D��DRʘ���n_�X�h$���
�O+��ĸD���Ad����gAf�z�����E� �0Q=�!��E��S�ą���41�잵��x�x�U�����M�?�	Ȁ�P9L��6"^�����z���Ss��ያ�o#<�a���&�]� �e��TiճгdyY^�ji�z��:�� ֪�)�B�.�Ld�`r�!�~���F�"w��	,a܈3��NW�Dl�#��[�sյ�ae�Z��\��`�U�_(b�`F����ƍ��կsa��;_��Y9�ťY9����;&�Rڞa�x�X���b�a@��`4� A��/s �k)PPSF@>L	�jSU)�8z���cm��������V�,�8�L�:Nn&��Y�a�,�"�*�W=LL�U�x0�&`��F�I�hs�J	�����ib�}�Y�ܦ�E,��'����]Ɩ�OB"�,*[}��05� � ��ܭ �1т�C�]kf�jr���|���>�R�+lV�Y߯Big�.7�s%5,0.�P�i�<�q�ӷ�щ��6���[l��x��W�&��c8���ba ��I�1���/�����3y�,;�����j���1��������MT̳n���a{<L��1���p@
n�ɢj�������2��	��K���ճأ�^y��0�8�.䑋t�ݫ�&���>-��?7I�0>�������m�� �����"fo�4�������ѣ�H0�'�@�2h����4�\�k3Ĥ�����(�]O���M<���V��&Rf��C�L`*qʃ�-���{��t���	+����^Q�矾���ۗ��x�'Os̒,�n&	�r�|��c�hrJ���5�ѾF�)K�)G�Â�k51��
��V�ǈH�OBcS�]l�t��4�d�Ih�=�������O�31ի��WhE��1&R���P���y��/"���S?�X�������fC�걽+&����7���k*�%2S�����ԡ�5Q�ú!"���<���,��w�7N�H)5a�#nYJ�������\u�kUob���Xf�.�*&a�#�=ML\ø(7�{լ�4Ǵ����z<ތ*11?��hً�b�q.\�s��:�3Zfxs��{��E�RC�i��=*���GDR�Q�(N�Wͣ�닓:4��^p31-Da<�8��Z��~Wq�CC)��lGĤ")�AJ��G4�U)s�t�b+�������s��#�7y�"W�Ԍ�Y�V�'�7m�w��P ��~֩�?ћTz?��g��wۧi71,��,/��;�+w���y����8�z���~u�i����d�����Q1���ײ�/�+@��D�.ƛ�̹"ǘNb��NoyM�C�u��R�{>�:��[ �0����I�@��٪�ϵj�
��i��\�s��P&R���p���n�f�׼Бc��m��1��#�;ScB�<�6���L.��'�r�(1�'r������z,�I������1Y�G��%Cؗ-l�G��5�Z�J�G����/_~��KhN�Nc�'[2���O�55Ø ����K�vgu���x��.�2Y}>�>ǈ!�3���LWgu)���2�.%c_��ƶ�4hJ6���xD�;\���2���m�m��Y���t?p���/�d�6ލ������m��o�6g%c���B��u8H98�c�qC[H)qk���qC�ԏ6���@��w
��Ӵ��X�`�=P�.�"R�����ثtiZ��^�cbm��EJ�v�h]����U�\u��}sl��tB�y��t����F��<��qoE&�d��P�T�w(-��M�nMW��H@Y�2q�JQ��0.�ě�C��bN�C*vx�Ŝ���Z��#��LL�V�-��T��W�ML�V�<���ugw���-1+�ݜᬾ�>0�Z]��x�q���O��?����Ι�إ5��.J+x��ԥEy����d�&�j�:d$)S��&e�DHv�β�1�27��"��|O��)CL�wO�A��͙6W#PsL�Eۡ"�B:DU�A\�����M��%I~�"4FE�2"���߈ Ӣ{�\�cЯ���A��A��u8h�?���/�ʋ@�[�l ��X��>S�Dv�'	��;WH<���8�Te1֊.��2�d;��:)D�ޤ�V��kag9@��dE��2�7�uCw2)���!Z�8�4��x��4�L>2r$}Ҕ���$���@}��Q�c��\#Tfu��s�=7:ͱ�ӉT;f�I��F�23̾���<V��G|���\�*P��X��l�j�A�kc󮮾�_؀�"��o�0P�ML�S�1G���ޕ_d̋�/�O��O�/䪫W���u31]��
.���6Ĥ���Č��mk��MI�y���!��7ߞ���!�i� �qu�ya]�z�W,E�)aR=@�Ŏj���q��ݕ��j})1Ց7]��߅�������i��p#_d"��@h�Ѹm�{]k�u�0�C��׳C�N2&�u��X�䢶�|Z��9��f?щo�M�����!)�,�����8�H=����� ��>IA	��n�џzYMLU摬��b    "eji����j�ɳ�01-Sۡ�fj%S�{"vZa��X���e�*=��7'��-{����ZGq�*�D�s�sAi��)$+����,q�lb��������#�3�Vv&�}9{�>H�۾Wx�/�mr�ɸz11��?���)lz�el��j8�y��r�D����dbrb�a��_�"&V8p�<��gZ�î1��w��%�7����_��~�NXb�H���k��C��˭&�.�.�����!�&�ƕ��*pQ�J�D�+1�7��8�KnP�T>B6d�j�75�y�.�B{$@�~	���1��A����.�a�L3ݘ���*tÄ>6g����ij^�� �1v�K�6Y�T3�rLQE0�*�qPU���Jt�꽉��D��]�:L4W"ƃnMmn�#���{�B���E�2&Z����l��޾���$�VQ�kiIG������h�^ƃ��uh�l��<�;V��*GgL49:�R�f�t,5ڭ�i��X�QL�Ϙ)+F���!^?:#�s�Z#�Y����!b�j��@�%lh'�?O��P��Y!	BbMݦ���d�!�aj]j#P�	�x�r���|�T�&�,o�g:�� 
O Z\ʪ�H+�N���0�
�������0��9�H�H�qо�g���wx�ӎuwm�3!�V1�A�Ӎ'�T�HGN������
��Qy�������������Onڠ�ޱ��()����{?%ȥx�0���{���{U}�0����=��ob��� ��fτ��.�_��xӮ0};�DZ8�-Jkn&��zF�D��Q�F֛8ar����A�"�8�pň�H��N*\1n?P�z�E���š�0�&֗�Bg�DXEjW�6�R���S�Ԥ&�3��P���U	Ӓ���A�q��*�ލ���/�:�B��T�ec���f�ܐ~�7��Ӥ��Re�wa��#޾,� B���x�S�=䆘(q�Hh%�V��V7�_�*�&B�U�]>W����i�K�c�K�6�D���n��U>�(���<��"��p�_�9���F���#��c�k���se��"���Pl��%��Pº���F�p"6�)b;c��� =��ꋉi��f��]�Z�HJ̧QR���h��rCQ�v�R����4��֯1r��~���Ԕ�"�VH�u:�����!&<V���6:=_�$sa���`��������Q:��B��&Ƽ��h6G���,8�p�_�����[yL����@֯=V<���1�ۑ�r�ބ���GBy����x^YLl���c��ڴ��o���y���0nq>�6=V��q���Or���z4�F�ئ�����gt�}3w��!��u������nB-�n��#r�#r�ap�LLxD��c-����?�W~51���4m��g��vo&<N9�B7������ 2L��b�Y���k��_I�~S�8���dbT��I>��-/��u��B�!"]�ы̆��|��
��f՞ra��W�v�9"#�9�p���M���=�6�;�:]�xN�V�]L����^d�����o�런��үe��ͽ�a�T�aHcFK!�U㹐71骁i�����T�]H&}~�9��g�* �����I�p��$�	J�5"!u4Q�F��.�<�$����f��$k��6y���S����Fđt,��������g
'��	���<��&!�<�2��%����Z�L����� ���}Z]� 3�vY��Q�xݘp�z�H,�O�N�DL��aԟ���Z&+hN�0��4?�Y�[���	��jQ�]5T6�CD.]��~�a6���.3�S��{��3��I��"�נ�ƣf���^�a��c<c�//�%�˓An+���Zw�<�:�!&b�b��]b2���$f^w�0����-�КSqEZ>��ѽ�CD
(	���Gp��Y���@Tb���J��bg6�T|n-�b&�2d>�*X!]Tu������2oa�����p�V72Me47c���Q�$�O~1��#�[Y��ս��[���
������/؏3���!�]�R���Rڕ�C7_�4ߤ<�oL�M�s�:J�]\1 -�����5���5��#�6�fP1>.��{�`�L�V���� rȽ%�"�ab-%�����!gbR�������kL��m|��}}>����ׯ���[�����7���m�А���ǌMz*-PZu-�g��q�+�͊V�ߕ�IJ�it`��nt��vR�.c�����;Sc��Mdd_~��u�_���ps96as�p��\0LZ���p2�/G~���bT�xS��ĠNfELVӄ���ѯ-�ٵL沽1��'(�X��1r-�QA)رhQ��i_3󢞊7����_��S=��L\���C䨹��}y71�H�Y�X���K�:Iג�01MmJ���p�$"r��Rf4��3�[ϚH�:�6�2�g��|��\yM/��fbj���ӈ�i�� �!&Z�6�a��4&�}�@���2��:�&����2L����i�Ƙ�>t��]�x��E�0����Vt�˛0����b�Zu1�GO�%� �!c����y��7b�W�]c�;�ZbdBN����G2��w�ȉĮ1����%�5��;_�Z��z`A����4��:>I�p�y�g�����sHĹP6B*��Wrs�����}6�]�w�2��W��L�z���ֆN�������껉��|��-=�n�]���#��K��&_0���<�����F��y"o�a�+�⦓aR#Ư�|E|�#����s��q���NSf
V��qe�2�4��&|$IY���Ξ�����g��" �mNÅ׻�m.L������o��1Ѳ+�����Q����W���&�|���Q��ɓ�p��t�<@	�_mR!�;}��xde��&�2U@ƙ���`T�P����b�d��{e��.6���&&�Bc��m*.܂
��#� 3N���|`�>@־�N�A2�u�+쯣r�a�5���,�<<���G@x�QUM^%ٔ:ӳ匋(��L�N|��ȳ��Kُ�aj�� �S ��h�.ƃ(���k	���uacS 5���h�)�G���<�K�m2�+l�ZT�����_?��"�ItP��`��F�V�����T��L�}�9DCT�nH�q�ߺʙ2����`nb�_�n�[�������j����eؚ�y�ih�D�e6�N�����H��\S�j]C���6�c�߾�c�S�m�slG�8֨w�M�c{�ypy��?����߾|�^�%���)h���\��:��՝��K���󷏟?�ן�{y�a���Y-6�'�{S?���jq����<$�����Ari��=3`ۻf�ܵ�7����l�2��a���̄��A1rII�y�7s�"�[L���6��~~����������O?�����o�?���>��sY��a3�s��/-�սF��؀��9��V�cO~T2�X���������m9C&��IV������Ĉ�~�B��/���I�?�FW{;���=%y9h(7�DR�2�n�L*ǅY�o����?����s�<Zg��P���G�օ�,MA������Jl���=ع�8�Ւ��l���k=텩Ux2&o��'�
�UW�\�:<L�%ģٱ�.e\�Y&��ŕ������O�X�-"`��s5a��y<�J�^c�����0���ϫ']M�!�k��%f��Jp�
=2u�-r<��owkºWiFA��0���
j������ ����C'��d��vFE�K�>�ޚ#s	��j�)-�\��L�Fu�ȞC[�X�����_�zZ�X���?1Ѫ-���I[?_��`�$b���sQ�5MQ@xx	Y��YL6�0u��a{���>�L�}�x��-��U����d�pFE��2"�K8�vO;��T]=Qj�8��@�1�p�?d��Z�;
EY�qkl���m"���=�&��?�$��w|^z���6+4ԺGH\�e���j9&3�Fꤜ�Z'el�:)�A����&�g�I�Fd��S���clT�y�C�=2�Q��9 ��S�Zǅ��    ����'4�E����P{�8�@ Ӡ	�D�Ϊ��سq���[S)��و��8��Y"/���W�ߠ��^�R�^���<�!�?0䕑sR(sQ	V���Ie���ыW׎��s��^�㝣W���(��^˱Nf��n�����Cˋ�.#";!��18ΙsB���TX��$L���c3N�5�l�΀���+-U'&��2����߸��d����±�cT��Ȇ��ںc�cՉ�ӕU0i�����yhP��*�qȰm��&��9w��ta��?�J��	�-<�CN�3*��ҽ�Q��gI��\N\^M��ť9�A�5�ƭ���kA��y�U`��Ĵd'�˃��`�3���SK���ZjeL�R+�m4�{գ�\�ږ��V�>�!&Z[�b1I�������Ĥ8��&�))�y"��m���	$����]]]�0���^_�Þ2�jZ��9�d��2�Db��F��G���XK�An5�h�J��fb����W��~Ɖj܋��ls?��%�6�}������S\l��~�b:��y����e��]��jb�9�����YG��kŅ�����p����g4�S{��!N]�%a,��u׻���Z.�����6y�G�[��$�]i�_fv�b��395��x�'+I;1[l.��箼/�#�qu�o���|�eT�
0N�ڃ>a�3���v�J�aQx����Tܴ�)e;E��oЍ�g�-��i�N龢�fc9ob�)=���t���.�1�&�Ā@{�XW�}s!�/a@"�R7Qv0�:�Y�&T�� ��M�g;���x�%&'�7'��c�F����t'5A�V��>.Lm$=�w���D�~0���Ɏᕩ��/L��s.j��1����Gzy�>�y�Ձ}���F�DK�u�ah�-'de/xb���U�c2_��3�X��p�����:�aGU����NT��8��k��z�Ak���bY|�7���X||��>�	��!�7����~|G�D^�K#��0�e��4R��v/���XG���V�&�f�֥�c���P�
Vw&���8q$���`F;����3앪|a�p?p.�E{�����4e��f72#����76�,/��Di��Zr�qj¨���(;��G�o&&j78��M!g�F��|gٯ�����M�!�bo�ˎӒ~7�!��A�!(&�#*�8p�yS�K�����=�Y͝�'N�7{GM���K2e��[\*p}[�>��l� /�B
��=w顒a«~�k��n>5�4�`O%�m�0]m�rl����7��LTJl�����ܢ��}���K/�ԇ���>���M����	����i�)��Ĕ���w��ɹ��P�m¬�$����;������8��y	�g�㸙#(aN˛xl�7N���%�6�j_����*��ѓ̦q���������=��q,���g��7�X���Dr�.׶v���{S�姘F��N�k����rdN�b^aB����c�R��I�T���~Ͱ��Î���c˛۸x.f唘U���62�����R�� S� 4E��Da�#�������$a/�6�}�mշ�rϣ�܍8<�W��=�ľ7�U����W(FD�BQx�Q#�pA��i�ML�k��|�6i����x.~�����P��!*c����\��#��:)جU�ō)��{K�����l�T}�h�������S��5��#�{~eZqc$U�{}X���V�n�C���ct���H�����x��Mȭ�oB���W����l�*̷A]X}61I
�x�U�+{�P7̣u���#��0��o���0]������x���i)I���a�8c<��ˈ��cM��D�wc��j�q��h��H-�E�p�@n��7�|�u@��!6c�G!v���־�UY���,M0�#�(������+0~,�,&6xi���KCX��n'L�40*묍 ���4W��1����*B"�i2(-��<D���ͧa�EI�V�K5���?vc엺Sj=&b-���j��I+���:�����K��O��f<Byh�Jdǻ���e�A��Gr��{D453�!��	�m���0O�=��D�;�{.�����ab���=�z����ȳ�+\b��o��3.v0�&�N4u��Ʌ�,Ԅ[H[���i11�	���Ô��'<h����v5����my���L��1�k�&�F����A&�q{|��f�U2L���Aw #��*�ly�ebݽU�R(]l�)r��Õ�6�@^j$2XW	�zU��yCS�ߒ����X�1�!�{����}&c�"��숩[�^�D�s�f����>�D�֯�})���+�N���H���ibZ�K��V�*���݋Q�&�B.R��^u71)��x�Ĩ�`�ʮ�S�ofx5	\�����/y<�҇��x}����11���Eaz(����T	��WN�Ĕ�/_/�X�X4��_)t�ԯs��a9�ġ(&���a5?�oi��aaGuܜq#;���Ǖ|���X�׸���S���U���ӬU����eO����U��f�0}0tg��b���1#_>��������\�/c���p��L���gCrn���:����uJLJ��
��a���<m&���ӏ���nbڱ�xȓR⪏�Y^.ϰ�I)g�f� fl���8�sZ�(��&e�{L�<�!��0|�.�����H�KP\���]�˱/<�Ɣ �q�7��F�b�p�-�2oc6Ȝu�pal�1LV����{gu�?�� �!��Obvl9�. �@y���k���'|�a �YML�&4�0�Tz�&&�Xp@G�M��bbb�CE��������ɣ㯕���?x�~��SG�w�h	�!��������ˌ�{�ԛw�q7���#Gs[�g�*5\i�ó���R���nbR5���"�=���E�$�w���*��/>�%�q��XU�zaj�N}�Ʈ%�=��Z�������Y����q�	���݅��ہ��������P�E��_Rٸ��:��W�3��~�*�qnѽ'��i��K����PE�^������/�\\?���Z�$�� oa�0N�%$��F{�I���o�;�_M��Fa�kX�?P��zw�,���H��(h�U�Q8�-2�4�R�+6`G<5���hiO�#�`�V<t~ZQt��t����ɴ�ҁD�Ip�4I���-���O��.	��0x����'����Ad�R�z�L��h�G���0�bxN��� N2\�>��d!<�zܼ��M�b��ӠzC�g��ab��w��i'=F��y��Y�qG��[S+�j�\�a������y��X��71-n�]n>�ʡv%J�ԧ��~x��Ft�mV���(���~�x�~6�J}K�� gD`�t裤�K�o��&� ��wu���D�[�.	��`&�3�<̻���]Tb����҅��e31��9+`�|���!$�R �&��r�T(ì��+�=�&ds�X�\ݙ�X�*��1��k~��5��L�����:�����ђ��-~:9&b�.r�U-~:�kZ?��9�_���+�vy�B�q#,�Hq�\ɶƮ,�L���\Վ(����y������y�W8��b�<7�;y8����������,�,�|A�)<�W�3�ֽj}�15e+:nZȐ�KH��?�Ĵ�'�d`�B+!U��<�#f!��9�=��&��<T!���۶1��F$��d�bb�\�=Xb��� ���d(xofK�
����R��"T�
O�Ӯ9�����r�s�}S��A�|�<j�H�+����߳��f���a���fN�Z�ߢ��Ep�͇�����X���
z�� ��&�ec2=�9k�PE���1����_����a<�MVS�r�e61>E�G]i�Vr&�U�����-|g�\�ɹDNF�%2*b.�Y������RRFr<�:,��~�B��I�NC�С�A7�F�x�]��׿P��t<N<��.:D�_��ITE��|��P��RU����bDp�E+���V��&<�;�|T�'c�	=�9��ȴ�����    ��&ƺ,��>�2 �I�ՙ����a}���k?��I����,s{�$��I�UV���0;0DF.L0*��PZ��-[�&9�N��D��u����1��?7��"q�E�)_�C+R���~%�#\<W�5_���(��#��ӗ�H�}�������_�퟿}o�&�i�ņ���P��$o����r��I\�6�Dz�Ź�=��7k���;�S �`�P@��Ow�G���O�e����'i����s2]k#��K�f�.�%�Bݹ+8�i#�f�N�}���?	��a�Fa�Z=r'���^��%f�ԫS�T�<..�U��֝��zͰ�}aƘh�g�C��b,~�_��@�V\?��E�%�,�+��?q�_v���� �F�=+���I���!�:��M�h&��r��q�Ɵ�8�H�k�c��G��V�Z&6���8v��DL�0"�MlwK\�&��&���c:�w���c����o
�G(�VՋ3�}w���,tג��jbZ�ء�ب��{��ߘ�9~b]ɂMe��͵��u����J���cLF[���wM��a�&��È�Ɯ��k��þc}��z���D����,�01V�u�4����_�^�4���������矽��mFeme�4�g�U%i�{�5���`�<DF*�@�_��]���U�/1U׳���L,8�k9����� <~r�k2fgq�.1ҪM��������=�|f��G�ML�'�9lP4��&�}�!�����4x�g�TKL8IroL�7ځ����#�u:ɀ�C��V/�Έ������)�+w���M�_�/��}����~�zl�!Adpm:1&6���F��,a��ph����~�'�{�8f�c֭I���#r71]��yVn��tv�y#�����X�v�M��{�K�ƞ76D�7}�����n��V�.l�<|��͎�cd�*��8�H���Ҡ�u11�����d �������	���ՂZb�����՚`�CN[]C��/B�����K��j	���W=���T��m���<�Gtb�ͪвG���xH�)_�YP?���T�V�g�Z��^�\�d3��m�=���\:������9L�L(\gσ���41O�2$t��_y�S�)$�2٧P�ޫ�&��Ӆ<�_����/�a��og���L�9�%|��p�Q~�M�wk�D�_@��6Ũ��i]�Uc����V��FL6�꩜���{$bd�H�E�h���S݅8����ibZ?���PX�|5s���B�\�6�窳�imh���X'�Y���15v�\D�窋�i>n�q	��+iU߼;'( �*���Xҥˋ%]Fߕ������I��o���E�M�h�$�7�__�N��٣���/n´��ǲ�J�+�a�Z�{c#� X�yC�@��޳	����C(o�� 5�ux��_j'�%���  �h,��o����9�1�l���n�i:��Ү��&l$6
<Sv�2����,f���v�c��h]�����ͻ;�?0�����=��4����V���R%oL���\Ħ�Dk�!<vR-1b���͏�΅��NJ;l�" _H9K�� �5��b֋��O�m' �A�W�nL�X�葋~��L��E�h9�1v5N���pF�A�e�&J�����a�]:Bj������"6Q>��y71�ψu%q};8��{��1�N5��O�8;<��9(�P͡9�\��B����+���:G��S�2��*��i��@����y�9�Y��K4� �4'�f�Iyq��d7��2�؂/�m�z�۴����-\�s��i��Qﺛ�>#�ׂ�մ�{�����j�����ga�g<W[ML<�ḩ�cx����OϟZ�d�P~����"��jѠ]�I�-AS_�q/��]x^a?����·lF
�,,�Ƞ}���	���.{D̽�.��^VYٻy�ՠR(1����r	�}��ȅu�ia^���z��Q1T0Ƽ�
Q��"�M�&�kvQĈ�c�@��K���Y;<�7�J�j<zo�D
k�ۜ��
����1Ak��h��\j711��!b�<o��<���;Z��^�����wd��u�C�KENʃܙ���cգ�Cݘ(�?�
I @y��-Mu/���V&*\��^�1&�¥�c���<�y����!����]KV���ۿ?��>`/:�`��=����-7&�a��L6��PJ�H�`ʃ���-Qa�G\Rt���_�8�A�r}�'Lj��=����x/C��rߡu��x�}q���ۿMz���3F9H=c���W9`6��|���U�)1��٘Bm�#Eǣb��g���0��'d��C��z�zΛ�����t7���1���5�s�0�$=����&�HaJI���p�o��-_I.\��&"�9�W�p&F�����C<�N�D�#GT�sKo)�t2L�L�P}���I>��~�!������
��I,Ry[���k:R�Z��ڱ�{2�ē!*�"�[�K�������J��܈	��4�*�m6�jȰ���=. �OQ�|�v��s�&�ɘ�R�͋\a��X��`bj�m�}�3��v�\¬�b\_��M������ �ñջ�ÛD=����2����:".b�xθn�ԛ4��&֭[ݕiؿ�H���΃�n������'��6�fֲ@b�d�i:���Q
��]5�F;���9l)Yӎ|/\J��ss�L��������.��rӣf��(��Z�\�	�1ubK�7 $d���迄zl��;i��*.җ���W����J�ͷ��|��y��-M��{b���J� �|.\����&��v�z;�d!q����h
�*H7��p��c+ǖA?v�1~���5���ey9є����~���&��a2P���g��=���~��b���ѭ��.����;�^�$��V8Me��{��f"�=�������R��0~U����:�8FD��wxHZ������d�[� 1�n��Q]����x�®#�Dqqh߅��Oa2�Ј����t�Pq���W6@c3��ǻ�c�쫣Q��c�iv&&��A3�H��
%B&/�Y��ga��a�%ֿ�O����D!F����o����] �T�&~G�vFG�������F���2�a���5�ǳ���sy���['��۱�g��/�.��F2�%ýl�~'L�5";3�����S�J�����S�TD�
L$��E�N�]ݷ8�>̈́K�!e����e�:h�9�i���v!4��N�	#݅Ĭ/����>f$���<˘H]�׆)1q�%Ty�P�;��_�&%�~�X�ն1m�:L�o�e��7u�F�s�2L��%�4'1@�����ߙ0a�	ЇV��8�x������h�N�����o���˯|x*X0u4�4A�<�ƌ_��\��K����)�a�*c4�_EdӖ�R��ɼ1)����_�A�N���^���dFa�9��������ږ�I��N^�5u��&��k��9c��j�HH�C����w�w�M���?����7����f�GB�(����Y��SyK�N$jD�׿S¤�/�F�U�����;��v�#î�Vc�Ռ��	���#�:�kD ���X%[g�l�o��%[�����,[=��º濰r���F�p/��؏UYeG�]��c�,��w�1�<x� �����{�5 �����ʬs�W�at�	KE�I`��Ĵ�OJf�@쵛�vG���Dʏ��+v�T��荚ᄽ�GU�16�ڍ��B �⭸|��0p�c���&Ģdc��M"�Ţ��w�;�.b��C���k$���R��w&���ꐱ��nؑ�;����v�Ga��$x���S����$n?8K����Y7��z}w��;2R?����dD*�_��5������#NXs�W��J�Ĵ>��?����5�𻉍��4%� ��^k��*3���	�L�O����q	����z*v+��.�
�{��}����n*�YxAdX'e��KT�OZ��1��,)    ,�n��ҪK�%L5B�\�NF�D3Bf<�\Ħ�W�����q:b� %#��cTpe�����od+��)=��ZaL����I��y�}�i��&f|��7�c����C�k'	��u�E��Ok9�.�X�;kǃE�9Ɏ�x�a�[��/�L�1b��'��T���?��YR�d���W���׊�M6 �2,�GM36ZZ��ZX��`��Rvl0J�W��ibr�B�G4��B�y51Ut�`U�| U;`���&����6��\<,8�3��m"qeg���@36�g�8�Dk�!<1�i��Ѩ��Ƅ�\���A#ˡ��T#��TAX�(���6_���'�W���R}�%L�9��Ű9����V�D���I"M��#�B�D�JH������0f��D�^�J�Wj��#�[%@å�,������dSr��(��'7��E0W�f�{�����z�db����HA,P��f��5�IEӚ������A�p�2X���L�j	����{uB��,,s2l�/>�Op�}Jo�oP%��6�p��i��6z],JL�Ǎ��Y��]�R�\Y��~i�Aͦs��g8:���ݸ��)�q�o�Vs�U�~a����a��tT}##�� ��˘�����FL�
GFWM�X�
+^���A�(N�v�^�4���t�N� < ���I�y_��R���—�Ĵ��
�i!i��xB.�/E��aj�mF:P3���f$�����7�x���71�?����S|C�K]ԌƈR+�v�K�6��Zaj�*��ʋ�iJ-�C�%c<ޑ�?�HF��Z_F��u��}���ފ%:R~��>ќF��Ч���*�-���VG�lbo���(��d^v����C����ݑ�B�cc��/afw,e���jbrQ�PY��ɐnq
�31���`OJ �&h��b���!"c�͓ٝ��f[~`�'�Ս;&}��	M��	Fd`�$��p���laD�T�I�@�V!x�]p(&Gl��|){��� ߧ!�v�Ob�&������f����ӱG�^`uob����P}���|�(1|�o��[����Y��`&�RР՛79bZɒ��>֭�vϳ�C\�����wpb��ꚦ��Xp���ah�y.��*¼B\ ����\��7b�e�9�L˻ρ�Z5o������T��F�=�t��&��<�!:���09r�4E�0��^���$1{���ĴJ?�!�"�<�EB�a�V��T��6�.�tTuqZ���{����wY���s��zza�"<�Fy�����eN���mo�2ڛ�ֱ#k?r	
��Wֻ�F.Al� �F�1$����{�r��q�8��0�n���1���y�7��,�092)��.Mۅ�[__�u���n�q�6>�Q�&�0�.�rZ�p-���9�e]�{a�*������+���U�� 2��>�n�%6R5���j��hU3�C��1?P5#���k�1�On1��bf�9P��$�!�>`R�r	ӌ::<l�������᪦�7�2�el�H�Ȥg� vK�LvaJ��>�YF
����:�0�{���6s��V�b.L�t���C+@ț�|q#T�l��u����Z YQ�c�@��f�Z 9ۯZK�(~��b;��)�����qw�{��������q�|����_>֏_�L�%�*�yw9I5V������ӪK�7�*�2u=v�k$q�}�A���
��噧�&"#}�;D�Ϣ���g�Z�٧���S�ײ]$ú�}�}xދ����2�n������GI.8cXu�DO�{�Ml�l	�����̓lދ�zČC��z��=�j�Bv�0��U���Vј���&.Mg��u����}%��F�r�'�86�-='�U��K+/&����6��ӈ�Y��������R�~���P[¬�i51%7���ֶ;L�5�X�hlz	J�'��c4Oa^I%������^��0V�>���x���	'�/vN��K�?��ӽ��wD"}c��v��_��������#|o�/4����P�Q[-qq�|G����_����Ǣ~}�_	�}���[/f����o_����b�B��˞m]���c)�7՞�ryh���෬��s��2�_:�ۢ�RƮh(Ͱ�3��%_~�����������|��۟����O����L.RHy�Io�lb�����&P�Q�YO�����Xo%c�,�����~a��hS����_��a���Ʀr�5}�\��|�Xs���ݭ��>O��l/}2hX�Fc���ʁc�='�Nu��71VwpΫ&/���Y(1v�X$��܍������'n�v<������|cܒ�+����A�M�N�&��i;�˵������\��~ޤCk8o������e߉��0�6 ^���fb}s�R.�$�<!��7~�	� ���N8:ιح�Ay8m!|Yv��|�����|���__ָ���Ӥ�VW���T@����7��q<��d�3w�}���ڸϴ�*�Λ�:��㑹�u>4�S�Ǹk�J:�]�b�՝&��|�=�.^QQj���Asq��0!���m�"j�85�k�<�ΰw>�� n2�֌�}1�&�ԭIF^���S��o�>�D�	39��r�w�W�M���2#�J���I�1�;LlD?��_-юȞ�p-�Z�JL�P�RYbĳ������C֥�1�s��\���8H�����f�\��p�M쇲
��'�ߵ&1�9g��zc���C��!"��L�"�1P*�Y�0^d�}�:�X�fc��#l��g\�v:ʤ�s)\V�7���f�ޘZ#9�ѷB��!&��"�q�yP}C��'��������Q\X[f4yoknf>L��g4f�nf�[�����H��K`��Jf�7��8=~�M�߉���q��>6D/&6��C��N��goJ���0����b�ފ���
�h��~i�՛�a�D� �7�V�>
�����5a��6c/__�W��w����4m�aeW�r�؀�I���w�i�IĄG�����/�776Џ��#Q��\������~:*b�W7S�8�7�*�W�[��^��c���ʇ���ca�5r ��8���K2��)Ō�F"&k'o�{1�u�n�8q3�]<���?�
��jz�C>i���C&a���%{��69�k3�:|m.�F8د���ɦq�_ĥ>e��MU�X�\���fs�03������>�8����4H,�w'a�`�6뉴C�w��γ'�R.�M+rg�����M+K�4�:�sazY�)7��L�p%a�L��C\e"1��A�=d -󐉫_��@Tjuul�n?�+aV�9����j�{O�&r������!U�~�e(&����?�p�G-1A��o�*����=�K�`'��S$��̕�Ս�'ӓP*�1�}"�1ؽ�a�4C��=��F5i��7�4l"F,�ٯ�Q`����%�B�)�r�k�nL,LaUb���0E��,T[Jtqf�bbZy�CE-�2"jy�R�E����אY��e6��q[➫z�>�ˮu#�+��e�¸�2|"�,.#0����1@�m:�H�FĕM�?�f�0�!#虠��L��)a�}��������f1RHk��.
�c����#��=�:ML�]���?ӛd�'f !2�쭁#�%�u +�O�%L̊���E͊0&rV����OorQ��Hl'@���N��"#�C,S>�/�k�ݻ�o��]t�e��@�h�({t���t�ݤr#b�̒�5}}�HQ�#~Ǡ}���r^��e>���[\��䊷^!F
�F�`Y�i7F�",y��:%X��&+E:\Dw{��w�>1+a�T�-3aW�R����FĴ����VYS�X�C�{�I��P(�L6�5V.�� ���f��ǟ����������P���|�]�i�&�3�wwAJ�DE� .Z?���U���}��r����i!2���,�9����W�΂��(Y=�%�E+��
�dSp~�����
lh�    p�ƣ�z�I�&Mb�m�P����k>)YZZ�i�}V��&_�r0����(j�LL����C;���1�M�֛�Z�rE���(
�N��5fS>d���Ę�1�`&��V�1������N3�L5�}8,���h-1f���޻��z�2W���#�Ho5W��MWhg�7}�	�����5�5�v��	j/\���:�u��Gx9��Ą{�@�(��)�lN��ě�"��3�al�\Ā�PаJK
�%�����W�8r��ۗ/����r���!����˄Oڞ�
sl������൰7���F��(�-�G`�&�3�	�d�Y���Lg�q���l�܎#���Es~�����d�T�:|��Z�gT�S���Φ����;�+��^+m&&ky("vu�#�V瘨`�pQ,=&����\��>��>��L��51|���{ar�;��T�[=j˔Xp����*�I;`�3�X��yF�w�	�n�ٸiåۭ��\c�g7��;�ҹ±�n
�K� )&^�+̘2l� 	gc��/˼��Ć̕���a����:^��ab����<���O(o>ԡQ�.Lo9�Z#7�鲹(��;8�RB�X�yu����'-惩"��u�D�u������� "a���{��r�n�:�n3e�DLlq�Y�HN|oͧ(����e��öCF1e�Q���ѡ�SpD�� 	#�q2��*4��ib�l�S�'�P���^�M_��s�
V�j������GLpF2�����=$UWv��{3��H��މ������c�q9�ԭalSs�v�u#��h�q-7�Dw��p��|q�v��\H�r��`(�Wm�a���B�Q�ݽ����s�a)�]�[]w��\�h�!.0�������G�ϔf@�aY���1u4	��	�6��bb�2F�Vk�{dP����2��fQ%�/l���=��>��jbC5:�;F�{��t� �w����p�8�Q�Х�ձ��T+S���`V	MN/9����!�[L��6��1vH��\oلIښ|���%�p���YJx݋���M�PR/��΀S'&���[�i_��u�?	S�]��~j�=&��+�rLNR��+o/��Q��1��Zv�+������B\ܚ�|��w��2��y�訉���lbrb�Q�R��Zػ��K��/�d�������ٙ��������r̈$�%˪C#ġ��e����ϸ�_0{�C\&�v4�gx]4���Ld~��A	nb#3N=�,>z���K-��Sc\�ץ�ƒ|}�������\��([�����ڑ0�&�iϮ�ڄ�yB ��������{5���>�Ǟ�U���)ކOS�
&�f:&�{mo�>N>YM�r����z
J�j��P���!J���c�qCh+���0��t�Vf��^��\�� �w��=u��܌qmZ��&�*��0f���W+Qlu��y��!.j?��9��u258�EN��&���[�཰n^2�7���L���OdЧ�13|8>���8�V�Kr���c���Z���Xs��a�#=�~��W%�}.)H�N��o��'O���0JA(N�»����ajqʓ�׉�X?��i^L�׸��c\��"��T��1㟨��֐.�JT֑�fA�
�"���1.C1�����.�����K1=�]P���w��T2��R�3�C�-(�jֺڌ�V?�d��4�0��/��e\�)S�����7e�C,h�Zm^��щ1���87��O͔�#�����t�<�`��<|��We��z��{	�[$.f�"b���l�����?E��Y<^��%��ܻ�6�I���xZ'cE����jV���g9����}1L����Z}���=�r��:X��˃1�C�:	vyœ���sn1�7�x>2|��K0�Ϭߴ�[���8,�{<|��|������{q�����2~�.kC\��2�R*�1|-�L&�?�7́�1h9��䶛�����+ë�"w�	�abj��E1�BLN{�|]�mB���~w���[�۽VQ�3�Å��:�*����P�����������!�(ql>�\?�-��ro�3�������#3���s��T4�0�UY��sKU��T���#E�n21v+#���a�Z��mb���TElyI��yl��#���Zȑ����i��^��Ga��䰣�yp�w�t��	$7&7���䜉�l8�^�Jo�̐��q�ĮPU[����'y�'ÆT���X`���E�[b�X�=�f�z���LL�٘g��9��n坏��������;�.�:s4%��&c�?����ne�u+|2X����\��/L�r.��1�h�)�������5���)o;jN�)�Hw�X��
�0PM��m��{�B� w8�Y�l�{p����{�_?������Pv��[�"o��.s�\������!h�-�2l c�?�#��às������˸���#�F3��ĺ����v��<ö��d?�8�mŃ{p����&F&L���1"���S	���@���Q�:��Y����sƗoi��/�s���5P�q��5�>��F<�a$��\����=�AׁB�TUƊ?�3�sa3q�s�ҨG����[0R�#���s;T�osXԛ��mf\���N?N��Y���Lx:|��>��s�4�N�����߯��v�_��V�Jl��ɺ/��������wӰj}�H��ݔ�q��k$�{(`��1�`nm�WN���#��9U�͸����#y��Ef���8���`�0����s[(�b�8��EL�q*j'(#"w�v����؛��#\b)u8����؍M1�G��UȆ�6��Sڡ�i�&�{h��OP����L�!"�f3�o6Ა������E%L|mw83-R�/CCD�e�5H�6t� ��
ɭ��㽘4Qb=��ʟ��u̔�!�3�c�ct�:7�9h�Y�d5�๿���~pqE�ۣv#ʰ�Q�;���	������)�e��Y\�	�p��=S�[��=_����G�Yߞ�������^����#�#�~�B�fE���3M&f醞yP�8���-.�d���mO���sQ����77��E#�+�����M~q���/��L����AE�@l"n��	sĪ�jbL�#���7��7�e���cjٴW�3� �;vq}p���KPz�2�X��s��G�<9Y�p%4�����xYp
j��������<�?��KX'=��W���Ĉ�A��w�?j��c����N+�gk�t�7�"��?����]LL��)&���-U�K0��SU�D��a�.�h�����-˒�ƒk�+�j��Ld"��ڤ6v��n���l��;� T��wD��N�bxH ��Hɘ>�{��7��$��q[�paZ�pqY�"!�M��^O)<Ib0멍yss5eL9�h�e�a��]gS�I������4��i3�8���1ѿ�l���5�42fJM'��+�����4t�)�1}�p�Ď�b����1c.��_����e�w)�̆Ͼ�F�=sp3�C�I{ �����Kt"�S��)�Cm,�����_�dlG���sHƎ����.竐��ؓ�m�Y�~<:ڴ�ggԷ��v��4�[�FB�t�dp��>�*�m�0e�n�(�}��B����&8���/a����]�e�A�+S�͘6fH��|�ֻ��܈=gl����,.J��s�M��>ʅ��l�.ꎹn�P*��������X(l_w���w��
(c���qQ�(�_�r![�B=,�nGL��> �cR*�0&#���F�si���q�ax����������C]��>�Y?�8W�+���+��$�����#��zJ�8��^��JDl$��x�i&޿���=��W̲ƴ^�[ҏ�/�"	q�B�o�ʔ1�,R���n�FZ�K��F�9c���&���2e�v���.�Ė�EmT����T����&R��#B�"|P�O�NU�>��z�R²N��    ��o�T�^Sq�IH_�l�cʷƌ/�m��'R"��b�����td��*��ڃ���kp�^����B�|�׺�GT���&�a����>y��4�'_4��+	�)S����W�����a���0.��ʀ����r�W�"glz�a:B5��2�8l'lx�o"�.`\��qo�Ƒ�#.aDZ-���=��L��#*����:���1��>y.L)���=#M��)b�?�M�Ɖi���N�2�?��3&�?�B�X	���k5F2��+V)�FWjG\��qYE�v;���X���JT5
R<����u�3f\�=���l{�%��e����]:�=��F�K��}��pa$m0��i�F�;�\dK�&�:)��$%�{$��P�+.2&��=6��MXa,	+#:�'u���X�q#i�m�509�>b��o�c��ôWu�w�e>�W�M.`�\�dJb�sn1��>E���.��-�J���)�7����1q"fH���]2���e&�'��$*1v��lSd��d�v���]�����������'�M.���"�������Sk��������;�=5�п�\���&�Z�����	�D}�M�ƪtZ?#��#�����}W��՘X��J���kߋ�9��ELSj�y��d��򤱺���oԅ�r����WVD��n�8��X�!b
BY?�p��N�c���8WU`4�8�w�Ӱo�d@�. ���̊;!��ɍ�ߪ�:4)z��D�T	w��6R��v�
�RB[���[�bj���f��[5|�)E�H��
 ��s��Z��S!<��y�O	)3O猓l���g0>�V�8�_�'D�������Õ�7[(c#���g6?�����Ýՙ\`zAo��9�����)e�;%Þ[A0Z쯇&k�{�l�H���\�|YWS/�]�<�G�x�Wor.��1�;����M�������
LY���De��7&�/�g\�0��|T����ڈ!�^nid'��[*�4�p!>�L�rd/b�L�p^���k�̈8+��~i,SO-a�|p�n�C�+G�DL�xC��X|��9h��:f�&���o��d�8p=��-W%3ɫo��ۭCf̫���d�0E��cLA;ړӐE|Gޜ�7�+[�JZ�W�r�����p /�mp����0;I�O׈�a;�/]�#	Di5�߷�����0�����߿��]��'>�:��k�1h/Lqf�
G�y�ش�����}9�qw�1�t����4l}�]�_����[3)�9��_��o���Sl�\��`c���^�8�⦰)t/��?���f{1����2�*�(�Ml�^o��J���,��Y�͋1�;��^���F^�=k+��){d�F��I�?t���ik�Gӆ[�O���v_���|�Sv�!ㄦ��bH�KZ��1X�MČ�7.R�i���<����YhR_�!Ԙ���k�]� �����6TE�sb��YO��ʬL�|nN�HW'b��Z��=G��[��=�x�[4�'Ax ����� �V�0�=kZo�K2��1K��x�p�ѝ�kx5��S
j������]��B��ٺ�ey�e\+SV�s:�t�1�~�s�F`�Z�j�H�`�}jT�D�;�BZ�I��_�<5���˕Z���^2mN8�Mt�:�OnO��	��a�^.�
��}Ƒ�1aR"EvprZ?0��̆ܝ�֠y�_����f(��-���4�O�
+=�؝n���*����FD�^� �@� F�f1�)PSptJ�Uc
��, 1���[C/6=�I�K׃{�k��ژFGk�)x:!@�+�� �<��i$����R�0��1`A�a��fR�ڮE?+]�f���D:����E�vG^׀��#^ϣe�{�U�TT��A��Gv>��ܬ�������}
Fh�]yLTu���P�:�/��H	 lt}�r���qČ'I�/Fb
�yn1}�3�����9_r�5���g�� j���&��k�s(0�W�Pw���P͇��Ax1�^����}���n�o_����럣[�9'�a�3�ã����0�a�eղ0ł����3tJ�:�x�4���Q����KP��H���&�;7r��g�+�������/B���mܘk<���(T���	-�����gث��Ƙ�*޿q|��i�|̷:�l��8�Č9��3 &7�mRS�S�����~���z�(��5<N� ��}��8;�Twv��x�ȝ�i;;-�U3-ML��.��d���W�#/~1�uƹh��Ө�Y�0}�9��x���ټ��=5/��Y,El�?���KKh���^Ę��Ǚ� ��K��#m"�_�b����K��H����n"j�݆9��2"��Ÿ����wg��]p�̷dd�I�f�dd���gd26��L�E��ɸ���d����P�Զ��*},0�]�q��vg��
��4xaj�L����ZP?�h��J��)�� .�y�n!�s:_�5ƪSp��#]N����˻��'/0��i�!`.�ccr�i6$������� �~^]�h}az�zʣ�t�YDf������q�򺍊�2�S���lTn�,E�[t�v�gݧ`ւ���C�����LE��sz��9P���ǿ���Ϸ_�����?jB煝�C6:�*F�Ź�;��z\��b)4:�%MR���v���9�ƥ�^M����ݓ*�����IZP�W������'b�ַء�t�Ρ��t"v;�L��y�紇��+0�_:�n�1��k)��]�r�ƴ. ��}�Uȋ�,�W����`�7��7��i�^=�\�i���>�s�T��ǓX��z�5G���@��z(u�`�!���,1&�%F�1��O��</"Fd�Xl*��Wkq*Jm#J冶ј�8�1`e.�>'��X�U���F��+��ê��E�N˘��i"&n~n��/Lk�`�:p�&�3&��ul]O����V�u�b�i�B�2�Gc��ć�?�&H$Lk�ऌ9�d⓬n2�K���EL�$�Z���S�G8���ɳ�"fpxlЪt��i`/bj/��fb�5MJ����<�b��p�#4&&F��؊���$�V�M�ۧ�@.��������w���y�s=�Na|��[�����0��͹��4mTFj�*&3�:O|hMU��lؖ�/��Xu1}�)��p���H��ZD�EJ�u�c3�A��DCo:0.����Jbm]΅�Iɶ݀���d4�v&�b��؃���~�	��r��dp�\�4�&b�\�E���F>��ciz||m"]��4�e"�r'�YIȑ��}�����sJ���f�G:�
VF�T����Vn�����!�o�4�L�֗[�d�C��=fC�\�!�0m���{��u]�GՋ��4B�U�v�1Gj򦖍��X��/)�a�&^+d�9�'�xt�-���'߃�ȥ5_f�#Ĺ��452�q��55�AMv�p-��r}���*������ ,]�'���`:ELs�7��ؘ�!7��!�D�h=��=�9m�c���c\H�N�7����n�,UDlC%	��0��Mc�w�%I�Cֻʌ*0}��:�H�1q�xz3��D��|c����\tQ,��Ś�K����F}�m\6��G@�1u��Q!ew]:�\
df��Z�j�4�����O3�����N����N2�fy?�s��p�0��;�6�"�l��ъ�32wE�3\V�g/��M�,������c���$\~����#�=�������v�ik#`r�e������NK'��̷3��������*vN�J�u ��LU}$�`%��]˺��{+0���[	D*��D�~�6�q�tX&�7L��hh�%&i������:PQ�it�ue
���[�i��ӊ��2'��FL
A�$�p�D� �^�0C�	q�9�X�)5!h�|v��5j-��{)�4�|C�pF̞��,��	�P��Itr!������S���
����VSDZg��Lcd��`O���=�0}0g@G���d�/MFv���    �s��>����]���rS,�\Dl�g�GL�CHA�MFNAo���>�Ϗ���rJ��{������m1m2+�y�\�)��>#�sI��[�V�� �C���di��g@�YZ+��1��8����)����2��nq_�{nj����z��Aq7��D��v;��@1x@���	3�� ����������"f�D�c��j�/���h�Ќ)����q�A�$$X�_���>�j=�^L.�[u��������wq�T���c�PFq�Ij���Ћ��
l��왨N�l���,MC�K�er8SD�r1g�`�l�5��:�NĄ�õ�-�������1碔��\n�-��j��"b��Y�Mmõ-�p�چ���\�)�:4ÈKu����=�!����FD]�B�,�>0���&8e`�9�)b���BrAZ)��
����Q$���� ���T�V���A��{��Y`���hAd�d1}���җ..�|VY��-><q�x���D����9���B�����:i
,�Wj�������Ǐ�~��X�" ��|1�c*�{���3��XK�Y���W��,0Ca�íZ����m�Q�2���Hۏu�F��ܵ�T���^c�F>H�c_ws__>²F���n���`�y���٤z4�T��%��֋�&L�,%�N���{�<���̘�K��	�
�;YDFU�&i�To�(6�wN���B��<�[�� �4��Y�;<ʔj�[����]
���b�_�����C��a���R���o"� �cΟ?��Ǘ�>��-W�ǧ����	��|�#yS�on�i1���s�TwMأ4�V����k�cK��W�kz{{~����v�-�;����N���1e:	7G**!4F�Bh8r��V.ѳu1�e�*h�#�� In�2Lq�v�2(�|���:�rL2��\�\�NpO:�Y�m��\d5UĤ��1E�����t��˻�5va�MT�����n�L��+�;{��
�4�*��� ��`\|�5l&6�RG�%�H���n�d	��uo⌽���~���bf�jM�H��v!/���$�~^cz��S^Q�mt}V�h�G�V%bwZ�+�z��am2�3fip�L{2��ǂ�X��j�6?����~CCMBF�6N��"�wS2�<�sLE�EL�P�'MD�a�1��F�$_fr����R*�xM����5������C��������W�(�����t�8t�DOJ���hh�b��:(Fz�N�4�i� R��*$��b�<Zq��C]��p�9~1Ky�O�h�'S>��E��/���͒�e�9�QW4�B�.�ī��:�5�/3�6^Y�{���)���biA/L��6AK�IG|"���Ԍ˻�+qu@�iu�k]���HB��$��
�T}0{}p�k���z�MQt��Z^�{
?g�$b"c)�dtH�_Wϕ_B�pvrG]�L������r!Rٝ���&/��t�eI%�-�����L���r��F���[�U^φ���)��ޥ3xpd;��z\�R��ړ0�"����RM�_EL]��h����>n��T`u؈����q����l���G�޷Q�WC��`�pG-� s���t�f�oLl�ug#.�1q�������D�N�'�M83@��׹�T�0��} �W�铔�?f�E��r��*b3�v����햛1e�ei�;�g�`X@���	3�t��t�-���â���]ՆƝo���1U��pwLDdk�Dc�f*.Lb�C�.����Մ����Ӱц�u��r1��#�mu)��8�PR�£Lԩ.��,cr�!�����C�ћ͘� ~��y�NȔ� 3D"d��M2��W�̓�̮pc	��>cƔ%$���LL�%$.�~�˝~�ؾj�E\ȇ&�!bTZw͝\#t]P8$-�����6����0aA�^�&c"S�O�B�y�S�l����9d��қ�g	��!Yz1mj����i#��6�4��չ�c��0���	,���ܭ{���)6,�xLƁ�E���=�El�-���f�<6.�iryM���|� E��1��\�z����Dv쩩!�G�����n
��Qe��Q�j߈ׂ�����{���. �p��YL�sϕ�å=�����x�wƦ���,��=DL]�}v"�"Q�m�c�����@:+��u� ���K��X!��ז��sj'峓x`4kqa�PΕ#=���jD�q���1��y��3=�W5�G�����̊��vW$'�]e�쉠��#��&���Ła�u'�(�ke=���3�a>.���Җ�Ş��s��>��w�Î[5��81�U�ΘV΁��v�lgbr��; j�['Ad��v���8��T?�A��1�Z��X~�����O�:�\���'^��]H�t��ie5a�I��#{y�#�߾|����?'.���n���ܞu���D	�-�3��D!C�U^�S�Icψ�V|tra+�H��)%��xôc�N�/8��j-0m�$�p�d�l]}�R}�C�LB��`�q����zZ��Ӥh]�b��PwIc��"ҵ�z����u����1�A����ʹ�&o�-�s�$fc���h�9H$��n���2><0<��UH%~`��V��_�����{��Ot�,)Էt�~��/"�v�X*8��*@e�[�re�.f��?�J2R��$c��]�s����������}��ד�M��9�g�,b�.�0#���'��3���,<4;Uj6y�E��j6��`<|Szؼ��`j� �bU��{M���/#;u|{���Ϸ���w�__�r���=d*�Vz;DE�*�Z`&f� 0����J^*�NI3E�G���"Ə~88��׵�~��"��6`�He\�6�qG�9�]�
Hovpݖ�q$l�u��=^���iml����;=d��.bڃ�T�;pUm�9���Z''~��Zޣ�ad�i�5�p�Eր�6qCy���Ya�����!-�T|
�g۾J���=�5�7�u~đ[۽K�R�|�v�,؄����g%�㫐-��I�tz�]+�0�;��I��������N��̅>�Bpe�n�&Y��f��^��p"��/O�3,�g��͵B��2��d�ٱ��e��q�L%S��\�<Y���ƒ������)�De�n�W���b��U�fG�?1`e~�,��]�1WO�,�>>@iw��0`s/�aDl$к�>�Oe���#{�t�i�	����#+�H�Mw����NĄ��z/y��:�`c��':�,�K�)������gw|�.�y&}/�ڍ��C��&� ��6�6a
�j�c'�v�;����I���J<i|�H,���� ?����ʱ\`��Ӂ;eŚR�1��fH�D9h��x�B�v�v"��Brΐ�?�-��&'b����n/�x���*���;>�I���j��X��~a�G�G���5�EU�IĴ��af���� ��|@嘭N�f*��7aꙂݘdp��7�p�N��)���
	�t�J�\�l�\�4��U���c��8���7_���4X�7�g�~�����K��s`�N�́���HE�'�H�Sf������eQ�dد8t���J�gؓrq����|�>�0���csߡ�gWܫ梈1����,N4�������J[i���D�0�#�/��������)T�v�V���y�9�b8%I�1����8�f}��������"4���u�s�:��<�&bw��|cr� �,�#��+�´nu�^Zq������D�օ�+AV\�\#������Fk.��5q��V��M����야]�i�r��|%�W"�O��q�n���CKPmʦ��)i���ߌ�	�.^]5GZ]%�_`�jk�?��A�vBI�����"bY������O����z%�����6ݣ!���"�Y�u���9@܋s]@X`�� S�kw1�?�����i�^\7�x�l�tgtڵ�[�>����B|��'��1}"4)�΃Ɲ�ʾSI	�Z��|�@��    -	��o��cu�Y.�|J+qP	s3s3��A�	f���5kI�����ڭ�G�ucV"��kJ���I�[H���0�c���D�(zDCaj�W�/�#W�'e���}�ʘ��L����W���+5cZ_*�W\쌤8��~&	#Aq��f�XEm`���B���B��W)�����jY`J�a	��"	7�k�Ʈ�B�[i��Z��zJ�y#Q�`ғ�O:����%�ȹ�A���MDNI����}�E�ȑ�q݋8(r4=e3f��';j����#>6����0���30�F:R����d��d������屳�s�ROs����ʘFG+�� ��D��gIAl=�NM8��Loo��BW����&&�HG3+�����ТW��0ZEObVn��͞�����A~\���D��E�I����4���5�-0NC^B	�*�)��O��.a��9���5�#��.K՛���t<6e�yɉ؝��,K
�3L�l.��oQ��"}2�&��fS�dqj��Ջ��$#�OD�m�'�8K-���迿����3޻��ᒞELL�|���rr�������\�%��EL��}Z}����2r�͵��CZeVZ�ٜ�D�v�I+�S�tT��t�b-���rj.�V���Dj�7aG����:��́ԯ@�L䞧M�_�JG�%�	vS�u����!wg�d���p�\�vb,�\d��N$�b��DO�,b�B�9��"�i��
C�Z$����q�+�E��C��
�����xW��1��Y0�\���FX!d���$E��}���:u��x�M��i��6�X�gb�8F�T~w��DM�*�S�+~E�6��x��5�ⅱ�w���I��;��X���* _u{���}/XD�{/�[��^b�R����
s�=B/���|��(˴ߖ[��\`wj"b*0�N�R�[�к�cNR|��.n1ダ�E�P��D�C�?ʏ�����o�k���2�ɝ��@�4#��T��U�@�1c��-GxV��������9������V�ڢ�u���Y�i�d�AW��l�9Y��ĵ��%郖T�Z˘��̗��FÉ���ˇ@H7?	S��mdj`霉���0�7�E��&b\Jsi8��u�4�@ҫa�5y3vn�8��H$�e���]���εC�6t��.7�b�jx���C�Y��8�A��kU�W`�k�F�IT�aݶP�X>t09���-6�oMԄ��,��N�6:q��=9��8a�x��O
�:#"��/"6j}V�;tȬ�����@C��%E)M���;�r�&G�G����K��v\��V`\HC�ά���ދ�@�d��q��|X��6��Ê��5X�m�`sT���%��J�@ɉ؇$�L��Om�<��儩���B��u&���v
�Hs*��w<��ΖP��9W�B���� �FG9���g�S �v&
�Ҕ��wW�֫1m��m�u^�L[�e���H�)lͪ���ooO�m�d�i�l
��Q"���v:�M�vs�UZ�Bj�`|Q(��D�.�g>9��u�.��\��+1�S�e!�{H26C�8:'Jy��!7�/D^X���CĘ�@Ɵ�u,��n�iya'0nѲN�}ֿ �P���]�A������>�3���E�\����n�u&����n���BfL2P���Q]r�s/��D��s�9�\:i���ڶ�c�6�,c��Ixpa]��y���Z$QY��SZG#.e��;�L㉚��k�H��"\@��t�Q
r�8uS�4�YI�2!%8����"zG��[�D��)u2p����WT��BDV�@�x�*��nGr(7���j"\��+��@��YD�h?�SZ��\�״�	zMg
�E��g]��k@����m<��
mL`��w�t�w���Щ׭"�W�3��-62���b1�Maڀ�m�ʍ8\�IbR��3��*��k�ML��̅��"���`+n�3���>kSx��0��@M��6�ł4�p�MG�Y
�	*��F�Z�J+%��	�ƈ�v8ė��G���o�����l~���ۯ���u�"�2�]`�^a�$*��_p�Hs��a�*��8�2"���w��}%.(�/���Ӗg��_`xP�"v�t����<��	�|e�_��(�1ٴ)Hi���u1e
�[��Z��b	��Y�H8�6�1�7��V� D.ި�>����gwS�ĉ��J��y������÷#S���J-{9$̐Ё�:��d#3���TU�K^�9�q���<�GM�X�.��ZW��.n��>�W�ݖo\�pt�6�XS8���x<Q�Ʋ���Èa��[C�}&3ա��&v���b1^���c��r�E� ��s����'*=���)S��E��!��vo����p'�#9�6\��-�+0c�I��D�^���Z8��,>qVo䣼I�ȋ����u�bg��?�U�a����12���*��K	`�ԫ������9�*�>�U�����h(m��{쿔[�O�?lVڃeg67�,������(����mQ�ȋ�e�Vb J��q�gcw1�,.�#���3��!5Q<El�o�b�תn_u�t��	P���ʹ��;i�:?�����yË�!ۘ|�K@���a�ǖ)�U�0K���g3!��ǌ͝N̓�jkk
^��� 7D[I���s�m*@�i��p���Y��q\/p�˴l!�	�air|U�X`
B��ޘ�Z��z�E�X>O#�/��dp�Eqa_yB�������r���'�=���#|⿼?��Ǝ=Q�[�azZAuW
FCJ�"�0����{{W��Z�G<0&����|#-�zK�1�&��)�h���j�y{t�zگh�B�~�u9ڇ˅�+�m(ʻIc�wa�@�7�l|u	x�8h2V�b?�٪K��Aa�=�����S�]&�;W�D��.��{f'����l�m����M���D�K�刵%N��;�k��)J���*��Ɗ�t����D�^�Z9�c'/��=b��"b�H�+�Zo;�cج"���#G���:H�۵i�1m�ˁ?��` &���}X��b���r��[L���ή9?�1a��{�$U0��#�.|�u%���������'P�Y�~a���D�U��-�b~M��˘�%�)�2�>��ؽ{�kǲ}$�E5���:<�@�a��n��ݔ���OP� a��/""��ǹt6���)#������6"���U+
���^;8T���+)c�-��]���fl�D�X��*���i6 F����)���J���Mǩ ��Dd�_}��@·rF*��R�
���t�`D-�'$c�t(v]OP�{Us�Ժ�y��E���m�3�;ec%�2���H����(��1����F
7�C/��MĆݳ��+y�lLn��d�H���y�R��1�k�ܙ�!�1�=�8RLs���3r1�E��:�h��a�d�hz�(�j���e�������Ɣ�o�
��ş1}���b@�{�F�v�蹁*J7c���M��������άqQ4�]ʄ������?oz>�B\|&��˟���Q����	��zV��
L+�1c?�I��i��І,��S�xc6�8?a�<z�*��`2r���zzk�6Vb�G��;����g�Z��$���jg�s����KL]r��cG�g&*p>�f_xF��0d<7��{aZ������PI?ߟ����x�|B�:���*�蔘0�8O4��n��""�MP�a�G�"4�y��a�Y�D*������3���9dT�CĴ�,�4�C�c��@3rڎ���:�_̅�;:µC�{6B�&�'I�=C����%�I�׷�<O=|/э�uX{��>8̆���Y�'R��͋���1SU,�?�{���C/�EC���PN� ���i1� G�'�FW�::W�o��ܬ:���pV���r����޿~y{���������ǯ_�-#�NXn
̩Y��u�'�ٳ38]0.	�c�4�1�zj�]�XK�z'bz�D\�����m9��#�QI�j�$�\��O���/�M�˗�    ������O����8�������4��\V�P���e3�S
M�Y��x].U^r��N��J�I��֗��ڜ9�IX�>p\P�g�@#��r��%���}u¤|���;���3�#�݅�����,b��A�G��9v�*��=\Q�,��$��.bC�����+��A�_�{�fؐ�����f�'*�u�ޓ�ў���KpQ�������Ӷ+�4���´E
.JG-cr��#9J�5ix�Z�� ��((͡4�"b��!�;�{�c��s7=c��`|Ef�k�nn"v/3�#*�Ҳ�>��K�J�W(l�F���Ĉ��!S���Y������6���	�0^X��}�vT݇�0aZ^�.�5�I��8�1�MŌ��t�|䱴��0錹�w\��W���7��	�tq�H��"&�\0M��w�i�{鏄עmA�d�xSw�"�D�j�_,��8�*���vy�h�~X-F����&YEL�j�I���o�Q%�gj��ŰV�%����񉿐HZ���v1m],n$�'�����"Fo,<��n����Lf%1N9��~��[d�����w� ����'�@��"N�L�/5�ּz.l %�RӃ���/��m���k��U���BDƟq����sq�~*f ���cO���x�Mbʅ黩c.Xm����.�&��N����p˷�%G]S9W��V	^s�5�����7Bl1n壍h_�v+c9?2��~�t��pSH�=��M<#���N���i$���ޚf��Ȏ(��	�3aڜ�ڤ�%�r� �����m'1�e�{H�]���̺%m��s"�{�����!|�~.(K+w�/x@C}�`����lLg���	GSC��y�]YpPb�ͱ�<���Ӆ�_� ��1-���wA�Ӕi��j�N�����C�<Hs]���6і���T�0%X�˒�a�w^��.����O�8ׯ���0ۍ�xa�{��.q�����cMD����U�V,����ϟ��s�j'�F��wEK%tV��.�%Fz���	���b�����NE´�䓮Iȥ[��t��PI'���)��Ҫ�E	uXb=bq��گZE����ф�2�V�@9��	�v�Nț)>KL�xE�s��c%���*��j%�yK��D��m��q|NLr0:#�����B��<Q�-�Е��Wb�¯la��@F�yeT��W�ྲྀ��9t�"b�Bw81��4���V�܃����N!A��0}w���+�Һ"��Y�j��)]��I�k��w��%�1}�d���Z=��[S�1���M�n������y�3����.�M����5���Y������sN��l�]EP�����መ���3�(-�2�_���;�B��R���LJ�Ж#�ڝ[$(��L�I�I��S�oD���%�E�4��v�&��6ǧ�z=5^�~G0*���"�c:�k*l���ВK�4]���00	3��=�L�3���7iF|c&e���M�T�����i^2^�o�n�_f���ӣ=���Y�}xm���oQ��l@[b�W���7���h~5>�>H�)���n�f�1�7���S~#�־g�Jn��,��trH\���`יf��c��[��Dw1?�W�D��]]�5�����B.0K����.�h����%���r6+�3{�5BK�(0���$W�$��z*�U��#J���G.18����L��-+0�-#Ox�j�oÈQ�i�E�Fg�$���vu!��|��;pфHLnf_0b�qk�-A*�Ԝ)0C��<MHN�$�9+����oB�n��
�����8Y����F��G������\y�0u��s^�VV�Q�T�[W�i=X�ċ\��k,>�d�iW!?�p'������jai���Tn������OT��6[ 1�"v��"7��g�I4��-f	.�C��,�+�h�9�q�m��M�����xbVa�?	� ³z���|5S�O���K�v����$�"3@� }^�y�\�����ϕ@[� �i2���g�ы��oq7��w���@��r���Rͮ!^��[<al�ʶ���VS=Y�A�g1��ؓ��
�����ʉ�6Rɸ���ݍ���1�� H��S����&-�����^�^x�lLVb��iB'��h�J��iҴ#Չ����vR��ޠ���y;�ez�; ���q�< �̋��.��O��l|���__~��SK��%��5:qg��;�e������{zHH1�q���2�U����tv��zo.L�,����Гcb�<9���ّd���m�H��6�y=SjK����uR���Ӿ��ہInw+�ݖ˅�{���{�4 �;{'�`r$�3o�(/��	�:IR��S���y_�2��<ҷ	_��wF�Y�,Q��p���;��
ދ��OQև�r�"6���6����H�q���V3���ӧ��ڕ�Ȍuc:8Ը��>��i�M���g��b��DrrZ{1�旪.��X��w�6��,��:۽�X)Y��E�xw���KsU\��/�&�'D"$n^�qw�� WWo�g�E�V%(���+O:6����y}3rDG������U۬.#��)ۮ�%W���oi�9q��
�X{�0�����t��M�؀���U87���tj��Q���~�6��|�2�?��4��m���/ n�&��Mq�6i�v>�n}h�d���%)��h����{���5i��ԡ�>�2�.�a� ����	��Y���$�}s$%|�M=ʘ�O�晹���u2u@#c��m��֦���^��������^g��0��RA(�W����<6�/�_|��������꺍���=LƋh�����bu"&�We-\����uyQ`���w�(ܓ����������Ƥ�=K\@�������!���DY榷��K��X�b��iM![|�"�q�_�|�*�������G}	`=��%L�{NO��MLl��$&}b����KĞ#2r��&�!����� ë�:�߮뀼�s��8�~����g�ŷ@�^���1n��순�ױؾ���y\fl��3�T������e]�ʡ��`����&�X�}gJ�+j�]��O�9U�������/�zUI�����������y��-"}zߊ�tr���]��[Ke*=�ͤ�h���W%HT`L���Ƨ��Bi���2�U��b�����R�+'4�O�mW>�q��:�0���K��'L�K�}��agg�X�[����ý�Ly���
�ͺ�wz°<`ѫ�v�J�������&���w���u�g�������\L�"�c1��5�s�7�A�C�ci1����ߠ
�m!�q{�'Կ�}$LY懫�"��i@�~�K@:n[��7N����µ��B����:����H��H316���4��u��8>�"��r�%M���~T~�=>t�Wv(}�6�x��M;�C��g��^���H��^��B��w�Ƕ�މ�����.��*�)0m�.�ߴ�`Ln�qbɼh�"�	�/jf�ү��1~y��_>_�x����-dƞA��ٺ�ƅ.
�,b�M���/?U~z�κ������sQキ;U|(�j����hp%��5ށ�d�jl�Pb¸�|�E�C������/_a_�h��� �E�~�w�G��n=�\�EĔ�ǜ&@�:"����:�,��cⲨ�GQ�#�;%a��bh��*vG4n�8�R�
̨1�+�#%M�<���]$7��n;�c�Yqa��}d��ڟ"��п��	h�E>�Ԋ���J�ͽ�iKA|{&�T������|�XsSW�'&G�
�0m
׎����=:+=|B�}qa��'?��1�Hޑ�����U�_��2q���c�޿���]��q��-j�k�x��IĘ��c�s%�[;~0X�����@6��K\|�l,0e��B���`���1�0����������F��{7̓�Yi����o�E�vm��#F�d�
K�t.0}�!4�=T� L6�P�!&G
W�@/H�����=K��9�,���圈� 1"���i~ �  ��0C��NL�`�\\q��`J�����5�yF�r�3>r�U���loلA������	d���w���b�M%��{:�����*����:p'�^&i�0;���y?�,�D��{��NS��]�Y\>�Ymbs'#X1Y'��$�g[�̘�[{��Z����X��6F��)�'.�&JD6Fh^���-��g�3R��D��p�k����<C.�Wq�gІ���F.S�:�>*�&�[c��7a���:k���>I�hBn���_{o�����|glБ��VV��:�֍
LX�o��;�N8%�3*Rjam�f�P�E��㗜��;D��%L��=Sl��x�����]����O��%j(P���n�� �R�3��9"5��)�ƮCS�Ѵ:٘޽Di��I�&yIQ��J kBX2�W�5
LaM㠣9v���t�0��/Y�|
��g'u���ٚ<���*,"�� �߭���d���vs=�=�d����\��P��2F�z�𪪞����zӢ3K)��f)�hӃ#���&fL�<���aM$�u
:�7�ZvE�͐j��q��P$�ß�?�������BQV�h$	��`xa���^	��>i{�\4j�r�Խa�:�����������+�      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܷ-[n#W>���g�C܁z;RW�jT�:�Jm;����6yH`%� +�eO�˭}�@\�2��f��f�����"�޾~�9�/@W���t�sK���F�Fҧ���ޡY���������i��X��l	�2��D�9Z3���$/������Q)��]�#:ϐH�	�N� {�c_�����y�I��t6�ҟ�M���ɧ!04M\�I�U��8�Ql��c�3�����G�,�.jE�v�cF�	U*��b���gu�9�br=��4���1��ɭg���_,]\��(�.�r�s�#�T������ɦ{q���[~�v�w��<��9ނ��#K�����T���k�3jŷh��g������>���	���W�h=�v7�������87ə��!&�
�5ط�^׊_3����3�G����D�m�D�F�}r5�?G� �1ڥZy"=�#	1y��͢��<Lp�����H�*��G��(���i��UJ��'� 6S!n�% z-�~��3����qM�۠�h+{�]U�˽�����0�l���U�[4�Ab�3Ju�Y�إ��{D	1��Λ|�M�)����9���4�A���\�KKC��>�ds,�Fs|�b�QP<���sĮ]�4��x�����vD������[i��X���Gb�-�iew���ƞ�%�c��&�^��M{�0m�J3(�b�3��,�2���2���]��_����di��޻ť_\��v�
b�ԛ��d�f�ͥ�b0���ϣ%��&�4��Ti����/����Ηg9[MF|��l��WgY�u����{��/i�\�4�%B��5�S�"�e]�v(	3{�󤧯x3���zx�K��/�ɵY-�����!���'��[VzҖ�1���N��oď.�̠l\ �R�wDR��ޢ�RsZ�M9�6S�e{8���"*�2&9�����1�J�ަy�2�&)/ỿ��]P~��7��.q6z�A9��<�F��+��0"�v����W�*�2��۪�X�=�ҴqY]��)M�H��Ʒh&R���D���fmM��H
�#�}lĽ��S��\be�8�b��[4c����=��m�ӊ=�e�Np�����9o����ykUUL�v���T�Ր��X��t�f"j\+}v���:#gl�J�q<���$in�bR0	����ŉ��M��]L��v}D�b��|W�aIZ����(8���BG:�	�؄��M�\}K&�]��z/I>csw�v?5�W���ſ�M�cZ����9P �&}�G���-�1a5
s��j����ޥU��$9p����L;΄E���`��5�y�T�<�MR�<�Մ�����ĥs,�M27Y�����w�y��߁�ɖ��D�C*Zx��+Zd\'jZx�OkZDT�U-<�gU-�4K��oP�,��1:c�2?�@ګ6-A�pz2 ��}�ќH�$�$4-����l"����9
��S��NђV����+sA���ؔ�M�3��Nh���q�_0�ho�ak5�NV�b�X'�����|M$lxV�	3y��(a#`�����V�7�=_��V���
[�6~�a�61�DV����:o����c9���]�����Q�.k��SԂ�\�0�hJ�G$�u�7iʯǲ�����*$�)ӊ�7��z��e�������(b&�G�]��,����y}�
�(;��� ���(�&ԧAD�U�#�SUǷ�N���r��Á�c����J�D�!�J�=���I��ȋay�%����,=�
�X¹�s,��	/Y�A7�g�Al�0��j���˶,.'j�i��<9}�&��ާ |QGT��"� ̽h�^�+�&��Dň�D��&�A�0������3}�HB�k�
�&�&��	b��M���"Q=����L|����֤E�#��*M`�>-MQ�(M`�>+M��I��D&9=u�U�ؔI^�]��?S"��9r�XV���Q���k!�k�B!��ߣ�DΧHN)�ޠ��X4rz(��:=�� QKIP\|�JK�c�b�1�0�cv�%+Wхye���|Þ��Id�>Z�R��_������TK����T�YA�\�żaO4+��I��%�p�u0�m���f�m�Һ�Ӊ���<���>��2N�L+6��e�R�8h�9��l� 1y��MCu����T��؞�ku�>|��o���K5Z�N��&
&;���z]z�y&sd�q�h���:��w����ت��6f+&�
^��;XhQk1�jQ��ˇ��~���_2�
˺��<C��0��!�9�'z{ݤ�h���M�|�/�*��M�sÄ�c����.e�kX��N}��(.�ǒ�'��X2bς�<DU�Xܪ�K�0�����!�Is 錐��n��]�)s)�E}����Ãd� 	C�=������佑>�CCNZ�tî�����w�q�ғ٪��w6l��Iy��M��[;�*��uwl�����sņ�!F/#�ſ��͢{4IpY�q%y�\E;&ϸ�1
�"���dc����2�xΤ\�3��i�����*-�&��p�Ě�x��525����lA{���D{�f�#��Y�����K���ʋK�Ѵ��ԧ�˟h�r7L��{�8���~)Cf�(,ac��#����=��sKw�u��2�B)��7x����T��b����/���7�akѦ����Ѵ��K�>o}�L�r���������]��Ŧm�ج�!�6ak�Ğ��F��K�Z������D�R���U��AcsD�у�4)������O�N{�IqmN�g �T�g����:g/Fbr��.O���t��[O{8���,�;�R._�l�u��4s�e`_î�hH��^0�5�kH=؞��V��rS�j�N��(�����l�Eu���_�� �a��K�����_\�f��ܡ9��v�g�i*��]D����ٹ�g�{f�L�D�
y�d'@L>���i� A0��ag�M����s�栩%��-�dE+Kj�[V�蹱���(JkV�t����� F{�7lrtq|����)V�:-�8����d�����H�ܴ�L���p������o��[�]͊��#�6_��D�~��Y��=pEU�	x�?`�ir�~]i�˵��c���x�N-&)���`7C��q�C%�}v�!�����Lq���SZ4�S����)M�E�w�d��d�Eٔ�Uˋԇ�'�ԛi{T�"-_(���v�(�:����L��;qN��"�
���A��4��ۧ�yx�O�Șw�R�xgz�p�'&�W��)�K��ۥ;����l�)r�n�Kx�A���T!6���g�*�D��X�P�N�-/G_3�\ɧ4=?�s������߰�د�OԹ�P6P:�݋R��8	w������|����2)��^�ʮ;��݄,ҋDk'WL(�DC���]�f��$ř�4�S��B�V�l�}��̻�4IL9����fM��#es̥��o�6BI��o��	tնj��(~}�����?b��Rg6�z���7[Ĥ�g��a���q��&ez�ū�x��޽�Z���N�K�"t�fp����{��G��J����."c`^��B�$j� �ϳZ��h���gۭ�*#HF���!�9������M���էT�6m�`sR]	-�ܜ��{hJ.�T���6��Ү��5�v&?�	�]�@G� j�i+R�mH�f$/��������iV���>����Tq�^+|�##��q4���X���C�2�(A��*�|/�M��_�e�
Y���O�.��ۗ���*�Z�@s2|�h<+z�K+�K�}��[��|    l>`?�cJ�,Zk��h�-�Y1�	�L�H��F�l�K����훬����#R1��c���퍠[�Z��"X>ѽy��x����.��9��[��T~Y������e�V�kߕ{0���do�sg;���^ˉ#� &�t��e	\���!&������q*W�h����+��v���#�$���)��߉t�Gk��vW������$��?�1��ɖǐ�Ӱ�J����2���ԩ���&#^5I����*S#	����7>G~j���q����[d� 6k�M�*ܨb.��E,��x��Jvڽ�a(���1j��*$�8����畆?e�ب���)=�YLmP���=���ڒ6�[cڴ�.��t�RI�U��G7a��Ve����^�Z�[�M+�{�O)�&��r"�ݓ�9��p���tE��,!�!�D���4{��?�Ǉ�' ��F�˟_��h���?~{;M=>�U-��7�āNgs�ԧ(�,�nwضZW�4pU~|t�C��ŉ��'��y����&�/C��t(�ߥ��{���FW�ܰ����m2Y�C�1� ��֫�����l�Ğ=��C�u��� }Q�s��w��/�-r렌�{���n7XŤ:}�B�$�Ò/�R�ySa�2�1{
bRi�6i��\㒏Ҋ̟I����І=�����	���Pl�
�&h�cr��f~�MZa+�<E��)��dw6L���{�.�_mF�c�ٶD�k�d��3^����&���J�@[r�\0
�1��E<f��K�����D�[LU�)���+���H�T־���c��ݻ����ND�,*ӯ�e����j�oQE⶝�a�)�۽�a0��޷�zK���"T>� �U���@/؉�@o�4*n�翽K�α|/-�ɕW��o��������j��)�&i��*?���� 跪�S��|g��a�S�'�����{�{޵�~�Ϸ���˙������Џ>=�"�h˚I�s[���*<��꨿
b�
�s�`�y�.,1D�Y���'C�|)�c��]�.�U�o���x%c[*K
�-�9���op�}W���iͨ�q�����}���3��B���P�Ko��#i�l�d9�\� ��'<�W�1��p%-S�=mzu|*�����ѣ�!6��@�P�����*S�Rձ[DR9:��l�$��̼���2Ŭ(�c�m:�Os��F)⽴�6G��Z򌎎����,gj7ЋV�M��j]+���*�0���u���G�÷?��yfg[/YƎ3?}wy�R�h �,��,l�7���8�����|wfZ�1�w����]�J��I7bce�o]��y��23�-t�)��Ui�ƢَVi���˯~��1Y�4@g�t��� �^E�m�W�b�٪�T�Z6�o;ǚ��l����ؤ|O��6�h(���;k]������i*p-����ac�{��e��bC�F�_y��'Ye!6&�gal�B�T-��E�ō�q�4G)�I�*�D=�ǈ�҉��|\�^/�ߙ��AfMj�T�|��5Q�&)��E�o<�ϼ��V���X:�L�M�#��~�rUF[X&��k5�Td��_��{'_l��ҟ�@'[��*�qV���� 1�Eߓ���%c�ckvfA���?߳~w.?�l�{�����}ٰ����v���4��-��g������\��z�M�3+Z�h� F�ӽMO�)�#�)�w��=)��S���b���u5���U���姨��Cl���P�H��4]���qP]仯<"�"�a:;LB͋׋*X�n�W�j�+�VTI���^��e�kHmp
<8٭�b�`Y�5�dg�/)8�&��Ճ��V�Ql��F�&�:�j�^���Hkl ;6��ׄKњ��Ф���-���P�ႹH��6G��R�����Y[����B�.(�	έke��Y���#���p]/��*�;ZB�0K7Es.K����&��m|��:���^'�R#Gv�ɣ��l02��������ޱ)�T�(���^�W�������4��g"��X�	�1�	=���4V��Ο&�Uݥ�Ǿv���й0��-o5 ���| �p�k�-�U�̅��=�k��2|!���fF;��ʲ�1���e�iP��٨�
���{���I�K�bqh�g�L�6C�@��zFS�8��{������;R/g}�w��%$�P��SvA�'v`�3���b��(��,O���r�󼹞�i�%>x�����4�:I��>�d�/Yl\��L�b�ܱ9WYS�dMd>Y��]Iq�Rg���]]K�zd]�XBs �	�<��v2Mƹ��)"��f��T��9T�c��&�E���6������x��7��J��o���7�%M�9"��¼�9��S��~��o�������Y�<|	G����8�=��E4�>K�z����-�f*v�6H�2��M�XT������0a�C��+������F�ps�w�"B��r[�����[�v�v����l1El��<���gk�~(�ç�6(L�������s~R�2���L�vCOʏQ`NA�M�nٿN����4{�-�$`�F�"s�$��+ӵ�Y'c�%EJv��S����v������E�H<c��V��?��j��5�l��2��`�����%)c7w���oΊM��*������ޙb���6�tG���Qmju[L>Ұ���/���w�EVм��.{'�*@�Z��])S#��_P-|Ź��XF\�Μ��6��_wg���'��}�aéׇ'{������>��A���#a:�;�	� �lw����˺:��L*#�-~q��K1���mׇO���_?}�v��pՃ�(��:�\F;&-�V�mi�x��z����ÊfEo�L��Rr���0�jC3�v	ք�k*�W�7���[�&t�X�v%Ž)�g��8\ot*K:�����
��I�q�2+<���b�����u�7ڠ?�U!�@�A��m#��*UW)Z��V,+�9ރ3M��mQˊ��L�{��b#�n�_S��ֹO,�S�mgw��i��5�5dJ����#	��;����=���{ѭ�nu��HP��]:qt��?�bjv��1�F��,5gm�7�N�|���Fn���Pϗ�Vf{��͛/Hk���9�r�0i�^w�8�iq1�8�+� ^�i�؏� \�2�K�6��gĐ�-B�N�A��D�=� �����
luL5����L ������+5��b6D*3c��RY�^��h�Dj���)�Z-;�q���"��F�h�M��Α�mR6�ƽ9�$�!v��e�G!;��� k7g��R��Y�V@mƸ���Y�����T8�ļJ8�?c�򔥆��τa�S�5lE��-O�a{MӰC�LoY���6�;�X}ݕ�E~qAk(�Wx��0w�b�2̛4�
���,�7���,qܿ!X���o��{00·50�������؟�[�OT�����ȟ���԰}9���}�ӻ�r�D���t��n�T"�62��X-f��2�<u�yYDN����ٔei�tH8�W��D3���ǸL8C�o��sK�z����)/�i��9��>54d���\9�]��7F��bbF�;�2P��s$Ԅw�h���9W��\l��v����kU]�.:{6Ff�.���6�u��Eteq&D(��,/��[�ŉ���Uld�:�QjE�=���P���~4n<C�R�.��/�?�}��[�M����o_>����a�?���}{�ԞZ���wA��dz˰��'���j��z�����ú��u��X��F��FXf:-*(���(�|�l~l�t$ϕ3���������������o'C�S��Qk~ߡ��� h�il����QX��H��|�AM����R��>�����V���WQ�W�CM|���CB?w.{=`s]A�#]�*��)�B��Y�����ů�������u��O�~Q�e�^�����W_���i���դ���P&X�b�Cl��0	S$�Q�����s�r�;�u�s���n`*�*o����Xy7�a�r�=���%�hZY/{!D3:����s�=��M��3����    c.M3ܣ9{�����{z��y���6�?W���.p�ҹ�cs��-��V]ѳN4�,&F�[q����9Tq�F�M7��s���EY��a=�Ԭ95��YjE�_�%c�iّ�=�:�"@�^R��TXA�������]�kjQ����($�;�#>`���������f����U�x������$��}���䳴�F�x_��`-�H�ɚ�.X���.ۥ��{�.X�]{��3�IvrI�{���0U�\w��1�J��}���K�֡�s�[���se���+H�eYmH�sQ<���m�lMqc�9��?`���Z�ݕ�f�T��F9h`�f�vw�)�������Wv¬��������&Rh�xJ'��ަի-TmVi��د������z�9�ވ��m���[��lrmw�"塩*�iN�ڎ5F!6�}U�]�5D\Ԑ�1�Sĸo���2v���]0�mf9`w,���"/��'��	ɓ���xM-��p
�04)�ae��GZ��C�0��Iý��>�kbzA8Ӟuk��2ԅ7w�L1��?���P�㭱�'�G���=`�@���E�:�Z�4�dځ�2�b�B(�~q&��2�Mp��W1��>�)�)ք���)|��q4�&�-a]�Ti�����'h���<�]��P�4/u_d�����<`�1!v]�J�M�o��W��S+9"�VR@URI���	�WI������:��V����P����Bzߝ%���_RՊsz���O��L��&``R��M&����.�S��f-�^��T�UA,��������_�>�2�����_����?�~����O����%\ɠ��dH����.zLe7T�]��%�,��V$��%~���[^����Ƿo?��燷?�9OI�}n�R���@]R���0�V�!�{�����`���k�
(��� Y�� 5�=�F�M,5�_xe�E�b3|�_��6��؃p�Y[x�h��L�޲�󝥆�m`M��K%dOB��AQ7�;Q\!���DRx�F^]0����I��3,�P��I���J�ػt��Ͽ�43zڝ�Q��f��iS�D]�z�r�	����bCX��U!%+�� &.�B���%c��T���6/����6*����3�c�5HěmƜb.h�܃`������R���w~���P�d��]i�v)�K��_S-���	��4�K�c��|PY�N]�4̢Vk"�9��4�5C�Ca,�f�s�N�p�4�Z�jl�Қ� "������tǛ$P�b�����LEag٭q8U�*
w�M����Lh��|��ҺCgh����,A���spv�䊥]���4�&W�3G}D��Q��M��7U���6�Z��S9Pч]�7Fg��1�c 6�ܥ�o��R��j�ݎv�nS
�6���E�97�d�k�j���)3���Ћݽu�>D�O��c�4��.���g���i��Ќ���Llm3���c�,F�0G]V�z{��N�`�i :E�tqN9X�>��G��|`Mq@���#:`Bv,�l������f0��>k�"Ĥ��N���T$�Rv�0M��ȣ�}p���,M��c����JO�&:����IO���=�X|�GM�����&Bl\���+jbE�J#��nä���b9��A�ln�;�E�H���b�����aB���_0���ߤ)����	�&���ֻ�4��kT6(e�}b5�S:���t5���J3͔���I��|�&�	?z��F����؁K�Y?E�q���|���Bӕ{e2!�7=�M����=�9���#��X����1��	9w�v��!m��,ǯ��������g'��"�̄�)���H�p�����ҝѸ56ʛp�P�9e��_=S�\+}t�nQ�f1�X��`�o�uMQ�p��~B�Z)ԑ�7[�3�I5t]��W��{������~T�^]0Xb�Ў%�jD?�}�x{1V�=��~3��/�����س9�]q��n蚐��d��7!}z������|�7P�������@����u��U���}����(�=y�}�EK!@� ��ߪ��tk�m�Xȥ=�;����/�/~�T�V4bc���gF��J�BqGW�4�n�@�~���b���s�O%� �#n!]t��o�h���g���#�n3ɏ�}vz����YwF�+��	bR#�"eE��K�䦰���=I�/ĞO���Z�Ĕ=L�A�C�s�[��+&/cfuLkww]Q��c#�&5�8LZ`xS3�^5����s̥1�{4�f��]P#���� &�6B�-�c��#�4ُ�$����3�m�{���_jMF/j���(̜C�ӝtȅ��9��C.�*w�y���k�������/� &��t�#��:�p2��!�d��k�����[y_5���(�󥪚�)��]qʎX��	�$�����oS͖U�FH*��������`�X&v&�w
|GW��]��ٰ�LuK
����@��w~O!�d�7l�$�[��q�E�yٝ�m�wä^nW�J�N��&o`,+�%`'fJ�=��]����zYCpp�(=��p�钙=[@;6�~�J��D2���'��3C���4k�͝UV?,�G���S+WID�=Y�+����0�טʄ�vVl��ݦ�N
�'e|�؛HF��ʀ�s��aw�]��|�V��kf`ݗ˦�3�t*�9`c�{3˒�?��q���Z��S
bO��P��Y�א4��|quJ.�1K^�mc��bUHg�S,s��k�� 6�u�w�U����e?R�@|�9�V8Me<`S:���%eq�ƨ�\�\Kbҗ��[�45�t�C"��.�H񮽕*&�=Y[���EV%Z+~���_�����0� �������d7�H�Z�]���HTI�1,�ĵ���W��nL���ͪDt�Rm�j�V�
��fY:��>y8�ynE��)���u���;������`A)��!6�����mЬ]L0���uB�Ǟ��l4���fH<��k��D��>�����0��n��+�a�]a��&x�����̼�[�S]�����ɺ0�dK/�j�,�B�XL�@�:u�MP��S�A�K>��M"+��3��6@cܨ���.�2�P���E �ҡ�RRp�Q|Ԣ��J�L6L`���C��v�U�̹(��x�M�W��8���72{0V�+B�={f	�$@�'4���I�6F��HVG��V�ֲXa��V+D��mr�A�����=��_��C�!�G��Ѻ]�qx)殺q��wB|�6Ʉ��S�>�;ؿ]�o�`]?��O�|�)�~��+4�"f�2�"f�m)a�9�S_�шq�AR�v�j�u��Z����d�-���[�Il�����8�����=�f0m����������0��D�#0�}��/��!����tף�t>��i6 ��6j�g�]涴d�/����z���F���88�>����vڪ!&8��ʟn}QJPK�]6n���;ϖ�z�I2�=��ZY���T��V��l�i=Oڄ����m�?��)u\VJV���,OwnM;`<�xh����q�˵�h�.آ֟4��0"Ƭ&��-�"���e�o�+sO<�(�pɗ�x�.$�f�OXz�Q���#�S��ݏ}@Z��W�bҧ��B@�+D�'��j��,�������ר�!�=]��!R���^@����]�R���j���P�+nQ�Y�(�h��!�����n���~7�0�.E��z��w���'��bR��b�7�/��j�%�J彇�y:�w�H�C6<���o����N��	���&�Sb2���mbf�H�}�D�u��ǆ��l:��t�PǆuN���,��Im��8i���ƌf1$���ը)����^M�>n�|����&�e[�D��M!D����U�~g['�Ja4Y��	Nr-���/C�@L"5�
��f��I�-07M�9j�_�{���n�h��~}د>��C�+���63�]�I�=�"NbSh�kd
�]-fN��v�Cr|7`�Ъ��*6���    b�3K�k��V��x��c���*�f�����:bx�e�Nn���̋F���.�f�#X0���;����l�`~Խ����imS��c���~2h�:Cg��ɜ�X8��S�U��|��M	�r�p	UG��Aj��	��Ӡ�H��ԝ꼃]uƱB��5[t�N�6�}�h��K�4w��-񴆬�)iAܐ�� ���M��*U�Z���-���X"�~1Q�[ޑ�W�nIݘ�;6:�IV�8�I*���
]���&%O�����XJ�é�����6.M��HT��p�������N���eG�NS����fhǆ�K�r�ب��k(�	�r��u-Rc�0�ʇ�hj����B�/SӰ����&dy=���,� b�Ok��� 6n����Y���Rcjq`P薚-`1i�u��,����3�T�o�`Tvcܖ�[�v7l\��7!�8R%������f躑��H�v�6a3TR4Ee1�8؍RH��/��N,�^W��>%�\��*v�S��=5���9��j��Ҏ�C�bJ�ҲFo��Ԥ�j�{̔JYi�e� Ӂ1�ؤ�k &��>����,·']�2�6�؃TM��+�S����>�{��m�X�E����.�q2c0��wV��̧i�X�ff#�TM�cR�|~4s���h>�)�{��=��u��o�1lF��c�
�F��8��͊��J:�����R��W@Z���)�Mr���7XF�ym�y�61��]1y�B�	J��K���T)f�d�f���ؽ�%�8�P��]�o��s�1{b��h2���K��j��U��Y��	'��b+��v�sP�ߤA]ow��Z��ALp��^�/��YӬ�a(߮��?����PݣB�R���t���Za�]�����e�s�����mb���R����-m#�@���X�!�(�7�YOe�]ܚ�u;]��He�Bl���V�X
R��\�¶� 7̬3F�Gu�<`�af�A��K m"�Wj�[�=���S���{����P��H:$Fx3ڲ��⃞�{��@a�����9ϡ?`g��G
�S�[�#��0���q�s^<��Qi�28*���M�2�#ɥ�wv�P�2�O�tR�>`��`�":�iӟD/"G�B����z��cvx��n��*zf!��>��N%kT �`i�5`�gc�䥈��fʜ��E����ͥ�T�6�I���cm~M6��W��$}@�RLq�t)v��bY\߳��(	��8`#��,�kV���J6B���'( �ڴb�nO�J��Y..�]���O/G��$uF���2=�e�uf\�"}��77|P�9║=]El��<��!J9洦�t3vDK��!�a��T�Z.�U�.!؄Mu�?��j�3b�庵�Ӗ<[��-vw��菎.�2�Q�V���F�f{���Hh��Z	��}0a5F�H%B}���\��Lk�:��>�95�������6q��ǐ"���s���:@wXZ�����m^�{���o]Kzk\��LqXy���RAL�jp����nw�� � ��ҝ��ƛƂ�����b���dRdT�t=�� v�z���S�󖊀��/�e���S��[L=P�(��4����,+6T�(�X>h��U��"KO��	�I*b[��9���1��yߤ:Y�}�2�o��4���&�RR����1�
Iמ\��z��-H].nc�=��G�dZ����U\��J�M�X;ޡ�T���RN�ۊ�A�c>���Gu4J�TK�
��ҝ���V:-7�x@���!&M�t��M�=h�-f������v%�c!6%��R�aY�w�&�Rm�L�?�2��{S��|�]�2uT�C����Em��L�K�nLMvb��P��R$I�Z���I~�ͤ��Z��ʗ��Td4��er�gܭj��6�~��>�}1XL����p�	>����;~�(l]�{P��e�SI�jr��Mx�l�-�j�`>�j�I������X��Ą�*`Y�*�"o��cb�s/c���� 	XF>l����<�b�3E�ײVP~��@؟h;J���by(<�f��oãSy��Ske�����?G�'S�w��J7ܨnH}��p�n���S�h�����Y�\�be��d��P��]�+�LVgjqœ��e\'�'���ZAl&|�iv��RP$W��h,�jÿ6��}���]֕t		��pH8���^��4�e+��l�)���u�����]P�������<��m����������Y�W13���{�7�i
����yA3b{E�|n��P��[�I%���}�Ex��Ċ����(/�y�Rm�U�Ė�F栈&cPO-�u�ċ��՜����|���شE��t
�D�-�1�qP�z%/q� 1�ڂ�y�L��N��N�%LR� �R���<��F�Tc��~�|��;��,Z����?F1��d�U���F�_�Y�׿�����B]T�pE^^�p�� �� �t��1I�������Aр+	��EG�< �} "`���#� ����� �IP08EK��s���S����1��Ԓ^^���?�V�M쪞&U����k5Xϛ"�K2��+lJ�b.}�oҔߴef��E=b7oZ��2tR��Ζ KJ�&�zE|J��8��.i�� #}�i0L�햷\?����@��<M�3M�`?���s�C�!M�X�l�dt9�DM%�o�[�`�F
�iuzQ�V��X�X�߭|Bo�l��C"����V��?�K�yX��aEo~�4��$3V�ˏ���c��;�v���g�H}����GL8"�-�,�Z�r��`�ɭ|���SF��!��?�Af;5���o�S|L�\[@?gk�b��t�I��e�)?�ȞwJ:7�E������ҤQ����5;Ny~;��L��#6ގ[���ONBK��<,�u|ce���цn�؃�r;�l�m�%X�*��r�c.�Zc
���y�)�q(|<b��_5��%��@wU�>z�d�Ae�����M�4�{�<	}6�ǆMz̛h�x��G�f]��S7�t�"��G��{L5�=�>t)]=��%X�&-���P���`�_����i�F�v�ʋ�m���3le���2)�N���L�K�go�d眠=���KG�Q�,�[�%�GԻA��si��M�\SM��{�x��#V�gcdX������8���w��
�v�X�~�W��;���if�{0��ᝨ�2�>mь�w��MU�ь�{̸k���W������_G�nn�ց�w�X�F��7�qs�""������Gbi��vXu��as��,7�����I�NzGl����^�J�*�]>[&a�|0�l��0�v��T<J�E�=H���;o����J�7�M����tK�ܤ��]}p�(ͭ-��ݯ�diӛ�b�1j=�Og��>Wņ#��03R��{xv�F�󾩦xQ�q���Z�Ȫ�ܿ>��Kl�5�*����YR��D����Dei!6JHܣ6�}�{��x�AL�Ʀ�����}����J%^?gZ#t�č�[�X�.���Z-d9���,�TF}���TM`1�o����p�r�P��Q7��~���m��,iM�٪�#4�|���I-MZQ[��g!}�/:b������~z����ۗ?���,����ӧ߿:�t����Q�z���:���AД�
����#vÎoה�5�c]Vcf���X��o%�"�EҤ�챖#U�&g�c��6����}���O߾�jPwV���uq.�F)g�q�������F��
HZC�ӊC{�W��c.-?�Is��6l*��-͊M�7���i~틾�M:0O�`A[����?*1�B}W(_i�+OE����d?Q�Ki����T�����Y��4F� ��r0m�H��c���諒�'�3�W����T��)�w:��;b3�[�W��C
#�JL�󖗒sյXG逍��/[��^��/G*h��Q`�JQ�vMK����1�=/Ҫa՟p$2�$O��8�X}u�#'���k��d��S-;]Ĉ���ۉ9�g����h��[�7�`.͛ߣY����.����<�.'�*��)qe���88 M  �p��� ��_H��Y�Z[��`��^�˰4n14@Z���~-K��^!63o�����M�]����\����ܚ�?Q���,U������<4eh�L�Sh��x/=Cg��Rǋ��qe

e�z@����c�k�c)��;�_�>��(��/;�H�M�Bcc�.�E�� �}Ĥ�pW���!J�b��¢�0~����8��MT�L]\�����A%�&�K{��=Ji���'喼E�O	WG�Au�s��eW)�ɘHS$9�|������tw�+��qy�L(��-*GN-ɤ��Mq��=�\:��AiP��G����M�l�@��Ny�).џ�y��v`�2����\���\{&�%��|߲��#�A����,����x̒�:�ѿȖ�4�rՋqw��e��%S��s�c�Х��������J��Pۻ���K�8�zM�Z�&⌭�Qe�M[y���g�pm�Y��g�UV`]ש�a�A)8�P���U<^�������LW����"��fB{�,��;���tZ��6��u5T�:���\G���t���+�IoA��ޣ�ފ$Ge5Įd���'�g���7Q�{���Q�o���q���]�n��&fgQO�,�]�8�`�׮�*6m]�庙������\t�u&j̃9E����hr+xESXZ)�Sw�{2���*IsG�����p*���1�x��W�]q��d���ۗ�¿u�ڻtY�.�G3�O���~���`��-k���>�)��|m�GvI��I�!#bWِ�7�[�S��J������Q,t�QG�)���]��h�v�P�F:���|5O�����S�^?!v�Z�U�O��j0��u*h:�j�D;&��>�m�*�ecU>A��jDK�@1���qlI$�<?�kz&]�L��Fع�>;`/���}����?��Sr2t��5�4��4�XY=��/n)��mj�]���/o��?���y���O~����?����^?�/��g�W vVoշs�1J�p8(�ם�Z�FR�TZ�b��[T��&V� 1�0�q�w�ͱO��j����:���=�����,:9z����ygݝN��ʾ��=�{��mZT0�y�g>�����Wl�����~�1aϕXt/|y�T�����7d���Lk�3AF�� "����������_�tm5�����2�b[}�bٺT��kH4���h9M�"�.��2�oG�D�^�B�g~�W�i�ѯ�6�슩I{�t)h4'��=ȹv������[��+Ԙ(�e9��Ҝ�m�uO�рe�܎�������o����޾��W������H��q]�����	�0bzg'0�+�,����ؓ] ���Lec�x*�8`�
�Φ/��T�%d��@��p���
ѯ���A��P;�����i��N�ګ�\f�]p���n�uL�L�үHg!&l�ٳB����u쥢iw*�N��=aۛu�n�RܴvK�J�P\B>��g6K|rC�d�	#��t�E�G��Lf��Z���޸xe<v_�8G~"-�i����g�u�g�Ѵ�B5��թ"_Ȱ�=�{�����_����������h�xw��M���d���76�I��=(��tSuQ�(7��!B���[V�y�\^�y����[�**C���E-�Gj��&��[lrU�bR��>MX�ӓ,�"�]�a7�Y�9�6��i�3��6ň�ܘ�[Tq,���(��i�؆����*#�ǵУ��6x˱M�=�R�v�'~���N�K7��I��`}ށ���1��kP�fW����*E7,����x~�}����9��c"����J���h��~DlC{Om�����8W���@��;��z~<�G[@�0��?(Tt7
,����o�S�?w�;�C��;`ͷ&�s���۠����0�C�+�i�j��R����N�`�P����=���N�����uRXO&� w����r�����y����'gč��ZK~��>�ޚylVw���j	���}���Sy�q&��Pl��ư��1�^=AL-����m�KM]P�͑��:~�~�vo��*���/��fCn��ǟ_D�͸���?��?�?�&�      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
����ۚ#����{~���O ���J"�]j6)�I)Z�4�������z�����p
��!Qܑcb6v4yJ����2�,`���*Ă#[��>�Xأ�vG�*��pY��0b�5��qvd�N����� υ�?>baOeۜ�گc;���!&:i($.��`'Ph*��6*@(�)�S슚�p���sK��������H]���#٘g���kꌱ
c��6���S�7Vy�X�x�^����~S!(�GD�������� ��dQ��;.Tc/�)�		�����"�gWX�d_���Z ���z�����ǃ%�ѡ
��a�k���*��3�=�8o�O�O_�.K��dv�1JT�^�V�u!%��Zr�/Xx�Cy׳VWⒶ�|f)�E�0�):�Y�}�z���[�̠#�$~��84z��A ��6%ۺ)9P.I����H̀$�<���»��K
�3Ҩ��00�l��������w��{	Us�+�&h��%����	k5}��a'�êC϶Gں=�����M��=�V��l���최3�h��OV�j���[7ؒ�?l�.Y����S{+K�%�+AY�n ���k�H⦗�+L"��^(��%�5�x���b�]ȴ����ރh��-��e��i!�"]����=�1m�iR���դ�sv��ņ�Ǖx���2�43�y�\c��޷u�>!YV�3K���T1GXg$���x�8a	tߢ�B8�X,���3�s������J���S��菼	]�ɨ��EUY@���XD�]/ٕrc���WG�]�N/9�.��hE$.Х����⸪��W��_x��(��ma[����Q�@i������w�V�8#��L	esfv�fTC��W���3���+�C���#�P��x,wt1���� ;��]��ʣg��!��N�uwz�V���B/��Hⲻqh�E7א��-��ł�t���s ����Ϸ�H�	�Xo�֜�w�3�\ȵ�Lܕ�M��$q������wXPa�I��欉�5���%��߅܍ݵ�V�"�dI�hآ�(�Xg��Z�.�,b*yR.E̻j�:���F'z��?������KLVe<��?KW�*�bA���Ebv��=p5�AH��Uv�!�4&��u)�.�	���ЁMxIS�<�}�DcQ�*3}�e�D�,/�EU��yrsW�@� �p��N�N_ށ����NtY�8cy��x0*l�h���/'�V�j,j�e(ͭ�˗��E��D#ON�i�d����Ȅ�O��+ߗOV�%��?�'����No>��u߰�"m�e1��������t��".��ο����Hقs�����eV�7��h_�M�T���"v�P]�䤓]r�-�w�X&�V�2V��/i�c,Zo1�Ф.���F�=W�(�p�pE����uQ�;�]���~~�^�m�n�8%i�����z����lK��c��+�3������SA��X8��#��A��������9�t�2�IgMy���'�|��ѭ�7"Y�=G�d��N�    �����? 亀N��,]x����@	����c���
uV�e	�J�ºa�s��r�x��ւ��J��+q1+�aA�F/5Y{6�.[e��~�hj<�"����y����H��?)%rO�sU�}�*���o���"__Kma:�਌����s�1��,���&�L���sЄ��.2VW@f��$����̻l�E�G[o��4�#-�u���	e
��~q	����ީ�[JT����˭6&58��J�)�<E�K�# DΪ�Z�V�=�Tv���v.�钠BgW�,���7�%,)6\>	������˲#�ď�f���.�Hn�=K�3�c�G�YZ���惒%V�aςI.fJ��\���z8���$Ys��&��k���H���p��u�h
�<ró�T~'uσY�(�)��<K��@wX֣G]�#&;,1���"���i��;�ɍ[�z�H��Q�N��I� �y��<Ӽ��۩�`W �,I���jX	J�z)7*:��9TN7G��j��%P+�a$�܊}K%.�;�(P#NJ�@�C�<�or��[	���d�&�L���b����݄δ��9+���B��O�aO�B0�H� �)��c6�
�f;	�����$�򘅐����@-\�#0tEC.���8�������H�2`cb�=���&���ۇ�Ed�0��cG,�fL�e�,ޱL��`�0��V�M�Pd#)�g;	�����wxŗ�R79�J���o�T^B�� J�Y#����AY7�������~��۞�N_&f%��Q�Jʀ6-i��$�;��`�)la�����*���3O��� ��&b�������sVt��nWv��yL���V�J�7���;�x=aI��u��Og|��}PP��e~Y����Q�$.;���z���â���#�ޛ��#���;�ܔ��~�B%�=�c$JlF��V��������� z$0Ab�c�\�Y�d�Z��g*g����������{�i﬊F2�������Ě;��ᯇ����H����DØ�`��c5V��b�7 �\h�Z��[�~(N%.�������J4/A���������t��I4���+�<�O�@&��1`���X�v��ƃ1GQ>�6�q1h�����Ѹc������&&�}��v>�\�a��m��_Z�����~��Hpl������ΏY����L�YҬ)`�&�����O�K��$��,���u���r9�wY޹�W����/�!����;��/��7`qe�*���@%�]�z%�k���ԉ�׊�2F�Y�Y�oC�(~��2si���wqY�Ϸ���ʢ,��`);�/�t�A��][�6=�i���A+xa��x17g�9� �gq�.�߃�����[�?�}�H\��.��[Sm�&���|�v��+�v8Zl x1�pX��ۚଵz6p�S9��"���O�JFC����N���@�F8�d��y�N~mC�s�s������ɐ%0�8�kP8^2 �UIѴ4רͼ�-���A�W畢�d�J;dN"'p`��\�F����7M'���n���q����~Ȥ9[��7ݢ�� �_�L+��s̴2;,�/�?�U�� �`��5�M�Um�	���7�nHs���6���xW���/켉J#M��m�d��y�m��k�|�L�(�k#g�&��o/�~r�A<��U�Oڅ�p^d�l�fbk�������4�� Q��&���z�ެ0Ռzぁb�M�j�I�~n��i�j`�X�ݲ�����ҁ?#S�и,I�����5�'$8�E�i�[Q��Ui�e\(�<W+<�;�`/�\�1����1���˵6��7��qB[��__�Z��U���׫}"	�2Ny�`l��Cj�쭆�E��9�e���\��>!��%8�)�a;�]h�1�� ��p���Kw�504����1js��w��"}��7�
�w�.�'l�x�S�]茊2K���O�t�;��I\���V��P�饕�����B�!w�P�.�����|��u��<���,�X���d9lI6� ��i�JD`�eQN7l�2�Q4� `�*�\�Bo �rc�淕�/��R�{�un��Bb/$ea�|U>��E�J�	)=�$qɍ=��I	��T/��h�b����_&'-��`�j~4 X�~�]I��]�U^c`��e񪵏�~�d��g�-�ˉ�te�$���nοM�ߑŇ@���qvҫ.k1�x�T��o����;;$<���P��;�~�5�����XzhO2�HH�VE�d�Tj��E|��|_H�]�1.��D[�Xſp��j�{�����`������X@��BJ��ۢ�e���E�㤞j:�1?��+�K�����f(8�`�:���;���Xn�hi�
�B���Wҋ�i�5(���B� ��$�e�-���O����+E����G�`��oЍ8ۮ�e��x,H^���`�\z��~�C���e�h�2M�͐k����21�x����"~�$N�lW���#�tH+d[5�Y���אs)ⴹ&tH��M��<Æ�ü��`z��LM��἖".j����X�ߌvH
����$�䚻�;�-vw�!�_�ys#��~�qd'�{�]�u�e15�Z�pc�$�����N�ҵ�)�g��<t�
#���7P��b�q^�C$س�y�%(�Y�����L��>OΕL�ݕ�9s�w,qU�\=vH����7k��I����Hqɳ"�X�������'�8I{S�Du����*ʷX�9w�|&�B_���Q̕QH?�>��H��!�-:�@��B�e�j��/�oZ,���%�ӧ�x��˿���i��ZK謥Y�&�`��/��xV�{��'�.1c�xo�B<��������~zFqV���㼡�7�72kEc5�Y����启,�1���f�����ʋƍ1z��E��):,3cI�����K@$�4"������u�FZO��\�2˽�)^M�k-�3b�+�-VXj�\�g3;������5�����u�(����Q~�ڙ�E	*�:h3=k3ug3��+�ڳ#٧��[͛:�G�̚�"q�r�1x6��m�O.1m�L���t4�K�X��2Q+y �c�B���c�ւ��HM[�s�����ݽ<?��6���f �����^w6߉�L�J���#���_�X\)��r�m�>�e�d���v���.n�9���^������͛�8FR4Y�����t�e�羫���e�}��[��!T�i�_��a�J�f*�rYU|+=e���mW[]�k0�Pp��7���l��7��/���w:���4ra�bE�߶�
F[��Ic\���J�=�޶��\�h��V��o�,w�OGPTآ�+�������H��'�w+�J�W.���ey��p�=֬x���_�%�4aC�(a5e/' 4��Z �Y��1PZl %-v��5 �o1&�k���LiE�����7�'�P�<��GhV��|{�?q�G;��*~3�F)�am�>ը�Y�Y���:a;Z�`D��y���Fr��(`��B��ZI�4�率��xެ�鋠X���,�լ8c9��4��O"�8���G�7[��C�����q��7��'�]͊�&�z�y��ؿ����F)����0����RF]VEM�H�9V�����۟�*�J@�RZ/Aa��ȵ(ˊ��vegIIY�aP4:G*n0�H@�������Rؕ��N3s�CM(z(J��-?��GY���&���"�F��0XH�X�<��Ғ:),��?���ykT����;%=A��ɛ&���$A͊˪|<�S�ˇ�W�l���`8W?�C��+������z9(~�g�����e���qS�4H3P�{��1������S(D���-�� ����ώ=���ai�A�"3�M)/�I<L�f�K������P�䳁qh���B,/La���C��1�I\����c�1q+x���4s�� i�k�B��\�w�Q�    w[V�n!�u�pՎt�K+"s�����5(�oAEOT����~���U�IO� �sldN�".Z��p��K���m���6���x˪�����j�Q]�c�.s $q^��G��@A�]�(#1vlS��R�_��26Д��\V��#SW%
;E�J�A���%��隀!���)\�o@��fc�HS�0,�&KC'�vW�FӮ����l�+Jg$O�O_N�@����k��?%e.�&L�,v���.�>F���bE\��yPI��*�c��%���)PLż��E��k�cKm�GZ.��kf2�^�2��]��CY��\��L$����R��;	�4i?<��^�/�`4����ܷ��,w��J��(���筎2f���r�Q��vH"H�2���M]���)G٘���h�8�����,eiQ� ����C��N����\�dV`���g�f����"����C�y�L���b��|�N�]2"Z�i���G?&X�֟��d���%���YXK%,��\��h��̃eG�rt�Lp�.8 ��u ��A����e�p��z����bJ�+U=��?q �
��N�����'(����윰 ͑r����e����}�B�".�;�nǂ]q�rF��$��e�u��2�bX��S2E�w�������ۧ#@��^�K���rݥ��K.�W�qi�_$��Qm	
wy�����V���R�ז�@�����:0]X�ł��/H��w3�x�'�a�Li:$�����Yz�N��g$�,>2(��zZ��iA�c{*��T�R�IM�̗UH�Ѭ8Cyb� v �&�:����	��]n=��k_'��#��AO��x2�q�ю#n.�ii@��ۿd��Y�����V:%� I� �@p�q���%j�c�b��~9���$������V\\�o'�]pOD�Fm�Zg0�d;��.���2��Pӝ�⼻~x|��a(F����D���4���*� �[�����Rp���X�G,I\n���F����V�*/0	��զ����;����)����jL�kH�7�D��ʈ�5�5�K�o�qpz%rzf%q�o�񊒀h@r4oќ8֜(�����ſRlhʪ�>�������y����(��Y�X7nqX*�/��'�	�=��uHv�n��8h���cl��ѳZb�HE.IU������=�û8o�ϟN��.	��':�ѱw��އ�e����M.�������~t��1�?,��k����;���%��i3�}my���4�Oh�D6gH�ٵ��ڬ�.e^��fS���u[qI�;}z�)�x42Z 4��5��1�8�b��%L����*H8�䒨R����1c6��ar�8[,�i��Qo�8R�g�z���^\�	)�6)ל˳���� ��>�%����	�k�|�_��l�N�f�_���Ќ�l�%1w�_(�}lu�b+��*��ه�Y�-������â�&��3I���{g�M���u�ޗrU�����J�*�e�eY(��̣ܡ$&Q�#Ua�1�zcV��:(�7��'c,��(��|�"���ğ��L�>�ω��T�ol�j/I�Y���d�\ji�L2�i����]\�.��Ҭ�͚`�`l�[�m8��;�L�d4p}��K�"]��H��6�
��`����+��8���O�V�D��L��������W` ꋣ:��Aa;�9(���{��:m�\z��{�:0�)���Z4l���x��aA�m��l;�2��	��~�~J��(P�����q��z�uI^D�����c'���+Bt���1ɇ�Y^�m�Ju���rJ�A��=Ƶ�R~����"4Lo�ZI��/��@�R�)�T��΢�˻`�ޕH&7ũ���U�yE^A�V�@K�:Ŧq�m���l8*CHݵqa�y�!A��q貰����r;XD2��O��I\����H����INu�w�>
����n����K�!{wG�jls+Q����|g�k1�*{t9YCq��ʉ��Îd<��B�Ϫ<���aD��EQ�l}}4���\�Qn"d%!�+���&��#����8dfGqx��w���e�.X2�#q�Z��9������燛���O����}��h�`M�E��J)����'ܪ���1��B�xP����/���?�����?���
q�G�X;�sN#�:ZW��hr���	��[�A��e�w��;k)v�9ok�mO/����2*���'q��: �E�7�5�d��k +*��\�g��8`�.N/����J���Ԙ>J핒��+�W�ŕ}S��r�p|��4W_D�M)+��lfȺ���Z�J�yU� Q�%�,6�+�fiE����V���*��Qxa�=z����5(�7(�
�x�$s�f�hV���1{3\���Wԕ#%�;݁1W�/5����P V���zL@jG%R�D0l���VM�ܝ�)��M�..y/����`VInNG���e��5)T���,0%�*�����U�������4A��B\�����X$�Eb�\F���S 5���Kfur�{��fc4��,���uP`�.*��#���C)⼽~>=�nSӇV~z��$;�5�&抪��*P�e�*@�q,E������q�,�xQ�^��ea��7Zp�˩{������o0Y�~����
^C�M{a1)���7�ɟ��2;�h2Ѹ��������w������tU͘�1�r��Xs�e�,83�J,�]ziK�\[���{:�v⮇ 7|����+����{+���2`~�ǔ��L�	I�K�jO��G}�v'x�a�ve29���U��k�9��QB[�~I�%�f{)��)o8����J\���Lr�bhF�F�@.��-���`!G�X��Efs��BR'R�iP��=@�&��8dyU�0X�ȡ	C�R�yw}�qo@n=�y��HJ���!�)I��5e0�b1�5��R�%;1�a�����o	.���k'!���u�5FC�yE�]7̄��]�-�ׄ�$!K�Ժ{�	�Ĥ8���A鋸(
�t���c<�%�9L�t�kⴤ2���R��	�}F0��E�w׏���ŧ+$l 2�%�¸&]4l��/�������z��KU�(���z,�����Cr�&-��V���4�C����X�!�.5bC��D�]���8���19��ys�� �S�6c��]��V��೵R��fy�H�x����p;���Ϧ1����7x4��[w�/l���W�/ʩ�y{�~��V�f��N��#廹�F�r9%�@�|/�kͬ�V���������ܱ ��X�r�\�����fS@L���o���찇�_Χ���}@Zk����s��W������(���2
CaĴ򋞫�r��M��7+�ܧ�����W����ظu��&�і�u�4k�f�&�3�5��V'Föl3�o3��1G���#�$.pn�#�|�d�>�K"nz)qn��$VJ^���*�\����I�ja&{LaL�M#Q �I��8+�K��,�+�J�s'2=Gv�6\��YYn8��IbGS�����*q�%����ů��_�y�]�D%��5$�
i��s���F\/�}�;�ˏ� ���fc�������)�2?=~����G��(h�jوz��ev�*��I�-�����S.�8��O�_yg_Q2�l �Qz]ө,:,Yp��KU�7Is~߁k���08���+�&���Y����"���iv*q�c�Xp�禽���-��O"����E�ҙ�ʜ���O�k�e)��+��L�`c���3���%F�
	�f�k$\�E��0�R�%�t��.��3C��01���� o�K�0�S%9 )�$/O�+���Y6l�t"����NQ��P&�B�%�˚�ń�O\�a l��2,�jZ1����T��,���o�"$X;�E8���~]��>(�ºR0�.��뢿�ߟY]n�/�M$�jփ��#W#M4͢�u��G��9��S���]^��#����<c��bc:M���Y�j8(���    ��:�	
�����Q��Mˉ��[�MK�;(Y0����KeF��*��@��nr;�y���踿�����Er��r��Ĕ�O�"������+oI��"Ñ�q{W�G,5�x�����2{4D�I��)V�ŴDǅ�W%DHFc�����.��PK���bE���bc���N<��+.�䯷�s,F`�E�%,�����"��d_.�&N̓�H\*q�r~�����.P�& �K�^�N��
+08��Z(/,O��$q�rϒ��mB��D���H�L(��o0�g%��xTLU��o2c/�*(l�tzgGq� �]b�����
�h]�;B�h��R��^k��c��9����v{1�Ċ҃�R�w��Z�
e'l�
ʰ��=T��[��ɛ6��]:l��X]��'���L�,K_r�lf/!��E"Y+p���1�BY���P&���� *��$� 3�
�G9M�����Z�7ʑs�t�?�wqq�&�0@fk�!��xxq��pЬHW��^����j%.��I�'�]���v>4+�Z�*��I��<�5V\\���0���ͳ�&Ϫ�t�ף�1��^��8|����N8��ms�~��=[I!Eo��j�r9�y ��a�XE��G��͘�	2V����o�Q�Wg��P]Ɣ�lZ*�j���q^���9�S4ip�拁�=��5)�:U5�O�k��x_�S?�M�Ǘs��.�ؿ#`�\�,ܭW�N�gЫ���`%��Et��Ƙ�1�EI�c/��1�Ϣ���kL�
��as���̷9`:���0�i-�=��{V�@e���S��TH�5YU�cr�&X�kRį��D #����B.)��^��+��_L/V ����".~��W/��\��4�ؒ0Y�����v4� ��s"]n�F�xG�u2r�>�N7vGI"f��t5$f]�]t5֗[z�u?���^!f��i<�0�P�V�1�u̻��� � R��Fn,yyϷn�o%�o����|2�*����r��nY޼�R7l�*^�\��q�G0��㮷��0��e����lY2����=�\���ºÕvU� 9�dz�G7������W��� ��4Ҵ�]�W|�A�fT�ս�����^U�=�eY!��e��:�E�eeY(�8�-�u�a=J��/�{��:I}�L�K�.�^��t�72�k*�@��`+�aJ�5��`5.S���P�� ���C�������a�],� t+�NV`�DX9PG0E���N��^� �����1��XBk,�X�rѯT��s<�".Wy�;�p�|A����)�U����V�J�N�QC_�R��E�k������b!������|��ݏ�����~x�o	K.��w�e�4���YV�y�}�}z�aIC��v<�,�À�e����L�߭�3�1�Xg$Ϸ7��>��Q�=��Z���]	e�����8(K�����-o+P���;��-�<[Cq�f�� ��=�2�Ig$�o/C��YP�$��X�E�n{��Z}7C��Ov8��8o��ۯ�fF?����}�/��HW�bٓ������迀ǚc�Ư���.����(j^=�6��d���+v��� @�%�7!U늩��{I���IO�!ׂ1����}>ݧ��Q{C�xj�N)���i�)˺#����un67}<���������gH��o�{��T��"ye��W��%dl��S���}���B8�ߤ��1��hQ������#Ҷ�\����8�_O�O<(�A�=�A��l���
Wǉ�ֹ���c���-.�i�1�^�;���ܖ"�P>�>=�,N�Z�e�*V)^�|D(��/^��w^�[,��q>�������ym��%���{A����Q|���H}�qM�fp���X�o�,{A��l�0n�DT���G�`UULi,��*+Xa0�E\����_fƞ���XS�"/�
練�2�ƴ�G��*8�+l�H��c�oѝ��ъ9��ԹG@'XW)��	�-��y��w\�$�g��yp�G3K妥O�=7�'B��rN?��d�P�,K���������F@��*�*��|;�E�2�	V�ܦk@�ҘS
�m����[�\w��[<�3��n�+�~{ϳ;hj�T1���k�v�Iӭ�\,έ�Ln&<Q0{
T�m� �q6(���iU�ƨ���^���~l�חb�Y&����k@a�@��<\``�G��%��d��:,1�w�3BIⲷ~=��N�4�ň@H��R�,Hם°���8c��M�a�S���z:���(��"M�N��XZ#�f�U�6]���J���F(����v�9�"�&���|Y��R�Me���a���.V�Vw&��(a��$q����Vչ�'�*��KJ��E�6��t�5�+N��M����������+E#WG��4>���~v��7����L)x5!LM�KG���(]fJGZ�#�3KZ�!3B�!c�[d�
d�G6�;�H��S��j����!���p���[�l�z(�N7"9���	��H%Y5r��V/^��0�>2�@���+�~vw������f��t"�}���4xP/���Mf�INo���4+�~ҷN����hs���(�]�ɣ"�n�%(�F��38'������$�&w=E�c���0Yq�� ke$(1�� |�s8
�4k:�6}�U%Κ����1�z9�H�M����^tH�D����2� �V-�iQ��`�x�%ߝ���)7�a�҂A,�V�6��ʷ
���F����,F��(�N;bQ5��n����z)Lf��X�+q^����=�3�J"x�޳͟�wz��=o(�udY�Ml_�V�K�|����s��7�o�i�� �E�;��,�曪Xd���\���q��O_N3I�ڸ���)��Uq��D�U�����J����bRc�v����x��aX���UX�t�m��u�7��j�s�G���\�"�x�+l.&!��U05�ӽus�/H��F�Ҁ���R�ڂ�aM�O�V�9(r�t[�x��^��H��*_�m�2tR-&-+,,�kziGI���$-_ǢĦ���)�u[B綨ŋc�S³lZ�x`E��ܟ�~����Q�f��U��և��۰~�H��kze��U�	[)�� _���Ƚ��fVt�&v�q�\.���&߸�aq֕��6C\0t��(�@��+��b�a�ˎ�7���w%�KrDQ���4]Fq���*TAB�U ��O�Ib2�"�@���g6�',x56����e��h�2���&�XЮĨ�{����a�}����G�"�وds|���#����+��\�D9`�{y�F4�*�k�c��� �Uz�v�/v��e2ü�qrw�3`��7�D4�ˉC�Ê'�^l��_MΉ�sIs�UI��m���.V��@��K�r-��Z�{�@Y��V�/6u\�w�T�8����4���la��b�XA�J�Z�S�*
��Y]؁��H\�h��fA�V^-R��W�7�9���0�8��vzx�/l@��yh�S8�C�݅ � �$ގd����Y�$�;�I�h�xGy�mc�$���W`&Sy�={�ٸ:(��x��R��;��@b��xr4��	�ML����}Y&�|����,�N�8�O@��Xo`���)\�d����0��R������[�����y�)�����7��-�!_RD�'Ѥ�� ]��ʹc2����o��0��]\����,�}���	�����@�2�CQ�^�9����t�|W�R��e������+@�ޔ��pQ��B�.֋�"��5L��t�*=bI����pf��	�F��b�%=�Ǭ'	�'��s�,|�����y�����6�5,��,�$N�>������B�b��"_r���ATmݪ�YUîN[�{��u�ha��B�-6�)�q�Ɖ��c����D'0_[�ڰ��U��1�'�����R�#�3���@��bqY��-J�m�͍�]�d%�/��|��������y
Ku�iA�PZ    ִ��R�⬩K�K�����]%.sNt[c{tc�fh*Gr��+݀����VzΦ����(��/�Pa~<?�6�TJ�MZ��++���+�%*���D���P_i�`�I�.U��?P�����ꌼ��K/IX�D�X�r���s(�TZ�dC�a۽�n��뢯�dj��K/����J\6���O��� ����!���M`�ɮZ�y ��z7Q����Å�hb��K�El�^_�����Udz�����������tah�^���.���F_0�^]��dY0���".{�.dӅ!,&lJ(I5al�h�Vfq�L�fb�S�������?��� ��N�@FƳ*�[�Y�q`s΁���U����r.�3,�[�E�8H�#���:�������8�rP�"�c�'�RӖ�v��σ2��4�aP�5(��ŲHXX?F���ݑ����݆6��c)�|���'�a��`��&�Ȓ��v0���"f��wS#����|ώ2Muf\]W�ܝ���|[�,ͦ�˺����)s�m��%��Y��<�ͥ�]�^%�{�~2e�~,�c��H�}��&�@Fe1L��:�7a4M\W�C�g"���X��WV���J�_�!��%��*p��ĵ��E1�-��fUc7���R��J��a�>��ay:ݝ��DS�!?ƕ��[[���j���4@�oV**�d�����-''���k�j���3�Ϸ7Өo���3�i��b��4�V�'��xbY4�ֈ!�/�bY��u
D����?O[�#L�����0U��}`ihU��i�c�J����0oa�NmX�"ΫR��gCپ-���)v\���b�^�f�ǨVg�)�8�y>%.�48�i\���l`\�F]�f�PA���".a���� ���hт=�]s(�UZj����cz�BO�\��ʤ�����W��SY ��:>Ƹfv�I��-��TR{�R� F������-X_��#6���R����%:>��d��;�bV�W{��l�$-��u���^�xf	j��n)+q�%=qW��*xv�i�^�d���W8L$����8&��X28��*ʉ}�=�$��� w�f�
�ua���X23+��<Ĕ2f�>�b�]�%,3�>�Ǟ����7�k} ���&�/��]QV�=d�,��CXl68�7a�����@��Zl�Hya�h��\�qD3o�qX����h�4�I��!��	���#߆�p����r	:j��b=���%}��KE �-+��!�W�݄�s�u�\�x�+�P}N�@�=�]\���mt$g�0��a�ѷB�K+�,��,�8o�8��]Z�%wgD��m�8+���o|��74V�8���f���3p�Z��]C�t�Q�s��%+q1�A�識 �}���`}��tXy!�CZ^�UD]@�S�6�@��7C�4W�ߧw���D%~�꘸:A)����	��'�cIz'3�iq序Y�$�P�D��~�oYe�%�,y�� C��a�����`�]Ot^��Q�
�����4ۚukN\��nOw�I`�b����H��D�|Meh�5NcAǅ�	�x̨�H�xŚ�9R�_JV���k(�2��`rR�����Ś�O�X�юH�yׁ[�K�)��fU�FM�����u��%��� =��1���6���=[[Uw�uYL�`��t������Y����ɀU��^��T�a�FS�^h8��Ȥ�$�F��T���j��5����;=W=9B%�/ f��7�G��g�E�T���A�J4��Z%v��L�K
�4w�8ﴇ�� Q~3�S�f'h)��LXls������8cM�I�������`F�
"Au� �Jvl�����,6K?��6���n%������T������Ջe����\��A��r-Ʌ�Ġ9ނr��i��B�����V��c�ķ�'Vė��9lo��idHM8?LI�Yw)6����xtq^�)���l��Lk���d4)����zbȞ¦��8�P��yJt��\/�����#yh�d��+|=^E�W�$ў�8kv���{lq�w�q�=��	�܅y�����Z��!��ܮ�X2B�ݮ��"`��f����#�eM1�j]z���	+�!��Hcz���BAwx��x�b�����땸��ӄ�%a��qЖ��hv��vU���淪�E\?Ȭ���7N^�(#-e[��O%M��a����]R!�"��j6Cՠw3w��,9�೽�Jv��*��8�&q����!sT��ϓ��ťl�W�zl��Rm��V9(]��9p"-��<�"޷�牞X�E�MJ���@��l
$a��+����5I�RK����ώt�r* �f�j\HwE��J���Fm�{&*�
�Ժ.��`-{�v��7R��
�� �����﵋!#�;�-�T2�N��Vdf�-2O��.q9��:���i/m-�OAp���\����,CԷ�"ޝ��osBs��fQ{�~�lW�s�8n.�������,�X����:�Y�Z�Q��(�pЄ��Qb����d����m��@wl���m�K���}��5��wOW@-!B%.F�e҃�;A�p���t$[\�t�����j8�Kϱ���X��,����*���v���x!VOt�'����D�p�/Ω�YOnx~�D��N		��F���ۺE=	پϮ�����+q{[��H�	+�Z՞=�us��q�Wb�Pʽ��XӘ幚$�L�#Y0�b�U��R+W��W|��Z�(��^Y�6k��\l:B�����Bo�5�{����
�ťF$I\|�o�_G� �Z������bo�LsÅcA���0�3���庈�I�r�p����l�2M��<�e��yP�H�Dc�6�񗙎���H�V`w��]b���]�&gVz�UV⼫n�_X�6�d��߬�&-";!G���4�p�W8&0��pȪ����4I8�@@�S24[��Lc�ӫɺ}�¤"OMwr��J�"���[�uR���ya��ueZŬ6�%(���[�7�"�~Q�8C)�̢S=6�e��F�m�4�� �<���{�/���%t��HD.�~W��B�ף����a�Uݗl|����'<�~sB��
lZŶ	"'���֧�<���W�X���~��Ag�M�xQ@���o0F�r���vr��'�Ho�t�m^�i7��HV����=�=��g���7l��[���8�/t������������l=ܴ�)��e�ʊ}Vr�ޱ,ؗ�4p�`��a+�U]YL�`�)<�&u��0�o��J����Is�GcLo�H�n�����X�i��%g���>���,%.a	���%_yd�0� U¡5Y,��_젱�^D�|�@��8�_^>=s��>�U��k�*���֪R�a�Fi{��ڴ��
�󻅷���\�Ys��0���7av������z/�v���"��,�9�V����`�b괛*�
��S����xeo�ĮO�畮B�2#��)���a3/��������SKR��p��RftD���(v�Ӕ�ƭvn���x�K�x�]��,�^z ��%Cy��yf/��gg�F��Q���z�L���f[�K�~�_%.G�/i����H����a;
T0��,���r�>? �2=�".�r��i���^Ӳ�ɋz
�O�����K&Y���Xg�~�k9`Ж"�;��NsP,�8��`:��X��;�)��> ��^:�k���찯�l���Fm.:YF.8dKt��C��ѡ2���v��&B�-����b;=T��	�n*�蒙C�M����J\����'���P�R��a{=Th�d�V2�cqdW��CP���;<O\Hٶ�E�(��ƠE�����f�OT�/MOoZ�3��ǔy���Ԧ�%:FsFE�.���.��s��U�r���<;�	�q��H�V�;��hN/,I�bU�]�m_�]�K�u�(4O�Nj��1�-E�(W(�?bjLPx*p���`^#P]��2.lѢ[�b]^�(CￗcS%�O'�    �ИD�?[��e{�-Η��d���=�".~�����M�&c,�~ih�/�����8�*i6������z��)i�<���D,���h�n0��2���I9��Rsf���YU~�����%4��c �6���*>m�k�����m_�]��(�4c9*hL\����٢I�;��ڽw�fb'��˨*q�f__~�ezS<�H6�"W�Πa���pHk���~�\%�b�4�n����g��t]��h�^��>��Y��Ěg+.���\��=Z���nUÒ��<g �bd\C�6=�.1BI������W�j:dft�7�V��aզ���h��\�UK4��蹦��m.��w�l̅a�r��A��wb���5�|�_���RC�.�FrF��N�c$4b�)'-�
[���2]�c���j��lfy>B)����ק3k5	�	�MƱטgi͵n�e�����/����/����G��*�k��N�T:V�U�����a�
m ���ο�W�	Nnڴ��-o�uyk@7fYO��K(��]�����6�����G����kSTkS��k.r:$�c
�/���y\U�?G�i�$�����^��gKB�nެ$U�Dߩu�HfIlU�s�yfu㫴4��-��u!%Y��t��y:(I_�z�(�E�2ô&l�R���ZV^i���Q�p�S���_���@�3�M��1�O�x��ȵ�ɐ���&X��$ޕ��l�YT{L�C��vfؒv]���o[�e&$�̀��
��Y���9<�2y>���5�Lz�-�ֺ=����pɁ�!X�8#�$.�2!>(P�mV:�b1lݱ֝[�:�>T������pp�����_�����_�`qT�-}>��������J�j�]Dr��E\����ϔ~a���Is�콡�/Ϻ��q�O�j0�=f�qj8������#�@��$�u��z.��Y�a��L6��h4������ӗI΢��ns"��?K�M��^��p&�]��Ag���yH�S4Ǘ�kʰ�����z�b�J�B��e6Z�2s,	����ə[��Mca�.��+�鍉�uR�ޤ�%�[��A���}�,]�v�Af���;^��ϱ".9�۟�����%����Ew̲\�ڵۋ��-��k��1�	�J|��o3�h�'lV@V+Y��u�%�4+ɽ
�̵�D�,�
]�&��!_�H�0�	$�rkߞar��I�'�%�M4=�"�䏞Y���yj�_9�-.k^\g^((MGo��\-�L�=Y�L�9��???�Q�\�#0�¸θ`�R�Pﱉ�{����=�v�7��6ZJAC>�d2�d�
���Ov��d�Kg,w�O����M8�mS�Fj��Z�XI���`�oz.{
�J�w����qBB��nJQ�~|	��K(]kHȝF���Pp��&��˂g����{��Z\�p�%J/�)E�'��G��\�H0e���rw8��E�b�ǒ�ݦ��������au�}�8�3�}�����,|�A���Xz���TzV�a~���x��X�*5IM�M���	�D-��\�ܜOO�̪��^׀e��*�Q\� ��ն��o��Ko�Y#M�\%��O?V�;5��Ւ�c�\���'���U%<��C��₃u�$u�11�H�Qaٿu���Vdͨ�W�6����3H������ ��"��4�t�u��j�F��ݕ.'^~^5�"1`�z����Cm��[̈�]QV(jFE�j<0+��U�=QTb�x6�T��& k��Ɠ���3�ϧ���(��Ȟ
u�,$�ЋN�ߎ;c6��'��2��]k�1��E��Ǜawq	!�?~�iJ����+�(�g鵌j������oj��s�[KQėp���e�?��&��^	�V蚪B7-E��_9C�Y0�����n$j�~�r���H��Hy	�-k5·P�X���4���-�C�Pl�&ysz���=��݆�	w#a�rЄeY�/X����W-.;lïLDc�#�I��
�bl��Ь��7�R�>q"u���h�8�������� �9|K�/�Y���_��i�
�f�אּ w���:�o/__�P�LcP�"G�h�TD�iU̲��da�9֤3PBM����o��hp+o�bղ�F6�-�^�׋H��`�8�^����1H1�cyM��ϱu,���RQZ�K�q�?�[��*��lٱ��A���'�[K�'.��SJ�L� ���[cٲc��"�_.a��Zu"�x?�ӝ�-6�e< �P���K������}8ʊx��?^�a1^cK�e+�ta��c�˖�*����ȗ'2�h �> ]�e�����bIU��)ɯ�ԘW2aUc����H�z�`�T6�6k����]k�v��ځ9��8��酟ᛱP=h�c��в� Le�l��2]��$q������1�z�0���@k����Z0uU~kǸ�E\n��'�";d��1��4� ] �V���� ��g��"�`����}v�N)O�Ϻ й n�1��cJ�K�#I4$�c�Ow�����`����� �� ���8C=��x����t �3镡�a��j�]����,�w����H�:�х�5���&��C�T�Mh	8�ŲMF5�}ǲL�2K1ː/�r	v��rd210�����x���ʬ�ď�_��x@4�ߵx�fe���'iT�V�Q�-�5��2b��%C9�Os�$EU՟Nl�N�(ҝob @X�-f�-�ȫ�_�'-'~Y �p�C)�=\fiv�O*��q`h��g�n�d���2�����W`�$q�`7�X9�ͅx��%])�>�'�$��ku��i���r�5]��x��da�΂�,�J�+,G\���
B�4��J �ϖ�ӹ0޼��5}�|��r]�t-�@~{�; �U��Ϫ$U���F7���18h�L�)�5%���W��pʍ;���l]�ѽ�~���QO��@U��$�M�|M$Np��౹Ų���t�>�V��W�(���vĲ���<~���9AD�E$�,{��]�B��Ǟ>P�°�vq	[��P~Y� ܄qTx�v�_L�vj?�_IiUﶬ��DL���	����q��"_�˗yfw˅\�K�[e�d����r�C��ZI�8bml|�"��{�K�M�V�%�x(��%aK�j*2Ԉ��-Hl��r�"���s�%X�~]�N��_@㼭7����Pk*�ڈ��a�Xy̺�ρ�7L�����r�I���ɴ���}XY�E 풴�[�y���vI��L���4��v�5�6H��䂄;�e����`�W�(K�0m.�P�T��t~�Ųy�B�\d/���J(��M�f��Ǟ��.���k�
���xP	Jg��
��@, 1�c�ڍ��]_�������j��0�g�G.4��P��sZm ��u9�i���<*V��L)ڛ�����d{(E���^6��24��m
�^��b맍�,}Xk2ܷ��\��z+�R���Ù:�� �%9�
��ˮm*vm<�`�i����;�!��jH)�_���J�b�&�w��l��e�G(k���%�7��֓8k�C�x��0�I���b��{��֪��d��s��~SL0�R�������İ~�H�~ڄvM��0�SU��.�����ÆH=h}���u¬�>��tg� ��� � ;0�,�AYRY63�)�]Yn��z��{aSu�bp�����x�zj���'2[�fEF����x�Tz#Z٦�*q6.�xR��ɀ� ��ׅU��uY�]�N�	"��2����/o>N�D����C<�"vm�'d�oqT_Iob<�4��%�/�,,��Q�7���e�c+D�,��ε91��Ih�V�y��~�l�47[������)fE{�������3�3Rٱ���ֻ�e�=Po�v���#i�ӜolE�+������.W��Y��z���)�S�P���W5��qE�Pl�V�k(l�(mrѳS��&�L�'�T�%6�P�Y����� �hI��owKT���|�t�t�eZ@�*kA�<c+�8`�%�x% +  ��J��p@C��9�&%��9|~�FG'$q#F$���:r�M�X^������c��eQ^A���Qȅ���p+���;�<��OV���]��rtM^}BtX��x1�ؚp+�W���j�+�d�3��b�%���-g�6�ikޫ���T�N����ǿ���|P����-
����h�m
v��i�=W����y��r���؀�7d:�؂p+]dy�]���h� .� �Hj��8�˱�Zң����V��^�+:�1�L�.ƿ��_�������0 �A]�����l�U��D�.s�+�..���,AA�m�q+[kќt[�Svc���E@ sJSn�}@R|`�5 1��2UL��ԺzE�tE$MȻ���ۢ6#9���օ��ʮ��G��Ãؗ��쇊m�g _���sjt�B�J�.�U��>!uC�h<���dI��RN�P�8o�Y74��0Tx��Ҫ��o]'WEOj�?��p��f���<gW+�k��iv�$��b���9�T�=QJI<(#$���t�b-I���)6���T[�k�\Hu�+�+P1UpT��ڳ˓��5Nu��!@@�\�oy�0����L�fmpp�R�.�l�2K+�.��rQ�>ID;��@�܎+ϳ�4P�JE\��e�/vM ��ry�f�!��F_2:UF������,�&*́�~Aݫ��"OAaM�r5X�8��Y��0�(V��䉥�K@��8�T����������g����	\�X�4dQ2@�8/�!G	� �!aͤj��b~���B��8��Ǒ����i��,�B�&���X�|��a�5���əe�&c8��8㸙�C��Q~s�9] �£7u�zl�pj�vwb�Q�a#�c�p�n�-$u)+ѯ� ��Y��e�t�XE\r^X&y�n�Ɯ�g�m-�a�� .Y��A��)�f�*q����= �T�keAa��������56g�vX(���Y�x�u9�6f��3{��wk��Y�J��a=�ģ�[�|��x~��?}:��`H# XB�׽�Fg�"p��K�w}��7>���s�k�h���Cj(xw����i^9�����t�K�6�jd�b�"���$f�7@����"�.[�bpЏ��EX�A���:�X���2Q��>������c�j�g��1�g)Z�S��+,i�@TD1@pϻ�ˑ*]dM9}��H]�S�����--
���S>F��BBo*���{o[-Y�Co_vq�_73o�	V�bJϳ��։�R5n��?�R���*E�F$
9Z���/�u��_��� E*      \      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��k�$G�d>c�?�#nWw� 2 D!�Y��*��|�"{�-2�;Ҝ~��3L��MM��#-j�)�"�@��Tӻ��*�Z�ѡ�y����r�3ѻ� 0�kd5��(�t�������ԃ�/J;����ԥ��X���;\��X��I��:^�X������#����#�W���x{�l55���w�.��:wɖ�YC����)�,�#^��)���RBĴn�e��;(k�t���)z�1z�c)�xt An�(w!�:�^�H\E�$��g�YhP��@98/͎{b��P9�q��L<,m�# �ef;���������j�����:��A��O"V�#��	�rk���ZqC�O�T���S��4}?�3}W݀%?��6��Áma8�e6�H�ް�El8`|��.�N}�-]Rw���e���`^?>~�B�{�k��5�2�L�tX���m=҄����2��+yaڑ8��H���(����Җ�����W~��|��!����&�2nC
5C'o� /rf�9�g�[�kh<L�;#��ԣ�����R�wmY_��p����e�"85�$�R9r��F�+�Fylo����Tj8̿��5�c��5%ld���^�dӤ��5��}j8��' ���۷h����t�I�ל7l������te��P�]��s�� ��{7k�4�́a����o��ɠV��j��b8zw�j�%{�p$�t��Br��5���ͼ�wks�#� D�Q�i���/`�2��^�z	�!l��6!l� з�����O_�h[L���[�����yȲ��h�f�^N���'Ʌ}��-ߎ���8�b���B�*�g�אj�Aُ���Jɠ��p��FKS�H�&�Ml���}�{)8O2����V���M�d�YC��1�?�{��-�sV�R
Sm	p�ЌiF��:s��AuG����;�~9]�.j?RZ�����!ʎ��j�P+��W{�^�A?)h��}[�p=Nʷ@�X<:�
&[��^ N��P��6��pڕ]�q�e�uh�xY�=�3h�2Z��	}T��ƫSgv1��%�������>���W���Q�������nm.�N��A�x:��61����rW�׷fT��t��ط�g�!���\+���p���[ 唈�	 ms�����pnҚ.�P�ä9����SH�1hFn��x/�v[I��7����G1A��5��ϴ����!2'z�2���F��^��_M4̶f�m�w���JC���:C�ߗ�����UoKG����.r��@�u�#2^�7�n�^�&5��h�'J�i����Gh�ϲ�d o����ܠMu��ܧ7z��n��{L�AZ���c��3��n���t��F'0�\J	6$f@3�p��`v3��Ę�j�F5L"f���X;�#;%Z%�ۭj#u$}�}����x�������SJ�a�x�T�V�|�O�k�~��T�"R�壊�O�3ǝ�d6��,��Ro��h�l�\�Ҙ�4�n7����b���l�ݳF�,g�s]�	�Z��|�ZSݑ�v����x 6���;�G�ڐYڐ�[w������?A-�"�+>�Ͷ�FԾW�Ncʎ���D�,mv�U�M3ˤ���� �̚��0횭�>����xp���@O��1�~�����?���M�;C��9Jc��j�/�r���Wo��qm��D��n�u�#p9&C3t�Pّ5U�kc���9MT��z���X8��:�U��P�\����(��yX�V;B���W��K�
�d�N�����z��V/��N4l��e���.�g�{��w�Ɗ��Z/��0��i�ga5��K!��Eڬ������h��ğ�倛��8�ȝ��-�Q��@*{I�X,��vzz���"�sc1�N*�÷g�*wL�'"�8���p�*�\]W��l�(������7�D�[I���l��8@k;I�Z��?��KB4��_�X����,�������q#'���q?mVh��r�b�W�2��i]?���V)���rP�ڥjؔU�o��������tf�kR�ظ7x�^&������    ^�3��/D���X�Y��q��1Å�,�En�d1G�};}z��v�����昖1���^�B�N�Z0�b~�,r��k���I�4�w�f1�:fN��Ø*w�Ua �ֺHu�9lv���¤�D��U��O<=��z��j���͵�w�Nn�t����e7��K���8�w��0���9ׁ���/H���X���Ɵ"?��d��U=ɓ��#QH��.2�7���q`�3�<ϒ��a4dzX���I�]�$h�]��pE�D��]��J�MK��YZoäU�	\��q(gק��"�.�y2'���9�+b��Dz����:��T����^H��rQ�kk��U�[S�N"��8�6Ge@��'���<�ъ!��(,xX��ӳ4�����sj��jn������Ta�^,��(�v����I��H������G܉�H�' �if䆗˳�#"�o��T���D�X�G�G^Y`>^�J�Mvb��:�F�@S8��I�up1��j�UV��<��-�V���my���C2NsǕ/ �<D�EGXZ��;*g�Ib�0�т�Y?��n,�O��F�@�NĈ�*L�0��aq��P�%�yP@�����?_��*Ǉ����J+��v1w<a6*Ll��x>��B����;�E����Ht$���efD�H<�<iM���P��Vp��Q�F����*i�;�ԡ�8/��3���#ܯ_V��Y�DЙ���}�qЙ!��jr��x���s�+	���G�G[wȹc��#�Oǂ��SY"�!
|���Nm�@5��;�B�&hЩʿֲ���1�Ēn��b/��p]� v@�ֱy�Ze�Xe"3ԋ���Rz��ʛ`KC��Md`�]rh��O��sF�W*�������� �;�ּ�k25m����/�^�o�����O�-c������o�)N?��Yt�E6-d_���9?�C;���!�V�7�l�Q�KyE�b7[�����>?�������Yo�����3�M�H��`i#";�ƥ����"p7�4��s�f�J��9ܚg�����P����A���f�A�|Wv�۾"Ԉ)�NV���Aݮ8�{(b�&�9�Xo��ܝ���9�dE=1M��9�F��~��<g���󬡎??�~�U�4t-V�)c�sG����8a,�D��	9�4ݠ��3�� },|x�EЈʀ��1��K�@�rDb6?��r^S@6�*���ϩ/
͈^�N��<��]�u�둿�'�f%噱��u�H�3�q,iw�V!wt9��;-d��ߞ�A5���ɶ�3\�I?��M���rz~~3������p�;mQ���6rv׼�.e�M��*��Rp�U���X����M�!���ф��f��[bE=��9h}����7�h	�c��m��F�X�&��X�]��m�M3=B��Z@&^^�yLW���c$�����9�zҗ���#��1�a��uޡ��XZ�]��~�K=E�J>E�ZOI�Z�Ə1k}���@�1�a��ۉz]
n}���<C�NU��ty|��q��7M\ cǾ����	�f�X����`"*0��Jy�RnO��hi:w�N��R�'v�#N0��g�c�>�I��� w �K���Q)bA��m��A~�؇S�W�zA�>����b�;��A
���2b���7F� C��-�Ý��|1x^�x���-r-6�ڹ�Η�b�'���"�C<<R��^���uD��8�A1�D�DGhZw��~04��6�k��d�W���Jx�m.q�@�It^�!��mSj8\�r��h���$���5p�VOG:����T���\��r���mG��P����/:lB�-tU�O������4oҳ�ʽ��qȋDq[�;<��j���q`�� ��٬,l�2�D!BW�v$������m%X�sۙ�@�*�TO�=�>�*��Z����#�>go!����0��wHKc�:�O�g=ˁ�q�LÜ�ϐ�'ȶx�@*�ʷ��Q��Ý����`����6G��{2�U�|�mj{?��C���"�+_�o��5p�&f\]���`I�%p�^B
ݙ�@���
rD�|�NpC��)��)��S��Mu�:�	�s	�3rD�ms�n��8����"�21Σ}�֗� ��	�^B78�e��1φ]�A�-ty��u��e�����?f������)+h��ǁ�?�0���rĪ|�JKz:��;A{��X�����"����]�LV@Ό��[<�R�f0Qf0�p�Tn��]��x1��ȠJʥ#U��"�������4ŏ��+��_M�ҥ�i��D~�"V�����t���%H�rPnѧ��J�������s��d;�����2y��W��c]���'�A@:w�1Ƀl� ���P�'����-�?�<G]EȞ�0��<�#�1���'�Q,b>�+����q��;f�LV�wn�aL��
�:ϲ�۸Zܶ�r����Rq3U=����^j4�:b�j9{s�#�&�:���)X�Z�YX�yp���A��b��R���	���ۓ���Yd����&ǌ�
f�L^L�Z?���]*���m��	�^�(�w�ŚjGݱh��ێج�w�� )R�Tc:���"u�3�P���S�s'�&wL��������Y"��nn��4�h
���g*�f�qu����b�D<�?ާv3G�V5�����:��E�:m���>��R�)�{��n:�\+8�[I�c(�4�+�g3��B�g�\�j�!�8(~ͅ(59b��i����~���q}�VPo���-
8Q �L�������R��sn��%�����uB�V��:vŲ/`ݟ��A��d�/rϢmt���u"mlf~E%z�2�0�QƖ�zW1�бn'��lR��ق=<Mlw���CeĦF�m�goV
שd��He�=pJ����C�xp�.����ZA�i�]<�nv}����~St�o�m�P3���'�Cݝ���E�tѦ�ª c��}����6��t|KJcM%Q�<|�LS�v� K� i.!���2"�͐��#�Y��ZD�B����ǣ�r����f�bT&l�打�_%��ELD��@[�y�o����2f�5f���2;�&�Y�A�ў�Ҋa�B�%@�3�����@�x �S�Ky]���t�����Ӡ�32>@p��"�"�n�y��UB�̐���ʋ�v���k,�( ��� �)���빍��[�y�诣�����̡M]�k1?��s�`f4���?]�̆�k�fjB��T��kĖ�>��4I�Tβ�j!����*��좻:+
/�\�js��~������L"6Z;�F㶑�H �d��=�~_���ʺ�d��**�˰q�/��i�AN�r�3(�-�>��-��Z�^�*�'� W�]�R 1��5��̓;��`�)vG��BLM�i:�Q�P�4
E����s*o�vH���4F�k�wxoz,��@�Z�|�M��t*�V�~Rpa�6�9���t��!�ë��-d�Ig�Z]���r6�ʋ/VN��د�$�M;�����{d�Q@g���>����'���3l"SаW�'�N�/�Q�Vԝ
�gx]��ʛ�k��ο��d1��<��݇�H��2rd�6���@H#c�&����@-
\H	�3@�LZ-- M2�h���L"�L�@cp��F���m3kĎFVU�L�*�����,C�a����q'bΈU�l�B�L5�А!�1�a�)�b����Yek��~'dv�����M�|�rVH�d�h=���7���/��zzt�&�?�>�J>$$3�
�~���ɳ3d��\M�3�Y
g)���Tw~�uM����/>�
d{<��I��Y�ba8��U��{��}9M�02^�}��%d������_�ޮ�{���<J����KF
�'�� �:U΍��W%c�csj����ql�˧SI�х~���`�S�v.��d���*��d2����ۦ)���:u�e�~�5ҏtuz�Y&��i|�����    ��b;`z�)����'��>8��+��ʸ���7Tj�(��2�G��؜ߖ�ł�ߎp�}^��h
,�56�U�v£+�;:��iL�K�Y������"��,�e1��ſ[zCF��1$�p�(�l��y͆!)��"��7��&�q_j�l�J�%H�F�0Сs�!�(�ј3���,v+o �rϫ��O_�^��!�EÑ�S�dn�xx���q��x���e�:�q�|:�Q/H���Mm�m������VOFp䶋�Rn.�ӑ�C��oZ/�w6!���{~3o�x��S�t����K������$�ԛ��>䕚C
���e!Km�!��9�]�'�X͆{���V#>��������M ��q�b,״��2/�i�g,�;ݗ�|>�����ӣ:	d!�����Sdh&�o�&?�p��_
X���n�Iw!�qF<��x�z�N<�4�o/r%b�ӳ�e!Ō�V@��beF���i$ө�G��s������w2D� ^m�\N�;�l����c3�*<�c�]���_�O�4�p]���;���� )������p���C�e���&� c�q�P����}������S�ߙ�@��'�x#�k����|�#����5���kǧ�Et�o,�NE�>u��=����/�~@�d�4؇��o<�m`_y��Z�b���������5�0�5a�2�������6�/W�*i��G�%o!�qM�1�%�1ǽ;�^t�F}@fN/ �����'y��BJ-�P�y�@~�#q��9P������'�,��2^d��,RJ6V�n,����a���뀟�����e0 Y��m�l{��	%.e����-�Iyr6���^1KZH�a|�̱w����U,d����G��@��:o���-dk1>
����u5ŢyOc�V�����N�5�G�A&�eF8x�ͳU�Y:��~�5���7��h!����fh��?�X��{z��t��G��<D�7�G=���y�yg�AY�|=x���`��e�?�������ֻ߮�m
}u�������o2�F:4F�nנ�?+����$��|4��e�(-�vT�2�o7l�P�A��t�UF��^WA�å�zC�t<
����������r� ����0ܶ��~�����:B��Կ����kǫH�MЫp竒s����[��J;�ƷT�����B6Dbk:�����pM��7@֖��բ��$�D�݃#��6(���_�\��&�-׎GU�f&4���˻27��'����	_������{���Ja��zA����	�R�1$���\d�T���W0�9�Lh�&۫��6Zp*��e����d�7:�'ACOO�Ҋӭ��ja�l�p�ߎT�|��9sTI�0p
m����{ωA��x�f����ۜ�N����Y�Lh������fV��$��/K!�Ct~��M�DGi������F��0m�Q�m��Lq��ü����N�!!�\1~�ܩ��ABe�1�l�r��V��%���@�2-�������}���l�L�r*�XV;B�x�$
K�-�Yh�\�;6#O�Im�ӿ�����dP�����$k��,1n�Qh.K���r�xGe�O�;��08�Epd�;,uWݥ !;�]`��v���j!�n2�4'�� ��/�G:K�;f�Lf��o���I�Y|L�;\>���d�4E/�x��"[���a�(4�XaZ�ox�"�%���W��sM���R\̞�dԍ)9�Ll�yןZfS֣/��/��8����>�:�٠o ��(zFiU����U���&-�Qv��b��'�L� ���M�4�/�'��a�\�L^9�����4�3�PfǦ��J�`(9O�DA&����t�M�#0��MC<[c)A�-�u�n�~�HX�Au�\��������o6(h�w�H ��|�Ntf@�=���r��d�0���۷��kx�|Y��N$d�*�K�S���/d����A�3#r5^o�b�%!�F��;>��z�C޸�wi�R�A���}�����_B9Q���NԦ�h棗_FY�r�l��$0U�L��6�q�t�o
����E�u�3�;�0�x�ad9�܋fݶ_�1�r�F, fHe8QTx7�Nm���fF�鎧��D�Z�؟Nw��%� �Y��q��う�Ɔk��yg����LY�N)���������p��<�Fq�l!}�TXU������_�o��Q��g�������~���\dF<�A��P�uxQ��$�1��&EPiUld��˸���Ћ�7<W���eZ1HY�lt4��F��߷���&��-V�
S�W,��s�~Lܖ���k�?>H�bV�@r���Ƕ.l���$x���5�>f��8��MUI a�Yg׎~���ā��n���C7�\�p���pޫ�s�̯gӡ{���Hvu$�U���s��g���Iw �Y�БA~f&cXs�2�r�%�xf8N����y(��@�u����t�{.e��i+�T񩽺�ן��$H0�r�l��6�C�trh�)l��:� �����@O�Nm<���~@����Q�,���'��}:}��r:����;�d?�vs3l�í������E�]:H�a� �c�ց+�A-�စN{Ż���y(�$=����M���(��?�(\��BF��L����/P�e'��:���H�>��ݷa�XZ��Ǒ�t��&@>&;5���-����hֆ0'w��ܞ��'����d52k�o���z�qUA�4������P��=>�ax�6����^ Ö��ȍŰ�чj��K����I�|g��-p�`E����!O�|����3k���&��m��4=o�����X@żrخ�e��ˋ:h� 	�5m�t|��ҵ�f�L\+��^>�3ڼ����H�Dn�V何�ܨ9Sp�Y�N��)7�l;��A�s��� t{F~fm�� b,�J;<s-yܿ*��x�I�~�'�A�-�� ٖ��F�f�&������۫X��7��=e�.�,��2�Xc[��m�x`Al
k=?
!C:;����IWvМ\Fsz-���Hdظŀa�Z닞�?����ZӼ>��*Ca'dJ�;�E�P�r������I!�v��r�gMI�����
�;��YEp�m����i�1�?�i+7t�&�EzAEk��C��O/�}C�k�H�u�ނR��Ď1)B�0�6MP��Rﵩ6"�Afļ��ΰ��!~�t�3bT�μ���k1xy�]�|8}�(�.�Ƭ�$ڠ+�ob���MNtAE����~��Z*_���FtV�u{��C��]+���KK��j����U��!K��"	]�	�Ӊ0{+���ǖJ/�Jw$S���6�6��2�嬘�l�l��6Tn�K�2dʰ�1ѩ�7�^���媝�K>:�h?�תn�a�TZ<�X�d a�(5
Em9��rO�!���9?}�A$��V����d��Ps�F��Kǘ�ۚ�^#�W5�Y`����S�{�-��:��Y��OA�0ҳ2�ZF�[.�w��d�&����/��/�OJS���^�^ޘ_�����SQ@�Í(|�ǒ�멵K�n���*���(�ԱPru��	��r��>�N����^N#fHac9�M:NǊG��9/���CZ�Oh?^^Զ���0����Lo9��j��zV��1[v1g����9'Y��ُޱ�Qe�V0[�ٗ����+�7IV,'Y�7x��y��A{��qu=#AC�4�	�f?x�+j��7��Za�
Y�����~��o��])4L	87Z|�f�ninE���\E"_T�����R�a��뇓2Ӑ��rJR���a
�($�,���	���˯z���XNc��s���wlt���$2�zF��F�o�v�6����!�:���6�$���D�����y�����5J���a������7,�P�%xW�A���^z�q`��q��O�"���N�}� o�8Ȕ`}�S)j�mN7jĞ�Ќ�g���Յ��;/�;?xأI���+�h�j`o���;�-jHYb�"P�[������W�L�C����5���    2$����
ԝ�^^�d�s,�#�IY���=�,W�F��>�!�mh4:�u�DŜZ�9]Qk�0��^Hz��g���pw�0'����nZ3� Pv��F�b��*�A�R�ÞV�6�0��cF��=�Y�
}�������6q�fm�o�Ѷ�a�m�!q���w��[2ާx;n0�1n�7�V6<�p'�B���A��6\d�����Z-|*t���S��� 4y��� ���)��[׈�������j�Ԋ�tDr�2�Ol�+[���?k������O����y�T"Pa����n����3m�}�}�=�~�y��G��'^��Yt�#/-`h7���xI)6��Z����r�!��j��� i�M�dG7�%;,(�tH\EH��{q�q�Y�Ɔ(�<�}�Qw�HuI�f4k����X%jh=��q�G�<wϫ$�J�Gr�S5O�y�kl��n�t'[!I;��<Nq�Yk���6J�$�ɘ�3�qk��Δ{������\��FQ���M]"�]��jp	�t:K�����*�i ��x�Eox]��ݱ���	G��Z�NOE��!_��m���V[��!?E���yܖϊ|:Ie��<J_>�j�#��XWi"��K������xȧa����x�17�i�(���������og9��'Q�&���'��Sbz�>K+�Mx���]C|zR7�<�p��q�]��ȸ�M��<nC������$����عq�ibo4`��ִv�*m�SA���(">lqܢ�ޥS�&ĺ�1�]�z�xi�����]��v^�&��u��Pʺ;�;����������Xvn<�:J��f'�N������U��V�8]���t��XvnLƜ��*9�H+��_Fn���,�{H�e��n�dC7�?���Ѻ��O}�%m*�iB�.�\�a�T$vU�yp������ʬA2sX5������ڐ�!1;5lU>Vwo����֓�4�usc놗ob������ �0����7�̀��܆��NU�H��m�ő�]٠M���w�-��Z��Ï֘�Ia�+�ߟ��,�Z�Xs�����*�{HGg禄{��qֲ�����q�t�%j����,��[^W��"yB���a%d�`�����i��6��qڽ/�H����YGI�4�rҀ����Viw���31,�l��4\·|	?%ተ�OBGSK����g,� tH[d���>|�>��z8�i�3k��,l�W]��U�6�ʻTt�/�/x=���Z�0�h��wir�M�+-�Տ�^�q(�>��F��V��Kvi�3�s�`;����r�;�f�U��q=c�m
I;�҄Iv<��i�zQ�M��OZ��c��5`q,M����a�r�A_V�_�tT��w��`z����pq��uwKܥ헡C�u��+K4�2KI_teK�_N��@7���|�(=A�C4;r��i�1u@����'y��C�%���U��6��{��l���z���o\�ҭފFI���7�G߱�, ��ϣ#iC��D����e�)����Sg8l����,*�;5��)s(��9q7��߱O؝�?L��1�ء�p6��n�m����ǎ}��)G��&�rΖ1�[{5�C�ۂ�[5 I��ڌv3]n��]&'��߅p�����2e?��Rn��8)��J3����y�w4�ur
���ן�E��Qvm ���\�/�d��Z���������!��l$W���������FyF����E]6}��f�<�{���%e^4�1���󮵂��׈�ڽ͝>��!�����M�!�7����y;���9N��*w)=$�rS[v���2n�"&�l\�t�������,���gR�5�%�ы�f�Z@nnS�Ȣ����Y)	t�F��NE�w!����$��%*��h�����l�83)k7��rĨ�Z{�ؔj�n�8^�>�l����y�-#��K�Y0��P�b�|T�5R��)
��,� 2g�����q;������� ��D@n���QS�_�6ѤOnW������!����ߴ��t�v�aH!(z�ff���_%����:�4F:�NA��F�pP}�F�2�y��J���C
gDu�m������ #XwG9�3"�Y;��a��A��B��Ic�������=ds���̊�&�(tڕ����r#%!��}3 (7�$FX�u�5��.E͕�ގ%���6	�6��r�����85�[�;�W�pdN��.y �0t2A�ʊ+�a/�>:��I��g���b��	x�����2�}�SŹB^�v&dj��՟5Y���*�6���E���8HdB�g���$G��*�<R��\���G��p<#rk����t���uJ�Y�i<�*�m;�@��#*�����?���p�cz�,�Y+4z<�
�Pwrܸ)�3����7���� �T�m5���Lo�7�3fT#$R��W��9�
rVd�~p�#Fc��Q՚@�}�M� àɊ�i\a�{aA�<W�^����U�oԥ� �k#��g������Q~�1
���	I<�p���Kg��@��b$%OF�W����<d�p�	��.v�[��x�j�ՙ-�|+�*�"r�=���wߕ&C�V�=E�����YЙ�iX�f�m	��l
/�Dm��c��.���\
`��Q4պ��By&�k�~K�m%,z��N/��8���L'�j$��;ΐ7�Y�%�M�N�s��I�e��N���c���C�%�D`�����rt~{z(oN���tz��m3�58/��Q��u�/�u�e�Bi8��!�sRG��xsYo?2vV5�f�������+8���K��ХأJކZE�39�z��$�����k���fw���)�HV�=���Ac�a������/;�ѱ�!D�g��t�g�թh������~� á��*�cv�f�!�sM07�ZYo�v����"kM뇕���$��zH��\��y6~��iIF�c���b��<�A�l��yT{�NQ[��2��֙ǲp�D��݅�݅�[ �F�6����6-�"�0��M��J�7�ЬG��%7#n��kZ�;u��C6+�eA�3a: m�۱�i�~��t/o�xH��|�Mh�a�ԭM+!��<��?6���m\���9������&����ʖNz.�9/b�y�����E�Y�q��̓�ںƴ2��"{w�'�9.rck�e����=:�^\h|��ʌ�$��?�K��\۾>_��v"���JAB�QC��r,�|����
3�H��DH�0��"�];��[Iw������|��L�*'�J�p���&􈩨;�\�G/34[֪_�cQع�$.��p]��4����oxƇ�~�@j����yx�E�NB�"ZI�x���#�R�q?@�x�N{^�M����Rђ����{.1z���w�o�2�UHP?��4�a��y[9�n��wV�>qʜ���.@�O��a��@o��؂�\�E�F�L����j���*c0-	�\h���Q�n��vs2<�8�x#]�?��!�mPڍ���݉(��,���4@��������m�/���g�k�z�f������	��6V�{E�nFl:H��y[�f����nxCRJ� �I�����BD��A�P�h�V�;"�NO��e,@���(c"	�`ek4Ў�_����"������+v0��*��lu��� ��5����\)W��Vs�,��"o�.i��;ZJ��c�1�z�9�SD�p�	����b�5�����:ΠC���!�s���1}�LO��HA�|#����3M����M�*�[�2��o�_�/ʥ@̱�L�7�f��W�bBW��3[O�.2�8ΤC��+O��	7MGKqS\]K���^�^m�T:�S���Q�������WZM��vB�J�ނ�ag�I*m:��{�j�ƃ߫��"���u�n���$_"􁜖fyGD���Ky�G��*C�F���/�����v���v��z��A]*�F�ͳ�<X@_6f�=�ER    Ng����ˌL���C>'Ӏ���ni4�$��[F�J���F*8�a?��j����!�[{�A�t���W�wYe�1�Xf9�*�/�������+���:,Z�D(mb��F��YR�H��a�̈́!��
��V�m�^�+β�k����B<��pҢ�ݼL��13d#3�����._�c�Q�,���,��+,��^�iz�LA`��1�Қj�!� �W,�*�j����&t$zqK�����m�]sm!OS>�Y&YK���S�TQni���)��.WiJ�Nh���ш���K�%�B2�٭䱅 i��ҼG�6��x2�x�Aves6�Ĕb��Y?Y!�Ί��K���W��Fu�!�3�2z�E��ы��t��q��x_��Ɍ�\N��8@��6*Mg����D�F�ү��k�:��
ӵ��Q�\7�n���q���%�����٩�/m}5י���x0F]�5�/�ݬ|0Zw���d{,��8Ȧ.�J�� Ü[���@FE\v{9m���R�@�:u�Q����V�Jxp���X�x�g~!����,�8zm�h?:����?�m�ʡ��p���5� ��[��c�p	q�w��]u����F �{�qk[3�Ӱ�+B�Ev3Ъ6(�au�t�Uĭ����[�>B/,�w,�ߛ�&D+2�Uz�����$Z�m��#э�1��gm@2��N�H��Ej��(��YKL�SגuTI:�����8��豔�W+��RY�_�L~��Dɔ�*Q2&.���Ar�c:����۟�O�_�nC�?�����q葤�f��gJJ���K���O����t�X�w�G�1��R�:�b���kd��䅴ǫK���̜�LDu��5d񓨚���{	��~�Bszj�>̱�§��������5����}��GIBS�h��^�M2Hx���v�K�v�x��/DJ���XR_6�IA@O�-����^�
�(�OM��{�����g�"y�~���i;�� �W �wi�e�Xi�����ZN����hƺu>\5!y˷�
�Y�ѲMA�(���0� �j)۽�L��\Co�
uO�f�F=�D�w��Ǫ�H!��ȸ�M�a�����a6=OJ�:�=Ȑ�|~�Wc�fȇ�J�P+l�����ڍ�rX�a�L��������A�'`w�EZ*?-G,xE���%����/秇�ApO��=���lB�у&dgI$'��{K��4!4EhXj���,&@�o����֫�s��{Y��B4}̬|�����L��������"��I&��;Ԯ-H��H9����z�W�FlJYZ	9���t����^�y��ț6�K��!�$���q�5l)��TI�ǐw�L�˚��V�)�'��ܐ\�3u���ן�Ãɖi�-b��qǭ��A�mӪ=���N�x����8�$��>!�R��;��.��(叧-�{�ٶ-��:^��4Q,��׊�οH���8޶��ƼoFܱ�X�y�.
Đ��[#ޞ�i�+�n������گ8 ����yv�����ԩ�N�aS$�f ���ӗg]���O�ꙉ�f��q��%�r����Q��	)o�[l�[R�zT����N�w��}����Yg�p�s5En�{�����x�Fv���A`�jz��ќ�'MK�ۆ&8�~H:�r�BNS���ׇӯj @�����Թ���@z9@}�~t x9EҐ��sʃ5�b��J����/�^����/�����5��/�����b҆�sw��T%!�(�|�Y�� ���DV�4~���K���)}�$���j��Y��:�9���ml�+;��4��2�&W��N���z�bW��yND�[�ԄL�^jR�mZDtu|���������az��v���~�G��Fc@�Jݕ��Q��Bj+�8�h���c���)�m�|�x�_պd����#}�ͽ����]�3�(�]��w ���5"���pz�S�'���}��Ók���?|��k�*��t\�h�q��u�"7B}��=� �.(��N-�+r��@���H�r$3_��8+�n̪aҐ��'��.'�z���7�:\�VF'�1ў�p
2Q�孳�����p���!`N��|5
�g'����*2A�C�ʮ��b���s� �)E&�����k A�������ߨ��M�E�&+�=�8���"=@b��`[+�hF��A|�Z�D��V��t��bx/2�;P�r��t�།�)�iX3� ��������0�H#Lsg�@�-�'�L��fbxd�~��L�i��B�(�ٿ��#���A�Өq 0,l��t�Y*t��>��n9�P�����AH���
������;A:1ZO8��J�Վ�x�V]X�V�kf�)H|�vz9g!��@��$��]���!ϜV ��p9�͇O�Y-���ҕ�ӗo���S|���1V��q�Q�0P3��vO��n��V>������Iw�g"�*��N���󤠡����~��&eQO��*��\Rm!�~>d��Ad�np�?�#1#�N���S 9��[m��<u�E�N�I!a�x�.�I�hDH>��]��ql�E�+���i�`6�Z�(����K��e��FJU�� y�k6�,QGH���u�f�Z���v�e��f�K�4[]���?�(z� ��|h�����e�c�3�=�Jށ( w}��#���sr,q��T����۬0H�sz\T*!�������S��TA���L����@?"���QfzӚNen���P+�M;vbҧ�o�FHS�c[�s� ��}$l]�N{9<Tz�|�<B6 E����9��[A�.��;&��o6��cI���YoJ\�;@���L��5��8��:����p��T��q3����!�9z��T��ĉ��O�ߤ���/���*��$1O����<]�O���:��n��a�K�W�\����ȕZ��x���.�e��"~:��y_�܆�����uJ�z�7�V^��9_Z,9�R���1vtE5�lv_^iU������]h)�~-d�^�ֽD��<<���������d��߿\S���?\�O�p��ϧ���n�Z>NI����͒�,��հ;��x��y���Y�R����Gp�3CW�8��Yc$��4�YZ��M@�+/����4r�TfX5�T����������.ռW���"cO���mg.g4�A��e@ζ��@ÐpnB�tw*|��)d՞��j�g�N�F����R�_�)����������Ap�s٣4�6�gfz��N����/�J�U_4�K����\)Z��wJ�g8E���w�#d<�K�У�r�cd��y��;�?#̐��m�m� �sc󠸗�]uY�	It�V��pVG�h���OH�Y��gi���:/�ù&�+� $���t&c�,�U
E�g����Kgۅ����v] ��Kd~U싐��/b��/��3k�g������E����oO�2���i~i|��w�Vƫޱ̈́X��<V����'Pd�M~i3��h?���b�<k�vb��ݫ"f��)�/�°�Fڻ^t�]���Aҋ�m�A�����j��F1S����J����P�&oLL��������㋀�?����w��tD/��K��I�5mwC��J;�B!��g�*Y����6�N�˜*�����B#&��2^*K!�~��AC�̘?h���ޯ�����A'T�R�0C#��]M�	t�U���2�*�q� _���#6�ٌ $k�n�Y�u�rr�VCNE�=t��zw9=��	�Hy�#��z<to��6�i���˵��B�AC�.�����'|��>����cti��N{|�8e#$�4(��������-����Z����>I�0@b<s���-�;ƃ0;0�͙  9�0����X�;u��;[��!k�Q��D��1��/L�c���X蝄�v��D�xN�V�6B��0��7�siDA�`��YV"x�|��l3$�	Sn�8v%`'��s�lg`�e��l��0    !	L����X�(�!9�����	d��l�˲����Y���&L���籁�,����9�J�6�3��K�pW$�V/��(�x@��>ߥw& GZMt�`\�:m2��3��svlu5�9t���.�xЎ���X��̀6�46����{b&�AEi]��36r��#�_�y���C�7s& �z= qѻq�I:�k@Z�x-#��eEE̻��.��攔�-��t�WԄr�iR���CJ�v�
�X!����Gƹwz�U2D�G&��f���Qn�\��>!�3�H��7��,�8��&z�F�;�?�������������|�0`2m&nn#���ьЎ�)ӝ{Yx������D�R�`����A���g����X��>��=����F�-����Y�m�Q��CVp刿�>in��k�i!-��5�~\; ��t;S	�!�s��W�HC����G�A�iN/�*���:M���"d�F����۱ێ�g�V�$�a�j��>�#�f3ӟ����9a�*C[z�Vb�q�u��K};x�)��L1�h�N�\�
�;d�V�S{)� ��'캒�����N�zO�xO�[\ v�6�+p�4l�Ʉr�Ab�����|s�uWys ^�\i��X�4��� �Cj��n�4�#�k�OS������w��RۺRZ���������,H�|�k�;+R���Qd�%���ľ�}a}��:#�C�j�k�;K�o�Uں�O��w�2�Ư�/�x�[���4�>Ta��mԉ�D�J�O%z�\㠢�K
�|����Jb�C�dy�k���I����R�:~q��
|��	���x��=�1S%kR�H�\�`�N/�^yu���|l: ˑ�Bt�o��5�5�:��-��'�p�DH�\k��j﨤����G�wCB9і_4�
(�IH:��9�MC�z����)��dǫ�i�ʴ�-�k-_\�b�-P�3s�lD��|wV�dY�6��c�)�GO,���DƢ7��;0gy{����&��-���BU���U֞m�=�~�
�p�kc��#<*��g�1Ś(��O�)\�Lɹ�Ҝ,�!e�P�v>�/�-e��ָ �<�)��i|�o|����Ë�ֆ0�r&��ye����g�h�I��Eq���忦�f�D��{Lm��=53
��@�!�O�"��o:��_g�l�l�CxhVl��t����u�� ��aEl�A��6�"]���c�w��j}R��V#�������_��H��}����#
�H�D�t��y��'cZ�4��'9O�V����UB�e�ayG�94�3	��(]�7{j�Ϙ/R�y�b�'�#!�LmJ0�{�}���d�NQ��oO��c��_�T�R>�F{���³����+��`W��1z�/����#�6�~~7m���ٸ(�i�-��n�TZ�M}=���#�	G����9����(����-�>0xP��$似Y��7����8��}���.���~xY��n�&����QzeFVbl�cSO��j__��1넳�D�l��^8�ބ-1gj�z����U�T� �~i��8o+��E^ܖ!�\1CBvt�Xi���<��j!GH|d��%�}��V��_-�i�`� ��@��΄ \������]�mӝ%�u����0yƱ�ĥ$� -QN 7Ȉ��y�����$���_(��atDW{[�~�Q��_����h�����(��A�o�a�Rw�I7�& {NL����;���D����6>�tX��N<�ü���=OC�D��w�Pƾ�s�����F�X���P����!C_`}��>�w� ��׈M��wݳ�׿7�7�F�����i�B�>��$�s�U�'e#�h���6r$�db��vz�����3$�	�,�
;���@c��q�y-pG��(��Ca5��,�ϐ%0.�$o;F
�ס_D5D�67����t
�rZf�8��cp��E��񆉝��3�3��s��i�Fm6��^�o��jh7=�+�y\�Ui2�))D\	3�U�����4���9��6Cҧ�H���!�寯c�\2�F�Z�`����A��X H�{TD��1��:C4�D�" Ӳ4�P�g��0I�m��w��W��=��Oݕ ��6¿�+�bh�� d<����������ժ=�8�6�i	�,|`�Zp �}�dψ=m))�a����B��j����tC�f�����	 r��ç�o��1CJ��(���e�WeӅh�@�rsP��fH���{v&���=�U�,El19�*���"�s�+/�5LS��m�"��>�/�ij����ߔ��"fX� c�:��@+����_LNW���1�G�����Na�b^�����Ō�����̕�	�W�L�~������gȰ�I��`��l��,O����aD��'��a�?�����l!+O�9��14q��sV�Ѿߗ�8Yⱓ��c�w�W�̐�(,V@N��d���̡ğ��B�GCN�䚑|??��F3$�	���!��tW�4�@������EF��p��j�fOI���p�<�MtF�HMmv�R*jvO*Ҙi�u�����1g���& ]�8�P���ER�́ε��SH|�6�ta��� ��Fm�f�_S/0E�^"��i�f���ƙ87?���0�n��	f?�Kjz{{��6aOo<���.���E�S�Uv�:#Q_��R���-q���W������ʕ���~���Q����u~����yb�w����h�����A��̐F(���s� ��S��d�0k��V�˪N�y�U�+ΐ�+,M�{%�7���A&���+����xy��r�P)�4�c.��9z}�5f��PW�?�>]��ݪ0V����:B|�e�J�DC��U�m���4�5!�1�s�pb*C ��tb���Mܺ
�)�/6��0�1ɢ�#C���
/^|��Fe��|Vs�3${��1s�/!��ڊ�s�8A��?�h"s�|U�gH^�F�Ө�x�ʧ锜�t���3�)������^�Xg�PM��.ㆹ�t��I�^�A�مu�Nwg�*��Aqj=�7Ks"C�9珥��}$��i;O޼?(�I�x�./���ы���y���2P���Q�q��M2��`�RFsFE��)�	��ˍV �'����Me&�3���YA�}l�����*{�<+Ѵ�5}W������?���������'X'I�uΖ.�'xMW+�:�>Cƣ85�њj̅h�0ƕ�3��W#�6�'�WV�Q�k��x_vM !V�\k�#����!���gt,���+���^����QFA]�ڠ΍��0��7�ػtU�aVe< O��Dۦ=TToاa���Į�u�fܟ$R��m��.ԍ�x�`��+7�w�@��`�����4&;��k������\HM[R�FI���<��pbw�u[�d��;�4�u�!�̰rض�� �`�J}�`C}6m�h�:
�o��R�c4� ��s>P�$~�(����85������
8ش�MF,;b�y� 	��D#�S���8��<�VO]h	Cښh��=z�CM��!����6qy0���}<CҚhd.ء�Α����~�Q%�H��uP��g�O��Ah[+�*IC��p'�ˀ��)�cu�m!����6޿�v�(�������DeA�6�w5�"�|:�!�N�-"�5�XE�	�W�9b�g��������c��-�̜C"����a9��15$�颼���OL[6J�mr�p���8q_f�p��=���ԕ�2�D��(��T�2��WB�F{��酒k��A��h[G�����_�.<�2)�����1.��ޟ���rb��ќ�f*d�� 7� F��gıI':ǒ�ڝ��y�i��`��6M-�0M8vF��|�� �B�|=��3.�v��'H�����f�d|��v�c��QO����{�]��;���b"I�)�*�D]��K��f���E]ޝ!;At�rX�2�u�����r�B��AB�������H��ֱ�Vd�q�e�f�v~^pma����Ƨ�C�i� m  X֖B��8?���oմ�@B��Z�F-d��N�gg�2�9���N?)ACF���R�a߹r:�unh9uC+�2�p�D��r?'>֌�}<�2"EΈ���82l�q��B����D2��S__��K�z����:Y�AFr6ͨ��3��R���&�2���S��<�1��/� ��F���`���s���:9�TҊ�/o�)�>��Y���Qc��Az�m���)�r
E�)D�o�*G#�l���Bܐ�ߟ�q�dE�&%n��~���|�q�!}���&�7�h���G���đ=4c+�X��~I��SF.1�2��Ӄn@�}���(�tܕ�33N��Ҏ���5������r*�ƟX�.���\���st���P#��xv�[��!�P���b뉈��[(�WjL����Zf�X�$l� 6�
8 �k�
�bf���G�LA��GGZ������.x��!���]��M�
����˃����?�Q�"Ϳ(�3;)sw~~��-��Ck�;8Fi@�U ���d�ݼ=\�Ӄ�P0BʝAʷhr'�ϏhFJ�w�5�Eo�p˙mn4z���]����s�};��9f���k���1���#��((�@����@n�<���:��>R�g� �.4c�<@8������>x��Ҙ߄`ʣ
���J) _W����Lƽ*#V�/q����ӯ����o��л������q%�����R�.����?����;KDC[���2��dy�;���+�F�&���N�?�`K� _=����N18}y�qok�`TۨȦQ��j@9m����N�"QS��M����e�(j̩8X�j�E�!#6��>����j`n��$1�a��3��o'�Bc��S�A�\SK���H����v�j���]`[`G�W�n]�ߓ?��aL��.��7�Fw�cMՁ�M�z��C�؄H�dE�ck�#�����-��@fn��ߟO�!��(6���2��eȋ����o����bh�JK' ��v��Ksc��R| .ea��У�@?���Q�/���O�_.w���?\y�����ׇ��S;��������!Ls�e�-&�ѷi�"hZ qI��o�vp��$�Y@��q~zUKU$M�s�{���SA<I�@���{}!��=O�d�K�@UsHX�ƚ�	�� �N���lM��_'���hpHg�k%�txV �P�a�4^.|�u]Yo������kU�QsG���v��VN:�q=��K���!��C��\ �W��Dn�+��.�!��YV�gOȕ��c�� 9䙊sV�}p4��hj^�C�&��$R[E=NK9'a�,$牳����E�K�S���i�P|�����/�� y���      ^   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      `   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      b      x������ � �      c   �   x�u���0ks�@)�.3@Jw*�.@�x �����R�=�k���}~�9���m*t� ڃ�ؔqc��;��V������9��t��D�����[]�<�D�\lp���wr��k��sWgl�9N%�EJ^q�I�y�c�	�Zx����"�b�̇��MqP3      d      x������ � �      e      x������ � �      g      x������ � �      h   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      i      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      k      x���kv$������&�X A� ����q�Hۑv �ߡ���Q�	B ��ŉ��>r�8�_�W����}�����ʧ�>?����r�}��|##F&���cd����o��PB��<%�o�����.>B���K)�֦�ߣ�x���x����r(!� �B7�c�@?�-�G�#���Bb�z,[��,[�'�%$XBK(`	�C���qWǻ��U<ȱ�Ċ?9�-k��d=�u���ϊ��
�ǽ�^Fl/#��/�ȭ^ekBĚ�&D��F�C	�P�:��%�C�o�X�֡�u(aJX�2֡�u(���!�۷�X�o�BbR�}� �5k����H���'�1�v�;�s���`�\�c.�1�v��;D�X�ԥ��v���]z�.�P�^�K/ԥ��u���B]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K�K��ɷ�X��K��ɷ�X��K��ɷ��������M����So�{�l�$q�8!�{����3^� 9��ȉU6@b�x����~�Ĳ���H,���9��XB3�� �e�?I���{ʠ�x��v V�ɉ]l`�`g|����:����|0N���|0+��3��`Uc{9��x����$^e3�� �5a�7 �;�<֡�|��:4��|�:4��X�f|��Ќo>@b���H�C3�� �uh�7 ���惃��}3��r��=�g����P�s��H�P����XBԽ�{?@B�0�~�Ĳ����;�˖:�s���@�U�_O=gH�[<L�&ϽJ��#����.����8�%�.����-u_ޖ������!�#��(��2�b�(G��Wܖ�\|������
�����z�-��O�ÇG�[t���>�|�x8ٲ���d��H��?��1�P���y�k���s/�H���=��}��돺�s/�H|2����K��u��^��X���=��}��:D]﹗�ob�����K�{ ���K�AW�`�^��p�ͽt �h��>��}�Ĳ�N��K�˖:�s/�H,[�ϽtH�qW�V4����-4���^��,̽t��:��[��{�>@���-M̽t ��������$�-uu�^��X��՝{>@��2��ν  �y���s/�H�C�՝{>@b������uu�^�������~�����|�6F[Q6ُr�@�	@��Ļ_!��l.�cO�M���/�,!��N�Tr���U����.=�ޟ������J����H�%Ͷx9���+.�M\��'���>�!�,��]�d�5!�����gC��7jm�}��;d�Ů�~����>!=bڲ�t��𝳠�V���T-?M*�^*&I*v��*�#2���d ������bDR�I$��ёZ��@b��5���qW���U<H�a�R9�kV��H. ��\po�x�1N�[-^c�[=-�b ��Ӣ.�� �V�G(ϧ#2�x�ԢK���:�E�$�!-�d �F�uH�.H�CZt�@bҢK�]2�X��蒁�:�E�$�!-�d��&`�ӢKR�aЁP>j��U(X=��@��0H,!�Q����Z�D0�XB�I�3$�-u��LCB����J}]5���x��e�3�r$_�x��}�3�qbKBO=�@b��N�M&�<�w���|��,����WI�H��0/�{�a�_�H�{�a�_�H ��n\'��������v6����%���d�OX-��'H�C�֓	��5k���d�&]��Փ	$\bz2��Ģ�޳�L` �l�߭'H,[�w��˖��z2�!!�I
�]�[��L�#�����L`�,X��������s=����=��@��b�GczJ���K�^N�)˖��zJ��Ĳ�>��` �Z���` �:�zJ���:DV=%�@b���` �Q�UO	0����:��J	0L�y䟧��P^�{�?`��f�*�����o�~�?/��o����M��8ݯq~��?���V�,�<	���Ok��)l.����&[�UY����?Wj/a�R�G��)S�i��hH���,t��#�@:Z�@N���������C��������?��ٕ���KU��H���������6t �x�A
�|~�tE���~�� t������g}���^����gH����ZR�9�:�vUsu U�)ԁt���3H���b�@:����th�n��B֜+��L8�{X�D�?jՁLS�'�:��͢��U�ը�fՁt���?HՁT��Q}���h?�YU}��/b:DxV�_��B�@���!W�����x6�_��@����S���~�x!�-�w���R�Ѯ�t ���LR�]#�ը���F��N�ƍ�i.����#�-���.j�Ǡ=�[0ͥG*�����L{�
J�/��\{a���s9&�}?ڕ?�"�?�����PH�ĩ�n�S]��=�/�t=<�<$n��q��E9RF)s<�����T��Q[�����!�ջr�>�C5�9i�1U�.2�\��"�W�M�-J�g����U��]��2� /�+���������ɱ�89)�=��v%�o����!����յ��y�eR/�����KK
sK�%����Z!+�#��&�l��6�n�*�=�ٕ�O4��g���!���<���u ��a�M��,��@w#rS�߫8&���=��:����aӯ�dׁlm���u #����u U �S_���8�Of����*��7�S���K����w�l�z��]��H�ɺ�*�r�ߺ�˘�F����@l��
�h���]R��h���]��.,��_��@zT��!�i���@�]���@�Q���@�E��E�r����z��~�eY�7߾xy�e/���-�@v����]��!{:����_������+v�x닽�������[W���F8~߼��]��������I*a.���W���E\�j�KNq��х�K{G��T��%}}��^%&������=A�wBG�a��A�K %��mH�ڎ�d��kQ#љg�����)�����BܾbZ̼�8�l��!�P1�ef���g/�F�׀t�y�f��iL��>�t���:�W!:��v8���H��a~���Ml$�0�eK��	��xV��4ɿ9:j�H<�À�-[��6mE���l���h�Og:M���ፍ��ge	�e;��aH�F�:L�����#6�v���X��A9�	�H,���n#���ζmp�Zz�r��`�(�d	�2%]�F�qB[�d,�H�R����IoJڂ�Ě@o������Jϙ��[:|U�a�s���`��#���㤧E%��'�$���d2�H���\9Jf���l{VF�j����{�X����6k���F❁zJ^��Ķ��)Jj�m�`��@�_��';�?�� �?�,^b��d����>�Fb���h�n���@~��9bL�-��d�-����ҲER�D��by��A?�y�ckqo����Bʻ�����6��O�Z�.���c|�����V�ו�i�x?���Bk���K��ۓ�=JHq��0�����v���n���R�Ҧ���:�6ש*�l!�=�jO��>��Q���-� �-�W���mQ�\\���U�oZ������G
~�Q}��v)�s��^���LL��sʣ��H���H�ӈ���`oS    4�6�A0�P>J��ĝ�Q8%�Fr	A=Prl$\)J6����Q8%!�FbM�Q�qN��I
�]��]�K0������85�^�X�4�d'���� �����w\|3�d)��[LmTl$�_XhNIV��X�4��+�H�9�uF�pJ΂��'hR�l$�!hR2l$�!�?*�6������X����������`#����`������(����(����(����(����:��߼}�'��W_H�>zV�3�����A_�\�d{\�W�E��ʑ�t�����5�?r��1�|��bۿ�R]..R~��ŧ}6P��i0m������G�!m.���x|/�v[��n�6ꎭ�.M�2��>t��o?cٹ�2�G�4�?o�;�!-jt(�.�t���cn�{~�ʶ��������2/�r�2�X�Zϐ�rem|ϊ64����Q�@����Wq���7�Jr��Wŕ0������P=,X-g ��! �@|:�\�gEpo�X�1+j,N�j5���Q�?%H���ī%>�A<� �����{��� �D>ߪ7ϋ$����Hl�(����O��H|4��b���ěG-�e �l���Ĳ�bT�7j����T�t ���/d �qH�2�|�����B�1=_�@�qR�C�2�X�ˡ���@�Uꫨ�B�t���ä���/d��#����~��/d�[�o��B뭖/d �������
�HT�Qb��)H�A�;�w����B����B���W5_�8�S��/d��C��Yo.�L#�l�'ut�L#�'u���'u��cg�����:�j����$�,u���%�@O 0�p��	����z��Ě@�r5���$�B�'�Hl��?�&k��C@\׹������@` ���/-�c]c�I�z�����u���eKs=��@���3��	�h���'H�C��$�!�?�	����X������ ��@` a��J 0��J��S��T)	�7�c��)��@`��	c�z�GmU2�0j%y��a ��=��'a �f�Q��tҗ��z;���_ �Za��)l�8�T��o^[�~ikK��/��~�l�9okZ.�l͇�rk}���kꈖ"�ZFJLe�T$���{��oOJ}��`~����xL7�|o��̼�P�9�������[;�+�.��%�]\��J%>�vm�ؖ�/���,���oR�Ҿ�\�>�T�c�Z�j�J��e錺�b�Rl~�?�v-,5 a�r�����tOK�w����rk���ڻv�_��~����s*KW�_�!q�,�� ��,�,=���}[{�]:�n��r�ܖ�0$���C����*H\jz��p��9�K�RK����h�n�K�q����ڛ��t�&��n�i�&-u�^0���BZ�է�k!/]K/f��0�=�/շ}iߖ^h���i^��ҵ��]K���kE�/]Y��]f_+���t�Zؗ���W����gӹW@z��!is%� ӭ5u�lM�o��^aDټ�!����߾I���Q�".��m�̱t-���V����v�K�[Y��.�~�e�E*KmHY��kW�R9�����k/���u���^�^g����rL��Z���Vdi�W�^g��k@YzŲ4b&K/<e�5��}���M�>l��������w0�4�(K_��җ+���*K�Oe�Y{}��]�^���3�,������d�e�,}l"K�����إ��d�5Yz�+koc�>]����q��-�l���Yz�+q�HמC����jd��־%Xi��qrY���ް�_Xz��>�kO�Koce�=�,�ϒ�qrY���iai�+,�#���پ����!lnߏ�痖�7w<�x��RZ qZr�}s�CJc5�·0��دn{'{�]�>Χ>?hno��Q� )���������{8��b{zc���މ{����|���������i+�h�i����ר�9�h��V���oQe��+Y��H������:�Ҙ^Xz��͖�O����D���{8�|Jv�r�`��!N�L9<�Y[�6S�!������獴�<\�R�����P�<���yĺ���r���F�k�϶I�[�͠�9�<cHZW��P�6C�����TJ�@��������Rv�@b�j�M	)���o�Y�J�H�M�������1$Wԁ
���W�̚�W�T�����)5�J�1C@\��t*�ϊF�h �l�:�:V�6j �1���RR�@�բ�+H�\�@*�R!W4�x��$�
Z�S���V��@⣉V3�@*��V��i �l����֋m�F�h|Z�D�@(Q�$<���` �8����$\c:�����.�N�h �&P�C%W4>I����WQ���U��I}���N�h ����~����8�%���N�h ��j�z*:��1+J�l��
��1J�A�����q8H�3PG'W4�ؖP�H'W4,������5rE��+N�R�ۘ�85r��F�a ��.�N�h ��εN�h�\��Q�Z%WԁP>:���ĝ�n�N�h �������\�@�qR�\'W4�X�[��+��@�Uh�urE����UrEcMc��@�N�h��:��[|��$�q�N�h�kl1i�A'W4��~a]���N�h �l�c��+H�9�uFs�\�@��urE�u���:����:D�G�\�@b���N�h|k��A�hX\T��$��Z�V'Wԑ���M�\ѐ�B�h|S!W4�	�҈J�h��rE	c�:���~
����CrE��+��X�\QGj�R!W4z�����![��\�ԥV�;(��}�R�u�%|u�I���� (!2��彁BҸ��ͣ.I�o|Jذȷ��m�|��ƕ���5y%�ҝ�����)�At�J �
M�c"D+2 �#�t��z��h!;6_̪	B!�$CAz��#�36h��P��B�
���0t%8z��Ĉ^	���ᅀ�"iD���}I#iT��ӟ)��������$q��n�tt��Ϟ��7*���C�{��jL���6[����4�yq�Pr;1M����2>���]+����Q�t���2�����j�O~�ks)��P�,���/^�+m*Z�}�\�U|ӳ����k��ڽC�gV��}�M2�(�<$V�����/~���A�8گ}��F�4�_��E�Mx��.��S3|v׹��.����O�!~~����K���)j��Rs[���n'��<����j��V�
���`Z��;y5,�e+ٹ�Ʋ=U���R����)�R��v֝��ȕNhKh�H�p����G��,:�'�+f�+z�����׎���}���2ҍ�tcg���
~^)��A!k��q1=D��#�ؑn�x߁$_�4
ҍ�z��� kS���iTAu!�y�$ �`aӌ4
E��M��0�
�x�����b2$�+h'�����B�����Ʈ$%F��3����Et$(�|%�x�.�Q��J��N�I���t�#��IXt]�	��S�?��B�b�Wwt�yق��WB�wP�b#ۋ�ح��?�o}�������O�E�\����G����I����O��ŇS+:ݪŦ�bn��	7�L�v��9�����$�71��[�{z���̅��g���GH[�{s<ge'�,6�ŗ�jc�6��#;7߽~���^~�� ��C����ܻ'7�QU�����d� �������*�����M��[�������E�9���l+�%��ujs���7�Co����;���HZ�|f��։^{�Ң��0���l`�D�f0>�{���D�k1��U�o��m���O�C������b��v/ث�o��1^�{�G��]���a=꽬���:��b�e�����ݿ�*�.���������أ�?@%_e|n]�^��K��������G���C8+�������ڳ
w-L�A�;�A�` ��?H�'�����ܵ��pl�i�����    0#_\_@#_�@��#TW1�؏1?X���
�S�)4��yt����篳��'���s;���V����ǰv�i��;��q<��珻�e�r�O{lZ<���[�_������n��R+�P%e՘�Tr@��k�V��T��5���qqn�%������W�l�q$�K,��ә���'�Z%�Ԙ@nB��쏦��J���-7G����:��{������ל���[ʍ�eo�i�{�Z�]��zP*�H��Z��&�)��q����:E�h��v��P�¡C��a �����y%Pu%�Ǖv�7���C%n�c�.�RܬD5rC*JJ���V#70g�����El���	.5=����~��������I��R��(�Ra^0������w�P~M��g��^�ʴ	֨�Ah�T$��g`"v���􊿝��k��1�9Z�s{=���}hk�v��+ӥy�8ߥ�˕�����xx?���uڛ�{�ݷ��I��T+0cM|�]�{#��}����n���2k���1�(4��ͶV�@���J��>(h<�7�[��ЁP>:φ��ޜγa �8�>�	טγa �8i�I��0�XhxH��0>I���4Ԣ�l����Z���a��#����d^{4x6�qbKB�s�g�@b��x6$t�u�cV��i:�c�X��r�k�V��@❁�����0�ؖPoK��0,�zSy6��?j<F�aH�F��0�/N�N��ċS��j ��.�γa ��εγa�\��Q�:P�Z��0���s���������r�g�@��lH<N��<ku�U����
��γ�#�ѣ��ʳa�i,X8��l��� ��t��w\|ï�l�[L~�y6$�_X�c��lH,[��<�ox�Q�\��0��DC�G�g�@b���γa �Q�Q��0�X�����l���G�Go�l�t�	#�φ�Ux6�P�B`|S��0d��l�Tx6�q�wN:φq�Sx6t$�i�<F�aH4T��0¨}���Ƴa|S��0�p��<FoqT\��0dK��φ��/(h������/�X3Ԁ��Bݗd1P��m����w_��D�f����V��L�a�юY�9�d������̲z��ATc@2a��,�WK3Qh��W�1��T�җ����w��l���A2���0Ui�}3���}Ư�B=|�ؼ��W�����?�+�Fx�'/G�Ϸ��*�KvLli��x�Ve+��n���E�|lt�����%q�j�o��[s�WH��|\
�X?�؛f�o����%-s0�Ғ�u����Z�Gxr��)�h�����k��[�@����;��H�op�V���1=f�9�����\�A��*ǲ�P�t�����}wm�ﵵV�?���~���wNUlI���Oi9�IrJ�Zs�ټ�h�g�hhYZ[t�\HL�@Z��gi=;�~��gi]u>]��̙n���)�E�6ɭ�@�����n����Nڈc+`��`I�_&'}�~���}�H�)NK�$�ik���,���&���+�$�����\[�R�K�B��<����%�����c�y%&���(�TqtD�/�g�kT��������Y���w&
����&
~�	#LrdPd@a��!��0�B�W�2Qh��k�Y�{�[h��IL���o�4�|��1�(4��U�LZ��t&
��=��B�|O�`�и�L��{b�,�=���BuO�`��n�+�($��j�&
I��L��-"����B��h�X�D0 V0QD{�

��
&
��=���B>
K�L��C��E��B��­��d�B���;g�@ ]�(L�:P$�(4_(.2 ;0QH�,�rOv`j/��=ف�B����D�YFўفyf;5��n���JC��c�ӡ�Vÿ��j�އ0c�b���e��S�����ߵ���͘!n�����>r��u�p�%l����V�����*��#�w=��^�#�y��G��ajܻ�A�pV�nJ|�#�޻%���^ѿQgw;�^�]��*�q^����+��z�q�u�����A���v�v��;i�]v��g��mc(�5�0ǅ6�{
Ә&6g�t ��C3= 0��^���<��Mzڇ��g]�fD��+���#�G�v������v��ÏUr�&f,�I&��7�^�طw_GkV䥏�u޼w�L7�
Ҷ�������{y����i{���?H��b���o����Ơ��x�����Y16�-Ľ����+����E�ufZ��}�k��!?w��<|1���u^\՝=͟4:�@<��@����^ǭ:�G�ށz���������kо3E�n^�ۋ�V����K\�;ȩ�'3T�4�(����p���ù����_�t�'�K!�룇\O�Y�Н>�V�����EF�)��WF����I	mE��2-�#�^9���6�f{�R����o ����L�oE�%�vy5�>�T��i���ϯS[�}�?�6��j?�=N�=�*M_��#�}z�������@�����!K���\�Y���;�]���5.���"�uF�U�h���u�℅6#�͠n�j��6ם�Fl���u���F��� �+���d�8�������_�h��eZ�Y��y9�����ټ��k�ϝ����\�wڏ�������r�HRם^����;}��p�&��������׳H���s�^z,ﳞ�Ob��oݫ٭��u�~��T���$�Յ��� �v��=��#V[�i��it�gֶz�o_��c��]�?W��텮;��M��w���3ab/f]ձ�%��b*���Z�0�Q�5�Y�M��x|���M'��2(-��U�a���ն�jI�}>jp�+�+z��%���l�|�k��=� ������s_H��իo�}���<�t�d�+���ݐ�y?ްL� �?��딐��F�F��\�e~j�#m�L������YQ�Vݜr) >n��EI]N�[%����F:z�Ȭ���?S['����s^�j]��<j]R2��]j@�f�����8���o Ѥu$��R���&�����T�H>�C�.���}U�A}�H����zX�Z9%�I0��O���d �hL�V/��c��H���@*������@*�?Ra�1�
㏁ě�F�c �U�
1Hl��rJM��FR�1�X�Z�"�e��2�^l�4��ʫ0:�G�1��8�s�H>Nh�t	ט�c �8�ˡs�H�	��P9`�OR �*�UTC:|U�aR_E�1Dˑ|m�qR�A�1Ɖ-	�7t��V�1��S�9`�YQ
��HT8`�Qb�J�H�AZ�Y�w���0���0���W��8�S��c��Cz�Ƙ�8��/N����ċ���:��ċ�:�:��3pM��G�k�FB��0w���:����z�s�H�Rt��I�r��@bM�n��c|�qW�u�9`t$6zԟW9`�5�K:�! ��\poi�A�1�|�ŗ�:����Ť���@r��u�:�:��Ĳ����c ���u�u�O4��9`$�!�?�0��u�u���:��M�}���aqaPI�1�0�kq�A_���)��7CF
��M��'|J�s�g8�FG��c�Q�DC#��GI�bi0�7#@��c�G�5C��%����B��\,�}�w��q��n����Sj�c��^���=6��c,�}Y2u[��T��%d*���׳?w��%-К���s<k�\���Cl ��S�t�z����. /=�0�q�p�"�-K`��z��X��R��ݖv0�5�1qdd�E)M!�	�/Wh
����{��[�T�k�ޖ3{��ٻA�w�d�{c.���>�}��kH��8�(f�PG|9�L��7���#����L��ؿ{03X;�������}�>u_��D������D�ev��`��}��`��,�33�(���&
��=3���gf0���랙�D���/fgJ��=3��B�|��`�Ъ�gf0Qh��L� d  �{fu��}����D!��gt0Q�r�3:�(����<3�@2�/�i���냛�"�p3�(���f0Q(�u��`����kӹ럿���B����E�[|�]��kuW�q\��������U���\��6���}G��!aK��8��5��W����F����v���:��F���Җ\i��f�Wb�/��ksY�B�i:���,��˽�N�YY۫����=KY�^��e>z���cw~Z~�^����]��[gץ��y��g������xK	�M˯UY����u��rg猇����U����ȋ����f�.G��^�g���[�>�ڜu���(��i���Ez�UO��M��>r���V����U�C�]�{.{�_w(T9`��P(�;`�1Qhw�g�1Q(�vE��;��B7#v�z�d�B�v�N���9`�1�2�/��Ә(����iL�/U�Ә($yQ�g�1����D�Uy�Nc��,������@���B��mu��*TCstH��? �0�E_,����u{첟5Y���f/�����~��s@ha���u^�W���.e{����}����wO�����Vb9��������A�����Տ����#�V��ŧ}����ds7��wמ�N��d��<��ei���4���?�d�u�J}��f���^I�Uv�m4~�^?��xq�N�Њ�����y����S��.�Z�G#���@���S/�}V�>n�%l�^7��hӓ��l�^!�Ԃ4��ɟ�
��+����TW�:֩���᧧�,���Z���>�,{v���Z���"�^3���~�7"	���=x�r�pm��w��d?R���iE�ϒ�U'{��د�V��hᄜ}
�Z�8rjWc]����|�h�凸-�ОwMO��^Wd��j�ZW-���V3¼���^Ցm���U��Sr��J��u~���!�X�h>F�EJ�^T��B
��uI�Lw�`�g�����Vu�.����1?�=����3����mjO�OeZ�O����~?~��ؔhsG~#$u�7�GM���^���ߋ�?+��������gӭ�^��F�¼5j!�xe�{Dz��Օu��o���s�<_��p�F!��F���K��	���p��������4�����F����ý�?�<�|�`(��Ej�j�0�!?��#��%�}>�.����S�S-�J�uM�/�ΪU����?_���ѹ��YM}�o�dM���>�ڳ�nnD�Oě����/)^;�h�>�����=������.|7W��G�;�R���<o|�eմ�Ujw)!�c~~��ם!5I���L=�����O�.?>�VU|�n�-��/C����<y�#�n ��cc��"��s�O9�7�U����)m-���?�N��zZ���t�vE��Rv�F!�ǣ�MӶW��1u��'���>�=-u�η�����ҵ����s�/�{��;���e?f�$�')֋Yk�;7r��y7=-a��m^|�#ꉥ�^P�����t�(���F5
��Q CG���:j��Pm?���z���j���]�FGR��2��Y��s��F�>��~��/7��]wm7L%��`7z�F.��\��8sj']�7��Q��������������w�����A�      l   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��_9Z��4�H�ձ��L/�K=�������5u+      n      x������ � �      �   �  x���=��6��_�*��/RRw@����p
n$�p���ҝ�#���H��k�ٗ�/q�F��!��ۗ�ojJ�|8aZ�W�[n�9ׄ������Ƿ�az���?�~���>~���P���!`GâM�ʪ��W^S�y�����=��O�7��y�R��z|���&���:b�B̗B~~�q[�z�yպ격3����x\�����}6�\#$w'�+AX��|�E aO�mM�W!O3J�6�r>�g<�ʄuͼ2�{���_o0�2#
[ ��� Y���AX�1���=�#1��?�K-�g*1G<�/*m�(�ǥSZV��$Η���] �� �a� u"^+���7d@q4O��h�iWb��&v�\?�[��'�i��Z�G��l.�໐/-����f���h̅b��V�۷w ��@�Y�?����![¦�6qi�Q�H5�N[�u�Ҷ(�GM4if�`��¡&\B���oE�W���j9L�r�
D��d=}(�N�j&g�s�ۚe������?B>�.y��F�խRG���$Q�dj��@^i7.C%�d�oyԷK�ݴ50G3J�& ���%䗺]�oJ(@$���E�U�M�AF���^-��AM���y^IZ�Q�$wJV	���k�ϣꔧ��v��f(�q5(��$�K��Y��d�r����?O?M��������ӧ�??��>>�{|;�MJ�}�QG���;]�����Yw��HO��y�s���7 �]�[)e�sB@0>����d�m���.��)�/�%��T��ٳ���]�D�{�|
Z%�jN6 �ŕQB��N"��`x�6�n3�ŗQ����!ɘ���0J��H��H�oP�K�%h��ő8'����y�F�9`S<�s�f�:����ьt�����=Ү�,�|4O�<�	k����r�������֞�h�}�yV�����H������[9K�>��Uښ<��F	��A�ÅҀ'G�]yҥ؋�P��{�6gsZ�_�X%fL(�N�����j��j\R��m�८�qF	#Pv<O���ŘQb��,n�7w]��H�݋��Y%�K@��ӈW��+��/\TA������ޒ�ju�0*Aw�8�'ճ�eHڕ��:����vA���Z=�(A[3��hBc��{8	V] ���mb��#%2J�WN�ё��yU9�Օ']�z�XF��q��F��o�.4��<���B��+cRSb��������'��$�33JЕ@���}"���k���^	�rv��/ƌ��ٔ�y�5���.�Ӽb?��J�W�<;܀$|�$�_(��Ԏ�,��Ép{m�Ҍ��@I�gtϫ�S8�P	�+	�YA��n��v�W�|���*1w������yUY��M������=�0�3J�CG��?�r��������X{�e���P��]H�uԘԔ��_� ��7��      �     x���[��6���Vq6��/^D0�2@^f��Z.��TuPTA	O�ߺ�"%���.�_.�����_�#>�s���?���P�P����5˿���_Χ_�m���2!�Gz���oS~���aq!?b7�B�e�@B��a!?�*��_�_������ӧ�>����Ƴ������?�?��ݖ��M�nQt\xz'��.�y��BurG�ܺ
{��(�d��i$3�k]�%��3� ��g�
����c��u=W�����J[�ְhZ����ǩ�~|ݜߎG�"̢���� ��:��Nq��;��﷜U�â	�g�Zo�wwi2e*Sf2�0��~�^
w��|�2;q�&T��;?����i��[s�h"�����<�:�����і�,�bǥ���B̢	�g(B����e*T>���1,W�{�ɗe(��?���	�9��2��xRɨ��]E�5�2S)��/጖���	U�����)M(���B�Q��X�Y H���?>�1�|.3�6��3f����`XL
���+*왿_ڄ�M�j�ch6�e��>-|��E���� ����(�����E��g���c\��B�0�Ǌ�j
Jգ-�,�THL@	��M�(��Ѧ=��.�!S��Z��EI_��<�6*�u������@q�}%$Vo�d�}��ѹe"�p`��7��E�Y�]Q�,�e�M��
��G<ע��q��}	�Eh�̖�|M^wM�{����t����-Z�
�\P��[`�HT��VRy�����,�H|���&|�6���5���xO+���$R>��M�'N�2�Ge�����ns��cM �[��w��!A�Hc��"��kfQ�{���+��P�-��,z�Y��'�^���Q(!<E0�#��LقO�g|g�z����`W v��b�3
1�&T��!�Ι
�a)�"R��� �9�=�˽)mxp�i�h
��������nMy?"Q�"�n��D2d�H�-|^d��5�B��n��&~��'�����@����;-{�,?w��`�a�aC��,3!QIʁ6�TjM|QB����g%W<���@|��'�-�@%��"���g��&��M�Oc��ߑO5?���$�P���a�+#��&�^QF����#2m�����H�����M|qw$ץ|yw�/�G���^�8�g���������+��/f��2J�d�w�|��y������"��E�T3�57�n�=_s�<�k��������эwE���v�h�� B7�
���0�a�k~+��X��J����E�B|� ��%9�����"�<�o�e�$�uRhM���:q�3�����J�ɕ��$ ��dZ���.��D��ο�wρr��+��p{5�������汍/�n���A������6-$O�L
��j��67�aф	����c�������urAq��E�̰��"1W3�����i�օ|�گ�_��_)���ʙ嶢)'g�q����8q��Y4~'~B��Ѧ�AE�\L��|�O�<�g�����)��d1�ٻE;�����W6�������jLJ[R𶓍�%2�6�#>�~� <�I�,\�Y4�@RI�r���KO�2S`nW�\_�*#�-�&0�&I�� �䴐_�/�m��|��u!�c���j�{��˙3����dQ�řEK$�\��*�qbI+fӕY4�Ld�5�#��d�'��W�L�,�_�V�	��'���a�*)0hh?c�+�0�h���̣M� �~�w�M
AiA��gp~s"�a�ߞ�u����B~��?/��x;A��H��I��?n�����ʚi�( F��o�Ab;�����P��q��q�D(:�(�n�{�`d��kWs^����°(
ɑBC-�M���!NF��0�q��@	7;���/L�W��E�$��z�ɩ֛��B�2�Wl�8|��>�X�l���/���O�"�����%���ܢ	P��;µ�#��ͮ�q��?!_l���̃gUf(?�헔�i�hTx��0�2m�
���
4e��߁�iI�e�#!c���,���$�s��@5;�8�ZY�L
Qq�G�ڦRI��hT"�C�0�Cn�?�~������6%��O��6%�Žp� ��Yz.���>������x�ES���\��}4��u��ܢ)Q�^�y)ɔ��O�WVl?��+!�$P@�ӂt�D��,3�*�\�&~#Q��;��X��	T�$�����y��΋��^7�hJ�Wн�rڤ�n��������2S���.��2#�Iw}#�|��H��b������-
?;��kY�I�����`�7� �ś��-�e������,����+����)�,��'����yZ��E�G�,���읗�ҧ<ͤQ)�G{�#PE���	�,3�R�B�2�hJ���P����U�$T�%r7���tu���KW�����Nr��ܢ)DR@WW��I����oű3��|�[4�DJ��n����%r�	d�U��)��sˌ_��Ď��_��g9��r�6�U~x�[4�LR�g�_�z�����߇U�h�ݢ�j�.f�|Q)��s 0��V!�-�Ie��C��#�4�JY� {r(Х�*M��BM� �8���e�Pp�+�
w+�$��/ݹ��a� ���0�:�Gw/u-�3/����<>��W
�M��L ���.4�ďȇ[�V~�n���*�Q@FS������`�,3~E>E����o�O���&j�g*\��[4���]���b��	ƹ��ӽ��au[��,
�8�{��)���/3%?
~�k�'��_���~��&�y�[4)ORE����{�w"v��d�tq�h�
��g�w䫯�U�|-���ȗQ���)_-? _.�&~����$�DC�s����&~�Z;QS�-�B$�h5f��K�3fȯ2*��,�@"��3���$*�O���{�
�7���(���/���vø��K_w�&�I ����L�|e������߰��)V�.��ʞ�{
vr�|��?�T�U(�!W��ɉ��ES(����:�Ōo�]�R�1�&PI ���:?#_���U����1�U��|8j�Q�2ˌ߀?���U�cC�2d�':J,C&���$S>?��W\��$�T2���H��t?="�{(�>��'��IbM��PB!�	Zb�(@�#/��++��_�fV~C��5���O���%�K��tJ��,�Tu�Tߜ�}r���w�Mɓ�%Y��)��-3~���<�&A�CumJbL:l���GB���_��E(��+>�����͡'r�&H����Q`S�b0�dRh������W�
7E����?�����*@?jj�G��L+?�0(��$�Q@��6~Q`���ܢ��[_o�yt�Jð�̢�Pm�Ȅ�ɇ�߁?=�5�t��G�6�G>��o����I(�x�B�My���	;���|������jj���Ə�k?��_��n},��|� <Z[B
���|�M��s      p   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      q   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      s      x������ � �      u   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      w   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      y      x��\k�,����^�l�ū����u���B��ݱ}��!�Rt<�Oȟ�	������ӿ[�7��ٮo��r2�8��2��ߍb��5^�z|��0P�O*�z~��0P�O���o�X��Z�=(5|Sf����o���It�R�-V��X�H�)�5�����4o��z|����=�}2������W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6쟴�c��_װ����0P��,��b�U�>��b�ũF|R�����6��DS��)���j�ix�D��6�C���u%��.|bm�\�a�bÖ��VK4�S�Nm�,�0P/�k3�����^�bNU�D���bXq�cuJ���ݖav2ŻM�&��z3��À���ף/l�cu�sS�0P�sZ���9��1ba����X����cϺ5�)�H���A�7�������^鎭Ͷ��NѰ:M�����*~cb:�&њ�Ś�N�u�[^,b``�S����n��au�qX?���`��vzkv�����B{����O
3"(����~UC�ק������t`��Ϙ��.ad��J�4��'�@��n�͜�VM"�8�[��n�u[.�7���z0�ԛ%���ߺ��Y:H�ǫӋ��Yt�v�js��۲nW�0�C�\�ځU�/3;3l����p�>���t.�/�Ev��]�1>4�m�b�u��Sk3�"çV�F8��X����0F�k콞3�eo�{��^��ᘖ�t`�V3�t,W���r�����L��Z>�~lڼg2�R��}DZc���J�e�Y�����0P�حi��ԝ%z3���4����<�%.�=Y�7+��V��½�)N>1�6b>Q��q�s<c5~��fɍ�a�fqҥzH���0���"�V��ܰJ�0���f���i�4�қ�5�0Tu��ͯ�a���6s�h��|�a	��:%k3H7�R����Jk�<��@����f. 0�K��z	.�_�as�W�8���>o9<�B�a�@M�J1wCs����彩a贈c2_K�i`�T�7J��C��8%K���ڰ��V5���X�:����9����U�~����s�;-�OT���00O��~��!��}iê�_�"����)B��{�bX�����9gXeNM�3�%M500���!ön��O�5[�{c���W���BX<���W>�֬P�w��ŋ#�ARjN\Wu`���p�A��1T%��ԉ^WOg �%đͧ���$ő5��J�hq٪������KD�Z[���^���v�+��ڎ��00�9J�a������.�����~k�V��0P�%�(g5	ð�3��<)+n:�*qeE��M�qC./�M�l��S��^�:�{a�0�Hj��5}30P��d��>M����!{�BXlZ�jO�AX���Y��pd�E�$�^C�n'��}o�i]W�0M�;��I|�=�Peĵ��b��){q)��Hγj1�n]�40�#Rk�D1�]1��9({�3�R܉������K:p`Ps��Al��6Q��
�\��Ƒ�Nw�3�0�'�;����nf�R���;�fn��� �0�%e���"?�+���!d��{5�$(wm6�C��`b��.�P���Ln��f��D��KP�d����`r��jow&=��N\L0���u�ګ��p����RNr�?{P0��P#D��2����Wi)��
%8���� ��YS�5?a��� E#���]~60L�ŮI��&�4�a�E
P^�#�m���[C:ƚ�z8}��0tzIɥ.����r�i)��[�խ��\q�a�ju$��j|i=�e4�(��������}	���O/qj-^�i`�)hv!t��%·�n�j1��۽�e��BP(A�#��3���z}v:M��ʆa�qR5�g�9��[�!%oÆ�W���J�,��AS��j�Mm�����N��|��������z*#�|y�a��ip�b�.�0Pi�Yo�z5TZy֛9��0�9�Q�z��#V2E��a�M��?��Yg�}bmV(�y�Ek�T�{,,���}������6��J���\��o4��H��5�600E�U[�	>m�G@�?����[٠������t5#�n��%h�J��B�ټ�i��V�o�a�Շӭ�25��J-K�b��W�^��A�D��Y0˺�����Բ���*$j2L�7y˙C���K��׮�2wR�%Zى~��~�!�&�.T3�(;k)�<_�S0/��*k�-9�k�z���p�l[M��*���5uk͋���z�ץzU��k�̣a�JMe�(�����Z��j%5��ن�*�/���1`)�e2��G<k�DG6�;�dB�[�K���ֺ�AR��IԽ��jPe��FԘ��1�� ^�E��*}��9�.'�Bq��	v�����#���7'� 3��$��8*�Tv��eG���ʳ����s�u�^"����{���!�7��z�%��5��')�l�~�0�1J�,yH��)G\�k���ʛ�� '2�n���1�K�/<_ok�S��%��%��RR��19���î��=�r�a�f���W*-	�ͼz�[��Dr@�^rU�~m���'�a�6�_D�z��o�ٌ�����L�ڝ~ ��!�Q1�6�6�7T�(S�\�vo��sf�ᆁY��%��1Lu���+��~��H��V��Pf~8�N��E(�-�t�a��5��PÛZ?�'=[��čг/���;#�[�(��gi{<�6ܞ99j��鯘�7se�A����ݐç�($���DL�@U��j3�ky�*sT텔�ֽ�ͨ�ᢠ~6u!��?��91T���6��3T��&�d�g����ڞHQ*���˿K0�U�z�.��ϫ?�C.�c����j�k����Ϧ������#1#y��A<Jg�nı�D!1̩$
7T�2-��^���K�L���]ʙ���H��=��`�z��M�P��擏���;/w���-�f�$2ےDgu/k�S����L�$:R%a�C�R5,M@!g���~DqR��A�P1���0P�p1y����a���+��2膡�"�6s�cأ"�#~l$���0P��s!BC���l�k!�S���XW�c~��k�����{�� 4��W�:0d�ӧp�����0���o��7��6�%�2�|�]E�$�B�\U����P���5 U�V�k*�5��n����rf������R��5�e%���㶍a`�'=ɛ�a`��pM�Y�0P��`��3-;�'����A2��G�^�����d*����q��)�Z�K,S	e�/�2B�Z��̼+gqI7�>��f��@�+jͼ�ԫ|��s��;���Ƨ��|c�E����S�M��H���k��.W�3I�Oo�,�i��7f̼^n�]2�w��w��*���V����%���K7�aE������0L?�QoE:�'������:�eٻ��~���hk���@���A���F?��py��
��r���U�$��ʭ�[(7�XU��&�0p���@a��5��K_���J�kx$�̮�b���L��/f�L?��5�"��V�55�]2#a��L��zl2O�<��d��d�:_3��ǔz���TUi�����0P��g5	jt��5k��k��k��)�;c/���)jY"�_�^95�=c�����j���F��0�Ms�۫��9�����P��^��QQ��/Ԥ��j��@͊Zp:�0P��N�煁��<f�!�uU2f����@=5uz�ꥩ�M���Il��6�:��;�f�a���%s��f�ݛ�a`fɌ��,��VK2�]2�!��aH�?q���<%3���u9�q�V�Y�a9�(�����0y������-�n������ 
   �?����G;      z   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      {   �  x�}�Q�,)E�_��7���i����:�+�U��7�u�ۀ�Z���?Z�����#mhzP&/�\`�2��5�QA�=)���Te��A�T�{H�\�N"С�2y]$g��R��W�}KM�ߓ%�u��j�<���C.��g�#.��6�S�߳5_q����~o�{�߳���R�&�+A����j���&���1J*�d��ߧ1lI�a��)
������=�����֓�T� `��GI&����I�4����h�M��d����e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�-҄�$�6������T��8s�[M�CH,�֡��5�R0�D����`��I���y���4��Q8s��U�q�/ ���,���!&��R�����5JJz2l,$rŰ�CO�����v��6���xYV7ֽ��  !�1����JdY��JC����5���$ザP0H��[C0��f�X��ɐ4�5ܘ6�`�j�L��lnԔ�dQ���>@� `!Y>��[Y��x��t����<L�auh�-�'$��}�w�/�1������p�Y0��Fԯ	�1Bb���y�dǮ�l
4	�{H7� Uz���Ӹ��� Hupc�[�f.�?��AK:�q7� ���������l�lo��A�zɍin&������&-~���i7���^��#w�,6����B�ù_n�X���vp3l72��2��J�����f�B�3<�3��
���`(���}0�ˡ��0���B�qu���З�����%ݗ^z0x0.H��:\�o����
$n2x�M�w��nW�ۘ{���y��]��#E-l.�|W4_-���rW���C��C/� H���mYo��R���QiD�����ZxH���^��n�e���O ,iY����4qa�A�zi+	�F�[�ш�"�K��/=i��Ɩ*-�nV%ݪѭU�*��h�`���n��{2X�u�n��O�puX[�pb���}0�]������2�"�0�E�s�^�)��G:^�?�vWA��F-G��}Y'|��+��Q���mQ�{�X�ꣽ����S�w�W�P���@�����VA]Ǭ��ѕA`T�ݯ�Fk�&��y�^��{�       |   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      }   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      ~   h  x����q� EϦ�4�`��
��E/X������A�A5��H���{P���3��{�;�G�hh���(��s����R�I��t�HѤ\V�\��7��L2�XiW�|��UtАκ)P�{�41w�%��K4hH����=���+*4��7w������y����2͟Ahr�r� Ӑ"��(���4$j�$B����L���ۻ���{&��_��S�������:���ө߉�@x�)}���J��i~+E���+�r���2t_��'�:�'�$�Ě�_�1^��6��FW/��LC�Y�h������Jtd�J�-�(SD�]�Ѩ�2ų�ݳL���L��n*����V���0�ۘ������B=�O\ڠ�'�d��h�d����LC&� �"�D�htu��δP��籦
~e	��I-4�3'Ui��O;z�<�؅b��}}��ʻǔ�(�J^*u*:���:y�H�P���$�T1 js�?�+�^y��'�!v��UY(�՘,O�6���<���xy�]B�ʰ�֫v�A�{�ŉ޻�АvB�.A�!�;q2�v��+N��]�?QL�M��5y��֑�����盎���QG����?xAZW���&�z�cŠ��FE�
�H:;�c:Y�Ӡ��d����'O�WR(:�X4�%j��h���0��.�P̣�1���2�^[uRP(���:Y>A#���S������T��V�?E���XR1ze
)H;��q$%e�h�[y-GE��ybxL��a���_��2E��J�$z�P<j;6ɶ������-��-{�H���Hj�B��5�y�Řp:����"xYgG(����LYf�B�һ�Ө�%z���A�Ե�3-��a�9
���,Ct��E�,K�*/�E��x�8���j���Q�8�5�@y��$/�;�����K(R�N�<��B�YC'
�J{U�*�P$�^բ�d�w8�m��ǳD�[�e#NQ��Bq&86ޔ,�48���d�Ve�4�>�i��ַ&�q1$�)���W\��(]���5D(*����[��P�65:����Ъ;\,�U�Hhh���2����C_ڇ��e��1�s�8�F�r�)�+r��	T�Gh�4��,էP���=橦�P^�_�h�c�ʒ{����(�Џ��q�����/��Vm��i�]�3㟫,KҘBz�L5�jP��=ky},E�y�ZYk�P<kt�i��u5����R�+����ͅ\�w�U(4��P���9Q$�>Y�SI(����N�nY�µΝk��PD�R7�α��SX(��w걪8��
'1\��lZ���n�Ъih|e]����dZ⍯z���X���j$��k��BaL�w�)�P$�޵�Z.4|�	!� _      �      x������ � �            x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      �   �  x��Zۑ�:���b� =č`��J`�l����S�_r#$�D5|P����x��Ey��Z��'Ǩ4�縇�}R��$͟��e��I�r!�ߓ;����q4�sީ-�I��D$b$�Ir�׵A�$e'Y�uѻ��{trԵACK6u��ZsQ6N�u!�zH9��v����AR�!���m���\���rm��$nA�(�{��ݥL%�U�t*N6	_���{t2i�(�ҖlʃM�"���C�#1GV3Ȫ��yb�ѻ#J�� 2��O{��Vw(2�X������/2�0���x6�7 �����p���ٿ��r��\�z���A������@_!��΄
QP�T��P!j��xyX�m����DT��j	�AB�B̀���:cB�{B})��1���QC*�2*Čz��M^� �B����sAݹ��\P;(��*z���������lO�F��N�EĠ�f0��,[GK�3ϭ��V}@MU-E���я�`%!�e��K����y:����N�H]
Z��ٺ�s�0E�2��O�� �KdGoͽ��{kڣb.\��qJc�Q:�jf��
� �h�L�u��w�24L�&(I2�@�C�?[U��^��f��󑊼yŦ�"7��j��Z��{J�; y�&.�I�VN��m�lU�F�zJ(�]fk��Q��dT@џ�Y��K
�YyFN/��7)	�N�_��������8g1�͡�x��u��K��(�{\T��3��K��� FE�,�L#d��ͬI��$z�3�e�`z�C��rm@sf�?��/�������O�3;���-?mE������d��u2��o3���j��4�VK64a�/⬣���@'�l4 � �k�zUyR�6��L�����q����:������(Gc����ژ��G�}���r�`���ё��P'��&��YL,,��@�O��0��k6�h�Z�֤��IC�����Q��X�s �r�9��	X�%2:`BՈ��L`���D�Q�ё�c FǂBh=���a#�xT1g��k~qiH��� �7������M��vW�"�]����{�yK|�H�d9թe�����q]�Ҍ��-����gt6ʂF��${@�:�����N��	G�����u2�6��v��rDՍ�qE%o8��/ ���S����ۼ��4�~G�A����$�����B6�"je�"3^�P�x��[�lX ���hnхR��5��TG)Ώ��잌Cy�J�M �A�k�̩Vh��==�����K��(8���F���R ���^��E���!K�Kb�&����P�S��NolG��j�t�-��h7�CKBGq�Z����]��҆W9�m �d�ڳ=f��~UY͒�MŅ�t D�������;���x�lH��O�'��A2�l/�רW4�z�M.�é+�0#��&K�����@k2l���⡬��0Xz�	�^��\_MH/=�l���6���'ۓ��b�����<����z=��/��QfUQO�����6�z.�,G/׳M��9J<�����M�XM���l�~s�k�H�+��;�|�ilyt�Dڑ��U��Û�|��ꥀ:��
� &�:(%�%Z5���rN�l춵��-��p�����ɁΊգ�������s�

H�S[�d��h~�c��?����?������ �      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
M����{B8 U$�      �      x������ � �      �      x������ � �      �   �  x�5�Av�8D��a���]�����"�����(�\�S�s���.셽����|~�a���������!�&�������������ѓ��������`Ϫ�����6v��ƞ�Ux��g鹸�U'�%����5+a!��XG��b�:�u���}y����{�����(Cn�ũH�ҋ���,�Xn��*���<�O�����l�7���Ml���6Q.}�����x�ů�!j�ZD-�OYD-�Q��E�"�"�b-��(֢X�b-��.�(٢X�2-ʴ(ӢL�2-ʴn�n�(٢X�b-J�<"J�(����!��-��(��N�B)*�(�P*�Tڽ�)}�ur�]C�lc{aO����\�6�?��߿g���h�-��Y�ۃc�?/��w���l=�n�����^t��}��S_�_�]�]>�2�6�6�6���}�m����d��n��&{L���1�c��,�Y�<fy�򘥾-���m�m�m�m��e�����m��6O��?/�%^��xY^./��ǋY�,e�2K����`�I& L@��0��	8p&�L���(�7`N���6y��	�0'�M@��s��	�0'`N蚀9s��	h�&�^0'`N���9s��	�0g��ا�q�i즱�&�x�����,1��91K���Y�,m�6K�Ţ�6K���K�����Y�ұJg�iy�9f���kގ{�:��c� �ۯy��5��u�]�ۋ�����/��l�}\�dl&c���g6#���l^3�'�	h�Y3���f�5�9��iFN3r��ӌ�f�4#�9�7�� ���@sS�MA7��߱|>|����%�5�5�5�5�5�5�5�5�"�"�"�"�"�"���(�Y���C�N!C<9�p�d���H�D�%-�h�DK$ZB����D�%ڬ������6k��������ms�]�œoN���>��q���?����k�3hv���v�*��@x��7�9�@�k���a��c��}��Dm�6Qύ��Y��?�:{	ed��RFNIed��VF�yc$��9F��c$��7Ff�Ad�5F�yc$��9F��c$��=F��c$��AF
9d$��EFyd$��IF*�d$��MF:�d$��QFJ9e$��UFZye$��YFj�e$��]Fz�e$��aF�9f$��eF�yf$��iF��f$��mF��f$��qF�yf$��iF��f$��mF�9`$��eF�yf$��iF��C��?DD��CDYD��GD"�D��3Dr�|R:)��L�%���6Y����F�O ���0j�ѡ`20	���LP��z���:�-�_bYǲ�ew<�u,�XJ��b)�;+*VT��XQ��b-�S�E� ���_{�-Z��;�=��4��hO�=�6Y{(m��g���'�Zph���Zp��@�̯�빯���m�U��X��ЖV{.���0�-��f}��^���#�`0��#�`0�xt�эG7�xt�эG7��#�`�R����D�$�%Q.9ß/�ݴ��7.�3Z;$e )IH�0%�9���[f}�g�0P�aP�O���><���j�E_-�j�W����ԇ5H��(#�)�OA
�SП����d/�Jv��d�Fv�Mi*HSA�
�T��c���?���w���O�A�
U�"4��QeWڔ�䯯;���G!4� �j�ڬ��!x"�4�k]��ϋ�l7�����l'����-l�����k�ڼ���k���
v,Z�Z���o��Ҡ_�˶���.�����@�Ӫ�q�6v�K��������m��'+:F}��c�dX�1,�M�Œ7��s"�5J�J�Ш3ʌ*���.��
Sh:��|tB�6��j����Mec،c�!����sh��坘�མ��Q�=Fɔ��d��c�Ce�@�?M��'��iA:��?h��V؞�?�_��T��Ԏ��T��ԍ��T��Ԍ��T��ԋ��T��Ԋ��T��ԉ��T��Ԉ��T��ԇ��T��Ԇ���B
C�"e!U!E!5!'�����������������z�r�j�b�Z�R�J�B�:�2�*�"�����������������z�r�j�b�Z�R�J�B�:�2�*�"���
����Cۙ�������$+&Y1ɊIVL�b����d�$+&Y1ɊIV���T���~�w4��      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@��w�B/�0���ͅ)$�[�@0�B����;v�V!u��?���ψ0��&o_rX}��y=<�7燑�&�Y+�%E��4j���8,����W�����j�8.6��H5rE��I���X�b���䰸��a�X�����8�����n������]���,`��g[�d0�Y�܇��G·�7��`RR0{�LA����!�	�y�}��E�/�b�9� =mC!�����5,����b7U���Zũ�JS��+K��S�5�u	�D�@:��.�d<�b҂aO�5Z�S���z��î�l����ѝ�V��Q5�C�>�S��Y͐Wkt�cB��gV�c�Ig�Ԅ��Ğ���}7���їh���y��n�۹��Y�X2�w�'��PLT��H���`d�un�#R��c�Q����V'���sB*������=��/���-�=\�o��R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-�����s˒ǵ�w�Q�l��K�����0r�U�Q�"c�L"A�����W#XxS2ѫ#��	��)˟���]ۀJ�W��$�>��+N����z���6�0�J:ϽM��"�|lm���61C�Hy�t��bW�]�`$}H�к<�ZҗO������C��؅4?�6�c��}/J3�N���;�`�G?B�K��}�V��,={/��l��=�
�g}�z~�<`��A>H��^9���5����L��p�� o�1��O<�D�|�s�y īD���q�(���O����Yc�^C��Wޒ~�;JE������+����Zt�h7ʊ�Z�JQ���A0E}�{{�z��S�^����z�����L��"vZ���=M��0��[��pz�zєn��jɼ��i�RYaQ+^���V����g�Ѿ���[Ⱥ�s{3��Q+\#f���:/L��4�#������X4�6�2|�v����b2�e]
%_��"��˦iА����K�mJ$���*cG��%��3��n}?���a�R�t+_��L��d�qw�ffrM�s?�w�w�@��*���c�^��5�^s��@m��%b�pk���?vڒ�6/�X`��۹2�{�-C7�آ #�H��/~��j�ΐA���r�0m�;P&����+ZS�Z�_R����]g�E�
t�����b^iK^+#>�-s;pӞ�F�v0��m)��3r�T���[:X����!A����H	fOs�����K�=`h^+E�;?R�Ɇ:`hH��Gq�ۘ?Y���n��қE̦f�����2Z:W�H�+���wꢬ3N\�*����X���=A��S4w���r��&�qᱚ�@rM��:��|�_�W� ����ҋ�{{S�[ǵ�ֹN�V�-��0����Ǘ�Z��u
�C.�?0���m:�@�3�q�c�2�R�D��ƥ&1�M���1?#R���y,/�)���s���d��ʁ`t!�;��Gχ�{O� H�N;�>\"tg�	�)�#��2Ⳡ�h�Ji��^���ʘcg-�cdϬ���%2�ҽLdK�<[��[c���%��Y@����z�����yisM+�J~���y@�s�+FI�xL���%&�����L��Y�J�lz�#i�+���H�?�fm���טs{�� �ѵ�x{�<x�����X�􃏈��k׾}����L�!5���i�"ш1%���16��ˌ�	v���U__?�h����]|�    `�yir����� H����g_\~)ˀ�_�M�o���e���,y ���V�͒����?@�XWOɽ�?��5���
k���@�x��w���2{:P�푂�髮�C��&�s�Y����9z˗�RĨ�3�uglO��0�-��2��jy(����P��[�bڊ��Z�tQ���Q�l0��V��[K�0Ն�BR����䭎-s��6Y%P�����<���8Y5`�bi��z�=	�#&���c�p�,s]'���ro���$��p�6�����m�D(�v�(��sox��V���鼡'�Q���I��{��[�=b.E�.}�}=7ē�G�F���������t�_����&G̴TO�M0���"�0W��r�
�(M�< |�����ģSLۍ�EYFb��kH����P�=�L��MyX���l
��E����S"�lD	����[�cZdd��%����Jl��ä��ZJ��m��x�Фw���a�}�bOU2���Mz�3��VK���r��Ӥ��	�����'�f��1����t�2sZ�Y�f��9����K��A�Z(bl.�v��9Lz���#�G;��d�l.䁂8��}�<,�1�Ҷ��/=�#	�(R�u�o�Ƅk��QK��%&��'���������jр�)A��o�/�ʌ	0�j�+����������Ğ
e~lK+|E9�l���{*�y��e�`$Es�wOiuԍ2���ey��'�;×��GǷv�|O�b?%�M��0��>넖��ދQP�:����ple��Vƭ]�ʇ0
z����t��ic�w
)5͗�tI;CNZ��7�uI}�ZKĴk�6oU=]��{�`F�6&��j�_�����H��S��{�x��_혴G��0H��u�/�����K���<����{���1�|ä�Z{�4�F'�_7H���r��������!�O4�˝v�ʃ�e�c^o�W�Q����]��ʁ0J�P���Ф���.xM��Ȅ�����{�g��ѨZ\O|����ۋҖ[�NIW����/��(���o�'��ݠم�y�;f��PӪ�=8�ncsAp�;��O�o�(���{�Q�R7�=Uwy��-Ѿ��ɺ.8�f���A���mA�ț�i�)�9��(i�D����%mʻ�,?���(K7z ���҅��i����t_G�:ʃ��@�Kf����M�=���t�t�PO���˃�{O��{�%��88R������x��M��^R�F�f��.ǖ$������6=����d���{�������Z��>4�eC�PQ,�#�
#�S�מZ�jg��49BT>l�@�hޢG�{��=°�z�Eh��QMk����0���-�B-�N��F=&�1��v�&��ɾ{JC�����(yp�K���4�_������υ!L��Q�SK[�N$�}
	�"�z�z1��Ŗ�^�SIq}�h.H��=e]:j��23��%����\�s������i��zM$�t2f�6�I;XO���z/�����;LG�{�0K���zO_#F=��z��M9��P���Obt���ne�[�ל���<P�[�E���{�W��0&��0�f��<_�jQd�y�)��V��
�LSMѻ�&ӿWc����tG��Zy˹u�̟��4��U���{Oa�y�,���}������|�Bɜ�*�ŏ>"���+z]5�+�{"t����Zi�p��Z�����C����eݎ�o��?J��ۋ���6\�~Ѣ8-2�?��2_e��)��m)6����
�r��8b쾊9m^��Ix��00z�����Sh�IĘ�W$���,g��Fyi#)�?��)�����[��^��F�����Yr�i�X+�,W��1� ���b �g:`o�C��A@b��q@��w�e��7���j!]̛2�$�-S�-�0i�����l�a�;�Yx�Kq���<��U����$?ʒ�-Y}P�!�wK��ר>ԑ7�}~n�[/��ߔ/��E!(л�@�\��Y�,�~��/��Nʋ$O��h!PT�Ȼ�Ҽ?u�t��]&���qDy�/�d7�Aeq�)���q��h�\������&G�Mw����#W�7z��y>�{|��m6��mO�;�=�`--k��k#HӶ�{���Z$ۅ=��w���ӤŚ���M?����8LO�j]�	+x�q����k�Nܲ�~^��޻�w��V��/�� �~�[_�&����~��R���|��!�w�0总M�_$>P��C�����g���/T���3|�e+HP4Ӳ7V3��b�	s}8d���j� %�B��I���0����W�
�x&���O3��h�8F�j�
!�r���7�۫I{>*Q�X
I��H;̃wd�0�k]Й��N[>N)����%���G�5�B�~�q'�Ǧ��gg旂Q�nc�C��@Ap�_Կqf~)�����%�?Qf�F��<�޸�0${���N�^�B�{
FL4_9�X��/:PPQ���|�
#P�*�Z��m8�O:`����U����I;삼��@/���j��ð�-T��oJ�9qOY;i(5O�oo
���o\�*�e9���p��i�4�Z�V�������0)�~��o���3d�؏��s��h��J��67ۗ�N����`�.P�-7���w��k�t�T��|��.ʺJ��[nx�a�+ߐ�ݚ� �\���n�-ey�}�q���y;PdN�Z{�����x�����e����փ[*X)Z�k��
	��x�M�q[�,�#C�����3��ǣ����%�qԿ��g���J�q�Ë;������\��C�ۮZ�|�16ĩ���n�\�)�I��'�=M��[
ꝼK��֤[�MTDX���Y,Yַ���W.r� Mه-���O���S*Z�(?��x�E��V!��]u����=b �#��t;���v���|�)_��c��QE�E�n�6��וp�\WyL��z�E��ɣf�|��7��Ȼ�*KĈ��m����s���S��b�M0k��<�P&�O�{�1�B�l��Τf6꾃�9�|%b��y��G�ձ�pk+^>�б���C�m���蛎�K�����L6���٪��|(��V_�L�N<t�0��~R^?8PȒ�Y���|��,�,�n�<���_ӿ��VǠ���C�m��e}V�)��a�۲�*\��<,�)�^��j�s��{�����{���nH�X��F��6������4��&�S��3��ƴ��T��J	tf�o~���gR#���K�a����-��D�q�|^���;C0`]��fh$m�w�:-Q�O��D
K^@)q#�5�6����F��'�.�sr>{H����Pɋ����kUeyX�)��!���XIe��>h?��V�[c�11��N�s��{�r�&�?�M�Y[щ������w?�.J��ҋ�����N�>�|�I�Z�״L�)���Tk�R��sL����@���W�\4H�?�ڌm@�a��&V��f9D�nV��w;`Z� ϼ?IF��kCi��`���U⮦/��^�͐���c��n~�Uʶט�Cg��e�[Pщ!NG(٤��t1��ցyͨu������"��#�	s�6-���"�̦��U~���ͤ��ٮ��G�L�����_?�͒���C�1�#���5�8<`{��;��I�_*��ŗ6��S��'�P����e��}9��<Kg5F.�Y�� ې��h��6L~�ܟ��R`]F�ſz����@��M�}�bC�c�jq%������A�(�W�� ݜ�)��~�ݚ�7̺o�S���Y����Q#��^.��@�y9~m������fy�%\ᗟ�րy�HÐ5`��O�5_�^葭�[��`����,�!��&�s�B�a�	�������9�}�Rx�|���oNZ��z��C�ށ�'!����1/�vQ.-m����־Y5�,�|!e��U�d�O�;H[+��t��i¤q�@Y�����-akw$�n�P����z�)�����<Kx    ���X-8QT{��\?)�9jN7h��{O�^�]�G�t���V�k�hJ�c3x=�M�ڢƆѴ�����H)F�C����o#��X1^�j+�y�t��~Sr�Ag�	!������,#�da�����Y���O�W���޿)ϲ(�7�ے�g�5R�u?"�f>��163�&��6��Z�#�Wg�a}����+xR�4S(�{�8��eF~x8���&G�Zdm�ߔ/a��n		*s�)̃܇{���ݮ�|GALqe=�48�|}�)�"|#��!�����۱��D��Y�)�wD�4����H�j�N�'[B��]�!�km[����w8`�5�q�īS"f��\'�mxhΛ1b3���I���f���7EOGe�#�q��;��.��~�7[��	����v։2f�}6F:��D��0�%�=����`�t��d��Cv�y^�My��7H�$F��q���6+JC����G�1U\#~q�c�k)�� ��ǚ��g�j��7%<�R���'q�o�!/�F�4}�������k]�[uIޒ�J	���K���I��=���ߺ�x\�`�Ą�Q�$c��yGӁ2[�2�C��'�B��_Q	9����BN�e<t��R��~�>4�(M
����vK�J��ZA.B���e�А�Q.�yKA�H�0��7�Rȵ����xm��'��"�Y����� �2�Ɏ�Cv�3m�CS��FHt�S�W���i��>(��7<�Z�S����M�j��R*�������m��B�E2�o�3��c��xU|mǀ�fI00"/������o+#P�����v�)�y��.��if�� ��0�c4b��]ǛҶ��Vf�s�&ڞ&���Z�]sȩ��ݒ��k�FL5�.�7�K>��1&�^1�yL�A�<��/H���7�u׭�H6N��&��'��9���r3\)`�������Iޘw���u�:LZ��*G��v�G����'��ߴ���nuD�5��0o?*�<aT�6�Gl�_�
3M?d��ŭ��V(�S.�Ew��FZ�@��ů�.BނB�<�NwT���k�K��F�]0� �����Z�ӭ�z}nٶ�z�l�{��|�oo��멀?#�\K�Դ��Ę�noGM�x;���)u��ͫ�J�x(n�:���8I��N��7���P����ǣ�%uւ�����Z��۠�4͖�_��I}�.�4fk-b�.+E�����`�����g-�?��;��֛Q?��`~9R���]6��V$O��(˦���%��lb�(k��/
��6F��#�z�ֿ|Ɣ\���z;]:�elJ>���fֹD�mÙP���U������V0�v�f��x�����m5~.J�u�Yx��_ҿq :ϭ������G�S�F�_���t��q8H�z;A��c7W(�Z<Q��%���DMz��>0��.>�/�_��q�p�*(lm�M㛭mB��lſ���(�?�z��� Z<���o%��?K~�S���2y8������=P0=�=
��!��uN@���\����C¬���`|�)k�T����>6.0w5��'u�rEUȩ U��V4�C�Y@��:��{(A��X+�Ӊ%����~$��V��壎2�G���B�4�z��yJ�yQ��+�/�_�o	#Ν0m2���{��P��&���>�OF^���WE��;�#�0�W����/%vaPV�n��&�z�����/yJnؽ"�E!�v�w�T��y�3� ���lw��Ɨ�>�0j릻-I5����0]��6�'�A�([6���k�<,�m/������v��$�G�4�95sɻ���O4
ڕP@�����5/�4~���ċh[5�d���*���k�\��?)���C��õ���7��v�E���ŭ]QW�Q���Or��$Y���N��#/����s��//t��s�|��1��ty���E4w���6���~e�	^����7�\^�ۄ�7�+��~�&^��g�|�_�/S,�0�h�ۏd2!��?��m�b��D���|�^��FY�	j�} a��}���KtY�-�=k�v�0�f�;�</B�WMg�=o��z����cAvznɞ���D�?��z��ꖖS���z�������V�o��5,�w��L�Ƥ񜼽����a���Q�=M*�v�p-[�QK~7<`0��v��-0��A�:��PUӒ[`���&�SI�ɣˤ�i�!�G�i?�GI^�s�G�o1��f���Z�E�%P�fAh��I�3��!K
/c�}:;�H���h]��BTSTxSr;l��дNvG��<?l�QL]��^���wKY7��ɛ�`�{��(��R��(���������Eô�E񷔵	���Z���ot�|AE��9B 3�8��n%!�aњ�^���*�gm�^���ٻ:`X��y{L=�*�A��73��fc
��N��m�*���c��f)�.۹��a	<: �	�ND�{��!JgQ.ը����;]�ԧ��3]��p5o����呓����󻟓�3|�cu��>(��PR�w�S��ג[_��Ү�������Cn��ދ��=/s�MW)b�\+��c�Nh�xo�!��)���� ��oFF_3ڒP����	p��_�(���dWPm����K�Ӆ̵����oF��3P�q��y�{���N��r}�R�6�c�c&{0�Q�1��5b��YJ<&_��.n�B��}u��A#���"D5� ā³�|�>��¹4` ��qN�Ns��xH�P>H�. I+�G������}s�)C�0d�8���03��9`FA<�a�a�WsMXG3�f��κ6�w��|{�~yL�?��<�_�����>�������@��<8�0H"�M�)k���8�@�����k�^w����픋o��N(���+��<Q���ɵ7��x���
���g�tk�^78�⦘�-`)cC��1������?0~]�F�t}��Ͻ;Q�;�N�A����t���6-����t��GO�>��=�'��A\Ku7�|�݉�띐���f������-��;Cu\��'�{�Q�pU/c���IY������u���S��cs�E�}�S�wM(bQi����K��O��@�r]*6�Jr�+0H��kB��_���n1�B,��*y����鈫Ԯ��L%�ÉD����k���q`р�&�/����gN��b5{�_d��4�Ah��%���y�݉��~����7�ƍ��Xi��=&w!4n̅�u�\���5|�4nL2��H�y���pᗌ�'�k>�.�,���K�SU�������}@��[�����(\_ە3j�g,(W���)S�,�/�� ��nM>�4kZL���l�ʓ|.N��wM9`:[����Ky�����HC�F�g��C.��n
�jȞ0���<�����x"�?�=0�N/����Y��-��0�����Hw����ݒMmt��>�v{uQ�E�|#WQ1KHS�+O���?�j���{1�w�t�h�Q��6���
�Y�@�-e���w�)��L�`�%/����(�S˚HÝ�7N���u��(dE܍օg��4�o}���Q	���Y"f��f�[�>Li�4������c.�su�n��j��W=Ռ�z� Kf�m9&k[��W��C{%=#]�K�~%�N�:���/��+�h�kK��-s���X�=�U�,�Ae�_J�t-��g�{(F���Ƿ־TZx|b{A&t�聾g�=/#&-<Q]���߶�il&��1��*�4�����S�˼]�*t�-C�=q�A#?%�i[Ll��t�C��1��{�^��z�0�+�ղ.�@�}ݏ�n�8��y�,Ð)W�������e�-�,]��03=�n1�~�_v�M�^m2�2��������"�(8j�U�5�`��k�(�t�S��̇����(��6u�xÿ�|����K�J�M7q�4��K|3�d�Z)�B���6{���Y+tqx��i@����qm��U��ݤK���a0E��Ǥ    i�{�x�F�*�I�H�h%~�^���1���mF#a�),�xS�H0|�f���f��������Y�F�W���L,�=��a�B�(J�K/��v+>(T}�´��?�&�d^����������d���]R{>���h�9\��r��t��w$��M�U������i2��W]>���)6p�_>B9�`/1l���>B99�(�E#Fl���z뀄โ��m��vIa�%���3��iP|�U�e���V�����3���i�>�.p��ʔ����1͖��
;J��k\�W��'����w���0�c�Z��aR�F΀��6�Q}�k��Eo{倹�B�Ώ<�#5���-�m6�t<&mm�5n)��q��V^?s��f�ޟ&_���n8L9aX�����oo2%(�շ}�4����&&k������қ������ kt�g�%ͪ�(�[���[����9봲2�7$�.��(\v��3���D��:�7�����(��n�[u���v�(WD�]�Jz��FJǳh�L�َ֊L���\_��қ��/�-l�߽&�	��#�.N�s�ټ�i@�7��R�*�_M��#��Hh�=�+7��h0T̥��~�E\��j�ɢ�)_9FiI��D_�~�C�R��zJ*��/��|-��\�	�嗂�o��|'�e'�۝��䗲� ?Q]�_���S@6�6�w��ϭ��f�uh�!iI�	�~��`���I>~�5�{�7s���>^��V�n����ޏgA����vŞiM�-Ů�}�^��C�;��D0&�l.�e����K����]y'�ro���Y�To(z��;��.[�zۋ�/������o��I��O��HvJP����ڼe�\Xp>e�������t�c{�����Y�ݡq�Җ;d��}�^#f 36��Ď�(z9��IK�S���5V^�n��;3DoA6'YW�s��{�\��u�)yG��ðe�!���\��z��i�`ސ���ݝ�RZ��5��_���v�5E!�Q�ڭ��=`��"~Cb���wN�����k硇>�^����n?*sw���P_�0+X"Ǝ�ui���MK[Bn1냛�7�a	k�tK�gݬL���'����B��-b�u�������D��`�)����(��m_{��)J�p{Sr��@�<Hw���ce4��Kdu��s��g�tD��/�4�n�y�ခ[E~7�T������o�{~q�1��UT�nO�V��cp�,���V��N��rٽ�e� zZשE�	��2���>`��N�-M��K0���1=&��~̭����J�*���10P�Y���^�< L1ݶ7"
~3P��NF.�)��pz[6J�E�)b�?��mS���I"F��5B�>T�J�F��������������k�0�Ļ{�^�Wz_�<�|�@Wy���8.c�"�N��8v�tHRoO��i��	N�CN�Q���1�+�5`X�9Cշ}-Ln��ĒcSg���ȹ)��j�T���N�n8_�Lc���8x�Qy�9bL6^���Eޠ,:4��Q�꼵����X��pw�QS�@����}a�L"Y��V������>�ϋB-�u{-y�#e����(�c����;L{�*���\#3���\ǆ���7���n�/�:tZ���(n�F7BY�?K�xy��[	-�˫�,�C�5`P�!�r�-��;`F#.�3I�0B�K��gm_�g�4S��(,�0�bF����$]��m	K��G��f����o���-b������"��v��4ނ�r�ϟ��3�0o�ܑ8`�g��1�����#Ʀn���w��p\7�-��y�LM��(C!\HX|�{�p)�Y	���,g��"Xִ��D��Y�ā�ڛ��w�!��J�ʁ���./�>��Gh�]�if�����S���ʰU�Uf���C&n�J��h���9�k�K�:U*/�����n6� �Ӝ�Şlޟ��_
� ��� ��V��u�vޙ�[� ��S�B�p�5D�1�a9v��]ޗwOA�q{`�y�[
"{\�U�R����o�W��/D��=MRl���?hro�Sr�wp���7������rq�F����zL^�v��u����Z�R���=uݳy�H���)��懅K�g��c*�۫ɣ�^G����bG�Z�0O����Yv���j�=��b$��4��p��h̠Q��4��v��1Fm�nǙ�1���L��ȳ���%/�8P�'��Х>d�b�Z�TA�º�����Kdv�ۯ��
�}[{5�>0h�BQ����5w~Y'���Ԗ[`/4�&�_M�����j�>`f�Ý('˖�j1��&�Th��+�+\��n��P0�1%�f�e����A4��b(&����m�8�E;`�n�<�p��6���5��8}
��L������m�׌Q��f�,c�.֞ǁ�0��:�[L���]$Ba�9��Y���G4b�u��,O�y�@Q��6L~}�͐��%�2��~Su��%bЀ��7�Y��	x�;��1��S$�)y4R��o&/��1f<���:���h�#f������ܔ{K����C:N)``$����A�jqG���16=���<9Ln�uD��3���W�g2T"�v��:���F�ӆ����OKJ���)�Z�S�ޔ<�|��{N#�,^D���.ۥw_7U�₩1J�f�y����'ʬ*�jk��J���Vm����x*�>�}�FϬ���쿥�u?�
�>��4�4�Od����CN�FZ�\7��iW}�dX;����7#i'�,�)z�;eS�*�'�����5��F����u4o��p�Z�PKr�|�1P�|a�Ԏ�s��r��\���e=�G�� L�R�e3�E<��6ƤQ�jh�)e��X��Ւ��ꍇ5<>)6�74���>?�P��ck�[M}�O�4����}��E���7�<��{�`���yX���d5�H�L�۫�T"��a%{=�Å�k>��"�+m��
W'�:_���<�`���忺R��ˈ���
��Q�~5~$ӕz�j��M�o��_�h��-߇܁�]|��rd�D�b*6��єϪ����5Z������{�A;��{h��3`��,�[,�� O�Q��wY<���:6�ϫ�Re���mR��*-b!��j�&���|�,����uT�N~Ċ'_�q��L���.�1S|��Ȼ�;�a�EL�#�4�U�n�g���1H�U�к0�-.���EA��nc�ԅ��N�#w�\y?�|aRe*1� 3�$�zZ6��Pш6�y�3EP�3�Ih}+G�3��Q-ӬTOغS&_ĵ�K����R�T�	�n�&��0\l̼äFT[�`(ʺ��iz���n%�O���?r�&���!�0vߞE��4iB�*G̰�ܨp�fd9�[/;���zLZRIuD�Z��?�pa4�{�B��=�aK�LXЊ�/��Z��;ah���憸j�\cU'm9�V�pD�YӺ���*����&�h@'��P�$�.���__�ij���k!OyX���j6x�b��!ұ���Y���`�$�'J兩��Vs'��@�V</W�_��l`]b:�1��+�;)��Q����K~f6_��ZZ�~�����-p���A�^|(�A�2{��2�M�c����qU��M�	�1V��G��)����Qi�ټ\��Z�+������4�v��z3e�Qi0�EY׍�ϭ;Q����`\���ØpQ �TO����#n*�Pz+DH�{�¡rQ�S^���[�"wCi(�ADC���;䨍H�ֿ��Mw{1�]��cڒ�c������cZ6��AX���u�ݒ��EjY�����i`Ձ��B'!a���T���x�����(y����=t���n�Gh3�믠��<�#����W?];�Z����L����#a�IS	�>!y��Y��B׵���-$Z���A6���'�k��Zv\0�V�ZZ�!�V��Ⱦ�uw���Ѷ|�^t���r'B�C���{�N��]�g�U3�sdt����S��{
uQ�Z��Hpi�I(ҋd�)i���"�)N��V؟(    ��j�=�3�B˵G
ι��ƦO��sqgvޢG^�`�D��>��l�=�Z4�i&@)<�W��IN���a0�rm��W�&��1�7�����'�ˮL�V|�u`���M���+�Gt{��u+�����@a�|����[�#�U(��Iw�Γ��k�?�b\Q_ۆ��_|%�`X��Nl�\_��f]z����uδ�I����E�lg�ڶ]�7�0}�~Q�3���h.���9�`;ܑ3"f��N���<���_bU�떬���������Է/ڌ��;i�\�me�nO��Vn1k/�������{��R~i�ms�%7��0dA�)nqJ��0��ԭ��ul���r�����E���YB��B	��ޖ��`�p�^4Lꆺ��܃�1�q*�*�0���4��v�0iy��3�v3}H0������ʓ�#�"�>Fۺ�mHS�4��٦nQ����K���3Ze�?/�!=�e�>������2�4�HQ;���w�L�O�Q��a蛭@�Ȱ�mӴ�߿)w"����zK�������|K����q6��\�q��k 雒�`�H���EeK�|�Q|�K�S����6�![23`P�X�KޛO����#dJ���Ⴝ"l�I�ڒ��d��n�~)��Wy�ؓ�=�t}�ۉ�t�y�މBS�[�Wlr��M[U0����7����Sd�L�B��z�%R����W�Hf*��F�X������|�r���L\��c�9�1�-S})CH2�%�*�i��^=������s؛�y�o1��Q��(N/`L�n&���-�1�#�<a���3X"ƌ0���˻��5bl��\��MZ�L<�m��25�m�VR�Cp"�l��
0}���S��"�5��qq��&��w'⢌W�k�8S��@D8,/����W���R��4F�Bo�S�܁�\�u�Q�8�(�b)���Cb��ml�b&����_,A��[���<P��;.���^�x���^�#�ܲ����~u7�J��8U���|/ş�=� ¡"���,��N���b�.�/޿Q�zG|/�]��?�~�YV�|�aP(ڹ��b��h���M�dY��d=f�Os�a�h�9i������Y~�n��;܈��_�Zʎ�W���{�W�������u48b�B�W3|0��z4FĨ��4��+S�L\�[
�!oo�aK�\	�����`�5`в��˥�O��~�h�0}	�Yu�7Ѧ#��ݒ��&�ڹ?d�$nL2� D\}UE�t�A���E�S�6�)H��7�e!��ϝڕ	H&�ʁ2��9Y��I���|���S��=Zus�r�L�0�:��I���!��8R��y��	#�w����O�#����dR��zޫw�F<�}0r/B8b������{��+'�$U��0��䜓1�.+��v@��"w�!�J��!'qs/��0\�7/;1����a�(ҷW�G#�
]~o���u$1v�l(ھT��0<�<g�:F�9�|p�6��f�9ɗ��_�t��T��n��}PrWB[��#Y;|���N!В}�;�r�j��2��J�����0m�&/T�16�x9$���T;(��i��kg�U���CVvg%ײg�� }G����gyX��ɲ�=ne]��i�y � Y��]oJ�	�%��q��H׼�s?q/�U��EoʃqO�E�;�8��A�:�HT�2�̿���(�Y�d4�d�b����-"��Bn�8D^3�:[��ȁ�c��9z��r%R��͗U������?ʠ�ML�ϧ�?���sQ$��ׁ���gɯpw�@��q�T�힂4Ff8ʃ�{O�h�+��~�/��ٹ�_/�b�2Q0��K^�vKY������y�@�<�SE�b&)E��g��n>�`��f���JV�k�I\8LKK�o1m���n��X�n�4#` �?�[e{ʟ���f��ir�w�>�	�A*[�p�i���B�(��nR=$����0T�Ʈ��DL�i��m sW]<#�1A��X]�.-�ӱf������pGj��}�:D�\�n�=)Y��.��Ǳ��O�I��*��#��:�{�\�tM��%������YZ���T��Cy���f�M"�j�)���S͛P���o5:�ԙ��{�򑺿�[!z���1\��,���1�8c�#��Y3`�n�0��[h�p�|X�	����A�#y73`еI�J[	z�5���uI8̃����i�Bl?�e|H�9��Z�μC��!������Q�)yՅ����0���I�ɃuN���Huh���QΎ�[j�*�N&w�������|����L[�����Љ�\��n:��s�H��^�;��_u�|̀N��c}(���n�����'{�E+vΞf�JB�en�;�8P�:�e{��uщ��`lnϨ��	����;`T�}4�ʋ��р��,�H{��#V���1�t3�eD��-�|<�M�&v�TV�v�p�MVEf`Qt�	^�ruN.5b�f��ޭ������)��N�0�1�x3+I�>T�K�0J������?ް�U{�͕�ZM�ߏ�_ʺ���g5�Ѳ'ʀL���
s�BV	��Fީ�s~'J���?-9����6e%(�r�/�r�Oq���.s%L�����B��U������w�q�1�%��m>l>&/�� R�NnWM�J�/��_�Z�pj�QR~'�$rs�Qsbc>��pu�Ӭ����Q0O{��\ݐ�x����(�T��ٿ��;���B.��������c�` ք�{��҅���$�ؘ_
-�sz�WN�Q֋)���O�`{?(dZ��aw�AR}�xF��Q�*����H�)�"�r��r?�SK��>aPJ�%I'4�(���A�*���3�C�u-ۖo���2#F��ڽۏJK���N7^>��I�%\�A��:j!K�ɽ�����<��u�yȮ��J���1���q�����C��I��\)b4��"��s�1acA��ߜ4�V�c0�v-��G嫸�����q�=MZ��U�W����v�ȓ~'j�}�����W�o�a�>H�V���1����<��uFL��Z�o�t�(�`龥��ay�J�t�#YVb{ù@�	��i��?n5b�<}w�E����`֠-4���qk�HD�u��Lqބw�P�R�/��k��#F��}빠|b�=f��`�\��E̴ηѦ����=��.צo�vΞ��:[^�=� ��b�����+�8�Ǥ�n#b�gX�6�ҮH���c
�ۏ��&cBs˂nBs�~gOs�61�Qq4�Z*�&b��ܼ3=��q������5���0�D�=F_��km9���m(�(~�ꍟyA���bP�[���yA��Dڬ�`���oNPbB{�}�0dN����\�3z��{�eZ\y6�4�}��F��r������/e���*��WȂ{�����%�T�W�p�(w_�f���o����W��{��;5�+p��]�`Э�<8�q��f��:�����d�oԔ���>�a�BЏVq�Mvh�݅�����C�`Z�x�j!9e�UޅX�n$�i�AΛ�N��Z��/��,v�]7�f��(yމb}Y��l�����Q��)l��7�+A�kq��S�r�)�����y2.:�FA�jn
˜��N(���_y�F�y��r���ߋ�L�1�Y��}w��^��N���s��)h�ܤ�8ﾋ.�Ql2����+���B�F{�)_��F���	�o�W^�/�/'�E���rz'��D�.�n0(�W>�EY?��<ۛ��k�Њ�V������_�W�Q=Y\5���E
���m�r�].7�.3�	����l��f��o��U\�;s���qG#�(���ާ40���HWר��s��_��h�0pwe{�|���������U�p��V�bZ�ul!�i�(���B�z�U+O��0����)t�%^�3J-�mv<�ḟ���V{�z�50���K3bp�zp<r���dkWZ�T+۫�0�S�^0��� ��+1���䚽ю�/mw8��^�/�4Ǵop��l~a$��4����i8mq�:�%��3�3�RwQ���%����Tކ�r�pw�k|V��0�>Pf+"�Kq��^���W��X���I�    ��QR�~�e0�$bԆ��s{���L���:����Y���ݚ����|g��u"�ے�LY8.sij0����|	b�OkBu�q�U0?_�0�e�ǩ�s��s�4�\:Qt�?u�!��\�E׳th��כ�n1�*}�<��-R*��i���8��޴N }�u�vf�n9!�T\�%�4A��w��|`�w"�vn;Q�u�?<�1�8��n�mH�o��?
p�+S>��
�����V~H�1EL7���n������r�MH!��.���bq�y�<"�/_h�:�ʱs�Y"��PZ7L���ؠ^�)�����[�5P��,�˦p3�ֻpLbx˰���/��w;P�U���)�'
͆��oJ~��)����r�}�xȺ�1��l�5�I?k�W��k��Z�o��度b�Y�wBF���I�ޙ������'}GY���p�XG���څ�[�Wh�[���Q�q���5�F���^���D�A�46�0T�W�5_��G��cyx�NĨ�?�F^�l�Ì���u���n��e!�も�C�d��xj2��.���ۏ��c�B|G����#ty_�z+lZ�ٮ�M���t\���5��<@�θ\�#��S��u���;B//e�E*�����̇�́���,ݯ��ZOP~`t�ڔ�� ��A}��s2y���b�������<d�Lޅ�iDˡ?�Z*&p�L�S6L���N'���Պ���z��S"vBy�θr���^�j�Ŧ% �i��)���b�_`hq\���҇эb}7�wB�K�F�4|��!e{�yd�ub�`����;&�Mv����/�7L�az�H��m�&n��n���E�H��4��2tx߈r��[�j6#�M)��ce�s�Yטm���{�؛��ۏQm������������d�ν��i��Ǐb�Nb.�{�yX�@���%�s�����|E�t710��䛕�mFT�fo�'���'
U��Q��[e��F!S��u#��d�@!]͵d|�@T)�I����M�qp~�<Pz��!6���0��S��i�Q��c����Nm�y��Ed��d��~��K<r��:����|��H���RYd�1���NV߭=8�"�L�����Sp�܉���K��=9�֐�_T�"�.;3��<�(���]:��p�)_������}!��I=��i�1r�{��T�|#Ѐg9�_��l�ub�בkq�0SwI�a�񒧡���\%e{7y^Ew{�Xy����=���:"��܀��[j�l�U"����Rܜɝ�Jh��i�V�<��H��ϖc?�����f�_��cs�����M��"h�B9��,�$��0�6�P�_�twt>�
�Cf�@Y�wn��2��z���Nk��6�`k����Y#��0j�>Y?4���u�l'�X�ô��V�}q��2R��Z{�J��9�;�D����M5�{�`�K^���e9��]Ƈ���r��j^�y<���b�BL֯��޼Ic3�!��4��x<9b�J�uq�l�Cs��0��&�?���	���ir#<%b�E�lk��`k��K!��M.�yKi����Fȅ9O�>�Nw�<��Fʼ�vy/y,�@�t�_�3w��ճ*0^���U�C[�-��t���`�E��
�e�:J���h[{�9��❑�a�o��&Lɧ�R*�h�&�=y��r�R�*Z�h�&�d$���"��l��r�~TZ]4�n;�����ړǆ��T9ah-��i��Q(blO2���KM��N��0�Mn����6��1-�h�c�U֎�^�5���Gs���~TZc��y��Hޖ7��C�T7�,��'|�(�A�Ӥ��\�HD�i0b����{m���ԇU<#�y���Io(�޼QK�(�4,���&��w�,+����|D�ͻ�q����JZ:�R_���ƛ�&�G��r��霛Z��|�0d~9�ּa�:�Q����*��T�y�$�!�T���7�-=@�}.J��*|[��Fa�I}nJ��SO�������J.�0(N���R����|Jމ���V^>%/� �X0��6puF�S78� �D@q"�)ꜣ�E/x W1:�'��)��q�r� FSѡ����j�:"ƺ!�����V���x���G/8#(��V���[y�����U]u�P��/��j��oJH��EiXu��OM�JЉ��~e{��i�B�>k�S�+܉����������EY>0_U������4�4q�TmG��u ���a`w
���WYiq����IoT��i9��z����*��4Xv|��K�
�S��eم����
'JZ�}$N���LA��$#~��y�_tO�ug*�S�r�'�X~�`���Q�Ý�$ۅ�42�����(��;��;aZ���'�F+c5"��	��y�J_'�oU�qUx$;OZ���i������u��o��b��&��o�6���/{/q����1k�6ӃD���@�����?F��
�G���@��FJ�4��u�iտ��pt�G��a*����U$�ns���n�|��P�o�Fm�S1Y��Fr|�LBז�pj=o)}�*V|���l�R��<�w�Ń�>U���"���S��8�l��)i-ډ½v'v,�/�e���en%Ɍ�mè�u�B`�g��gw�uK����,iZa� )��њ��o)Pw��Fȉ�k�@�^��:ͭ�2���)�5ՏƑ2��ٹ�/ /�n�{&o'��-��}�&�UU��ٴ�x���aƫ���S��o?7���hù۴ֆܩ�}=�s~�l��б.^�{O��vH��Yɼ&/���'ܧ#��Y��=��Lql��gɌ�t�rh�G{�Gh<����: �iD����{M��Z�bFhL�^�Ur����`�b!yQ�MWK�%9`�E~��������0�A�1��r����
�eX��V�'���%��8a������iB����ٷg��l/�h��0�F*��0+W���H-�t{�T�%��+0�ٜ�5������]����<α/����إ�:7Ek���K��m�E\٧�қ'ʬu�(���_r��B��U1��Ar/�+6�7��Z�K�a�5�/��i����j9��ä�B'ʲ1�2������B�v�O��lk��@/
'����{��TS��G�'���~��y����e=�!�w��)ͧ�u�9٭��E�� F����Ї�׋2�%�����S�ǁ�}=��w-��}b�$<��Y����|�)k��j�s{�o�U�ޭ&���~���釾^Ns���5`�-��Ż�w®;�O���+�����#��a������>��`j�����2�o���Ӑ�'�h�WV���7]7V��͞�q0���!�G5bPэ�p�<Or� �����!�v�ttٚ����s��[��@�$o��ۉ����e���`��)\m�֛�~5R�Sc��,��-�KY�p_ܫy�]�&��2(�g����!r�{��p�-`j�e3���(X���B��j�R�r�J���.���qа�����O�Z����C��]�D������Rh�T�/_��Qsg֊�Tڮ4�f�Q�Y����OC�+c��hH�,�5�%��"P���s2��7hߔb���+շ�i>oЌ%���|lLR}\"��냥�6����*��|Ց�`�c�&¬V��G��hCz�Q͛�����v�wڢ���Ļǌe��&
�#7��#T뢱u�j>o0E��<��ovb䋘9`����~�]w�um��R���ٜ�R&���5���`p,5��h�;O�A�bO)e��UyX���A�&���Z��8�2}�7s�(J6�ғ�"�1Ww:��[5NO�=f@�}{���A��R��ɗ��W�E_�H��#i��3^E�>���.w��R���<<jİ	F-[A�X���-8�5�R�L��������[��c��Z|s�jh��E��|.��|ż>$�G̰ 7Dxӗ��cD�؝�����_�DJ�_���9���;�#Ӽ��Y�|��ՇU��p�����i�z   7ϡ�%b�֜�->`�⯾b~��Y���16͓��v��ThH(����������K���[VB��n8��ʶ5QDj�#�ױy��\��J!/���{�0���_��=���h#���	��/��WH�ؽ�s�%���6�j8Ӻ�9J^y��������szs��rs�X��hG���/΄�dr�����M�/�PL�v���5�CFN��۬	 ��u�:�Y�ҋf��>�9r���iiχ��p�X�|�j����t�@kzwd���NL��a�i�w�2��5�j����·�܁����S�ځ���rr���7�)FY�Û��7�/e�;v3��CJ�]�Qܴ*T}q�e�r1!�E,Q�����,�z!s��,��tc"C��[�X׸����S��w�ؐ�#s-s���c���(f:Q�.�;�YrQ�L��G���(����U��w���!q��	�~��mV|�\��o*dz��B"G��=������]�J�&�8M���N�u9&,G�|�1��BO����?��?���g      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x�̽[�$9���+�I���/z�̎���2����A����Y@��7<.QN;4�N3�δgN�jy�N'�ǎ�c��������y��k����j�����?����:�ݸk�y�����o//�_~��������}���~���i������_����������ǿ����]�/��K�ߞ���O��Ac�~�{��aw��??�P*K�ޞ�X�f�=��^������\��������O�j�k/�q��V�g����ST�>?��$�3C@��J�A\��Ш��=��zwx||��><}{����x���z{z������p��~�/S6��߿9��3���/}s{6̌U��o����v���oϟ���z��������}\�>6��Ë;z�~���8�d�� ,Ǖ[7������˷e��_�|����������]=]ƽ�2ַg����̻����.��A3̷g"��A3U�_o.��Sߞ�`��9~��[�܏��=�������O���oo������O����"ivu}Er�e�{�"9�Ev�O_�����������<5O_�rx�����ǃ;� ��8+���޽���o/����|�pZ/��E��M{��������﷯������u���_�S5�>��ZA����p�L�6X�6�y���~��%q1�L{�m>�H$N���Ǐ������?w�8�~���rN(��o�/j�tX�q�~|�������_��v��4����p|"d߆��D�v����f��z���3q����3��Nf��=�>��i�|z���OQ���:p�ן�?||h��ZU�[���\e9�z�����f�=_]������|���A�{N}{&�i�awx�[G����=ߑ���#z�|�`�W���7���E�y���c�y?�,�K��Qy0�>�����<�t��]s{a!���zT���8�u�l>0'�Q��rS�ʄ�N�$A\�ɹއ��3l�$r-C �2	`�nq����B�~'V����̯[�k�SKcX����L����3Ii·�a$8 �A��Uߞ����%�����q��bWL�a�b"���*�y�ѻ�����o�S�k����p���:���g".>��]��t��ӛi����G⡕�B�ox"�8@39B!�~v�G�������O2�&=zm�颡�7R9��F�e4�H"dh8�F&ě�p\��P|��׋�1��|s���w�_޿�q�s��?z��d���{(�c�?Ǩx�N�wb����Yo��ÆC0o�N*$��.~�d#�DSc(�|sݓ!����Z��tdC��h�t����׌F~%W�m��Z6�R6�E$;��Q�>����+�*�u4�7*ѓ?�I�,���Y��1�xJ��(�M��8w� �(۽o��ʷ��φpW�%�����M- ����}��N����#ռύQ���s����c�8z\�-��3Ku�Cp-��>%Ne�Pm=����I��m�H���6�J���+C��.TO�r�
ňu���t�=��o���Ϥ�B���5<<A`T�8[T�4��J4O���+NPq�ھX?�X�J��։�/WC�&7E�8�����f7�*T����lì���\��F!{���w�d,�SD�����b=C�J.Ah�	ZD&t5����C��,���	���D��P�)C]<L�P�UjH�QjG�\Z����'����\,����U�C�$����v)E��P��.�Q;�6j��@[�1�ӄ��+�HtM1�����>�D��,xE�����Ɇ�T���0:Q)F�aB6�	�ʻ�U�`*�g��ACYȧa��oo��//�NWŷ�L�vEȵ�홈�=|dbf0|@i��`�FP'S�J.��_&DP,T� J��Vy���n?ޞ�x��L���L\*)v`<��:�'x�%�h�2�xݯ��
J�b~���v�_�a����������"3�|��A	/a������'j�e��䃶a��#"��C�z��xb_�NFw�gb��A��'��AaoE��]�	�L����c�\���
��4�΂�P�!��m�d��%��Mz�b��3�j�4ŠxQ�Z[FFwK^5�E��i���  �Q�%{��_���U�L���x���8��ֻL�f���/]�c�y���5�E����#�OO����ᯇ<����=����/�(I	�Axx���J���]�������K��͍_) �̲�&y\z��#�ݜ墲LQZ�b�:CZ��4��\6T�X(R�ܳ
ވQAxJ3�LKφ��� �UD��"e N�A\�� mM)N��z>�u�|s���8��x޳�-�R���.�#U�0un�4nE�A�\���𮃄�G�\y�m�\��3�4� 	���3�]6�"�ǻg� =�P`E�qĩr4"@I�DZ���O�����ǯ�i�5w�y�Z&p���x�'����8�P�L��I���p��@c���x0��I�,i$����ЊFb�4���;��Q:Y�����lh[�m=�o9�{�����v��ka`ى�I;ڠ�2��!wWBh̅u4c6�q@�|%`ӄ0�$��g{��S���6�=zh�!� �9{��M�5��d #� I@$�K�`T;��+Gh�8����γ����J+��~4��Z�څ��i|��o�pf� H�.;�G��^�1�#�{�RT������iv_���/n�F�j���s��1uʨʷ����F�ExU����\��9�\�4�u�uG���;S!?��Ȃ�ֈE�|��c�"�����$*~8���.�����zxW-.�jӣ��x���m�B�WL��Cp�'	����O�J�/<+	!~o��s:JV9sV(2D8M�1߻	���f~��d�΅�U��=yƈ�P�4���O0���]3��Fzp��G�h��b�>�#_W(����IsJa�;%��+% ��]e�X^	 %>Dt��zO��P�p���7�=4@�'SH�ߡ+�ۣ��U ��hG���ۋ����������������H��αQ4n�Z�rU	��ٵ!褗�k[�<4LPǓv9j�f�ZE�Eܤ��L���qHQT�%��Y[jRLJ����:���$�2�!rAɶP��t'�+o���wv��&��b{�є�{�	E`hx�*g�B�-I�I��m��CI�{I4����oS�G�jS�{��ͩ�ت��JL�ӟ^������r���ӷ��?�ss��gloO��^�������uϺb��r�y��(��=8�Q_���x�$7LA`F^CS�Ւ+��sп4��r�p�7���L��ռ��j�M��sB�xU�qc��ٍ~�H�����l � HB� �gt�J�G�$�_�.���\z~2θv	�tJ��|w8�~>�E�r�0mt�����E��EE�Gp���R[�k�IiB �����W`����)C� (����o� �����z*n���[2��PƊ��)���?>�A9"yܿ�O__oỏ3^����R�0U* ptE��˩6WLF�%ॷҵ�����o����aٿ�+t)W���-x���������fN���w�4
ɢ��a�q[Kg+��k���$�1$Nc��(��6Ο���$��A�t�p�=	Z�	���'Q ��Oq�.P�i��zؿ�_x!TW�_�9a�r"�=�r�$]uD��v�No��g)!���V��u6��*דR���JQ����1�>e����A�����������N$���-������dw?����{u{�/�wO6�K��rSE ;<�d<�mծ�V�=��᧴E�=K@;O��?a���bzo:�o*�l�1N��[���Y�V��C	��$����K��@0��Ns��u2��˛�KX�n�D �U�3�v�2�� =��:U��M��4�/�l���S�RK���cH,t���W@�!��/���j�+c[-@U@(n��@:������    ����Mw�4h�����uK$��RUV�!Œ#Lu�hI_�#>}�+=�����WT�,ܮ�l�@&���\�虃	B�KC%+���Q|�q_jCўu�v��C��{pM2D� ��f�"b�!����e�`5�y��w��G��E���[�1��n B�*|�{��iY��v�:�D2�+���Y�o��DH<���,Y�W��f�c��2�=[�	�	���8�m����k�Kp�K=��ׇ����r�����6zg!�b�+��yV��]K���Eo�}@�%��MX�,z�ŀ�Bи�N!��F��r2@x
t2X�x�V2� �S�	�]a�H:�K����g2�`SV���VQ��;у��"�*�\�M'墜>��5�5����4��g4m��;U�0�)�I0 (��qB���d���e��@�Sժ��M�y�c�E�`�/�2�B0+|�+���o�W���L�����'_�-f�����e����*�[b��o��縎Rm>$�N�{bQ�-[��Y=�u$����7[�z���=���Q��<��%���?�%2�ԗP���0�.���7n�K�����(��I�v�U�*F�iyD��a���NQD����˭�I�K���<g���O�~�%#��Lӄ6m��|�w�)b-�%��M�v̩%��G�#���! �.5��ԓ�9��]��(5AA� �G�D���E���Ө;�B(&b5��-�bw���z�9S�)���v�""b0����pF�PL�V�k�(��҆4��O����#�u:�y�';Cb+R��=�����.57�ـ���U7����jH"G<�����sk,6���q�'?�`����mȀ�6� �DBѲt��Q'�Rݯ�Ȅ'���:눶��g@I�@N�2��re8�ĕ�iC�K��(�4"ĵ� �D��!��;J	�M�Y��4�q;>VB�z��u��BtM,:߭�gtMs{���f���ܦ�J�}ם����L�4={����5�l�^�TA�Z�+�қ
w���[�dF��F�ji�>m�Q�ȁ6�C��!%=:���*A(n"X����+5�����<!vu�]V�;����H����������(��>J۔>;�Km�:F�/UWѐ�=�T���r->�	�u6ޞ�sBs�^�9�Y�t%���(E��xMH��#����h(�άp�����pbL��!�Y������P\�v�(�qo
"un�a�����]��$0�:􊲕������jFpL��L�
05~c,�{_�{"� ��0~��{k���^�b�	G��P�$�A�f�`b]��t�坌w�b!��X��Pu��s�6e��c���Ga�v�U<q:���̿,m��A8LX�Iv�Iy	��	#�}�$q�S�щG8Q&c�BOs���,��SҀ\�4`���l���o��	��0O$���$�ys�̋wRř4�Q!�L�	xFN��P�c��Z��̊X�G��+��0N�w3s��a�X�3�B��"=V���Ԗ����;1�J�#�$�pP�U�q^�To��vlr��N��	N��JoxN��D�Sd�������d�$���n!o[1��ޖ�@!CJ!�"�MCL�̊la���7m���(n/\}�j�?i���S�"y���E}{n�����U�ݞ��D��P $*�p�8����DeB�CztWQ*���קT�0�)�X��CF�C��E���bD^�W��f�h�ɛ�^����Y��"t�=8�1Y�=ͱ̲=0�S��l(��<�5_�����X����
<��:��2�3�̫+��/�-� 3u3�������%$o!�^EC��6�+?�R�@ ��f��?�2�[5�
���R,-cj>��_�(�h(��,`>����
�& ��3��&�p��$s�1�:�A�4������e�0��d����=�p���7㶪�t��*A��k�D���`�_��	�r3�b�z."
��Z"ɼ�,U�F��eJg�l{oN8�`${��,)�j������g��i��/]w{&�n�&��`� �&�Ƭ��a�w�V+� ����ю'c�
фW#X�y��S(���:j���AzD1���u�_��}�E�ң��6d�=:��W����Ͱ ��/��s�23���)mj&����ݠ��UU�X�ܼ���s�M2�T�<�~}���s9ˤ�hl�+OԸ�����LD3q5� \��o��]%�;��x���[VBx<׭{B%� ��g���m��w9���L5�ð�Lj�^x
���S:&t^�XL,� W�+����|/@�� G+_B��b��WO=�=��ֆ�h��.>hD@T3�ct�2Rzݘ���Px�K�{�=0�4 �n��� ���J��ɰ�#��i_���ѡ+�n�EF8�Fg������x��ܑ��XL�ai(���/�� �P�%��^�HcL�e;
�5�X��e��: ��=9z���ȵ�FcQcO#	��
�4E�P�k�"s��G�dR4;$�s�x��ՙ������L0M�>k��љ�s�P��b�P� VD%�LR]3��'�C��� �`���@�QV�� ��� ��(�f.�c���<Q�&@�'�#<cCG
Q4��4F����LɌb��Ul�I�J1!L�x�)^�:���^�ݝs��TaC��`c8Jc��ӈ��lϲ�m���x)C(TƐ\G�_�ڏ��$�ڨ�$= #ӹ� �ϔ���<t�:e�<�N��SI����*��<](�A��t�#1�� �!����=�`��0'D�\]�L��owx�4�o	�	m׆�F�K���y_Yu��VqRAMÐ�b�B3�n�T��^���,t)�O3EǊ�pW�"��0W��F2���~�1f�$�(D��Gw�gr7g�+G��I�����$�i(~��ЭA!�-��	wo���������&�q���ψ���Y��H<H��`�E2	)yG6t���ׁP��6��D�ǔ,
������S��i�����iE������Ɲ�h`���0��=~|�[ ���x���/���=���e���F�L$$r�
��Y$_�\��P�����44�\ƙ���=�+�HR�*p��ҍpن��z�Fs|L�V�<GP�'��M7� ��Qu�e p:f	�z��_��oaO��w�ԉP�8�ǲ�[�U���g��ڄݬ��C��B�Y|4~D �I�͔�U��V@���L�y�)f3M��Sk�@�$�to`K"߯X����aO��k����Uj�{�bG�l�&' �G�����o�܎�M�R���K؇"7O|��)�
2���@O1�q^�"NJ��'+󋛒4�^��li��"�'�fB3(4<��/�>Q"E�X���7
����YoB�@(�Kʊs�B=$H,��K��LУ������˝��,��2`�͡��3ۃ.�ػ&	��b�T��A�wnxoMT������j|���MDx��.?�ۓ�.*��&%�4���!%��?0��9�"���L��>��;_Cn�DH�i!C��Pl�4ί_VC{{n���>�}�}Z8Ї�o�_��'F]�i 33)�z6��3m6-�6=:S)����0�B����7@�Yj�MCa��b4,����e�_4��P���#v�g"0֨G��:ڌ~Rj G/Q��*t�cεR�?8zx�3ĕ��9�t�
�lZ �pi�<����o�X}<���/��.�.?�2��Ђ?t�j�����ǉK��f�P���@C1�$,L��оLca��D�^���-aB(��q����_w�$M ��I`����囩����oZp$��SrLCi��i`Z�Z0�hI�E�����il�M_S����2���у�)	��瀮���fk9�f"Ľ��iLi LfDF�HCq[Ȥ��{�2T4��91�e�y����<��3qZ�MTF>@R��'M斌F��H�2��A����F��s����P��    |u�=r�}��%�x��M�"�ވ����IzO4��:W
�@�����I^-I6�e�����f6������%��-�D(�����;�<K'c�h�F������������y���W��jb��P�)ƐW�5����.�t��c�;nk/UNn���;�aC��)ᕩ���4��4��3�돣�=qt��4VM�q�g"��K���|͎�=����¬�KhRML�#e�iu�(��+w�Sf��k3�(��+WԤG���s�Td�O��� Ӿ\O��sm��t���zjf��6�I���)XƶS�Xx:�_0�6 �1��0, (���[��M�n�i�}���X� u��@U�W��8��H�[q)]"��Pd�-ht[i$I���2M����;��ӧ���z���֬��N�7+���t���0��-KU9B*�����Ue*` �n�
�cO"�P��dB�t�F_���pI�z���"���wY�WL;Y��}���t
��x{P��T��X.!$��Kd�=���D���v���������X�5SD�h�Z���m��QO���/�X<���*� ��`��.���M�r«�n8b���b�hyJ�p'�L��F{��^3��D>2����t��(�{L	 Db}`���$����	�'�+7�ަ���y;t	L:���(�,z2B$���f�eOR ���A�^^�J�J�����	�g��_}�%p�=S���0��_"���mdH����$����rS�.-��ݹ�;A�m뿖
�!�v���o{bѰb"�i�N
W�G�N�0w�>�b������P�
p����K|S�dJ�A\�'��\s})�S��h��N�8Z]���K�#p�4��\�7�t�A�-��C�J�i�eK(�]x ����{��Ï)U'����L�TAPl��H�U��ht��l?���:9�^�:95���U̤���%[�*�<�߳���n{Ak�4�!QUs@�J��'�c��H�k��K�P���
�>���R.Q+���m�!�Kiɬ\4��kFU-������������v^�oO��^�;������	[�P�L��̹�����|�����7=�+�V��c���٣�"RuG'e[�J����/������3o9dT�t	��&�]�b��6FV!Q�Q���\���ݯV\��ń=��Z�ޡ��2n���[8xso(*� BpLD43���;fT++�vǤ��.�.�_C�����C'Z
=���)Ɇ��)'�X�In|_�#�9A8��@���.�|'�V�D�ˌ�̢AP
��.��ܗ%��h�p��ɓcy2	krTy2l �<60�'@M=ٶ�C�"a�����p�2^x���&�[1J��Ii�+hVuc�jh���)5���BX	�J��]'.����E����b��Fo���x�)BXJ�0a�pD�� K4S.f$ ���4��r�J(�1�A���V��
٘"y	�,^����������x��?��ܗu������#��t�n�]n��������F�Ëp��nm1���H�&rU�:b�)���4M�M'��vDv�6���E�Q
x-�p����Fn� yC�@`��e�L��
O�=Aɟͦ�IPE�=Fv!B�¯'W�m��'oJ��)&t7�ƓTF;@8��*]���j��k�jWP�XN4���t��AƆ!1�����w@<k�I�<�i�s���0ht�lmf��#�)EGP
,E�;�y$�{V�#��Pr��h��;b�f�@h�Hd��J�-.���d�� $�ʌ	���C ��`z͘���X��4����)Ѐ��hЪS&e��l=�_�.G�
b]s��*���r3�/-1U�]	���u���v_==~�W"}]!��qe׺6Zh�{	�D�{��A���G$͉8�� �in�Dz6b�T�.`	���ٻ߉bBADK�h��5�:ht[B�f��v]2��i|�Q%P�x�R�4z+P3&9�џ��#(VV7|e�f�&ƬC�3%���dA�TR�"���Ίbmu��fKyzU�ݘ��A�X�:�0�zΌ�WSDS�x-�m���_Zb���Rڍ�QvD3�w�Y���+�;�n�2T/Bc�0����Q��������,!�_�~c1��V�~ŮgQVj���U?v͕}ʷ�F� GH�N7@+j�)���As��B�-ͭ�f�Y,[�� �8h:�QO�ZŸ!jiRk�7��D�YA���6��մ�} ת׳�n��4��t�+�V�5J�f/4nt!�h,_Pɺ�J�p$�u��f���!��A0�Y���<]��� ��Z8{��ߞ�
L?S'���-�{�Zf#K@8�C���#�:�cQ���h������&<גI"T (�v/���{��0�2~�M��v�W�"�]FPlc3x��M��+CT}8�ʐ����6�VP�lh����������c�8�B1$���d�HŶ�:E�N�?"���c������NQ������T���[43��*�Tb�^��
�e�ԅ��m�I�zu�C��*�b����&����A4a�n8���H+�Xkŀ%�'U��A�͙�2���T]'��?� K�@��NSByӔ��0�=5f[�,�mmDUDm�ۼ��!X�;�wv-d�|h��ߗ7��<��,{�׎i���Q"�D'���L�	!1MQ�%5��;�㡞x�E�$0���z!)P=�'\T�e���j����${4{��l�j�ZC�G/1�ϟ(6X��iU����봝~n6��gw4�e��U���c�i�����N���S���r��!kj�ND�|�#�)�ܨa(�=Bb*��3SN����*�K�xt�"���m;	:��|Oz�XNXJ�Mj0aѶ�8J��l�2:n�92���љ (�i_U�4oV�g.�Ijo���Y�ܞɳRb�Э�ڞ��EZ��t	@X�MQ�JN�i�Jݮ��e�h:��mi6�m�t6o�o\�����]���Ƈ���B�@4)VAP
4��r'!�A�Ÿ�.1pM)6��L�A��E!/��0T��7�I+��X��R�bdJ-d*��-�cAN�И�o����SS�#2II1�W�����~�n�/ݙ�j$43�My�"qx�n`�!��.��k.#Ƭ��Ua��A��Be�S�6J��'��������D~i�0��?���Q�J���]��m���`�J���e�M<O�ʳ�ȡy��qET����U����(��V�Ô��y̮P}����Mͼmj�i�p�2��wP8�����3ql��(^}Hu�K�LFRܗ49�EU����Zc�fܺ�Ue4�i`8w=�0�+h��&q���h�ܻ�L�ݶ^���-�< ��<�Y��	�Q`���\Q4�����y�٭m�ě�e��N^��g�v_=�w�U(�o�W��'��qq�P��^�|��f��V����UG!��$R�Yz(� cSI�etn��[�R MT�*񙑡Y�A�ZYG���YYǸ��\�hz�_��ܤ�/���~Fңh�0��yԮc1�9��,&�R�4G|s�|�2�|�����O״;�AT%�DվX�p��s��\��m�����e�R��lKS�!�cH��U�!o�2D���C!�/�~K9�
B��3�����@�B'�������C���k��2Fh�O�Lp4Bb 8|�b �m�Хa1����o��Zh����u�/�Yic�/�Y�[Δ�#�[7�9�c�
�%g��4U��u�r���_T���*�!�+V{��რ�����Գ?}!S؅��v�/��g����c�~5w��0���28٫A�[�s�b�j�D��늑�1��;yVD���f���5��|�)m
Q%�����:m1F�t��a-��F]'��I�����PV���e�E~��+&2�pl���X�â&��P�R�OȥV�J ��Ƭ̓5</���̸	HK�4��oWm�X3�\�%��|��\    �w�Wb�	�b�WW��{r��`O�}}�ٮaI�C���A(�(��Jt�[�/w�[N*D#,��7�UV�e��Kt�wOT����7^)$��/�U�
���I���v��ߎ3�:,��zx��������?����<��b@pl�<�< �)+�NE�{R��j�n+�i�W 5��iT2����7's�g���N�/+��ēD����q�a���>�@E<�KNf��#v邊��vA�HnY&Y��Fj�و�3���h��^��xc��3��t��*��1���@	0�Lz1<Bc-�"�%�h�^��~���=���ҚS�\�D`���Ju�r�e;��l�4!���E}K� A����䜅�C)�D�+�i��v���6C�΃�؆D4K��zM$���T��	��d�U�=}� ��"S�iR����db{�6���ό�Q��z"*I��'��m[�cXބ�K2�A��,
���~��zx{sB���d�����3���+-wv[u���J  ['Z���J�94zy���u��b/�6f�H�?ШLz�#(��.��s�S��ZU 3��hj�k�%�q�W���V*�2u�2Wa��ër�z"B44����K]NI���C*I��ӝ������!m[�h��������&�,*B!��#�wUq�޵W�"�)�}����L�<q�cɪ�Қ���Ԥy�����MK����(Q��dC�(.��5�I�;M)%v>�4s�-��
����ڝ�fNlu#4櫛N��yrA L1��W�&�{�'&n����F^^3ǖ����������[��; �ȏl-dD��/��OK�iڨȤ���L���	±U:�44�yt4��> L��˴�j�&"�Z+�#�c��A�n}ŐVS"ٶxE"L9Bc�XJ�Y7vo�к�l�A(�c^%���x��o���p������L�V�/�2a=BR�do���W2��V�B:�V��Th#(��*�����ؚ CTE� ӗi�l����-w�C	� !���&e�k��Y���s`������NF��]Q���/��QO9��� 8%�B��L�gL�^���f�;=��z	b�k��p���@���6�@@f�XJtލ��(;��#w���Z��bN,*6�nh�3�M��viׁڰ������;�yE�Kmf�>\h+FXl�%1,�B"����n�4�t�`Ȋ�@�� �o�D&?��)���Bh�o�p�)� w�LEg���	��&���*2�|Jy�|5���&�����욲���g`�����y��<J�d�=����nK���-�!�������ڪ' �S`O���YS�n��(�>�ɠ�6DR^��O`
E���\�,��]����7]2$7W�ێ*WS��c�a6�)���ԛ��+�v������������x���k�4ܞ�Z��$Q�L{ ��2*8���24�������T���	m8h��7m���2&�J�&���z*� $R����2 (�0$��� E�Ѹ��ЭW���RV�:��A�SX�'iM��[އ$~kF
&s�C,��$_`�/�X68�D��.c��F�5֡	U�2<����|��X�1���ʌ�O� �PL	pб+���  *93I3ΐ2΢4�;T,a(����z�����i��Т�pC�v$*ܐ��E���h�)�5��ݞ�D�q0`z�F��ɉ.�bDO���_�\a|�p���؂+DHL�a��*�˵��A�V��k��Npxc��O��Xs�Fs���Ő���1\��7W���)U���>�~�BN�Ii�ѾP?�c\�O��L((�$���W�1��S�]�4:Y�1��X��y�w��5"S�,��@P
�A,�if�7���A[u��a���s�Ӕ���)��M���q��<��{�͆n9��oUB�����N�0-)�VBc���d�ےB�M`�i�gS�5'(&,� �f���	i����G�e�r�Bc��������ׅF��u峠Y������N*Z�G��)���N�����8��J��ИJi7�V�BL�qn�l����c&ݜC����%;7�!$XG�۪M@�����=��8=��m��gŰ�J�����ૂPL�*:/��m2��h���5��d8 8��M�3vDb��M�E]o��nA��M3�#c˭��#j�5�ED���q�c� ��I&���Q��N+����؆EJ?�T�_l�Y� Bm�=6�B`��:G�Y#��c�T'@졘������l���+e��\s�te��2��͗g�`CY������C3�$��s[�=���
�'����"�=�W ��pD(=��7��8W�"�O�N���vht[{��%X	���%a���M���i���������x���u���r�r�9�x$�JNF4c�!��#z�5k2m}L(�טur�e� �(��6qR�XJ�h^������V�R=�=Sq��4��eT�M�,�mB���2SUk��kǪk�4�FF0l�r��*Ps�V]d>4��m�/�Z���ρ�tQEH��:,n��)��<e��w��rm(qz&�Z�|��MPy�H�9+z�tQg����>/�+>�t��au��o�£�i4�@2-E�1-$D�4M�`	eP��%fPܾB�<G�	�(�i�.�
I�5�c̐��s�5yI��L���������#$������ �V1U=_�;7��A�����k.�v��ߞ�乿v�2}��#�D|�X���2��s��D꼚���F�zU���Хol�J3��׊ٖ���zٖ��;�X���3"� �H�a�蚢�(VL�2�&PU�dj�^Y�< 4���Wj4�X.AgNL��e�����(�Q�����l62�a���,
.��Pο�($0�"�t[R��9UH3�n�����i��1Ü�$mhƔ��I�0��8I�~�^!�@��Bz �&Zq)�8.E/�D�����)[BPl�à��T�F��Ws���=������^?����=�'���9	����ٓ�ɝnX`�&che<S��#5��C�G��nh�[\Z��|�T�DX$���xߺ$�k_b��%�����3���+E ��^��{ �9��-ۣ�:/�t�R��������1*&=ǐ��ԛ�J��u����b�=�inl*�"$�"nڱ�a�4��W��{y�ݿ�x:�����j'�Wn�A*Ρ��j�����u����љ��"#���t��o)5ջ����,!Ƥ�I��P\���Բ���(�8���N������r��+{L֑F����ᩈp�}{����}�'L�}�p-��*���Ub���y��Z�fwܝ^��|[����O� c���.������)�⍟U�TFu���6~��su�r�%F��2�Q�~��zx{s0����t�v�9�=���FM" �9���4|���. �!�5o2��qɫ>���/���oo�9y{z��������ϟ?�o6�D���7���"J��)P��mKqH��mT�Aa��_���@(���q����5�:FRD�I��e����̖ioBCYz/���ӯŢ�@	������a!�.�ů�1;����45�@��rd�J4������G����ޞ�h�^�"lM(���+;8h[_���3?
�g�X� _&|%G���Bwx03�L����J���3�	%>�׳�.��g����?���/|y{�?=}{�'�ᯇ<����n`�Wm�p�3"ן��3�%��2�7��x�@q�q���3 DL����^*�n1K��Q�f�d�zztG& dH����x�2U8���G�A#q>�[�`a�I#Y�J���ӧݕ,z����*OT��RE�	�W�����	z��i��cC�q�ѱ��ַ'{ť�=�a(�*�@��]D��0�~�lp�P�U�9�pŃ�
0���@@q�gJޅ"$dŤ.����Y��V�9}  Ԏ�E��t���(�?&D irJS�?���q�wX<;��fםa�%Ւ�f	�]�-Z    ���U��?�w���^�����K;ܞ��+#�V-�g�U*f%��;���'���?V����%@��x"ϭ?C�=דa8 �p�>���u���$������߲KG�Ȕ3#Ы�_�D�4F�I�>��F#4�q�����o�q��n��=�7wb0�C �,���%�2�_�̒ciDN���C��&2yztf/"=i,�M�PZ��R[uEpx�l�$'��-b��,�jY��U����4��?�BS�%�qV3�Iz���v'��w������*�'�e����)�Tu{o�H+.��E[MM@������������.PR&
#L�(¤����� c�V��>=˺�BL2���l���&g �+����N�p��6�Q���Q�o��=�^YQ�(��F`� Ɔ D�Mhi`f*h'����>I&u���3>��eaE��hpS@T�����l07�(
���W�֎ �+�|��MM	 *F�*C�#(�M7�jv��M��Y5z7�V��޸3���	d���LJS<A���^�4�5��A1���-�J!ۋ�iq��D�
��t�%F(��ZAI�;DE�1�tu:h?�y!n�t�f���&Gǘ3Ad����M��b6�0�lmIQr������"(�K��=Ac�Yc�|]��o�i`(s������^��r`��>>�p����k'BJ:��"q �S`�<&+�EB$�0�VD���=A�ߍY��bۀ��W;0���\J�-��f[��L �1��'N���GFW�֐���P?QŶ�(ݍ�)���EPl#~�Ye�����Au�A�m+u֨,�0����-�hrpbi�e°��N�rS("�68z�s���y�߅b�3]��+�u�E �_�Z��V'I����|��!en�hp�[+U� ��JiX  s�+��8��]B_F1��UL X�6@抈��^iTL#1��6�B:��ǿj��~?��|��<��������󿯯��������_���q��k�  �V��⥾>N�������}������~�������a������|��?�ܥ k�;��3�R������������� ����*/k��a���eUu�nnv//~Z�w���[�݂�ڥ�+����2�u���z����g���Ç�����a� ��?���s�Oj!�*����v������&����ۤ\O����b����nܥ���Qm�ĻI�[z���bX&�D�ݤ����H�V�?�錸*Γ�M	 R'm,G������@dc2�JE��RQ"����^��m�.h$�|9�_�}z�>��������ݿ�O�����'T�t���Z��3i�q?�9�بǲ���-gHݏh`5O��QԣsՔ�a�6$�4aK��6�R�{<���!,����t0�R����\�9Y-ȹ�a/�]*�P��g��<�pA��Ƽ�@se�+=�ZCY��bi���궅W������߷�Vdo��Mn���*=����x����Uz��`%�ȗڝ3�t���'�8ҫ~H��\��+�F���/��U:A�P�q��ur~>Z���0|���n[���2�>/i�����A�E4���$�9�I�J;c2�$���jN{��{����v�+"t�ˎ\޺�M|��d�<e~��N��$H=ܞi���u�ԝQ��y:��0�I��.�*鈹���c +mw���XI�\���J;���04��+�U�=t���VYc*X�U4�K$�s�aHZ�y����o��XzF���ՙ�U��G��֔V�[�h3��*�ڕ�A�ҎČ'5��b
K��?�U�'��Øa�6��2��4��==�H����6tZ#���c(TM��uf���Mb�� ���\�M�^߉*�O��[�M�D��d��A�r�����[�O����6Tc��"�޺��	X��U����4�'W4	Q�U��,_0	��]���6=��"��M�b��-�/S̱�����ڷ��ql����oHB��� Õ~�31?#H=�ZA}�X�N_!i�ʺ TMRJ8�qB����4�AŮ��7ZX���fڣ�Ą�'m��r=�	�&9�gk�B�z))i����χ����������Ç��ù��{�|��O���qq���ߎß�Uq�7���Zޠ��pVt�^tup��D�:L￺�l�T*�m+m����WЎAׄu�B7X��tf���[[X��XI_G�ܤe`s]� *��>}J��P�n��ɢ���6Y�h,1�(=_�B�\�N˔�F���Taq�iit�ŕ(|�^\��W��Yڇ(��O�o0�R�<{�4�~NARE��&1ј�%Ҩ���'H�2F�Q�e�������kyHX�uq
�
�.^��-�7h\B�J+`U�HU	�$74*�T|�i��l3U�� ~�i�LF%mVa�YF!i"����%��� �sU�r�FZ�a>�0��)�����/gJ�J�I�
�se�������s%�QY��/1���T��ʺ���fm��l_�D�X�0�5�F�V�����Q�I��$�4������� ��������{VV&�t[4��sZxe�U���iX֕P4�4�a��#�ʚ,�D�픖��FCҠ�.�Yw,�����T.N���d�6nu�]��z���洃&cdE�:N{yB�(.�w��QYg�hT�,-˸�FU'-���ɨ|Ĵ��.ON�*YPi�`^>�l���oK�Q�]����Ү�/t�k�F�v�ȸ�Ӱ�]�IX�,Q���U !CK�mZ��/q+�hHHQ�cٗQ�I�Jcd�9���O�2����a����^���$\���f�"�4O��_����%a�if]����"J����4���'�΄�e�f`ٚ)Р��|�8�*mÒ^X��R��`�8��
����)��U��ò��Ө�6��2��Ϙ��P���h�F��ȷ7Ѕn�5�2mJ�|���(��Cw���L�;g�^�h�%��i�-��.�>������.aX�U�P��f�u�Sbp��������闆PI���Ftd�7g_�M�Q�1���]�h0��-u�6���~��?e��V��s.��#�R�E��@��s�2Iئ#��]X}٢�Z��A�a�8�{m�� �3O̵������ZLCd�u��#3�(���V)*}MI���x�#a%�d�H`iփ�UbQ����:��	�2@���+�2��L�6!��<]��~��L$/i�P3��$���Ly�3m�>��;<�@�ޡ�!�u�,ߊ���hi����g[F�'7�d�/.�4��Gk!0�\	���k���/��L���|�[��s��	�u�a7GLcs��Hܡ2��������B��ʺ��6�-���8mYe�@�ilJhY����j���k`_��כ���|��*1�w�w��PZ͕v��Ҡi�K��"Wb�[�aO+9�G4�!�m A�J�<� t��A�*�`�^݉��a��w�V���i߲���7h���H��VnN��E��92ad������Z�0��'�iS�Ҝ�:A�i��|����%_�u<\���Kh���X18�"UK�--�
��A��8�TM�WO�=�N_3Q��v�t
+ z��N�R�)ڙ -/�U�����~xy���I����������ݼ�d��?�����Y��dd��m�Y�K��}Z���ȅ�v�d��a��޲����+�3��QYo� ��ŝ6�M�e�c�����$����|��u�]��1-q�O@�J�6��-�SU@���N��ӕƽd4ғeK��մ+߱CD�;��ϼ�36۪Á�hڊ�W�C�J��|=hT�yI +����5&c���w%������U��fڥU�Q+r+MdD�}����Td�i�x����ۂ�M[D�z�4� �M��%�����������o��߾���V�?^�_����e����_����������ǿ���C�_�\~i�۳��X�u�\��A�T�<��^����K���9�����O�j°~f����d�	jIb-����    �}x:�/�7��Ȟ���ĜN?�YA+e1�𼟻�}�dr�Q;ߞi�h��������/�_�8������1^ ���H~�kb:/�+����,�7t���@Z�#�o���a\ٿ�e��v���o�������W�g=�3r�}���9�o��9i�+�ʡ����2ޞ�X,�{�.F�s}��׻)z=��r���˗����k|�C�*��rO�Rs^F�pDR�Wޮ���iΏ�^;{��n��w?���L\�5��\(��'&r��r?��@�8fϴd	:����r�P
|9����/��5�ٙ���=W�1IW�-nY�s�{�?�qz<|ڿ��?�ɹ(f���8N}���/4[6��YrOe��_ۮ���E����uw���u�����p����ϗ����)\��DR��ƀ�Y5���1����.��;6�g�p�����tv�Em|Ǳ�Wĕ����:ʏp�rO0~����c��&āB4�;��?�z h�-�
!ciN��̲֥rf�Mڃ&x=CX����H�Z�'UC��'�����?A���sj�ݒ��9��ȷ�"��3l,&b<�f��9��ы}fgN��s�+W�9YTA�=�����?�Ď�P�lzj����t)o|uĽKd�C�ś/\֋���Z<���@׺�5�΍/��3q~"R�W�	j�OMW��ܓ}в�b��T�S"��z���(��MLܣv�7�%�)]j"�L~���'��qt���+���@�\��W����k�pu�%XOQU3T����I��Q)u1j��RM?����51�-�O��l��M�m��g�:Ï�0O@�?GP�$�4�zsL��u���]��4�饬
I�p|�R2m_&m�RQ-�i�B��jc�
M���3����:�XVS�/���1���3��D�C+s�S����j��W6b,Y���*0�+�B��-P�w���P}Prm��s_9H]Z{`Kk#���K+f#��߮w�}��~z���+��/��3Iq�TK8��EUs��}K�[ʻ��+�xPMr�2F��i3Aj�iÔ�豧M̭K�=�b��z�eA�ʎW(�)��:o�I]'PL��.&��fF�1w>Mޠ��i�U��1t�֗�W~����Օ�U�b�ɴB��Uw����')����er���0,�)�6&c���\��[��m�V�=aQ1彊�6&�P��L����icb��MǗ�kj+��K��c(EunCi��s[κ�ˋ��&�활�h��}z��iN�q�u�������>4����n�zǊ'Ў��2�zP�[8KA�0��1�4=2e0���bB/-��7����萴5�3ֈdd����������U��S�������f��pjqh��]��T�w��S=s�kr�}�I��S��ћ�0M�u�ο4�환�g�dE�b�!J�\����Ҹ��=_�Jx�=�6��ަ��T�Һg�EM_�Z�/g�K܃�����h_�C!=�Iq��z�R`���o�_���Vz��������j�KM4�j�&�����65��sϤ�Y�N�ƼK�����)ES�5M-]�����/}�馦N�\�7�<e#
U�S�n
EMD㤤���:m�;PS�-T�C��/�w��|{���ؿ~��
���/�|{&fwWD�����*��������6���S$��W�I�ip+5��}L�W��1��j40�����9�t3uc�ɥ���Yg1�)0*^6����������T��D�y1��J����Q�h&���=�$��R�7�P�nzSa�S�y�^���T�j���E���o뢹�1")�-h$io�
^�X�%<���OPLRP�#D��=h(���G>������=ӡ�E>��h/%�'�')��dҕ��	�������~�x!������wT���GoIJ/���RB�
�\0΃��4�$�#,��9��*�%��M�j@�����d�sŖi�Q�v����������ᴈ޾�㨶��L����W�j�?z�3@5|2��@?F&�(0A�۝E��^Wf~Q�ļ�-�b��Q���XB0O���ϐ9~_�}q�����9��8�~�FAu��ޞ��_ #�CHLS���u�}�4Z��z�f�)DP��e����s��Ԋ"��Zʐ�_�^D���L�LRA�m�H���a!p�>��S����x�_:�p��L)�c\(M��fɛ�u���%�b�Uֵ�&yF�HgaE:�=�n�n�����8���u��hF�m@�i�DI�PZD2C�b<�4�1�mܭ5_��Ut�"Щ��,��"$��:>@���˨yq�͇�*��[���Z��Z���i�����.C��(��)Q�K/]�\�@eg#�����VKY�eE"ƭ[OV���GX,E"���W7����iZ���霜�2��)�h��bـ���ǧ;(G$�����/����޼��xedFg�n@t�iwؿ><_�����}n�w�y�?�}�����e��L�!ꂋ_P��?.���L�?-�<W���?��=쟞�=쿽��z��ß�����J�]~��1M,�)`� �0F^2<��b��^fYNLq�2!�X��^BP
䵮�KqNb��*�	��uUNQ}]5UN\W�\aƢ�|����ke��l��No>&�5��lՋp�ɷ��H+�܎�Gv��S����27ݓ ʺL�$������Khp-��$˂��դQ�5F)�Y���z�SiC��d�  ��6��'�=m%P�%$�'G'bZ��I�������=צu����
�S`ΫH*j�bz�)j���Q�"�E$���n(�߆��&4��3?�!�����48^�_���(~=Z^�h�O��e4EC�����DR����H�S4��g4S=CM���9�h�}q���k\��Lro����^�7��Oy�!&�U�eFF棘`cd>j�@����J���ޟuWd�b:#��嘽�E������X(��cd>j����T���u�����������Ͽ�&i��|��{f߁���<s�C<E+��Xߞ�S��P�c���m���"M0Y�1������ã�1n�kl���K��-�����?b�CB����"c�C�F��b�C���L���7*�>-�i�ĔD|��~ѹ*1�<G/V�Y�bQ�Td�>1z]E�v2�����Ȫ���[�\���Y^h����@�K�7�o=pl�V�x�6n(�B�r�����74��Qc�2�bk���q���kT�{5�urJ�5U+S%-����e�r8�Q�Y0޸Y0��( �ۺ,I\L_HEQ��u��eLH	�6y>7#�p}_g}k%�̤�x��B轢߼7T�R�HϸŴ��f�q��`Y��]X֐���/mB7Xz�j5� �n��74���F3�p;i��c��걖3�\@Q�4ǈ��4NSD��-H��Yݺ���"k퇐�P����)��*�m_��YFO���-�sQ|'t�AM�W��(c�I���2f�K��ɳ����u��n�3GП��(�6�\~��sOДQ��u�2t�ϲ�z�Um�%z���}O��h.�[��yF� _9��8AE�s��}==w����X�#��Ϗ/i��6�g��Ĩt��2�ѳ~;��1yh��̡*�/z�b��~�$Sؖ�.|���&�r��{���5vn"c +��GX�;(�|7ct�Ǽs6�29� J�a�&�^�L�Z(S��Ga4,���۲v�"QՌ��L�A)O�ZWL/`��*�ֳt�Por��fo�|����+�ʤ�7�b[�I���Ň�9榎9�$r�4�rέ��܂�Hg�6��,���En���+�S�8듆�-iH�j�|�-�rz��WaY]'���|�LFc]�Ns�WeJ%�趌*�*@',�DhLs�$�&��)���N#1领��X��9��7A�W���nZjC�������3d�P�0����7[�QF�L�On�L��'� �ۖ*YOȔO�G���3��t~(~���{���VF�FWk;�''i�� ���<M&<�\J�o�I[0�{�7��;�}�M{{&& j�^�    p^Ll���c�#&�D�rJ-3n�'B��Yɬ��31��8��Uh�hF�p����h;G�~$����Bk=���IlIȆ�/�95dJ��'�����kE�̍hw/׬I3��.�T`51i?=V�UB�F����.n����s����K�vZ�Q�*�] 1 ��q�L�XbHFk�C^��hҵL+/�lP��X5E9mLќ�����R��1��"��Ma�ાߋ7]1��E�'I���#��1�rV�9�dcE���42��^ �ֹ=O7^��4*�QCQKg�̜FUP�YL�nE��w�!�^A�H�S�a�z{���0Σ-��hy���Z��i+���7���.|�홸���Mo�W�WL��.��\v5u֝�K�b���^݌>�/ḣ������Z�	�َ�Q���)�ҧ��1�2$_;}�Dn�޶��}��C?ofj�Cca�i�N�Ǻ��Q�?������Ѩ,-�"s>��2�-���^��(�\R��smY�E�Z�&�7oD�j`���ż=�3�'�7"�)�bְ3-��^L����w9��遒�J� ��{��mUK�8m��������C@Wj=V}��J3��(�d�,�-Sm�(��+�"�6��jt��TX+�C�8@⨤��7+M��U�J,b��k���=��ׇ����xs� �����3�qer��?�!�"�d�o�4LW�%��i�Ƕʙ�1"���3q����S���*u�\�c�r:$�ʗ�Z8O���<Q0���SŴi��@�o�pF��R���u�G���HBi����ʕ3�R�}ޢ��,C6(��^H/��3�Ċ��>Fb�&�V����>&s�Vl�1��i�!F�����^_T��C���G����:�
�C��`\# ��� �\e�2�C��b��	�[	�0���9�D:�%iT��Z�Va��*Tf���Ò�n"�+c/=��wi�p&�R�W1a���ztIQ�;�X@�MSA���1��r؉Q�xK��v�r�I{�0E�$t�1�y�-�>��ro*��h}(N�^���/�]ܢI!�M��mn2F�Ō�"_(w�����h|��NF��]_~�	��M˷���O�k���?�?᭖��_�e�cȽ����#D���D�"����:�J�8`E�4!@��H���b�-5o�U����e���*�3��H��Jxk`��6�v;����N�#�+&ǌ�'����i]�* �y*��ipVQ�?�1�0j�瓞u����}�'L�jb(w5g��ů��DTu���9D�U�/T�M��i��3�0j}�4Bb�&�AXӊ�l)�D0����>9�VR&������hTL{u1�8Bc.�;����K�BH���`���Ϧ
3��j�0��Z�������&U�?��cK�Zs�?�$3x��`"��&M5c�/T�Fw�sY,��.��[�k�ic*��#�i^�f�b��$���g'�zQ��-շgZ�0�]��8:�e|zb���i�[��$lX0�Ȥ�����_�ɴv��n�t �K�|����J��Y@�B5���T�1<��Ǝ��1�X�T%��1�P��b\#E@��8E��h!dJ)M�mldig3-a5=�EFxx���Wm���l �3j
�i&�fײKF�F���Ш���"�n���#w�X'�qg�]ͫф��w���n�E�r�QdlY���hPZ�h��q��s�e�U�5��:�RJc4���0�c@��>[����n�G���#q�x{S�iG���(��OŰLS'�&�^�[��7�:��"��W�Z�8b
țˈ���'M�1NX"Z]���KLm=���q���c�$G0�ܲ�Jy�ٱb�piF�1�b-������Jg4�i`~��"��@)�ƫݛ���S���o>��?u�	����L�
,8�v����������۷�"Z�~�*z��ǐ�����Ē"s�c���q]��Se�xrz���?ܞ�X�{�z��V����&�K$7����9·&���C�A�T��F/�$g2MwU�\_һ�?=w�z
��SlRW1M�d�i��n��[��oT����	�/����ƴ�#|EʬlJ��/�7��	<�8����}G�\n$��,)
P������_�7�i,��W�і�+h���~=����Z� ��FE�KB51�M�u�f���6ƻL1����� G5����^̈́R�%�W��fjb��-�hTN��I�6I6E�����W���n��J�X3��F�zٵ�-b֜�tX3a�Ɯ�z���!+�sژYM���k���9m������2�]�����س+2��\ZI1��L��AT��b������#���~���X�W�����-��;�6
4���"G����8چQn�	,P�U�x-��/%���	��4=n����^�T��F�ML5�fDߺǆ����X˒�?͉��0��(� }l|��	%{	����;�U��v��l�y��6�}�s����s��UL8G�x�@HH��(�X��)�<C�	�EG��f�N@*��i-pM�R@aO�Bn�d���}���~�Fz��
]�ʖ�����L	]K��=g5�_��﷯ǘ��yA�����.��?7�ek�W*���PR�,n�?|x||{9�o����=�����o�/��{�|��M{�-]~�۳I:*F$�>@��׭bk��khS�#�U�L���$t�� E�]Л���>�����,1�������JjׄN�t	 -g?�ՙ�Bj�O�o���;�_��3�rٵ���0�<-���,!�T�2M&��g/i
��Wt��G��D$����R|K���)���q)���&���>C����??#�3���)�ѕ�)�cL1���e���Zt1�9Z��<CQ���x��6{�'B���V\�]�іʜ^$�F�6B_\������4�u}�}5�!)�$�w��s��RsK���_�0�g��*��b��4��}QN�}�N�}@��b�Co��g�Z�'��8FS�6�TP���ܴ�j<3�+cȼR3���[�nD�T���L�=m�]}���j"�F�Orz����䮢~��������d�B��2w�?!�F�d����@����mnV3h�j��U����W[=Ï!�b�E�L��"�<�بQσ�B���".�j��������%��G-��@�T�,>�퟽�st�]o�o��R`5��*A���-��s�}M�f,�{�U������R�*�E��/������o	'�ݯ�ߗu��1&?�I�/�=���}����"�2�-��/�z�����Қ�o�k.�v�y'9K��&*43�cL�B/c;0�*�D�`ڙ����Wy�:�����
N\BE��[P��_�wkwY{U��c�W�9�P�2ðJ���ɨ���4�B�4Q��X)U3��L���Q!���3�b�e��C|����Ǆ�꺂��XA��ڇtn��b3�y.���%F��Z������OEٞ�������K��s��K?ݞ�������H��X�� St'"��PLm�iT��H�lA$��-��\��S8���)@��D���i��ʨ?��K�_"q��A!�oaC�M^��A����"Nf����$���$��J��<�����s���p�2n��`�f�Q��7�`���R7;�\��@�4���ʧ�RҌ���.H���BE����H� T�0�Q�$!�|���{P�լ`,�N��Ҡ�3P��H��n긍��#!�Ԓ3��T�E0�l��|���D�t0�ܑ��حJɟ ���/�f�]/��ƻ����D�����������;�����%�٘x�p�*��[5ϲ *2�2U|/9�݂��íiR�q�xo&�z��Ǵ��
�Q#
4�S�Ð.Xlk@��J�D����uz�U�������ʵt֣��MU�`9�I<E)�l�o
{>9�G��#Zq�+���� �( ,@��w;^    ���ڜjG�$c�G7��x�n��{`�\:I1Ӳo[�`�X��0�g���6�+}A�����Y�+,�Qs��������ӽa[�%'4��9T)1���,/q�:��~=߶D�'6�o�
*�*��<��~�?՛ACgv1��Jz��..QȾ����lG�V��ZR��v�m��������.��=����0��'�_~�~v��M�n��`�@��]�Ç1UU,�N��`rt��,i爫`/E��tk:�Yf]У3IQŖk�kk��9�`b>S��DQŌkkұڃ�Vo������z�6�vʮ&��TJq��:2/��.��CJJ\�=��8S�G4Â6�([-޺T��@ir+�4�m�ۻ��p�W�a[JL���UZ2\���Wh6�k�\��[�#)�ï������S�F���].���C���3~��-[��T��$�NXʓ�M5C����9���L��I��J��UP�j�� �?�+�Rc)��0{$�����ccd���šM�%�F{���ob�����M��A�ųŚ�3qr�1T唇�_�Nw{&�N��)
&w��i-H�@A�Ƿ11�����3�ae�sc-���n�WQ�Mg]�:�=Sq�x�iܾ�����o����iK��7i��-5��.�[�n��43]F/�%i�\�=O�e�?���p��x�|SZ'1>�W�9��oG7z�b>����a��e=;�� ��|WLdv���e��Y��1�c��]ƼL�	�E+
ź�̸���;����߽Z�6��D<z�q���4V�b�"ji�ލ�4Ն}E[*c�-�|@��1��|_rɲ%�[��PR�O�t���]�|}��2/����P�\~;vM�B_��W�h���}���S����>"�ԣ'�e���o���#a�{y���{�f_�7���v襣:��C�E�ܞ���[(���Թz���Q��u�9]V���\3��"'t��'��{������޶�v�ik+�jYMǯ�iwؿ><W����^%������8-�r֋ć|ƺ�$=��y��A����kѻ��]�Z�Mo�o�w�O�vW;����q�p�D�b�!�n��3護�>f�Q���]��CL���/h׼��1�	59�P��"z��kޭ��bd�z�V��ㅙ��zkE
t����(СTW�X���]D�-/W�H�1z?5"tA�T���g{c���5Fc�Ϛz�X���Rf�^#�TL��1�b�T肪��o�����,���˴]~��g">���f����[�dz��
= ���W\��Tn�#�"k*T	 ė��a疈V�w��.���*�Ӄ���<�������V��/��<�/��A}<�R�^���TM�2�	�ht���,�𖡀�=�w��K��?_w�e�y\]$vr?�nf����	.b�����W]�\~	�~�� ����X�ا�[�[��<p��U�^��b��~���$�r���l��a��:G�)�� �nx��o�wET=ZG[�/|y��V�TE����%��Ԯ�X�X����ְJS[_nZ����w������!8%�����P��.��{�L��3a���*��2�����[~��ǐ���;�Ѝ@��'��r'�s)�b�w��Lo)zv��e�{Q-P��fQ���_k'���@�mKG��Wk
I^<h�{��cP.ѱۇ����a��]M���g��p�Ύ����s5)�R�U�Z5�)"��|q�:�C:�@+'���L{7iB��26����M�N�!ը 8��<��	 �nzO	�`;�+����ѳe��s}��������iH�oPf��wa��
Q�D
tH�w*�5ɛ���P��.��3�Ok��N�����/��$uu��ň}PJ�n���i�"ĝ�P�h,8�F�FϮ��	/D�N�(�N�4�r��s�끄���P2B�Y��eFOv:�m	�P��[z��4���s���zW��y�qT��|WQe�ܞ�@l����q[�Ķ�/�^L�DS{����U3'r�X�c8�#��+�0�e�J8S���f�tX���>>������/o~8��x��sF�k�;#���%�D�&rp&�-�!,)��L�v
i9R�f�ZW�����ӒH.�IOs=һ?��-�'�X��'Ø���y���,�<��i`Η�W��nZ�G�b���R��a���Oլ�m�R�A2���if9+��Mˆ�؞3�]4Z;f)t�ƴh���0���^H.��[�QW��4�&�n���ڿ�)�zM�U�s�xr؞cs�6N�g���^j2׹i=������g��Ĥ��⮦�����R����YF//�;3�MtU�s�8�H��c�^y%�Ӹ��hB��H�>ߊ�[c���o%�W�
�l�H���6��:Fm����m5��,���\���b�b���Q8�� ,p��+&i��8Ca2�ឮ1
\'�MD�s�fX$�����ѵ�I�[�23UuY�O����*J`8�9�͍s�P�71_ηW/�(i��q>�=X�JEO#z�;��q�b��L���6�#C ��m�p&	���|]9N��^����i^��2��m@�ގ����q�b�+%����;Y��|�����;����x�}s�Mo�ŗ��YVWww�4h��RS�Ԛ��ѹ� �����`���n�L���Ż����x���"u�΍���lbFG~~��ac�:��h;F~���k܎(���&F���2^�GP�u�Y����LWGL�V}%���[��)"��Gֵeu�Y�H�2�&��U�|B-m��婚�.f	Iho���w�O�vWQ��_���p�j��2��\�XL���s�82�:MM8L�������_�`l�C_wM��]��u���0Z��zh�	��]�7�}X*�������rO�ޟ�<<<��ybޞ^�=>�,k���\�����嗾�=�4|L�K� �.�61��+���X�3���P�t�ۡL��MS��3�'�.�N8�]�O�jVε%v��� �UQ������{/*�z=�8l3��Ɣ���un�Xn�E���-��t�"C������@�dֺ�����vE���Y3_���[U��7�B���a�a�I��~�OO����҄κ�2�`Ѫx�1��B :��c*��}L��D�E3��$"Wq����"y�}UR�y��T�N63zrMIw�QQ�q�s1=yjs�Ӓ��乢A�K�ͅ�ߊW���b�JȒ�y�N[���,Qhc��h�ݱTT�9 �%���5��}����Zg|O5��0�Ջjo�4L�yϕ������~�'(���T	6��y˶u������|�~�b�Th�����꽕�=�F��]��i�ܞ��f�L������C�dg����O�����H����&f��dV���g2�����'%�w�d�G�d�ه�`������Β*��7~ó�E��$j�@2㣟��ʟ�S��z���b(`��y���@����?�Ĭ��)��6�jQ&���._�p˴��L\)��Q&�G�na�F���T���vSH��v��)�5��2|>=z�X岥1��B�L#	�*���p	�$���bL��l����$L�%DI�o�)��ò���*����2�9:J��b	���#>ߥ*O��Ehzh8f��$�9�B_�m�=����6��.�����B:�_�|ڇ�������ҏ�gb�)�����e��0b޽�߿���=����'ߔ��?#�*�VΪ�]|�T#	�Fd���%�^,����/w���ӷ��q�^֟���x��+���5���`8�Y�P���"!0������9�x��%�XU�_Ζ��)7��@�*���p�W]g��K���5����/f��Ҵ�gbQlo��p�Har��b2�R%4f3�|-�?��uN���ٛ���_����s�=8��_�r<�[N^z���ebȈ[I(�˔�9,�;��x����홈��|��7�U��-�Y_��3��@y7�֡��Z4 �D����<ט&�Rd	=56�h,LcG���5    �#KCqbS�t
=�=M#)�f�m(�Gm��.�c�ͯ�m����\��n�^��h��·�˓��<t;�r�I��J�~���v��m����G_�����;�_������r퉂6ȠIC0�z�ޮ
� ,�\����+�c�fo�E�ɚ�K@���=s)L�5D��Y[�M�g���ܫt�������I	a:f�$�^%�zN�z�1��&��ӻq/*_�B����ˍI��H<�kϙ�^��홈ñ+ԌOOuOeħ�%Xx��S�kN?�oh� /�BQ1��xq�b�8�(��;�s��$�%�o!������|�tߧ��>�v����;EB��ls�6Փ��KxSޣ1��<�[���������7L�D�s{��q��Sͤ==��:�y�L3X�E$�nHH�G��6����Û���P��I�zL#
���a�h8~�TN����*a�{ ��s!�_���R��M�����t5X�EWC��!Ci,�pR�g%� =��:��c�A�d�FJ�P�goH�sųw��:�W�r�O�__�/��s�b��4�}�f�<s�V����̙�rcŽe��Xz���
��KL��`�n�,>�	�o:��ρ������Y)a���dv�#N���\A����U� K���*&I�w�ts���5��ukSɺ�Qai���"�{]W�ZR�#��MY�ex=�n�[*�u��Wy������LD����<���ծtSq�^F�2�Cr&�߬�=��SoF��V�� ]p��Q
]�0*��ݩ���I���i2�����D4&�{za�ղzK�ظ��X,
����_��ϭ~�U�K�(&�
1c$_���,�Z��L4 ��нV7�eʋb5#��8#�uJ1,jX�1�"Gcfe����Ԛ���9 f*��nP4��U�}����z����̉
�+�m�t�&jG���#F)����ۉAI��Řa�H�<���I��`������'確�pu�bi��iw�ó!3H�-�=�>F(;G��]d�|4,/����h΋	�CB��u_S`t�8AKE�� ��O�^�Q����P=O=��0�fu�g�!��OT'��w&vW�g�(ѳ��@���33#�񣡘8-�P�w�x
�E�'h4f�F��]���ԣzܽ����?��`��r�r�9�x�G'���w��c��H�A�|�S�4�z�ycܨT�A��4&%�&��@�L��4:eV�["q0=�T�,3*�0��Ҷ2�a�z�k��T�6��z�S��Q��qCн4Ǖt�k5#W��G�ؙ
Q���ǩ&�bң3A��K9�]�%o<=9��exlJ:�-��AX2����t��8��r�S�����l{��We$���ib��b����'C�`rg�"j].n���6/ȼ�h�d����>��g�t�I�t�_:�EO��߃�2��"�ݠq,FB�i�6����P\���L7�y2,�] ��i~�Jm���{Ơ@�P���z&�e�U��nf��FKO �������r��Gg�k&���=�E�J0FJN��q�.��Y �h�֋[�,r}�G�x �������	��h�ε�a/���F�uw{���L��L@���P�����7��[sc%J��n7�ۗT$w[h�ȍ�~W<C�V�ƴ�����4�h��  �TT�@�� "L�ݠb6M����n��:�3�}5��'>�V�3�~@q6I�Ȥ���e� J9�i�//)tHxc3q�KZ.L��"m̙����"x�(; x���o��3m�o��_�f޺F���%�����z�po�AO�⊗�.������)5�����0�mp�.��w�T���'���wL��"7������֚4��\�&�qm�B��cTy��0$����s�Ajw��B�	�lv�ɂ�����,(�L�╬�C�P'�����s-�#�;Oe�%GE[6r�-p�d������(z���y���6)�dI/;y?�W��ŚRցt*��D�?}�6�Š�`	��
#i<<��%����=vْ���'&C�ͤW$��@�l��ĸ\�L����f��w��&��Z��`xe<%@'������L�j-�X��o����'��j*��~z�0��L�B��
Ɛ���5�M�'���k��p�X��V���I�?�iA��1ԯ����~?��|8�����u���n�D���P�8��3��@�t׌]�Zո���Q�H��/�XnE�E��NU?��ץ�� y=�}|���R���W���{����j^n�VF%���7!�Eg6��H�	"9� ����k�'?��/��j��s��G&G�1�hL:����f�􈭡v�����⻅hF�g<J> ��prŊ��P�uJj��Pk��=�*+��2�C� l�?��H��]��%F�Q8��+�P�~Ҝ�&��S<j+-�14������\f���ǧ��r\����#�O__oo���xY��_���L��R��N���n!��e �,��m����BI��K4�I����i?vo������?=<��o�Ŀ��lk㜭$�pj�?m�׮�M���8a��7��� ��91��u�I�� 杝%6��������:my�/��tv�y�m�8siJ��� �k��O��O��?�?�W	حa ��C�Z�9;�f�]�W08�]P�k�O�%,ψ(Z*���LL%u�� ��y�PZ,�!��Js�בj�*��M�8J�M 8Q~n=U���fH�*/��Ր��D~�$�����~�H�b�����AF�N��p�
b��ԃ@0�'�%{d�EzEwk©,4����v����f��+�kn��ѵ2�4 �D@(�CC1!$i(},�c��9�(3C[�����਱����o r�F�bE,���7w%�m\A�L�g8�Q�	Y	�Z��甓�C>?����3*VOH���Я_w����\:�l8�⍬��k��aO8!O�
�U��X�v4;���Oz*�EI
��7�(>٥O	��i�8�Q�4e�7��gJ�4��ǧ�C0�;C�y�%'�jNv�Jך��%�uE'_�<���|d�/3bthBb_��r�'hJU�~��T������ZM����㨽bJbP-����3k�����IN�V��������c�u�T���c.LI ���0�3�r�1�&$��+�N�;Kq�n�ׯ$�� ����%���N�b��Ϥ]�;N[LG�rm��z�r?�L���ݧ�͢��}m�=�s��1����W����M�{![���I/��ˋ��������?/���ϳ����OO?�IXz%���쿞�K�� �y�v����|������as{}{���/"���^��Iϧ^������7B�FAY�m�Y���t��$9}:e��6�����ߠ��P�"i�H^�@i�X�e^e�T�_����<	�ʚd�G!�8����R"]iƝP�'�bim���3�GH���5%k�|�.*��lf=>1�y�&~�qPN�厎��]>^-G�����Y~y�������7J�y�}x���%���
��W�,E�m����u�����"y·�����|M�_�T����:��N����;�\~�$V�D�b�_7�o��D�n���~�����mx���~�"��:��+ ����>��{Tk9�]���:���U8�Q�ޞ/����%���Z���oB�ВU���U�W��^=�3X�y����fs���xo�{$E���>:�:���S���w��}p��w��՚���ޣ*ը���UG�N�r�](���A������4z��C��ޣ*�z5WjU��8�Zx��r���j%�w�Qq��6�Hs|��<�����ݽ�C��k��L`�b�:u�T'�����S}fHp�0�<2�3Qq�Rw�0*����!�T����� ���d�Ed��ly�q���̺ �JH�!�2�ˤ�<Ϲ�����kDMe�-g#ZP��[�
.RrN�L`�:FEyg�#��Q�ꐺ�	�bT�1lA���X| m  EuV*ʪ����j8Yyۂ�R,o��P�\���;欹�lZ�J
����h>�k+�;_��5���X����!}^�<?��R���M;ʙ,��Bz��u�"S��L���JVl���Yt��QE��@T�m��n�wVmw��}��!���.����G�M�A��K���;�/+.q'KT\.�TM� �̹��3*N�^F���j}���7�'�@q�z?z+8A@P�5�tueL������w���b��A��n��*�:��hd��U֫�Ь�YE��z���@����bꮇq0���">?�l��J�.u�QE�,cT3����Z�d��/����|����sT�M��Ҟ��J��/����1:{�y',]���8���/�p��.����zT����qF���'m8�.?�׹l��ĳ�V��t��;��k�6q��_rYW_7\���$��q�Ir�.r��d�u���O�OB�L̜tph�;֚��8}����2p�����TE�jFz`T�%�57�Oդ�;S2rq>B���ێ�*]�֫�%�ŷw�7�ry�]\'S�m� ���)v�*�w�g�l.��Ar�=.{����?�kC[��C$�4t����E��B�Ps�sg����qb��q�"tͭPTdC�3q��x3bnJ��N��h�U������+{xǥ�8����'ޡV
�s�l��#�š^�dS�s
ƒ����@ŝ�������-�ҙr��+˨(�jі��J=�]����a׶���r�E�V��;@gs�%�t�F�ΦF��xӕqd�ݝ�[��0�!눹��\�Q6�h��Jɫ�[�~�����(��G1�*��X?zi@�`���쫳S��u��{�n���������!r���Ю���BS��r�ҵ)ZE&\�#��B�����-T���3����3|�j{ˍ^���snk�.ׂ��r��5��xkV��\�	MX����9x�E�������bPsdX-�����Qq�AQ�M��[�-Q�X,��meB�v.،�N8Z��]�f��i��rO x�-W$�Rbr�r6���|$%V�A�6��9���=�?��uX����{��=�Z�-w{N>.���B>���n�Ynp\i51,��.�Z�짬aX���o�S�%L%�-��,�3:}�D/��ܞ����ƍ�ʼ3�\��6@Ty��\�kR�,��>~SX��I��k�t^}�-)p�?$�|�"@�*t��BE� ;�*�? �
g�XV3X ��F��
~ kV�>�����8S�3Z`ssB�G!*�sVH�0���"q���^r?��˂H���F�H%V����MQE�&�P�Ë��F5�}�׮�k�
�����������%4E]�èfy�3��`�I^p�\��w+�=U}1�З�MT���X����AP�s�ZE.�g�Ⲥކ�۳�#��LK}aT\����Ǿ�՝['��Ut>�
��BP��n�-�o%a=F̑1������X.��C_2�Q�下�b��.Re�c�"we4�D�?r��`��h��9�.3O����X�ɜ���aT�R;g�.�&wYv�@�:6P��h�d�OB��#fUlY� ��5�6VV���|I�ٺ�	Yh�
]�l���0�!D�V���(&~�Ԁ�~�>98�m��g LR�%�i��@u��
��cT��k0*r׏�&`Q�'^0��Wu��.2+�� �u�g۽Qq��0��∞����g�T�}i����6T���'1*��
Ywh��XT��@��MF�;�@�������R����o�����4�8�'``����g�EN�:[n��;*.��Q���s�׈�|�n+a3�+8�AE��ű��fA���ӧO���EN      �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   �  x���Mw�H���+�x�*��|�zQDQD��T�~�ۘD0q�L2	ǣU}Q�Uw�q����AR @s�b/�6�����J���?���j�1;�k؞(v�2��p՚G:�����9����73�6�k�b,�v������$]'�7�Z� ��������!ɏ����y�C���W*>� !,�0!���s�\:;����䱹��À?�H����l"@�Sw>���;7tP��R� �+���/�h��K9����$Oa$�oa(LL�8��� E($�  �h��H�*g��B�G?����O����U�?n�%o����L�0	� �I��05U# [<B!UyVwO���!�sG�ͤ+��I�2l�1ȕ�<�o��ᕙ���p���z�6�2:x�$[�n���3��*b(�(���:��kK�cA�O*��l��[��o+��T���5����-�8��r�ϯ{)pF^b�r�N,���dj��Æ���Ŷ ���ߐq5�$T�>�h a��*������g��7BqhvC�Fo}�`��tqi�������aB�:�i��ߙh�E¯L\�D%�S��S���xB�Z2�@��!d*PwO	�Ɗ��'��n�����"�+JK��g��g����1yTw���� ��|�b�B�-�+�p-a� ܿ�*��E�X��LG��d���*�r�X�I�'7����x}�+�֖���.3��m�0A���i��
1-_�TlA�c�~�~����#�f��x����}%��܇��)z���v<�C�?[���id�sp�'a|��&�T4h��M����+*��	�;*�U����JY�g�˙+
�$b�l���f%�x�[L,{L�'�(��[v�5�w4^P�|-��_d��3��
g "��"�,��+Xﾒ�t�y;��{��/�W�f^����Fo�B��M6
�K��9������{i�6v��H��� �q�P$B�����g�"<e!n���S�3�YİKW0�<�V�Dn@v&�'��]��=��6� �}��� |i{��I��,��(B��#����`m��`�����x�Dw�G��D���i��Ȥk�����Ǒ0�/��V���J� ���Wb� �P��ʅa�&�[���wg	6٨�ݤ���M<�ʼ�d�F�v������A�vgr��ɗ�����[3��D�S�*�J� �C�`��#T�*�!BO�X{�\�kb֍��w2�m̌�o;�b�%���u��崸���^G�7
�u�	D��=�w��S7�Kᦫ<�h=�c�
5koH��.}�R\rs��'9�Ǎ�F�n�Ե����t������r������hP5��7ʒ�ɨ"iR`���8�w'�1j�i#S���r��5WZz���U,h�oӫ�	q��{e�Ɖ��u�6N!8� U�^xJ��DS��;ù����l���q��7�Ɖ��]{�����ٍU*��)��	��⡚�H����������N�2��'�qw�Tˁ�Q�ʻ�MR�&݉0�w�vNG��Ӊ@�I.�'UJ��|����NӸ,|�$�)��~)܉9<r�T�yy�r;���7K���t;��C�8ҍP��*�������od��x��z���_��T�T�_�� �o1Y�h|B1��j/%҆�($�J���h�)X��P1�45I��i$��;��lNf�Iw%L���U;���c��P#p��7*�ɱ���4�2�r��.e5eF��ܸj���/�j�4�mhA,+q��B�5e*T�o�oqA/m�UR?L�u>�X��J�a�]-~�S�z]]h�(��'Y��a#��@>�OWf�6��>�F'խ�ۥ�o�'݂��-�`%_&_�G�z��~Q�<��[X�U��-�<�]g��٘������q�)�9��l�����S�SW�_%]�_���;�{��*����u,=~W-8@Ld�1� �iȿ�J��V�xe�b����[ޱHEnǙo5-�po�m��* ���&x������+�X��|R���8ba�eB��~h���������,m=wNKe�p�3�Q��i0�K���!K���{����4;�[��
U�`T~������N��9PU�gh�U՟ϤlM;�^n����A�&E��Ӝ��s3c��Lw�@���y������LU6��W��W�V��5ia�      �   2  x���Kn�0Eǹ��R�����%Q�<�wPɣ�ƀ,�lZT�bG�h�3DÐM��G�;ңyHgC�}�cu���V�fm�m�ڢc��բW�`��mD��ۣc���=�3;���*c�B���|y�Dѩ��/��H���t2b�0��T�ZA�(}	Q:c������k���8cp��̓Wf��1��R������3�죒�g�$5��33b�h�L�m99�0Xn{�db����b�3���Y��|�`�g�&?�}F[r_���?x�}3X#�D}O�fK%~K��� � ��K      �      x������ � �      �   o  x�u�ݭ�0F���4�����El��:��4��y:��X��# �?��s�9� ���b(
ƽ�6{�Pl^W��&���ɯ�_�<6�T1� ����G�P��^�iU�8�֛��b���[g�Pl�����>�8�7����
8���*����{��9����������a^���\Y���x���ӻ��󢼯��m��yQy��f���>/���a����h~���o�Y�������0K}^t�����0K\�|�2�_{��0K�~�}F�s��0K�{�q�fiC�� �l{h�0K���I����cU����˼�^���_�fi�9G\;6wy�0K��9�Y�xT� �?��!N      �      x������ � �      �      x������ � �      �      x�ŝ���8��ϕO�/���n��1}����\���O������ߢl9m9E��*g�?J"� �_a��~q��h�[/i��_�q�a�
�E��4�0�4����ï�����^��Ǉ���_��w�/�����ߵ�;��p�B�d�Ci0�����-������Ͽ����9s��Iा�N��)���
3h��"�hh��t�>}b��3(;� ��M?Ah�*��,�Yx]�=���@{�����(� �2�exe��20_A����{���C���3���3���e`��2���&H���:�����"l�A����U'��[��;��AӧAG1vaE��8���q�3�(�� ���;�0���$���0^��wU�O��m�C�[_�e����(�{���!�'�A����Hc����К�������+:]��2��5�Z�&g��*
{�q�?��*����}����/�3�|<���<�ϟ�C��K}�UG�͑��#��� Y��%@�e#�<KR\	b��C��A0,D��h��G 0,D;�`X�u����H>)��R��a!��)�{m�	�"��e�<�	_i�������ᣃ�$��	�H��UH�r�G�� ��A� �� H�jg$H�3��3��3V��7@��=Z����;]M��
���e��3}t��[����!�rg�c6)_:�tqe˼���2\?'�q� �h�e�����G���7��b����<��a�r����������22�G�~�F���(�.�Y��j�л��^p�c�ǔ/��m��v�9aᣀ�	p�N�'�_[uπ��/���5�0�wyV�#.Em\�,
Wz*bU�ƪ��pp��+78��8��s���pm���k�anp(\#s�k2�P���q�&��x�Ag��Ǡ�{̈C��SZ��t����1h�F(��isF�Ј��Y$Nh�Fn�o����Zz8���pɕ�r��/���v,y�.��k�7��+9��#��=�J�w�M�h���	���@�;�R�7b)掆��������c҄Ez���@�"�Y�y�a��,��% m�h�͒��|ʗ�Nh�͂�c��;fa��酆1��lz��fM��j�$���	�]�֫�(���	px)� ���8xd'����qm�����qn����qo���M�npEFQɫd��b����d�2�r���݇�լ���88^�a��GE:ŵ��)e�^;��%�[���
��^p祹s����e'8c�	_�X�>��t�	n���;��X_!�9�)�uv��~g.�>3f���I7V���X��B����9>��!洤��K~�<��˟�bK�v<�5�G V��4D\��tC����>9!@P7���D���c���c���c��H͍M�[��i��e�pe�n�]F�yf6�9s�g#E=�?Y�m�ԋ�D�v���Fn{��b#ݽ��z��߆k���V�?��l�R�t��?�V�?���l��е��l�Z16tm��aC�J�gC�Jqg::�o��]�<'[I����)v����#6 �)��M�T���tz߈54��w���:vq����4������9AU8���� W��x<� πgw��^ Z�~�&���kG�=��}pK(��"�QZ���s��'�T�(K���my5Z�S-"���#J��Dlu�ͻB���:5S�q`�=�M3�x:����}��yl�!|����?	BL��<-�n{	BL|���$HN�Ò =�1Ovf��0c(� ��P�#;�9� ��5���5@.���P�&���k����P�&���k2���P�&���k����P�6���k3��z�mN�"��SV�:2�x"�8D&�	p�L����N�Cdb>����J�,�8DF�"x��1�R*K<�9�=�;��t"#�����8�K�Jq�r�s��7FV>��x"�r"�z"�v"��8DF�	pX2Z��f�XhR���%��f��7:��2ǥ�D���s�w���:����ҁ2�����P;�1��j'4�uVwt���\9��kX�O KbO�~E�g{Cwo)q�!tl�)��rBo�ȥ�,Dy��f�>�,�Ǘ�t�[�WEr��H�6���o��p�섞EV��w��
ttG��N@�;:m��trFG$zj[t������@��G>��U<�r�TjO�;�����䎆�3��������ʜ�ꎆ�����᜼��~Q��h�Y�����^+���8[�I7zsq���H��H�hidw4�4Fw4�4�;B�!�掆���F���쎆�Ȟ���AC�ۃ���P3ٳ[�4�L�l�>5�={��AC�ڃZ��P3ٳS�4�ZT�lX>���Z��R71<���ѐ�h���dV'4Ƶ�;�Z�;�=��	�q��f���!0���NhD�n��@#�ws0�����!<Ј���F���`4"7Cx��+��BR�3:�����@�R��6k��|M�������������;�5�;�5�;^2w4�
���H�W�S���\��,�]k�F#�Y5����^s-'|vs�#�X����pcw44ܢ;n⎆����!)f�hH�%o4r�Բ;��9��4�,�9��4�,�9��4�,�9��4zx�sn�!h�j�sn�1h���Რ7N	8���;=<�;=<�;�u��h��Y�ј����1_gsGC�r�F���6�)��q�섆������4Ni/4$��;�R�;��vBCR���!)��ѐ����pJk��h�YY�/h��BpGG��-@�;Z���hZ��	huGg��]�N�h���M@������AC�(���fD�h��;jF�5#qGC�h�����	㚲;�z]4�˽�e'4��������q��Ƹ��Ƹn�~��#��hZ{�V>�eGz���C�<i�#�}�~�el�~I�7�գ����L&c3�L��|��������x�yV�Q ��������n���)&�KL�+�W|D���"��1�DvGc����)&�;�+&o4v?Y��h��qe:>��~�Z���?�q-{��8�q-{�8�q-{��8�q-⎆� {��8SA��qj&{��8��W�l���x9���NhH�w4$E�IQvGCR4��!)��+/4$E�IQsGCR4y�Q��t%)����b�I1rGCR��ѐ��hH��;�bꎆ����!)����+6��h��5�8֚��N���P���P�D�h�Ybw4�,Ew4�,�;j����fK�����l�/;�1�rpG��g�F�>����/��4�:��io� ��
������f%���fE���!���{xsN�Lզ�f9����1ɸ��@�omb��I6(zX4��$�[�W��ڌ��l��8��jM�x�i�Q��J�>�%/7�B�ʵY\��V����(��<�x���(26ۗ,�W��؆�y���OCǾU���o���O����?	L���X�/5c|y�q�<1J^o���!��e)?):v��4��rT3T�cG�4;2|jzR孨�|��Y��H�,qu,JX�r��!�o��nE����,�-��kX��8ߵ�&(��>�렛���?Z�~(Ŀ��^��ܝ"�����`I��-�脞��"��@�;ڀfwt:��3��.@�7�����z��ղ�y{-7K����IvGC��ژNh��w4Ԭ��鄆�)���f��P3w4�L�������$��/��А�����҄h�А�����Җ~rBCR��ONhHJ[��	IiK?9�!)m�'4DK[��	5������6C�h�쎆�YqGC�RpGC����f���P���P�$�h�YRo4%�;j�Vj�rEo�:II�I��I�䎆�dvGCRrtF3�b�V��C�h����X�����1
���� ?  ��/�R�]�T�$e��KK�1lnj�b�����i��	���p*�NMu�&-(ȓB�m�����:M�h�}���,�#JMd9|rH:*�L�VL
�����]������4%��SX��2��y��V���u�޵�1Gy���X7æ���ro��A���fP�v܇�٦�I/�>��e�tѶ#.툿~d%*`��s�˭�|��3�a��4���^K0�x��8jI:�.��h>l��6����^o�IB��w��$T>l���eG3d��fԧ1��(ȪX�5�+��_Z�J(�i��M�I3�Ӈ͵�Ƨ�:u@�'����n�*D�P ��*�"!�텘����Y�fZ,֟�����bAC7� A�
wC�"!������1׍�}�<#�;�G�n�����Ӄ�:!�l���<C���k���%�~�1.�;m����]��g��V:�	[��VBK�Q�(4z&*�]w�gx�Y󎖎�]O��b�e)�#�a�_.�����KS��-8��t��֣8 �Y�ܬW]6�)�������eD�FX������y+��(p�8� g�W���;O��r�I���N�� �P���`9I8�8���6�*�\v�c��; ���O�c��� �8o���1��p���v/�<�O�C��� ^p����p�C���Cm)�եHOP8ԗ"=A�Pa���C�)�U�HOP8ԙ"=A�Pi���C�)��7��O��g� ��Y<�39�1;��t"c�8DƊ?�&(����~�Qp�L�s��Qp�L�s��Qp�L���d'�!2i��#G�!2i�QOG�!2����L�(%Df�l���V]
e�'a����<$��$=�֧Y��q P��4�7�ʹԜ?�.BZY�W?xZ'�r��8�m����1*�~XD���avYދܝ$aX۝?��46��\�g}B�
���l�g'��?;����zV��0�B
�l�R$z,9��߉��H�h�Jz��-I��Жd�lhKJ�lhK��lA���3ctۨ�)��W�0}XDڙ��z�ك�Y=}0�(�J�˖B�kr��H��/��M�h��7aq�c�����6#\��I.ٓZ@-~T��M�T�<�*��6U_�FP�'U@O����T�<�	Ե6��ZZj�[#�<����%j5{R�őJ�&
�Th�'�D�I�6Q��B�H<��&RO*���1��
t8�I�*-�!�+Z�����Gm�JmH��È�׍}�  X�}��,*�\ly��\��/���˅tq��BFX}������Lu_v��]��֦@�Y�7e\��������k�haʇ�;(��O�Sؠ��w�S���Ӫ/;/�=��S]�זlު�@��#�����FX�F�o�$b�'Q�%D
���ޔ���r��e`�W���Tb��t���z��)wC���F�F`�a��n@y�e�%P���)=F��-h��4��T��8rr<���,'��ڙ�8"���1R	�p�ՠe�F����<�E�8�iX9���C��Q��5c�EN��]Y;�m��*]T�;\��`9�o�c$�.�f��j�7r��t�UU��M�����_G"0���:��B���!����!P٣�{u4�=D;!��.���M�xG���xw!���N���Q�%�7:a��m��֙������i�f&��8M���b7�]�n����G�z!=�]���G�j�#У������vy�ou�i�c��fi��Y���f�P���#N�����%zRQ�Qē�b�b~T��Jy���^�7�o�S���w�����L<6;"r�������N����Wk�!6�@�6��ې±tds��C4�x�;Ɩ�x�K��p홨��V�z֐��xdC�'��)��>2��(Պ�[U���;�R_�ȥ��+ުR;�a�*�!��d=�!�^4����L�$U��$�nuk�w�R1�8R�O*���'NXeO*&y��TaUO*&y5O*����䪃� T�)ucnu&Qȕ��_���|y{���Yw�|���C�4;R�a��
�0�B8�=���T&O*��ԓ
�2����<�6�AZ��ʛԍm+�>P 3�2�l���7�5���K�Ҹ��w����Y�Tt>��Tk;���|��1}-��{���x�*�|�4\�Ph�e?&��7f�HL�����|��iWy�F_�tٜ�3�[��H<���q����v���f�#?׌R� ڑ��h�a55��Q
/���fO��D�tG3�u��η�1�/q���^�^
Ѥ�t\��`�.��į<Nu�S��;Cq#YQSm�J�;����{_�،\��3��͸�4Tz�<�:��f�M�z3j��#�fı�"�c�ػ�E�������
=��2E�0�B^e�^�����gAȹ9,�tC [B7�g��!=+���Y����醀�[�6o�^,|C)�E�L���0.���#�6h7��R��9|0��M�X�uk�>v`�i�)6Ⱥ����6]M��;݅��A{��r`�$^�i��{tA����W����!�i���4���eԦ)����8_޹���}��>}���SmNb�#�	�=8��(����\���:�	�jh�T3w�번7\8Vs-�E����FN�,~L�n��"����+B�+R�Jn�|G������ӕL��_oF-�o��V3�8̔T^j�N�-Gޖ;�fH�^�i]6�Ҍ:�kF��d�"�^iF�T\� �[��iF���f`�μ�i�]�fԾ�1/f{����͓�\y�F���o����Q     