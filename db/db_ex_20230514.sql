PGDMP                         {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
                        false    2            k           1255    34652    calc_commision_cashier() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier()
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
       public          postgres    false    7            l           1255    34766    calc_commision_cashier_26() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_26()
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
       public          postgres    false    7            j           1255    34653    calc_commision_cashier_today() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_cashier_today()
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
       public          postgres    false    7            h           1255    34586    calc_commision_terapist() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_terapist()
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
       public          postgres    false    7            i           1255    34764    calc_commision_terapist_26() 	   PROCEDURE     Y  CREATE PROCEDURE public.calc_commision_terapist_26()
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
       public          postgres    false    7            g           1255    34591    calc_commision_terapist_today() 	   PROCEDURE     .  CREATE PROCEDURE public.calc_commision_terapist_today()
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
       public          postgres    false    7            n           1255    35042    calc_stock_daily() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_stock_daily()
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
       public          postgres    false    7            m           1255    35044    calc_stock_daily_today() 	   PROCEDURE     
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
       public          postgres    false    232    7            �           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
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
       public         heap    postgres    false    7            T           1259    35031    period_stock_daily    TABLE     �  CREATE TABLE public.period_stock_daily (
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
       public          postgres    false    271    7                        0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    274    7                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    7    301                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    7    305                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    304            .           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    303    7                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    311    7                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    7                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    276                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    276    7                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    279    7                       0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    7    321            	           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
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
       public          postgres    false    282    7            
           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    7    299                       0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    286    7                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    287                        1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    284    7                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    289    7                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    291    7                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    294    7                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
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
       public          postgres    false    306    307    307            �           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    312    313    313            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216                       2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    298    299    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            (           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            1           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            2           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    315    316    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            5           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            6           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            9           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            <           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            F           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            L           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            P           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            `           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            s           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            �           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
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
       public          postgres    false    321    320    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            S           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
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
    pgagent          postgres    false    323   D      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   �      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   �      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   1      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   �      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   �      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   >      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337         a          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   	      c          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   �	      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   =      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   �      �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339   ]!      e          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   �E      g          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   YF      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   ]�      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   z�      i          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      k          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   !�      m          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   >�      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   V      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   ;�      n          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   ��      p          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   ��      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   '       r          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   D       t          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   +      u          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   H      v          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   �      w          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228         y          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   5      z          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   R      {          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   �      }          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   �:      �          0    35031    period_stock_daily 
   TABLE DATA           �   COPY public.period_stock_daily (dated, branch_id, product_id, balance_end, qty_in, qty_out, created_at, qty_receive, qty_inv, qty_product_out, qty_product_in, qty_stock) FROM stdin;
    public          postgres    false    340   jq      ~          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   �y      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   q�      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   ��      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   ��      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   w�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   ʞ      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   �      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   #�      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   ��      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   n�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   ��      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   _�      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   %�      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   e�      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   Ȼ      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   @�      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   ]�      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   d�      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   �      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   g�      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   �      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   d�      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   0�      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   ��      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   6�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   S�      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   p�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   �      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ��      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   /�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278    �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   r�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   ��      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   ~�      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ]�
      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   ��
      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   .      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   �/      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   s8      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   �9      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   �9      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   Q;      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   n;      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   �;                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1905, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2984, true);
          public          postgres    false    220                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229                       0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                        0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 517, true);
          public          postgres    false    236            !           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            "           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 516, true);
          public          postgres    false    317            #           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 80, true);
          public          postgres    false    315            $           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            %           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            &           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            '           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247            (           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
          public          postgres    false    255            )           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258            *           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260            +           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263            ,           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266            -           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269            .           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272            /           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275            0           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300            1           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304            2           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302            3           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310            4           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277            5           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281            6           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 8361, true);
          public          postgres    false    320            7           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283            8           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            9           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            :           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 89, true);
          public          postgres    false    288            ;           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 72, true);
          public          postgres    false    290            <           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            =           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295                       2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206                       2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    208                       2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    206            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309                       2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210                       2606    18467    customers customers_pk 
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
       public            postgres    false    313                       2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216                       2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216                       2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218                       2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219                       2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219            !           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223            $           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225            '           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339            )           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227            +           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228            -           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228            �           2606    35040 (   period_stock_daily period_stock_daily_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.period_stock_daily
    ADD CONSTRAINT period_stock_daily_pk PRIMARY KEY (dated, branch_id, product_id);
 R   ALTER TABLE ONLY public.period_stock_daily DROP CONSTRAINT period_stock_daily_pk;
       public            postgres    false    340    340    340            0           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234            2           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            4           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            6           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            9           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            ;           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            =           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            ?           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            A           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            C           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            E           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            G           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            I           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            K           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            M           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            O           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            S           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            Q           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            U           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            W           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            ]           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            _           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            a           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            c           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            e           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            g           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            i           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            k           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            m           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            o           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            q           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            s           2606    18551    roles roles_pkey 
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
       public            postgres    false    311            u           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            w           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            y           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            {           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            }           2606    18561    suppliers suppliers_pk 
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
       public            postgres    false    338    338    338    338    338    338    338            Y           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            [           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            �           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285                       2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            �           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            �           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            �           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            �           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            �           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            �           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284            �           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294            "           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225            %           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226            .           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            7           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3597    208    206            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    3615    218    219            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    284    3713            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    219    212    3605            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    225    3634    235            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3699    274    226            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    227    3629    228            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    228    3713    284            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    228    3605    212            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    240    3713    284            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3661    248    254            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3597    206    248            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    248    3713    284            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3597    206    250            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    3661    250    254            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    254    261    3661            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    265    3681    264            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    265    3713    284            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3687    268    267            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    268    284    3713            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3693    270    271            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    3713    284    271            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    3605    212    271            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    235    273    3634            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    273    3699    274            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    293    3713    284            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      a   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      c   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝�o]�qş鿂�탋���7�!hŌR�RS��p��I(�?�W�Dͽ���{��yٖ��c͚ٳ�����W߿���͏���ܿ���HW�����:��u
)�K�֫��W��*������������_��������T�շ�]�p��w�o��y������oo����믯�}s{�ÿ��o?�-�ß|��~��_b���/`��a1,�Z� ���)��?����������oo������G\�ܿ�� ������~��\ <���y���ڑK	+2� 3a���U���3��do�/9�|q�23�"��D��Bȟ����$X�	+Ha��4�Ge����o�������?|�����W���G?��/�1Oʋ8�������Ww�}��~�2�I�"7r]$���)���1�`�%X3^�߽=�w���\߽��}���������>�̏�<�5G��q4A09��@��		k0a����4Q��>��W��7������q}��R�ۛ~��7)]�C�ǫ�{������n���^~��F�N�C���ê��<V<�űVbª�N��ɉ��GXq���uv}K~Đ��`�ia���8�� ��|�5����e�G��_���&����2G��~���X�K��
�Z�J���jL'F�]X[�81r�8;V
G�0NEj-�HX[[�[�[)�e'��m����NL�0��ܥ�<k��<X�d��2��J	+kayN��	+ZXgy7�+�ZIj-��0y+kyk]&R��T��Znl1�Od�n`�K3;8����8$�	���z͡���A�S]j�������^�X)#a�#X�s�l�y���FP�r����V�fbaZk0a�%XY��Q�z^{�+����e�����f�SCªL��6���զ���-1ae�{e�DX%�Źu�G��r�8�w='"�U�QlQ�l%�8�VZXA�����,��塙x�޲��ˮ̀`�iaab��3Y+YXϽ�RJC²�< '�m�|����[q��/�;�"9q af&ړ:�̄5�q[�/>At�[�+⎵F'ª!ka9N�c	�~7�]�U���c��.��W2���9�׺�g�´��o������Z���KK�Hb1�b18N�e`�/�>�+�M�Bm�W`-hlQ�����e�	 X�IlRle$A�Y6ȉQ�D�� �ؚg��M3�j7[IN�f��}�ɁeW��vb��zb֓k�Hk�o}�bk���|A²UA����V��[ �j�i��k�a��L6L6�S�jA�,3��A ��ZZX����uy�����NlLX�[M[�����$���"&/�'2���Zˉ-s94*��r�5VE����V[ˁefl$'(��k��5/�2ƻ��<XbZw`��*�֬ڐ��Ō-�����<�����v<4���RX����5��*VZ���W���H��P�E),׉Lk�{p��`�¢(�n'�
k9�Z`���	�"a����/���ۜ2<;��^���|�ӻ��=>�LXb>}ډ�jQ�+��,��`���%��ز�������+Y�����쾻�����������L��V�Ɩ�D$o��,�f[i�cañVB�27�PNlHX�ZC���c� v��N��bfb3t�=�zyu:r\��~�u}��͛��>��?b���?��L!�Yv��x�Ӗ���'üG����U�����>|�ђ<|��2^,/�Q��(�����e�`^�[��RN �IƱLBQIX$����	��ʉ�L�E�������Q�	���F�Z?yQ#ɧ�k��i�����4>� ��4T߷o�ZHz"I������í���N�ʐI`ҾnڪmHS��%�Mզ=�p�*s���v�L�A���Hp�1�ڍ�u�>� 3%A�EO�F�˖.��f(�ķ";�h[1	Ͱ�K��gt�t�e&�2s_�l�`��:}��P\���g^�B�"�\.��b1�٨�i�D����=[1uݐ0����W��=��As,�0����%ld�D��o��*Z5hV�C�j���%�y�p�%�LI�����G"
_�^�|���)�S�Sx�3��y�Ԑ�d��iX����A��|���4�Lv\1ݼ`���ٲ����H�$B��#���[3i�A�A��:��:�IwIi}9S��,�������ͪB�ܑ��$朗��Y�<�!q�����+�%6@��'��j0�I�$5��qw�3Jq���5��RLm�Q؊I�b�o��ŉ֐|�~�C��� u��&Cw�Q��Q��O�畦}ŧ_�F�� �9̾�92���V��R�yh�4��;9�B�L$0
7y�=Hd|�ۘ�eL�;̞*�/3+����Gd��}�z#��&3Ö�X��O����:�L�
�Z%I�x�ZpʆB��6"EOV�Y':�n����(��h6��"�<�[Էz�#�z#��r���|i��ROø-��;&�����i ���b̼�4O�^���{{L{��߽��{s{������<���������0�Ӵ���f���(C�b�:5��$�R�WP��t8j�~Z��`��r��s�����d#�(����ϋ�q��w�iG�`T�,'���
��s cE�x`우<����ܘ�(�Q�i]:���
޴dI�;��ڈS��!�
��Z���N�>0�M�#�1ӥ��2���
���*#'#� ���(�e�m�7ZE���:��e e� Mm"�2�(`nR���oC���Ň���"�o8U�rJ:�W1�L��ҩ��X�%w�]3���t�W�䦱_󔃱�r0��G9����6��{�i�*�ǳ� %V&��AJ����[��*f(j�1飇T=)zҾ*gc^)��UƊ v-�h`�U)�0��Jr���0�D&i�������5R͜˔���T�
�a]1=q)�&f�$!�Q�4L��Y}�["�E����=DϾ�k��k�di�H&�
�Yw$��d���F�T���+id�H'���TW�K\���K�[Ki�H~J��^PLb��<ɤ��$uU�I-q"�čtP3Pj�T�~��I'�F"��
`RjWR6u� u���3I�d����ŋY&����i0�\Fփ1W�S��s�,��md.���$�Mf���H`L��
L�	Sa7�"�21ia�`�k���z�i���D!&��ɋr�/ep(ԧ��
��K3$��T��bF��j�z�X$�K�V�u9��G9nx�eF ���I�^)�|_v�97I�8�W���ʏ@�_�;(�2I�T�e
�}�Ub���<�tč�5	�^�H�YuQ�^�O���v�td#j�A�B�\r��(������$���)F�nb)*��W$0�44M��d��� ��A)_�
Q-��]!M&EO�:�B�T�W��D�T��Rucs�Ig�a�X>��K����JZ(J$0��˅�G�&\���Ͷ�U�$�y&����[���iH���0�
)��[��*�3I`�y�Tf�,�@`�MƼ^�3I1ӏ܄���I��՘�j܈R�Z������#�F��T�ͧ� `P�4r��@jھnژ��}�N� 
��Z�.$��(�!U�I���R}(7%"��N9���՟�,3H�a�[27���
R75�c
E�8$ГZ�.Ye���^��j�|9{��r`�N��g�[�n��-#���H��Mv�I�^hѻI��&gWdɌ$�ɒ��啤0x��/���r�K�&�&Q�]'�G0�2EƝI�=�=�$rb@FO@UO���`�*WB���%��<"$���Ԕ'T����,#)��e$��O�D*���4]1�<糳��H�4��w!U�ؐr=�l�I'�·J�p�&��F�'��0���K��K|�e�X$��H�0�[Fמ�'�dK9Em��*�I�����2�@6����x;$�q��M����k�XN]B>��
	LEO�$0���E�W��X��Y�����ZYRļ�G	2�iVe�Z�����E����Ulcf%�rn��:I`Z    EV��ܛ*NކD(z��G]G^x�f�q�'z�F	�ԡ#]WI�8I�Fj���'M�"in�,5��wj Q�Z]�$`^�d�ZTL��Τ�<$T�AY��s_ټq��H�Æ��I{%50$%w�j��Z���5�t���p��&�}�ЁI���?U#���m���=I�@��06����G/+ ���� �G��i�dH�]��F���WT;I���n5��4R�%`V����,��w�D�?}�(�{��R`�'���'^�g{��^>�{.'��=���(-,�Zv@�εb�.�`�ؗ��=]����\?5P�WE�p�G�N.����<I�� �q��W,�n")��(Sn̐�(
�[2I�&.g�Y�^�ø�S�:�<�96�$��9�����tf(7��Q(B������:guwa)XyC�lt2�S�gT�/�\q~rX�%��O;��TE+�(��:J��BʰFSH�ӵgK놘�t'EO)�<I��A��d��
`Ҹ���TH`*��K@Y�{^��ߍ�Ņ��i
�@�&y��=�0&i|�P�U#H6���Q�gm��HLXH�����k/xQM��H̍�ɵ��Z������ � -�X������l�<�%�&���3iޕI���M"M3*�H�)�Z�Hn�Ԯ$0eߘ�طd�o2p�����A��N��F}��DM�R{9����&vX(0Y �s�]8��)G���U)����$E���<9`��@��P����Ֆ�A�8���M]J�����a����qC�̶����$����6��ʤ!��:��)��G��n��I
��.��2�$�)�*�,�$�2*fHJ5+:@�2Q15pS[���
V"�r�6��8�ՖD���qˡ���\u�c�o���p�����wo����޾~{{����p<�̏��<D��/	uf��ӹ9E��t��I'%�$3)f:�2�$�ʾjc����:IwuŔi��S�+�|"��x��'�#+�ԏ�7T�(�e����P.$0�t*R@�'}0F�TR�ȨP޷�oˍ$��}�ѾZ�0��Z�I(K2�U���_�a����L�H�^6����[I�v�e&)�+�l��UQs�"�2H���N}��ƍ갯v�z�� �'����I�_CM"h���B%*�@GkN�.X�HS��"�	zb���u�D��KI�SH�i^�tq��'i*Й#�Μ��u��v��ŁS�f�L"���r0�dH�),�dSG`(�W�n �]k��u�fo-,��P�VA�բ��(�A��`<�L-���HE��#����5�`��q<0q_��Z�0U��:������m'"'EBց�@.*�x��֦N��ɤ���AAV(	7fH���߾��	��)�#J+��e.c����JrR^U�e:�2��Q#QR��I<��]	g��:�xV�ત~3�;`�8Fj�S���ݸ�?Q��O���֕$��q(8xݢ��2��ͺ#q���\��H����}�:�'�M��;VB�0��?��h��ҹ�PwI+gRjWR%�\E�$���3�,�Z�5�9n��߷�:�#M(3i�A���Q��)��J����C#��!�娽�nMG5�%u&ɰ�<K/$5�M�D
�J�ڶ�͵�+�����nv�;0kV�?k�������>�3߾~���}4������s0�E�K>�i鋁�$Ј �X	��p���ߐ�	
7y�I1c�������B��4�yyд �L!Q�=p��)��I��1�j�}�i#�uRGGE:m�76[$�qDɉ��e)�۾��F?�#4���OUR�R�I+�jy&5��i� �v��)h
)�ʾzbcO�2����9�B��}�S�0��Y�.��rS̏��_s��p"x�UR�$THE$Y&)���N:ﬤ)�XNmVT^�N>���5�HJ��8ut�)	L!�Ɋ�ݍn��$9�a��8�N&*�zR�4���EC�t(�V&��i�pPu����1V%eX$�������G:�h���3� L(&$�HIrUR^u��b'Y��M;� :,�v�ub�D��gSm�� �DO��_�-cu�`�%VO���槔�����]Ց�^����=�L�/D���!-.�֭Ճ�D�5����Fm(�M�e�%bۜ�W�T+�]�-�]�:��D����ОP��]n�/�D]�};��}L����	ɂ=��	���iEG:�(zQ�Z,�.�.r�8�AS_Nw�*�8� S�Ɣ10Y�a������*�ɔL}$�o��Q�fҬe�9�����:|H��Zf�<�9�(-�<yQh�L�f��9e/���|p����s5�)��b� %�fA�bBj�D�=)�ȥ�1j�R���	,�p���ixI}F֊iWuLb�����Aͬ��	+��C���٨M�9Q��e����A��'9j�V잸ʌT����4�J$͚�+B����fU�8��T��Ҷ�Z��H&M|:�S_.��<�ذ�r��8P�:�8�T�@
�F:�m�&o�Z��Ij"�6kz �t�ݪ�ۋX'�uP�tO�l��	�ƾk�iH�p�%ON��Y��$žb��xf}.��{kq�[�y6If��++F�.��
EF]�n Ӵ��R���=�t{���D�Z�$���l��v������x�1�r�3��[���E {`��e8I>A62g瀼��H$0F��ts\��l���P6Z�^��Za#7�;�Xt��l	�D:��[6��죭`�s�
2Q��Hi]|�e"�am�2��&I� �f���'�t���EOp�Q��S7�HS�@�⬰�;�P��[H1����KR'R��G�g���h�,��,JAZ���攢9HX�H����b\m���ܘ!�uߘY�z�5��W�S�#��R�ڊ�ڈ4Ʃ$�I�ɨ� :z�3+��������)�WW��?��Iѳb���Qf��t��;��F�>�Ձ[����4-���>AY>2iܕ*2�#J.�1����2q+'��Nt����~Z�,�-��A�Ǿ=϶C�>H���{��n�;y"œ��I�f��2��6C���uj�l��5�B�"W#�$M_�Bd�1���q������t�H�\H�a+j�j�Zm��*��
QyEZ�Zq��%�d�B�L!m���V����@�q'��j���c�)˶��|���W�h_~A�y��!Д}m�)��ck~Q0��SY����e�Qv_~h��JZX^P�Eם��ik��tb�d�g��3#�a�M�V�}m��䯨����Y%��ՒeҾq�{�d_���a����1,9l��^yA*�3���N
��U}f"�I���� ����r��HC����$M8�d�*�1�����'%�!����3�fm�j���>����$��h*��]���lWOO"O$�	�{�Ls)6�QkU���;�$����[ @E�d�$�8g��Ȫ3?
�T	
���+�$��Ƙ(0�51I�x���rR�U@��1�U��.:b�8�d�$���ɪH�3�Z$�����}FP�7�{N�x������q��O��.�5������;$��MNALx"	1�$JL��) �qr�����8Y�U�"Q��$�$0y�}�3�e�VNн����q��f��y�4&)��"Њ�]���v��H֟\-SS i=�d����8��;�	CճG-�'}��]Kv<��i���e瞤��HX[]�������&V�����R�9�!���,��*Lkfȋ�W�V
���b0e`���BZ+�����VZ�%h�z��0N��'�`5&���5�!��b��1A@X>�*�-V�G�	�1�4�� �������!�-G4�/X��O����?����t������.�����7���|`� ��gs���x��$�0��od$,� �qb�b�t`٫���h��//�O'��a<�2�!-c��mBEZ�^D���M+`y�/v��uPX[���_���ٻ93�̢�*��_�`�ĬQ��LLv5�bFѾ]9֊	�~_��Ĭ���n��`��) H  �"�Z)@	��C�:֢�v|
��P��d�F�b�r��Nd�A:�-��I��hk��$XA�qbg�*��r`Uhl�C�D{vDr��:уՐN�{9 X�i-;(��Lѡ��Hk�#�᭮�����|:&���������}K�d���e/=�`Eql9�lW�eG�L,P���g���Վ`�X���ܑnne�9w1<�gD�G��R�e��T��D���D�y R�3kbkZ'��űR��>��X�n��`����9Ql-��jrb��(����U�]l�l�M�:�2�̓��v���qly�
Ȑ�К���zY|�f��j��ز����D�5"��Z��
�E9O,c.�:c��:�"�h�)(���Z��Bލ��+�VE:13Y�~�Kk-ω*l�,��j�L��R���N]XZ���Z�)l�VA8֪��'����F��g-��;�Z��GX�~ۤ^�n7��ܟ�wSI.��t�y�� ���Ws�ᥑT��G����R5��(�%��\��c���I�DVFƖy�d�Ȅ������C��!�����9X����G�U�6�]:]��3^�߽=~3����7�wono_������ǟ��g�`2B�Jb������6g&���O� �mu0}Ou��Xˊw�����T�j+	��HXS���y��VA���[�LN\y3�sb`Z� C>4d�Oq������5l��	�&*��!�3�t�-F�f��.��VZ!�Bg�8��4�O�|�:5�~�w���ZUk-�yKe������DªL�hbX����b��Ր�j�L,b�ZU|0֪	+'���T{��HkU1,/䑱��ۥ���n�П�*󎟖y�cݼ�`�����`كi��O�b��[b-��q���0,���S�MdԴ��H�7�G�G�LXQ̊^ e}��#�)bG��nw�9���WC���B��(3���81-����I0a:��L;��!L{v����ˮ~�`��jH�&�Z��z:�FdZ�|��^��2���V��'�ZL��	k0a�7�Q����LX�|C ˹]6�Z|�ۃeT,�!��%a��?}��W�nJ2
      e   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      g      x����v�H��{��z���݁b�1��`��Z�&��j����feU�����p3h�02�3���/���07�C׾�ޜ�ov������~�m�U]���띯�wu�޹��?U�Ou�v��Ct�����o���H,������v7b��ݟ����?T�Cp�����|y�u�>µ�
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
��'�v��N(�B�H��`���N��0��]{K��l�P �  P�h�@��ѼL�.5��6��`Jv���CB�@h{�|�������?���4]�jT�~ۻO&瀬&'�R5���nw������O�a$S��W�cC�C�oow� ���#8iG���qK7�mQ1,4�$γ�Lq6��^�V�0�&wP>�.ɬ��bB�PZ~�א����0���a><,YId6��g=kJ�b�����?�f@i�d]y�"4%�������O�a$57�����Ɨ)�����?��
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
2j%4��喭�K��2�+Y�#5�� k8��Y���,���f�k*s�qԔ��������ȭ�a 5��[��E�a t�N��ƥKU�$�a$ܱ�lM_����;U�H߹����hj����R�@"w�0uaIVS>tq�&4�������-A#PK㠓���c��幼�Y����kg��6�{��DR?�)���:��
�����.�.Yuz��~�l�\����'"�X?ޑ.�t�"Y�@����|h�mkjO2F�@�\�s<�@�],���0�j̐�a���h�����=T�0�t���YX�C���"�|�:��`5D���
�w�|���c4dԑH��e����q �6��A��m� Q�#������>�x�`��[�#���!@����CS�Pt���+V"����8i��m�(��E��hȠ���qe%��8Y`�A[5�Y4X������6�ǡ����pѰ�!k��Pd7��q$���MÖx�q(: �r8�_������8�Eٞߗu(nH�F�h����w�D��N�8�>����3V���Ɓ���zE_4j,J�Gⴧ$�DS��Ɓ��u}���$����q$�1jLW��Y�8F<Ǩ1�z#�5�C�׷w�''	,M��9�?3Ǽ�M��X�s��*�5�C�d&G��_�o�m���8Y]�g�f�V�p����eq2O`(*�Ɓ�{�M4�Xܝ���խPE����h�������w�8�\���:���ps��6G3i��N��7tM��Ѫ��zK^�T:k o5�D��
�Ө�/�یF��خVْ��Y�q Z�����-����\O�R��S��z$�?�A��Ȯ3�n\\@�o4DG�^_�Hl/n�Ɓ�:��^�QC-h ���;��8�	��A��ݝ������J�U_?��_S�73n�p�s�kj��z��j�!�V�@�䫌8#ŨAοm�#�-��>� %zsS�@\ژ�`>��_\��c�i˶�e,��F�X����������Щ�q(j{~���nb�I�}�����2{�}�_�"���՛Ǭq,��+G,=�aC���iʒ�=��y�m.�Q�I�Z����k��g�c���c���L��-�j�ơhO��t�.QC�b4�$y��!q�r�5�ħ���Q��l�h�,�۟;h2��:v��b�= �pF22i��	��Ԩ�H��#��ql���/G��ib�P��K�M�6�7�B�)^�Д�>ȨW���铷2f�b�I_�ϲ�2�$$T�҄�nnj�Kn7;Y���q,ɉ�x��nv,��F�P���H�J����2��ΰ��'ȷ#������1�����;ȥ�/�@�Ƒ�������t=k��F�H���*��]��t�o��(njjJ����:�54���Zt��^��#!O�K�����~|W/�Y�`|�$�K3����H��c�:3�\��V#@~~����騾�      �      x������ � �      �      x������ � �      i   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      k      x������ � �      m      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
j��������<�?��KX'=��W���Ĉ�A��w�?j��c����N+�gk�t�7�"��?����]LL��)&���-U�K0��SU�D��a�.�h�����6˖�Ȳ�X�)����$!4�R���T%�U����}��w+s��{������񨍔�vw�������7nm� N̪N".^/"Q�t^���� ��ژG$17WӅ��/~yX��vy\?���M¨l} �TK�U̚�ĹX�G���}ĸ�`��D��qaC��$q�èj�;�Cי�f�}.��Q"ƛ�3��h���_A�x�B�l�˗�H�_܌��q� 79�������Tx�y���c,�������dƎ�'�琌im-�.ǫ���ؓ�m����?:ڴ'�ggԷ��v��4�[v����N��c2�*�m:1c�n���{��B����&:���/c����]�"c�A�+S㽽0k̐R!�حw#���{��n>v��t�}>�QW3�|(�[��j��;��"9�Tb�:F%3�b�t�}-^���,MЅ�f����W�L�~ʅHli����N�UŽC�ƤT�aLFƓ�F�si���q�ax�{��p�����C���>�Y?�87�+���+��$�����	�u=��N�F�`�	�I'��n�����r�h����1��kǖ���k�HJ�ùX�[�2]ؘ,�u�ؕ�TQ�,̍���G��0Y͍�)�[���p��$�+_t���ُK���?~a���#B{D�X�j�I�T���8�*}J�t    �>�{��A��9g�h���U�&>�a|k���Yk~"%b~k0*���4Y����J������ay������5Uhྀ/����.����I�r�[x��F�O�4���䫃��J|ʔ���U.�i6�A�X�+��9���b�o�\�շ���~�ƎPMc�3��̍"a.`\����s�����V�j<p�@������%`m��{���O�3
�F.p��H`r��9�ϸ���qbY�3�;\����\H+e�|!�Vc$ә�2`�����@m��z;#.^��ng�K��M��OC����f���sO��%�wr�2[w{�.��r#���ME81�����4f�۝�.�%~��i��6�!	.>늋S��=֡`MXaFVzt�O�&۱l�F�^�hkd�+|�la�x� �o�i�CD�a����^M7��%s��iϹe��}�)J�����+1�*f�ވ\��F�V�ĩ�@:P����l'+3}?�1�H�c����6E&rqM.ȅ���+7�a�f���$�y:.��t��e+��a�3�\^b~j�Bqax��w���ʞ����;\���&�Z���M�_�>��b}U������:\��
p�U��֪O,�z�R���oEۉ+�T�Rj��y��d��򤩺ą�oԉ�r�Ϊ�WV�D��n�8G��T��bBY?�p��F�c��8WU`4�8�7��~@l��պ�̪b0+:���2H��6M�nI�+��bCU�p�i%��m��X*��e�n��*�6��o���V��Q$���mP� �S��
=�
�Q����SB���1�$�����g�
��'�K����ء���w���f]XO������xn��ƌ���L.0��7s��H~쨹)etuJ�=��`��_M֪b�rؼ�<������⽊��_O�;�#l��٫79�~vA�˝��b�&SI�����
�X���L����'b/�g\�0���h�?�#�q�C�����Na��TFi��B$|����A�̙.��r��3#�����]��L�Z�X����̻�W����]�pٰ0�&��9j��:6d�L$�c�������d��0Df�r52Ӽ*����n�2c^��%��)"�)moO:LCq��ys��lٕ+��W�r������#/���f�H�av�ш�a;�/]�#	Di5��֟���^G�����/�|7����,a�x�4�ά���o|j6�//c�z_Υ�ݧ���} 97��[_}��7�*f��L�~�*j�W�i	� ����*�[���x��8�⦸)l/��߫��6�bD-z#�eNT�Q^�Y���ۙ&_sY`��47��5�bx1r+y1
z!�V:3����꧃����im�Gf�0�)C_���|�Sv�!�C��Ő ��.zOc�*���ߴHWOc�癴l��b��B��L�ߝ����،ֆ��qN@lS��S��2��#��S-R�T�T�S�T?�������ab�;��M�I����49���=LGr�ǚ�[޲Ln8Tl��'�<,�����'P�
91����P[0�T�.�ɸ`��U�/��^��~�LY����ӑ�d�����4���U���zR}��âr�'b����O[��*�1��]���ª�Ex�Ohh�p:�!=DgT'���i�0~0�|�r�?�WŃ�����4�83�%R\NN��f���;��w'ە5h��'6��t3T��ߞf��bVa��? ���)?��u����mDTl��� ���*�8j
�NI�ʢO�v�$��[k襦gaS1Mw�|p/xm�W_�����\�� �
 1@��a� I�����>LsttXP}v���T��k���J�k���LpU�i��l*6v'^瀘�#^Ͻe��{�W1�ui� Z�;��ܬ����Ǆ��2#6Ӯ������}�q(f���}�6�=�s19b:\�8b����̗Ab���b�g"L_�9�s��*k��Ϥ��|��U��}�s(0�WnPwS��P͇���QxR1��xq���֋�v�η���_~��G�Vzl�	w��}|t�8'�:̾�Z�X�?���Ni�p�'�r?~�*�</���рt2�6cܹqY�|V�ROD$;DnVb�o���� �^�P5�9N
&�t�_��8�^�5�V��M�뽀�F���V�� [#g�>1}7��t��f�ԔL�P��g��^?��T�~u���gf z�>f�/��s�;;�s<Z�NŬ���*���CL��.������W�#O����:�\�y�y��,Ș=�ry�܉C�h^`񈞚؅�X�ؤ"M���К����15�3An�HùFZU�(ŘI�����^b|��������e�U���qO=��Sg~�]p����L�>�*6����1b��dl����5#�q���Ɉ=vI������uGU�X`l��������(
��4ej�L����ZP?�h�����S��A\,L�"]c��t�d7j�U���G��4�5v�w��'/0��i�!`.�3��f�lH��Qc_�� X��M�>1�[=�Q@:z�,"��X��wR	�@y}���2�Sѵ�ƨ�6tx���+6��O�4���E>�&>����L%��sz��S�����}�㷷_>�����kB�+�Cct�U���s	vl�!����*0Rh��K��ȭ�%�R��s*�9�KW5��v][Uܓ*c)�������-Um����b�ַء�����p�_c:��]&���s�bj�\׃�/�a7�G���Ϯh�[cV��>�*�e�,�W����������Ĭi�fF.ִW�Ğ�ʹ�X��A��'1�T�z��#i�E�D[=��F0̐xXe��!�%F�1B�'~�#2K,�D�7kq*Fm#J冶Q�W?��a5\�}L$�/�X��U���z��3�5����ŚN˘��i"�nan��O�j�`�:r�&�3&��ul]O��ĥV�u�b�Y�B�2�Gc��ć�?�&Hd�j�ऌ9�dꓬn2�K���U��$;[���ÞG8G���ɳxpx�Ъ�t��y�bf/��fb�5MN���f<�R��p�#4CL�ebo-I�a��U�ۧ�@.����iln�;��v��\Oى#����Cq+4z�3f7�9��������Ɍo቏���W|�u۲�m�bUˣ�*fO2e\N�S�=�A���H�u]o،q���a7�O�0�X[�sblR.ۮC�hg2v;�q��آ���~���rl�dp�\�<�b�\�Ŝ��G>��ciz||k"ݞ�ԙc"�r'�YIȑ��JsKFA�9el��f�':�
VFf��'�ϭ�dn3_c�\i��E��jm��ws���sm�TƬm�R不׉��kԠb7�,1VI+DR�Ԣ�M-+�,�_R�áM<<1V
�<z,O����[�s�O��Kk�dll���
Jt���t�%:�԰5٥ʵ�[��c$N����/H<���d\�t�L�b-�t��5�Jo K�>���$F������,�����\�9~��=Ǐq!]��oٷ�n�F����JCl�
Ü07��f�|�X�T�<d��̨���������!.O�Eh%��%�ѱQr.�(c2Ś�KW��R�N�>rb�6.+y��# ���9�ɨ��;��"�
�(�V��"��XC�y�CņB��1v'atnv'�py��s��p>�!�wfm�E����N�*����yg�pY��^��#���$�r>����=/�pq�]+}3{t{4Uk'�Is������v���s�CG);���TvZ�8��`������A~nj��b�4/��]P�l����x��*Z��m�[���J Q�}hCD�7j��e2�a��GC�.91M;�Ͽ�_׎���FG_�E�}Zv�<'>���-s��ĤPTKb�U�Ē�fa�5!�<�� +0�&��Џ@qM����v/�fa�oHg�쉹��Ș�]w6�N.$5]8m��	?�[8x�d|����"�:����4F�H�(�T����S�s:t�/ML���    dT`w�LG���]��;N�
��G�yL��rQ�Ξ�M4�v%}l2��V�������o��7NɃq����Hm�f�&���Ś��3R8��2j���8��m���5Y���P`#�H���i��y���6�2��nq_�!6���,]{!���AqD7R�Tl��v`;|�b��L��36�v�t�c�fD䧛�y�Tl�e��êM��*��1C/̨M�KD��h�?~զb�dJ�qH􈥘\j��6�7����q�\���c�PFq�Aj����K��
���왨N�l����MCT$��29�)"s��#N0J6h����GA�b�v�µ�-��������c��(C���[����E�x�a�(چ�-��p�چ���\�)�:4�Ku����ݱ!���}����PY&{`"<�*6��|����ȇ����iM�<�Wʘ�yE��k&� :�RYrXmd��N�ġ�*Q���-@aЂ"Ȉɪb�,�����G>�,��8\��bb�Ń\ܜB�z!�x�����N���35��?�x������o�j;��l4_�pL]�*6ꋙI��%ԬV����l�@a�íZgO�H�v���¨����H�?%#wy��y*��m6o�r$�����OaY�Z`T7�Ф`��<�U�Ƥz,�0��e��*EL3f}�m���DN�GSRv^��K��	�
S�,"�*L��4z�7O��;�����B��<�[��(�4�ذ�w|��v�$�[��S��j�n�E��.._�.�͙�8WXU�A��9���_������HZ��~���&87����-L-�-��&�bV�X5��a%i��*�-0[ׄǖ��������
#�<H[4w���
r�b�tnNTLBh����p�񭜢gޫ�2a�ɑ�`}�d7�Z��f��|=]��E������	9&�v�ϮH��'��,����$.��*b"�~'��:����F�y6B��av׾�N̰�
��6\�m�)�p{�b/����#{��-�h-��ְ���:.QE���Y������z7���{�`�.f�]���	�6�.�E&|�Q���eW1�wN>e����F�g�p.�VרbUv�U��I֓6�����Vq����!6�X�Bk��vn��
���76�$d�n�<�bv�1%����S*ڬb�0L�
�>9D���QQ3�Ǩ����LΑ^3"�2���N_3/�g�M<�����W�ֽR{���̊'Eģ���PI��"ۗѰ�	sP��֝iӦA���$�؂b�y�q�.@]q�������Hy�O;�h�'s>J�U��/���u$?&��-s ��hcq�l�ʃT�k�Q+^^��xe����P�����
���=�m��ʓ��D"S3N�t����3C�s_�-�E�37�$��XTdd������GW�U�+���E_�]�+zO���D�Ȍ�k2:��O�s����ҝ���.��f�����r!R��pI_q��qb6v���$������K�rC����r��F�C7�&�k���F��o�K'6�I������Ip�K�bfOB���ײJm\,�1s�G�q(�6P��p{����1������1.�9R�������c�U�Pb$���QK+�|a��t�f�o�ؘ��z\�}3�?ؖG�7��S�;�o��:�� ��s��|b<3��_�jORfD����~���r?��͠�U3�}�-����u��a�vwgl��С�/�������=,:��.�6\4�B{�d������#`&�[cC4�kf��$fv����W3�Ob~�����f\�aj�e�^yk�N����1���ebNm�p��g�[ٔv��2��Fo��+���;�uB�T7���Hd�����I�r�����)
7��]^�3^����>���s	I�����r��'�y�������D�U�J�ஹ�k��
���vT��������LF\���B��ɘH�Ԫ�D��P��m�d��sӆ}�������,=��55������pe�K�U��\�c��0���	,���ܭ{���)6,�xLƎ�Eg���*�����f�<6.c�������2���c\��*�,0koǉ���RC��1�f�Z�<N�ʂ/0ڣ�վ�Ʌ���{���. �p��Y�F�=7{l���˚�;����Yb<�<�vW1s�T�و8�F�����2�VV��u� ���K��X!��n-I'��F�g'��h���4��3Gz&{Ո��jQ������P��fB7��&����JÄvWd'�e��`��J#Ɩ&���Ła�u#�(�k�U}C��a>.����Җ٥���s��>��w�Æ[5��41�U��0���%mP�n�ɽ�o�X��o�����A�n�\`�R�D}���ke���{g#��y�/�}!O<��]L�t��Ye5a�I�m={��#�_?������HÈ�'j5�g݉Y?QBw��(f��K^`F9i�q��w����[1F�U�(A����7��@��Z`��I�	��$YE}���>ˮbCB��`�q��]i=y�Y��,)Z�yl����!y��`���ty\�p�0a@�Xm��.Ԋ����{>�-���c��̬������=7G��9���_�{ ��"�T�6�s�����#��߿���]7>�8�����y���簨����a��HF7� �b�]�!��)z��*�h���E+;tbω����æ���?����Z.\O�Vs�S����uq��L\�>�C\����(0�e���aR���\Tl\�&�L�oN���L��\�*�S`�)x����������������N;���u�D����2��Y+����
���� �0ӗj���Tx��f��T�U��pp��O��~�*f�6`�D�_�֡qG�9�]r��;�n��86Y�3pKW�bV��*m�N�GeS1��	]*�����ٜID�����_鯖��a�XXZdu8�n���򀇸�<`��x�m���~L;*��ٶ��x�sw|�:e�U�n�i��v�[�������᫤|V�(0�
��VC[�!i{�nO��ke�26��N�e2g.d���j�S`,sa���G����I��Eź����-��`��Iz�e�����<�--nN֜[|]�.���T2�����ఢ�2����2��!^7��ʢ��-��;��X��rճ�1�OtX�ZV��쉔��b#�>>@i�Hc谹���#��vh�[����#{���4�
���#+�H��8JCt��b��u���@L���':�,�K&Y��{3���>i�<ӾF����WuUN��f���1�W�􍱓_�ڝ6�u2Ƥg�O�$�ƾ�Ħ*�ϭ���r,�aE�����RM�n���fH�D9X���B���L��c�-8CJ~Bk�MN�:}�W��^"�,��*���>�I�i��q��j?��G�G���^�*��b�t�83pr`Z���|@嘭N�f*��7c時ݘdp�Fk<i'�bFo/�B4��b	�˖�^!�iJ3.����?���]����U�K�e{y6�車�~8�>sL��Z��Č908�����;5c��W7��,���{h�Ty�= G�h;*����>�6��~��^3C��*L!���ġ9����#�Rm+�U��c��f|���{|h�{�~�@
�]�Vy��i^}�v1���$�����8�f}�������^qQ�kl�����-!�u���؝��:�19b�j��Ɗ81�[���<��H��H.�U�ƺ��s%ʊ[�k\#o*fn�Ú�8|���+Pr�&n���w�Jޮ��w9nk��z�+�'����n���CKTmʦ��)k������]��j.��]%�_`�jk�?Ə�A�
��� �R�nQ�K������_����3,�JT��'�u,ģ!��x�,��u���9@ڋs]@X`�� S	����������ȅY�^\7��l�O�#9���-cVwxp!���tI��p�0{"4)U�A���Ue_���K    -`|���N\����44N�cu�\��<qP)s3+s3��A�	f��ҵ12�1$37�'rfj��{׍�Y��گ)c��$%o!�.�a���bf�y=�!�8����Η󑌫%�2]�
�	d]���L"O�Z��[�J�0�/�؍�������g�1'o�h��U�:F�/4�;�/T�[��\`��(���d.+� I�\��81v����J����s�)�T�D͢IO�7><����'[�,"��yxR.c"rFb@�w��^Či'^�Q���){a#�dGy\`)��9�ϟ�Y�̟�	��0��ҿ��%���a��S���p^;+��z
�㖏Vfht�2F
`i�(�Y2[c��N{>�ۛ;cݣЕG��%���8�Q���n>0�$��=;6�Uѓ��k �4fό����A~�1n7�����������4���5xY`����c$Ɩ�H�}�h�w�̡�pԯyO�QtY��|ƥ��!�sί�����9�dI!�}���Ų?�-ʲ�3�O^�	��Y�&Y���k*6`���'"綊�I.�Rˡ�� ��/i;8����2~��gS�%_2Bh9������ڂPbf}���Z*f�炁>�>W���m9��Z�jN!�2+��Ɯ�D�v�H+�C��W�� ��Z����\������f��4<��eQ1s.)��_�>��=O�.�,�J{�%��	63�u����"w�p2u�p]l�
q�M;1�a.:vc'�T1qF,��=���fGs�Hfk��fɄ.�=z�W�
�I9xW���������'\�2+F������+��6��Ș�1�[��n�3�O=�iW1k�y���K�|� ��#�����QԤ��)0����+b;����S��1O����'�F�T��Nc�A�:� l|���ƾ��`E�^����{��Js��=)̹�=������@Y�r[�mr�ݩ�H���;yhyo"�١uk���L�.nU��ɋ>�h����(?��V����.��K��%w����ӌ��SE��W)ƌI�Ϸ��Y���;����s*v���o�[�j����g�j��=�
ݪ%r��ρk��%��T�Z�0��y]��WW��1?3���dj`����%a�n��.�UŸ����q8k�4�@��a�5y3
�[�{�: �¾�̔!&]��%`�ڮGD����f�����F�j�P`#�\rO�͠nf_��뚳�{�d��>�P��u�`r�A'�55�oMԌ��,��'s�4�㞜�}�1V���'`�5����Z���2~"Y��r��h(0��(�b�0�ar���U�����8��x�6ю��
�i�)̊TY��u�N6�'
ƇUlU��=�?\�%m���Ju.0.�@�7��HN�>$���`��'>�-z�\��3fz�_����TO��)&"�M�����O?���ȹ�(0
��0� plt�x�L|
t�n��}�4%G"����c����������e�ė}�j#f�5�BH�Ҟ8�4����6�D�_�v:�M����V����_J�7Q����O�D���E#ͅة��)0�[BQ>��$c���sb����ws���B䅕o:�U��
d��\���~mM�q�-~��3��<bV�wtb��ݡ�U�|���oV1�s�<�;t���<[C���&
ya�����%���=��q����{���N��yC}ӷm����C��.�0{�$<������y���Y$S�UG����2S��e��DMDϵ�R��fQ.��d�]Q
r�8sS�<�QI�1!%:����"z{���M�ޅu2p��O���3*Q�!"^��
 m�Ll^�#9��Yvv�5.YU���
 oo����O�Č���i#�5=���/
�E��Ƴ�m�9`�T��6�M�C�cL`��7�t���v\��뼊ٕC� w��ny��L��0���~	�F.�$3���f�*��k�t#�2/��.������u�t�M�G����5!��#�L4��f)0&�8�7�km<*i�h���g�#b�aW_Bc<�K��E���۳u��bo����k�U.e���:���T୿�������U�H�q*eD����U|%.*�/^��i�3v�/0<���?�������*�Be�_��(�1Y�)Hy��g?��1	׎����V>�TB�b#Y$�xK�|o|���A�\�QM}��[�n*f�#����J��$ՃU�X���ۑ)��R�&/��$t�6���n/����Ku�*�%/��4��~�ۣ&c,gKKyotݥ-���W��m�����ض�Ʋ����_���B7���*0�V����T�3��P
��`b��{A,���1��*��b�;7I�	9Q�i�T̘��.R�����{+��Ps��s8Y��i��:�{��̮�KwH�d ��ʧ�k��i���z�M�G^T�~�GN<�� 5�,6�ˊu^�)RdxU1SX�*%���`n|<O��sTUh2�U��ef�9K۫���/�օ�� �b]{����ƒe��򱾟�%;�ޚ�����,�'�&]���q6�qW�����t=R*8?S����b�|c��^�ܾ�n�d	P���ʹ��;y�:?�����yË�!�1�����#*��a���)�U���:ŀ�f B����;�X ;�)�|k
���� 7D�O�*��[�
P`��/\��1K�m��
�`�L�����&'Tu�f �j����Ρ�M����i4�{<\{Q�؀/�<!���|Z��OW���'�=�|�+~⿼?�bAc��$��zZAuW
FCK��\Ӏv֊=��մ��&�H �D�V�o�%��$c����a��0ṿb�6�ےk6�X/�~F�������>\N�^	��hEQ�U��3������7������%c�(�ß��4>�&�c,c���q9��e�s�HT`��2�g6�KK9�|hc�'fo
��%7\Z.{�-q*����QX֦(��ޫ,��+J�%��!����iy��vOe拊Y"	��~h�m��-`�U�o7F���u��k��¬9/;��6����*f�a��i^l>,��n1%F��]�+~�c���&I�` �=�.B�uel  ��K����(���
?����D扪�pK��_S��.�܉�ݘa��ؽ{�kò2�p���E�Xy m0Fo7L�nJ�u��sG�'�sа��/""-���\:Wǅ#������cD����VZW;~�
8V���ta�-��]���f�O*6X��*����C����wS�����G���S�����}�=į=�R[.�(mM��F��xB.l$�]�T��f.B������[���}��v'=�)�*	�Y��tH������8�Q��H�8���YU��=�ۺ2r��i���v��i1�>o]�*fum�;sG5DcL�5DO.����}���E�Ąn�v�0Z�n4=w�e������Z�P�M	cvcJ�Ƿ\�a���0{���b@F�[6v�ع�*�!n�Y�'7���;c�Y�hF��{9c������|�
q�|�.C\F5����r��j�V`V����"�XM�<�6d�g*��A��K��ыU�}@��#��*��Jm�Č�*R�w@E�!"0��j����ӫ����f.1s�!����Q��Q6��3bh�!ӹ�l��Z}D�(ׇJ���(]5%�K����@�A�k���N�)㟁cՀDcx��Q1k���=��̓Ǻ(c�*��Pi�+��(9q��1���*feᦉj�1�@
4#g�蘩���bNl��#\;T�7F�c:ä�� 	�A2[��Yb���}}�����'��H��ڃ���0�G�<�fE�H5��5QîbCU�hV�D�%��=�^:��΋���1�'�b,����_!��K�8��ߐ�r����Y���IZn{�����ˏ�V�����/�_��[F����S���s�*L���08]4.	�c�4�1�?���q�%~��S1��z".F�n��m9��=�QY�j>%�\ٶO����    ����������_�����q���on�3�����1�e3�3
M�Y
�x].U^r��N��J�IL|�K�qmΜ�$��8.(3I�Q�c9�l���߾:aR>�@s�͝@��3�#�����<��`� �c� ��j�Wb=\Q�,��$�ʦb]�����+��A-/�-v3lȜ�M�#@�,��:�Ico����%t�t|{L���v�Y�]4���ĬE
.FG-cr��#9J�I4�B�TN��u;��PlQ�������آ~�,�'a�r�oȌ�$�&a�2�)1�"�-ۡl������t|��Fo��ZM�~��:5���*�LJJt�7���'`�xaY ��J��ć�1eZ^�.�54 I�yp��d63"B"���ci-c�s︈;�ot��o�1�q�D#�*�홫`����?^��ٓ��M-�%��b՚��<~�X^߃vyW����Z�.��y�M�����Ⓠ��oƺ�Q%K`j���ૂ�3jmn��_H$M�4����T�Z�Ɇi��I����@V�����'1N=��~��-2m���Ż�qP��d�1PC���ӎ?�њWωu��_jz����%'߆k<�&Ae��d�"2��KVqϥ��T�@:tSǞ��#�qX6�)'f年�`�iy�?�]�M�0��5s��o�%�F���������9ܚo����7Bl��{�>1�V�r2a&d�Y����p5H�=��M<#�ɝ��1�
Hy���5Nl �ߡ�;����Lqs�mMJ \����	21QS���$���,2P�ń�eW1ZZɬ[҆Z!�8'ܡb�g8���W�R��İr��wh��L��r��t��p:aoj��B9O�+J��96����;]y���O��h��8(��A�O�R�Y��AJ8�Js�^�� c�u��w�o�-ͩveJv�$�%����4�1>$.��u���8�O�cG���|<1�=�ek"��?}��_v���~��J�J%�o�}��鏿>թv�k4xW�Tbgŭ�B^bġ�X����Mݽ�v*2f�&tMb.��̥���؎�t�
h�!�.�
Z��Q�%�=�K���*j����&�wafE����0ub�LY�Yb��+R�<��HoɑT(�����읱�o��91����u�'R�*��|bW��^��
�.+�ED2V�+�b��5����ϡcG��É16��/�"��l�7�=�p�	�-���۸C�_�K늌gi�I.�芤\H�^k�ſ㛗ą�;&�WM��Y<�]�����Y.��&����M����M����u�n�]�l�Q�~����ϟ���9cֲ5vA��!&�T{Ĕ�7¤��Ɣт'.Nq����ZO�)B[�j�HTl�K�Ӳ��]Oh��waKƋti�E/��-�\�뜞�|j��rG0*���"�c:�k�l���В��4����02�3���L�3���7mFBc&]Ρ��ԙ4/{��Ӽd���>�v�fl���Ώ��J;f����k-�g~K�_e�3�ڟ�>�y���\@�[���AJ�x>�{�p[Q5�{C-\?V�h$�0Ur6R}L'�ĵ�鉶q��P`#2~̜��Ey;At�s�pUO�X��%^s*]ߪ*�)�r�؅�cl�d�>#=�܎͊�̞S��R�
��-#�U	18I%�*P[`DɃԺ����g�N��ڲC��2���U�6��䘖Y�ht�L�� ������S>1k�E��%D�ar3��#u�kKm�RQ��L���Z�ӄ��M
���;)0~�^A�m7Rq�!"0Nvqp�Áo#q;�����:���Uy�0uo�9/I+��(ރjc�c�'�6��AL����)����M���
��;	p�����UKK.5�r���̎_�}�2?yج��|�؍r���$<{�)(>��%�v���Y�W@"
ТsPpIm��U���Q	Ĭ�6�<	}��A�,=9_�T�f#������/�&c#2���U�w�E��:^�\	t�ŋ"�%C,S�v�^¶��K����k�_��� b4>�#��y8K��1^��[<cl�ʶ���US=[�Q�ǫ؀�8���
���g�T��d\HKiq㦫q�U�>'��Jz*B#�_b֤%R���֋�/���Jl g�Љ)9V�}piڑ��h�����7(�~x��c�����$�t�� ��yQ�����8�>}���?~{j)�T�V�F�,�#QY�*-0K/�����7�^��θm$���[|�91k�HR��AO���)�`�Ȇ$��(�VY��kÞ��aW1��4{;���c�CU�[`��1y;0�m�b��m�����)ܾLbrg�\��Iy�͖�E��#cV!IJ�q� x�7O�3�ԐG�:��\�}GQ�Ul$�@�RC ��T����e}x� g.b���ئ6���4��y�W��p�{���QE)]�L_7���C�+��S�؝��Dv�,rX�q�HNNk/���R�e���.]g<����勉�����ŉ�Q��]X�����x�6=!2!u���wG�	�pUp��<k�$�����*ׁ�O�4��c��9��7#G$pzMq~��:*\����2������[�#��&��9�0������ᖕ��Ҷ���Pn}�M�>:5�����F�|�uy>eҟ�y�T�t��7u�a���&�8�}��M;�C�>����ɭKR>���f�Yo`�t���r���8�0s�3�u�ML���*6 OLR�WG�Pʇ�ԣ3�yf��{~��Lи0V��6�G�����J/r�%a��`z�3��b�SW� ث��kq���/>_�������|u���Q���&�E4��`jfᝊi��UY�������<)�OyB�;�(ܓ������2/���1�f�x�z��4�s1(�|�<�%�@,])T۴��->|\q��_>�*���/�������z~�K�$���b'1�$#1�[��}b��sDF?۴�9�W�udxS]Gg��u�~N
�C��X����v� ��;4���ؘE7Jd�'N��Xl�ّ��<./̟�m*�ۧ���e]�ʡ��`���M�1�haj�+k��X�'�������������\���$�Ol��`�g1]�[T������ȖʢOX��XKe*=�Τ�xyF�$*0&R�p�ӕ�[�PA̷[���M"Q��as�!Bx����	�Sjە�h�n�6�"k���"?�YrI���3��<�.�Ł��
Vj�ý�L}���*��_坞1,X�j����mh"�#q��<&�������}�N��06?/��#�
��XUlt�lܚù�ܛȠ��ѱ4�؀���ߠ
�u!�q[�'ֿ�}$�X懫����C�~�K@�5Nv���nfm���u!u��~��]�k��X���f;4z�uzqq|.,ED.(""�HK���~T~�=>t�Wv(}dl��B��v"� ��
��
��L!�Fׅt㧶���؀�E7.�\>[U�S`�t5\��Z[�t��,v�Ĳy��E�n[��"��|�1~y��_>_�z;����3-d��A��Y�y�b?��k����O�����-��3z?���\Ը`�J��Y�wtb�z�ap�^��L��ƶ�JL�ϱ�y�������˒,[�c�����n	��(�#ͥ[T��z���]G�� ZZ�T��b#嘸,*�1E��۝��^D1�ـ[�#7Ip�g6�1�+�%K�k�b��H0n8�}�H#�ǅI���R�u8T̲����'����R+:l���+����{�i�JAB{fl�XO	*�#�b-��\�����+�Ĭ)\��<+=~B�}qb��'?��)g��~������U�_��2q���c�޿���]��q��5i�[�t��IŘ��a�ӓz��?,U	B�Y{A�N +� �4.�r6��X�P!Z���b"�;Tl���1Z��M���Af%J��M�`sTZ/f���p��]�0��È�#��R6]��^x� U9 �U�>Tx�ɑ�U�Ћ�*fmq�a�R�qN=K[�b9�b�"H̅�_    �9�o��26P���B?�4WXL��c����{�Q��=����h��lƠ�\�cl�D�����l1�(�����yO'���Q���[�d�ˤmf���:�㇘e��u�G{�4Ui�؈��G?�����6L��5͆���V�?/�𭽌�o�[o�9�b��pb�����	�� �Uź��j9t���Y���~�Rn8�U>C�t7ϐ�U�����7c�w��hM��	{������3�k��4z�O2����f�����"gn<���H�j�+�����N�uc�S���+�OŁ�l�=/)L�T� ��z�b�ӕȔ'g:�V�ԟ�m���Cq����>��i��g������?�S���?~}l��,SCq��H	�-3Ge��깰��A:GDR����u���L|,�WV&��QZ��Vfɥ2��&��Q�,lU��37E;��N�-t>���e���P��|6R���)��I��0Z��5�#SQFg��E��np�1�H�̞C2v�/>4[H��#EF|xS�Qg�{EF�i�Yɔ�}+�q[��ʉ��:7/̐�<����j�H�k\�#�42o6:��6ց̷<�S�菗"���8��+6������E����Q"��+�ᕙww[70b�dmUsҨ��fnU��i[�<�F���ܟ��rT`���3�Er4w"�;K!����U��T��$?R�R���ի���LZ���T4��Y��<�r�E�ϯ�_ڴ��&Q�/vr�Ҹksx�[�������I�߽��)��,AŬ�|9,����jU��#��I'�� 6��k�ۏ����b���!:�n����2��?U�sF�a�8�&7c��;����m���4�X��+?�IY���`�?�92��S��3���kc����Uw8ȶ���E^%S��S1�y����H���7#�[?;q�M�~�*��K�h5��P�v���Spι+h��|��:��=Aם��L��UԼ�F�J�|D'j�a��2n
��PC��qh��>c��AO-3���3��Bνݹ'6��}��Y��E���L�m,����LI&�UL�lm���X:�E؝-�<(l*fX��A�ۢ�5�n��c'/Ϫb�I�cg=��;�����>1�;OG�r�tE
�+ei��_?~�T�_�+�A��20�Ӻ�<��غ4�4��AMV��[��Ǽ��@�-n��e(_�>�:#�^V�q��<4��b�vK"�4���O6��=<�m�����wh�$����
H݃˞v��?��o�/���[d��a���_���l��F�أ@���G#���~`.�D:T(��}U5T`��D8�7��Jk5=J-
��� ����l|�A���VӾ�K2��}�<t�$:F#�cG���q>���f5�p���$r�+?�mV���|��l�1��y��+�gsb��SJ��'ތ�Tj��A�.���:���9��*�c���*�����n���^��+υe�-r"���8�x�Zi�t=*f��͸�/�1"���	tK���fqK%:�}��/r�ĆΕ�b��<��k���#�ʵ��+0�o�C�ׁ�b����gQ�F$nVb���$θ�зs�1�3��gu�����ː���
�75�i�x��b���|~�]6 YGz�f>�(cӏ�1�	#	�*
g���7D��UMѫZ��kz�H!��ډy@SO|O[J}�T�2�X �;���PΘ�.��@�<�ݒ�m���}��BؑN��Zo��u��&��ߢu�}>ԉ��i"���͏<^����!��L����돷����������9�ӿ_-��5��ZuxoB�t�6"k=�}wb�X�h[�չ}H�U���&�i0 ]��b_��}�����6[<�"a�9�~��H��,�:�tf��4b�|-��}������Uػ{�kpAŬ銄˂���v�X��e�.(as*v�%%gViZ�-q�P҅�U�YG:������M�!��hE^(3�� v���Ū�2�X`07�H2�o � E� 漴O�S0��3��g"��B<����b4�Kwo�v�K ��'ƺ��t��>O.��.d�!y�jS��)/'6�	��1Fa�;QXN�w,�����:W�G�T��þc]P�H�+�fLQD�M�U�����G�{��ؑ�"k�Ǯ�`f�!��3�� ebjڍWg�Wgl6�^��?�KC��[�O�h�3�����5�~0ʦ��������~�kwu�|X�n��I��0�" �%��}�����x�I���߾}���_������k3��u �¬�J��>1CD,cb3�|��E�Tƌ�W��A��cL�^Fb�^k��S�kx2�U�b�:�z�\~�Yȥ0�2\
׫�YT�\��?�ǒ�9�U�����-���[����1�3�3'1�u���(E,���5��?۰�I�Ҭq�T��(V�������}������I�Y̝��x~��?
�u�Ƶכ���5Ҧb7{=1b���D#��v��xy#^�Bhlt{�'R��l��<CCU��b�r+w���G�?��3*vo�+��7^i�U�k\�.�ۢ��"w��������+�����^�s�L)sc��%��aM���Dx	�@҈'�j�<q����~�Ʒh�vF��M�!F�y��O4�b���o�s��7�B,5���,w��j��3X'��LD�DcM����##����rLt��
lD�o�/����^�D�\�uA(14����IJO�ok�7v������ր�uOH��Ƿ�8��d�����O���X��s�rZ�i�rl��[;XJ��>�И��qk��}�\Hu�byM{�uQ`CYZ�Ppf{�\�-q[�ey�*f��d�ߊ��&����8�z� ���t�w�V�kE�`3t��W��E热Z1����,(���5>��Ӥb�"����šWǟ�J�F���c%U¢L��S�'c�"zl*��1�K�l^,ʈ.w���p��r�\�a��
l��L������5���Y�����h��pT՞���l|���]H-؜�Y��q�v�b��x���X?+�0L�$�!�>�?��l诸s�DŅ�b91ki01�7V�jQ6�b�8כ5��x#�N�|	1n'�%cf!C�xɀUH��3&�-8:��\��r�ؽ�<���Ņb�c
*f0��j6e� 6blUw��h)T`�����rH�P��1��s\��vz��M�X�6>κ�V!x�
c*�@=�o��ط�"�*}!�B�oT�7^qu7����Tڵ��1�&V�t���Fni�O'��N��f�j��][�������ǋ󨫊}�9&!G��e�.n��P����.�nQ&�Eȭ$Lxpbk�J�����$" �z�/�1��������4i%˷���
��>�1"�DA/�gG&ͤ"�&�rbCB�x�<��$�=�l���m錉,˴b����"/7�AW�N"�b���&���Fڪ���=�G����C�ɝj
�)��6����Rٌ1�Em���b�O{ç̎r���� NŠu�J����N�$�4��������␂V�:ߒnͮbV�B"����X��5=OlD빳[l����h7nƌ����z�T4j�l����xG���ʎvS)<���d6YL�X9p��}Ý؀V+n���$�T��b���N�H��ߐ���ϑڏ*c��u��x��"��CῙ�q@�}���;D��-�dV�����s��g��=p��4%f?����|4Q���`O����a��B�:�� :D�C]�)9�I4��P����r{���A5b, �3���2�v赻�;*ϕS�~yhn���8�����-���1�(�ɧ�^i.7>j$c�+-�!:I~7�R!��w�E��NTJ!&��|��qc�DG�RT�EvS1�����?���b������EJ�g�yde�.���~�[��~���!D/Yة1�ܖ`]�5�G:/��r�w}xk�u.̘�5h�=�cp"ޔ��r��H�tvؒ$q�M�if#���Z% �  �T��V�b����O�|���{�0�G�{�D>(�qW�a�On+�M����.��ƺ���G��)tb��]�H����i|�*�o����*Zxk��0���p^2:�.*jx]T�|5Ya�٧�q���]J
�Zox�;{�]�0�ß�A0>i�'�Τ�0�� �]�`fEc��?x��%j0��M�b�d��D8��I?Ybl�*y���a6�%��$^��v�{�N�0���v%;l�4�2<�:��b���%��D�a�zzh�؈�{&�b����c���-0s^n�����k��p+���3I��%3�T�fu�aq��E��1A>݋Δۉ�u��֗a�Y�P�tH2`�I7���A��${O,N�n��c�~b�:<���|&�Y���	�؉\�����x��ݭ��N�Ar�ڪb�z�+Yn
GdÜd�|�Ş�����F�1�/�b��<4vBx��7ub=��WQ�3��	�,�eS1���R����������5'�(Y�\ b2���<2r�M"l�5�*fi�{�P+~�7y)��5���<X�q��̾1&���,�!\L�2.+���OX��k,�(Ņ�z.�E�U�CL��Vp��쇸ܹ#�FT�ŵ�:�,���`�
�K��Zl��UL�vLC�8�x��;A�:��� q�j����L�#������j�y�#v��0��Nx���mJ��O#cu��+��;�veC��}��V��ΑS�w�[̘5����L�Z�k�6���+1�w����Z��X��+�6��ǡ:!�H�NH��D�R���6Śހ5}Y�̚&���"��&�X��P G*GA�������7��N��}w�X�ތP�R��!f�4��6�Ar'*���c~|��)��P�Ҏs<΋����\P������������آ      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܻ-�mcY��U_������z�v*�:�l�deWE��Gc��$0&8A*�����bTz�a�y3��f��f�����"�޾}�5�/@W���t�sK���F�Fҧ���ޡY���������i��X��l	�2��D�9Z3���$/������Q)��]�#:ϐH�	�N� {�c_�����y�I��t6�ҟ�M���ɧ!04M\�I�U��8�Ql��c�3�����G�,�.jE�v�cF�	U*��b���gu�9�br=��4���1��ɭg���_,]\��(�.�r�s�#�T������ɦ{q���[~�v�w��<��9ނ��#K�����T���k�3jŷh��g������>���	���W�h=�v7�������87ə��!&�
�5ط�^׊_3����3�G����D�m�D�F�}r5�?G� �1ڥZy"=�#	1y��͢��<Lp�����H�*��G��(���i��UJ��'� 6S!n�% z-�~��3����qM�۠�h+{�]U�˽�����0�l���U�[4�Ab�3Ju�Y�إ��{D	1��Λ|�M�)����9���4�A���\�KKC��>�ds,�Fs|�b�QP<���sĮ]�4��x�����vD������[i��X���Gb�-�iew���ƞ�%�c��&�^��M{�0m�J3(�b�3��,�2���2���]��_����di��޻ť_\��v�
b�ԛ��d�f�ͥ�b0���ϣ%��&�4��Ti����/����Ηg9[MF|��l��WgY�u����{��/i�\�4�%B��5�S�"�e]�v(	3{�󤧯x3���zx�K����k�Z(��?�ɇ��m>��%߲����T�%�I�^w�(�#~tygm`�є:�#�r��͘�����<hʹ�ᘊ=(�3��t�Qɔ1��?�n��TB�6���5Iy	�����c�/�awv����K�A]�0b�x\є�ɟ��4-��]Pɔ���V-��j��X�����bMi�xDR�6�E3��&R�g7kk2o�DR��A�c#�տ����+����ߢ�dT����n��V���,w��Ԁ���-�yon'0�[��b����ݦz��t��r5�[4Q�Z黰#��x�9c�V����Y6n'Is��I8�$���(NDFo�T�bz�յ�#:-�jK��e5$D���T:�iOP�&ԅn���[2��*]�{I����������X/&�/��o:����@l4�ȁ� 5�+?"&�oь	�Q�Sw�fxP㯅���.��'Ɂ�4�g��s&,�E����O�;���	�hB���i�&m,o�'.�c)n���_N4��0�3v��\N��=H&�R���}\�"�:Q��s}Z�"�*�j�>�j��YB|8}�bg�}�����y��^�i	J��cГI����D@�%�, )�i��,gAn�`|w�Q�Ǟ^w����U�\^�BpĦ��n2�I�PwB�����K����E{c[��u���:Y߿}��[�h"aó�L؈��6<�G	K���/�*��i���]�Jm�Vؚ������$�B��y���������'����*vY�8|���$�b���DSZ7=")���IS~=�m��ܰ�w=V!�L�V���E�����(c$�G�&�G3��8���z�f��<V_��P��Dٱm��׸E�5�>"*�:ќ�:�Et"WDH���l�[��uT�%*�UZ�!��lN�E^�/�e�eg�AVH��e�c�,Nx�R*�Q8[ b#�!�U+�\X\��`q9Q�HN�����4y��>��:������ `�@��]�`6�&*F,'7y���)��E�]���chF�]��PH7)6�ϐL�'$o�T��2��l�d����&-*h�|�Ti��ii���DiK�Yi�5M='2����۬bŦL������GϑƲ�DϏڕ��^�\s
���M&r>ErJ	�M�Ǣ��C���驘p����XJ����Pz�X�3ین���,Y��.�(�ܼ��t� ��H"k��z��@�������M��X��礬�-�b�
b��.�{�Y���H�s�/���㯃�lsԧ4+ns��M��N�M��ɗ����@�q�eZ���/C���i@S0���fc���s��h�ӈ �����r�=���_�����}�+�/�h�;�" �(��̢��t��̑�7�ݣɏ��hƓ��{P4{c�
�ژ���*x��`�E�Ŭ�E����>����?~|��+T,�~��9.��,������u�:̣��;�7i�I��d�hR7a�Χ�}r�ʶ��Y�a�;�a�����K� ~�bɈu<6�1T��bq�NP�-���b��&�A��3B�ƺm�wŦ̥��U�V/�c�a$���Wl�Z�G��F�H9i���:�����KO:d��:@�ٰU�S$��{4-�o���� z�Qܱ�N@���N�-��,��#&7���$�eiƕ�yls�<�Z�(4L�<�j���R:�ʜ�9�r��T����"�~ƚ��X�L��k:��s�t����{_�Y�]�gTL��U���T�f]bT��S.�6"*/.�G���R�2.����0���I���n����a�����$���s��hR�-Y܍�e.�� �>�����OS��9��S����L��E��'/�GӢ�.����}3��Y0f>,��2��.kt��5Xb����ڄ��{fkhy�/�j5dwl���2UK��k�+V�c���Gn���Z���v�?�;�I&ŵ9=$��xR1���~�S蜽E�ɝ��<�b�.�Qg�n=�ix�0ó���J�8|=��)��h�]��}���!�z���p��!]�`{�VpZ)�M-�;EP^�t��痲�ՙ/�cZ0~)`��"",�#��qI��Ss��gv��۱����� �.tE�V�zf�z�{�]3�E+䅓� 1����)��`w���6Erf��-���p�Ȓ���p,�)oY����(�Y�GұCX;㟂�I߰������bߧXi�(g��B�3��b#ys�n3:��;���S��o�v5+vg�(�|���	{�g�S��U�&����M0�ɉ�u�U�/�fJ��=�_�;���,n�s�q���OT��`��	kֆ�fj��2���Oi��N�z�v�4��u�1�1C��eSblV-/R2�(Ro��MP5��|�����)��S����B2RS��9ͻ��[(L�/L�7� wln�����>-#cbHXp�J�U�õ��<^�K��.�Z`n����.#�I�ȉ��o.a�um�S=@��H*o��@A�`�B	C8��p�=|��r%����D���/OWî'b��[<Q�C�X@��Bt/Jb�$�]�N�;*ǳ�I*6�;ʤ�{�*��Ыw�H/��\1�,BkwMS���g���d��N]2}[	�a�u�3���$1�l�.��5qD����1�Nv�MS�=$)n��I�'p�U�j�i�o�������n��]K�����Z�n���u��E4?�����m�b�9�{��j�.�OP85.ي���a��XR�9Bldb9v+��JZ����y��
ݓ�i��>�j=`����NC�m����8K~ Ivχ��6�R7mV�RILش���I]t%�l�6psz��)��'R��ب�K�j֔ڙ�4&�v�����0H���H^�	>AS��?��Ӭ�&�}F�c����V�PGFh��h v-���Tm釄e�Q�.�U>L�^�k�����6,.G��]�#��/s�U:��>��d���xV��,Vʗ"�bK?��    ���|�~��6��Y���[��b�����|��X=�~�[��7Y�ɵG�b|���]���A�.j�L�E�|�{�T)���]ħs�+��Q����5��c���R�:׾+�`rW��ޔ��v�_9��G\AL:���A�����/BL����%I�T>�v�����W��C'@G�I��7;�S���:��:� ���)vZ��Iһ�cD{�-��!='
�a��GueHu�SW��MF�j�^gK�U�
F>t!&\�xo|����;L�@5��[��0Al8ּ��U�Q�\�7��X�!&�v{��{u�P�y�c0��1TH
NqHQI��+���Q�9C-Rz$����ڠ���{4㳵%7l��ƴiq]T	����H��	�n��5�������G�F�V���R�M"K�D��'#s���,�5�P�YB^C�$��i,������O@L��_~P���۟_�NSG���EUK���q����y�)���������/\��<�P�yq����vb���I��PC�8JA�wi���}���D'7�jD���C�L�E�ǐ"B�/����8��5�� �g�w�Px���?�F_T朷1�|��}��:(#��"���V1�N��P,	���Ǡ�r^��T�e̞��T�4�M�h1׸䣴"�g�f��&8�a�ij�(oC�gi �E��	��\�����s�V��4OQw�G
=5ٝ<E��ީ��W�Q��|�-Q�Z�_Y�������d耉��:��2Ж\ �B}L������y�4Ą�/��S��F���z��J�78�>��o�l��أr�.tC�g��Q;���+oY���Z�[T��m�yX~��v�nl��-��R&3��H�=�Uf�>�v�>��<��[��?ޥx�X����ʫ����������]j5W�z���d�[�nw�[UשYK����ש�X]���=��w޵���o���ogz\VBz�C?"��Ћ��-k&��m٧�;�� ���*��+<ν���2�)����f��R\��i򥸏	jv%��W-��b��ʶ6T��[�sFCC����no�ӚQ��!;��ʍ�gJ�>�0��a��2%�G�l��#1�r0�4��Ox�	��c���JZ�&jz����T\s+���GSCl�3�����[�Q�U�ƥ�c���rt���dIT)�y�L{e�YQL',�d�t�"�+��R�{i�m�ҵ���vgmY��n�����ԺV�b�U�Q`,ͭ��/�G��������K����O�]���<�=��1�ͼ��=?:���#�]��z��d���rW�R/dҍ��XY�{W�b^���e�p
�pUڼ�h��U_?����?ӑ�.(It�M�h��U�۶}+&����L%�e���s�I�x�f�`i��M��įm㈆RZk����8�A�iz������6��G;Y�..6Dl���'iz�EQbc�{ƶ.d!I��nQ1_40��P�gK�q���� �2JT�c}��A,�(��ǵ���a�b���8�Qd�4��O��LZ�i�RXX�[��s�̋нl�/���c���?��G(We��e���V# JEV��U�ɾw���I-��t��[��g�<_��[�=��{_2f8�fg���������p�If�?�k�ζ�ˆ���w�KM�ߠi�nqή8��u��JF�Cl�_�Y�:�F��0��mzRLO��&�IIm���{�%����wD���m|-?E�b���G�դ�܌��"�}�1��s��aj^�^T�� vc��V3^A��JJ6���h>.�^Cj�S��)�n���8��
p�)&;{~I�4�4���h��П���bc,5�07���	U+�wEZcݱ����&\�֔�&���<l�/��j�Ej�9Jז�O����%�uA!Opn]+C�'��h]A70v��z�wP�p��҄Y�)�sY�g���7�vo�K��Al�6�:��9��M��ff�����]��϶��Mɤ2Di����:�R�,7_����=yǪN�ˏ�O�1-���*�u�0a��.M<������΅ylny�p���9��^o��2d.�U��\�� Δ����o�03���W��ym.#M���.�F%T�e�ܣlM��]�C{>�d���b�/�3�j���;篼���ܑz9뻾[�.!9������<�����>W��G�td�x�}0���������O�0/��sv�&�a�I
=��Q�%�}�b�:�\e��H�͹ʚB&k"��"��J���:#eD��Zz�#����N`�Q4�ېi2��}�Hg���3˯��gΡ��u5��(R-��������^0�1W�M|c��=�1/iJ/�����)�Z �S=|�H�%(���ռ�ϲ~��K8�=���A쩇/�)��Y�?�ÿ��?�n�bwhca����ݼ�)���׵=:&l�bh�rE��W�hnn�]D�t��@n�W6Tw�C�n�.��Qc�-��͝���ՠ��l-��}�T@z��	�?�T����OjQ���`�Z�i�n�I�1
�)��i�-��i���fO�%�d��(^Sd��dRwe�v3�dL��H�n�y������;�����Gc<�j���0_1�f�mUFw ̑�R�W��$e��N�^��Y��S]�֜_���;Sl�X��&���v_8��M�n��Gv ޲<��A��.��
�7��e�d[B�]��+ejD4�����8w@�H�ә��s�����l��R��p��8l8���d�>Rv�ׇ�8�={}$Lgvg5!Ğ�Β�VzYW��Ibd���/�ߛc�!f7������鿾������g��W=��O�3�e�c��k�ږ����W˚�=�hV���T;*%�~���v043l�`MXQ���|�}�|���@lB��ejWR�[�{fʉ��F�����,��?Q���/?K���,����a �JK��j\��q��c_�����6�Qy�Ru����l�ұ�k��=8�Ը_��������?�!6�f>�55n��Ă<��vv狚&oqX��]C��{8�=����C=`�����ݚ�VW���� 5�إGG*��+�6a��:3@lT��Rsf�V{�t͗�z�j��Y��|ne��1�!�ټ��������-��ְ[�u��3�ӊ�r�e�&���)�$o�n|�A��� ��ċK��C�i>���V�TSK���M�[ۚj���R�)�aC�23v�)����[���H����o��ղ��,/��NAlԋ���X����&elܛ3pK�bw\Ƽp���k��vsָ-���5n�f�[J> �EO���A���K̫���3�-OYj���L�<�Y�VDMn��Ğ��4;�����:��=`�������讌-�ZC���[V������aޤ��`�9�B�{�ᘩ������O���ܰ#|[c�^1YO��	������De�nߊ�����]LۗSK�ڗ;��+7H�9hM7��I%i#����bV��(��sP�Й�E���	�MY��.A��CE-L4C�Z��x��3��VX:�ĨWl�M�򲁜�؝S��SC�A�hHȕ���!{c�X*!f$�s*��;GBMx猖��sE���Ŷ�k����-V�����g�a�g��򭿽a�^W�XDWgB�������%Y�8ݮZ�F&�u�Vt�S�5*��G���3�(��By����ۗ��m����~��Twk���������8�X�j�%�[�U,=Alp�T�-���\ݸ�������v�2�4Bl�6�2�iQAY�W�Fɐ=��f�`S�#y��9`/^�������>���dt� =jb��;T�R~cm:��;`w�1
˼)P�o5���� ��~^�4ҧV�6�Њ>7�*j�Jy����`rP{H���e�l�+�s�+UE�1�UH�m�t0�i�k~�����/�o]g��_TuY��W�v�����l~Z�up5i�,'�	V���q<LB�I���)�\���Nz� v�X���ʛ�r���FV�Ǎzتs1�r�-�V��^ь����oO�{��E�+of    y�K��h�ެq��ެe�o���M~��� p�ܫt���0a���UW��M=���VA�j�?wU��{�M�.��%ckQ֬pX�,5kN͵l�Z��Wq�ĘfZv�fO�Φ��Tj� V��5b�|!G|g�Z԰D��>
	�N���Dr8��4Af������q�%�������z�m�5�,����'���/XK#RbF���V������v�v����t�G�<�o��\����'g4L3��9wL���pߤ�&�R�uh��斴��\��+�
xYV���\ϵ�`~[6[FS��XΟj���0��mw%��(U�Q�ٴ�o��b!���5�0���b�j0�I�:��Ilf��i�jU[�Ug#�+���0D#ĸްC��7"�s�u��ֳ@���G�]D�Hyh�Jd�S��c��F��nG_y�u5djL��1���d��k�v�k�Y�˧{��K,�ɬhB��8�;{!^SK�ǃ�:�B�M�EXYf���~�P$L%n�p�%���Z�؃^δ'C�����u��]?S�%3�)�;T�xk��	�>�a�eп�4}ѡΫ0M+�v���؄�JŮ_��.��d\w��UL8���{�h�5!+�x� 0i��I�xKXW<UZ�������	�Ǧb3v�/T)�K��ㆶE�*(�~�E�]���y���<�����J����P�T�l?f��U�4 ����Ġ��w*�<`������wg	>��T��ߜއ�~�������	���Fm��f*�������Y������2�~U��~�����ק�L�0����|��O����S?�,�y	W2�%9�j�%��S��jW�}�;$���}��~���������ۯ�����#������� �1j�%�si���WY�����z��:��P���R;����H�	P#��ClT��R���WF�[T+6����h3�=� w���7�fPKL���o�-+=�Yj��V ����TB�$�y�u3��R���I$��l��s�ȫ�4I:��
�:�T����䎽Kg����I3㠧ݹ��Ak6Z�6�J4ѥ��y ����+�H��,6��]R��b�)�m/Y�1���L�X�n�M�Lo�Ҏʻ8#:\�D��f�)�f�=v��<�-ժ�x~�wl<�NhؕVm�2���5U��� �L�>�t;�Z������EN�,j�&"�Sk>J�[3�>�Blf8��TQ
WJ�ů��(�� b�����OWq�Iu1)(�Yx�Tv���S�a��p�ڄ�A{�,nx���G�����)�;t�V8h��!�A�?gwL�Xڥ
*Kchr%:1s�G$�u=�$���~S��o#��u�=�}�E{atVs9�b���]j\�),��V���8`�'��6�PhS��ZTp�s�Nv���ؠ&m�r13_�[P����[���C�ԩ:�I���":*x6
��fP�����*��D��6��_:6��`s�eE����t
�0�@�S�N甃��sxD����ԏ�O1�6!d�2�&[�:��<m��; BL�y��+ME2�!e'���<:���L*`��4zq>FXh����h�c��/�����ޓJa��zԄ���h"�ƕm��"�&V��4b��6L�AY��*������c\��T�I+� 8�𮞘&ToY�si�M�ba�J� 8`��n��J���F�a�R��'V�<�S��IW�k	�4#�L�(������g?`r��'�h��ᬏ����S4W1i̷+-4]��W&�{sг�D/���s���)8��Z�l(̐�s'hw���f��r����o����+v��y!��Lؙ"z)����X�����1*��[�a���W��S�1)��3E͵�G�5k㭁u����v_��1@m�'d��bA�x���0�TCוkyU������Ge���%
�X"��F���爷c��#��7c�y�����ƞ���tCׄ�M%�X�	��۷�fw�K��
���˫����n��?6T�ӻ���_k� ����!,1� ��T~���ӭ��ac!���d�h�_hf��v��qSZi�\��?j$�Պ+1��]Q��q1�1PȮ��KT��>����ϸ}�t��ӿ=��o��	B����}�$?�������n�g��T�'�I�p���1�O.YL������I�}a �|b����%�|�a�
����گ^1y3��c�X�����!6٨��a�Û������}Ϗo�c.�ݣ�?5����V1���-�ڄh�K5���~�'	e䞹n�n�cw�Rk2zQk�Ga�r��C.d&w�yfOrU�C�}�_��wG��}i1yե��D�a���	A�$\��ݕݕ����	�o�Dٝ/U��O���Sv�J6O`' &�'��˘j���7BR�� ƗU�����2�3��S�;���ڄΆM`�kXRpG&r>��{
�&˽a3%a�^p��.�Ϋ��ll��&�r�"PO5P�t"�5ycYq�/;1Sr�a���:䍦�����D��㴇;M����ڱ���VZ�� ��T7���8��J���Y+l�̨��a1>:��Z�J"B���]�����T&����bS�0�6՝pRР>)���D2R=�P��+h�P��
e�#��/^3���X6%��h��S���ܛ�X�4�IE��}�ֲ��R{����|͊��������Sr���Y�mK��B��8��b�^��W�7���"eH�/�a�*/���I��i*��z�Y��.�(�7F��Zb����]�Z��)p�c�z��4Fp�D�w��T1a���:��-�*�X�k�`��}�RT�,��0?߶0�E�'�a�F��R��f��F�J��a�$�m~�/�ҬucԜ'�hV%���j�W˵bWU��5���e���1�s+ZNA�'���՟�A�Ǭ�4�J�\�q�N?7/l�f�b��Pͬ�x:<��>`�ٗ,5C��1��\+~'����6hO͆Iew��^�C�
U5���$$�e���:��ؠ�ܴMօ�%[z�VdabX��bZbש�n����(\���UljYa��Y���F�Dw����:@l\.��U���CW����W���e�a#g���E�+Ĩ~�f�E�.�Cl�\�����)4��ك�b^b���3K�`�%� R=����7L*��1ʏD�:�M�R���
��Z	 ��h`m�K�_>������:>T2yę������jW�A�q'�Wh�L�Y<�購�����M������o~����/�z�F�@��R�W�L�-%�8�t�+?1.�:Hj�׎b\����\˕��>����Q�����s�?��avgr��B0������6=�W�QF7���sd ��5�E�c5z�М��z4ҁ�G�b�"���F�L��ܖ�����x[o���H�}6g���z���N[5���X�ӭ�/J	jɶ��ƍt�t�ْ�Co?IFc��\+�^�����
�͠3��I��~;`b��M���6���J�ju���έil�g�?�=�p���[���&�FĘդ~�%P$_�ܠ���qe��� .�2�م��,�	K<J� �u�|*u���HK��J�AL��;�UhrE���$�^�;��?P:���U?幧k�5D*6�����^j� 1@mw�jt�-*?K�e-{;$�|����7�M�������ܥ��R[��<�B��.���D�[LJց~Al����^[���R����s �Og���~Ȇ�6P�����)U:�TQu�uJ,CC�RT�M̌i�ϝh�n���0y�MgӕN�ذ�i��ہ�� ��p:`'�S�ܘ�,��W�5�v�vѫi���Orc��$�lk�(Գ)��5�]����l�dxB)l��&�U>�I��6�e��I��_��L�4���I<#G-c��w�w������ׯ�����q�v���f�k1�R�Il
�x�L������)^�|H����U Z�W\�=    �U,�cfI~mq�*8��}Q�ٌ��vTG�/���ɭP���yш`�4�E��v��r�<?���-̏���:�?�m�v�2��OTg�,�8�'zxJ��S�/2b�)�[�.����}?H�T5a��a��2���S�w���8Vh��f�.�i������va���ns�%�֐��C"#%-���[���W�j[�S�����KD�/&�|��;R����-�3|�F�� ɪ�@�0I������GW*{�II��5���pj�=`sů�KS'��x%?���#�S=� zّ��T��#���!���\!6�����?G���k]�ǆԘ5L���6��>.������4l�-�	Y^���5�0�؆�Ӛb�%���j���s�-*�ԘZ��fK XALZmݥ?�o�2��&�8�����ֵ]�Wĭ�MH5�TI����$x8��n��1ҩ��M��MQYL2v�R2��b�ˬ���OI?����y��z�E@M��cwNm��Zj����P���ҵ��ћ�g05��~�3�RViG�5�t E66���I��n�O�BG��2��!�IW�̠�8�� U����T����OA��o߾o��hуP��%4NfF���J���4����ld��	�bL
�Ϗf.vw��<%���޵n��2��(�}�p�S�ۨ�b�`�YQ��XIg�S�]Y�|��
H+�p:���I�0����;�M<��&��+&oT�7A�crzɖ���*���`܌�cs��7��d�g�_�����v�t#�bOL7M���"yi�?\�Qۡꏓ9��0ᄑ~Bl�Y�]p*��4�����R��:�	���k���t9k��`5��u@����GuV�8`�{T(�[*Q]�ξ�S+l�+_���R��z���R��@l4�[B�4���m(�k3�Xe�&#8��᲋[��n�+�C���X���cۊKC*2�+Vض�ᆙu�H���b�L2�l3H�"�q	�Md�jA�r˶g��}*��bOR����I��o�B[��tA|��t��(��ߞ�8�9�l��A�HAs�u�w�Y���>�B�ubGwC<*�XG���2~��S�s$���ή�#bW��	�n��O��L:�]D�2M�a��h�E�HZ���߮q����m5_eB�,��Grԩd�
�,����L��c옼���L�s4���8������f#:�1�wLX�ͯ�Ɇ��
����]�)��.�Β]�!ˁ�{6�%a��lb�Йez�
�qQ�F(�c5�@S��Ol��W�55��e���R����z���h v�^����l����Ό�^��t���4G�2���耍Y��r1D)ǜ��A7�nƎhI7D7l���R˅����%���n��_CMwFCl��\��zڒgk�ԣ���S���%Q�!6J���Uܨ��aop���	��R+����&����dC�3ߐ+��iW'ч6���v��Q���&N��R����ov����X�K+�;�^]���a�����k�Co��_��)+o5�Y*�I[nҴ���~@ ��V���x�X����V,�r���L��*r���"W`��_]y*q�R�b�����,9{A|*9{�����՛�Q6#זeņ����oz�j�H���+a�b���V�|γfGLgb�7�FVu���[5�.�,��I���6�upf���Bҵ'�4�0iR���XjO���?��nzD!D���R�G�#֎w(5�k6��S���{��Ϥ��Q���-�҃��&��t�)�D��FA�;Ф.`�I�2]k�FSg�x�Y�8�3�]	�X�M���TmXV��ɰT[#��O����ޔ$,y��L�Є=�CeC`Q��6�<�R�S����5��I���*�x��9`3����%��'u�m���w�Z2�͹�0��x_� �*g,3\u�h`��%
[��T�t�TR����h�9[x˪/���oR��zs4�%1��
X���ʧț��������˘�{*�;@����w}*�����G���_�0�'����n�X
�٣�uxt*�|j����^����dj�UR���O�؍qV{j�ڢ2��<k�KU�̴�*3��{Œ��L-�xrԽ���D�$R�[+�̈́O:͎B�R
�D��j����Um�w�f��ѿ�˺�.!�|�	�AU#üݫ���"�l4��:E�r�����WS�j����߱;���\�͔VX��p��y�`<+�*f&ݛCv��5M���|�7/hFl�h��-R�5|+6��W򻯿� o��X��q8>5��0o^�����R���d��.�xѼ��u}��y����U�N�轅26j�[��%N &U[P}4O�i�)��i��I*�V*0p�G=b�h�j̑�o�o�}��@�E�6ڜ#���(fߒ�أ
�����4k���W��W��J���K�2�`��q�#&	��������`l\tt��� ��*9b2�
��.r���Q�4��0WI;�o��s�O-���sk�Į�iR�j�����V���)�$������)�ҧ�&M�M[fF^�#v�e�.CW u��l	���ınb�Wħ$����>2ҷ�����ny����k�1�T��Ӵ>�T	����,?�<��$��e�v�AF��@�T��ƺ5	6l����V�5jeώՊ���!�6������0$����m�������;V��n@NO2c5��������?6��l'�	yF��+?yĄ#R���Ҭ�,g
������� 1e$]��*��d�SsaQ�Y�F:���ϵ�s���!&oLG���\]v��c��y��s�_�̱o�ɛ�!M5�i*\���#Z�tl�;b�����-��$�d��ÂX�7Vv�Jm�V�=�-�C�v�v]�U���,�9�"�5fp��*+�ؙǞb���#6Y���Ps܎P��t�Q%�꣇O��P��˻�o�dK��ɓ�g�}lؤǼ�֌W8�|�l�E�:u�N�)�+|�ع�Ts�S�C����C�AX��mҒ_~,ܠv���
_.�&n4m�����	ٰ;�V��[*��ݠ�t���z�&Mv�	�t�U�2��_B0xD�t��1�vKޤ�5��ξ���;b{6F����qkIߌ�.�M'ڭp`j����7�q��ӟy�f��s�މJ*S�����'��T��ǌ����a���xU�A�K���u40��Fj�yg�Ulԙz�7',"b�l��~$�6��k�U76G|��r�;���꤇p�&��j�߫ĩb��ev����Cl7��M����d_�؃�J�����a��[X�Txs�t�9�J���Mj���7��������O�6��.�փ�t�x�sUl8��3#;��ǁgGl�9�j�5��-<�����������Z#�bʨ�%��O�^�a�a�-NHT�b���=j��g�gZ��Ĥ�ilZ�^������(X謴Q��s�5B7L�(a�ŌE��/ʫ�B��޽��Le��
1�L����	�
Q,���\u���W��Ц͒�䘭�?Bs�G����Ѥ���}������#���_>��/o_>x���{^��+���>}���O�"��_י:jS�p���AgY>9��2]��p��v�n���ҵFr��j���lӷK���$`Y�H���=�r�j����wl�=֦>|���}������ug��k]�n�r��Nx	]@�~k� ���5�>�8�gy��9����4��næ�^�Ҭ؄~S;k���׾�ؤ��5�h_��B�*�w��f��T�ij�I�1���?��I5�Zٮ�e^LcT�n.7 #І��X�;6N���*Y�=�~�Y?H�����z����#6ӽ�}��;�0��Ĵ�8oy)9�P]��pt��x=���;�(�r���,���em״T0?���"�V�	G"�K�4�c��W�8rқ;�VIN�.�I1ղ�E��A�A޼��S�)�����p�ey��Ҽ�=�eZ���~�C�r��`o�W֋_�    �C	gOO��	�L���ݝ���eY�����K�C���1���ײ;�b3���������U+8�^0�1?�ϭ������Ruz�>x�|�CS�V�t8�Fp���3t�i�.u�X���W���QV���]=��?F��>��1��3���s��b;��Ѱc��ؔ� 46����Q4���GL�w�{j��(�-,*
����Q*���/��De���ŚL T�mbP��Gm�أ���x{Rn�[T��pudT�M1�*Zv��R���4E�3���;��LwW�J{��̈́R�٢r�ԒLJ8���S̥c���4��� �x}�ݟ(��-�F���o���g���9��=n���!SΪo*�իzɵgb�Q�Q��-�x;�$Ixx�kN�n���,٫�o�7ٲ�&T�z1����-{�ԯ�\��9t���<�$�{����Ri�1��n,���8Ψ^��V��8c�lT�fӖF���`��+\ۆx�9��@��l�X�u*yXlP
NF+��"w��f����5ӕw�zk�H�� ���^;�,��.�=����z~DM U�N��&ב�n-]z��*G�[������"�QY�+ٰ����(>�MT���`�E盦�q�F�)bFW)�����YA�Y�S�8�zcW2�7��}@��M[�y�F�nf�i/o=r���`N�|07��
^��VJ���x�����J���D;jc#2�
��ā#�>�{W\|?��`���%���._{�.+b��hf��Q���!�۸e����~ԇ=���-��.�5i6dD�*rw�u�`jT�>b�p`t5��.6��!5�?6�7m����H�7��o��)@b���r����"�nP�jZ���^8�NMgSM�h�$1އ4��W%�l����'�;_�h���#&�"߽5�-�D�c��'yMϤ�I`��;��g�������?}���[>%'C��\�O�+K��U�C���2��Mm��Y�������/��{���޾��Ӈ��������wy�����_?���+ ;���۹��S8���NB�p#)o*�I1BS��[T��&V� 1�0�q�w�ͱO��j����:���=�����,:9z����ygݝN��ʾ��=�{��mZT0�y�g>������Wl�����~�1aϕXt/|y�T�����7d���Lk�3AF�� "����������_�tm5�����2�b[}�bٺT��kH4���h9M�"�.��2�oG�D�^�B�g~�W�i�ѯ�6�슩I{�t)h4'��=ȹv������[��+Ԙ(�e9��Ҝ�m�uO�рe�܎��������S[�/o��W������p�㺈���;�<�;a���N`�W�Y�*C�'�@@SI+��ƴ�Txq�FL�M_���K�F��6��⛍�_3+���3��v��뗩�nY���W���ڻ�>g��$��&�_��BL�<�g�L���KE��T��>�{¶7�����i�ؕ򡸄|`i�l��䆸ɖF��R�@�"���L;�R���q��x���q��DZ�&���E��}�%��i�j���SE��a�G&�0���/����m!E*Z1��l��6�(�k7��V�ol֓*�{P���� QnZeC������󂹼�M+7�\UT��#�m�"Z�����M`����,Ĥ&�}�� �'YDE�p�nZ��s�m���2g<&m��1����XPW�QH9��ccA{UF �k�Gӏm��c� {���0O��	L��j�n�%�HE�����cp�נ�ͮb3��1U�nX*�Ћ������/��sc�DL���,5�.�8�5�� �؆���0I��q�T=m��w���xL���>8`�sP��nX$-�Ee�@=�Z�v�P�w��oM\��K5�A7��%�a��:WH5�^�F(�♡��\�v����{0ɱ��E?K=뤰�L
��ݙ��~��W�Yc��{;�OΈ=�����}&޽5�ج�b��C��	b���u7Ч�.�L~١�d�-�a�bؽz��Z��)�{�j������#��u����۽e���_�4R��a�~uZLPxƽ�dʹ#Ĕ�I�
b���P�UR�';?hh�^�r�8/�w��h�dl���9��8`R7��$U�T���D\y��f�֟�'���F��d]����������8hȇA�e�����I���T{Q�4�P��98�l򸄓
��q\����V�K�#�_�>*�d���"c�jUۡ�W��ժnB�]�VFn Z��'����.��q(���xRBp�M�+2戱^�ap�z�^��T��<�I�C:ŠBӑXi��u0ى&�%�IHG�=����Ů?K]v���x�A]�<@l$z���*-N��A��婪9,1�koչW��|��S+����X��iy��X#Xy���<�|��߾�����,XC*|NKʧޓ�\B��7���[����`�o��Z������ѸA�.��~q�ܔ0иi�5~�8�M��e���(�,��!�L���ˊ�#�N�H�t�*���4����΅���u-k�Y��&����CR㧙DL�S߅�z3�зn��&��LT����s����	^"��>�Q�����fζ61�
�6�&�]��ٷd�q��:ݳA�~�Q�T��ӆIۜ-p�,�X�x��(һ��lu<b5N����?���>���P�s-R7�+�#�z����>d����(����W�6��Y���(�o@��b�{_;�B�Po�bR6���4��W�)�d�/f]�#"��Mٹnu�� �^�*�3�?�y��0I*��˚�?%~�*��C�2���f=ߺ�����;zl�a��8��cQԣ��QJ̤�`�}����t�;�LJZ~+U�ݝR�������:��>�U�Y�*ڧ�~����8'�<o�L� C->	۠�C�����8�=���D�ω�%X�Wx�3���#��6���o~Ɇ��/�{�..�6gj'��L�K���ɂ�Cj�����)�3#�=<8WTWv2
�DK� ����Z�f���og��s��@l��`�Oҫ�\�ߞ#�g;WAl�����p1!��Y/4D*��el��P"#V?���"#�O��aЪ߿��ѵ{�bD�G�B��,1��"�<�z;vE��I�l�p~a�7QV�ƳXRG����@LIП3~;6��P+���h�ш��y������/��2_~�SY	d����ʂHK�\�`�9�;�$k�2���
�9�[TQ�.y��O;�]�d�J;5S�fչ�|�av:h~W���N��m�����4U��/�}�C��{ċ�
v�&;�M�X����st9�b�S�O���C>ZF�B��]*���E��Z9���eD���T�f���A���/xJ���O}I�)��3�l'pzt�&p]��bc��(<4k��������=�����v
����	��5�����u����ےUG�X�׈$���X� ��1�q�`w6<s�ّ*�!��J�[bڎ���h��S������*�:�>SF��)��a�o0��)�W"��Hjf-�Tx*���g�b��<�s1<�Z�N�Z!�����4m�&_`��9U��|�wL����+L%	��M��ysL0bϙ:��q��S\�:Ǔ+c�ȁr)9(�8EnRs�妅��������4��M�F��H����~X��E8���2j�SD�O�{_�ȋ����&ReK���Q?`c4ֶR��M|�I�J�zb*̐m?w��?`s2���,�b���OE���N��L^ڌ���%g<<A�iݍ?k�X�;���	���Oʾ�Rm�����������;A���"�R9��;v��r]_W�m���٭��L�og� 6RھIM�YQo9{�.9`��
����=��g�NXp�ص��'�LPD3_C�u��!��k�b��rx��A��w�`;���N"Bl���e���5e��/�؝S�Mb�4�i��4Ps!M1l���AkwП0�|��ю0��D: �  c��Ջ��D�p�fT��Wq����E]N��ayE]����1��n�-��+�DVپF���VŒ�I�\�J�tM?R���I���u߉wh�S��CS[�:�wd��]Lc���!LB��	�zjǾ�6fy,�D,�^Z2%a���\��nK�8�\�W6��>d��3�Sf1��*�7��iU��*e|���Ʈ�4����Rl1T[�=�,5��F�Z����m�Pu�T�+&Xſ.Vї�aZ-�Pͼ�f/2؍S�alv�w�5��
�Q�S�G&�=f�PM���2��C���&�v�-J�F�)7 7�|4��&5��?�!vg��8봤l�AQ��Yd%��ZIR�S3"v��\Q�����u��^1i72~���0NA��|�k����Ӽ�6�U�ZM6��d����X^��k�����|pS���ӽDȶa�T,��,�J�I�0��W�����B����ΰ=+9��ڭ��2I��,�X��]u�NiqT�Q1�C�����Z��&�L4�Y%� &wȺ��2�\d�?ᶨ����b��]�T��������&�x��sąW�M��
b螞z�ږ�ǻ���Ř|��6����syB[{w��zY]]��v]�O��8������(R�P+s5��\�-�DM���LBF�pW��2��P*J��[���{�	B��a]L�
J�k�*#U������S}����`$+�'�k�Đ$�^��Y�u^7��1)�4_tѫHig!6T�Rs~YWo5ކH��Z�-Jt߶`R����R��4�9��>#�J"����a��.��u�cu6E*��b�)ʃu�j~�,ƮNZ��@Χ�r�G�ða���)�q�w�^�]݊�yq�9�y}R#8`{n+��qp�la$k�`%l��bh��4�vk�%����&�,��r����oi���iw<s�&�,:U)G��2dQ*Y8�/*.~[�k)+<f>�mS{�mMo	Va��B[fj�$-�d��]�����@ǓCp��6�^��	v�����5&F�"5 �,X���b#�+�Ԩ�z�Y!3=���-�"�t4�\��кT3�%;��`�lLv/}ѣv���fS༛�e���6��t3��f���Ĥ��=Ӵ�f��#�팑mgD_ݦS������M���"z��%e���s>�Ky�Ov��&�Anl����?����W�.Ľ4��ʝ6	��/��j������>L'R�ѫ���s�Q�+�S�E)�1��Q���J؄�Ѳ�*(6Gm�m��q�Qd�ڰ��I���	��D����R+t�qI�&�^��M2r�{Esb����Xd��������C��hV����8�g�G�-���#E}|0	�7�Sp���H�Mv���}(s�_9`���R�������?��?�/X4�u      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
����ݖ$��,�笯��	��y2"3�ɉ� %9�����i��~��_�j������ő�j�b�9��8�P�^���i�`���-Bc_ ,��캣y�&\�,g�0dݵ�82N�~�b��"�����kNe֏���� �tӺ�6�	��f��J���)vC�N<b}�%kp�v���z�.�Kr��l,����7u�P���EQu�����<z,$�o/���~c!��:�	{���]߮r��LEa}�f�����l
jF�;�� ;��+�o�/@�{+��o���F�J��	ȷ�K��C��W��+��+��p�t�o<�|Tⲵ>�?}�,
��A�(R��Z�])qג���;.p��=ku%����3K1��h��^�A���;���oX�Bm5B���}��À���h٦dW7%G�%IKHl��H"R��#/���ޕ��XR,��VoA���Ṻ/\:y�K��X5p��o�-�P�x�wOX���@;)<T�=��푈E���o�u�I��b�g�e��\XE��>���(�\���|�a�u�ʼ?|�[�`P�-��oҌ��Dnzy��d��d�Vx�b��]M$�<�����ʂ�4���b�b<kZ,��@W����}`;�]�1�ʲ�\�<g��[l|\�����9�3C}p�5��}Ww�#���
0����9²� ���ˉw�3���40���`Q��a�[�� ӗ�U���0:�����7#���5HF��/¨�M�"y�fɮP�H��#5���^r(]�+��
H|Ĥ����⸪��W��/8đOT�ma[����Q�(j����h�ȭ*qA�3M	ebfn�fT������=�fЧ�G�C���#�P��x�tt1���� ;��%��O�K�����v���;=���~����D��gpd1��C&l�͵�G�{K�e��"���p�9��U��{v$I��\�x��{��U.�ZK&�J���QK���x��9�����
*��ٷ7�5�&�ܴ$��],��]�m%.*��L�$3��-���u�������"���K�����yWo�Ĳ�8��Eo�;�~XSA�@X�`�*��#��C�t%.��*�KX$D'X�_��<��VUa'�KC�zX�u�O8D0�l"H��X�/�bW��k,'�Dy,�:��ϓ�AQqS�R�.�������p5���.���iƛ��Ekt�S�s��h�/�Z�Pc�S,Cin%.X���.&n6ytZ�N{/;�_eFF,|��\��|�,�J��y��I����A�-�.�uXC��j��8.s�����g��g,@��E�%ڗ��ˬboX�Ѿ�����u��E�=0��p�I/��_�w�X&�T�2V�ė��1c�t�0�.���F�W�-E���^W�O���q���������+����Z�%�/��ݵޯ;��8ڒ��X�����d��T*YI(���ˀ�U������d�̡kB�)O��"�$�n1���J$���lU|�    )��¡נ�yZ���.�����P�^�Aѐ��qI�`l�?�Y��ʴ,�CQWX7LvnXX�X�Z�|R�~�a%&��`lҠ�go`������Wz?��l<�ey�F��-R��OJ	ܓo\�c߮ʨ,������W�a[�I�%z,��?���ŘW|	���&�L����JZ��X]�YH|� YL��# wٜOJ�ޱ�#Մ��X�y{4�&����"1]����-�ԽcW���`{��j�/��H���(ו�S�q
S�������a�.ݟ]�q���a�$���Eb�R��|^��bç� a�]w�}XwYv$��#�ِ����4���u�y�
���Vǫ���NK���?�Q0�E�,�H��=�h�C��d-Mܚ`���	o�,��W�AY��IS���X�%��;�{�z�E+��`��-�T^�����P:b��2��&qY�Os��On�b.(A�5�u����6���g��b�v;U�
`�%��Y+BIZ/�f�C�G1;�ʛ�(�R/v�DlE9�	�b��R���bGE,b�I		H�����M�t������@&k����}.+�K!�1.Q`!.�M�m{��B��/T���X*�FY\�#0�~;@b���v��l'����"o�2�q�BH�`�4P����ӕ����h��t`�3�lLl}���d1����$"3�䀅 ;`a0k;,�g�e�,z�,��m:�h� H)�I�됬ǽ�+�$���aUH�ǿ�OBy	�hm%D��^Bo}e���W�{(ֆ����n{l�;}���<�F�jc1ٰ�m@��Ŧ���_ا>�/U�4>�y�܌8�6�n*@�ؾ;�D�*�veg`���8�kU��e�}���/^�X��㼀|���m��wZѲ�~Y�,���f�%�i�����x(
I�<`a��m�=P��ﰃ�M���'/T��3>F��fM�yUX���� >A T�DM����4�Hg�!��TKq���l���_���p�6���HF�Z|�Y|LO���;>=���Fr��c��16-�3P�{�5� `�r�a<j%�o���8���嵥�@�+��`^�`���/����t��I4�QW�yz��Q��¥�č�z0��`�-�=���kC��A�.���(��;���
���`b"�w�]���ef�6���K��������?̃�U���d� ��c\�Ǭ�{Up&y�<kJ1j����r��\K�$Y����z��K�޻,�\�+�э����J�~�;�֍�����xT4��+,)��+qY��_�N�z�d.���h>k�]�%�6�\f.͡0�.�E�|��}�,�A?����%��N}5�4���cK���=����y�
$�+&/���4�$�,҅��2�^"v�U�g!�oɀk0\?�5��`��������j�cĦ$&�Uc[3��V�s*���H~6�����4#C)h��Xe <�84�A#�X��ͼv�������Թ���t���D�2�\��0^2*�1���yinQ�y�[yk���0��+%{�D�v(��N��vK��)�^��o�N�)�f�+��1\ f���B&]�����-�Z)��vZ���C���aY|q�ٮ���l��0�m��j��X&���t�@�����J#as)�w�9?��ΛȠ��oƥM~�b��໭��v-�ʹ�"�6p�0h���|a��QU��1���2�}�>v��"3e�6[H8������F!՘ڤ�
x��כ��Qo�b�8lӹYor��߂
8|5�]�>�nY�H\�c�����gh\�,.X~��3��"�4¯(�ꪴ�2���R����f��B�ؘE���v�a��V����xa�R+j��*�ڳ�#�oW�L$7m����.V[�L鵲�
wK.�a�(Ŕx�<B���ʛ�W�����sk�w��})��{N(�&{�@��|��؛wWn��iw�@�v��.Y
8�٩�>vFEۥ~�b��m:���e�,&(��Uo;�tzp�ddz���b��|+�K���bu>���:Bq��%)��6���8#Y��d�qp�T@����Ӣ<��ؠe�q�A��)P�����@����[ͳ��/��B���mn��BB/�����.|0����
R|> �b��}e�2�^L������b��\��t���V�s�� +ޏ�+iJ��v:��sY�n����#�\��3�Q�rb&=M�T���������{��jSJ�K���d�]�bF�2�/�4�w�@x6B�ăP�r#v(����5�d��2��$���yU��I�P��O⋥��B
�JN�b'�O$���Au������漧�9$&�O�.��cQ��RZ���� �,Rg���1��d���.y��%=-P`��fLR�6�ܼ5҅(�"#�ѯ��HkP$6Qň0v�l��3��v_d�Z<Q|lL3���x�y�K{��
3�l�N��� y�Zڃ�r�9��1���� ��Uf��lg[��?���CZ���$�̎��|F�+7��:����,@i��k���8o�	R���p�|� ǰ��� �8�Yw��Sӭe9��Ĥ&�|܎ń����mA����x�\s7s�{��f듸l�c$ՏNX4��d�z�r�k�GLM�8�(Y|1�w�SEq�61����P�KC�(SU���ߓ���!��߂�֡��Z�Y��V~��H��>OΕ��ݕ�;s�w,iU�\<vHqP��o��[(�H����x�$1�Y�(v��Y�j�������`������*:�X�9w�|&��@L	���Lʈ����ϏT>��ܒӨ�c[(��@ٵ���K��L��Qq\�,�c�x-j����uG�r.��Ru�ҮM�m�L�[è�x[���%,�F>�3��K�!_�e���0���%B���>X<ϸ�Q�]�Ȯ��Xf!>���!^IbҘW�����"�[D��X��m1�J�J���X�e��;�2��2�H�- a�2Ӈ������b/y�WS�Z�����
�*,L.����Lg�����V[;B�`���Q~�ڙ�E,�K:��f�f��fސ#V�ّ�Lk���M���yf�`�0zB�L�{�4m�O.1m�L���t4��w,��2�*y��3�m�;��Zb~#=mA,�M�'R�w������|��ͪR������|/n�2�U��uH؏XT�����Ji���+砸F�Yv����=~{A��`l���6g�i�D��<�Ѱ��n�v�1��I�"{(���ӝ��������� Y��!���%�R[D��+]���eU�̔��<w]mu-��B����Z���b�6���^��(E��ȅa��x϶��
F[���{%L2+�� �:br�����[Ixn���ZLX>�?A�qK�2)>[$�"q�A7�_	U¿r�n3����{lX���_�%�4��Qh �j�^�@p^í@��xc�a�������k@l�ҝFh$ ��ߧ3�IN��ߴO����<m>q`XqA���Ék>��$U	��.Ik#��F�f��R��	�њ�#�,.�w0�c���د�ҽX��dKC�^�`���j��_��JN���@��a���7�i'X���!9/���җ�M�N���}�7n2x��T���M���˘�ؿ ���Vk�������RFM��'q$z�߽��b�r��X%�C��PJdD(�x/r%eY�������,� i�"+7� ��H�	`W�ڽ��X
��}@�43�;�<����u�����y����l6)����62�n����~�e�#�/-��b�"���c(��[pVG�����q��G(aݶ y�$M��H&4��V�㙝ZL�^��7N���\��=@0ά��w`&[��rP|���`�G!ٴ�a�ԟ %2�V(0BLo�0�������
<�m���u�J��c�h,~\�z���NyS�E �ǀ���Lr����!WS*�|�b�-&��Cl�#{�9����Ŵ0�<�cH�	�XU�ѼK37�
H�^���*    ��ӬVA�Nc˪C4-���\W�H���F2�����_�b�5R�$��l����K�\�Mf�Aϡ�e8�HLZ���<�����]��7��xiUV���i5ᨦ�P�� Y\V��+CEP�v'J+71vlS���J�~u�\������&��B]9�(�H4+}�,�f����iH�k�,rmH,qm_�ĘͥK�GM�aQ4װ<trmw5�v�͏�f�^Q�� y:}�r���^K��)1r�6��h;eqP��b~ׇۣa����_*1[��?�\�Ǯ�[�b{(����hY4���z?v�fa�sj��Y�c�LC���*�Z^�� �=ƒg"���]��گ�Ip�I����g�%�p�����ܷ��?��J�dXq��.��Q�h�p�\r�~��"���̅.�hCV�Ga�(C������<�?�B�TK��>D���S�hl��� �X��C��pw�I`x(0�0l(��[�X�&ߴ�p����vZ.�ɏ�΁�g'�D���b� ���8
밄e8�ILF��n~Y�xYNN��޹`�b� �2@>�_� ��k�����a]L)�C`���s�'�^���������0s�
���gvNX���H�D�����y� _���%��<cg��X�+n����M"Q�nYVZw:,�(��Z�1$C���>�{�:��%��^�_��4�����kϸ4��/	�Zɤ��K^D:(�l��Ӗ�M[��f� ��`l�@���'$��Ym���̲n������+��,��'F��	0��
���/nF`�X�ʲ9�UXaM�wғ!���
��"�(O�D�Z��<f�w�lw�_�^���G��AOHL��y~��H��oFZ% 1���Dنa��k�@f�J��� Y\�L8N��-��Q���8,_a!���#���+����N㑈��-8�-\,�N��Z�ߋ��K�2��Ps�B�ⲻ�}��n(FƏ�D��꽴���*�b�,+��R�06�e�ҌX��2���c#�ECo�J*/ ��G݆�n��;������!�՘�א$oҋ�		k�uk�jߪ����������b��󊒁�h��9�9Ѯ�]�7��J�E�)�zT�,&����� �C���k`�bӸ�q�l�^�L(�=��wHv�n��8p����
,c`��v7�$W�>��f<�wq�\�?��O�I]�º���'���{�ɂCS7��oގ���ְ������E�u��y^'.1�O�A�IL��.+�~F�%�Yx��Ϯ���f�w�y#�M���m��~��S��`��J�����ԍ���ɗ8e۟� ��%a������`��t�ɕ�l���=�F���H�~�I�UL�z]`U�&�hڠ���\�������@��.y~�$�H`\���B�g�v����Z>��fde�/���iM�Xp������f�hZg_-�o�L<�\�8,�jr{>1�t+(�v�p�°�����R��=�Q�����_�@˂!df�%3�Z=�
덙��j�����{c�y�2�2�I� ��IR�  �<'fb��ۜ�O���&�	�5��Vȥ��$�g��K��u�X8�0*�ڜ����mr���Nj�(S7\	�����0I�Q�Mx�#�+�!{�v�
�2�r%�ӽћ�А��b��o��M}F%}�X'�6(l'8e�|��f��Xh�������r��O��[�����W� �VN�ma�RF�8aιw�o�!p��Rܝq~;��t���bZ�셱@4�<MNn0vRh�M�"&��V�x,���U�TG0��j�����h}�+�)���& Ћ�0�qkeq9�����`K!S,�⍝Emw�6��L2Ź�N;��eE^A��)�Z".	���)v�G^��@s�Q�R���".�/?<23v H"���\v�a�]�K.��%$�����q�!�Ť�?���T��
z)���$}����*+��1�/0q��si9dsw�\��6Y�J���x(�I�Eg��P����e����k���xt��>���"pO�#�,&E9��-�A����7re"d���cJ"㨉�͈���f���(�p ��w���e&X
�#��Z��Z+1]Ϗw��3,p?�V��dGFg,�+TB���EO�U�;�c8cU}�A%�/����������������� �{򈍗0�4�a���5�M����8�����^^fP�p�i�à��B'�p��ѹ��č@ؐ��bt>�)�u ���ވiH��.�@TT��\���U�ǡ����¾oi��eA�I����^)�ш�r|Q/��r�ؔ{��$��||!7���x��	/Z �J�k�*	�UDWI�# Pl�V�;�Ҋ����U����
lmE4$l��'/1��R�����`n'��3�$�y�f�	���|�]9R�Wyo:0����'s@��
�*q�_���@��������zՁѫ�^���Ԁ��~S܋�s#�*�͛䶀ֳ�ѷ&�t�EMI�蕡\bp�H\���$�¤&<ĊEZ$V�e$�(��
Qø�HL��I>E�"�K�y�d�,�@�����J�p�GEM;��Bⲽ~9=Ͳ���*?��m��}s�J���*��e�*
��XH\������dY��H���j}h�^�[6X	�siT|.3_p��d�����/B(���	�A,R��?chL�?�
ev~�d�q����o�������X�1ҭ���b�}������������\W����t��ĥ�Ti�n3I�QWء�1�Vr���4`~�Ǵ��L�I�KRa�>���-N."�.,�N�;����dr�i���i�9����8�~I�%�f{i��)W�CSa%����%���X��d��9�v��\Iqr�5^d6׵;)�b�(m�س��\ LY^uxY1�����
����6��P���1z+1lĶ��؆$�Yה}8���[��Stbü�y�R�d��P	�x-.�;���1Z���1�G���c&��7pq���X��H	�Xz����@$���!��'1)
�t��c:��9�t�k��2������	U���p��쮟Ο'.K�)$h ��%�´&�mخ�_�쯙��������eQ��
�`F�C��G�����H��6���oC���VC���Ԑ���~t�����&�� (.�� h�v��ӈD��,��K	>[+��q�ǈ$�������q�~6��A28�W`��	%T�{�u��¦˟^�B�}QN%.����$�
�M�:)G�ws-J���(�C� ���B��̚i��O_��Y�;��ޢW��$�㡄�b`_�)JL���o���v���_ϧ��}Zg�6��s��W��������
���kĴ���r��&�Λp�s�;$�+�r�46n]��8��`�ee]0̚�Y����Lr8Ƚ��I�aG������p�Q2?�b�����<���O���૨0I�M/Eέڟ�J�[�pUŪ�fa��Z����a3@f���EΊ��Ҡ,��]���|{]��EY�8��IdG�����*q�%����ů��_�y�]�D%.�5$�
i��p�j���^w�;��O�(e�����۟�G���ee~������H���KWˆ��.sk�H�&1�0C���T�6?��}���T�V�,��SYtX��K��o������A+a�L%W�d-�f�+,l-E~i���Tb�c�X`��f���-��O$���@�b�L�4�}b���ZfYH\�|��)h�ޒ��x&sոȈP!Q�Q�	u�%<��E!1E��`�Kx����& ��^аB
rMXքy��H� �Ĵ$/O�+���X6h�x"��źNQ��P&���-%�iM^�b��'\\�aJ�V�e\,��մb��K�Rf����o�B$P;E0���~]���i�ºR0�/���b~�ߟYC��s�IĚ��]���H#ME�(n]���A~���JLa���H����<�:<�؋������Z�    ��<�_'>)��`k��{��p�r����>A3d�M�FU�g�ta4�R���.�&��Wn�������J�vQ�\?��+'1��Ǔ�����8s�-���p\`8!m/ŕ�!KE�D��}�����2w4D�$��#1���pyUDd4n�Fj��R�8 �bivYX��ЗYll\#�I��\Ŋ�2����˄z1�!���a�Gr����	�y��K%&,�ǏOO��(,�T
��ҫ��Ib_af��
e⅕��#�,&(,)�0~:h$��6XF�4��ܾ����g�Q!T�{��� �v1�WAa˥�;{�GP������S���BQ"Y�c'(�4V�w�k�F����"|�o:$���^L�XcxZ� 'i!�r-����&(�����}\o
P$o�J�HXG,v��L��tsO���Y�,��(��^F�7�	d���Ǝ��rdo�2�e��(��^^A�0�pp�q���9Q���Q�)`�9�*���'�.&7lrV������]8�8vVl8hV$���LN/x�!�Z�is#I�$��T���fEVK\t�s2�BB��F���������a�q���Y���z�8&�}���#T8�����6���޳�R�>�^T.'0�$��E�=q�>c2G8�X!�b
�7���Z8����2��e�ҥW[��e]>��й���@ c< ^���#)Z�"�b_�����#x�<o@��ԏTথ��{cq�q��	�b�ܸ,\�+o��3�U��tQ��d"�_nMc,i�eQ2{���=h�?^T�5&S@����:�:̤�{�f"4�%��]��������r�q�
)B�&��B0&��<�z\�z}D� �p.w咢�E��X�m�b�XQy\��G�����;�^ZC�[���q��bK�d].K\,�1�|�Z�ϑt�	U�ɷ��U�,8��%��UYVO��� 1��b���ܪ�sc�Ye��D􈘕��̧��@awXMǜ�EAܕ�@��i���KN�������{枿��'�U�ۨ������-��[,w�&�tt�5�8��6`���:uF�T�,��~�-K��٢�"������ �Pw�Ү��܅9�'������t8󕇦p9(h��hڮW�_P|n�Y�wu/)>�/�W5$c��Ҳ���2`��ǲ�,KX�0r�ʲ���/��w���M!Q���.�_Θ���k �Ir^�а��5���`5.R���b�� ��c��ai��j�8�ޢT�2���
�uC�r&�?}zzy<D�:FZt���c�Zc��"��y�:��a���Ry�,�$}A���)���*P��[�+%;�G�}�K%�
�D�2i,
[*u��b9$�?������?���~����2�R�'b���ii�9�U����e�}�z�a�C�#�v8���(�-�b!%��j�[�g�g�1$���w�)>*n���{ŶH�z08|�F(Ff6�AYH\vط�7����X��W�x/vl�X���5K]�d��*�َH�� 9}�JC<gQ+ �V��_�ﶗ^�E0��q3$�d���e{=��>3�y�ش�*���b%�t�/V<��_�bO'�E�9V������eYY�Eϫ��F�Q���B1�b�|�A����*�1���MHݺb:.�^�?g�34�Z0&RW�ϧ�|�d��bOo�k�|��aFvʲ�"pS��m����@v�ǿ��_fH�!l6� �T��"ye��W��%dSВ��x-j�C�m�K^��a��`Ǆ�l�E�J�n�Kb�H��s�ׂV�r;=?�\�h���bRe��mWp�:L$t�G8�=���o��O[���5�3���m!q�����eq2آ/s�X��
7�#A��~1Y��y�.Y��/&q9���������K��#\V�u����_#�q�5w:��-&1Y��_YvB�ݦ]��0n�DR����`UU,5N�**X�`�ILn��ï3c�X�۬�B��
��+���-����1n��@.�
��������[L編�ۊ=��4�G@'����ˌ
�,̼��;.zڳ@�<����Ǚ�r32��=7�'AQ��~���0t��,Y_����`��]C��Y��[ �@�Q�m��/�Mwa��RҶ~���>�;�œ��8�6G\���=��`��?b�4��	۵&m�&r�8��2�L�`U1����a����S�M��6FŤ����=�c˽�K�"y@��i���.�����
@Ct0B]��Q҉nA���c|g( �#�,�����nv
�y.VlJ		�Z��U�w��Z�]@�1����j�S���z:�(JQ�JN��19-�ciMX��VY�L�s��Uʼ=B1u����17a����˂5�Rl:j�{�rݵK����΄¶e��]�,.X~:�ݪ��QX�tIi��H����b��F�{����I��x_���@���8rEs�	H�;����w��x�'�R!5!lM��G���(C3%�#��t��?�䠄���K#2�p�E�o@fyd��i�;$���0p�� bz�?�tcy��l�z(�N7$9O�����H-Y5��w�,&�-N���l)P��ɕxO�}8�qP,Rv@}�A<ؾIY�MZ8�]�&;�$�7�|U���[�P`df�9Pe��(l�Q]��d#���~	�J��
(����E���t�6�5Ys��J�ʈPҍ� ��� �i�t�sc��J\4,'_�b)���  ��Ea�� :$@"F�Ko�E� �V-�yQ4��`�x�%8��1K�%�,�V�6#��ʷ
{�/�/��U��+X�>xh?��v¢k,^-r��*[��R�� ӱ6W�,Nwl|�b(M!�S��m�����U�y���#�o��ҷJLw���o_9-���1�`a]��S:-�b6�V�"���*v�Ĥ����f6c�i�%OS@��x����^ٕ�[8�Ť�"����+��aP��UP�t�m��u�7��z�s1Gyc|.B�J��6��$�:]0��]�����\�y�a������So1����W��9p��i�S/�f�0���l����ԋA�
��_�c�r��/A�ױh�cj�fݖع-z1qlKHx���b�����ۗ��8En7�κ�����z�O�	ͯ���Q%ޑ��"�o�	��mf��tk����%����%�"��E�+?��t,r�`"?)�����W���>��o��w%.KrDc��w8]Fs���*TB�U �H�'�$31������#H��MA�\���o4`Ob|�F,`Wҭ�!{����밸��eK(�#���Q�@o6bQ�9��j��B$� e��K�(�X�~�<q#�5ֵ+c�4��D��:.���_�k��y1 !1y�p�#`���&4 ������N0��2�����������Ż����]�j���[�&�Z�$����:���_l蘞w�T������4��lA��f�X�h�~�z�2U���$�؁��HZ�d��f�l��^���Po�s$3adq������;^Ѐ���Z�a��f��l/)7�v$ӝ, ̂dq�Y�H"ܶl�ؑ��66%���4q1f��ܳW8ת�.&���>����+$v�L'W�Ȏ�P���l�E/r_��m>b�'2˲�7�g�#�*6�rR�.�d�J�0�o��b6��rC��VD�;�v�f�|}z��;[�Ѡ/)�ɓ`R��B����*�-lFbB�a��`Rv1y���Y�����m6D[̱+���q�H�{���k��E
�廂�JL������# �l�9�aQ��B��k�Y����0���a�͈%�	������#*���x���j<ɰ�`�����y�JL���3,��G��ְ��,_ a*�Q*���
�a�,���t�i($SIU�՘U�ZU�]��tya��?�W��@_���4�8��Ɖ��C���sH'0_G����Ӫ|~�̠�	�p�1�G��L��,��eq�,���	%�ŕ���E������/��o����&�    ��.�i�ۥ�YS�8�o-��]%��9g���=��X�9��#yV��i��U�i|+3g��op� &� 3P����|-�+=�b�Nm���,8c��t�����>P��2�W�<h�Ĥ*;�G���)�:#���E��K+�IX�$��儃�P��t��ö{���;���i��y`/����+1m���w�!�*�-]'���&�n�Mv���/b���q�xOv.��N^L����b��E�"�~�g%.P������� ���ua��4����eٱL��?�#1��� �.b�q�BK�	c[�Q��,���L�n?�����h��	��Р�셉hd�2�U���T�XL�uݻ2����<�`�yk��F iv����,��+�@�9̺ԟ�{`���׉�4�%���j��A�e�0����Bَ�XX?Ƙ�b��]�v�nCWډ�鱐�e��Iib���� #�$h�]G���8�"��w�#���d�gG���;���+D>����|G]�v���g�c����6�Ż%��E��8�+��]�^%.{�a2e,��@��|��&�@Fe�L��:c6aN\��CU�0$맱>�̯����xO�!Q8/K8�U�����i�Ob�[t�ͪ�nVw����+5�?���,&��t�p�/M���t��.���e)W���XW���8����(�Af�v�r�D��	63��ڣ�'q�����nz���я�o/��F=eӢV�'��xbY�ֈ�Ob�,H�:b��N��?O[�#������!Tk�|`iqU��m�cj�&!��a��b�ڰ*$.�BTB�3��hߖNb��4;.OY���b�^�f�ǰVg�S���y>e.�40�\���l��������J3��$�k���� ��G�h1�=�}s(�UZj����c|�cO�\����+%�/&������J-9�@�H��1�5��B6n��ۓ��2r�� Lh���U!����]?h%���yf'#���s2
H���U�&h9ץ�w��`����RVb�%=q)}�<:@�t
�^�d���Wx$�d�k���\,{Y�ľ�e�ld�E��°m��w�H��#bdfV"�yD��2D�>��=�K�e,"�!�����+4�k} ���&�/�ҥ(+�~e�,��CXl.z�0�v}�毿��Vl���e�D���8����z��5l�j�<�I���}�ۿ�ρo#t8vqY��X��xh��}iI_*"�R�H�e��0�[���!��xn���o/}�i�����q�#�Ť�_�#9;�q̔��L�8^F�f1Vf�y�ű���J,��>�o3��EQ���c����Ɓ���g��>����Y�5NW<�?�>/Y��ĿE%o�F�P޶,��+V����diyu V�t�O�Тꆖ����yu��}~g٧'*�c��D�aD�a�'T�>��Y�x��w��L��t�*Y\� ����dYe�%�WP�f���`����$K��������Q�
���ۚ��֜�$�ݞ�R��zž(;"�b��5���o`8.�xLU��LJ��7�ɜ1#�}R�$/_XC���i���� ��hϰ �<|�ǚ�vD�ϻ�JLQ��<�Uy5�N� 3�g[���y`�~��\��ѕ�j0�ϓ���lmUݝ��e1l\��2,�$�}���Q���X��U�o^��T^�@���/4�kdsU��ր�a� j��J�X��_j����uO�P��������#���BQ5��vФ�#�W�k$�/R�;P\v��[�J@tج؁`�	ZZv:���%�2�0f�I�#!q�__��f �@T�[Ɏ����<Ԙ��f�G��F��|�٭Ļ��v�O%��"�z���z"=qf��ҿ����u�T�/iI@,��-j�`n�a;)�����n�w����������*�#���-�FՄ�ô4�u�����0_2C��E�$SjG_�ē���Z�'��hRp�k˕zbў�MK+a��a;��/��N�����#yh�d��kx3^$.��
�dOB��;D��=v0��h�d��$GB'a�`�>�}qH%��ʉ%@$���("��LK7"Y�;������0_�R�"��AO�
���+�߇�� V|.\߸^��4�&�.ƍ�q8nư3��jW�&(z�U�/��Af��.l�8�y��@�tma[?�����5"�zwM\H�����}�V�~��+� Bɡ@���Բ;�W�C|�4�G�"G$.P~�t�g(>G�v�c��n�*z��җj�'ҁJ���"�>O��a/�ڤ�Z�ʦU�$��eݝӷ�R�c�&YL�?͌<��H�i�#�n��@�ƅ�7\P<�MNaІ�g��Wa�Z���eO�#���@j���YA��l��`�������vKh�^W�|V+2�����`IL'�׹�$ :n&�[���Ӫ?��ZQ�/�Q�,�Է�N����9���$�h�~�6�+�9�Y7�H�Aݯ5�8� �-�#����Z�Q��[��	_ʣ�p�"1E����mѻ��;��C��ꋓ�ɾ_��/Cf�=`
�%D��d_&=x�$'��KG�����>}X��ƣQ���]��Ĵ(��/��`G(���u��(���FO jq3���C�V_�S�������D�M	�l��6�!�ٺE=�ž�R\�t|數�ֱ@P@m�	�VM`a��Q�{\�I�r�aE��<fy�&�;S�H�f��*�t��2C��+�V3��|�W����Y�n.6a�p�mQdUok�>�����K�H��|���_�� �Z����ǽ�f�l�ႁ�J[�a{�L0f�.�R̂d1�a@����HÖ�k������B�3��dR/���ŻM���LG��]�M9�����,���׷�9Lά���(��eWݝ��Lm����˰��L2XDvB�v]�4�p�W8&�B��U,�4�8� @S2[��mc�7���}�¤"N�9�~ge1��W~େ:)����p�Bl�����bW��2�|dq�-��
�7�~Q��@��fQ��m�v�ic�6m��mk��	����x՗FVb�����&$��B���k�H��Q�i�a�zU�%_eL��D�Krؼ��"Vqm�ȋe�BFû���U��}��,_NO�b�tЙ&@S*$
0p���J�Cn=�z�N.�����͗rA����w��d%.��	����,�@�|˶躅 �󫌓�BG��_�8tD�e,��?Ϡ�7@��f�@��'-KWV��K��e��T��s���X��Xו�H���o�G{b������{��=O�KMwz� *v�X{|�e��-\b��O�X���Wb�v�I�����: ��e��z��b��b���"B`����y�����K���Xeҭ� VY|����V�
4��#�Ԧ��l�W���-��%~��̚뇅4��	�Ö��`��{Y�[E7ߐ��F)�����֖SWc��Tat���2�B���X��
H���~^�*$(3����\6�R�}!��-��K>�$����2�#Z�PF����8nͲsKt=�$�\��7��Y<,��@^�)By��yf/��f�F��ѡ��f�L���F[�K�~�_%�#��<Yb�E�҅��e;
t���,��ʦ� �ìl�Ĥ-�o��P�/_.������:M���]2ɺd4b���Rˡm!q�a�:�Aq8��$��[���L�� PL2x�Ҭ��b�a���F�P
��|r��\pȖ�4��;��Ce{G�z��eB�-����b;=t4�	�n*it��!���~xt%�%�p�J
�zh���в�:�k�Z+���8�+X�!($~-��+ (۶�(pc�1� �f1�����?J�ӛV���k��r@"f���A��5�Q1�����E	G	��\��l���,/ϳ��X�y�I�p����%I7�ʼ� ���˼+1E_犂�d��I44��a�h��GL�jf�hhx$׈X�礌�����][�b]^�(C~�cS%�O�'    ���L�?	[�kd{�-Η�d.Q��a����/�;?A���d���/�Z�K�+�%&ίJ�mz$�����N�8%�ǃX��e�>#��3@VF�;�#_�М�dqQ���^��& �y����*�j7ܭhxŇ�/����-�4c9"46�M�Nx�lѤQ�;��Z޻B3���<�eT��l�o/��2�)��$�ȇ�a�35^�����<?���J����h���W`��-�3u�^�DѢ��}6���5�iVL���\���=Y�蝀nU˒盚<f �śq��h���%���/������X��m�|L[	�U��j:�os�: V-��6��Ǫh���(_~ fc�1��	�Ր�,߼���c��E>��ta�32PLu#�3^{�`U�2]S���[�VĪᖳ��|�B��ӷ�3k5��M���gi͍i�e���G�/����'q����G��*R�En0�#��U|�(~���@&G�ʅ�[yd����~��6��˖����5���'���%�$e�!1��lcP�L~r�0}�Y��[��\s��!9S�y�����9Y�O�%�m.jK*$X{�$ԘF���@�X�N�[��d��U�<��g�є1��HA��BJSR�E���J�p$��AIH|	����V����5a/.5?+��a��v�X��p�� �����Oɉ9��d�k�al񴩋��\KO�l<8� ��`�d��g[́�C8_E	lg�-i7uI{��U^fDR���X��`PHL����8���{�,0�Y��ژ�3����%�^�2V`��d1�˄���(�9鱋Ųu��tn���X�N6�����-&1��o���������ڥd�c���X��,f��+���t��B�����/~a._���39�������q�O�f0�=f�qj8�IL`>���,*&g��md=���Y̰�X&���m^�	���ӗÎ��y�Vԟ%6�s�W��5��'��=��	�c� ���0�$��]S�%f7�th�/-���*R�hYL&�e�X"�K!�3[� ������\�#�W�����uR����%�[�� �PQ�}q,]���A����;^La���)&v��3�5��$�2�}��s,����©e�&��ZB6n�u@�_t����G��6'�V'Y��w�%�4+��
�̵H�,���<M([cI�H=`H���6�=�����O�KD�h{$$�ď������B�:p�;Xּ�μ�������\-�L�Z����O�_�����\�G0���θ�`�*��c�8{�3{L]�q� c\���|:�d�9��v��� �,%G,Y\�|��OdH6���M'i kY|cY$�b\^��پ���)�*q�a����qF����~
)K?�D��K(]kH,�F�9����MX���0V�C������(�K R/�)$���#L.M �r���rw8��E)b����f�������wqu�~�8��>�~Yv1-�|q�7�^o�DTzN���x��Co��U
l����s����bJ�ܝOO�̪�G�^7
��aUأ�*A���m�K�$�����F�,�X%��?V�w�k$:�,���_Ϭ���"Jx���R�	�e @��Đ��²���;�ȚQ)�4m)��Gg��K�1]��QX����:��5��u#�wWN,N���j8Eb�����_��Xlk5�AD�zEY�����X����UQ�HQ	}`*�Ƴ��4Y��m�0����`��� �|���| ńt��B�?ɸ$�"����@g�����]V��k�:��s�(�x;�.���ӧ��䤔ڂ��,�����~���A-U~q�a)H|��?s���G�٤w�+��
][U�楈��G�o얢�]3uT�s%��D-�s+w� ���t�J���e�V��K���N��py�r��6ɻ��og��a_w�7X�X�����A3�ee�`�/��_��v��_���G������JݡY+?�o2T�>q"M���hH\V������Ӆ�b��_,�����"��5.�R�YCA�EWu��_��|�BQh��xsd�fmE4�W�.닡 �(ϡ&��kz��/O|�TA[y�
���8��9ǰ�h��2��^H�n3O��z͚�v$F�K����kje��c�������h]�x�OJ[����ɩ�Xǖ[�d�f0\|���d|b�O9�2E�bx�ǖ[�:.������uW!R��S9���I#� `8�ҪΡ\LJ�h������QF�=��2�a��@K�c+��ꮑ.ގer,;��8X��ȗ'4�h�)B�@�2g[�^�K�4L�Hym��d�x��U��`�/#5�9��BaФ۬�_��Zô��׎��L���~�o����ɏ��C���Xe;(ke{���`?�%�������X��%���ܭV��k)o�PW�����Ob��?N
Ev4�^c$qiX@u���FM[�[�O��CIK�����m�kP�Y@u.�_+E�hʘ����HR�������Qq��j���T��[��������b�xF��8p�ɠ-.k7uc7�b���g	�;������!.���0�4=8��l�HCY�t`u�θ7,��V���2�ILI��Ǘ#�	����6��Z�[���������&�]��4+��+��Q9F[�ad�xך�ʈE֗�P_�)�]UT:=�=:�@w�E�. ���b��b����E{�r�E$=��e�fw��.�,n0�L6홬ܺ������U1P��l���]9����t��%]�X��~�����fZ��P]9Қ�`x:�Er��AgAWW���G��[u �S�B�ϖ�Y۹0�^�F�|���]�t-.@~�p �ȡ�UK�a��i<K����a2?��Ǩ)YL�#�1��N+�[�u����z�{磞8��: Y�����H����1@s�c)w���}a����ѝ���.&E���_$�T"9-��c�C���f�<��V,�kӵe/��MX������b�S����J�{�eE�%�`BlAlu^�X\��cXT�J._���-r-� ���Z��i�#�LPk%�i�������n�9/,?�8�O��.��C�+��T� �g�PmE���@Þt���H�.�8?�YR+�ӕ���8���`|�gjm�P���8��"�Y7�B��#!qq\μ7��0��^L�+K��]��v�<ϵ��.I��7��q�^�F��ɚ�\�pǱ�JI��|�vx����ڪPϯ�X� /\h���˒�S��Bb��p�A18o&Y{�YA(���AYLS�P��=>O�`�dq1+� �
�"#y���z� q�k�S�r���ھ#��E��+>�e��ћR!�t��,Ӟ�y�V�[!؇o�T�7Y�#�d{($.PJ/wzYN�7U/pz����w�>�5�[^LRǲ������xOQ>���30X�c��)ܳ�ڶb׆�K�;-�`4Sy�<�t�R)���w��BPlܤ��cy��ݲ����һ��k9��(.Z��'p;�AC�Q[4�A��+� �U���Ys�+$��`V��������Ġ~�H�~��vM��0�cU��.�������H3h=�i}�0��� ��\T
n+��A�Qv`nY���$Z6;�!�,�Ϗl�X����:m1�`��?���zz���
'2[��DF�^���̩�<�he>��Ÿ|�I�'#d%�~CXV�c��e�w�;�&P�����Wb��|��8������ K`ع�N��H�8!3}�G���&6�H�~]���da)P�����,�;!�eY��v�͉��NB;�0�v�i����0h�N��B��N1'�S�/�ί4��]�ʎ5�SX��
{�߂�Hü�|c'�X�5��\�/�g}8�Y�N������оj ���8(�����k�ϱ��V��&=;e-&5�d�=��,�9�޼��´@ֺ� -����D��hɷO�O\���(�r�"�3v��#["    �Wb_��}%�P�w��I�b:�Ϗ���$mĄ��ZG��Ds_QP^������c�Ŵ(� �v��j�B�la��q�f���g+��tW%�]��H���$$�=[�d��z��X�y%�,|�]��$ܼ��6�\����pO5�ta��}�����-D���гE�N6:����M�T1-���Zv4��l�_��spæ�̇[��,o�ޢ�+�0 Q�y �@$6x'���l��S�@��뿞��k~r%�=ݬ�������?�������a(�;Xt����^PdsAYe>�@Z@d�2����b��O��2`@1�5NZ����I��8e�j��\����؄6[}�|�	�b�5 �*/e����ԺyE�tE$NȻ��R8�EoVD,2�l᧫?(�^sd���e�Ul�� ��%��S��l��|p��J]��r7���;��@���rf���esͺ�UI���k��
{���$Ӫ�Imqc�ǫ������*>/�U͊���t��a�@Vls!9�q�&�]�Ԑ���2B
���/�R�����b�Z��u����U�.w%��*�
��
_�vy��\�\��ȅ�f�w"-�=ʹk�g-Ōԅ�������
��fů$��'�h�;1����<�mŭT���x<��@�Į��]L9�{6R�
-l�%�SeM�{.�>��j�����b^%nx�
k򵯡�E���7���TI CQ�f�eM�XJ��#Le0YIXK�K�}���uN��ĺ�!����eI�xE�-�k&uk&�ê�<0*�szYL��ϳ��Bm"z�-�)ߙƠ��������̲H�1�Y$.8�&%Ūt��y��. Y������=6b8��ݝPc���H��2\g�cH]h%�a�ә5�XR���"1ż�L�f꜁�j`�k-�b��D�fsS��zUb�����T#��"Bao�uQ!���3�k(l�^��a�(��gE�Iם*�mk7%�~� X��l�2���
{�W%�hǑ��)�症�ӧ#@�
4
J( ��jt�-� 7x��W~q߇�*q�L�8<ǂ���r����&��N��)UR���i������[5��l�"�df�+�t�{zv�-A�0����"(��ԇez�7���o��(d�R�_�@q��E5��I�;q`)Z�ם�k(i+@tD3@`ϻ��H����ISN_�#�w*+0�69������`���tH7I���7����{o[-I�Uo_v1����7	H�	*X!�X�l�E�d��F_�o`\_�DG�	7{�uy6�]�(�%�}|��80��R*'vK���i��q��d`9Z]]��P�*�B���\kOjV��bO��?�C���%�,l�%�ˢ��X�e �M6yXԥ��ǉ�� �$�70� �U���b����\���mjyJ���7X�TvL) �����V������t�����{gEW`:R[c�D(콾�a�X� ϋ2��g����E�2{�76�߄*c��u?�~gW�s�+$���X��)YL��G���XX�M�`��5��]hV�n��L<z �*�C!�EU&@T�����돯E$��5h�Df�z��29-1H�N��R��
(��o�����In/֙l��$��ټI�@1�~��@�nK��H�t�$�y��Λ�U~RT<?�.Jυ]t!.ֽQ��ES~?��$@"�.l�l	��[��

����K~���^鳘�*/O�/y-ZA�8�t�vV����.�2����˖�C[��ʧ#U��a�E��Z�r}�p:d���u=�#�%L�2��,Ŵ��u���z@� ��]Y\�̺k56���2#T������)��ȵ�M���9tPH\t���gΗ�t]�\�	�&���p�7)8�� �������3�$9q8l/�E��;��g�`30'�l�fcOG�\��S���2H���ĻxOu��N��P4�Rü�� ����������P��(v]��h���"1)�ϧ�	'(��"�y�sd��d����O�1/<l����$0"���A�$섈��A�7��ݼ�a�	�Wf��و�+c���"&��E#�V���p��e�.&�oʤ�>��Ɣj��7Y~>�.$&27r�{��<��x���Esa�a���� ��b|~��P��u�␄�n�e�jM[hUz��X�����V7o���F�5�����m�u?�Մ�}��KIbr)��� ��Уq���	
[��U����Q�Wn���կWb�.�ܤ��A��jo��5a+��n��������\c�u\`��,�+@�(v&�(���3{%�͵~_9���`W|�����Io�3����^���r4-2?ǻ�$��%���� ���.�+�YY�/�P3u��N��U��>?}L���KW&�0����-���txnQz{��<H��Q���^�� _�E��2 {�9/0|iѶ��e�f�5��C����yj��L?���s�J�tګζ���[�p���)�`�����|7I�-��̕;o;�'���3��w�gj��LVX�
��.��J^$[�	n��H���p�^ګ&W������5�'s�&��\���29�^|�-�l��׍����%�O]5�MM>�D�2��;�Ǐ�e�@� ![���v���MfU��������=�|�f���R��Nb��s7��5�@�*灾� N|��7T�(�] r봿x�Db3�l鎺�b �C2�<���
�7 ���N���lٷ�˾X����������~:=������?�,?����gb�4ؚ2o)�纍�Ub� �<}:}?�[.rf�W2���U�s�a���T����.�S.��T8�T����_d%$> �.��"ڼ�M��ī�g�e#k ��uE�c�P��m̂5�b30�\1�_����P�n��f��wcS��)�!q1���� A�@H�i�Z����um��.�E�����˦4B	9.IS
���{�4˿���	^�ن	_7L�kX;��\9h*���Cȕ��.y��#�ɭ�¯֔[U�˂���-��sSn�B����E���B �U�DV�m����ӆs�Ҕ٢fPy�M�42P42C�F������C��:3�=�P5cI|����.�Qכ�H�D(쭥f�fu��YV0S��]�������e�ڿA�&,��,޴���(�����8U�K���	|�.�Γ�,"��2�"�Q����b�E�a�F�B�F]UM������{͠h�i�E�<�tu�8���E�rSu�M,��"p͊�������V��GE{e%����kY=�[�e<��6�� �)4�G5�_��_�\I�_���F9��f� ��d%�k�i��3%}��`fE㢰����,��`&'�B_p��H��9�2߄��\��2p7��b�E�Ձ5����ҧX+1��_fs�2��n�茕��U~�(�_�	������ҺO�V�/_�3��@�۔���ـ��-��Tq��M��6}Kt%����.
g�҂�v° ��_d0�+u��� Cd�*���@v�f�er�A5T_n\�)��ħ�Mi��!e�K~1��m�_<�	�w ���~����%$� 
�ͳ���a����e�(���,J�Ey
�D�F�[X_�5��Y�g^i�7e��L=�˪�v�z�eF^�@h\�l;�w���f�n�\�f^1���֓�.+_�̑@	Yܢ�@@a-��,��_\}9ge�w�MfQ��@y��+9F,`�'���6yz�[,����KҲ����8�y�����ؑ�PAC�nd�}h7��VU�����f�{������~��Ǔo,���°E�>4���bh�Ӹ����C��h�I\6�}2����O�d2��u%c�J"'��������\lT��,L�ac'a�)6x�u�>�v��V �#><Àݺ�LV�)�zz~:�TA�:u�Ti��"K*�c纄������%��s��k=�,&0��i�P2'��8o��%�e�>vrX 4  ���+���L���b��	���P�ۼ��᪰�q��� �����||.�-f��$%'Dg�F��-$�.,�w]�e���H�H/�u!1ʗ���`�;��E�:��s�Xm�m�F2q)aw0�B��^^�a �����m� �-fW=��?o���vÊ)��x�v�$]Y4N� $���3��y��$䒉�����)Hq���p��,gY��{���;�Z�g/����ik�)ꕸ,���W���"� ��n�KA�Y��P�LC�h���^�4�L$=W�ò�	�=��P��L�@�Y��P���Uы�/[�zr��+��W%�wE�/_�2Ej�= a5����;궥��Xf���-������Of0�'5t��ڳUǡ�:�Y��/:(ͷ����������OB�X�l:�,�
�`	5��}g=0[���*�z $&��e�*�$�`PIqM�P~�K�q�-�zK٫���Bs?b�b�&_��K��\����R����N�n�9=>����>�ܒcl�d':�S�F�8D�#}>���(Ճ������_?��[z$!��Dǘ�h�?��7�a�d���PH|��h�!�b�`l�nP��K){i��i��d�=���g��!
XvL�,P�b�P��w~��B2�ag�I���I&Rk�=�H� <���ا��RC���iά�ͳ�F 2\����O�ɐ5[�äߒ��`��X�Ǳ\My�<O�Ѳ��ޓx��?&�?]� �#�����Zv����C��F`9�@���C(r�����ڿ���_���&�      n      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��k�$G�\	>�_�X��ݽ�� �Df1/U��������R���~�����T�y¢V�"]�d Oj��]��J�u���P������r���]�H�X�5�{�a:�zM|��tp������Ya�rFY-G�����r�M����� �~,GU[���Z����+Z\[�=�ך�W��r��
�>wɖ�YC�����G�Z�/��anh)!bZ7Բ����5d:[\�����1W�U<:�!�d����>�^�H\E�$��g�YhP��@98/͆{b��P9�q��L<�m�# �uf;���������j��������A���"V�#��	�|k�>�ZqC��g�f*UZ�ǹp��4}?�3}W݀%?��V�����0xֲi$jo��"60�sM|B'�>���.�;���	?�1�׏�_����EjxM�L%�6Vicr[G�4�q�zY��~�� L�g5Q���b��؛�r� 	�|�'���zl�--�m2��6�R3t��!F��}&�Ź������.�����L=��r�k��b�;�쀔.����$ᐔ�ʑ�h�0�H\��5�c{c���R�a�%4�1��&�)a#˷-��B&�'L���ϳ��j{��,�}�Ǝ��Iw ��x�yö�3�'{�y-]j��g��s��`�t�fm��\80[��t�M�� ��[[m�[G��C��lO��̑��ZHζ�&Ѳ�����niNCt�@ؑ�<�}������La���^p۳�M% �������O_�h[L���[�����yȲ��h�f�^N���"N����[��#L�p`��=���$ W�Z�!%�⃲7;%��wg�--M5#-r��6!�y�c���a�\4�<�裰촚/�oJ= ����1�Q�؋�l����w�S�ݖ ��H�fdX���TwD�[��������S ����ژ��hQ����e�7l�1�����ܷ������Gg^a�dw������7�v���`'�vW~�o�n@:^gO������VKpB��l���ԙ�M�Ksɮ��4����_.��34wA�?��~#澹[�K�晓$b�0�"��E��xz;�������2��,���Y�@H���&׊q����)/�H9'�[� C��m�d o�MZ�e�`��{�<����RA-A����m:����GR��qe�࣊� ����g^e���!2'z��h�Gi#z�Xޯ&f[�e[�]�ZiH��?Bgh��Җ68f��m�(t`��E�u�a����e;����p���v�+դf��f�ě��*�r���,�J�V-��M��\�]A�}z�����?��t��A/@_?f�~:����|��z��f�K���Ĭh��U�a�[�3T�ب���P9kud�D�v�Um���xo����_�������)%��0��ͪv+x�?��g��Y?�i�|���Q�x�'��q�"���;+l��[`3Z":�87f$Ϻ���/�o���%`���#�o���6¾VC�3OSk�;�^/�a��Ħ� {ǚ��TC���ܰqg���)k���^|���6߈����iL�Q4��hI�f�[��4�L;Q�8�'�$�`�iW��`S%������%%z
l�I��$�XRk�h�6io��(�Q*n��?W�����z�0'�K�fb7tFp�G�����1��Ӈʎ,��7�.*A��DU٨G�#y �C\U�N�J����G9e��ò���`�`�׿"X��� O��~??�'m����L�-_AM��2~���?��kWV��z-���OKJ�j���J@�S��Y'W_�cy�~s�?=>�7�q�4ȝ��G �s�T��'�X������E9Eh1Rc1R'(��۳U�;��@��}�|���.�.�Ћ|�y�\������ʛD���I���l��8@k;I�Z��?��KB4��_�X����,����,��q#'��7�q?mVhW�r�b�W�2��i�?���V)���rP���j�TT�o����������e�!.AH�c�~���2񲖠�_�%    ��>s��Bt|������q~? f��P�<˭�"�Ⱥo�OO��N�R��a���� ��KU�p�)�A滘�9���=��xl7w����ݻY�����E�0��hUȤ��R�o����0�/��ki�Og�0��erus�c�ݱӄ�;���w�2�����i<���=LGt�A{��@������~,���q�O���C2��ʪ���ݤ�Hҭ-��8�r>`��0Oճd��kX���q�)봫����k���
�貴k�\M�i	�<K�a���:���8����v]��E;O�d��:'E��H�9�8���C�=#��_@1"���
���@.�eiM]��rk��IK������P����}�-t��@ȩ�����!Yyzփ�bY�x#�v8��iX͍M��,y��a��?�$���Tp˲!.�pĝ�4yB�#7�\�%`A~x<�ڞ^'�'�:>�=����1�d'�y�n�H4�����X��xS������n��27o�˛^�q�;����C$Xt���<��ra�$�	c>-����Ktcy{z�W�2t"FdTa�̀�<�s��r/	,�� ��{������r|���bN������QY`ް`+dP����-�����܉.
d]D�#�L�.3#�E���Ik>�0������*�#���m$��i����V��HZ����0k��h�f�~�������$��<�=쫏����U���������!:�����|��u�\J0V|�1r�|,���ʢ�Q�s�7uj�1�ܡ�6A��U�e/�J��H,�fI+��hE�U*b�l�G��U6�U&2�A�XJ+�뭼I �4����D�%������=g��z��`h���Z�>��m͛�&S����|��r}�Ow�?}x���׿��Mq���b@�-�i!�}�����>�c�rhUyp#��;�p)�JZ�����������Yʙ�Fi�X�8�Z�m����	�6�!��m\J�/w3O��{�8[�v9�����_�n#"��/-h����I[� ^�+��m_jĔc'+c��n���=�WS�s���]�N�F�A�v����'�P�\@��y;N�	�h��yְ�??�~�U�4t-V�9c�sG����8a,�D��	9�4ݠ��3�� },|x�EЈʀ��1��K�B�rDb6o�s=�) j���Ϲ/
͈^�N��������u��Q~$O��Jʉ���u�H�3�q,yw�V!wt���;-d��ߞ�A5���ɶ�3\��ߘ�M���rzy~���}||z8˝6��D�d9�k��.e�M�yWx�ⶋ�}��v���HCLt-�	K����Īzs���)�O�o@?�2�n�[ϟ���.O���n�^c�̛>ff6z�Ο��L���2��8��Hn2�1�!�r���//�FG&Z7�0�a��uޡ��XZ��3��~��~��|�&0h��.�(��ԍ�1k}.��@�1�0C��D�.� �>CD�S���M��v��ty|��q��7M\ cǶ����	�f�X����`"*0��Jy�RnO��hi� w�N�i�x��8*�G�`ĵϐ�\}���@�@��/E5�-�RĂB%����P��D����:}���=��+�0�w"���(1���:1̛o� �Z�9[r�;o��j�����[*�Zl��s��/݋����#"��#@��H���:`��h�#B_��I�9� �':B�ʸ3T��Дc�4���֓!^��6 w�ûus�k"N��"y2�M�1�p�ʭ�����֓������Z=��"�?P/�*��^�r���[��n;z��"��>~�a"n��bx^-|�戨��y���V�:�r�C^$2�ۂ�9�dƪn?�+4���.fef[��y� 
����#�n�V��;��	q
4�BN�i���'@Ve_���v���� ��?�ցb�iil�N���Y�r n:�0�A��d��	��^���J��-������NFK�E�C0�vtj�#F�=�"W��:��LĈ����ȑ	|����/�7|�8�3��΋�`Y�%p�^B
ݙ�@���
rD�~l�����S��S4K�0ݛ�p� &�%���	��!�m����"�2���n0��8��[_�T�O�����!.���y6�
���n��������-C7��e��1�\��W����H�XA���oN���`A����ﴤ���=��ױ���4W������Y �0үo�|�IY?��D��,�1S��w
��L~%��)�F�XT�h�8�Z�VdjJc�xT?��ܺ5�7H�V�m"�q�XE�^H������ I�A�E�6w���o��$d�D/ ۱U^'�Aȋ��R�o��=y��й[�Id�9(͠U�}�y���"��`�s��U����q�3J1�@���pzR�"��RЈy�a�a��b��d�a��΍>�i[]'�Y�|W�[7Q�N U7�����p�K��QGlS-go�}ģՄ�\�x![�}
"�V:	+��)�>��W�<U��b\�BVa=}{ҘaX�D���79fķP1;e�b�0���q�Х�!���V��Ё�U���y#/P��q�����͊z��"H{L��B���Nt��*4�<u<w6irǴ����!>ߟ�%bh�R=��GS�o�<Sa4���{�,!�J�)��6�[�Y8b��I|��׉�Z7,��iS|���̖��һW��ϵ��J��t;�bɣ��x1�3_ �q�u��2���W�D���Yk�M�;��w���K��붂z��nߢ���δ���>���R
}�&��s[���Z'$l��cW,;�2��	Zt[K��"w�,�F�k\'���`�WU�-�Q��elY�weS{�v"�&UQM�-�#���v��:TFljtܦ}v�f�p�z A�*p�T��7����=����ʷ�ϬU�N�6�ų�f�'m��Q�71E����j>Q����r���ܟ����.�4B�Y`����נv�[�Ӝ��o�i��I�.�?�Tq�*��(H�K@�W�8���~�(��c��AV��Q�y+���^��d���)��e���W�dh�3��w�`��{����ef��svҬ���h�^i�0"� ��g��.j.�"��R^��>&���{%�4(&��k�ȷ[e�p�P��d�����"�]�<���8
����<�=E�j��zn�;�V`^'��Q����I�P����鵘���s+�`f4���?]�̆�k�fjB��T��kĖ�>��4I�Tβ�j!����*��좻}V^�%�~��0/�H;ti!O��Dl�t��m#��A���	{>�� Q��u����ETl�a�]p���E9��&v�*�g>P/Z�}J�Z�õ�2�U!O@A�n{�KĐ^�L�6�W������
1-4�N��鎊�R�Q(j����Six����C*��<��0�^ؾ�{�c1w�Z�z�Sm��Sy{��'�Kc��]��Nx�;3��I�B֛|֨���gS���b��n�����Kr�3[?8}�Gtfj���(/.�hH��&2{a}�T�"EkEݩ��@��k��Yy�r���󯠬C̔��������	��sF�L��&3tid��Ġ�5�E�)!�zh�I���I^�Iğ�h������}$`������U3�������|w����0B���e��1�*b��U�=�А!�1�a�)�j����Yek��~'dv+�����M�|�rVH�d�h=䛫7������zztmOZ~}R�|HHf����I��g�@5ʹ�*g���Rp�ݹ�42���5	���^|,ȶx跓"Q����p�����5Tj��4UN��dx��r�#J���wR�;P�{�����wi�Z����bOl�A"&u�97N�_��a�ͩ�r>�ı1.�O%��E��gr�I ���T'��,?�UR�d'�!зMS�u�u���Pk(����ֳ̜T����    �������	���f����J�L�p֯
��@��R˫�J�P�M��vȠo�cs~]FV~=��y����)�p�ظVA��	��Vwt��Ә��$��12-���Er�YH�b8-�7���T�cH\�Q��6��5��CRΡERO7��&�q_j�n�J�%ȕF�0Сs�!�(�ј3���"v+o �z�koџ�<�>(�C���#����T��lQ��.�(wI�z�����,G� 5N�7�"�u�vΒ[=���.rK��DNG
�C�i�@�ل�O��e��kO�+�[����p�]B��Ƕ�'�����!/�R�g�.+YjcaV�Y��_��j6������)��ט�X�_tl��kc���5�y�N<ca��؁辔���oE���I 	��m$�� C3I~�6yK�A�9`�7�vv�O�cy�3���#�W��#L��"W&�;=�KQR�o�8,�PgD;�F2�zzt�`=7�?���_�!C�q�Ŗ����`���I86S�-r��>��[Z����*A��5�����+Y��?:�����_94\g�O/`2&��j8��<=�����������b��W=1�y\�>�I���|���I�_:>��-��{�~e�w*������C~>����$1N�K�}�"��ƣ_��Wɪ�)��������^#�\&�i�� ��t��|�ڵ��\�����)/�9�����<�2sza+�~>?=�åRj�Z��Yx�yG��U�s����6�/�!O�YHMe��rsY��l���XT�ٖ�z�-!�?�}���`@��۸��(zJ\�h�ۯ[��*�l�=��b������F�c�����U�d�H���s�N�>o���-dk1>
�����j�E#��.����둝��|up�8�����6�V=ppg�l�S�QN���T�)�F	O����6CS~��	Ǌ\��Sd�k?=�'�!2��=��y �O�w�wA��.׃7Y?�`	��^�����9�"L/o����ܪ�W������������i�]�"��_�����f �h��ZQZ����Έ�ްi�CY!k�YWA�z]�����(�C��#77�8��W�p�R���j�ߧ�����{�?v��dY�w�(9���0\r�X�bGX���5��c�릐���ؚN.> k4\Se���egz��-$�0Qj�������&B�9W��Ii˵�Q�y!��	M������M��	2}z|��[
p|¯�isd��Og��Y�LBă�E)؈q�z. 2q�n���+�^�D&�A��U�6Zp���e����d�7:�'ACOO��ӭ��ja�l�p�_�T��֧sᨒ�a���)/���3��Q� �Z9E��916F����e�&�����7j7�ͬ��I6q_�B���A�C7A���疮��f´��kDM�:3�I@�7or>9���p���r�bS	qL�a�x���'[E�x��:�9;ȴ`Rٍ��pi/٢� �T��l�]��(,9H�`��f;�.�!wlF�
��\��^;�A��6|�;\��A��@ĸ�Fa��,u�6P������?]�*��(���wX�]!t����v��^�-�����9�tҜ "̃���,En��3ɘ_�y~|�&i"d�1Q��p�|t'+�)z1�[>ق����D���
����DE�"���W��sM���R\̞�dԍ)9�Ll�y��ZgS��`�?@�?@��� ��c��;��h/��Q^UC��&�B����AEU{T���ǳX��I1�:��db=����A�hؾW:S��Oj{�A�h(3�cS{d�Z0���m� �sC�Vj�������&�!����`�-�u�.Ʌ�^$�}��:H.aR;<�&<�[
��.��"�Ǫ3�Ph�ǯ~��i��%L5v�c��4_�*�	�
�r������2�m�� ��I\�׏_0���pU#���{��ȡo�ǻ�m)� �(_\�����/?�r�6k�>Q�����^�0��KdS'��rg������{�~S`��O�.��� w���a�9�Ňu��s/�u�~����u� �!Q��DQ�]������fF�鎧��Dͺ��?���eK�A
3��:��	�ט���*�ݙ���S����G�)!χ�<�y0����B��raUiHد�?��|;$�2�_s��gF�����"�$��B����E]r���pA�U��]:.�N4B26@/&��\�����Yh� eM�g���!M6��(���m�0�6�Xn��E�:7�b����c�4�_��G��A�����}oۺ��G��am�
�`���N��6U%���fi�a\:��F�G��<���nv�r]�A�+�y��Υ3�^L��6#�Ցr,W���u�ݗo'U܁�;fqBG����a͡���9�"��.p��UO�Pة�L�^�AG�@�\�B��V"NT��{u_��A�:H�`/��٬�m��}�ɡI���:ꀃx�'6~��=A;�񨋃�a� ���*f1fX�<�&���||��!_,`�gߙ%{�ڥfذ�[Y;1Z���Z�t���,A(� �W4�Z�����7���P�Iz�����o�R��Q��]����D��۠/P�e'��:���H�>�[ݷa�X^�؏#��HUM�|Lvj";�[l=���Ѭa6N�-�O�Q-i;�jd�(��A9���㪂�i:���M?CB�G����s���҄�K{�[��,7�JFv���]>�d-M��;�?VT��r�OW���sfi�X"�D��͚����m/m!P1��k�����E�v�Ě6�;>���tio�Y�.3׊��׏m�6��.�/��!�۩yoe` 7j�T�!i�9W�4�F�m'Q>��5ը)��	�����=�����q�� #�a'���A���+dg d[�%C�a�g�X/���,��n�b)kߘ/���r�@�W:ȸb�m��`X㭀�M����(�Y���Fx��']�Asr��e���#�a�N�%jq�/z����okM��h�w,d�
;!S>�)/B�ڗ�F�NO�O
1�sF���_kjn���?P��a�D�*�;(�,���fs��Ú�bpC'qi�Y�dP�&;>t����"�7䈱���]g��G�A��z��1&E��Ѧ	J�b�X�4�F�8���נ�b���ִ>�/��~A�jЅ}/6��Z�^^`/N.���A�1kD%�6��㛄���m`�]�Ad������ʗ�������u�^��fh��CbŰrui���h�tz�-}�Rb�H�Gv��t"��J���y��z�� �)�ABk�Pc�r��l�l��6Tn�J�2dʰ�1ѹ�7�^���媝��>:�h�|��U�|�@��x��x� ��Qj��z.��f�C
9��r~���HLg�4#S�6١�.$�����1c�{v�z��^� d�i���N�Gl	?nЁ.F�
t~�"����y�<���z�S�]!��0�t��N�|}y|R�M7�������z$f?��B\nD�>�E��Z�>�v���[�
��PL+%Wg��0;+���c�����\��4b�6�S����t�xT̞��1:?��<����Em9�
c9+L,��#���*��P\��esVzK�Нs�������U��a�E�}M^����"ys�d�r�z�7	��/�G�W�34$H�� -c����r�6my���橒u�������?����+��)�F����-ͭHt����H䋊��>�S�-L=}�pRfR�XNiC*2X]"L��DbbJ��-��~���o!���46�_��p�F�J?L&����"�P�����ށ�M�nYGכ�v5�S�6{\'�Dc�>���6��L�4��R�F��3�Aؼ1�aw�×K;�p	�t�(��F��~�<wDD��;K�4x��j_?��92%X߸�\�El�Ӎ�'�4��k�tu��!�������h����!Z��D��o�i�R�X?����5<�:p�:���    ^L���_tR�Yo���D//g��9�|đV�����V��j�+d��Fᆐ�64�:d�b�^�9]Qk�0��^Hz��g�'���aN�ŕ�t� N�@�AzM�9v��YK�{Z��	`�cǌ��{Y�l�p[=8Q�m4�-6��)�b�m%â�FC� �'�z��d�M�v�`�c܂-4�4�lx��N��:H�a�0�m��(
;jAw�Z�\�`'1 �
���Ah�h��A��a�R�����C/�\�|�jܩ]'��e��,�8|w9��k!�1�n��D��O}��<�Kg��A��l{:��{�9�r��xݶfщ������"���%�جgk�N���C���Mϳ��64!�e�,�찠�萸��
��&���,�� �Q�yp����(���h�S�c������z����=���*A��=N��x���^c�(Dw��;�
I�)���q���Z;<\��Qj� L�ԟ�ksԨ�0Q�y��ׯOr=�C�E�.���D�������t�x����������n6H����uwǦ��'EL�oj}:=]	��|	6���n[maB���v�q]>�6��$���(}�x����+`]��tt_�}��~�C>�gL��Gj���QZu�!�+�1����rR�O0��MD��	��˔��/�
��&� WNĮa|zR7�<�p��q�]���q��$My\�������Iv;=$���q�ybo4`JGkZd���\��g�^��6
���h�w�T�	��s$�˰�� ��A�d���zuW������I��G{(eݝu��mz����/RА˦Ƴ,�<q������`�@y�~���U&N��'1��!�M��H�羁C�!�i���+����|�Et��lj�F�6tE��e����M�.x��y�P���R��^fHEb��ڥ��n&_8CX�<�o����aՀO0�'���Ґ�!1;5lU?���|;_3�'%ih�Rc놗o�>>߉3
��a<;LY�oZ�C�Ԇ��NU�J�ʭ�ő�]ݠͪ��w�-��Z��Ï֘�IaO;��Ot-ɤ�>֜t:�������Ԕ�bO�og-s{8?H18W.I��D��0M2���u��̒'�~�VBIs[9����Kí���{`�2��澿�u�I,'HX�Q�QUZP�'bX\��/Ti��o�~N�3a�����*t+���X�A萶��mA}�"}܇���w�9�R�Qz2��^uy�CVu��-�r��V�p�����n8�j��ȣ	n��Qȡ;4q_i��~�����C����c��]�J��`��mu�vN�ǰQ�_����r�S�\E
8�3�P٦���M�dǃ��f�%�l���%�1v��#���8�?<�ZO1�˪����J2去L�Դ/\�?h݀���wy�e�Pz܇�{��%�[���taK�_N��@7��z�m�� ��!��t�4��;��p��<��!˒����}�K���Nw6C�t�VB�7�q��o���YFIᏊΣo�e����ё�!�H�[o|�<ݔ������Kt�c��E�cv�==E '�&��;�� �S��S6&��jg����v�|l���r����CC��2һ�WS���ݪH��5�f���r�Tv�29aMz�mKs8Ku�~�+�ܐ�qR���f�ud5i�w4�ur
���ן�E��Qvi ��Fڷ/�d��ZI������Z^����r6���sAg�Gb+.�Q^{y���n6}��f�<�{���%g^4�1���󮵂��׈�ڼ͝>��!�����M�!�2z�ۥi=��,9�~#�U�RzH妶��c���);�JELY�n�p����w	Y<75��k(K���M%��Anns�Ȣ����Y)	t�F��NE�w�����$��%*��hj5}��.$�qfR�n$��Q-�"���Մ��q�p}��oo��@)ZF^��:`�?B����Q�xH)�(tbp �z��4�)�&�/�m�V��{�rT��)	؃��6̿*lm�I�ܦ_/j��C& 7���i�����ÐCP�
Mb���_%����:�4F:�NA�m#}8��֑G��tY�w{�L��!�3��:߶̀��sn�	��������,���Կ��?ѽGmG���f��i>d��$ ��"��:
�6���.��HI�"r� �-��d�p��KQi�ꅷc	�z�M��콜$���,6�D�V����
�7�K8�L�����J؋u���!�a�3�1?��A�vCg��&걌`[��Tq��g����ۥ[i�gM��!���M���B��<14����f�w���G�@)gd.~s��Zk8^9���9���:���:���4C����\�\��U����_�8�1=H�=@�j�;9n\A����m��N�L��|*ζ�{e��7�fT#dR����E;rH����8G���+b��5����6��&+��ep}�A�yY{�@\�[�*�Vu�P�|���ޟE����F��Y�(��&$�S���{ϝ��)�c��&0J���1>��]�yȒ�l��]�ʷj%��ī�-�|��*�"r�-���wߕ&C�V�=E�u�c�,�u֨Y�@[�(��#Q�F�����v�=�
X�mM{��A!�<εA�%��� ob��Z@s+�ɭ=�{�gț⬌�2��*['��9}D��史�Y�V��COH�!�s"0Z�K��]ޞ�Kټ��a?�^�Fy�̂t���m5i�����+z�bIT(G�>�!qN��x/���#cgU.QMl+|8]�^����p���{�@�.�U�V�*�O��� ��h ��46\۶=h�4��t�N�F���1�#}ז�]�~ف��-!B��6ӥ���NE#���5�����~ 0
���r�13f��L 0�=s�	�R���#��3�Qdm�i�p�j;=ɫ�R�9��!s����8-)�ul��+v��$jp��:1�G�7���E/�H�>�X����о�����ȸ�ξy y��K�2?}~����34�)o�MĈ}�����:f�!��� ڙ0 �6��zlfJ �̯֞��M��o�	�0���ie!�~������Yǥ�0��M����
n�� oRn� Q/l����� k��"&M��ť-/b�Ț��MolT���5�y�� Ջ��Q�<�8ˍ���fW��ztr�����ˌ�&��_�K\�\۾>_}Z;�	�Y�NAB�QC��r��|����
�H��DH�0��"�]:��[Iw������|��L�*g�J�p���&􈹨;�\�G/34k֪_�cQع�$.��pY��4����oxƇ��^ ��c���<<��v'!w���{<Q}�QN)�q?@�y�N{^�͐���Rђ����{.�z���w�o�2�UHP?��4�a��y[9�n��wQ�>qJ���tC ̉� J�0�M���[pI����I4�h�@�F�M�e�!�M�A�?*ۭ��bN��Go����r ����������ѝ�
��NKc� �]\l�`n^�V���y�}V�V��l&���� ��\lc��+xp�0bC�A��uUd7�NO_t��R�h�N�՟�/Dt*����m�}G���闳,�H��b[;eL$A�lm���+�t��ߤVCcc�p�n�6�*`#[�$a6��v`h98W�l��*�δ���s"������s�<�E�<E���=��y�y���Z�A�rS�xx�B�Ag�!ăz��9݊�x��>S��Jx� C���F����&H�M�&H���XX�ٷׯ��R ��`�y�H���+�31��vwQ����K�L:�3鐸�ʓ�~w��M��R�W��_O/r�6@*ǩt��(D���y���+��kl��N�ނ�ag��*m:��{�j�ʃ߫�V�"�*?������I�D�9-����4oܗr�G��*�>ʍ C�^H/)��� ����m�%�A��u�8@���<X@�Wf    �-�ER�g���KuF&��塜�i@�M|77�a2Y�-#��N���J*8ʯa;��k����!끛{� C:�����Ż,��X~�Xg9�*�/���f����+}��:,Z�D(mb��F��YR�H��fa�̈́!�A��d�v�:M/�Y�S��T!LV8i��.�ӰzLG����|�'��0���W�X`T�dTڙe<�z5`�%���+;M��)�� 5��[S�o\0dv��@E�C�'t��	� �^��8r��tr�\�D��x��A�%ip�)@�(7�ـ���K}��4%K'�fm�h����%��l%�.�V��B��Ennޣ��CE<U<*� ��9�KbJ��⬟��qgE���LC�!�Lwĕb�Q�jH��`��nfd���3��g0#����lF^.'Iw �[���ܕ�H"^��x��o�5^��O��|턱x�#��+�[�niz�!y�5����";�E����u��m-�Q�&F���a7���ݬy_��=�MMSj����a�-���s �"����6R�K�r F�}�Q�����Jxp���X�x����p�t��a�4q��}-�����:{��Û9���j���-M�1|���8�;X�.�zG�m#��=r�����i��U!�"�D����aX�C7�dqKk+Fi��}��;��M3k��� ���"=���ll���6Jڑ�����׳�6 �Uf�o�}�"5G~l�%f��גuTI:�����SLo=�:�j�Q�w������*QC2%�Hԃ����z���Ny�@*��������ې�O��k��xz$iA�Y>����R?���9�S㾻3ok���=U]�k�Y�v4z�쵟���xu)�x�d�dZ �w��ZC�?����m�����4��&����/|z}�ʍ|��_����}����8J����Q��c�i C	oZ_c��}�����=�HI��s���8)��c���}8���#U����\|�vұ��lP$��/��#?m����
��.��+-��h�0��S��;>����������lȬ�h��o���up�t�xV����d&rGe�!	�7m�:��K�z��q"ʻ��c���!��ȸ�M�a�����a6=OJ�:�=(��|~�Wc�fȇ�J�P+l�����ڍ�rX�a����������A�'`w�EZ*?�G,xU���e����/秇�ApO��=���glB�у&dcI$'�����F��"4,5��Y s�7m
։Az���9�ݽ"eu!�>f>�}wyQ�k�F���X[y�G�^��$ey��jׇ����F���M|G=��+L#6�,���|X�jq�~/�<HK�M����͐q�h�h�8�Z>6�me��ˁc�;���e��t���3�YnH�녙}���ן�Ãɖi�-b��qǭ��A�mӪ=���N�x����8�$��>!�R��;��.��(���5�{�ٶ-��:^��4Q,+�׊�οH���8޶��ǼoFܱ�X�e}_�!I��F�=��7:V	7��9���_׵_p@zo[��z)m?S٧�;��͑�K@��U�/Ϻ8y���3����9V���i��FqPg&���o��o�u�Qy��f�:O�IwX�������:��#��,9r��k���P��k5:�3�U��P��+0|0��T?yZ��64���C�)�{r���?�>�~Uk 24x��p����	�����Gҁ��P$)<�<X2-&9����|������(�y�&���	N�x����6��[V��*	%F��'�U�YyNdu�Ks�������y��GPJb��j/�?k�� YG<g!���-}a'"���\_���*Yۉy�_OW��~C2 �ɀ�`K����	�JM
�͋�n��t�?j+!s���&�e��ooÑ)��� P�R��y��f|!��w�L=Z�ܱڎV�նk>V=��j���x��C���սl���]�3�(�]��w ���5"���pz�S�'���}��Ó�>��+�����U��鸝�Y�Q�#ʻ֭ӊ������0��k;����5*]�o\#yʑ�|�O�Y�eeV�������T�Rzxߘ�<p1TdZ�t�D{j�)�D�/o��5$��޷�;'vs��ુP�=;1����U�	�xZUv�D�3��֘� @�M-2�����?�@���Ϸ�/��Q훖�MV�z:q��3h�� �u�o,t�m��^�5jU�3�
[a��-ȋ��\g`�@5�A�q�i�S��fI����|����w�Fa�;��rny?!f:-0�#;����g*M���Ey���EoqY�"��G���af[}���R�#�p���u��z��hY�8B��?W�S8�+����|h=�(�"�V;*�[	tam��_+��HA⃴�i8�8���r6 ���p�vyb�<s>X�x�^���7>�f����KW2O_��>"$N�A�?�Xu�u|��F��@��=�{�Gvd��A���=��t'~&rP���d.e8O
:��8���6)�zU�V�@�����Cf+D��7?�<3R�<@�#~Uy
$��u+������N��ة0)�!,�ޕ8���G|����Ӑ�"�ͽ�b%�D���fS ���2�l��qX�i�TJ�q�G�f��u��>��#5W�r<���&��6h]����1���󋢧�	ȇ&���yˌ�"gd{Е�Q@n6�N�?F���Sr�q��T�����,0H�sz\T*!������S��TA��F����rY�rd�(
3�i�����1=��{ӎ��X�����r����ؖ��4H��a	[��^��/�����G�����q��o�P�+��	���#��D���r�%.���F$QAl�SyK�`@E@Mg8jh*݌���b��ِ��
�Upv�����o�`C�ۆ\��z�<I��!�(O��sῡN���w��ܸƅ2�1Ů��p r��#�+/~��2�v?��j��/>��i��C,��>�G��'�V^��9_[,%�R��Ԙ;��Z�7�/�4���|H���.�TR�2t/�u/�,��y|�x~z?k���kJ�������.�����t�m\��)I�Sђ~��*�����;��x��y���$��\y�d�#8�Y��Y��K�����y�|�V1�$��U�a�kn�r.3,r��lv�����gb�j�+Ls���s�odۙ��<��p���� {�aH���0���
�>��c
E��8;��G������,c���o��(Bz?7>��yy\m\��Ͳ��Y��^�~�XsHm��V�󌪯��F{�~�-��;����#����w�#d<�s�У�r�cd��y��;�?#̐˧6�yɹ�yP�sŎ��,네:�+D}8���i4���'��,J݋�Q�n+���\2�Z�
���L>��m��*�"�����n	å��BG_�v=�.O�%��*�EHG�g1Q���ڙ�ǳXY�V�ݢ�M�t緧G��B�4?7>�N�;]�U��fB��F�t���(2@�&?�df��|@I�AN��X�t����"dJ�0,�����~W�len��"��9���1�C͢��(f�ܟ�[�~��i�����z����z�{|�!�_���.S���E��|	T#6����⮈ViQ(�V�[���^�
��r�S�MX�ZhĤ6P���RH��h��(3�ڄ�;���k|h�h���F9S���c�&�:�*��W�g���}�gFb���}6# )2Ɓ[t�t�v����ՐsQa�?��]NO/2F�<R��H�e�ݏ��A+�<R@�z�=��cА��3��"�	��$���|6��]��s@��@�)N�I�<#*��6�Vyu7�6m�:{���+�/�O3�O������A���Ss& @F�0L�#t=��N]�h���7��j��5Qfo���S�Xz{�z#�E�q;Q�"N9����F�&���B}.��h#���1�JO��_�m�6aj�Ǯ��D7r.�m��P��    �|������)�u���-��I�:M [%eKW\�M��/��|�0aj�\JcE��sr+��m6lg�I���Hp�^�=�Q���#=��w& GZMt�`\�:m2��3��svlu��9t�����xЎ���X��̀6�46����{b&�AEy]��3Vr��#�_�y���C�Ws& ��~@�w�"$2
�t�׀���ZF�[ʊ��w5��]�2�)))[~E�t��	#�
�,�<��^��3�B�y�@��s�����d���$L"އ�"���ܜ���}B��H��7��,�8��&z�F�;�?�������l������|�0`2m&nn#���ьІ�)ӝ{Yx������D�R�`����A���{����X�X?��=����F�-����Y�m�Q��CVpሿ�>in��k�i!-��5��~\; ��t;��C:�ٯ��������Gx�ʔ����D��~��@�L��#agi�Ǳێ��+S�0�n��>�#�f3�����9a�*C[z�Vb�q�u��K�q�SL͙b&����>�r5+H"XQO��d�;V���JN�z�O�;%z�=m�=]oqq <��Z�/�y�X��&���F�VD���
��� ���RO��y���@����a�Gr׮�������N�v�Jm�Ji�bw�X��|���"�w
V�7��(�-K�v7�}����LuuFb���
ך:K�?~��u��#��fal�_O_>!�зZ�[��4�>Ta��m�#�4���J��A��AE3ܗ\���Օ�
Ƈ>�8�4ׄ�K��nT%������+�I�f&�ƣ.���� ��L��IuT#%r{�tzQ�Bȫ�4�c�E���S}Ӆ���<���oy�<;І�$BJ��ZC�W{G%�X7���	�Dk~��*��'!�0^�7�MZ*��
T��&?�+�*�|��|ap}���s�@1'(�`و����0�rmde�vSʷ�X8ϙ�E!n#w`���/z9�&��5���B��C����=��{x�*���$���GxT��9O�1�=QC��S&�6��sq�9Y�E�ڡ*m:�/�[�P��ָ"�<�)��i|�o|�����ֆ0�r&��ye����g�h�I�2�Eu��;�k��4�l�(�t��m?�nO%F�p� ��"d�	^����,�u�ʆ��:���f�F?OHw|�	\Ƹ�^V�v�������3��}V뛐� ��ao����|G����* �Gz6����(%d�Q(G�&ZV�ۿT��(H<�2��?	�et��پJ�"�,>��h<�&w&�z����f�Bm��Y
��Sl��|$d�	�M	ҸW�f���I����,;����Nտ!�S�m�7��+<s{��v�����rz���9Bh�>�ӻi��c�+Of�H���T��vP�MSi{m�����w0�M82ߐ|-�A��F�\�n������J'!������q�;�ى�돳��%4�/�!7��]�="�=J���B������'��חE.|�2�l�Q(۵ۨ�WaK̅Z}?�t��*u*uE��~P���^�"/n�v��!!;�B����y��^��#$���m���>�K�U�/��b0~��w�[	YgB.qfkwb�}���ΒԺ��6��<��Z�R�{��('�dD��`�1�~�dI��1�J!n��՞��o~�����c$Z(f=�<J���B�yؿ�;v��e��='&�LLƍ���ih��y�lL:,�d'��a�B�ڷ������Mл�y(c����s{v�|,O�l�^N�r$��C_.�O�@�D�5b���]�l��놠�����1W��5�[�Ч0"�9�X{R6r�FH٬#�Ab�&��A�o�����]� YN`d9Wؙ������k�;��E	�
��_d�=A.���P���)p�]�~�ip���*�����\h��LQ���g�u6���&vB� &H�R��i�FmV��^�o��jhW=�*�e\�Ui2�))D\	3�UX����<���9�Ɩ �S`�O��ݐ����1w.�C�L�J0n|�� D`,��=*�C���A�!�c�g�iY�](.��b��$� �]a�z9`�e�sw%�����o�8�
c�Z���#~�t�uP�`�TP���Z��'�&J�� $�{Ղ!o3�� {A�iKI!�~h;s)Z�F��0��0�27C��u�M �#�>]~�%�)����w�S\�Mr�����9@U�K�34���Ln��{��."Y�.�bv&�U
h��,�s߫,�5L�OێE��}*(_��Ԥ��;ο)�Ḛ��<u|ɁV����LIW���1�G�����Na�b^f����YČ�����̕�	�W�L�~������dX�$tc�Ak���d�'����0������0�O��<��� �C�ʓxj�o�'BM�l��������e�N�x�$b�����U)3�>
�����
Yf$*s��g��?��iȹ��g$����Q��6a��2ĕڀ�ʙ�� 襹��QC2��s" nPw"#B�T��)iIo��k�ai��0�Dj�fw/��f��"�D{�۽���� +O�� t��C���RI982:׺ǟ�h@�0���M�L7j3�h~M��@[����J��!,�3qn~~e?`r]�0�4~�/�����m�"��x�k] ū�Ϋ�uF���#>	R���-q���W������ʕ���~���Q�Y���:�y���ּ1߻D�a�A?h�#���˃�I�F(,��s� �٧t{�*a�;��U�<���bWL��+�M�{%�0=�L�-2�Wl�����,�弡R�ei.l�\�s��&j�ta_��|�t��{�0�X|k����qW+�ۯ"��u\Ȑ�),Ay��C�Sr �u��L-fh�E`�~�q?@c�,>2�~JTx��cd4v&��g5ǘ �C4��[�x	qi�V��s��	���1G����:�� yI�uΣ>�	+��Sr��N�V/���"��/�{�bM��"�6_��s(�ų��`�,�3����βUy���z3n2��D��1 r.�S��H��z��yPƓ��4^]�k���]����u�$������d�=��ĥ�挪��R6l���@f9N"컛���8��gq����7��_>��	�DӦ�t�]=��������o�������?x��$	��������Nk�ο'�x�&6Zr���Ƹ�t�4�a�� ����B;
[M���ˮ	$Ċ�k-t�!R��0D������֞p���ͫ|8?<J�(��SԹљf�����{�����my�U���&ѶyU��iX�9�5�)�j���'��n�G�f�3u#
^9X�������/��9/({�g�)�����������	a�iK��(�W� �<P��B���n{�V5Y!�N4�|]o��V�v#	���ݩl�Ϧ-�SG���mB�v�F`�r.'�%�_.�f�x?NM�?�?`2�6/�i��Xq�2@�t;���T�]�Gba�_f��SZ�&��*w�����4$R��&���vn'HZ��;4�%�S4��7?��IT�
s��B�I�>H�mk�r%ihY��v�z}6G|��.�6��}������U�p2xv�8������f���G���!�N�F��Ӂ��F�"�x�+�1ܳ�|������r˱
X̖]f.!��_�eX�5L�m��l��g�Ӗ����A��[�nta��/�Z����N�O��j��9Ѷ9�l:����4��о��~z����3
� �L��#�A�X�/OJ������K[���M�zaE91��hNu52�΀�c#�`�3�ج�cIO���Լ�<vz0�l�
������;#wz>}Sn�G����ڄK��;�R�C����!�쪝��aiԓ��� }O��t�4�WL$i5E[���+��r�wcٌ÷��˻	�D�(�u�!�^g�	y�a!�q)��$dq�![�.����>v�ӊB7n�������-$��n|n=d.�    �&�em)䫫����֞V�Hh]+�ۨ�,������Q�`{"�����'%hȈ9#R1�;WOg��-�nhSf�n�	s���ǚQ��'�CF���r���GF�-;n�b|[������B����ח�'��^�F����N�����M3��L����(!���y���!�z���f�t�?�Q�i"������ld���u*k����i���,[��1Y� =��س�)�9�"�"�7vE�#��Q1he	W!nH��O�n�YѵI�[n���`��8����&�7�h���G���̑=4cw>2t�6}ι�SF.3�2��Ӄn@�}���(�?:��33N��ҎDu�=������r*�ƟXȮ��k��o��9���e�Q�I<�ʭ���I(��^h�������)�WjL����Zd,�a6c� �i�ٴbZ�X���Q&S�~'��Q�у�w>u��+ޠ|Ha�de~Ӧn�� ��`!�`��eT���/
sb'e���/����ch��l�(�X�QO/�$�m�������R�R��&w�����f�${�!Z�!QZ�V ����F�W �N�e�
�ط�c�l1����S�^�A�=R������9������s+����#u}���B3����� <zlϮ�9+��M��<�"��x���uEߘ9?���d�ˠ
b��2��>=��J�!(�&���,?�q��� 5�	��t��0�m}+/Ə:���������j�~�jc���[��C#c��~N'��}��O��� �W�O18}y�qok�`Tۨ��Q��j@=m����N�,QS��M����e�(j̹8X�j�Eߡ 6��>����[_���)Iblâ�3��o#�Bc��S�A�\SK���gH����v�jl���]a[`G�W�o]�ߓ?��aL��.��7�Fw�c�Ձ=�*�	�H�	��Ɋ���xG�c��!P[ۿ���6m�?��C��QlB#�� d��+�g9�Q>���T#2������N@�]�̱���Dǥ� \��Y�G��~l�) ��__?��޿\�N_������ϯ���v�������B��(�+�[L,V�o�E�4C��n����H��(3�������fH�S�{���SE<I�@\��[}!��=O�d�k�@UsgHXScM��X�j���h�&� ���~}4�3$��I�Z�*��^�=TmX,��K�g]�ۼ?}�@���p4���+lۻ����� }n7�pEuɭ�=�գ˿|P)3d#���������������C�E%�kr۾D95᪛�m�1�N��;�T��Ȥ�p�뒪�<C����VcgU�En��ۑwb*B�b��1F��C:����5+6	l%��C�,�gQr�J�@K�2纑T73�@�I����"��e��)ch�_��
8�-�|�ԕ9�aS2����Ҧ�0��uN�y�p�*񵫜��"�����٭����sJ췡��g��\��\g��[Ft��	�.$҉�[�t�����]�RN���F�FC�p����!A�d�FC6S%^���'U-�!OA\7c�m7u�J!����)��RE2��{��3drjyѾ�R�.Jr��c��d�i0��9X9i�`?�|t�S�0۬Eb<�>��X���O��~z�ag�����":FH=D���JSYD����db��dw�{{�E������}^%c�ֽ>?݋|r�4Cq� �� ����6s����&N�A�;�\����!���U�I�|{}Ҫ)�bj0��a&{�n��5��)g9�V���#e���j�ΐ�'rҞ�_��ȺNtô��<���`a'��/�o:i�,T��\���&\�j�<�MsD\�f�&%�|r�	�W����$.�>�-p�;EL���Ɉ�4�.t�L(ʔ�� M����H/q^�����Ӿ0�y��' [1�Hoiss�c�f�;�&^QM���g_���U)5d>��P���꾍�̡rt"a6`�5.�{@O@5 �I\�Amܑ���Kf�9��z��� �� M"L��h㏈�j�2)�Ie�� ��@���o��S�pǧ���䉾z�)�Ys�!�E>���6�aG�	�Evl�W� iQ]�t�G$ܩ���z���u��i���C.Ը���ar;�,�4t+�U��w�>t���)9���
�F��4�[��,�$a��/�{��´j�i��9V_m;�����5d ��C~JGQul.��pwR�I3$�HSS8��-���#���g#�,_�x�h�K�(u� Hbi�\vs�]i;��B�́�}�r\�)	�#MEj�Q�*l�H��L�_�(B���I�ߙ�,�ڐ�\��`�
s 6�-�z�`Fv/M��ss'_yc�� ���}�;�Z�>�,A&̸H/�k +`+�v�!�G���"rN~KW�~:�R�$#�~�#խkXΜ.��̉�ѧ-?��*d0K�@� E���r�fUf7������HF�=?���Q�­s��j�;E?���!qK2B�}'(}���qv<���>f6��p��,� ���y����l��Xˋo�ǂ]%/�c[ ��C�d��ɯz0꫊��+h�%����;����t�cYl o���姵�"�V��.vf����W����Qcw�ߐ�@�nڂ�4�I�ؼr_QԾ@����9�!�N2"��CB�{O���\�2d�(��=�M��%ۘAw�������Pպ��L�"��5�H9'�ƙ��	�w6�y��w.��X�s幝���=�T�\#aJ!Gh�~yR!���H��q+��e�|]��\?Ɋ��d���!�.���)�)���Y�[ �K��D�q�X���H��Q@�F~;o�����5�*�i�Z��ҏ�W��!��[I��U���k0H�НXQ����5ٙ���M耠�̴��4ܼNN*�mC5n?�I�\��[�|��ֱ�����$�C�;)���8��r���x?憐C�d[��#80"KK���ޔ�+Vʺ��E���j �Ɗ&o��:Y�԰@V�J��[�sye�
�jڳ�$A�d�p������/b�,h�\��f.��/$h'Y'�u�[Q�AȂ:�� �3C�zV P�<@�z�A�]O9�ү_��b=�|̱����ӗ���Rjț�\0��a*�Y�+�����u�*i1^�K��֯�D���L�t3`��2~f��r�S!��k�%;�1C�b#7Jܺ���ĵN@s�%_
�7x����;N~�F�D��+{�,@rܐ #q�_��G�+d�U1O#�j�z%�q���o�r���m���Ym�$��l��Ϫ{��zY렏�P���(��R�9���Q��x<�B�p_o+��5m���/�*��~�sԐeN�*�g�_I�G��3�ߴ�iOn����&9lZ?���^�RC�v�v����=b��zįw�����r�������጖� �J�t*�]��F�v^��/��`�z�4��z�>�=CN��9��<��GM��T�����Y�|��	�GH��j���k��3n�ʫ!�
p�S����2$��6��Qf� [���� ۆ�Y>�(U|]"�"����b��$)4N��t�p=!��dG�U4ư����Y"6�$A��]��ޡ���&�b���o5D=�~ �*IA��A~#��@�I2�̾�k�>��%@R��[9�H�΅ݱ�E��IZJ"�.�j�Bv�l+�Y�Vi�g�ei�Y�"m�/ mH1�|��6�$��,���s,^�##���7e�]]�v����V �\�2W��1ø�6�%��Yɿ��Z�����"�5$H���].﷕����ӝF'
��x���E�ؐ	+��0�"��-�G�Q
�����g�����zD{��e{����I,��~~8��&Hm��̽nk�s�C������Ȟt�rŤ8	�~l޳Q�	!�:��4d��?������2A;� ƺ�t's�Ҕ3�~���V�1�R	��hI���=�6��k����X�3d�H�hI��uգ��k�3[�ꀆu������%��1"��s��N S
  �
���D�����J���9�MK�Mdr?��-#��kF�{I
yl_��!�����������"A�ѩ~�b�C��Gu `��)	ӗ���]����q-4)�aa��?��r���&�����vOC!��'�<羏��-�#!Ei�����959R�0A�Wȑj�����_ IV��3̣�C�i,΃������
ɾ�x��0,�@-�6h�����hqA�ˎ1�~W��2�(C��e���1*��<{F�B�����T<�p���g�����L������%��R�:�A$�M�8�2��¤��������t��ԡ$CH��X��λN�Ñ<�ty=T����������g�!7IJ����7� ��Iǫ�G�N�m����o'�T�@6��|���G2�����@�[��Y[ �TJ�I�*{�6�`�"6Hּ�����Ni	\NK�޼�۲��;����:�J+�����f��|��}bh�����%NQ)�<���Ӄz��H��0v�m4����_�%��cS��J���5B"��D$ݬ#x/aL�?�j�d 8��H�|��i~��b=��QRװu�~��+G�((@ִ4�T`�N��˝�hUI22v�2�<%dWIs�ߩ�޽�
�80~�Y{���>֩�^�*Is[�	��b�\���߽�� V&$��>����TV2�0���*�Ιڵ�elK��+��&fC��.��y��L��տK����r�ͱ !;N�ޢiD���X��uȪK� :�t�M^m����_vZ�1�K[�^�90UĽ&h�r��9�vt��!uT�E/s�������	�εh�d/����9���alf�:�˄|I��	��t��������Y����?�{E%���9sd���I��,�m'�^@�G����3*7&6�K�5O��g-jHN��!���~e��K�^|��k�v��|lf�Lϧ����r��-ᴈi�����l�"�Wt�@����/����Ӣ�����J/kD� �f�=Riȵ��V�sm	���F(Ҩ��8tY�HZȉ��^��W �QZڰ�Z�kyx|���g��EP��|�z�4�n�Z�,�~�CQ{��ði�����Y�l0�ZD)j�%�o�i�����@{V[x>���$`I�(PΝ,�G ��
�$ �o�B�(��g8�ɍ�C��pD������X�?�Ϗ��r�<��$���iz���G�}��P�έ6wM��\z#nV�S;)�#� ����D���B��j_!r�<<s{����F�.�JQ���oiƂ���:���u_icJU)��̷�ûXA�G�9��Z�zt�g��I'1���<�����@�y��>`�/������׿���ˮꆻ�^*vV+˚v�
�4$�'��1�X��2qu�N?��l����1�pp8����|E�4Q�@��ݓ��+di�!�<��j�������U�d0�?��H*����<�^���WH���"��뎎H)���Wx�S7$n��&��W�>Xu��f�5�
X�es���3��m�',����3�}�?{�)����^���^��ôe�Q�d�3�P�U�!Ϭ���tw�]��o�VE��29�OW�2��Dƾ�O��u�ɚfӄJ6�ccov;"�Ӛ�X�2Y��BzI?fN�A���e7i ]�����:�pu�f]*ׁ�ڜ��0w4��@;G̡���f5�|l�C
_!� ��ҁ]�� �k�Z=2W��z���_ȑ5s��kx�#��[��/�]W�Uxgg6'��}4s�#��`��7���@��M:"����ׇ�W��S3g�
�nl?�u�r��4rG ��~g�|}��64ל$�z���	�o�!�γ�ʐX�|ު��.�e�xfN�sg2q�TO��f]@#�mz�حf��>~U�\/��}[JK��a���Uo13K��.��y}��7ڐ�i����{�C��A�jG�mr.�(ig������������?��]�Z+-��Lx��t!��s�U�K����̶�Ç;��xtb���#��Z�;7�]��B�aX7|3P݁l�n�)��A�x9�;䦘]c=��n$<oLc�:4��GY1�K��b�X�6�^27uk������<��u��3ۦr�hj�b�mP}�W��J�y�]����9��\�uO!��n����=�P�~W�!y7���?�F]��f�A��H�I��L�#Q,��q��ʻ5$��]:��ܰ嫐�P����)���W����s��-�U�s��$R�9�d���?*�н� �c!��m���!V�0�Ś=6���Q',��pv2cLc�_
�>A�l��]��9}Sb����G6�#�2��m��O��������1������S~/;Z �&VZ�,m�b ���0�^��^_��F��o�<�>}8]���&�o�:�&Cޖ����9�\h!bOd�/�Oj|R��n��r�ҷ{s��j+��v"�.Г�I ���R�|��쵔�:^�PC`��m�!7��tD=[��Q	#�p���*�f��w[������W�k^쏧b�O�
1t��u�f��J�����@��e1���I��-��f�m����C��b��W!.<ժ�W�w����O��O���v�      p   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      r   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      t      x������ � �      u   �   x�u���0ks�@)�.3@Jw*�.@�x �����R�=�k���}~�9���m*t� ڃ�ؔqc��;��V������9��t��D�����[]�<�D�\lp���wr��k��sWgl�9N%�EJ^q�I�y�c�	�Zx����"�b�̇��MqP3      v      x������ � �      w      x������ � �      y      x������ � �      z   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      {      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      }      x��]m��(����������E�������i�4�Cw����
B$����_�+����:~������Q��/W_��������jm����2��#3�,0�����o6������yK�;���~ƕ��=�-4_k54ڛ��z��˵����l)��/p.t8�����Ґ�(=����Ր�h=,[�eK�lin�4$,!�%`	XB֡���$
��:ߥ���oM��'���f`�zX�������[�{����^F�^F�^Fx�E�z��,aM��&Dxύ�%X��C	֡�P·@X��C	֡�P�u(�:�a����!��א�	޾��uH�����	��	޾��/P�u�	u�	v�	v�	v�	v�	v�	v�	v�	v�	v��'D a٢.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.=�.}@]����u���إ�K`�>�.}�]� ��v���إ�K`�>�.}�]� ��v���ԥ�KP�>�.}@]� ��u���إ�K`�>�.}�]� ��v���إ�K`�>�.}�]� ��v���إ�K`�>�.}�]� ��v���إ�K`�>�.}�]� ��v���إ��kHX�P�^|��!aB]z�M��MX�P��߾ɷ��mz{��N�J��/� �{�AB�@�W?AV�iXe$, �W��x�$,[�W?A�����H�o>A����$.[��(�aO�t���N�
Ұ�M�,X�o>A��u����|2N���|2+po-��dU����O��"���$��,��	k��7� �=��O<�C�|��u��O����7� a���$�C�|��u��O��Y|�	�!�o>A�:d��')\`����wH��{ (��IWA����O��B���� a	����	�;�	�-����O��lQ���~"!��(�*�_���O��[x���l{�>-��W5<N�e�����$��j{!>A�z��������؞~@>�T��VS���b��HmT�)��������h�rW�o["߬z�&-�����������Y��A��і)G����?�v�ǘs�[�q^ീ�޶��$�P����}����z�^�O���u�m/�'HX�P����}��uu�m/�'HX�P����}�MX�P���������}�UP����$��l/�'HX���n{�>A²E�v�K�	�-��^�O��lQ����}"!��(�*��^��#a�z����;�^�O��:�po�Є�����ޢ�	�K�	��hh���}��e�����$,[�յ� � �^e��k{>A���յ� � aB]]��	�!�յ� � aB]]���7a�C]]o}>1�������=�F��f���*�Ļ�h���ˡ�dmr��t���l�����]������.������;[/EPRo.�G�}������w���7r��O���>!�L��..Ym,�z?�%�l�ި�*h�}��52�8���ϵQf�	i�i�����΂�[}e��7Z��L���U��R�HA
{���$ňd�#R��N� �qJ�)�k$�CR�FAⲅ?��
�)��� �c�"V���	NYӰ`�x�����:�po�x�2N��R�F�-l��������uQ���׊�EA��)ň$�sJ�%�L�:$E�$�CRtIA��CRtIA�:$E�$�CRtIA�:$E�$�CRtIA�:$E�$�CRtI9� k�]��b��#�0(]+�0(Hp��9
����AA��Z�DP���P'Y�DP��lQ'Y�DP$�]E}]1A�n�a�.�����G�'�>ʙ�8aK�:�r&����uo2��ό�|~f����*Ɍ���v����:���	���/�$ ��n�\'���VkȞ������
VK���	$~z�����d	�����M�5�>��	d (1�@�*(X9�@A�KLN&P��hQ�YN&P��lQ�[N&P��lQ�[N&P��lQ�[N&P$�]�"9�@F�u��dŎ��E=}9�@����E�r2���{[=4F �(Hx����rJ���e���rJ���e���rJ����
��)
>����� aBV9%@A�:�:�rJ���uuX� 困����R���`G�y�o���ջ��� ��}�U���|�7?���E�������7��q��q���?���s~�%�)OB9�J���$�=���ؼ74�!VaQ�����^�l)�q��qR�D
Z�]�B2P�d :R�@N�������n�n��yr��#����v��rm�k=uE�Z
>[��2U5)�!�G?�%�_
�Y�P�H�N �l��G�#�����^0~>�J�D����Z��Mre �U�-���
HN�D7�=���ё\,�N��`�@t:$�J���B��+���p���"���Ub�*?i����Y�߳�@l5ʯYe :F��(?H����gG�5��A��<��/Qe���"xV�_��B���ZD�r���Q����ק2�U����?#<.C���	�t���H�f2���L��t��W�25�k$��m�,���?_������/%]�ۤ=�9��Ҟ*W�i�[�;W0�}��m�i/�ڌѾ_��_G���hw�+�T(�:(?��O�Z����BM��Þh���J��! �r��T���m%����A����=��׻r�{H��?GLIS�"�r�\��:�-R.��s��#u����\��t`;s�=��F��h��Ӟs� _	����4�w�υ��=����QO�����[k
�%}����rq'���36x�Dco0�4H]�%��+�=�L&����@t�Cn�+|�n�`�M~�/,�ݍ�����^�a�����@��`�N~@/a�`�/�d���ڐ߱�@t�`�N~�.Q cu�v�� �'f����"5o`�O|�./aT�`lP~�.�Vox�Ѯ��H�ɺ�7T��]~�./c�4��H����M�`�N~�.Q���:����w ta��:�u�D�*`lH~�.Q�@�]�D5t �G�2���_��_DUt ={ �/���#�:�����������[�@�g<d�v������(���~?c���W����苣����h��g����x�q�����]p�7��e��i��w�7$�[��W��ƅW�y�5�hlpv�qi��L1�K�����%�ߟ��h�zO�ƝP�=��4?PBo1߆��툎l����μ��~D�)P5v�t޺q���yo��>m��w�̙>m�e������1��6��t:��h�M�� ߅��8�]T�4��#�oN�+t��l�#a�N�Z���d�п	��4��#�oΎ�:��i�I�-���6uE��9��ٹQ>��0���ፎ�0��i$H��<�b�!	/�i�����4r�#��Nc:֢iBENc:���Gב���ζnp�2���<UA���t$��	�
:'hK��	�!gAG��DoBڂ��5=��3�O�@���9s���K_��0�s�����G�k'zZ��q=e
�:��i.���%3��Y6�>+�X������}��M/Iu$�A�kR	���!�5�Hؖ�~��ڠ[>0��Nb@�_��'= r�A>~<,�Ħ��:^b��d	;��E�0�3�@�A��)o�Z����J�l���B*g���%����~ms���[,�ɜ�R.���c�ӟ>~��] g�c|������ ��4�JŴ�Z�7������z���A����H!Ek�a"�w�m�~k���[/}f�ծ�T��Q�s���b*��=�&���G���[́�-W���m�Z�.[��kU�M����a�&�r�)�!Fb�����9�{�+�?ô    �Ѧ<B�����	��hDLH@п	oSh,m���A�Y:�,�t$.!P�\	�!AG��D�pBB���5���s�O�@���u�T$l����<5A_Ӱ`Ѹ�����u\�ޢ�F!EAG�;.|3-d)����h�QHTБ���u��	�
:�-��t$�9����	9:>Ѡ�&!mAG�:����	��?
�:�!���o�ڇ��^Ja�-.C�t$x�#�1�w<�<=�?Kdп9�d�e4Keп9�e���P	Q��7o��	���W���}���wj���P����Ɏ��G�#�n��h��� ��f�m���c"{��d��R�..R�}�Z��X�a2���������b,{*{H��T�Y��g��m���JoԵ��̷G�l����ۏXv�����ϙ&���-Cu-52�(�at �\�t�y�1s��_��-�@)� �oJ�
R8Z)HX�RO��pe�|�)l� �o
Ge���׸�{��= 
�J_WB�+�������bq
R8a+��N!�CA³Bpo�X�2+b,N�J5	�#�vJV��+<	���~�>T<A��Ǐg��s�	��*��y���7�$x=
�
ROA��O��)H�h"���韛�G)�� a�J1*	�V�Q)�l��bTR����|�|!	��|!���|r���ט�/� �q�.��/� aM@]1_H�$
����*b��"|U��D}9_H-���&<N�o��q�7�|!	뭔/� AOE�RfE���0P�RF	k��NAA�$�SP��΀z8r����m	���B����b��r�G�R���3q��;f�.�L#�l/N�ѕ3�$�8QYN P���D�k9�@�pM��u���GN P�pgQ�\N P���@=�$�R�	�u��	kꖋ	�'Q �Uк�	26z�?/&(k,�Ẏ��[4� '(H|ǅ/-�e]�?�	
�_�.����@� a٢���@� ��^g�c.'(H�D���r���u��	��?�	
�!���o�ڇ��^I P,.T�$������@�������7�EFB��M!�@'��FN P�pB��c�r�Ge2�0�%�˃�����0�<	��o&8*�3<��K�ؽ��[��7�'.lݞZ��RIw���Z�K[[ڷ��o��l�=okZ.�l͇�r㾽����SDg��T˩"�����_������`�S������G�#e��C�9�|I�G���N�J��rIx���R��ڮ-�����R�Օ]����W���[ڷ�kއ��֖�u����m��Ψ[)6O+��Z�ka�	K������U��{BX��K� �/�[X�ϯ�޵��R��K5$,�SZ���R�kga��T�h�Hi�)$����C��9uk�+�4�Ai�@Wj(/U��TA�R�׆��i\�Zz���G˸v\��K�7-�޴t�k7��tsNK5i�������ҭ>-]y�ZXz1���y�|����}[z����y�Z�K�BY��ڷ�׊�,]Ye�.S��m�:]��ҵ���x��x��]i�m���C sk�n/n2� ��󴇲Gڼ�!Vsk�o�(��LhĀX�����ɴ�k�.շ�t�׵#]j����t����K-R]jC�����]YK5�-]k/��^���t�]=-�΢�&h��-}�BK_���p/-�΢�׀���KK/�iiČ�^x��k@Z��o�U-}�DK/<i�{���`hi�������/Wh�I��^���?���t�;-�>��g$ZzKK�����XZ�؄�>�����K7��k��n����.}�Bkoc�R}[٦����n��ڑ�=�,=9,���R�9�}K�4�HK��4BKϽa����=,}�֞T�����{@Zz�EK��4nIK�4��WXG
k##�}s=���6WJ�޾�边�'�{��Z9�h�\�o��T��,:�=Wq\1���
�.D����O�+��i�B5_-�?�6��9�;όk1����|�;r{o�[?`����Մ�F��V}� �Y��������;��[m5�oQi��+Z���������:�Ҙ^Xz��͖�O����@pJv�Z	-�S�Ǖ����ȇh��t<x���~l&�F���M���s&m��K[��?�>?����/SA�Ǿ���r"�vC�ً7���Zd�^r��bH���Pm��l��a�=�5J�@�d����*H������N)HX�RySEBB}o��H%U$�M�������kJ�(~;��B�5��0R�[��,X�N����)��N�\QA³"�+*HX�r�R+UU��1���PRIA«E"WT������@�� �MP"WT��U�*�*H��IuJ$|4�j�*H�\QA²�**HX�R�Ne�m�D��|��D��|H�P��q�D���|2���טL�� �q�.�L�� aM@]�\Q�$
����*"��"|U��D}�}�\QA�k'�7�H����$��!�+*HXo%rE	z*2��2+B�l	rEe��I
� ��AA�;����
�%�o$�+*������J�2R WT�N���2%���1$�8%r	/N�E��$�8Q�Z&WTv\`�C�k�\Q���$�Y�-��$.!PdrE	��\QA��D�r�\QA���"���Iw��2������ϋ�ʚ��drEE@���z �>��
�q�KK�\QYװ�D�2�������c.�+*HX��c.�+*H|s�����
>Ѡ��L�� aB�G�\QA�:���2����u�erE困����W���drE	F|5rE	+�+�H�\Q��@���H WT�)�+*��ҐH����rE	�4erEY�rEEo���2P"WT>	`erE)�+*H�\Q�-��٢/��P�Z�OPз
��S�;�LK� u�I����!(Bdxf�{���q&���NI�>Eذ�o�I۞|Q�3	�"k�!Jx�;{��H=����3��4�!�"$x�>�)���Z��/̪��$ ���|Ĥ�h��!a&
W@z��GO:��3aѓoA"<=�!$��aľI#!�����)���χ�h���D�߭��`�~���~P�s�s��L�k�{�G�֗�V�'�;�����d�5)�9e<������p~��`��[f��\��Qs��ͥ@���Qd��/ޛ�<�q�7Ws�yv��ٸ����52�,���&�.�G;Ů[	1�]x�4�/"8��_e� &j2�Wws�F�/u�e��5�k����ya�=&�F�>�Q��R� 
�޹���֧�F���S��<p���{�~VH'~����հ��-e��e{��8�z_�S.�T��u��r���%h�H��,A�>���"A���=���'cGph�
�-(��sV�t#C�Q0݀��<S4=AA֦`���ҍ�F�t��5H��F�t�b=���B֦BzX!=��FUH�ND8OP���X�4CE�	
��)a���%���L�����^�v"���g�'(H7��.AWcg��'(H���3tD�wC�-A�A��DOP��8�?`<��bҀt��$(8N��A�O�Eǡ�8�.&	���������b�g':��	���	��0��^���F_���>�Z��av�7��?Ǘ��B)��A����n��p��\-6%����qn�����Ǝ�������&ftp}O�����\�=B�.�!m9v<���cYx��^o��&�ڲs����M����%�n���<�G7��U��瘼}2F��3�~4W���>�o:��:�G�?s���]n�����xe\B�|�èͥn���E��P��� A�0�B$\ 3s��	��
�K��	
���+Q����+�o&����
W���e+�Xz�=T8����O����꿥Zb<7�ߣ����t؏z�u��ڮ�,v�P7*���z�x+R]������or[k%:��U������~�z�\C�����!�G ��+C8*�́��<~V�΅��!H    u��!H5$4����-~}ޜ;�9mK-$�Ak���af����f������g��bB�e~`���+(H��BN�2��Ӹ��gY�O<[+��06}�*6(2���nW큿ygu>�����;^��T"k�����_������Rj�+J"��*#�Pes��H������x����C�������!f�W���r$�KLq���L�go�V+d�*�ۇ0�@^�Ѵwg���!�ev�/�'78]���s
����U��2��MS,ɴX�V��A��� a��*�+Hh��?wџ)�S?b(>��P��!C��� ���-����J�#�J�}��|�gv��T��y,�EQ��JT"7P�"�4*H��J��L߃��.b��'��zh�9�>_A��zѕb��1,�yA���� ��?8�%�|��1�����0U�	���AH�T$����DD_��N��ص{��Y5G*Ѣn�Gy���mgj=3]�ǎ�]��\��wM���-4�:��{�����(1x�
�h��P��Hw{�a7�m1UW�f[*#�B��P��ٖ��(Hx��R.�� $���[�ِ��|d�	zs2φ���	�sQ��P���y6$<N4�$�l(HX��ȳ�|�]EC-"φ"|U���B-Q��PD�#�	��ڣ³���$�s.�l(HXo%�	:�2φ2+B�4	�e��I�<$�AR9O	����	��ےy6�^��<��J<J�1H�F��P�^�R�T	/N�N���'�"�<
^��s-�l(;�	����u@�k�gC�"(� ?�	�[`�<�ny��r�gCA�+E��P��8Q�\��P��&�n�ȳ�|�]��̳!#a����"φ��a���� d�e6q=�{�d�����̳��k�b���gCA����1�y6$,[�1�y6$�9��u�e�	�hP�Q��P�����̳� aB�G�gCA�:���2φ�MX�P��+<���J2φ�#�φ�x6�P�@�|S��Pd$�l(�x6�q��d��'�l�H0�)�l(qT� �P�gC	��Q"/�$��φ��̳����K<�l�G�qƳ���
j��F��W~6�8c�PPN
u_�EAq��|Y�1�}�u�Ū��k[���P�DO&�a!�1!�PgYe\��,�g8H�jLH&T4����T�P�+ۨ߂T�җ����w���|a���=]���F�W0SQ��dx�񫢠�sloE�խ4s�M؟���]#���S����ڱbTE�d�DNkwmw\e�T�37������G����悫��=����6W���+��rn��<���,v֌���:2��3c!N>4����8��+<j�FJ�(�B�Yx\ݟ��Oԏ�1�g��k[m)�f3�
&x���������r�ŅZ�m��ר�B�ܠ/�5���g{���s��S9ɞ��T�YM�S2k�AfsIъ���YZ[t��HT��8A��G�ώT�3�N ��Χs�:�ܹ�YyN�Xx���@�JMə�;�`>�	�8r�Q��}���,=�"��S4K� ��5�.=˼�]���b^q1�X���xS7/a�k���o�B�!�ﾥ�c%�#���(GUq�p_�O׬ܛ�5h�/����ߩ(�Ͻ'�PQ���0BEA��F�(�~O���]�(h��k�i�{�[�|ݓ8�(h��k��Ҁ�랎AEA�|_�NEA��AEA�|OǠ��Y��cPQи�T4���
*
� ��
*
Ҩ{b��=����$_�QEA��/ӭ~���XAEA���	���B,��XAE!�;!V�PP@xB��� ݸ'VPQ���%'�
*
�������2n�P$�(H�P�zB��z�4  ]�M(T4.��dB�������"�I��ܓ�����@EA���@EA�E{&d��Шsh�#�a�ʥ���Q�9��5�G,n�>���7`��*N���������͘�����R����l�(�r
�~�=3�R����w1����a�J���#����W��ab�]{�?�Y�Ow$�{�VS���GE��v,]�]|{�U�Z�K1�_z埒X�'��ou>��,?/"���ك���� ��+�3�	́z� mcP0kB=��ڐ�)Tc��9���d�4�B �k�+��+�Iur=탎�G]R6"���t�Ŵ���n���nߴ��Vɍ���2�L�ՙ7�Q���6ޚU���Λ�.Us�\����_#X���{�C�a�=�d{?��AX��b���7W[�?O`��(�뉣bl�[�e�Yk��=Nft�b���\��L��ށ�q<�b�O����;%�O�Y P~!4zȷ�q�i��h�z�G<#���Ǡ�`��]��E�~�{��{:��`�
��2F-�����"�s����_��Ƀ��RH���!�`��3˥�O��^dd�b��2��~$%����2-e�qT�m}��m�+�Ҹ����M��"˔=_^��'�s<�)�~~��r��~�e��n_�'|��K�w'��\�S�����u>�����C���9=�
1�'�]ǚ�5N��r���ۺBp�����n����3�l�p;��jmn8#Ll�g�c{#D�b �
���ެ�s�b�����M�G�i�G�[�r�a�U��|��5����N�)w�J�O�m�5V��#ICwF��Z�w���p�&~�b���,n;�r���ua��^�D~3e�h�f����=�Ms���Q(݅�H�Hz��1����V�J|�2��v�Yy��O_��c��]��+���{�N�����9�y&ԃ@Ŭ�:����/��� ������l=|+,N��6���sz �ʉ7<Wq�Y�Vy�ݒ�b���|EO�q�_��͇��w�x��/��w�ྠ�����ճq/��J����_���WxwC��=�L� �?��uJ�����[�%_�g��F��������쨶u7��
�ϛ���i 3W��yd��v�Y=�����<���9���~W6���KBf�K�jF)H��療��$4i��V(C�|���Ŀ)T;P��|~M��d�@���U���F
�Ճ+�SR�B�E@���)00)HxV$&	�V.�$c��H
6&��2�$�Z$:")0�(H��GA
�?
�%�	[������TNIA�G����8`$,[�@���e+�R�^��I0�7A+/r��@P>2���C2����	Z>�FA�kL�Q��8Q�C�Q��&�.���|�]E}�F����a������G�k'�7�0�8aK��2����V�Q���"s�(�"���0P��QF	k�TjVA�$��U��΀z82���m	��0����"�r�G���3q�%eJ��)��U���j�*Hxq�.��� �ŉ:�2��3�� k�\�02���� �΢n��� q	�z s�(Hp��0
'��0
��-9`�O�@���u�9`d$l�P^�Q�4,X4 s�(�u���h�A�Q���_Z�0ʺ�-&~�9`$n�`]@s�FA²Es�FA���P�\�Q����e	��?�0
�!��9`$�C��(s�(߄�����X\0�$s�(H0�q�(A_�F	�	��7EF��M�F'��F�Q�p��c�2�Ge8`�0�%�K�Q�)p�(jp��0Joᨸ���}	8es�Ps6y_�]A�?n��U\C�v_uJAMY`T܄F���SQ��������s7�H�,T�)�Oi���@���|�̹ �n��V��ŉ>�]c�ԿQ�<D��}��ͣ���W:��F�a����;��R%~[�@E!�dB����KL�z{[�A�ք�F�!#�/V�
���2��1�CK���F�bB'�6joK��=��3����*��=��T M���#���Q�i�}aG�*��3u�o�i��#����.�(d�hƻ�~��}%>u_�OEA��=��=�6�{���=�t�wAEA�|ϻ���y�oA�uϻ�����/ �  U�J��{���=�V�=�f��wAEA�|ϻ��Z�)��k�<��T��|*
��|*
Ҏ{�u�1�dx_�REA2����~���yAEA�{�E��T"ÖG�s`�h�-�j�%�9h�� .,㸪�o�\�O�Q1w�L�o0Rr��ce]��~�l�S�Ru>��l�´�.K�~A�8�|�:�A��s��w�K[r��!�fi�Y�_�幹Lt��T��88۵{y��ኔ��~�3O�(��EҎa���B�\�����#O�f�k��1��ܧץ��]~�8��-�tp�!9� ��b���񷃁;p+� oח�ԷEf/C�,j�S�\���Cfr˗�(OĿG�E�
�dk�w���9%wO�~kiվ~���(�N�����6�����k"�Q����,>�]�Ps�f���0���FEA��=����"9PPq�f���e�f����	����z�
�N�lTtƄγ6u-C��r'l6*
Z_�l6*
�/(�<a�QQ���=�������lT�*��lT4�P}�f��FMa�j��:���jՔ6C��PDaBd����Y͟��k~*R��ϾG��Wy�'�8!�PQ�Z�]�w}�g���v��Y]�oژO��C\݉�k�{ �o!_��������᪷�4z��6�Ss'�+�t.��*���!.��S����"(���竰��� �b��H�v0�r��;��n!�����BNӓ���h��J�<=G!r��{���T�j1޶��lL�.�<�3�q����xv�Aܺ�LG-�{�l��D�y�L}��i�;���`�"��tm�~�>S�.�T��"�����k�n��/w]?ng����c��2�B��S���֝��@�ڻ��+�h���#Ȓ�O�>�7_�xVNᢔy�c��=�2�/���G�:ХQ�o�RۜObA���M���GGS�m�W��܃�K�G����F(�O���k��Jkd^܃��_b��SL�!qį�^l����/;��ŋ^2� ۠�������k�ۇ��=�͵� �9xX��^V.#����}x0�#ߟ��o����s�_���5�K5%�_*��"�f���~G��rL��=�	���P+�G���L�b�gwP!�h\X��i*���*�=���wIL��
u��j�Z��}��b�����4�������\��)���ώۊod_�L��c��<�r�r���w�����y���ud䳎��qn���M�~�8��Əq�/��`�+;�sj��o�w��V�]M좘�]����c*3~3帾ُ��4��)$�G{Լ�<�����Sj*���!_�0Oի�}���ެ@|=�ɝ6z�4K���|����<�	]�Q�(���s�����޴{�n3~�B�s�K-?��]�2�Q�7�xy�j�n�{T�Pr�e�Z��`�a���5��"��)K�m��X4ɏw��e����� m�#��C?�t�5ȨYHGF�B
2jf�Q�`����/d�,�+�f�*	�i���3���{���n��>6��sX��̞
5�i49�$]=��V���T��;1{�#�^���|�5�Y�TK~������,?&>b�#�t{���NVf�t�)G��n�����D�8      �     x���[r�6E��Ud� >��%�_GHJS���!��v�&�'�%ܺ�}�����vl�����~_����}�g׿K���_����{���u'�B��؊��V>�+W���������h9l���䦕l��;�Mbj�܈�Px!77&�R�m%֖��>�r�B�P!E����I�s�Ve9Z�������$x��d�-������RR��+)����J�B��dSpj�ڍX�k7b�N�g;A����[>F���n�\�?�p���M��|�T�/����B��)�EJh�Z�	m�i�g@�t#��1%�J	�RB��&6Y0�e�̀��$6��I	�H	)қe��U�Q�ͨ����N��l'OL⫒��$�*�/@Ɣ�1%dl�ILN	��[O��I��Y� ��
�,3�D���dt]o���d\_	�`��@(P"(
�
�+�f@(0 
�ܟQ��FT#*����P`��׈�`De0�2Q��T*����|�0�PP(�(.���F�#ꆑc��cL�t#��]�Ѕ�aň�bDX1"�ح�d�$J��`Df0"3���Fd#2�����`Df0�}�p_#���5�}�p_#���5�}�p_#���5�}e�eOiYvO�d���G�e�%q��;}6лեF}�>&���ܩ�������+5���l��:G����y�i���@!���u�&����4-�1,��-�Rr���O.�>�u3�Y����rK��ց�}U�����n�R��``;�� [ � Xؚ��ȩ���o:߰�m�=��.)&ZW�z��D�^�O�-䉖>~y��;������5"���8�=��/"��mb�9�bυ�L�$�v�|�cƜe�K$�*�9�H�ZOS���S"�z�zа��%�y9�'d����,<�1z�s	��<���'}bt7�\v�x�qN'e^</8��%"XWw�IO�	w��!B8	EA@pRѫ�E���	�JV�${�{<���[�	�N��u?�;���V"`�V,n��"��SI[���8��ܶK>.�O�\[@( �+�Z0�����xTP-k�?HE��ب��UA\5WM�Ou��+qE�ŃC��DV��@t4DG'�Q���X |��A��duP�z��8��A`uXV�u��9�Fkch���������#Z����
�Z�Ѷ��JS<:��� 2OP�θ�̃���\^��������x\;!ON ��H�|>�n��s�5����F��������c�/:�3�h�* :����?�(�pQ1	.k�x��\��x��
@�}�9MHq
4O�x�p	����u�E��S �5�W;��/��)*��ڣ���D��w�SwT� h��N-d� 6�V��ՠ�+�JD����<�_�;�h���.f��k�ϓc��&�X�g��sѹ~�	���@�����N�Ϲ����"�+��"�Y�L�}�9����͔QE��J������j�C�Db��W2���F<vd�:�R�5���{�ŧ������!�s�68�gu�#��3�mݿ�[���ZR��e�o�k?u8l�F�a}�L���㰐�O_'g��bR��M����+dB�-=���E�)1�E��"��9�c�TKm�HԌ�reꘁ�фwvNr.
y�dLg�F�����Rs�g�]�f2g/ȜǎZQ��N�as��E$������X�e�Pc����Q�a�P�'�>��u�^���D�5����/����^%�W>����{�QB���r�#���@ <7>�n��j�gG��B��:���1��%��ċ�=��AQ�=�6��j�6�����f�.��������̗/�r~)�n6q���2Ǿ�}M����N�o;X�q��M���n빔��p�K�Z�I�`��͎��v���~~�H���i�m6�.}<��V�s�(G5g�>{EղF��?�|Uu��ɥ#�_6��3k{�:P�݀��5�-��k�p����c��q���'3X�����2r�������Uf-C      ~   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��_9Z��4�H�ձ��L/�K=�������5u+      �      x������ � �      �     x�����7���SL���"%�t$ہ�0��@R9@ ~�H�����c��'}�K���(P|�����%��>\0l7������������Ƿ�ay���?�~�!�>~������DC�,]���&��+�+ϼ_����.��KǕV���oǗ�
Nob`2a!n"3�.�|	����l4�".�6���M-4U���c8W���}�m�FHvlT����#�p�Q����diJq�
���x���!/X�L[��c���~����/l�6�x�y���u}с⹆{$��c��#�ĩ�s����׏¸]��u�z����i�}��l��,���cԏ��F@64K��h�iW|��"��~�Z��;#a��R����Ӝ{�7!�{ԍ�M)>oP0����*���R|�HMܷ�F[�zp;�!�E\{ld�"R=a�-
��A�MJ�ȉ�i�y�j��@���[��*5PM���Q��5o�A�
�ݢz��	�2�|�3�ʁ6m�1��#�`1A�KlTZ]*1�=�F� �S�ذ� i��8Og$F 5����\"��V�M)N���_�r�C�+� � |��RI�lbR����h��w�o혀�x6$�qFu��.i�I�]��f�)-!�r�lz(�8q5(��&$�K�^��
�z����?/?-��������˧�??�[>>�{|���sJ��ގP��w��N�/&15�d����%�Zq���>܄$wI�,�����$�ţ:�����V*�v!�O'�BZ�'�j^>k����~��Z{��t�B6!�ŕR\�b�DT!�I�!m=�ŗR��B$�C�9O.ѡ�;��"��#��A�M����)�`Vr�6M�^)>gQ%�l����#\�3�R��b~��x��+>Kb�*Kߏ�Úp��(����D����g<��Xu�g}��lpҬ�=+�����T�7�l|�>g��m�8}���p�0��qĮ<�؋�V5�y��gǰ���ъϘ|��=RtF� �j{����mE\���1��gI6�S��X9����MU���o�b�д��� bpÌ���+/�/\D@���C�&��2�lu�0�*Nw	$�%ս�uJ���R��d��_���P-����������CVHj�h�7��>#R��W
�А��yV>�Օ�C�z�XBHj8_�QH���ۦM)Nw�G�	w!գ�sRW|�"$>��i��'��/{��+�$���#���cP�w����	�dpR�S�o$�:��6d��/�C�p�IG��+C*7!q�Gb��T �ܱ�	_}����+M)N_+�`p��y�Cx
G�*.w9@>3�~8�q�/��O}��i��.#d2��z>��[����;�|f��bc���{#�aJq�����&$�{$��̐���u�q��׋��\Q)N_9܅Ԯ�椮�|%�g
��WhL��_0R�"�R��2�bp�z���p���]�|&������jW�S���
%ޅ���W���/+���� L��      �   �  x���[��6���Vq6���{�<�� y��ob$��R�AQi$<�~�B��d�݃�_.�����_O��9���?��
������f���������Qx��A�B~ć{h�:��)����vS���,�(�ڃ������%,�"�n�?m�o~{�l8{���;����O�x����pӹ[GO�PBt8�eB^�!��u-"�Ѣ��u2A��.��׺N� ����L�$��� ���)�t+�z�(:o����D��nѴz,����B��es~;��0�&���ȧ�3��@a�wd;1�o)��EHO�Zo�wwi2y*�g2�0��~����](���ԉ��E�Oz����GX���'��5w�&R�A���y�:�����h�l����X�H(�,�P}RB݉^Y�[�R@�C���r��o}��G���[��ǵڜHY�E�|WI��]E�5�2Sɨ2:��mllB�|w��Xٔ*�H�5!S{��X�X �����F�:B��̢���	tF]�I!�B/,�J�#��K�P�	��v1�6�Ϧ���ǅO��~�O����@�B�V^ܢx��Ay~�K��P���c��5��Q�/�,�TH�L	��M� ��Q�=��.ޔz��Z�Ƣ�/y_I�
N�������ۏ���D�/G_	���Ed� ttn�HT��ӫ����Y�)��pY4���W}<*4��\�b�����F�E��Ė�tM^wM�{�����=���hQ��)���W��h�( 1����N�їY4��L�!6fM��mxe7k�ى�V4/:I�<��U�GN�2�e�	���x�9Q�1�&�[��w��!p�}��G��̢(�d)��Wx�7 �-��$z�Y��'�^���Q���"���J�l�Gċ3�1L9�q��#�e������B̢	�g�BH�s&B���+"(OB�s�ۓ-ߛRw�2��M�==�5���ԭ)��HD[��-���L�q 	���ϋ�FZ���M�|��'|��{mx $��5���i��e����qWH9 ��+�6��8�Q�2��hKH���%�XJm|Vr����
�W�{�ܢ	�.PP@�����ܤ����HA�4f�����{@M%e5ɐC��d/nD��ȧ�ɦ��G�7���L�l|�;����xwD��&��;��R��;��ѣ��M/J��ճ�Χ����h���~ā��_%E��C~��i߇��cq�ǎܢe���57�n�=_s�4�k��������э��ʏr��[��7�Ѝ�[�����B>.�z��Ŋ�&e\I���h�;_,�~vIΪ$<�ý�7�[n�)�{�=��s�s�����c.�pr%=6	/ϩ/F�A��["�]���'�9R�SL����}�O��r���W��e須z�Yf|qu�/$O�L
��j�W77�ݢ	�.�n��2�IHf��֗2�׻�[�/�d`vˌ/s5���/\�Oݲ�/\���+S�+b[ɯ�Yn+�rr���Aʹ���E�Ώȟ�1�T�(�����/C�I����2�y:9���)YHxe�n�N�|�7�+~���z�[5&%�-�x���'l�̡M���?.��@��Jµ�E��.Š+�-.����,3�v��5񥨼Ǡ��f�B�(�gr\�/���6~E~��e!�a���j�{�=��3g
فkȬ�3�&�s�2�\�˾bF1]�EH]�P@FY? _�M&~D�|���O��El5��+i�D?S8,�B�
�����>�|�Y4~~~�Q'y�����;�&RZ���oNd2̢��3�z�-�G|���*����Eb:�&UN��E����W�L�@A16~��6~��b���ō[&B�aG��p�#_#���]�yq��'
�EQ��+1�2`���La�����n��[4��p�C�]xa��r�-�@O�٩MN��<��`�ᫍ_��Śf�7|~�~t�Y����8�&�^�{�_�M�'�찃�-Z���7�.J��[f��|��g�3�U������i�h��`'4�2m��}��
Te��߀�iI�%�#!c���,���$�s���kv�q���������j��J�ߘE�%;Ġ�r�yO�W
�pNmSB��tNmS�\��0�����"~�G�m�kO��h�wY4���k�����Tv�r��[4�^��j^J2�3�#���O��J�2	d�� ]8Q=0�L��1���_�H�����k�:�Ⰳ�[��^4 M��y����Mi|� �[-�M
��j��8���-3���ti8���&�����k#������5nQ��u~����

��6~��Y�)xے[f���/=�¯N<�2[O��B̢)���|��6Ok;�mA��0���kx���K�S�fR
���>���z�c��T���L�$��{�](�A��*n*�����GB��������[��_]�vNt��ܢ)����������o�
��t��mnєbW
�$w[l��-�+�M ���M��[f��$v�m�����+�q�X��nѤR�:=;�r�[��/�����G��߫��b����M :�k���TV>!b��p�qW�*A@ٓ�]l��a�JWH�	d>�p��2��c��nY�D��;�{9l@�?���ѝ�����Nh�?��W
�M�v�q_�a��íi+?b7ajlH( ����E�hzQD�c�� �G���ï��E~MԪ�T�dq�hB��M��A�c�너q�c�x���:�F³�E�g���x
l��e�d���8cM���/�?���/~_��;Ow�&�TC��&�����a�1	/]�-� u��2�����k)F��@_K��=�e��(a�WŝOȗ˨����81	E���&~��$�������G��w���z�3L
̥�3ҫ��"�2�&�@C��O[T�ŧM|��Q�ƅ����D�R>�e�:�0���~��n�RH( 31?_�A&~A>��b�W��a�U�	%Z�S�aO�N�����g�J�
�r%z�� ��Y4���W_Ǳ���oW��Tt̢	�.Q@z�����C�*�A����*~A>5q�(C�eƯ��~��*԰!r��%�!��|�)��O���>9Q$�̢)Ԯ�\��A�J�u���˟!fфZ�(�cG���
�ؑ�3���/ȇ3+�"_�������G���ݥ��tJ��,�Tq�Xޜ�}r���w�M�w%J��}Sp�[f|�<�&@�Cum�bLl���	GB������E(��>�����͡'r�&E]����Q`Shb0�dR�������W�
7E��:�_L��R��~���ȇ�V~�aP�I ��X�m����/v_�E���gn}|�����+i#�̢��ڮV���ɇ�߀?=�5�4��G�6�G>��o������$p<D!�����Yf��U�t>}�O��r55��I����w��ϝ�n},��|� <Z[BM
̧�o��0x$>2u�hJ�n�3zh��o���2S�"0��/�m������&�(�Km�$:H8����/��m���O��/`��b�E��]�y��l||��M�����Eh]���,�,|[�*�Af�tZ�B�������N���<�Ɯ����)ZbW�[fZ	�2>򦾉cUʢה���x���ݢ(T���_������6      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,����^�l�ū����u���B��ݱ}��!�Rt<�Oȟ�	������ӿ[�7��ٮo��r2�8��2��ߍb��5^�z|��0P�O*�z~��0P�O���o�X��Z�=(5|Sf����o���It�R�-V��X�H�)�5�����4o��z|����=�}2������W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6쟴�c��_װ����0P��,��b�U�>��b�ũF|R�����6��DS��)���j�ix�D��6�C���u%��.|bm�\�a�bÖ��VK4�S�Nm�,�0P/�k3�����^�bNU�D���bXq�cuJ���ݖav2ŻM�&��z3��À���ף/l�cu�sS�0P�sZ���9��1ba����X����cϺ5�)�H���A�7�������^鎭Ͷ��NѰ:M�����*~cb:�&њ�Ś�N�u�[^,b``�S����n��au�qX?���`��vzkv�����B{����O
3"(����~UC�ק������t`��Ϙ��.ad��J�4��'�@��n�͜�VM"�8�[��n�u[.�7���z0�ԛ%���ߺ��Y:H�ǫӋ��Yt�v�js��۲nW�0�C�\�ځU�/3;3l����p�>���t.�/�Ev��]�1>4�m�b�u��Sk3�"çV�F8��X����0F�k콞3�eo�{��^��ᘖ�t`�V3�t,W���r�����L��Z>�~lڼg2�R��}DZc���J�e�Y�����0P�حi��ԝ%z3���4����<�%.�=Y�7+��V��½�)N>1�6b>Q��q�s<c5~��fɍ�a�fqҥzH���0���"�V��ܰJ�0���f���i�4�қ�5�0Tu��ͯ�a���6s�h��|�a	��:%k3H7�R����Jk�<��@����f. 0�K��z	.�_�as�W�8���>o9<�B�a�@M�J1wCs����彩a贈c2_K�i`�T�7J��C��8%K���ڰ��V5���X�:����9����U�~����s�;-�OT���00O��~��!��}iê�_�"����)B��{�bX�����9gXeNM�3�%M500���!ön��O�5[�{c���W���BX<���W>�֬P�w��ŋ#�ARjN\Wu`���p�A��1T%��ԉ^WOg �%đͧ���$ő5��J�hq٪������KD�Z[���^���v�+��ڎ��00�9J�a������.�����~k�V��0P�%�(g5	ð�3��<)+n:�*qeE��M�qC./�M�l��S��^�:�{a�0�Hj��5}30P��d��>M����!{�BXlZ�jO�AX���Y��pd�E�$�^C�n'��}o�i]W�0M�;��I|�=�Peĵ��b��){q)��Hγj1�n]�40�#Rk�D1�]1��9({�3�R܉������K:p`Ps��Al��6Q��
�\��Ƒ�Nw�3�0�'�;����nf�R���;�fn��� �0�%e���"?�+���!d��{5�$(wm6�C��`b��.�P���Ln��f��D��KP�d����`r��jow&=��N\L0���u�ګ��p����RNr�?{P0��P#D��2����Wi)��
%8���� ��YS�5?a��� E#���]~60L�ŮI��&�4�a�E
P^�#�m���[C:ƚ�z8}��0tzIɥ.����r�i)��[�խ��\q�a�ju$��j|i=�e4�(��������}	���O/qj-^�i`�)hv!t��%·�n�j1��۽�e��BP(A�#��3���z}v:M��ʆa�qR5�g�9��[�!%oÆ�W���J�,��AS��j�Mm�����N��|��������z*#�|y�a��ip�b�.�0Pi�Yo�z5TZy֛9��0�9�Q�z��#V2E��a�M��?��Yg�}bmV(�y�Ek�T�{,,���}������6��J���\��o4��H��5�600E�U[�	>m�G@�?����[٠������t5#�n��%h�J��B�ټ�i��V�o�a�Շӭ�25��J-K�b��W�^��A�D��Y0˺�����Բ���*$j2L�7y˙C���K��׮�2wR�%Zى~��~�!�&�.T3�(;k)�<_�S0/��*k�-9�k�z���p�l[M��*���5uk͋���z�ץzU��k�̣a�JMe�(�����Z��j%5��ن�*�/���1`)�e2��G<k�DG6�;�dB�[�K���ֺ�AR��IԽ��jPe��FԘ��1�� ^�E��*}��9�.'�Bq��	v�����#���7'� 3��$��8*�Tv��eG���ʳ����s�u�^"����{���!�7��z�%��5��')�l�~�0�1J�,yH��)G\�k���ʛ�� '2�n���1�K�/<_ok�S��%��%��RR��19���î��=�r�a�f���W*-	�ͼz�[��Dr@�^rU�~m���'�a�6�_D�z��o�ٌ�����L�ڝ~ ��!�Q1�6�6�7T�(S�\�vo��sf�ᆁY��%��1Lu���+��~��H��V��Pf~8�N��E(�-�t�a��5��PÛZ?�'=[��čг/���;#�[�(��gi{<�6ܞ99j��鯘�7se�A����ݐç�($���DL�@U��j3�ky�*sT텔�ֽ�ͨ�ᢠ~6u!��?��91T���6��3T��&�d�g����ڞHQ*���˿K0�U�z�.��ϫ?�C.�c����j�k����Ϧ������#1#y��A<Jg�nı�D!1̩$
7T�2-��^���K�L���]ʙ���H��=��`�z��M�P��擏���;/w���-�f�$2ےDgu/k�S����L�$:R%a�C�R5,M@!g���~DqR��A�P1���0P�p1y����a���+��2膡�"�6s�cأ"�#~l$���0P��s!BC���l�k!�S���XW�c~��k�����{�� 4��W�:0d�ӧp�����0���o��7��6�%�2�|�]E�$�B�\U����P���5 U�V�k*�5��n����rf������R��5�e%���㶍a`�'=ɛ�a`��pM�Y�0P��`��3-;�'����A2��G�^�����d*����q��)�Z�K,S	e�/�2B�Z��̼+gqI7�>��f��@�+jͼ�ԫ|��s��;���Ƨ��|c�E����S�M��H���k��.W�3I�Oo�,�i��7f̼^n�]2�w��w��*���V����%���K7�aE������0L?�QoE:�'������:�eٻ��~���hk���@���A���F?��py��
��r���U�$��ʭ�[(7�XU��&�0p���@a��5��K_���J�kx$�̮�b���L��/f�L?��5�"��V�55�]2#a��L��zl2O�<��d��d�:_3��ǔz���TUi�����0P��g5	jt��5k��k��k��)�;c/���)jY"�_�^95�=c�����j���F��0�Ms�۫��9�����P��^��QQ��/Ԥ��j��@͊Zp:�0P��N�煁��<f�!�uU2f����@=5uz�ꥩ�M���Il��6�:��;�f�a���%s��f�ݛ�a`fɌ��,��VK2�]2�!��aH�?q���<%3���u9�q�V�Y�a9�(�����0y������-�n������ 
   �?����G;      �   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      �   �  x�}�Q�,)E�_��7���i����:�+�U��7�u�ۀ�Z���?Z�����#mhzP&/�\`�2��5�QA�=)���Te��A�T�{H�\�N"С�2y]$g��R��W�}KM�ߓ%�u��j�<���C.��g�#.��6�S�߳5_q����~o�{�߳���R�&�+A����j���&���1J*�d��ߧ1lI�a��)
������=�����֓�T� `��GI&����I�4����h�M��d����e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�-҄�$�6������T��8s�[M�CH,�֡��5�R0�D����`��I���y���4��Q8s��U�q�/ ���,���!&��R�����5JJz2l,$rŰ�CO�����v��6���xYV7ֽ��  !�1����JdY��JC����5���$ザP0H��[C0��f�X��ɐ4�5ܘ6�`�j�L��lnԔ�dQ���>@� `!Y>��[Y��x��t����<L�auh�-�'$��}�w�/�1������p�Y0��Fԯ	�1Bb���y�dǮ�l
4	�{H7� Uz���Ӹ��� Hupc�[�f.�?��AK:�q7� ���������l�lo��A�zɍin&������&-~���i7���^��#w�,6����B�ù_n�X���vp3l72��2��J�����f�B�3<�3��
���`(���}0�ˡ��0���B�qu���З�����%ݗ^z0x0.H��:\�o����
$n2x�M�w��nW�ۘ{���y��]��#E-l.�|W4_-���rW���C��C/� H���mYo��R���QiD�����ZxH���^��n�e���O ,iY����4qa�A�zi+	�F�[�ш�"�K��/=i��Ɩ*-�nV%ݪѭU�*��h�`���n��{2X�u�n��O�puX[�pb���}0�]������2�"�0�E�s�^�)��G:^�?�vWA��F-G��}Y'|��+��Q���mQ�{�X�ꣽ����S�w�W�P���@�����VA]Ǭ��ѕA`T�ݯ�Fk�&��y�^��{�       �   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �   h  x����q� EϦ�4�`��
��E/X������A�A5��H���{P���3��{�;�G�hh���(��s����R�I��t�HѤ\V�\��7��L2�XiW�|��UtАκ)P�{�41w�%��K4hH����=���+*4��7w������y����2͟Ahr�r� Ӑ"��(���4$j�$B����L���ۻ���{&��_��S�������:���ө߉�@x�)}���J��i~+E���+�r���2t_��'�:�'�$�Ě�_�1^��6��FW/��LC�Y�h������Jtd�J�-�(SD�]�Ѩ�2ų�ݳL���L��n*����V���0�ۘ������B=�O\ڠ�'�d��h�d����LC&� �"�D�htu��δP��籦
~e	��I-4�3'Ui��O;z�<�؅b��}}��ʻǔ�(�J^*u*:���:y�H�P���$�T1 js�?�+�^y��'�!v��UY(�՘,O�6���<���xy�]B�ʰ�֫v�A�{�ŉ޻�АvB�.A�!�;q2�v��+N��]�?QL�M��5y��֑�����盎���QG����?xAZW���&�z�cŠ��FE�
�H:;�c:Y�Ӡ��d����'O�WR(:�X4�%j��h���0��.�P̣�1���2�^[uRP(���:Y>A#���S������T��V�?E���XR1ze
)H;��q$%e�h�[y-GE��ybxL��a���_��2E��J�$z�P<j;6ɶ������-��-{�H���Hj�B��5�y�Řp:����"xYgG(����LYf�B�һ�Ө�%z���A�Ե�3-��a�9
���,Ct��E�,K�*/�E��x�8���j���Q�8�5�@y��$/�;�����K(R�N�<��B�YC'
�J{U�*�P$�^բ�d�w8�m��ǳD�[�e#NQ��Bq&86ޔ,�48���d�Ve�4�>�i��ַ&�q1$�)���W\��(]���5D(*����[��P�65:����Ъ;\,�U�Hhh���2����C_ڇ��e��1�s�8�F�r�)�+r��	T�Gh�4��,էP���=橦�P^�_�h�c�ʒ{����(�Џ��q�����/��Vm��i�]�3㟫,KҘBz�L5�jP��=ky},E�y�ZYk�P<kt�i��u5����R�+����ͅ\�w�U(4��P���9Q$�>Y�SI(����N�nY�µΝk��PD�R7�α��SX(��w걪8��
'1\��lZ���n�Ъih|e]����dZ⍯z���X���j$��k��BaL�w�)�P$�޵�Z.4|�	!� _      �      x������ � �      �      x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      �   �  x��Z[��*��EM g	���G���U�r���"Oa#���_9��� �!��-��/��i�ϱ{^��$��S�b�u��\ ���N�k�d����Tsm��oH� !!�oH����I0IJ2�:	�,h|�J��6h�d�7�׺��Q��-�S˹Z\Rh�n#k�d��$�Z��~0��tS��� �3I��!v9[P���2�>�������E��ڈٔj�)6����B���#�d�O̸�����6�$D����?����Q[�+&��Z׸�ɔ�j�����wņ5Noo�����n{�@e�۾�f��'�ꀼ:n���X p����ɫD��@]��E�*�~�J��������
D�D��[�$���ZHN7��B�c����K�{5&�#e�#��W����7����
�mo8o8o8������^3��h�l�R?[�TRHLԡ
P��55\�{��� 7*������
��d8�.~���@����U7�q�CҠ�6Z�΅��G�O�����"pM�h���;�`H p���* Tٶ�Z�᳟iJ���I��c�@q�����W���V���}
DZ�E�����'b�2�����!J��(��ï*��A�F0��I�����P�ͼ�Ml+1�&%(���ШL�RZ�D�/々>�"C�"ܮ�L�Lg3�xN G�u��K��(�{nc�ǕM�%b�7�^�9h�@w{�`tW]XI�v���M5 ^Z�?2��&��;�,�JG���A�DqCzW���'�x6��ld�r@X=�$R�c�$X�GE��V�0���#H��pu�1���G����W��@g����y%�k�z�tu<hc$1�o�&j��k#����1��Yԩ����#smLZ�%靾�QS��o:+��Q���p��&��1&�&e�s�E�����QF�y�u��&�ۚT��Y�����,�18�rN%bp�&�Vpz"z� ^3zAxg��މzl���;@�X��[���^[z�a��������!�弴D����P�ٞn50n:��k0�B����NǗKD?��c��yL�V��ɛ3�;������2���@�|���B	5Uy
�`��^s{�B����٥%Gc�{��z�l1�i`p.�a�,.��k;3;0����*+Z�<�M�3��h������|�U��PlR��P`vސ(�9%[0Z�=#��%�n��ыvJ��9HE�2p;�T� ���z��� H�v�́��R
����5ܰ�0��&y���EL��DeB�`�Z�v����6��T\q�F=O<@NYq�4:_Nw
k�Ҵ%�T�RC�&R����A�Q�����^ S&��&���6��s/��<ҭ����8�59Қ�I>�p���P��3��G���K���"�@�a5�D�bH�z� Xuu���J�Ypn}(t�4�5� �+�Bu�i����B������b�IX�:����!�MI�ґVKA���|�«�јp�؛O��o�,����H���@H֋8z�k��HJ��y�F���kǛ{��U"`9}��"�:�@�m��J
3����ꮕ�	.�t�'��R{�%��{>!<�I~�������B�R���,��������^��\� �      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@��;O�P��gI{m{0��uB (�]�!��ځ�}Ǯ�K�UG��`~����ư�ۼ{�a��><�M��bx��<�jĚ�����īVEHau�?7�sX��st3=�Aƃ-��u�
)�"�~LC ����6����(.��8q�'@G�5�Z���o�N��������i��g��f�.��?rnW_�թ���`�I/��_��o�|�g����"�G�Dˑ����5̇�KX�=�v�i�R%��X�mi����Aک��M�e�85V@qj��ıJ����6E����G���2(�y�����g�]8�L��4�w8��jz�/#�y�ZE
:�|3�Sm~�?��[�y��jB��M���pfE4&M���X�.!�S�֝�@��U|�&t_��#�-	v��fbqc!��,���И�����Xm��FfXg!���W�����uA�ә1&*�Kx��?YR      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
�+�����dm�f�Ƌiu���0�7>[��Rv��ȝ��F�X̢<X�ݐ2�U_��'�:/2J�ؐ�Yv�7��g5RԒ�2�𧊍�K�E�	~u(c��$ii<��txv��_�M���3rQ���ڼgd=x�E~)�eV��T%.�"F�nq�� �����>���NuQ�~Щ�@�ui�Ϋ<\�(P�M+F�<%�;Q��ѝ�A�*)�;P����<��8�#^�C_��m���M��L˭��*qϒO�^�Q�����ek���!LB���Lr'��o�\��[���e����g�"Q5�|�?E?RɄY*���=�((�b�n����/�n]��%O�((�Y�ҷE��s��u���2�{���V�_e�d7�C���t1�3�q����P�r:���o��e���[}I��Q�ڐ0��C�8ga�o1�������n�Ќ�>�J���Y��i�1&}���,�f�&�x7up�I��מ�����ލ|"A��!�kG̵�2�[2B�OS�F����E�d�VG�0��㬈���f>�G��>�b�3��<͸z}�SF��p��� R  ��ƙ�S�0c4��i�
��+rQ�7���mJ��'%
��i�fGc�^�ᄑ������l�E�.o�E�m$룸�)/v��=�����K�]��*"�>�n���C��n):�=x3��,���_d�����@��)[����0)�9j/���9Fqg����}�����#��b�l.�ff����܈�����W�Y�^8$'s&�d�ˆJ�޵�+S0h_f�K�2|Rv��T;�2���!������{�F�x����(�\�i�u�C��N�_ʶ1�x�׋�\O���J��'
��B�������]�.�ڊ�g����f���°ӌ���n�y�M��Ǔ}���ͧ�=��[�c;���Q��->ڗ���7�3��⤼���z�d���x��S���0�ʄ���z��f��wmQ\Ԩ��7m$�����5S;`j��f�@�bO�Ƕ򬽅`N��A�s�u\�Hj��,a���pE>1�l+c��iQ|�R��<Pt��0Ij��'�p�,FW�g�I]�sKA�������ʾi��h�M�����}������wec�W@Pz��c�ٷ����oe�5L�=�xq�r�;2�j��{������R�uZN�I�h�-�̓����bzz�VޅW�`ɘ�)<�#-N/mx���VR�Oթq�im��f�y@{M;�q����H��4�tHޘ�<3��RemW�OSס-���XG���1>B�ɫ5��[;���8��y�����8k=ap���>�,z� �5�C�վ�*�ҋ�v�(���aa(�;j���{m7�HĔvؚd����)�OĔvؚf�אMv�ʀ)/q�F�L.㶎�rԙ�����`B4�s� ���{�\C]l��A�҇wn���N9�n?��b寽�MS�pS|�ZF喲O�-$q9(����WP3�8Y�<Wm��z��k�8"+��x�@���۳BX;�f��1o,Q%ױj���1���ޒ���g��'���͞�9d�=a��a���%(��'���sT~�:��'�`�݉���-%{1��a�g�1�SB�~e���W��كl�2�����d���Nqy���{~-=�\�|��n�O��
�b�s�q���t��<tY���V����G��~��k���,�{�%�G�5��q��=t��طC�v���%g<6���6����ŏn?�o~=R (�.~?�ڢ��J��j�};��C_Θ&y�e���T��7�P������P/<���7���1Ф�Cc�V�[���怈��� j�^� ����p�r+#����B>~���
�2��Ƈ��[�Zf���2ku:�Q�E,n��E�&���nb�[��\���Ƈ+�*�
:D��f��@�L�OzY��(���n>��c[%z¬��v̭�X��(��!��Eɂ"a�����+��8�X\�6�#��e���|�;�k��������B�"-81�k'&�a����e�ϟT/��w=.�z`��T��b�R��'��T�Rcc�,j-j,9�iB4�*p/�8�8Q�gwIW��
��it~kܭ]%a&90�Z���5N��D�'�R��H3ŗ�=Ie%�����f�ؓu?^^3.k�>�m9?�36��F?Q�ǌ�	�x��f�2#~�H�R`���L�m�J ��I�1�A�����*�;��0��q�Z�ƞ|��<`�^h�������U]1x=&�0�����������{ƐK�ab���W0�UCf�P=ш���-f;�hV�ˆ�zd��b/�]ȭ�����Ջ�%cF���}bʾ�'��tȮs�|��p�����5a0d�p�I�1a)��0Ƴ��C��U|�Y�dƝY'�G�(T�6��a���-�n�p�����3�3��D�ƨ KYTdl3qGh��<~T��1�;���s��)Ĥ%�6�j��G����b��-1�Z�bʯ���əP&���K�7�)=��%�s1z���t߉�ї�"r�2 }Oa�����z(�	eʸT�d�*��9M�U\s%b^V��5c��;��K�c��){�.�ߺ�
�n��ۊncݒgr�`�.{W����=y&�1ר��z��䗜����T��5ɼ�}�����DX      �   @   x�3�v�twt��sWv
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
M���3����:�XVS�/���1���3��D�C+s�S����j��W6b,Y���*0�+�B��-P�w���P}Prm��s_9H]Z{`Kk#���K+f#��߮w�}��~z���+��/��3Iq�TK8��EUs��}K�[ʻ��+�xPMr�2F��i3Aj�iÔ�豧M̭K�=�b��z�eA�ʎW(�)��:o�I]'PL��.&��fF�1w>Mޠ��i�U��1t�֗�W~����Օ�U�b�ɴB��Uw����')����er���0,�)�6&c���\��[��m�V�=aQ1彊�6&�P��L����icb��MǗ�kj+��K��c(EunCi��s[κ�ˋ��&�활�h��}z��iN�q�u�������>4����n�zǊ'Ў��2�zP�[8KA�0��1�4=2e0���bB/-��7����萴5�3ֈdd����������U��S�������f��pjqh��]��T�w��S=s�kr�}�I��S��ћ�0M�u�ο4�환�g�dE�b�!J�\����Ҹ��=_�Jx�=�6��ަ��T�Һg�EM_�Z�/g�K܃�����h_�C!=�Iq��z�R`���o�_���Vz���������1�'T�%Ɨ����5� ��)R2S̅H�����tE��>�QӁw���bF���_�e{�Ճ�����,RS�LE��m��)�*��m�:�fw��^��|[@�_�|������~�=��f�DD������*����궦����S䝾�я�ޭ����1�9\�@�<���Xrg�G���͉�1'�fNlv|h��j���x�`�ۏ����	�׮'[�����(X(f'G���N�b�����n�E͛�#�T��M�u*�b�zՐSê�h�bh��-����4�ȑ$������u[��P��>A1�7	��2(�����:_�TW(�_���L�b�@R.���L�������IWv�J'�sR���_��0\\~ַg�_��w���cb�%1(����{8	9�s�x��ӌ3�Pp����۪��n�_71���#����[��Fu��j�������������"z����ں�3qvbb_	�����|���Tf��d��!(n�R50x]�93��Zdĭ��~�F��b	1�<!�">C6��}u���y
�J�����qՕ;|{{&�~���!1Ma��׵��h! ���I�A�Ɨ��+����gR+��j�?(C>g|A3xAA�T3e�2IŶ!y4�[����8zO�>2���~�E�]�2��qI2�ƚ%o����w����WY��C����"�1��|�L�ɻ���ү�����U��e�=�%1Bi���qG�Lĸ�q��|KW��@O\:`�h׉������ �c���űc4z�(�C��*j��fE&�хӺ�b�$�;�D=.�tM�h��e�a�b�"ʰW-e���_l=YikӁa���K�s^I�d��j�iMb.��sr�� ��S����env����<�_��|��zx{�7㕑����q���a���t|)/ϟ?x���2�������s&Z�gR��V�3����.~Ai\4����3q����|\���_�����z���������>��O�+�v�e��4�̦�!�Xf��|J�=Fx�e91�Mʄ c�#��A)P�׺�/�9��o�8'��U9EuP�T9q�s4s����Q�*�����:���� (��mT/���S$�:W#��+r{3h�1�NM�w��tO�(�2͓�W�p�//��5ී,��V�F����sd}b:�U�wLL�yelS�q����b�0�sw��!�@9g������dhq�w'�_pV���L\��m]hTfV*N�9�. 1��U��ڦ�U��R�FY@�x��W��xb�j�����T�����mj���x��~=C���hy��<��y�a1���S�}Hu�b�)N�ෞ�L�14�Z��������{[�q�2ɽA��3xy���6>Q�e���W����b�i�������(��{�]�ً錠V0�c�:i�:z�b�X�s|����	�OS���E�wXH�������.b?������1��}Bf���	���c}{&N���Cq;��;������4�Xd���Oj2nc��Ƹ������c,����~�{�W���h��	��Ӌ��o�=��Qll�u��3�_ߨ�����aS�1��E��dL��X}bd��EAS�����u��ɴg��#��B�n�s!�dy����rO�	.��d�����[��7����
��]��O�� �F��ʰ��Q��U�+үQ������)i�T�L1��D�r�m���G�f�hx�f�pVT� �n�$q1}!E=���)�1] %����܌��Q�}����<3�:��J
���~�>h�P�KH�"=���R�9��S�eEo�w�aEXC�&���	�`�ի�d 8�E���|F@��@���y��鷫�Z�LsE��#��8L�^̷ ).g=t���/����B�C����<�f�\�}=�f=%N����E�ЕW5�^����)&��&ʘ]/M�'�r�VL�:ԁo�=�Arz�|��4s�}(/�=ASF�{�	��>�Z���W�1��1?��=e����ns��|M�L�g�y�Ͻgv<w����=�'�c]��<?���ZJ�ܞ�����+ʜG��Q�>�䡵*2���衊IJK�E�La[N��E��/���9wﹺb,�dع�\8���P�a1�@�݌љ������D�(��a�d�zQ3�j�L	�b�Ѱ��
�o��͊DU3N�2�.�<k]1��e���[�ҹC��-\Λ�]���4*���m�&��3��昛:����!Ө�9�j�s6� ���<ӳT�vX��f�N�[�OB ��!�9��q����^@^�eu���/��3�u;��^�)�D��2�4� ��Hn�1������J�g8�Ĥ��Rb5��>�9^�2�K4�i�ͪ�_�*ϐ�B�hZ�f�l�G1l3�>��2�?���d�o[�d=A S>}�wϴ����x�5���R�:Xm0]���K������� �B�X4-��lr)	?�&m�p��߸?�x��7�환 �zA�y1�@Pl�-�����    !�)�̸M�݇f%��n��?�\&V�I�M��>ޢ�������fb
����6&�%!��t�Ԑ)�BPJ� ��Oή!27�ݽ\�&�X:��DS��Ĥ��X�V	=�VSD����~��̝����/5�iuFy��w5�ĀV$��3�c�!1�}|ty}F��I�2����A��c��1EsjbR�JQ��dȲ�`<�7�邫�~/�LtŴ�q�$�~������ip�Y�T���W����3z��Z��<Q�x�{RӨ\GE-�y3sUA�g1=�)�޹�(Rx}�"aNE���M<H
���8��LΣ�Κj�6�}��Z�n��z »��g�>�6�W|7�i_x^1E��ts���Yw&.�mzu3�(���f�.��3Rk'�g;�F�Fg���K����8~�8��}���Mx�{ۮO\�]�>���-X����!�e:��nP�G�w���f���n�G���@F��M���̷�+{}8�<hrUH�ϵei��j)��޼��MB���H�؟�ވܦt�Y�δtz01��K���@���JB*Ճ�~��Z�U-��6�G�+�SL"]��X�!&(ͤ_����o�L���<wp�0�|��˪�ESa�xT1� ���VVܬ4�W�*��as�e��.��;�_��W�����{ L����4Nĕ�i���X�����Q��z�0]-��
���*g�ƈ,�j���scě~rOIcJ���sYW�Q���0+_jk�<yB�-�D�hf�OӦ��	���a�KR�֑3y2'#	��R�2(WΨK��y��3�d٠�F�#x!�4B�X+������T�gZ�*�f��́Z�)�,*�����{}Q�7e�/�zr��(+���q��`6t�Pr���$�u'8�n%���ֻ��H���Q�j�Z�a侪P�Q��K������	���6CLܥ����KQ^=Ą]j���%Eu�|c=7i`L�b�>��#��a'F]�-�'�bd�%˵&U��,͒�qƜ#䑶�t�˽�h*��M<�8�ze3tn��vq�&�p7�k4���q3ڋ|��iR�kF��e4�;�wmd|�y'`L�7-�B�?����_������Z�.]��)�!��bX"�ɷ�N��< ��#�s*5�\��҄ �b#E�f�!�ԼT��Ɨ�ss�k��T�#�+�a��_����(f@�";�Ld��d3Z�g��r:莦t!��,��5�H�1�YEQ�<�¨ɟOz�i�����0\�����՜��^Q�u~*�M�V1�PE6�ߧ;�d�è�E�D�i��5`M+nj�����+��0ZI��b�C�Q1��ń���p��x.�!�z���i�>�*�P"��O���k�/SЋF��N0�T5�h\�F�-��j����.�\��cx���4ՌE�P��%�e�$bn�\��o��)���P�3�ȧy1l�Ic��{�P�"TF��$�EA��TߞiQ��w��@�p��u�郒K��o�N���a��r ��:��3{�~='���w�=Ӂ/,�Mv�b�+%rf%o �d�6PM��02;ZJ�hceR����p�B5R�q��1��-X
����)�4������ʹ��h��U����V_�ſK�i dL̨I(�W���]�.y�VB�rR�B�4��"�>��N`�@Ɲ�v5�F.���m~�׺���qF��eA���_�Ai���4�U����zT	��V꘻J)����Jct��
�U ��w�,pl5~$�;�)���ı��M�J����8�<�2M�<��z-oU�-xJܤ�j�_mZh��) o.#Bp�R�4%�8`�hu���/1��
#��ӫ���Prˊ(�IgǊiå��h����#�ê+�]И7���Ɗ4��@�vo���Os�˾� 6���
$("���3-+���ݧ�o�/���oߎ�J�h��	���WC�
��K.�̍h`�鞢�u��OI����I�=XV��p{&b���b[�K�jt�{�/�h�2��8�64{�u�RI�����4e�9T�r}I�f�����)�RO�I]�4��1����	|��n�*O�Q%;k�',�@�r��&��)�R�)���
���J&���hc��j�-s��P{��(@���?~n~�Nܬg��^^�F[���-RW������Skك^�.	�Ĩ/4I��U�i^���2�L~�2PkW�����'z5JMD��Pj\E������fK�h�Q9��&u�D$��S���^��2��O+}48B`��Zq`�e�Z��YsN��ä́UsB땾���ic>d5uN믭VV�1��:��J˜w�^Z��bϮ�سsi%�س3m6Q�>x��gWdھc�������{&c	^5z�n�T3<��(ШR��m#LV�hF��g&�@�VA�Oൠ�� ����&�^���ibn8z{aPգ�71�`�}��r�6c-K��4'�Rڣ������+n�'8��%pܚ��V�z�q��1��b�t�M��Vι"W1�-f�i!!!���b=�h;�]'(]��Y�R8} ��秵�14!��I�=y�!��{������YJ+t]*[FK�C3]$t-q����t~%��߾c�7����o��;��,��]_� V+CI}��U�����������?�y�����ޞ^�=>�,����1��n7���t���n�&�p���� }0^����O�=�Mԏ$W�{P0�&@�]Z���wAo�*b4�0z�G������۫���+y�]:��e$ ��1�(Wg~�/�e?Y������}x:���e׆����l��H�׷��P�SU�4��g�e��i(��_ѽ~`�Z�x&�rK�-q��2� �Rƥ��n��V<B���������G̰��6�`GWb�H��1�Lj>�c��Wj����h�ZtL�E�b㡣&�������bXqwAF[*sz�P��}p�"��Nzx>�Ҕ�����ȇ�����%/3�}�ZK�-Ѷ[�2|�����窜��)��T�E9I��:I�ڊu��[H��j)��fp�M��SA��_sӚ���D�T�!�J�軚o��Y�R�~�2Q�J���w�	J�����>��R�~`���:�!暢���r�� c�ܡ�� ��3�y��w��Y͠ի� W�V�7�^m�?����206���S`�F=��b�b��̪�.fGS;�سr��� eRE��$������w�Q���J������������5雱�R�V�^�#��J�<Y6��Jxx��%��v��~_�����%�ǘ��&� K8����������S��ƾ,������Kk�9���L����,�����؎1�
��������ig2��&/_�I�T�[��+8q	��nA��c|��=��edq�U�s�^A4��C���*1��&�����8#	�H<D��b�T�l�2�.�G9��Z�w�Ċ9��V,�R,�[X;����
��gb��jVй��͜湤fNg8�	bH.h�k�7�>e{j�?���,��^���/�t{����_ڊ�J&#%"DcM/`Lѝ��B1��Q��#Y$��Xf��Ks�gD�N��V� #d�C(��b�*��,c/1��E���1��7y�	��g��8�c�WD��^��:+џ�#̞��W�=Z&�	fȸ�؂���G����-z|P(FBH��| rIbRTx �^�+�rJI3.bW� !T��[
�f�#Q C PEh�tFD!��X�%3�A=W����;��K���@q��"iR8���6����RK��SY��X���򽢓_���rGZ3c�*%�hrʟ2����v�hV����vx��듊�
F.�k���\��"
�`xgc�E� �o�<˂��<�T��4ot�ot��I��ƅV����E�ӊ�*�7D�(X�GLUWC�`���+�Ӄ����W`j�.pL�O *��Y�XF7UQ���'�����)���5;Gt�hAĝ�`G�K, �� � ���x�S^js�I����0��    ��;�	r�$�L�2�m��b�w�4ܞ��c�<������g1��lOD�1��b��.�N���m՗�И��P��h��S��ĩ�8���@|��6�ؐ�ug(�h� K��7x`���To����+M���o��D!�VBx�+�MLZYBkI����e6.4x�χ����`6��k�Øv�p����}J7��Q߃�Ekw��TU��v`8y����U�����&���>ӭ��Zd�uA��$E[����9(昃��L�mD3��I�j[������-��)�� �R)ŭS�ȼ�j��~T))q����L�?���l�lx�R�z�ɭ���s�=n�5_��m)1�ۏWi�pI4�^�����s}��n폤�:"��rv�N-��w�ܒ�3�����lS=�;a)O�7�m��׾���3q�b$Yj*�:�WA1ī� T�l�PK!���kB��EX��ފ��g���*��R�614��8tj���V���K���7�y�:kn���1n�Py�S�~=;��8;��f�(�܁ާ� !y!o���`�/;_�܆�eύ�P
��_E=7�u��x�L�Q�M�q��j*j[�A��>�-�Btjܤ���X��xVl������t�<���r�n�<�����[gÝ��e�Mi��� C\��s��襋�|4�����i:��|���Tn�]1��EP"j�ySWdN�4�Q�~w�2�&�k�(�b2�j\h���
G;�j��T���]LvF�X��I����z7�T�m��1���M )����}}L8�%˖X�ne�[V��BI�>�����w����I"ȼ,b"`�B�sU���5�
}��^=�a��c��~O=#�S�'���S��`jh���޾�6 揄5��}D �w/}M߼>&ۡ����RE�s{Bh�n���S�V�%�:F)��Q�tY-��s͐f����o�P.���jsl>x�*�-��� �e5���a���t\�/ϟ?x�`?���R�0�Y/�����慃s)CL�E�.�v=8ky7�����=>}�]����ǽ�	ًm����ZΠ������FM��vi�k1��z����]�"��$&��<CULw�`��,�y�f�o��)��X	>[�f�Ct��)�!��R�@�R]�`�wͷ�\��":���Ԉ�UBP�o��퍍n�]�i�I?k�%`	K��{u�\R1:�$��R��z���������k.�v��ߞ�����%�cLko���V�+� ��[\q^S������\P%|�_����["Z	l�=c<��.���O����<�Z��;c�zX�r��J�� �ԗ��JI {u�RSS5`�$&��5�xD�[���dޝ�.ep�D|����qu����л��n�"J$���w6��_u�r�%X�;�S���cAc�z�o-@o!�^��1L>BT�z���i���ӓp#ȍj��8��R����P[4����)�Q�hmE���92[�Snھ���R��c!cezNZ�
(M=pl}�i).s?W��f>�j����7�n^&BEp�.�̪���3�v΄����2�؛j�^n���C����Kh@7�v�Nʝ��!�\��c�]B2���mح���E�@=�E]�&����Ŷ-��_�)$y�1�FT�A�D�n�#���@w5�ֆ3�-:���;;*G��R�1ԤKAwTejՄ���2��Ņ.��!��`��3�ݤ	1���`0��274:�z �T� ��~��h$�&���!<%�C��x�b_肇Fϖ�/����7��!�A�}�ޅ�+D�)�!y�ީ��$o��"C}D»4w�D>���:���kZ�������#J�A)A��>&�يwBCѢ���M=����%��;%{��:%Өʑ��1���@��gi<n�=q��t�%�{@�:n���\V�����+�]���]��Q���]E�ms{�����o�m��F�zY0�M�SW͜�bI�� �L"�l$�4�%+]�L��#���a�zx��������?������m(�U�I���G�������T�����3��)��H��k]!2���VNK"��'=��H��8W����c�R�c�:�O��K���`0/#��9_�^��2�i��a�e_JyZ��b�?U���Ja�DG�m��H;7-c{��v�h혥�Ӣ2���B{!�x:�miF]�#�����U/�jj�����5%V��M��a{��5�8ݞ��x��\����k��3ܞ����S���bRr��J��Ʋ6d��<��t7�U�/h�U�"�'��{q䕘N��w�APͺ"5��|+�oU��7��e�H\}+��A"I���P�j����V�/��tS[��6s�zj����F��炰�)�f�����6�����{��(p�l6�έ�a����:&F�J8�&�o=h��T�e9?-x
t~�k^t�(�Y���67��B�"��|e�E8�^� ���>��t�,`	+=u��E��j�ƕ�qN3��B�P��F6��S��$���u�T8u�zU<vZW �y�n˼~���z;Z��?p�)��H�S�hdu��qR�W�S6��������)6��_��gY]��=Ӡ1wKM1Rk�/G�6t.|j>�kF���&��25&��6ƟK��M���E;7F㳉Q��E������#t3�������q;�(���.�O�x�A�?�Yf���3Q\1mZ�����o�������Yז�Mg�S"�˸��V1�	��a痧j
��%$!`���6��=>}�]E%��á'�ْ�D`
�s��rb1Ų�����|�45�0m���C��~9W���}�5���v�&��R"�hU�롍&\Kw�r�a��v��Ƿ���=<}{����x���y{z�������s٪�v�~K�_���l��1�/� ����莮�W�cA�S�'B��u�n�2�+7ML\��p� �P:��w>E�Y9ז�)b�(VE�{��V+�Y��P�����D_Sr�Vֹa�b�e���+���݊q��VS�wLU�Y�b�z�Z�?�I�._g�|9��nU���
���B��c�M0&��'��<=��s�K:�˴;J�E�b�����
i ��[��H��1�Z!�P8��\�1*Ӌ �M��UIu�}L"S�;����5%�]FEu�	b����]�=OK����u�.UW4r~+^�zk�u�*!K���:myN��D�}�5�]�w�ZPQ�� �ܗ�>�k��Z�1

Nk��=��{�V/��=�0��=W�����������''[P%�l��-�n8ԑ�o����e�%~��R�W/�^��V���=�v���Ms{&�12e�+{�20�3	����3�?e��rl��"m�OR���ӓAX)���
Ll,�.��P�=�i2�1f�]B Sϣ�;K�,��������0�MɌ�~�S*JO���뉎ꊡ����q&&N o�PhZ�P<��r�\O�0��E� �޻|���-ӆ�3q��F��=��5�>�*R��3z��M!��-J����s�����-�
`�˖�4
}3�$@���NG�%�P�
�1���N�0ї%M�� S���V#�2���!���(�_�%�w���|�j�<�2����W�p�
}��E�����쎻�˷�o���ir:N����K?ޞ����VC��K��.y����v~>�������|S2\<�����Z9�Vt�)S�$t�է'��z��^�y޿\ܱ�OO���e|zY>����k���K��Dc��f,C�.K�������'�h��F��bU5~9[:z#�� nx 	�z��+6�^u���/�ݓCB���~o0���J�ޞ�E��UC��"������J�h�h��L�8��2�!88)�go�Z�q�[v����dv�9Fl���Cll9y�%��!�i8L  #n%�4.S��4�t���{�����3̷g"��b��W1s�@f}�o�d0�f1��LZ�2��j� \;�6�O�\c� K�%���td��0����֤�,ŉM��)���4��    ���a�h1��G���7�.�}��rs�2�z�2���VK8*.O�OT���x�A3$Y|<��+	�)
s�)~���}�n�'���}x:�/�˵'
� �&1���z�*$�pr�_cF�����e��)$k.����̥0�y�fm�6ݞ��;s�ҝ��'%��-�(z�0�9��]�|ΚP\�N�ƽ�|�
�~+�/7&�J#�=g�z�N�g"ǮP3>=�=��&�`��:OѮ9�<��a� E����a�1���d|G����W�X<���=����?,�����i|�Ns�t��i.�.?�	�og�ͱ�TO��/�My���ok�o����jRf
#�0M����&đ�O5�������3�`u�hܺ!!e=��DC�NoRCC�&��1�(�2N�m���E�R9Y�f��%��΅�~)nBKq[7�������`�]Ɔ��0�Iͯv��D�����)��)	gPB鞽!���Y��^-��?�~}���sρ�y��8�������)[=�K�3g�ˍ����c���+��/1U6�aL�e��4&TR��L#<��ϧvg��m� h.���d8aj��rYz�W1�,�c���$���U�MBo��*׭M5$�*G��y{����u]�jIՎ��6e�����io��w�-W_�⯫���3w�����gzW��M��{��$bəDz|�~��N�=�[��w�tU�	�G)t��¨�v��j�_P$9�[�s�ɸ��3�_�ј���V��1,]c�Gc�(�CHdp~�?�n��V}/���xV (TČ!l�|�o��0jEP�:2� �C�Z�З)/�Ռ4�g�0�)Ű�a�̊�����ҺRk~""���$�A�Pl�V���w������2'6h(L�0�=����F��44��o'%)�wc�M#,�`4�{T&�B���7z^�����ա��=�݅φ� �j��\�����w	����h���\�J/��9/&	e�*�}M}�х�-���|<g?{%GIzp�B�P<���^�0��!4ܞi�P�?Q����Wܙ�]�[�	�D�J@��;s�̌LƏ�b�DC���A�	(����ј��wQ7�S��q��~�zx����������v�, �I�3���#-k�AHN�����}�q�R=��Ҙ����0��#p0Q[�PL4�4�Y�o�����R��̨���J�ʀ�p�Q���"S��ȖN�]N�zF�sgd�A��W҉�Ԍ\�:Ebg*D�C/��@H�I��Mz/i�w!������Ӫ��)��0�GH��aɼ:���a�D�ˉN}�>�K4���#\��D"(���&��SV�KO��ɝ�犨u��iJ�ڼ �.����c��ߞ��5'��a�|�h�=m���V��PV`t�Ʊ	Y��;� ��oPBq)�B2�D�ɰ�wW,��q*��#G��:@a��2t�b��I@VU��=�!F-<4�n"r�/�)nP�	�!���{O�x!+�4)9=h���a�pCga ̢�X/n���������"����5g'@C�y:�&��S\Q��홶�2��2Y4 ��j
@q3 ���8�o͍�(׻��n_R��m�"7��]�i�[��ҷZ>Z`x�`��3� �RQ�BD Ţ�0mw��U�`4��f����W�P�̃���_��xZ-Ϙ�a ��$5#�ڟ��QP(�|����\�� ��d�=`/-h�0�R��1gF�KD2v@�T�)
����2��oϴ}�ub՛y��j~��<�cC�] ýh=��+^>�����C��d��ZO�W���e\��{��SU�{r��˒�J�1���`g R��Zk�tn7p͛Hǵ�5v�Q�wؚ�W�9���{'���&
F^�_X��`2Q�W��BMC��/ ��2̵T� �L<��m��i��]�-`�4O��B�g��W����gڤ��%����`_�kJY^Щ�j�����d�b�%��[(�����2�PN���eKJ�7���f4�^�p&�!�1��rE2Yz&�=��M��<��kU��M��4� ��HhKoL�3I��#��@PhbbH�������38���"��5j2��z+C޷23ԀfX41��,�%��Ac�OZ!�^&��2�=;�P�v�������������޾27�uƮ�=qt�gCY�n�DF^ �\3Bt�jU�ƇG�"12�xb�U�u�;U����^���Â�������K��?�_}���Y3o�y�a�Z� �B�t ������ )'��\S��y��T�b�4T�v�y*�Z�l��[�1�V���#���5X��ֆ���M��(��Я��+~�C��)���C�%����0�� n����f�,��# )�w�8�EFm�lb�xC��Isn� �O񨭴|����F�r�iv�����q�>�_�X>}}=��y���e�^~i��3qr�bH=�w8�B�=��ޗ в�����%E��/Ѽ&-6���lؽ�_~Z������zؿ��ƻ���s���é�z��a�g\��6m0Cㄵz��p�^�����ܪ׭&I�惘wv��tNT�~;�K�����.,���睷M�̥)�,tK���>=�>���8��h^%`���t��{zhE���D�ct�^��v=@U�1�>Q��<#�h�p�r31��eDď ��f�Ci� ���+́_G�=,.\�\�6�(�6 �D�9��Tm��!e�� 7LVCB�bP���HZ��Z��A#q�Yd�;ht�7PE:ы�*d�4:S�d���9�`ܭ	��P�P��ڽ<�������Ю�=�G��|� ���ń������M~� ��Il~2B,:��Ƣ����iDL��,.��xɥPBáv��<����OB�8��o�Zv#����+���l>�m�2#XRz�0���UV�,��aKl�D���փ�c86xpoݪS��T ��-�2��lT:��*Z8�&��;�(	�lR���c�2:+��| Og/1�Ǔ6����T}`(	���������2ے��µ��蒁Ӹ��m�3�ϸ7�g�b0Z��}�%e�&�$�n.��z^�;R�:��).���Wx�:5�N�Y��.�ooIf{��s��9���\s���� �ޥ$b����B��"���#u��*�gA�/�^2.ɑʾ��~r�dl���/	� 3㨫s�fZOmT�&}~#�k�4��GM�jE����� ?��D���]��/e�� �i��y�M^ô���)����
~�ML��	�b(�����b(���u�PC�=)�_ň�IOťO�����4��t�Qm,�|�
eZ�cS���>z��O1��46A:������1����n0�PR����.\s�%��$G�&���t[�#�8H���Je�!՗_�N^����?O�����L�%��M�
��v�M�`�i�i���gj���ௗ���K\�@�hB��`(SOɑ%v���ҙH�X��_�:9��(uj��I�#�/q�)�SߐG�<�5�����Q��SW��Y�oM�O������i��������L��l�P��.zv�y��嗄����A�f�lN�̡�
�����xu���x;�@������^�����}���KB��}C�E1��6��L�}�Z�a;�q:�1��`�����v �%����מ�3@�K[�[�H,Ԉ� �4�+~}E����F���¯j��s׀>dORp�8]������"�H0y��3~���wċ/���ūmp�R�Ww8������*��L^��!1�ح�9$��c���+���@����1�GҲ�~��я��&@Q� �2�I��-�ğ�B�d,��������O������@��-�U�����^�n��&8a)��o�<b��Y����O�-�cI�DO-ZM��6A3��i���̟�U�r�jM��Iv�����u?��,������/y>��j64C�����v�OdNÍ�m��ò��ɕ��d%(� -  �"m�p��3j
�̄@z�Ԫs��$㚈~A���
	JBbNk^/�ubT�Y�	��4�8�'�l�m�J��&t꧄�	��"t�d�M�*����;����:��e8(^/b�};�Q��~:
���N͞7?�uv^�����AҰ�O"d�2��hp��։���W�VD�9p���8Z����<H�1ڌL�`�}����6���'/�P���jm��~d�(�t�#�hG�21�Ŧ�#Y0��ӉI���ҷv����.�.�P����_�N��4�@j�\��:��IU��x�ԣ��&�<!�ڡ���U�|4�h^6��Lx�o���2	|0[a�m�;��ضY"<�����!CϠY7-��s"�i��1$�%]^9T��ٵYj�|-c,�~I,^;��'B��͵y"j��͵�Y/���6�s��Y�  �%�t�cۗ�?�ec���_~Iʳ`����`޳���&��$���Xm�R���|����/�I�H�m|~	J��|a�����4ok�\�.�|ކ���[{#惡�������H�����UI����A�P�[���`(���6����p}���(ٳS����� ��f�0�˾q�D�������BɫC�[�*=O���o��������v�����؏������_����k���"������-@rZt�{���^}��r4|�y�������|$�4�Egr��7$�8����^�S(���(��yCRзS�X����]%'���+��?��G��E�(m,hgH�/���=<�GR�A��c�M�"$g�f"����v��)���HR[fː�o��x�XR�)�A(�����U�L�h��
ڢ��A�}��֣'î �5NW��w�_������������Oo�o��l�!w߿�V �	J���}��v}u�-�{Xw��߮��z�����@q����\���cq��"�\ $R��:3��,�O��|wuܫ��O��������|�C�z���k//ǧ󿒿g������<����MҬ +O��?쬫_Q�Q�j��PI�xM���WTy�X-k�������+�Ϊ���U��|w��郚z�m�<\_�?]?j�3�r@2��x��FOM���=
��őB>�+TN���+�JUu*q!P���)�<�WP�:��;��W9X}��Ð�zEU���V�U�I�PRPQËL�3ͶZ��8�c��;+kQ/�1ӷ��c�����k9T�&�����Fh�e�4��81����:G��FUDz}"*N]�;���y#�Z���lNM���W@��wzQ�QB6�ȹЋ�Y�y[
�"!���P+�� P�E��4Cm�Z%*
;�h+ђR�bUr��"焰� �AǨ(�l}�M��P���6��L���� �8A��)���Y��2�P-wVֺ��˚���:׳|�s�\ImJ�*
��Q5�|
��2�?�:��j4���V���m����x-Yԣ��2�-t�7(i�3�:+Qgqg��l���y���QE��@T�?�����ʷ��Ңs-՘M�CI��g}�%!dI�ǥ�˯�/�+q'騸X�1�2��A�Yp9=cT�T�u3��j�ξ�X	竟�`n��@]�4�\\C/��w�z�����j�W����8�1]�E#��J�a���J�Y��ܞ(W�A	Y��^��<����G|?Zmw�L�^���.Yƨ6P��u����Ыj�㙢ݣ�Q�l��ȥ�쏫�2���;�5FG1O�K/z�SV�4��j9OT/����aQ���X���0
ׂ���p=ӂUxVՕpt Gȍ�KÕt+q��_qQW[3��t�|t]l�\ԋ\-�^0Ϣ�j��Ih���v͡p�js'�j�+8�'�ϊ�|ZIQkF7z`T�%��j�O5��S�s1�B���Z�*�:-,W�Gx�o������vwӫ���=�w��VU,���
-�m 8����;.�+p���ׅ�@I�H�i�]"�����C�ύ�&7k@��z����W�
��,h1&.ܜkF�u	X�)�M�E�⨧�����~)�j|�d����ջ�����1b[j�D6ܧ ���T�Z�U���3��AWz����2ZAr��h� �o���,wξ���aW���;��x��X�s������0�Cp4]P���+�ʂ�;�]��0� �sAĹ0�ZC���K%g�l=ڡ*�gtbTd�X/?�a�E�����R����Q��Wc����h���9�aX)�`X��"�QK���
ݑ�XhhS�C�����T�W�
����A�z	U�����+�.�o`���q�W�����ګkA��q��%��XKV����	X�gms�@����Y�Š�Ȱ:n��b��H��G�'��N]��j�`)��V"�h��xh��tV��DTu�;n���qI"]J�}@�&-I��� bg���b�n�O�r����������qe���\.g\�B��1`w�&�8��51,���;.���3°B����)�R%�)��,����� qzB�
 ���kU�:�͈3�z��*���BP\i��j�gZ�/Vtr��=�GsC
���9�z F�v/�"[���*�> �
g���60" �m��+x���|�允q�TOi���=�h>
Q�����Ê�
!*2g}Xܶ0E�QqQU���E�Q����Tb��&/U�6y��$/�E�0�����r[�U�E�������P�-�)��F��܀��M���}ǰB��H���g�Q�nQ��b�
�A��:���<�h�!����Z+nΞ!���aZz�FŅ��o�\�e-���8E�QEǓ1��|/�5�����^ŭǨ�92����%���\����!��lw��X,��T��n�{�j4YD�/�,zg��i��KWSO����X�ɘ���è��vƒ]�E�j�!Up�X@�Q�Y�!>5B@�1�b�J(ί�+c`q�[�S�U�ZE��0�9d�D�1P�~Qq�!sǦ�� %�*K�E��5f
�au�StEAWQq�OE#�Qq�X��aT�5U�T���@�F�Q���0��]?�r� 5-�� g���|T�n�F��S�եAT5G�Ϫ�^&.��������#���΂wbbT�6���Mר��S��UF<�T@�������
��Å�q�r�q�i`��~��@c�E��kn��9*έУW�g�j.+a��0�mVp$��n�czQ4y�&+1��XT��v��E�t;FŅAT�<O�j��E�Ϫ+ӫ�F��H)@ಹzD𺸆JkU�d\bP��;����qت a�1�F�w���G�aX�40�86Dŕ9Z�΢Nox��4��^S�nKE�Uwc���/�g���,E�ň����l�����}6\@I�xBP�9|T��0,nz�b����bT��ZV����������_�6����]�\Ŏ?�*v�� *z�E� ?A�Y���\�M7늶��yp��"[��!Dŕe��+00�����ӧO�Z2�y      �   ~  x�m�Mn�0F��Sp�T���T(�$�
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
8���*����{��9����������a^���\Y���x���ӻ��󢼯��m��yQy��f���>/���a����h~���o�Y�������0K}^t�����0K\�|�2�_{��0K�~�}F�s��0K�{�q�fiC�� �l{h�0K���I����cU����˼�^���_�fi�9G\;6wy�0K��9�Y�xT� �?��!N      �      x������ � �      �      x������ � �      �      x�ŝA��8���/O��
@R�����Ԣ��7]��L�?F��[�-�-�����Y鏒ȟ  ��W���_8|���4_ү?���2~�"�db�CH���׿����]����C��_�;�I�C�
�����e�~!�O����4��S���������_�����9���$pR_N'��pJ_�4^�@�4�b�M�>1@���A���&���
�G�Ah�,��.�]xa�=���@{��Cx�2��2�J�����ă�=h��!���e��e`��2�vA���t��APN�AP�}A6�� ��X�����-������Ӈ ��;�0��taE��8���qSg�Q̝A�ac�X	}A��ӻ��'��6Ȇ������2��jy��F��|�tِ�ʠil�o�1Z���\h�����}��	�.�h����	�@�3zD^z�=�8��ߊX�oy��>��߿���p>��pM�~�^��O�!����#��ȏu��[������@�
��D�%)����!���� "�@�	z�#��A0,�:�`XHz	$�	Cu)��������6�~���2]��DCudm~����T����w$�w�*$H��SH��� H�Jg$H�3��	��	����{� ����{K�������d����2_ޙ>:H�-�����s����1��/d���e^Y�|��ո\�a�ݲl~���#b�rÊ��ox1�b�dH�0�_������x��u��i��#A�R�_�`N��,� |��
�]�e/8�1Ԇc���6]v�s�����Q���n'�௭���g��xU�����U�j�<+���6.U�+=�*jcUnp88���
�r
�ƹ��P�6���µ�078���9�5|�{|�Ǹo�{<�Ǡ3�{�c��=f�!��)�{yX:��b�4b#��ш��9#Nh�F�,'4b#7��p���	-=�z�p��J^9�yYn��}�p;��r�\ǵ��pە����⎞��R�m@�;:��hqGc\�F×W���!)%yi�Yx��`ެ�<�0oV_h��7k/t	@�;i������i���B�"�⎆m֤Iz�a�6��^h�Y��ᅆ�5Y�>h¦����U��(D|.<�'��E#=/�	px�n�>px�n<>p�	n|.p�U�/�\��S�=^q���P>I-�(�o	�}<V����F������V@-nTENK)�񊄮?�|�2��y��9��#%��ڀ
�̶a6��D6i�|�s�/����9]�������fT���	]n��7��h�ݝO�����6ź;��O��Z�a&wC����Ϥ�U�n,J�z!��V��ZRY�%W{I����q��<�)�j��@�h1�.�� �OD醘W݋�t<B��n��!��������������	��H�S�)�0#�<Sˎ�ʎ�컌D���l�v���F�z62��ةI��*ҋ�<�6p��F�{��b#��:�t�6t��;�O�Za6t�D6t�{��kE��еb�l��:z�Æ���φ����&tt*߮���yN�
�u�S�ry��GlbS��3�0��|�����h�Q����u6�B�&��'hX�!m�ws�2* p�'�p9���	�x:���p�� ��U7�M�M?9�p��{����P�AN��4��16�Q!O*��=��Q��I���j���ZDꗭG�,#J�(f���Wh�tP�fJ6l�����i�}A~�>}<���1�a4�O��x�#O�i=���m�##O��O�Ò�x��	pX�'�1��N�Ì�tf��*�p$I1��P�f3���
פ����pM2�
פ����pMB�
פ����pmR�
צ����pmb���M�w�Cdb�\r�JcTJ�O�Cd�� ��D=��v"�	p�L�'�!2���Q��%� ���Zd��5fTMe�'�!2"'�!2�'�!2b'�!2�N�Cd$�ñ��5� �rIW)�\�p���(���'�!2O�CdTN�CdTO�Cd�N�Cd4� ��h>KF�?�MJ�S�DZ��t�F'��\�T����c�ஓ�]G�5y�uB:Pfw4ҁ�j'4�u�B�Ƹ���@�;�+'�q+���	dI��i���lo��-%�5��m9�1_nC�M��S�(���G�%��2�.{+��H��� )�Ҧ|��-�N��г�j{�Z���hZ��	huGg��]�N��DOmp;�5��h�~�ȇѶ�HZN�J��x���9��������pfw44��;��sBC�Y���p6w44��7�/��5kb�ӷ4_�ke�0g�4"�Fo�#��)7�!�쎆��莆�FqGCH���!����Ҙ��H�ј�ѐ�s��1hhx{(�j&{vk���ɞ��Ǡ�f�g��1h�Y{h�j&{vj�F^�ʞ�Ǡ1��cD�WX�7�'��>����qݞ��ƸVvGc\ktGc\�'�:�1�U�ьBBrS+�z��F���|
4"7�Sx���9�������hD�nΧ�@#�ws>������( $%;�#jh{&�-��l�v�1h���ј���ј���ј�)��1_���1_����U sGë@���~�=����������Bܵ&o4қU�;n�5�r�g7W<����7vGC�-����&�hh��;�b掆�X�F#M-��a�ڞN�AC�ҞN�AC�ҞN�AC�Ҟ��A���=g��Fn��=g��FO�.z㔀c���9����3����3��1_���|����:�;�u6w4�,'o4��kS�����NhHJ	�hHJ��BCR
��!)%��!)mA`'4$��;�R�I)����쎆������n�Y�,wt���4����6����Vwt������������Z;?��4Ԍ�;jF䎆����f��P3w4Ԍ��_z�0�)��1��@üܻ\vBc\����1�������h�k��h���:�����i�#]v���<�0ȓ=bޗ�\�f`��y3P\=�������d26��d���G=��:�-�(J��gu�Z���x������f��јb��t��{�G{�,�;SLdw4���јb���1�b�Fc���쎆�W����Ǡ1�eO��c�ײ�h�c�ײ�`�c�ײ�X�c��"�h�
��H�c�0dρǠ�f��8�C��xe��+���3z�섆�hpGCR��ѐew4$E�;��l��BCRT�ѐ5w4$E�7��MW�B���!)�ѐ#w4$��I�莆����!)��hH��;�b���b�쎆�]�c��p��t�	5K�5K䎆�%vGC�RtGC͒���fI��Hi��.��ϖ���+w4zxfo4��Z��h<�>Mc�SL���>��;ﺰ;jV�;jV��r����7��Tm:o��~/����/4���&ʟd���@��@2�ey�iP�͈��f��S��d�����0�4�^�r3(��i�\�ŵ�o�o��j��{ȓ�ǯ?�"c3�}�Rz�i�m���m��4t�P�L����?rXo�I`:��7���r|���ȃ���Q�z3$���.K��Kѱ�ԧ1�����?;2�ّ�S�C�*oE���b�hE�e��cQ�rX���,�~#�u+ⷿ�e�o��]������m6A�h5�9\�$6��"�3�@q �mT������I�%f��H"-m�F'�l�	�h���4������wtZ��H�-M����U��k���Y"�4�L�;j���tBC�4���fmmL'4�L�5�莆�����f��hT�/m�%��섆�����А�&D녆�����А�����Җ~rBCR��ONhHJ[��	IiK?��� Z��ONh����,/�^�D�ew4�̊;j��;j��5K쎆��莆�%qGC͒z��(���P��R3�+zk��1hHJ*�hHJ�hHJ&w4$%�;���3������@ Q  ����<��ޏ֍�PPm]G>%~����ǥ2%�(�v_ZX��as�P{�||N�O�'wx��Piuj�C5iAA��l�8߷̗��h�F�UdyQj"���@:�QA�`�?�bR0��_�N��z>���hl�))?����x��ֶ�W����u�9�������6e�{�%|
4� �4���>�6E�Hz��A4/����qiG��� +Q����\nM��u���������?��摤q��[�F����k�����m2I�C��n~#��ʇͲ?6��h�1֌�4��Y˺f�6�K�[	�>����?i�q�����4R�h�d7����\�H�
wC\� vC$ �"��s�w;��L��������#�tC��"h� �B��n"vC$ �"���S�z!�1#b��g]v��ѭ����z0��B'�����⼚�g(�a�t�t���/?�e�}g�V޲;�+��,��J'6a��J@h)4J�F�c�Dž��]�/?Kc���ѷ��Wl�,eu�1��e�3�zi�U��'����z�9�����4EU�Ҟ�=���˲�Rp�>oez�p���ʂtr~G��	p\N�c:�z�I��j���,'	'�g��݆Z��np��v��\�	p�s����> 78�y�u�#���p�g��	p(\��ӑ�np(���p�-Ez�¡��	
��R�'(*L���p�1Ez�¡��	
�:S�'(*M���p�5Ev����F�������!��P8�'��p&'�!2f'�!2�N�Cd,� ��X���p"�ց�8
�I{NY:
�I{�Y:
�Ir"��8D&�9{�(8D&�9��(8D&w8#��i���L�M2�ժK��$���z��ı�ă�g��4kP6������������EH+���O��X.���V��8F�����:�.�{���$k��'�a��f0���O�U�V��m��v�gg��?Cϊ;�VH���T�D�%��;�?��VI/6�%�?ڒ̟mIɟmIٝ-(p`q}f�nU� ��j��H;��cV�7{0~6���EZ�q�RHtM@n�ɜ�"�eX�	���&,n~ܿV���f�9�%{R�ŏ����J��'�A�}Tݦ�k�j��
��IUPՓj��'5��֦�PKK-ukd�粢6�D͠fOj�8R	�D��
m"�B��=��&��Th�'�D�I�6�=��U���7�[e��6rE+���^�?Ԇ�Ԇ��1���X�7 �Eٗɢ��Ŗ�z�ʅl1�r!\̾\HG_.d�՗!a{�m��T�eG�[����{��hm
���ySƅi�~������|H��������<��}�<E���;�����۳98Օzm�F �j	��|0��X��i��i��f�O"F{��^Bġ@��M�z..�]\&xi}L%6�O�?۫'�q�r7\?m��`v��	A���[�]�8���cD_aق�mA#ME�O�#'!���I�r��YO�#2��?!���^Z�j��/���c�[�3��e�k|<�:U��Y3f\��)`ؕհs�vJ��E%����S�<vAb�BiF|p�vhp#��N�[U���4	�q���u$3���#��!�������!��=��WG#P�C�B�"P�qل�w��w�;�4�;U\�z��Z�����i������l�Fhf�n�����)vC`�%���J��q��BУ�%���z��v�y0=�]^�@�j���&Pǘ�:�k�����{k��Z�.;R�[��PQ�Q�'�E<�(�(�G����Wi��E���:�JMAw�y����cC�#"��a�L~ڐ8����+�9{�ob�	�i�l�)�@G6W,�;D㋷�CalI�G�DH
מ�:�m5�g�y�G6d|"8���=�#���R�(�UE�ݽ#*��`�\J\��*��歲P�)H�SP^��E�갹o���KR�)H�>�V��6z�-�A�#U1�i�b�)yR�U��b���I�V��b�W� QyL]O�:�@%�R7��Pg�\����ܝ̗��/��qא��/�>�J�#� <�#O*��ؓ
��I�`2�B�L=��+3��^�cj��U�j���I�ضR�2C[ 3�F^�/q�\���j��.�[z׊�~���M�A��!�M�����xϗ������辷��7�����A�U��[�c�Zqc&��d��ށ��Ϙv���L`��@N���9ӹ%<�ģ^��m7�<m�8��q�(��I���VS�������o���LIw4c\?�|����R�Y���M*HǕ��B<��H����T��0�M�37�5�f`����i������ȵ09Sxތ�ICաw�Ө�Jml�D�7���x0R�hF�(2;։��]t��ZKk��Ѓ�(S��� �U6�����p���!�ÒK7�%tC zV�ѳ��������Y�nؼE�!`����7��Xd~����n9>��_|0k�v3��,ڝ�#`��ۄ�E\����c���b��K�a\pj����]H����z�!�0�A�U����G�]�Pzu��1K��F�M��	�ZFm�b�O9���{�������G�!?��$��>R��؃�(�nN!��ȥN�ފ
)!�3�����M5s��.�xÅc5��~Y4}��m����������L0/Rz�l�"T�"�����wd�^�k=]9�I��fԒ!�֭o5cZ��LI�f�T�r�m�#�i������e��+ͨ��fT�H�-��f�M������f�X\mf��;��}�E�hF��b����kI��<	����a������� �ڝ     