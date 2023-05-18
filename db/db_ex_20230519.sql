PGDMP     5    &                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    7    307            �           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
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
       public         heap    postgres    false    7            �            1259    18083    permissions    TABLE     l  CREATE TABLE public.permissions (
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
       public          postgres    false    7    318            �           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
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
       public          postgres    false    7    268                        0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    7    271                       0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    7    274                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    7    301                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    7    305                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    304            .           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    7    303                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    7    311                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    7                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    276                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    276    7                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    7    279            	           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    7    321            
           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
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
       public          postgres    false    282    7                       0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    7    299                       0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    286    7                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    287                        1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    7    284                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    289    7                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    7    291                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    294    7                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
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
       public          postgres    false    313    312    313            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216                       2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            (           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            1           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            3           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            6           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            7           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            :           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            =           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            G           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            M           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            Q           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            a           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            t           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
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
       public          postgres    false    305    304    305            �           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    311    310    311            �           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276            �           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    279            �           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    321    320    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            T           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
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
    pgagent          postgres    false    323   j      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   �      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   �      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   W      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   �      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   �      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   d      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   .      b          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   5	      d          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   )
      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   �      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   �      �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339   �!      f          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   -G      h          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   �G      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   i�      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   ��      j          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      l          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   -�      n          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   J�      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   �       �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   "�      o          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   ��      q          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   �I      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   QJ      s          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   nJ      u          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   UO      v          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   rO      w          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   (P      x          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   EP      z          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   bP      {          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   P      |          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   �Q      ~          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   F�      �          0    35031    period_stock_daily 
   TABLE DATA           �   COPY public.period_stock_daily (dated, branch_id, product_id, balance_end, qty_in, qty_out, created_at, qty_receive, qty_inv, qty_product_out, qty_product_in, qty_stock) FROM stdin;
    public          postgres    false    340   D�                0    18083    permissions 
   TABLE DATA           m   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent, seq) FROM stdin;
    public          postgres    false    235   ��      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   +�      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   H�      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   �	      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   	      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   �	      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   	      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   +	      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   �	      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   v	      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   �&	      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   g(	      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   R-	      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �/	      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   �0	      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   �6	      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   �6	      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   �K	      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   �R	      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   (S	      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   �S	      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   ~\	      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   9]	      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   ^	      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �^	      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   _	      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   (_	      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   E_	      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   ]h	      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   /i	      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   Li	      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ii	      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �i	      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �i	      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   �k	      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279    l	      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �l	      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   ,m	      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   #      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   Y�      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   ��      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   w�      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   ��      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   $�      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   A�      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   ^�                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 15, true);
          public          postgres    false    207                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1966, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 3150, true);
          public          postgres    false    220                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229                        0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2663, true);
          public          postgres    false    233            !           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 517, true);
          public          postgres    false    236            "           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            #           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 542, true);
          public          postgres    false    317            $           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 85, true);
          public          postgres    false    315            %           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            &           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            '           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            (           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247            )           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 339, true);
          public          postgres    false    255            *           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258            +           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260            ,           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 55, true);
          public          postgres    false    263            -           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266            .           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269            /           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272            0           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 15, true);
          public          postgres    false    275            1           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300            2           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304            3           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302            4           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310            5           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 60, true);
          public          postgres    false    277            6           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 13, true);
          public          postgres    false    281            7           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 8825, true);
          public          postgres    false    320            8           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 6, true);
          public          postgres    false    283            9           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            :           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            ;           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 90, true);
          public          postgres    false    288            <           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 73, true);
          public          postgres    false    290            =           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            >           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295                       2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206                       2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    208                       2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    206            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309                       2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210                       2606    18467    customers customers_pk 
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
       public            postgres    false    313                       2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216                       2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216                       2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218                       2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219                        2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219            "           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223            %           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225            (           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339            *           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227            ,           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228            .           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228            �           2606    35040 (   period_stock_daily period_stock_daily_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.period_stock_daily
    ADD CONSTRAINT period_stock_daily_pk PRIMARY KEY (dated, branch_id, product_id);
 R   ALTER TABLE ONLY public.period_stock_daily DROP CONSTRAINT period_stock_daily_pk;
       public            postgres    false    340    340    340            1           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234            3           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            5           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            7           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            :           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            <           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            >           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            @           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            B           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            D           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            F           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            H           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            J           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            L           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            N           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            P           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            T           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            R           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            V           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            X           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            ^           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            `           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            b           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            d           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            f           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            h           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            j           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            l           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            n           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            p           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            r           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            t           2606    18551    roles roles_pkey 
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
       public            postgres    false    311            v           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            x           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            z           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            |           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            ~           2606    18561    suppliers suppliers_pk 
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
       public            postgres    false    338    338    338    338    338    338    338            Z           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            \           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            �           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            �           2606    18569    users users_email_unique 
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
       public            postgres    false    294    294            #           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225            &           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226            /           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            8           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    208    206    3598            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    219    218    3616            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    284    3714            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    212    3606    219            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    225    3635    235            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    274    226    3700            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    228    3630    227            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3714    228    284            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    212    228    3606            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    240    284    3714            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    248    3662    254            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3598    206    248            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3714    284    248            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3598    250    206            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    3662    254            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    254    261    3662            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    3682    265    264            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    3714    265    284            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    268    3688    267            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3714    268    284            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3694    270    271            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    284    271    3714            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    271    212    3606            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    235    273    3635            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    274    3700    273            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    284    3714    293            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      b   �   x�m��j�0��맘��dY&�m��d;�,�r�!����j��Rz�Y��OR[s�c`�kG�z]o�����}��Eσڣ��<OE�
	�3Ei��
��rM��d"�l;p��<t#�C�%�'p��!��.�T��7? �ڍ�ў���H���WiQ��.�0jkt�o�����_:�xf,|�<�3�ԧ��h�Ԏ�{�ѫS��,�TF��Y�uɒ$� `IM�      d   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[�\�q��ǿb��~��HP��t@�q�@�81�H~~Z"�S���93�t�O~�@ԅ�U�V]v�}~���~���������o�Z�w߽���B,_���W��XF���W��mw���������o�����������]N���?=~�������Ŀ���ۇwoO~+���.~���K,���9��I$09����
L0N4�@�L%��Ղ������?>c�	L��������o��}�������������o�=>���G~���$�O�>�L�_^D刄�撺�
&����#�M$�I(0&7�B�LS�r7�PužB�1aif�6����钚T��}�gc��$�tR�W���0E�r�$>U�-�U���3��ӛm������?p���Ӈw�o�=>�}��pW>����|��EtI �,)�Bv\����A`**;�⪒�dRQH�Mq�$ES���n��2Mg�LR�J$ɩC�0���7Gl��e�k$PQ� ��j �;q���vz��J�� �:�\U�c�׳X3��N��2��k�mc�H!�Q�{�)i�SH�I$0�t�P�)�;I�
�����84证D�BrS')N"Y&��ˢ�2��t,~� ���)_eԨm"QS�����iBPQ��e}�?���w���O��?��p����~�����)�}?��S��2��ھ�/{6�RZ%�.�5�Q{b�)]T�\7d�ƿ&��~��矯��
���R�;VF��R_8I�{#�I���u�\���lM;*[0��<R�<�T�6fFm���J� uT��ʥ��i[{Z�~ks��z���/��F{��d�
�Qc����6J��w-39*TmO
b�}RJn#����=���j�
άK���J
Uv�'��t{�"E���Wq6.T�[Xs��$$�Jj(�"�]*��Ҙ@`:�2ř)�+\X
�q��
���`c����q5GQ�ua��S޷����m��ԘK��ä�"B�\$.R�YH=L�V]���
�^�6������8I��tȎ�%&�*�$j�e"�u)�&�#Jq%��3�h"��fkA�N��D�*���r"Y��]g@���H�H#���|�|E*�I��"��[F�	W�	��H�HgՓ9��X#�)����:���P[���� ���ME�x}0�h�_��ubl�I��H�6I�5k��#.�
����7�(]�Y�ԧ����5�B*�&(��I��)OT�
����?��u�BJ����cEO&���g��`�� 7��LW�3��n6��+�QW�ǳ�]��[��,c_5����LS����\�2W!�(�"���2���T���r0��	UV�3��-�L�PE�"�\�[v�5�1�`U��(��1*���mW�[Q$M��Y7E�r��0�,cڽBʣm_�m�
�)�&E'�a$%L�~/�J������Dy&�GTR`EҸ ��� �9�b�*-&��ޜ�T��?���훻��4�~��//���"Ɍ�ECf�}���4�T�e��R��n܌�j:�ݤ�v��-��SQ�:��*��P1�4:��\�2�4��-�u;1j��[pm,��͆�i��[&�r&�
w�ᕫC$QL�ҽ�r��V�fjI�9+Fm��jJ��ͤ��W$�I�N8J�].iH��D�걺��1�`쒭L�q8��1��2�/��r�g�w\��]�lk5{��6��W�/sEѸt��U.�㧞PҫHJ��t���.�A�MR�<�(��� ��ţ���$��R����a�>\(3�q�D��ܷ��X�g	�Q�H��C����-�v�U�}�7��F�9Ϩy)�+(A�Ӧ�uݴ(}�"�Wsha6Z�[*_?����-1\m^V�kfS7�Q�0�B��JG
PAM��CI���a=�H�&.�e���!��h�9Nڷ���F�d7"�+ziHX�TEf�O�$�f�}cm��4ti��jO�����T]��;���e�	Ӿ���Њ���T��,�6K"�cRyX���I�:ޫv��P��#j�,C��˞I�|X��kV�6Z7t�&�c������k��gO�*hdh%��%�T1�N���=+(\aFU��L����L:�i��4���<gf+V�Mj.��rXg�B	����i���f�Y\I�K�R4{U �\�Uİk�;�$k���3��?�量���C���~��������}��t���O���<jH��ME���N	Vd�Af�J	˴�*1hL1hL�\��~�Q��Gef�EfR�bky-h*�&�?M$�D�!]�<�Pጒ@���eh� �t��H��:��t��H��@
큜{�
a`E��T�f̊�R7����^E����~9v� ������h�y�r4�L3L�
0N`��/i��ɼ��L�1k� 7��d��*�2��,���d�}�[&���� �*� ��'�rHr`I��r��j�����%��\0Lz'R�� �����ƚ�2}*���"����D��Tt{.�и`���RH�]@��>2��J�է��pm�����IW��2o玾\�_�}����U

l4"H�GB��
��gj0�Ru�)IA͟@�|#���}��ֳa� ���՗���QH�a�˞�\��}�M>+s6����J�6g����`���+zԤ]�h�Nl2��ж�&+���`6H+�F+Of�w),wpH:�L�eҤ��Z��u�k#�H�laa��)��}��'(���TR�ZQff���#��g%u��Ksv����4�D徸1�q��q�d�y�S�mTm����?ϸf/]5�S�#�튤z�!Ŕ@	��IjH3�8�4�ͤ����7�IqV\w�$OT�NJ�Q�Z�k��#�T���>��lm#���c#醙WY2�6�� �����?�8.����g��}�l��,�x~J��8��c������F��^�ǚ�@u<hC��x *�g����&G~f0cvR����cϢ*��8~����t]���A3Ȕ$WO�yÁ��%�D;�+C�L2M&5�m��u#i�-;�I�L����+{��ط;�X����`�D�7�o��
 �T�!6#iܑ%��g�@��j0�z�HrĪ	�:���UI�kFI��AM�
��(ERkx�}_4'̙fEI5�a	4S��=0�*lR�SQ`��ƌ�zl�*�D�sc������,�N���<&rz9i��Q��^�R��rG%,dR?�O)��X������hř�`��l��V&�a��:�a��Ahf�$N��L��� լ3���n�{AT���䰊JS��g���gTV9�2g��:1 {�����S9�=j�A�U���qP}����vo&ҡ��y�d��̨]�G���,x9pfIn}}k��Q�ή�h��gT�ɨ)�;'����laA���w-,�Z]�D��0�5���	i-[N�`�:"qN�@x�%�SωM����Jb9u�ź�Q�|���T�O��;�"��ZX^H����HX�h��n����l
X�#1���ى��%��J�Z�0����u{9�1ja9N��0�H�ɭ �%��1�%N>�@�@��f���a8�f�Z��VF�*LnE�=n�,'~��O?|���?(��~������iܻ�}��t���Oo>�(���e��̨�bz_����u<�rx��e�9a�DXl	��Ӗ^��Z�z��c-������"�!�e�ZIgajT+H�E��<�d�������Ŗ�
S�2S*3���Q�X+�#o,�A���8q2�h�(���؉���x������@��D�HXv�J�7�Zi-�� '�G��-f�+��Y.�����n4��]��	�@�n��<X���D�;����`�Ʉ����AKy�Z�<	d-�Y��u�k0���¬�
�ZU��ae;�� X	�^$�[벜f�9��-,{�)�2����*bF#��.6V��j�2��|˅5���OߜY|������~����3�O?�-���q�vt��"i]�2g�E����_� �5�`�x����)�><}xw��������_6�?���_.z    ��q��|����Xm a�a�LX�y��e��ǣ�,N��	,��V]v��'��v�k�����#�$0���������1�p(
�x�n�ָ����z;Y&}vX��|��WJ�gʜ
.�X���/�Zi�V��ra5��ԉ.���V7N���Ykv"�N`a�8��Z��!2րr�!�5��H�Ja,;�m���Lt���J�X����a��g�����x#���c�����W����9��6!V��n��.�+�ZIj-7�0u+kuk]$R���ec��Ff��������|���hu	��<�V����z͑���A�S]$��ku�k
X9��ü�r�HX��\9�vd-[#`��;p
+ aEh$��V\�u��š�%A�׼$(�g-�"�p����NL	�2��܌y�� �!a����DbKLX��^��V	���ܺɣha9N�����J<�e�VB�X+-,O �Zb��Uyh$�P�[�@�8K(vm+Oíүd�da��2J)	��h�y@�򵸵Q��2��_L-v�Er�@�*�H�'u$X�	k"�[�O>�@t�[���B������8��%X��(��c�����"����Հ��r�"��Z��U��B*B��m��5\#T�ֺzj��1�$.�D,Vǉ�F��K��J�6u��_���ܢhgM	ˎ@��dr+#�βAN�b'z���qk^�[�fB�n���M>L��}�ɁeW�.;��T=1�ɵw��bErk���Q� aً� XS�[���[ �:~vf��k�a��o���E�)`� V��� �u�)����g�aa�^;=ke�Ver�i��J 0�L����Q��/b��(?��*Sk-�[�rhT<��Xk&���5���ѭ&�����HNPXm	�΋k���],T,��;�����5��򞵘�2��
Xγ�=?����AV��r��͝�ɄU���"���]�nT"�&B=��\'2�e��EΫ�}�R!w;UXˁ�VDr�'&���5�r$��n��os~J����zq.���}N�b����3a������E9���B�e���r�e' kE1����+Y�����쾻�����C��tb`��i$r�U���ԭ>���,����:-l8�JHX�ʉ	봖���ia��V;ѫN��bFb3r�=�z��t�+������wC��'�d+>��u�B��+���Ӗ�s��a�#��F�?S��C�a����-��S%��F��펣�=Şe�a\훰�JN �IƱLBI��H���'��-'6J0)	�=7�f���*��e�Z?y�����k��i�����4>�� ��4T߷oٚH�D�D�G����í��N�̐I`Ҿn�Zې���yK$���M{��|U�f��v�L�A���Hp�1�ڍ�u�>� 3%��ؓ��q`�ԥv��vAdm�#f ��y	5F'�O'Yf�,3���F�/��D�*�r�!x`~�e)T,���TúC\L{6� A�"h�}�����:oH�zUs���NҞDr� �9-�0�i���2g"q9�#��4��CL�Q�K2���e-��2%]��v7TIQ��n���s�'L*���£�`
�f��!�d���4,K����l>���D�w�:��n�0�P��ra/)_#Q�f�����tfߚI�����џ�yN�KR��5��aBݷ����hЬJ�����Jb�y=}����y`Hۈ��bQ�h��l5R�9)���9�6��vF)���Z��TcU��MC:
[1�R,�P�8�5$�_3�P�17Hi"����cT��(��'��JӾ��oe#LU��fߍ�2���V�����4�i��wr0��B9�2H`n�b{���4�1	�>� w�=U�_ff,TV'�{��k��z���&3�X��O��yu�L��ڵ�L$I�ik�I��̵�=Yf]ѡv����:�f�i*2��I}��:2�7��,���Η�U_�i��Pw�$7T� =@�qU��י��Ż�7�Oe��Ӈw�o�=>�}���������|����Z�4m�t��4�$���"��C��+�4���T� �ڷ��21�'�0ל+_����l$��y30����`6��L�"�r`��O(�L��+8ぱk�rG�깜�(�Q�i]8���"oZ2����
�sm��Pː�E��Z���N�>(�M�Sb8ӥ��*8�����*����s�Dpr*�e�m�7Z%���:��e E� Mm"�2�P2�ܤ(�7Ldo�}`G��7H����:����� {c��d/�:	����n�k&;��N�*��4�k�r0vASƾ�(S�uӦ��Cp/+����
�x6��ʤ�0H�U�q��If�E�5&={Hٳ�ؓ��r6ƕB���XA`�2�f]����$�)��C�Ȥ��[Vll�)g�e�Q�뙔�
�a]1=q%�&f��B0�Jd� 0��gQ��n�X.rn���=��^�^�T���T©�uG"��Jֺ�mtH������F��t�I��s���}�pk�"���O���J�I���g#�4�����8�%N����j�� %�D�߅�A*�	L#�^F�ڕM]Q��`H狙T�d����śY&����i0�\Fփ1W�S��s�,��md.���$�Mf���H`L�p&q�����M�c��41x�r]����q��o�v���ɋ��-^�8�PT�n\+<䒗T�P���.�P�^[��/s��w)�̹�!�$�H�¥�����=fR�W
3ޗv�MR�G�Vf���C�#��'�bR&U �d�BR��o��v��,�5qcjM�1�rV]�QoӧGE\�,Yň�`���(ln9~S��u����$���)F�n`)2�W$0�44M��l��ќ ���R���Z<R�T44�Ğ�uF�")��(6$AR�������L:��r��c/M����*i�(��d�.R{Q5�bV�o��.#`�&���3i��ߺ%\LCzż�UH�2o����$� 0�R=���L�(7�z��$q���	��O��1�ո�R�Z���V;G`��-)��O;�������yh��icl��U�<��>g�\�H��Q�C���$9U��ܔ��;���$-����d�AJcߔ����(Ґ��S(r�!�.֢v�*�gX��~V�Ȯ����-��t2�>��2v#Wo	g0�#�z7�&9{�E�&	/�H
�Q
\�)3�'K�W���)ξ�v��,I5�1�$9v�T�`�eJ�;S��=�ĞL*rb@�'������`�2WB���%��<!$���Ԕ'T����,#I��e$��%O�DJ�D�H���D^��Y�F��4��w!e�ؐ�z$�(�j�H:
����0qH6:=������J���D���'Y&��EB��T�}���3�rM��SԦ�;�r0�d{��`2Cd��/����Cb'�mҔ�ɾ���r���VH`*�=}����m\yƲ��:%\U�p��%I̋|TA�1ͪhS�>$0�s���o�Y�T97RN�$0�"�DZ�M'oCR(z��ģ.�GoԌ���4n��a� �(!�:t��*I'i��H-������T$��"S�����N$U�*�V'1	��7��G�3�=	�`P�!Qy�[6o�c6�谡ftABa/�����nКk9�+ftM<��<\a��l�'t D*_Wğ��W�A�6���$c�UKu����#��%�dm�~�呦�����F���"�r��Q 5���N�<qź�G$0���v	�U�=�'���))�/_(��^n��	�l�7�Y��n����c�b���6��<塅�Y��ձV�ѥL��ж���PȐ�������(��Ӑ��'��
0�g{�R�&R�Qi����E�ܔI*m�r4]u��9��<1���:��ޘc�N�I�I�+	LgR���EE��0R\5TC�W���.,�*o`��Fgs9u��
��+�/K�a��N���	U�
���d�N1	��"���{��li�S�$�TP�'i�=H�j&Y��LwW��
	L)p	 [  (�pϫ1�����0+�F��'бI�j��%�I�&T������\¨ڳ6�u$%,�p���ѵ�<V��1s�srm���(�(0��<H�z+hn�}�� /�CI�I���L�weRB��&�&�M��A-g	$7RhW��/g6�-�$4����5�Em{���IQ�HE� 5Q��Ԟ%�x�<=�/���)7��s���ul�D�'G�0X�	K�D�[��ǳ.���V�%D����='f��
�[��u{'�J>�����q[��[Y�/�*6���w�Q��&��jHX�#a$��5,O 
҉�c����Z��t�d&�.���L'v�K˩G�������B�U�ҍ'�ZcXXk�fd�ޘ�2�)�0�l�!�*RXn$ja���:ѳV�RރU�r�r�2�Ց�j�
�[7����tb�%P���&��r�+�Z�Y�v�@�gnŀ�U��>
VFC
ˡ|-�ܚ������?s�����0O�>��������Ǉ��|�w?���_^d(��^kHX�����ß~���>d�t��ǧ��O���w�?<����ˑw��/x��d^���$sBNrYa���8�n�Yk-���fh$"�2��f@m�q�Ȅ��������ml��s��䓠�Uy׉?�ע�.�#�M�UT����4T��sH:X�K�r�5+�s��Y�Y�N=<k�~��l����'�ɭՐ܊L�H	I��̉]�D�Z	kL&�3R lѬ(l<n��@�[bʯ*)W [�Lk�HՂZ>BukE�#ЭА1��z�º<if�(&����P�M$,˭D��qj5!�U��fs�d�q$z��g�΄՘��Lk1�AS5T�������iDZ���tU�����V�h�}�=v����ޜ��� �o�{��}~k���r�����ҿ�Ag檱��~C�y�ezl.º�i"$��{}[�E[H"ȼ5w������X�c1qi`A�%�D�$���-{����"�cm"î1�V�o��#�\�Dk��lOl^8�hW�@���$Xv �U3�y����5�Pn%$,{��ՙrZ��ؙN�	+3�5İ.�[#j#ѹ]6���!���2�=�|�-+�$k����wa5$,�0�[���Nl@�̧�b�pk�x5X��TGZ*V�2ۚ����ԁ�~=Km��$s�K�"���@��"ݧ=~R|&΁e�,�Z�:3�Z�[X��c�X��[Q�u�D:1v������gy�����ҴG�
X���}�C�(V�˰ܲ��e q�V�$n5&���S���
'z�b
De�������Iy{uĭub�:q�8�ZQ�^��P�*"Q\z�n����~��_�?��!      f   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      h      x����v�H��{��z���݁b�1��`��Z�&��j����feU�����p3h�02�3���/���07�C׾�ޜ�ov������~�m�U]���띯�wu�޹��?U�Ou�v��Ct�����o���H,������v7b��ݟ����?T�Cp�����|y�u�>µ�
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
��'�v��N(�B�H��`���N��0��]{K��l�P    P�h�@��ѼL�.5��6��`Jv���CB�@h{�|�������?���4]�jT�~ۻO&瀬&'�R5���nw������O�a$S��W�cC�C�oow� ���#8iG���qK7�mQ1,4�$γ�Lq6��^�V�0�&wP>�.ɬ��bB�PZ~�א����0���a><,YId6��g=kJ�b�����?�f@i�d]y�"4%�������O�a$57�����Ɨ)�����?��
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
2j%4��喭�K��2�+Y�#5�� k8��Y���,���f�k*s�qԔ��������ȭ�a 5��[��E�a t�N��ƥKU�$�a$ܱ�lM_����;U�H߹����hj����R�@"w�0uaIVS>tq�&4�������-A#PK㠓���c��幼�Y����k�ܸD���ǤH��#;��xd�rBI�r*�|@6��������̝���)R��OD
�>ސ.�ht��D�F�h#��FW���d�Ɓԩ��t��V�`Xf���d�q0M*c�A�l��8�����R�����ga5�Uo 
�4�l���89_O��q��/��8�NW"A���ŏE���oA&���=��D5�D\��ۂ>��z���Ƒ�	;���ƥ�aS�(��ux�J�\ړ�G"����qm%1���g�����h���B����
��qȸ�m�mh5�C;eg�#��a5�C��=>�n��Cb/X1���#�F�PtA�u>�_�Ь����8�Q'�}E�D�M�!1E�m[/�7�D�7��q$u�����mv[��i��i|Q��(�*j�Ӟ:����D5D}�� գ�ն���Ƒx<ƨ6���O���1F��m��qr����?��I`,j��9�����"�5�c��1lO��Qڠ%;9�,}��!�m�'������?pz;��j��~�jY��h��8�q r�ޠF��e��q���(u2�?o2G"�}$n���k��n���c�.�m�L�!����Zi��f��5UQ�h�j�z��R+�T*;@�j���	Z6�V]��یF��ڮ3Vْ�ڄ��8��z���j�UE��<��yF�����<�� qeׂ�{�������Ƴ́�89gw�����8�- T�m6�jH�/�T���z'F�@ͷ��U)�����i��>������5�Dv=�y5ْU�q u���LF
V���G".��>/%zCQ�@\tL�X�7���F�X���b�`��8��k?���5E��.�6�&�ط*j������Ԋ�]�u�Ʊz��������q(c�����>���[�(�ج��P������`ݜ�I�X丽L��t��lT��8퉝�@	t���*F�H��=$n{�&�#i�я��V�mٶ�89l�?v�hd��a4D�a���l2��8�^���PNR��Yh�hɠ�c{H���C�HƸM�
��Rz�7��]�Pt���2P{YU���8�:�V�F4�PiRg볬ơ4)	�|�������ⴛ�,uW�8�8��t�|75�e�c�q(:��[H�J���e4E'Þ����^v��Y��h���b��^��m�j4�D��<������Y���#�f�7��nt,j�XU��݁���ơ�q4T痬���!C]����Rx$��t�R��a:�吝��~�8�6�$�KӸ���H��2A�^���PX�q ��>Ώ�tW�Te�#�F��H��P�q �҆-����c�v�+IG� o  ���Њ�v�n`F�@t���pCJt|��w������� !��5D�_�w� ў?W�8�,Gd�@4�n�:w����u>M���I�>��h�z��j��lȈ��k4E'��$��'�q$�Ⱦc-�����8���`~�Q��5e�����y�>n����.�o%q�e�I����ƌv���Ɇ���р�~{4��	��m��vE�#��Y�#�d.�X�8�6M��2��d/���5�Eb���w��e�n(jG��$a���Bk5����A�$��5�D�Юg+Tc�I7d��'�C�!��w�XI��|j��(Wi��l�P���ΌƑԺ\��~�T�~LRe�]^;8Ƭ��h�)��E��#�,wm4�$6"\>�=�j���F�P�N�܋�5%UpAs�;ɠd+��Ƒ�1����WE�#4���`�^
s�-F�X4{��\F2[PX���"
�~�Q��1�|/P���D���h���/��B�Y�h��c��}��j+v�Ƒh)�t�
��l�eP�q(^� O+��]�j2�"����tC�}��dk��Ƒ�q��z�s�d�Q�q$rԾ�'(:�ThP05�D���q�b���X�Q$q?�s�ٛ��x�q$����$�j�#Qw�r����h�N�	�LY��h����	��!�U��G�4DN�_Vov�?���L���F�h��O�f޵�8�>���㯿��@:YJ�"�����W?�<����QhH� ;C���4�C[��p�ۣ-iG����ߝ�"&�:4�_X���!3�5D�^_����,�m�6�q,r��6C>�.�u>C�h��/�@I�ۺ%Q�#��4@H��:+)0��O�?����      �      x������ � �      �      x������ � �      j   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      l      x������ � �      n      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
j��������<�?��KX'=��W���Ĉ�A��w�?j��c����N+�gk�t�7�"��?����]LL��)&���-U�K0��SU�D��a�.�h�����v���H��u�S���~�� �GwG�u�KR�J�����c�dF$Iw3:�6�CK�A:�Ǽ6R.���I��fRz߸�U81�N8��x��D	x�y��S
O҃�zjc���\Mf���I�aYG{��q��b�7	���8R-�W1k��b}1&���������ƅ����}����4]g�_�=�M�bG�o�gh̘���~}]�]1��/_v#�~qp3�C�IP{ �����Kt"�S���򇎱��;l����;��̞C2v���x4>��B�cOV�igC���hӞ螝Qߊ{�=[p�Ӡo�1�;%�;��|���M�Č�_�qT�bL�bD�_�ɂV���djo���w��T���L���¬1CJ��c�ލ�w�F��º������b��<G]U���\Ho�֫����R9��v�],�̈������x�ǿ�4U@֛�_�21�("��-�ò{8aV�c�R��1O��ϥ5�3�����Iá7<�[�us?�Tg�p������s�dÓ\^���'����>:q@���J$�'�hx�i&޿���=�W̲Ƭ^�[ҏ���")q�b�o��tac�H�eLtcW�REY�07�6��Y��d57Z�l�n���%C �X�|�1*2g?.�c�~�e���#b��ab?��oR�J���1W�    S�إS����ۧ���T�y�]�W������1�g]�������������di
:.��*��ڃ���58+o���`T����p����{T���&�ao���>y�P�㓯�^�+	�)S����W�����ac��0.��J�����r�Wߢgl�a;B5��.�p�N�:07~���`�q!����M#�#.cDZ-���=���F7GT���u��1��>yN�(���=#M�ɡb�?�N�Ɖydahg���p��s��r!}��U��Z��Lg�ʀU�C���=.�팸x��M�6,m2�J45
2<���曵�3f\�=���l{�el�I�l�졻t,{�ʍ��*;<�6��H2Zg|�Ә�nww���M.�u2�HJ�x$��P�+..L=�/�X��5a�IX���?��tlǲ�I{m���ɮ|�	��}��,���1�}{\�C{5���̕Kf$�=�Ab�է(9�C �^���0��Q{#r�y[�b�@2�v�KƲ�����4��#�J�݂k;����5� �k;���]���������t��'�M.��d"����sy����
Ņᵺ��6�7({:D��f�p�?��\,ke"F�7�~I�쫊�U�:4�~F��G�pѿ+�E|W	[�>���J��׾m'��nP1K�}��aKP�	W˓��ھQ'���:��f\Y�u��ŶS����	e���	i�q4�bF�\-T��Lp�DސOcl��1NT�2��}���S��� �^��4Q�%E�ܳ��UA�]즕3�]�b��Җ-c����ڰ�>��Z_`F� �z�A�@D|N	3+�p* �7De�cJ��O	)3Oǌ�lD{�#�e+�3��/�"g�c���~��Jښ-ta=�ë�"l~6���3��;�3�����ճ#-���榔��)�܊��j=4Y����-`�F�Ȗv�R��*f
^�z?�8�a`T�^�ɹ���\�d<7#7�J��Ͼn(W`ƒ~xd*�ܿ>{I?��ه�G����������Gv
��2J�"��τ(G*f΄�p���{-��g�7���e��2��g�f�-�r�U��7�ˆ��7q��Qӥ�a(�!�g"K�F�΀'��!2������UI��&vk��d>(.N�qL)h{{�a����oț���peˮ\I޿J�k�Tv���yi�7�>@*�����F��q~��I �H��8���M���qt,o�_~���w����&���HcО��̺*H����6`���2f���\��}�\>���s�L\���w:~êb�nͤ������u����
�j̰��R�������3A.n����b�n���]`c/FԢ7�Y��A%����E�-��i�5�v9Kscy1^��*��#!����Rm�S1c�ܨ~:H�n9~���yta�p�2T�u-q·�15aG�0N84�]	r���4������M�t�4F�w�I�V�,6�/�j�t����.K|�Ko��hm����6=��,�^09�9�"�N�H�9�H�#z��n&���n�Ԟ����NL�8[��t$�x�Y�U�-��C�F��y�����8}|5��3
j������M��B��Y��2��y��ʔ���N?�OfH?��9H#0m�\���'e�׋>,*�}"���q!-��u
�R�3|��Jy,�zX����6��CtFu�ܞ��ȇ.���{U<��*��L#�1cZ"�����~`6���3zw�]Y��i~b�NN7CA���iV*fVz��;ݜ�cM^7���FD��nQ���"��ͬb�S������,�nWY@b�����^jz6�t�����&>x����E!�)�� $�pf	�$:��K���4GG�ՇaG��I�j�Y��t��@�W%�Q�f�̦bcWp�u��9���[v)��{3P���E>��a���jh��|L8~.S0b3���X`��۟��b�q|M�GK a��@8�#���#�?I��|$f�_-���q&���w�c<�K����`�Lz@�W^�Y�[��>�3|��q7��|��?��'c�i�'��m��mg�|��������w+=6�;�
�>>���cf_V-S,�П��?b��I8�f���Bn�\���h@:�s�1�ܸ��X>�^�'"�"7��1Ҋ�qc�t�m/Q��'�Z�ˈ�{}�a���c
�x����^�C�_�|�q���3�n��>��}b:���MjJ�p����}C�t�l*�^?���|���33 �u3���9̝��9-r�b��Nq�L�!&���W��r�+a�̅�'��U�j�q.�<�<jkd̞g�<^�ġ~4/�xDO���F,El�?���KKhM��AŘ�v��� �L��\#�*�J1&C��%ff䀗��n"j�b���z�wc�b�Sϩ��ř�q�;�G22ӤO���ddzr��32{F&�b��d\�dd2b��BR�kjk�x�Q�>ۮ�8y|�3|�B�<A��0�G`y�b��<ګ9c���i{ӼHט�9/ٍc�)8{Ǒ.'��o��坯���(`�}��z�1��4{|��W,+ ֟�k�O��V�y��� �Ȭ*�u��T9�P^�b���Ttm�1*7�^#E�krĊͳ��S0k��p�Ϯ��ke�yl1S	{���?}�T�}���/�����������P�ya�
��s#���F�[{=��z�
����&)rk{I�Tf뜊uN��U��]�V�d��XD��� -��bKU��q�����-v�'."�+�טN�nG|�	w<o򜶘Z>��`��Kg���9�Qp-��+Z�֘�D���
y<K�U!�G+�>(���B�&81k�k�Y���5�1���r. �:�eP��I,����H~Q(�V��3$V�%�cHf���g��􉃇��Eň��mC�����F��QۈR��m���}tX�e��$��0{�/����La��+r���2&�tZƅ�)�[������'غ�\�I댉=i[��l� q�q]�X`֫g�L���X-)�!�Ϸ	�Z-8)c�&��$���g����f�<��?D�������x�,^�+��"��B8���� ���Xs�A��"�b����"\���A�����GKxX+~U1��)2���p��A�[�N}���:�Sv����P�
���ߌ��n�E��9F��&jb2��@x�ck��_`ݶ�Z�XU�򨳊ٓL���Er�gТb,Rr]�6c4��h�M�e��"��$�����˶�1ڙ����d\Fr9�(�2��sƬ�6�=�#����=��q1��呏����X�ߚ��F�'"u��ĸ�IDz�@r�3���ܒQ�~N(}��뉎�����`ŉ�s+7YƆ��ט�7W�fQ�Z�d����=eCE�\�!�1k���{��u"��5���4B�U�
х�#�(yS��|e,˂����phO��2χ��o<���\���AD�Қ/�#Ĺ��45:�~��95�AMv�r-�V�����*����n� ,]%��XK0*f������Oe 7��!�Fgo=�'f=�9k�cb��c\H��F������*"�������0���!.�Y8�h �$U(��*3���)np�$. �f����{ZI�hG�7Ct�B���-�Ř�G�f��a���Ө������J�C����*fu2*��ND��ȥBf��U���As:֐x�P���xgv��I���I:�FD����h2�OlH�Y�v�wFg�l�����32wE�3\V!��r�Ȫb#������cc��$\~�J���M�ډu��v|u;��#0���Q�N5y3F���,|e;�o7��c"k����o��9͋*gԁ���#i�����us��V`Fc�HTt�����pǅ�a�i����иKNL�N����׵������uQ`���2�ÉO+av˜|F+1)Ւ��uU�����YfM�3ϡ4�
̨	A�0�#P\�稵D���K9�Y��){bn�02�|CםM��IMN�=f�O�8_g-��H��46��3��!�3�=�;��T�����K    �1�4�]G,���aW1{�Ŏӻ���rS*�\T��g�GM�]IA��+��z�����������)y0"�q��۬b�dVX�X3R{F
��C\FMߢ���ڽ�&K�T=
l�����;�c8<����\��-�1�枛��k/�[8(��F
����l�/P�i7yƆ�n���������Z6�D�c�j�/��mo��3j�;b���$$Z�_���=�j=b)&�ڭ�M����`��E!�d:��7�Q�t�Z?�-�*5��<{&��'ۡ+"kӐ��Lg��\.���Z��1�QGЩ���p-{�o('eht{�s1��P.7�:Āp�FaQ1^�l�&���oK`:���->r���8�R��f�~wl8�}#b�y!T����ϻ��&8c`�9�b���BrAZ)�악2�h^Q$���� ���T�V�� q�J�,0{PX��2b���=K�p��Ed�ő�*K���Ň{�a���s� 7�е^)��1|ઓ��.��L�|����~}�����ϵ�[D6�/F8��q��̤i�jV+k��m6l����V��'y�s;Gk|a�n�c�e�퇟���<w�<���6���X������ק���Q-0�EhR0XmvŪbcR=�r�k��We�"��>K���l~"��#�)�;/��%����R�)N��^���B=՛'�F�C�Fju��O���a�O�TlX�;>ʌj�k����]
���b�_�Ƣ��C��a��LR��+�*� ~Ŝ?��Ǘ??��-�V���o?~F��f>������E���U�*��Ɯ;�]�$��V�f���R����^ߞ_�b��i���b��S�bA��T̘N��͉�I������5��S��{c^&��69����^+s��L�_OW�c����@�zB�IƵ��+�)�Ig0~��|]M1]�fh����x��<���0��k_c'f�D�H|.�6ɔ�]���S�JT�命�Ɩ�T���qqk؆��K	��"}x��,d	��uo�{���?��z0_3�.Pkj��]�m�"��(q�Ӳ��;'��G�Gc�۳Z8C��kT�*	��*��$�I��d_�H���8�`��{,�q!�5�W;��yf��j2V�qvS1�ۘ��恌~�)mV1[�Ct�"b�����cTPN��`&����R��k�t'�����3t�&�����+^�^���NJfœ"�Qihy�$OJ���hX�b��9(Fz�N�4�i� r�W�QlA��<�8H���8�RFN�Tl$��<ڧ��t�ғ9%�*��X~�:�t�9PW����]6�W��*�5�//�l��n�DS(���biAO̞�6AK�IG}"����w	�W��ę�չ�uɖ�"	ݙ�[��z,*22��d|���+ު��ck��/̮����s�I"CdF�5R�'����Bh����Q�sS3��\YF��la������81��C�XC�XKb��%A����p���|o��ޡ�[�5^�M�Sַޥ�$��v�c�$��R1�'��E	�kY�6.�𿉘��#�8j	(�p�=L�R��ؘs�z\�����?)��yy���1
��`(1LSd���zc�V3�7Cl�ug=.��₅lˣ�@��؝�7Nl�pf�r����T>1�p�@��l�')3"vL��z?��b�L�fP����{a���Tw�Ϻ����T��36�r����YTll��TeU.w��B2�T����0ѭ�!�53qYa���_Gܫ�'1��facS3.�05�2�
/����	'f���C��
�21�6t��Ⳍ�-�lJ;�`���Z�7{a���c��:�S���\�@$�CFY�$c9|M�I��K�.��/�XBB�yP�o���������r���ۼUZ��|�h"�*F�Ep���5B��]�B;��m�Ys���Z&#.H�k���dL$cj��	"�|u���6y2{ٹiþ���Yb�wL��U̚���vZI���%ͪpu.酱�x����Zi�h�ֽe
���K<&cG٢���Sl�f�^�O3Q� ��i�ryM���|� E��1��\�z����Dv�a�!����m3|�b
��^e��Q�j߈ׂ��o��=A�Hz���,C���=6��{�e�ɝ�x���,1��Yk����L*�lD�E�R���T����+D�:E U��%Yt��i�����sj#峓z`4kqb�PΙ#=���jD�q���`R�� �g(z
{3�G���vqf�aB�+2����2^�D0Ws�cK�Y����0ܺ�J�⏪����0�Nm�Ji��RO��P`P�;p�a�-��Wg��ЪL_�U΁��6�l7�����C,��N��jk��P7q.0K�~��>�}µ2�X~������O�<�\���'���.&s�]Ŭ��0�$sٶ�����_�|��ۿ~N\"#n���ܞu'f��D	�-�3"l����*/y�失g�M�BB.n�)V1�o�6,� t���WVk�Y'A'�s$�d��>��,��	�Â��1�St���eg���h��]�������6"��q=�ADÄ�c�qp*6�`P+&~�z�����Ǐ�N2���^�����%�x7�{~��g��WR�������������������%������/?�E����KG2�A�x��0��٥L��o����!8�X��C'���o�<l�����퟿V˅�I�j��tJ�3xV��.�0#���'s��3�f�,4;Lj6ט����٤6�����a���������U�z
�5<���]���ӧo��;�?����_�{<�T"f��v���*�Z`C�.���L_�V�R�uʚ)�?RtV1~���I�?Ѫ�)Wp���ۀ58�~EZ����tv���>��-[�H�d��-]���Yml����;=\�MŬ't�8���fs&%_''~��Zޣ�abai���p�EV����-��a�����1-�T|
�g۾J�����5�W�u~��[�]�n�F�g��GlB ����Yɢ��*\�Xm�����==殕���;��ɜ�������N��̅>�bpe���&Y���f��^��p"�)�'���3
����з�L�9Ysvl�u�p�*FS�T�?�W4O#�Ê��ƒ����x�v*��V���+�t�c���U�fǔ?�a5�jYXջ�'R�����F,�� ��"����^C�X?Hڡuo}��jt�;
��"N�4�S(�̯����#6�(���)���^
�u0�fh�Nt`Y��L(�n��fP��g7|�.�y�}/�ڍ�%@�ꪜ ��6�6c�j�c'�v�;'lr�d�I�@%�<�I$��}��MU��[��G�X.0Ê\Ӂ;e��R�b͐B�r�$�_㉅:��ۙ����[p���������u���л�,D�Y<"��UXd�="6|֓3�j_�X��~b#�*2�D��5�&U�IŬ��qf����������1[9���T��k7o��3�1?�� �4�x�N^Ō�^F�h�G��*'�-a�B�Ӕf\�)#���m��&v�7��>1���&�l��w�p��}8��Lŵ�Ӊs`p|5Q��I'"vj�%2"�n�wY�=�3-��R��t{2@.�p�vTh߇'f}�l�;�Žf.��U�B6��ŉCst��##F<��VZ�~��2���H����������[�*h�h��DLӼ�|�b8%I�zS[�q���|);7:����4�����[Bl�iU�;��ucr� ���i�qbV�:y/y���\r���u!��J��4׸F�T��\#�5	p�q��V��M����l��]�Y�r��|%�W"�O����,��-�����M��S� ���v'̻s�\ɻJ ��H��~�/��BI����ݢb�N���oo�����3,�JT��'�u,ģ!��x�,��u���9@ڋs]@X`�� S	����������ȅY�^\7��l�O�#9���-cVwxp!���tI��p�0{"4)U�A���Ue_    ���K-`|���N\����44N�cu�\��<qP)s3+s3��A�	f��ҵ12�1$37�'rfj��{׍�Y��گ)c��$%o!�.�a���bf�y=�!�8����Η󑌫%�2]�
�	d]���L"O�Z��[�J�0�/�؍�������g�1'o�h��U�:F�/4�;�/T�[��\`��(���d.+� I�\��81v����J����s�)�T�D͢IO�7><����'[�,"��yxR.c"rFb@�w��^Či'^�Q���){a#�dGy\`)��9�ϟ�Y�̟�	��0��ҿ��%���a��S���p^;+��z
�㖏Vfht�2F
`i�(�Y2[c��N{>�ۛ;cݣЕG��%���8�Q���n>0�$��=;6�Uѓ��k �4fό����A~�1n7�����������4���5xY`����c$Ɩ�H�}�h�w�̡�pԯyO�QtY��|ƥ��!�sί�����9�dI!�}���Ų?�-ʲ�3�O^�	��Y�&Y���k*6`���'"綊�I.�Rˡ�� ��/i;8����2~��gS�%_2Bh9������ڂPbf}���Z*f�炁>�>W���m9��Z�jN!�2+��Ɯ�D�v�H+�C��W�� ��Z����\������f��4<��eQ1s.)��_�>��=O�.�,�J{�%��	63�u����"w�p2u�p]l�
q�M;1�a.:vc'�T1qF,��=���fGs�Hfk��fɄ.�=z�W�
�I9xW���������'\�2+F������+��6��Ș�1�[��n�3�O=�iW1k�y���K�|� ��#�����QԤ��)0����+b;����S��1O����'�F�T��Nc�A�:� l|���ƾ��`E�^����{��Js��=)̹�=������@Y�r[�mr�ݩ�H���;yhyo"�١uk���L�.nU��ɋ>�h����(?��V����.��K��%w����ӌ��SE��W)ƌI�Ϸ��Y���;����s*v���o��\�E{�x�óp��ɞ�z��n�9Y������QK�v�]��ʼ.̀���?ȫ+�@����K�V25�tn����0�7�E�تb\�ri�8���w{ �Ն�㚼��-�뽊Y�Da�Pf������smף�����f� B����X#]5|(��G.�'�fP7��J�
�u�Y�=�J2�F[�L�:t09�wך�Ʒ&j�X������N�qO��>�+^d�0aD��E�z��
Sb�?��ne9�^	4�]R�r�t�0��a�*����H�[�t�hǉYoƅ4�fE�,A�:B'����*����V�����̓�^�:�L���y$�b�L�g0�����y���3=ԯ�v�L������&TvaD��Ƨ�GB��\	\���J�g�86:���{&>�m7D�C��#yqe�1`탊Y�]whk�y�2m��>Z��3ؚU�$��_iOm�d�Y�l
��Q"��b;�&�b��J+^Im錯
��ћ(Ӊ���'R��g좑�B��]����-�(�C�����91��t��9��|!���7��*�l2�D�ce|���前8�q�?a��|A���;:��
h����*}�Gj�7���^���a�L���!�ds��0�@�v�������{�8Nņz�=��K'GǼ����6{l���f�]��n\XAw���<[J�,���������Q��E����2S�&���F)�e�(�b2ݮ(9T���e����
̘���qf�=���&Q�:8SΧ�r��(r��bc�6^�
��ۑ��,;�ǚ��*�
hq��7��c���ubF���������c�^��"�G���6�0l*flϦá�1&���a:��[|;.v�u^���!tF��e�v��Xt&�R��aq[��r#��A���a�3J�Ղ��CL�Ћ��EK�M�Z܆GL}�:}:֦��#�a�����?�m��i&�H��j�T���ȵ6�4V4J��3f�����/�1�%t�"fu����:�P���_����*�2�]`�^q�d*��_p�Hs��a�*��8�2"���w�*����b����T����}Unavw�[~����/�Y�����<����U̘��k��B�Z+V*!T��,������7��V� D.ݨ�>��拭g73�ĉ�~�	%�p^����b,z����}�\�e��C�:p�HG����t��:U��s�n�q?��Q�1������7��Җ|�٫���lx��z�]l�Dc�U���/���D�k��MF�T�bC���Tl�_0�c�̽ �}�KU�~S�yN����݄���4r*fL�f)J�DD�w۽cw�9��9��j��4Zq��=[[fW`��;$Q2uz�S�pf��4��Y����&�#/*v?�#'��n��|��e�:/�)2���)�r��Xi07>��'N�9�*4�L��*|�23����U~o��E�u�@�3�ƫX�,;����d�u�|��'�@IƎ��&m��b#牁�I�ek��y�U�h�=�8]��
�ϔ�Cn�x�X'��c��7��:�[�,Y�E/nx3���N�Ώ)0cx'~���Fe�cL>�% �
�t�n�eJkUdl�N1���j�c��N�'Ȏr
5ߚ�'f-.��<�S�
��֦�5�W��@�Ra[�q��%�.Ӳ�(&Dt���	U�b��Z{c:f��s�eS���qx���O�^'6�#O�(p>�V���+z�����d��?��f���aF��Vi=� ��+��� ��s�L�i@;k�A�j��^{$ c�h��7�HZ��Ve�հG�F���_�P��m�5T�h?�y�����eo.'f��k��(揄�ޅQ���e�K��x�����R����\�ƍ
�1�1�}̸��2yܹR$*0Kw��3饥f>����7����.-�=Ֆ8�k�/|��)J��*�����t���d�Ľ�z�F^���S���b�H�+�Zo�c�x��ۍ�#G`{���ڴ�0k�ˎ?��` &���}X��b���r��[L��:a���Ę���퇭I�*Hs����~]@��R~�bd�J?���Ol�i�;�y�*#��.���.�3w��;e7f�_�n*v/Þ�ڰ���$��fQ1V�GH��������~b����	�4l����H�}�8����qa�.���1��������Վ_���Up�y%]��G�zo|:����V1�����Cl��#���ݔie������T��2D��_}��@χr�TƖ��+
C[ӡ��4��I�b��պ���P������}Dhl߯��I� qʦJ�eV��"���`� 2N��l+7R�)��wV�v��\�ycr�]$#FZ���[�3ă�Y]����Q��~ѓ�#�4�~_�A.�~#1���?���M�cYm�1r���?�lSݘ��mWq����/�E�������ք�1vn��r��`���Ͱ���<��Xaָ$��.e�^�������7=��B\|&�����F�b$&������U�c�~���+V�4O�Y�Y����l�q~��1}��AUbP�d��Jz�R+1㣊��P�j�g�Z��$���jg�s����K�\r��cC�gCT�|�;��X�q�tn6��ĬV�{!J����~8JWM���#��$2�u���Sb��g�X5 ���*<eET̚�8�t��Ei`��.ʘ���6T���3
D�@��s̨p��YCY�ib��cL>���Y;:f*~n����������0)`>HB`��Vfn��%!🿾��y��xIn$�a��F|p��#eT�"L�_̋���aW���X4+a"����C/
��B���PΘ w݇�W1� G���ޯ���wz�o�r�Yuʉ�����IZn{�������V�~����ǯ_�-��Xn
̩Y��u&��S�.��|�1Q���z�8���ũ��_=#l7F涜S�۞u5��W��lۧ    ��ӗ�&�����������O?��<�������/M`{&�1T5f�lRbF�)2Ka"��¥�K.1��X�3���o}�9�͙sb������a&	4�|,G��Qb���W'L��hh�z�br�C\>v�g,�|���cW��Jl��+��E2@�P�T�kp�<p�:��ž�n���iqh���X��=i��Yxbֺ���o���1k���Fs����H����eLnWbb$GIX#�FP���	z�n���ʃ-*v��ܰ�_[ԏ���$�Y�������$�^f<%FT��e;�-}T��_��oP��~S���o�]�&��Q��II�������l/, }_����2�L��ׅ�� �=?��fbFDH�1�x,��eL;cN�q��n6�M�#F�2"n�h�YŴ=sL���34���G�k�� {�x����1C�Z���o�+�{�.�*ZÿV���ŗ<��I6��Z|�p���X��"�d	L�U�|U[bF��������暞���Y�bq#�0��>�︠b���£� �����}��$ƩG���6�L��w��`�t9yb�P�)���D|�i���sb)ᗚ��'|�ɷ�ϮIP��,%���?�҇U�si,93���Ա'j��x�Mbʉٻ�c.XmZ���qe�&̦{�\b��tɧQ��b&���*�k��bs��[���F�O̺���L���bV?n:�<\�E�yx���cr�v�C��R^enkM��w�莨!27�;�g�sF[��hd�m��LL��h;�)`/�l1�w�U��V2떴�V<�	w����߱r��U��T�,1��q}�����,E���1� 5�N؛�PΓ�ʂ��o��1y�NW����A�c.Z6>
kjA���i��j�N�Ҝ��C�<�s]l��hK�@s*�]��,�iIn0�;oL�O�.c�4��� �����g�1O�z�aٚ�%�O�(��;D�?���R���/�>���u����-��Yq+���q��*�&D�G�pSw諾��Y��]��K�<s���:�c%��fH�˫�%n�n�u����୊y���	�]�YQ�&8+L��7S|��1�T��c%�[r$�v�2Ƽ%l{"{gl��q|NLs0�Ab]�ɅT��
,-�ؕ��Wb�¯�
�b����ʨ�=�D k��s��D���pb��iz�˭H1��My*�b�d�)c�6���<�Һ"��Y�j�3�")���n����%qa����U�z�qצ��¬z��:A�I��s�yS1�gvS >>e]��~W1[�kn���?��g��sΘ�l�]EP�r��=��1��0�(�1e����S�i��i��SbCJ�Ж#���-[�R�Ĵ�o�S�oD�]ؒ�"]�t��v�&��:���?���������H���*[$f/��2�#M��"��L⌄sF��f�茬��M��ИI�s��&u&�����4/��7�O�ݯ�e���=��ҎY��8�Z��ߒ�Wـ��L����nl-5��k|*}�3^���:�VT�0���P�O��(Z�&L��B��T��!q�vz�m\g>؈�3'=nQ�N���.\�1V6s�לJ׷�
��FJ�6v�F��;Y��H!�c��9��T#�T/�3z�Hr�FBNR	�
�Q� ��!)p��Y��S3Ų���Pp��<�k��#&9�eV1�%��z>���b����O̚}��b	�v��̾`�H��R[�TT�9S`���4!9y�B��N
��WwۍT@�l���]�p��H܎i������t�~U^C*L�[|�K��j7����X���ɦ`i��bpi����x�=��B���Nܫ�/<�a��ҒKͩܤb7��W|G��O6k$1*v���j>	Ϟ�h
��-e	.��n�j�Ѐ���\R[�iU1��_T1��*OBEx|P1KO�W3U���H�d��}t����؈� ��y���sQ�����>W]l��j��T������-<'+=���n������!b5���1rΒ�f}�,������+$b�T�VzT��*6�(dk。|���Y9�F*�RZܸ�j�w��	B�������H5i��%l�����ec�ș&tbJ�իD�C�v�:1�?"o'y�ʬ���X��?�2I(g�H�d^T�u���g��������/O-��U.��с;#K�HT��
F�����!!�x@�M��;dn��3n	�*��zoN��,���lГ3�yr
1�#�!��1
�U ��ڰ��t�Ų-��#���PU���uL�Lr[�X<v[.'f�u
��� ����;Wi &GR^�y�%y���Ș�AH��w�" �����Č)5䑾N�:�fߑDTf�:�|�����<�+��b>EY�7ș�ج*6��MĬ}@"�=n^�Ul�,��>�tTQJ�!�׍-��P�
*��{,v�i7х�?�s\'���ڋ16�Tu�"F;�K��/.��;�l�c�ldq�{}��=b��81�7^�MDO�LHݼCt��b \\�%Ϛ#���*���u���7�o<���wN�����	�^S�_`��
W!����l~�l����H�纥I��aN*�cmml��|E�ee���mhr�:T�[_�s���NM�>*2��/_g]�OY��'~�&�-]x��M�$BX��n�I#Nb_'k���Э��F�}vr��ϼ7����{���5i��ܡ�>�.�\0��|k=�������Ց ��6���|�o��k�_�!S4.������i=4��ҋ�I�?5���aų��U*�j0�Z�������ϯ����{vw��n�ƨ��atO��"dm05��NŴ}�e��rhtt]�ا<���c�IESb��_���_UƘT�g��P���{¹��e>�V�l �.��mZS�������_~�5T��������%���"�8I�9=�Nb26IFb�'���2�爌~�i�s��*��:�𦺎���: /����/�5��c��еwh����1�n��lO��ױؾ�#��y\^�?�3�T������e]�ʡ��`���M�1�haj�+k��X�'���_߿��󷷟�gs���P?�!���m�t�SDlQ1����h@M'G�T}�:�Z*S�u&}G��3_� Q�1�*���D�R�
�`��2�Ul�b�����[�nWNhh�Rۮ�G�v+u�aHY ���g̒K���ag�!6p�.l�V�Rc��e���CHP9l�*��ay��W;�D�hC���M�1�Ώt���u�煱�y�E��V0E�Ǫb�Sd������D],���Y����Uh���>����#Y`�2?\���X�L"���7X"��q���8v3k�F���o�S�h�^#�"���X`7ۡѻ�Ӌ��sa)"�p�@!GZ��=4�������?��C��C�#c���ܴ9�opV�lU(���d
�5�.�k�?��N�,.�q���٪"��������
���f�'�͋&.��p�bf)����J���?����������r�����3hR5�8o\��g{m���[�ǡ'�lK���O��;5.XũbiV����F��l���x2����-����s,fz>�o�?�
��$����.��{�[r=��Hs�3��4b�A�&���!�`��H9&.��|L�k�v�d�Q�m6�V���M�\��Y�j��
�D��E�<���.�N{;��A�qa�*>�Tb�l�߯�	h�%>�Ԋ���J���|Z�R���*��S��w��|�Xs3W�g&{�
?1k
׆�,�����J��P{_�k�IƏ"�s��ٳ��_����cfn��W`�L��c�X��o����Z�A˚4�g:�äb��ܰ��I=�ڎ�������p'��h�n�P9�X�F�-wyl1��*6pt�-rF�E�� �%s�y�9*�����u�Xڮu�|�a�ȑVe)�.�f/<��{���ɪb*<��H�S�E���8ܰg��8���-z��S1{    $�B�/�ݜ��@�_ۈi�L��+,����1��\��=Ϩ����ws��[6c�d.�1�}"]pA�N�S�T�^������?�bz�[�d�ˤmf���:�㇘e��u�G{�4Ui�؈��G?�����6L��5͆���V�?/�𭽌�o�[o�9�b��pb�����	�� �Uź��j9t���Y���~�Rn8�U>C�t7ϐ�U�����7c�w��hM��	{������3�k��4z�O2����f�����"gn<���H�j�+�����N�uc�S���W������{^R�,J��A4��F��+�)6N�t����?���1���t��E}`��ό�����?�S��Ͽ}zl��,SCq��H	�-3Ge��깰��A:GDR����u���L|,�WV&��QZ��Vfɥ2��&��Q�,lU��37E;��N�-t>���e���P��|6R���)��I��0Z��5�#SQFg��E��np�1�H�̞C2v�/>4[H��#EF|xS�Qg�{EF�i�Yɔ�}+�q[��ʉ��:7/̐�<����j�H�k\�#�42o6:��6ց̷<�S�菗"���8��+6������E����Q"��+�ᕙww[70b�dmUsҨ��fnU��i[�<�F���ܟ��rT`���3�Er4w"�;K!����U��T��$?R�R���ի���LZ���T4��Y��<�r�E�ϯ�_ڴ��&Q�/vr�Ҹksx�[��������I�߽��)��,AŬ�|9,����jU��#��I'�� 6��k�ۏ����b���!:�n����2��?U�sF�a�8�&7c��;����m���4�X��+?�IY���`�?�92��S��3���kc����Uw8ȶ���E^%S��S1�y����H���7#�[?;q�M�~�*��K�h5��P�v���Spι+h��|��:��=Aם��L��UԼ�F�J�|D'j�a��2n
��PC��qh��>c��AO-3���3��Bνݹ'6��}��Y��E���L�m,����LI&�UL�lm���X:�E؝-�<(l*fX��A�ۢ�5�n��c'/Ϫb�I�cg=��;�����>1�;OG�r�tE
�+ei��?~�\�_�+�A��20�Ӻ�<��غ4�4��AMV��[��Ǽ��@�-n��e(_�>�:#�^V�q��<4��b�vK"�4���O6��=<�m�����wh�$����
H݃˞v��?���r��p�-�M�WV�/U�o�u��u#z�Q ��ң�����Y?0�m"*���*�A�Q"	ʁ��������onh���[��XC6�����Y�c�i��%�惾|:Z���������#�׊��8J���q��vc���6�|�c>S}�	�V�<x���9�[��)�Y�o�m*5nu��c�Q�Z��Պ���YWñ��W��O�n�s7��L/x�?���2�9ǈ�S�f�p���wC�����f\��������v}X����>�H��obC�Jz��p�
�������V�����շ��!ی���1����(c#7+1�W�g\j�۹ɘ��`볺�nz�P�e��GT�Դ	s<m�yW��wOO�{T>?�.��#�W3[����Gׁ٘���Y��Z����k{����U-��5�C�$a̐yu��<��'��-��m*�׆L6�@���8�3fn���6�4O{��a�#'cy�v�S%���C'cC]㸉��hAf��u�{���-����G���x���a��.�o�>�x{\^o�y��۟_�:����_���U���&dLGj#��c�w'&����e�]�ۇ�YŌ�j�.��ҕ�+����WJ��i�œA-��������̢�/Ag�I#��ײ����}m��]���ǺT̚�H�,(_}l���[6��1�b�PRrf�����%]�]���u�c*:萹���z�FQt��2�-`׫��Q���-C�s��$3�p8R�b�K�Ծ05��>��}&b+.�#ɮ�*F��t��`o���`�=pb�kߙK�ϱ����Bv�'�6[��rbc�0)c������Zq�b��+;�su~�@Ui�7�;��ōľbh�E��tX5?�<Hz~Ժ�+�9,�&|�y��vaV";�P:�xR&���xuv}u�f���~���4�j���ā�ְ;1�����:�F�t�`tu6�:CҏA��]��4V���hR�.̨�{�G*i������!rR����o�?���綱:&Cd��́<v �0k��O��Ę�<_��e�+�1��>~Pe���׆������F�����z�����-�^"�߁<Dr)=����*`U,W�����$n��EUl�4yK�?��0��x̸�̪��IL|,0&Jm!�`M���6,aR��4k\ ��,�U1F��y��z߾����b@�as��4�ߪ�c��q��f��t�����^O����1���]+0^ވ����Tp<j,��P�q���܊����#��O�錊�yÊf퍗GZv�׽�K���u�������D$�'���>�(y2�W�$S���3GxɼxXS9D�#^�.�4�I�Z#O\`,j����-ڤ���h�v��p�8��ū�s:��6��;�Ki�u2��0�����I!��=�XS��F@�����@d�ĩ�r�Q�[��q4����5�9�o]P
CM�=�'pg��S��Z䍝1Æ��/�5`i������m.NŬ.blim��0�뗷`�_N�3�U�c���`k�C�{�����0n픵/���R,�i��.
l(K�
�l��%n�¼,�UŬY���[QU�DG�^7 ��-�;�ݽ�Z�6����io��`뀖G����F:�1
�3v����4��f�%iq���g�R�Q��߆�XI���(S%���ɘ���J}�CL���E���2b��eī/&G�*`X*���%p�s5�v�C���~aV-8�e�i8ګ6U�g��75>�yR6�b�*r����X�=^�.*��J�-=�q�à���?��+n��C/Qq��XN�ZLL��D���Z���X6��f� �H��8_B�ۉyɘهGȐ&^2`R��CŌ�m�N�%��l��'v�)���wq!�󘂊̆+���D@�.���[��=Z
�#��R'T�bL�!��î�1�fS1������n�U^�BƘ
.PO��<�����J�D�;hi��P���W\�E�M�?5�v��g��	��,��c��[��Ӊ}��������q�� <1{�5�*���<�bh�I��l��ۣ*T-0�`A���[T���Er+���ڰ�-0�/�Ȭ��KbL�$"j��/MC��m<|'f4�y��m��=Q��ّI3�����ؐP"�=�=�(Iq"[{��q�C:c"�2�������MlЕ��ȡ�Ʃ*�I�:�����zt���}�q��gr'���|J岍Ab#�T6#D�F|Q[��8������)��\v�m��S1hݿ��y�!I�M����b..�8��U�η�[�����Ÿ��pq=�bkM��z��[���7ڍ�1c������?�Z:�F+��&�Ѥ3�����F
Ol$7�MS7V�ei�p'6�Պ�o;I4U>��᧥�1��#�7d|c��s����X7}�?ހ|�H��P�+6���P�u���㿅������|n?�1�������g�bu�&j`#�Bq쩐uR1,VX�_@��@�H|��9%'�#��rj�?�w�Wn�t?�F�@{c�]�"�C���vWsG�r*�/�M��Tǜ���ػ%�ӝ1����3�4�+���G�d�~��B8Dg"��=R*dP��.���ډ*bC)������b�>n��(_ʃʺ(�n*&��s��A��Sl4\۹H)��b<�����e1?���vk�/0��o";��%;5������H��}"^����oM�΅�S��GpNě�oZZ.��[R�$�)>m¬b    D_�]�$���r���T��?��O��~oB�f�h�w���ü2�b�=l�i�mŵi8�X؅Y�X�P��H5�N�޶�)�p�~3�o\<��U��pWEom�q�����KF��EEO���r���!+l�!�49�Ru�KI�Q��go��Ft��=�'-��ٙ�&1���KL��h��o֡�D&�I\L�lS��T4�'KB��[%S��/��d3����+^َ~o�	�_�׮�0w��fW�gY��Tl�������9L�@O�t��B����yL�QY�f΋�-ӓ��<n�_��a&I��d�*����1,���>�1&ȧ{Q��r;Q�n��y��2,0�*��I1�f22��d��I�M�cZ`��OU�Ǘ����0�y=�;�kܴ�C��Z`�|����	?H�W[U�SOw%K�M�l��L�o����b:��@��1&a-���Cc'�g�|�P'֓yx��=��A���bY6�A��D�$�Δ���kN���*X�i'�n�8�R�@s!����m�/@Lf�@�IF��m�Q��j�C�,݇O�n�oU"<'��5��&��++>��j8Ƥ{A��;���r���c�;�qR��y��(��q�Y/
�h�lq�Iw�
.t^��!.w.-â�pag��6ˢb,:��4�lc{��&��$0*���(�X�\  ~Y��oUs�i��W7"<�Y�=�x%��O�g'<�J{;�&����1�\���m��=���!��>�N�EO��'���;�-f�Z���Tw����5�q[��쥏�ˁ�wivm�@^`�}ו�S�P��c$T��et��)_��6ż߀y=/��d���"��&�X��Q G��A�����	7?�N��}�X� �P��Y,&(�4��4y(fe���\��٣��yc-8v��	憧!E�}��Y`4 �D�D�{|�6�̉1�n@�ƷȍuF�/N�ȅ���q�,A�F�7�� O�x1ѩy��X��y��q���+.f�}�����J���օ3�	߆��_��r���N=s�] !�dyd<.$���$���q'6֧��H@�i�Ќ�h�E� g���eO��L�Vs�[���v��$�5�-�����HƃIX�p���t;O*��n�i��|a<������ݿq���}.��Q�2/�Q�}���9�b��4��Y �����3F���D��'M��\����r1�����T�M�Ze@g(��F
��9���Xk��^Ykf����ڏ|L����2H�?�iM�s��R`Ƽ����/��hL��U�M���%cyC���"���f�a�ۊ���*�*˫��,�;P�Xz�ÍY�k%���Il�������*_I5���sN�S1k*-�Bt�y9�+����y!߹�=.�Rj�(cx��a�J�	U���H���@RfV�c���zh/�������l��]�wR�R�-Ӝ'�l��Inn�$ ̚�5��c�u��s��>�_u���摴�U�)r�Ull�X��2�e�V[�kx�q�~Tb�Ƴ�^aZ��k_wk5O7�*N\`�jj���4{]�١������4v��n������bk��|�+����Ƿ�V�ݷ_�c:�"-8�@]�st��I&�r�<�i���J�2�CNo�2���;�PJi��5Î���$�`R�8����+\�,���O�\i?�
YT��IlR,����aS1��d�`�}Ghn+K�
l���':��5�b�_��y[�*;�Ų�Ĩ�t|國=�D%��Ð�woM����� 
̘Z�> ܂t�R��b���ޝ�\��y]����s�.6�>sP�EŌ[������زkl1O*6 �
�G�0�S*�Ԟ����������16�[�"���xb�M�H:�z��8{3P2H�����Hl��m�T`>�w�Ɖ������	5��Ĭ��׊\@�`��X7�����AnHa�mm�v�Y�4�S�l��0���5�0�F�#O�c$�K�*��5���C��n�':<Ɠ's��<����V �)8&����_L�iΕ�z�=�4]¯h3VT8f� �-�9���*�������?G��1�-q��N������C$��1:}i6&�r�V��<d���Q�j���Ѫ_��x�@8����jO��@�&;_e������Ќ���#ތ�b��-�t?����蠀��i�"̃D%,*�s|�����Ĕ�$>����x�8Z0z��36ڵ�W���{��{�s�ɠ<&�f��8�V	�؀���o�	�ǮdS���'��]I|��g{�7�1*+N*���\~~��0�����߿��u@��ƨ�xi&m������+��İkM�$��x�.�h�<���a�F�vq�U��c�������_}�\���'sqe9�n��U2�F<�7�O�[��tF��/��;�#H{�*�<������Vp��
���x�C%c��� �]�E�,��Mrɘ�����op ���0)h򗚀��?f�Δ�[�*��F!	��k�ȣlNm?7�T~3<g�� n�9}t���%*ё�2���\m��%����o�O�_O�ק��%ZQ����/��#M�����g��Yg!3y�ϪbF/G��>OcL���B,���e��D�S@�M	�����6����<,��=�<�H2��t��}[�M�+������z̍��m-���];O�&���5Jd,9{*�BPv�(m2I������&\+��XR�;Dn�,S^�{��=3����Ч������y�JP��I21#Rw��ͻ�ªb�8).,9q=�-�Ⱘ�V���ڃv�C���ѻ�����q�c!��rT���*0{�M�.�K�{����r	I�4�؋���/����_~������?}�����1W�y��۟_�
6K�YLNɏ*htth�<Ds����R�e 6�pN��G≭��N�/S`� Ა��e����b�,��Յ��B��M��u��H<�����R��7�>Nņ>�+����aq!��ղ=x2�iG��j_�'�ћ�{b�)�,��Xv�K�b��O~U1�O� G��'9AQ�����Ys�T8�b�91���Q�X�:2�{�0u$�[B+�Z`TM�C��ÑBqԅ��r��%��!�M �������v��CV�N�,�/��UwR�"@�BJ���~r{�sX`Vcw�<,���]���Y�,bWWcHǛ=��3�T�kf�@�VRQ�Gl|��*�\`Z\���dD�KXo.��̫�H��oȵ�>D\z��V��������U�tf�ٝh���Ĭ҄$0	�]E�W�ɽ�=bJ�V����H/�Û���g�T*Vf�>c�6i+�	��w��(��#/*���jO$v|K?���� f����~�/�7DV�P��s��u�I:�'2}�H�-
�E�`6):�����Γ̇!jV�ƅ��[�K����Ata������m�����'F,�՚��g����O��N�G����~~�/��R�zT� ���921X�9q��\�]�_�
��;"`��p�Ĭ�P�HXgsJ0t�����tΕg"��\�'�Q��X`�Ap������7�-r�ba��%��l���w�;yHl�4e�]��x��B&��=ўɱ��i�=5�
՛�����hk�i����XR�ͮbc=��g����E���Z���HZ�N����>���a�'X�x���j�*�����e&"I�*+Ѵ�*��p6����<p��p̜~ ��x���U����Ɠp�]I�E��A�X��Y�B,�����{���0��~�'�s3cV�	w0Q�,1$S
H�5LC��vn®M����X�k�UPŸ��[y��$��Ul��bG�*J���$s�b��W4v&Fہ+��.N�{�b����_�|V�����56�����}$Ǯ����r�����9i|K6g�����i����0���u�{x�[�yS��i���
l�_�#�u����Ŕ���|�C�"?yz�XO~�4�=6�0\��d0Ί93)Y�0Y�aI�萸�HA�-V�ݎ�ݗ�e,��i�   ����~�Ǘ�f��ߟ�k�[�Ć���5�����Jr~R`�vd\��~��9r���{t_>S��$mx��>y|am��]�FE{��k ���,�c����`Ï��x��R�b� �Gvl��[����^s֜��e72���>�X�#�"�HH�G���L�]ߠ��>��� Fl��$���R�@�]/l, Q�WC�nN��ߞ}�gH�f\��br/Ɉm��S\�Fs5��%��z�z�W����p���Bq�Y�"�}'��5�;�� ��י����t�կ��q�o���&���y$������	��X��ر]zs#�U�,>�B���k �M����[�yf�F�H��FZ�u���!67��	1���|R�����Mۍt�NT�14F�~�p�K�&&!����Fe��輈�^j�;��^���mp�bqK���yW1�b(�
�A�7�LJ�?��bV���O�z) �U�n�;Ĕj�ی�&���}��X�X|�ѢrUIb�q�ک)Ir��d���ܓ����'g�Lޜq���A�,4��� �6�<�XRz#�-)-�6{/��|��Sa�؟m���B��H�˲Z:�vx��{,�;���(V`$	�I�D�Q�;(�uTY6�"ɫ�ijr(��QP�w��k\�ߘF�y�[�����e�����J��L-���%&&9�k̠b��a܀6������2~���8�Y����Wwh���!cKh$Rׇ��q��o&�5qc��YŌ7������ `�Tll���
���V�#z��KE���;q���Œ��a�'�'f��A����W1h(��agr�IL�2H�89��Xy%��M�w�Ę��4n���>�{���<����������1�y����s��I��!�s�d���WO�S����.ծ�O"_O~��������1�al��i_�$����̾yΎ�o��bc��$���h�����7�If�U�K��.�9�2��]��s�h�,;#�ͥ��^kDVDc�6�9fMu�<-����?��?�?,(z�      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܻ-[rY�Ϫ��Ǚ��	��%�4��$%�$�]f���1p`G�ምf�����U�>�\��<~�f��f�����="�_>������]��:�E��m)j�^I_�"X��f�o#l��f�/@l�6���b�V�%P�0�m�h��{��t��`��P�Rz��Λ�gH$�{�\���ѱ�CRCL�<<�YF:
B�OخU�����&n�$�*�w\�(�ǟ�����it��{�;��Z�ϧ�U[�QB��8�Y�#��Ye����\��!M~p}L�h3�����������v��eV�x����~�&�� ��h�e��Yx��B��?E��o��%O�{�����e�!�P������yOtE��M<���6uPr��Ǹbk;�U������Aܔٹ>���&93�5�[��1��Z�{����x�I�(��W�������,�/�F��H�3F��C+O�ܒP�g~��,z���~.�?Q0�DIS�<>E@��v8�N��Rb�=���
q�(�{���]�__�ȏk���E[�C�z�C����hv��(���AdK%�H���<���Q�k�*�n�w?"J��%w���nB�Mi�H�ϥ��3��2�}�J]Zb(����C6�j4�'l6E�#+�F��5~�&��q"��ہh���{��	����\q �>в0[�0�L;;�x��-5�\-�[47���el�K���U�Aa7���g�-���'>����|����|�!K�|��-.��*@l�ۧ)�axSoF����"��7�d�{�����-�=5i�a���H���y֯`O�<��j2��=�e���:�z���-|u�ػ_����5O�Z"�\�<e*���=j��0�W<Oz��0�_�<�7�x���G~rmve���?����'���[VFҖ�1���.��oğ\ޙAظ@4�N��}D3&�lsZ�M9�>S�7��p,�ET2eLr8��ϻ[c.��}L�>exOR^��|5����X�ؓ]0�l��rP�ym�X���hJw����s��_�!�d���a��f5�|,K��mw1��4m<#)O?��H��K�񳛽7�L")�� �����Oن�rp�������ьI2*�x�Hk�N+�ƨ,w��Ԁ���-�yon'0�{��b��p�=�z��t��r5�G4Q�Z釰#�����b�V����U6�$Is6��I8�$���(.DF�T�bz�յ#:�-�jK��m7$D���Uj��'�b�Byr�-��p���$����Q����_E�7t���7��i�f 6V�@E���������hƄ�(̥;�0<���Bl�{�V�ד��Z�3��9�"ڂy����K��S4!H-�4w�����
��7�<d�/'\3�=)���-c����T��|߮h�q]�iṾ[�"�*�jቾW�rK���p������+�(��
���j��NǠ�,�w�"�I��{IM�t�x`9�r��{Z�{ix=)Z�
V�sye.�QT[�"z�t%=B�	}��b?.=��7�1l��ɊVL�d}��+<�F	��b�F�L���y��������R�b��ޞ��]��Qh��y�a�61�DV����;o���=c9��>\�����Q�nk��SԂ�\�0�hJ�g$�u�iʯǲ�;����*$�)ӊ�7��z�^�e�������(b&�g�޺�Y*>�5���� �Pv�A�A(�5nS~O�O��J��g4���]��R� ��g�yw�b��Cp�V�+���0C����Kxy9Yz���s��X�'�e�&�(�- ���ʪf.l.�f����-$�Yb���C��b���EQA���H 0�N�Yz��X0�xJ3����<'�~��z�"�n����14#	���k(����gH&���i*ΊD��Vl1�FV[�6��\��4���ni���BiK��҄{�4zNd��3�[2�K���cJ$#=G�J=o�+��q�R��*R���3�L�|������E#������S1��屔������;f.��;fY�rC�7Pƹ{���a��"���G�Y�Y�{�K���Jc�3�������5+��뻘��
�$Eҟ�~>�Le[���Y񘫴nj�t�n�!O��oL���S=ӊ��|�T$N�b�AN~6C4@L��}F�P�Fy���,�C�!v��z��O_���e�-g�Yd���Tܽ�.��<�5��g4�qw�xQһbo���ت��6f+&�
^��;XhQk1�jQ���O?��o~��+T,�q��
9.��,��眞��u�:̳��;�i�I��d�hRwa�Χ�cr�ʶ��Y�a�;�a�����K� ~�bɈ<��1T��bs�NP�-���b��!�I�d0B�ƺ��wŖ̥8�U�Vo�c�a$���Wl�ZzF��F�H9���;���?�KO:d��:@�ٰU�K$��g4-�o��� z�Q<��N@���N�-��,�^#&7���$�eiƕ�ylw��<�Z�(tL�<�n6���R:��\⹒r}�T����"�~Ě��Y�L��k:��c�t�����X�Y�]�gTL��U�i�T�f�bT��S.�6#*/.}F���Ҙ2.���=0���I�4�n����a�����$ψ�s��hR�-Y܍7d.�� �1���_�q�jpV̱ߜ�U4�f2l-�?ya�3�v����^΂1�a_W��vۣ�p�ز��[�5D�l��{��������^C��V��(3Q�Ty�G�c�<v��Qy��!�I��w{�h��ӻ˞dR\��C��'m����0<��ًQ���9{ʓ/"u����^�N�1<���씋��#q]�(��<e��p(*�����A��j��r��ԲڱK�5JOyz~)�xQ����㗲 �0�a	����K��ʜ�'4�=�k�߉��i�
��FQ�o�gv��9��=�{�v�h��p� &����4E� ��3ҖH�L�yDs���Y�b���%5�m�c����}k�5+�H:v�`�S�?��8�8>�_�+m�6���XhsF2C�BL`$n�c�Bgr��bg��z��A�-ӯfŞl�e���@�Y?`����*�<��	�49Q�������M	8����x�Nm&)���d7C��q���9;a�ڔ�J��S���ь)-�ީzO��������;f2fh��lJ�ͪ�E�S�E�ݴ��F���/��]�DtJ]�=^H�Cj��8��tq���� �n������<<ߧedL	��I� C|�
=c����+|˔٥K��ғ��ed6�9q���%���}���I�3}H"hz��(a�������ޮ�4=?{p������?���د�OԹ�P6P:�݋R��8	������|����2)��޼ʮ;��݂,ҋDo'WL(�DC�����f��$ř�4�S��B�W��s���{�4IL9����fM��#ek̥���6BOI����	tշj���n0i����}�ԙ�?����� 1���0zXD3�s�=�I��~�*6��|v�^���S㖭�&j��%�#�f&F�qXIUV��Ed��xU�DMd�uVk�-�V�|�l��Ue�A���H�{>���|��񔚸i�а��Jj0a��6'uѕв1��������䢞Hu��n�Y-Ȑv-Ԭ)�3�iL0��':*P�N[i0H��)5���i|�����
P�Yy&�}F�c����V�PGFh��h v/�{�T}釄e�Q�!�U>L�^[k�����6l.G��]�3��/s�]:��>��b�4�l<+z�K+�K�}��    [���67��؆�6����"b�x`V�u�01�o��7��-G��x��MV�or��_�qtW��A���-�k,���<U�<��������-��T~Y������e�V��ߕ{cr���ޔ��v�_9��G\AL:���I�����/BL����%I�T~������;"�<>�=�N�����vР<^'�u�u�A4\��S�N��w�y�M��;���(��5T54�!�}�.]u���x�$�Ζ�L�$|�BL�?������O�Ɖj��n�a��t��0��p����oV��C�L��*���ꁡ���`��c���␢�6�W���k�Y�9C-Rz$����ڤ�c�{4㳷%l����iq]T	����H��	�n��5��|���^�Z�ۣM;�{�O)�&��r";ܓ�9��p��tE��l!�!�D���4{����Ǉ�' ��A��_��h��o����ej����jK��a| Np�#/��D�L����a�j]���U�����5�'ޚ��n�!6ۚ�D�5���1�D~�&:��/]]t���FD;��d]~)"�����[��0P��{����
��=���ʜ�6���o߾؏��2��Q,B���`���y�
Œ�[�|J-�5�L��X��)�I�M#ؤ�s�[>J;2i���C�6M�7�mH�,M�b�� U�vA��+704�{n��X���)��H��.�s`����u�j3��϶%�^���IV�?�%op)j0q���WRڒ�Q��)��c&�t^<1��K4��T�����.�!�����Oe�[� '�V���!�3�܉��Ee��������Z��#�H�v�<,?e|�W6?��h)��\T��ʇĿ*3Y�;q�c�F�#���)�5��5��*0��׿�������j�)�!i��*?��=� ���S��|g��a�S5&�����g돼k���}��>�r���e%�'=�3��zU�e�"ѵ-���N*<��꨿
b�
�k��x�y�.l1D�Y���'S�|)��5��C���Z��J�ƶ6T��ۼsFCC����n��ӛQ��Mv���;3ϔ�}�l0����2%�G�l��#1�r2�4��Ox�	��6��p%-S�=mzw|*�����ѣ�!6��@�P�����*S�R�qXDR9����XUJf^��_��bV�	�1ٶ�ǧ�9�
b��Y��tm-yF�c�`O֖�L�z�*�I��/�ke!�ƺJ8*���u=����������^���K����O?\���<���c6�yA{~t|IG~�3-��=d����P�R/dҍ��\Y��P�b^���e�p
�pW�|���U���������td�J� ���2��8"x��_ŊIg�24S�jٸ{��kRv^�92Xbs��#�k�8���֞�}3k�g��������6Ɓ�i��N����m~�I��dQ��؜䙅��YHR���T�p;7B���d� &-���U�X#vK'
c@F�qm���g*Nd�&�5��K�r�Ik�0MR
�v;�x��y����7�tL�:��G��媌��L"��jD�Ȫ��*���N��9�e<فN�v�U�㬐�;8�b`�~$�G�K����ʂ���}d��,\~�����Z石��r`�;�ÇR��7hگۜ�;Π�I�p����[�gV���&0�ħ{��SG�K���=)��S���b���}7���U���姨��Cl���P�H��4݃��qR]䇯<#�"�<�v����U�*�=X��ՌWP�����ǽ!6��ˮה��xp
�[�-�nN�9�j��Ξ�RpM �+(.�3�'�b��K�4�M�/tB�ν���A��؅AOl�%��	��5%C�I518[�o���s���c�ҵ���K�G�=Y[����B�.(�	��ke����ZWG�����v�5*n8ZB�0K�Ds-K��=�M�����u����Nj�F��f�G=���ddfo{W���}bK2�Q�=h󽎯T'�͗��k�i��D�����c�zLoi�J�?&�U=��Ǿ���е0��֖� w�K>�S����*S�B[��=��L������	3��leYΘ���2�4)|�lTBXF�3��Ф��-Q�8��3M�o�!i v�R�GS�8��G�����[;R/g��w�%$�P��SvA�'vb�3���b7۠KG��'�k|�>x>\O�4���`OlaF��0R?�e�/Yl\��L�b�<�5WYS�dOd>Y��]Iq��`�̈�]KzdC�XBs"�	�<��2-ƹ��)"��f��T��5Tsb��&�E���6������x����J��o��wo�[��sF���撇O����M$��KH�j��gY���K8�=���A�]_DS��4������L����� �̻yGS,Uc�{tL�n��$��!�60��$������ ���֨$l��V��ݠ]�i+��4[,[;1orV��֫�d?���Ki�M
���l-���Ԧ����2� Ӿ�Г�c�ScӾG�o�h)�0͞t[2��Q���?ɤ��tf�ɘbI��ݺ�T�Ak��l�?|_��ģ1�o5��S����\����*��; �H�)�+�_�2vk�Z����⩮rk�oZi�)6~��m�.wd�=��hS��f� ��,O|�|�'~J-���]=u�;ٖPb���J����j��+�П�2���t���4�ڷݝ�2Pʞ�B���^���G�N����^	ӕ�YMH��vgIh+���S�ʤ12�b���ͱ������p}����ۗ�߯\��zR�\g���Ĥ�ת�--o�U��={XѬ�M��vTJ���&U�`hf�n����zM��j�.�z<p��؂n���#�̔��CeI�,`�=��4V����@Hڌ�Y���0C���N5�GԸ�㱯
�bo���>�Qy�Ru����l�ұ�k��#8�ո���������?�!6�f>�=5n]�Ă<��v�䋚.oѬa�!S�=�ޒ���C=`������Ú�^W��fB�|�҉�#���S[��U�� 6��d�9�i���v��KM=X5r�,Ħz��2�Ø���l�|AZ�^~�ٞہIk�-�KǙM��i��]��L�~�ኔ�ޒ�y7��AL�>� ��ċK�؛�=�|Y������B;���	��5��w�f1Rl#HeV�rS*����b�hA-]�>%\�e'2��Y^DC��ج������9�M�&ظ�f��D=Ğ��y�h#d�`��q[j�!�j�
����| 6�^�33�
g㷘W	G�W[��԰��Y0lyJ�����ܰ剽g���4��&3Z�:��Vw�o��5�][�7������d�!&-�|H�?�ts��"���1S�%��#����y`o��}�-z�d=m�&8�����e�}+6�'�.w15l_.-)k_����$��5���&�H��xj:V�ٵC�L2�I��`^�g &l6eY���0��jh�K3`�	g"���tn�Q��~[8�e9�'��ݧ��lѐ�+�y�B�ƌ�T,B�H|�T
b�w����Ι-��;����mq��k��-V�����g�a�g���}`�^W����l΄����GK�8q�_���L\<�B�辧�?5*�G��3�(��B����O����=�&���ߟ�~*՝��Z�o!��8���x3��GɌ�aKO��tK%�4W7n6o�u�e�ݱL?������t�TP��U�Q2d����$��H^+g�����?��_���O��v1U��5����Y)?�1�6]��5�Sm��2oG
��[j��0I����*���ն��Z��&_Em^)5�U�L�	�ܵ��ֺ�G�RUSX��?fQK�6���n�2��u�?a�EU�e�g���o_}���%ZW���rB�`5����f�H��VGO����p���� ����
T�U�$���4��n7j�U9�br�G4�����
b�{�9ޞ��&Y�    �V���1����\�Y�Em��޽Y˼�lG�����I�z�W�\��4��ECת+z։����{� N5ԟ��*l��ӱ�?g��ڔ5;ֳJ͚Ksm��R+z�*n��Lˎ����bϒJ���
� ��O��_��Յ��5,���Bº�8��HN�|��&�l6�ܸ�6��C]��� �F�a��wGyM>K{`j���<��҈������դ���b�]�ÿg�5��Q�7q�7�NnI{o�3�����;�P�|�Rcvi�:�|bkKZ_p��ԕ|	�l��C{.����0,�-�)�`�?�/��6;L�w�]	n&J��h���l6�pǛ�X�!jl͡{e'̾y��ظ�L�� ����tR����6�^m�j˰J�l�~E�ܐ�h����hF#R�n2�]��o�
d7��<��"rE�CSU"Ӝ��k�4Blu;��Ȼ�{���!Sc����q��d7$d�X�w�`\���`O,���"/��'��	ɋ���xO-M��p	�7�������#���H�Jܤ��Kp?�kbo�8p�=��n.e�o��Yb.�1ޤ�P��q�'�G���m���Oi��C�W-`�V2��D�w!��]�9]d�&������p�����kBVJ�n0i��I�x[�w<UZ�������	�Ǧb+��/T)�K��ㆶE�*(8~�E�ݗ��y���<�����J����P�T�?fĞU�t ����Ġ��w)�l�g�]Hoỳ���T��ߜч�~���r�I}�L�w���D3��A�E�V�����``�j�+�������?����_>�2����_��������?��c�b��p%�^��!�^R��1��P�v�?�x�@R_��`K����~΋��?����>���~��g6�)���_�.�4�d�5P�T�s8̥o��^e��v���e$�� �B�Z�J��7�F�3E&@��G�YeKM�^oQ����W���l �FxЬ-�i4��b
&~oY���RC����P̥���{����(���N")�e#�n�KG^=�I�V(����j�e%O�C:��_�q��h��ף�#4h�FӦZ�&�����j�����fCء�U!%+��!&.�B���%c��T���6/����yV�QygDǀk��7ی��\Ќy��QՓ'��Z5����͇��� �Ҫ�Rf�`���
Z`1D�i�W���X��QYN]�4̦vk"�9��4�7C�Ca,�V�s�A�p�4���nl�Қ� "������tǛ$P7�b�����LE�d9�q�T�*
O�-����&�?�~�DMiݡ3��A��A� Z��58{br��!UPYC�+�Љ��>#����&��F��*`��syO�S����nڛ��zҘ�1�d�R�7]a��T��Z����O �}J�Ц���6�&��q�IM��?�bf0�����z�{�n3ه��KuL�I���":*x6
��fR�����U[���}ݿtl����ˊ��c�����k0�@�S�N7甃��kxF�,�)��S_bD� d�2�&[�:��<m&��; BL�y��+ME2�!e'���<:���&0di�9#,��VzZ4ѱ��LzZl}�I�0��=k�D���d"��m�"�&V��4b��L�AY��*������c\��T�I+�Fp��]=1<L�޲2���2��4����5�`��J���F�a�R��V�<�K�����9��W��h�d�X-���7��&��"�*w8�c'.�`����BL��CMWj�Ʉ�ޜ��v���s�Z��`+G���˛�c�r�n��&m��,�o_�������.T=0/DT�	;KDo����K;=><F�;�skl�73��vs�6&e#�z���^���Q�f3�X��d���uMQ�p��~B�Z)ԑ�7[�3�I5t]��WŞ{������~T�^]0Xb�Ў%�jD?�}�x1V�#��q3����_������p���j9�04!S�nV�lB���ۧ�fw�k��
�}�W?�B�t�~l����k���FA��ڗZ�����nR��F�N�&ځͅ\�wГ��]~��������]Uh�As1 6�`��|fT;��`n wtEm@C�����@Y �o�:,Q�v�T�
b?���E�����V��}�'�>2~��1�������k�I��`��R�� &5��*RV�l>�d1Mn
���}$I��������o1�C8nR�0�\�����˘�E�����CW�u����F�6����D�w��{~|�si���������$5�+�I����'D��X��ȷ M��<Ih(#������Vq�/�&�7��hqf�!��.:�Bfr��g��C.�*w�y�o9��,g���*e_�AL^u�G4�u�=�d��C4�@�+dew�����Pv�KU5�S������8I���	���2��-���T��)��e����2��L�L0������>�s`�����Ñɉ����B��r�JI��7\㤋b�*�;�`�I�ܡ�S�.�iO��XV��K�N̔\�+����������4Qz�8���G�%3{��Nl�=���6�!�d*�.9(0N$Eg����e�J���UV?l�G���K+WID���rw$�g�aF�1�	%�.��R?L�ݦ�N
�'e|�؛HF��ʀ�km�	����Pf>R+��53���K�eW���X���4؜���Ų��O*z\컴��甂ػki�����kH�_� ���$�lΒ�h;X:�Y�����ܰ��+���a��]x�(C�|��Ty!�oN�.Sl�Ag��E�,.ܘu��k��BL�Ruk������!z�A$>V���)���Rń�'{�@T��ȪDk`ů��1����KQq�����|��������ZK�k���*)�����y��J�֍IPs���Y���^�M_=׊�U���,K��'�0��h�9����Vz�����,(s=��};�ܼp���	FCq4�O�A���K���f�/Yj���c��V�N���m�П���������6�j�w9IH
���u��55ؤ���Mօ�%[z�VdabX��bZb���a����(\��UliYa��ٔ��FM��p����:@l^.��U���CW���W���er`#���E�+Ĩ~�V�E�.�Cl�\�����)4��ك�c^b��83K�`�%� R=����L*�t0ʏD�:�M�S���
��Z	 ��5���%�.��_������J7���G�qfF�5�᥼�z�{��x�+�I&�l�J�Y����f|�������˧��y���L�B�M bv+�+b&ܖF�s����1.�:Ij�׎b\����\˕��>����Q�����s���4�4;��39yqK!؃h&���[�ߟv�Y�0���sd ��5�E�c5F�М��z4ҁέ��?1a�f��l�&}��enKKv��Wl>�m4�il$�>������sn���i��b���V���R�ڲ�j�q�'�7�y���0�O����&��2����"Š�Cd3�Ly�&���L�3����Ҧ�q�)Y���<ݵ5��x����#!��
�k��]�E��hr7�0"Ƭ&��m�"���e�o�+sO<��P<��/���Hn�B�������Yg̗R7��i��^	:�I�v�
M�=��֫!�d����Bg<_��<�t��H�V�{5�cct�K-� ��.7C���M�g	?�l��h�Ē/4[�ƧI�:�Ø�P���Sj��'Z�3ޅ_�w�I�:�o�-t�?\��k��P*��b|���Rܕ"����ʿ���:�J'\*�LP��24d,E��̬�v�܉F�v�����6]�$���Ư��X������8i�����f1$���լ)u���^M�>�|����&�e[�D��M!D����U�yg� �Ja4٬�	Nr-���/C�@L"5�
�>f��I�-07M�=r�2����z�Q�oъ�}����}���hwx9mf���^{ E�ĦЌ��z�Z�\����7��݀C��
@�    ���ؤ緊��,ɯmN[g���AC�"�<�Q��Zu�!�� ?���L��IC]���@�`<�#w���i�ْ���{	����ڮ,��nsK�d�@u�Β��9a�p����1��"�!6�|�8�
8N������JU<1��Aّ.#�;�y��c�{k��2]�m4�s�h��[�4w��-񴦬�)iAܔ�� ���-��*U�Z��=-����X"�~3Q�[ޑ�W�nIݙ�'6;�$�F	�$����	]���&%O�����XJ�å���֊_;���N$���J8~N��AGڠzzC��#���z�GD3L4�cG�%s�ClVY3���|9�ֺ���1k�.��6��>.����dj��pߖل,����=�0�؆�Ӛb�%�͆j���s�m*�ԘZ���fK XALZm=�?�o�2��&�8�������_��W���MH5�TI����$x8��n��1ҥ���l�J���l&�Q
)�b��ىe���ڧ���w\�|ʼ��f��"�&�R�q8���W=�]��є�!�t-m{�f�LM���7��L���F�Qv2�H��M��b�a�G�Ӏ���-���|�pҕ)3h#�=8@Ռ��b'տ}��K���߾��hуP��%4NfLF���J���4����ld��	�bL
���f.w��$L�c�z���F�f���>J8��mTJ��1��*�+,pj�+#K�_i�N���4�5K��������mbƇ�b�F�q�:&��ly;(�R� ���Xi����ƒU�I(~�.�7^�5Ӎ��c��h2���[��՜���8���_�	'��b+��v�sP�ߤI]�p��Z��ALp��^�/��YӬ�a(����RW�P=�B�R���t����a�����e�s�����}���R����-m#�@��X�!�(�7�YOe��ܞ�u;]9�He�Bl���V�X
R��ܱ¶� 7�l0F�O�*��`�af�A��K m"�Wj�[�=c��S���{'?��JۑtH��f*�e=M7�'=MϘ��h��)�s�C�`gx�G
�S�[�#��0���q�s^<z�Qi�28*���M�2^#ɥ�Ov�P�2�O�tQ�n0�p0v��4���O���#i!�V~|�[�9;<ZO��|�	=�{�>��N%kT �`i��5`�W��䥈��gʜ��E�@K��RNd�z����\?1a�6��&B�+�B�> v)�8޺'Kv1�,'���TO���z4��H�+���f㦒�Pl�j�	
��6��8����kj���nw�����Q�4I��@�&�L{eٽ��S���H������xed/WQ��Y^�r1D)ǜ��A7�nƁhIwDl��R˅����-���n��|\CMwFCl��\��z:�g{�ԣ���S���%Q�!6K���U<���aop���	��S+��v�g�	�1��@*����7䎧gZ��	E��ͥ9����:
��ĩ6C��V2���7� =ai�s�ӫ˶{}�6�q�Z������d`���[N�
b�V��4-�w��_��Q+=h��i,���]N+�I�a��L��*r���"W`Ğ_Cy*q�R�b�����,9{C|)9������՛�Q6#��eŦ����z�j�H���+a�f���V�|�s|fgLWb��NFV����5�n�,��I���6�upf���B�}$�5�6��i��,�'���L�0=�����Z��[�#��w(5�{6��S���{�֘���Q����=�҃�����)�D��FA�M;Ф.`�I�2Ck�ASg�x�Y�8~0�]	�X�-���Tm�v��ɰT[#��O���ޔ$,���L�Є=�C'eC`Q;��[I)ك��NL��XZ�$�RK�V���4�Jji�uI�|��IEFC`[&�0}�ê�ow���3>3�Ť���w��X�z�G����?�7�q�r*�YM�V�	Ϝ-�eU�7�gU���uX�9�ޒ���[,k~V�S�M�w}pLLw��mL�#�8 �ȇ�ƻ>�G�A|�VD`x-�`�7*���6��ć[(���Cl���6=:�w�?�V�A{/��s�|15��*�Í�ԗ�	�`�ՙ�G���g7��R+3�$Ą�L��ޱd�:K�+��l-�>���
b+�A��P���"�h��lE#`iU�=��|�G�o첮�KH8���C�aR��0��jŤ�/[Mf�.��ݬg���Ք�ڽ|u�O��.�9�n3�֯/��e^o�ʼ��I��ݛ{�poNI��7ohFl�h��-R�7|+���W򻯿� o��X��q8>5��0�^����8R���d��/�x�|��u}��y�[��U�N�轅26Nj�{��%N &U[Pc4O�i�)��i��I*�v*0p�ͣ��4��:s����d�i7PeѲ�6��x�1���$+�V���o�e��Az��
N�+�E%	w��%	O�N|0Mmܬ�$�_~���W�\I06n::�H��ئJZ��k�K��&A��`-M�s0��f�N��*��\�KKz{�7c� ��U#M�\{���j��7E��d�1�W�$���\��?�)�i����Em��7-sw��{DgK��%�uC�#�$q��/{JZ�4�H?zL'�r��-׏�-�D.Pm/O��LS%؏�F����{�&il{�[2������7ֽIp`3�յ:��Q+{v�v,��v�a�uFv���!����+�����<l����7�ppz�����=�������Aȓg?YM�3
G��X�v�d�	G��\����Y�L=��/���Ab�H� 1$U�Of��IͅM)g������ٚ����1�GRsu�iʏ9�睒�Q2m�b�ɛ�!M5�i*\���#Z�Զص�|;�{�?9	l�3� ��ûRF�bo���g'o�o�*Uy�d��s��3�PH�~�cO�����+6�55��%��@wU��>z�d�Ie�����M�4nx�<	}v�ǁ-żh�|��G�f]��S7�t]"�­��3���F���bo�%X�&m���P��M�`ט߭����i�F�~�ʋ�흐{2le���2)�N��M�LטK�g�d眠=�Zͥ{�z�����#�ݤ�t���[�!M��ft�=M�P�+�{cdX������8�����
�v��MȎ+�����2���ޘ���NTR�R����hF��ަ��lF�3f\�u������bo�����_G�nn�ց��X�f���qs�""����=�Gbi��vXu��ak�'�,�����I�.z-�XOWC/��^%N�.�-��[>t�F}b{ȍm��%�"��H���'o����J�7�M�����H�<���]cp�(��=��=��diӛ�b�1j=�Og��>WŦ#��03R���<k�Y��)^�hB��V0�j8�o��[덤��QF�,)�}"�Z[oqB����%$�Q��>=�Z<� &�Lc�r��E���>@�Bg����3�z`�F	3,f,r�~S^�����g*�>w�Ig�&���7L�\P8�b�Ght抨���bo��m��liO�٪�#��|��xH-MZQ[ُg!�������/?����_�����J|���/_~��˵e��u����;�&�|�Y��tM����Ph'���;�_S��H�uۍqP�m�Vb�>��,��I���z�T-���������ϧ/�����}����A�Ym���͹���e�=�^B{��.�* i�O;�Y^�v�����!�I�ذ����4+�����$���/�"6��<���M&�W�U(n1�B�P(_i�+OE����d�P�Ki�����T����:Y��4F� ��r0m�H��|b���諒�'�3�w����T��)�w���k������!��M%�u�y�Kɹ��^���Ej��z6��}8�(�r���,���e�״T0����DϼH��U��<�:�Xb��%����ɮW���lRL��t#v{#o�O̩?��}�@s\8޲��si���2�Vu��O?�!v;yTi�7M�+��    ������'�'��	�L��4ܝ���gY���<�q��m�C�cҟ;�e)v�;�V���1^��ɡ��Vp4��`Pg~�����'*�2C�����}�8^�������p	�4p���3t�i�.u�X���W���QV���S=��?F��~*�c�`���_�?ߊ팋FÎ)RcS���ؘ����F�(k$�[L��{���(�-,*
����Q*���-�P��2uq�&��t�T/�Q �VJ��=)��-�|J�:2L�˖�K-��H)M�DZ"əHM���"F63ܕ�D��ވ��nB)�lQ9rjK&%l�}�%��1h�hN�H�[�J�~�ß(��-�F���o���g���5��=n�~���)g�w��U���3�?(����E���$<�e�5�g��[`������l�H*w��pW�̖�e�w~�w�TBWbݽ�3�X���j{7Z~IgT��W���B��W6�L�iK#out0���mC<˜pc ��l�X�u*y�lP
NF+��"�7�f����=ӝw�Fk�H�� ���^?�,��.�=�6���z~�DM U�.�������.��yE�#�-Hs�{4�[�䨬�؝l�Y���L�&*t�}2�b�MS�8b3�1�������Ĭ��,�%b�E}�+�����1�CŦ��|`�\7�pԴ������D�y0���>�Mn�h
B+�t�nl�wF�W%i�h���N�v�0f����}(.~��|���5��oC��)]V�l����K�f�=�!�۸m����~և����#��.�5i6dF�.�t�&u�`jߪT�ج�D�b���:zHM�ME�w��*6��Mc䛨y
��,�\���������x��W��SA��T�%:1�@��!�h�U�/c`��	��W#Z��b+��[�ؒH$9x~���L��/��s�}�`/��}���/�>��9����[W��镥���*�W~�H��Pj�n�}������?�{毿|���/�~��o����_�(/����R�����
����vn8F���z�P+�HʛJkR������U��I��=@��>���cs��i�C���zX��v�g�і�E'G/R]<9���)Y\��ף�xb�}}�6�c^��?���>�[���q���N�s%�_�5� �n�f�1���,��imk&Ȍ�&��*��kD�>��y��7l'][����$����V߇X�.�$E-�c�1ZNK�n��K�������Q#Q���C����w�����%�cj�^(]
�šh�7r�C�d�m�O�mN�jL޲��si��1�:���h��Xn�+�`�������������W�����kK��q]�����	�0c�d'0�+�,�����;�@@SI+��ƴ�Rx�`�
���/��T�-d��@��p���
ѯ���A�=��~��뗩�n۝��W���ڻ�f�=$��.�_��BL�<sf�Lӟ��KE��T��>�{��7�=���i�ؕ򡸅|`i�l���xȖF��R�@[�{Of��Z���޸ye<v_��F~!-��i����g�u�g���Bu��թ"_ɰ�=�{���Ͽ~�<>��u�hń�f�Ň�`Fl�h�ݜ&[����/���F)栛��D�i��޲R���R�'4���rUQbo��a[ђ|���=l+��&We� &5��ӄ9#�"*�م�КE�m��,����8�1yhS�X��}Dǂ�z�Bʙ��:�2x\=�~l�7�k�8,uh�<��'�!ݨK&����yB;�O���A���VF�c�ݰT�������_��(Ɖ��N:+Yj�ݢq�k��I8��=u`��6�\�z�)j��K���m}0�`�s�(T7
,����o�ަZ�N�P�w��oM\��K5�A7��%u`�M�+�i�j��R����A��P�����1ɱ��E?K=뤰�L
��=���~��W�Yc��{?�OΈ������s&޳5�جb��S��	b����0Ч�.�L~١�d�-�aO�Obأz��Z:�)�G�ꐚ��v�#?�u��Ǖ۳e���_�4R�y`�~u�LPxƽ�dʵ#Ĕ�I�
b���P�UR�';?hh�^�r�8/����l�d옑����h0��?L���Q*��h".���N_�A���^F��QgM�lȔ�ԖR���0)������(7�DEp�0�JEI�����K��`5؃�7$Ͷ*_������Q	���֎���U퇮�-&W�zY�[��hi[0\���]��P�щ����BVd�c��fp���^����x��<�I�CŠBӑXi��u0ى&�'�IHG������]���6O�;�
����y��L�!5�-<)TZ� �8�4��SUs�b��ުk� O��+(b�vreM�L�iy��X'X�`�r65���ߟ�������,XC*|N[ʧޓ�\B��o.�+��3Ə>��ɐ��_�y��H��h� RM]�9�nJ�h�taA�?k�Â��exJؔw��[��l��m�X�t�91��Jh�?�%0�`ҹp� �n�mO4�����~psHj�2���$;�C8j43}�6mm���DU��?�Rb+�KD���7jSy��6�����&&Z���`�م�}K��7����=�4���Iuo<����W�R񍵛��I��"���� �Qǣ!V㔿������g},a���^�n�W
"Ff�0N�{�}�*A��T�C��U_��ڰ�fIFR(�\�i[k�=�}4�
mC��I����l�7C\AL(���e��u����?7���=o�F�o��Τ��Ճ�$���o{��88���O��d�{4����h�����csk����?E=��e��L:�,��I��bG�II�o�Jp�S
��V�V'�����W�����_��~#�I'� K��T�O�6(��ip�}�bo��u�V��D�,�+���nn��z���O?gC�ϯ�{�n.�>gj��L�K���ɂ�Sj���7�1�?KWF${xp���dp������׵��<+�I��n�D犅�4�u�_�W׹�7�?G�!�v���Bio%E��fB9�^h�T���ؒ!"�$6Df�~�!" -7Df��1DnH�I������G��=
���`w�\�0�9���.�r`���	|�DY]�bIiq�21%A����|C�̆s8�f#��1s7@L<�g��
�|�EOe%�%k+"-Uw����� a`X��)��,w��)�=�:�"��H%~�A�n&�Q:8Ȩ�"5c��]�C��A���\�w�4m��~�$�ݫ ^��]��09xOԬoJ�z�̕>���Q����|��`��2���>��-^�9��#)N��F�>�~C���L���2h�P�Oiw��oi�O�D�w��[������\�F�٘�$
��=d��Ǥb�vO��b~���%�.xB�r�*o� v��m�mɪ#u,�kD��zK,'q���1�q��p6<s�ّ*�!��J�[bڏ���h��K�I�I�yn�v�)#�Ȕ�L���7��V��;�Hjf-�Tx*���g�b��l���ZmN'g�Qy�~�U��H�/0��*�}=�'&QK������[�&��5��
���:��q��S\ƺƓ+c=ȁr)9(ԸDnQs�=�]_��;�����2���Z#�?�R�����ggN* ����Q�ӟ�� �"bg�;��T�R�t}�la���Wj����4iR)X�OL����Z��[ː�vf����x*b]=wi�n0yi3ZNCL�`���M�uw��-ba�R"�`JC��}���,�q1���i!������E�r�%-�v�4�rC_W�m���٭��L��d� 6S�~HM�YQo9{�.i�yg�Ny��J�3O',�F�^X�W&(���!�DאQ�5T1�u9��j�����I�n�f�?!�X���U~�������gN�)�&1a��g�	����6��D㠷;�O�K���V�#�h     ��X~u��3�>�չE�Uܨ4Ĥnѐ�+�AX^Qq1{�s�t��n��
�[�*��hV�~�®XR2ɝbRɝ��GJ�c]")�3;w���������h����ya����8h���rx���Z�7�`s�m�%bI�Җ�(	S�6�RGv[�āLp��٘�����H�N�	4�P֪P��nl�UA�{���e�7�c���V[TK�1�Pm��4��\~�n��Vp|��C�S�A��`�u�����nq.�j�6{��{�fgyg_�����1ŽD|f�?c�
�Ϛ.S�=Ğ�i�h٢l��r�rK�gs�R����cbO�茳N[ʦ5)�EVҌ�$!%>53bN���[�_7���vs!��р�49��K��I��k����(�j�A�'�OǢ��z��'����7e m��1=K�lF?��@�b�"���
C��}[��.䔪�x:�۫�S�=�n�T�I�ofS�z؏���j�uJ��ꯌ�I���Ф֪D4��d�)u�*!1�C6̥���"��	�E����{�f�Ƥ
��?i�Ik�*���F\x5=dɫ ��驧�AL�	~�[��pߌ�g
n�8���'��w&��ꪏ߰��}����I<ФT���D���3�Z����l)%j�$��m2�c�����}�RQ�ߊ�|��� Hʼ���b�VP�_�1P���D��HǑ�K�Pgg̨#Yi�?n�X- �$��������M�I)�x�I�b�^EJs8�٠R���۾{��6D�����)P�`���j�F6��O��p�9M�h�yV����F;�j�'>�`S��{k!6���<�@��g�f�nथ�O�|�-G{�?���B�|��-���(�wឣ��5�[�sG���{�ce#Y��+a�@-C7�91�{�(�n����4�gI�ߕC�_T|�Hw/M�v�L�-TY�R���e.ȦT�p�_T\�.�<�RV�f>챩�Ŋ��������Y�-3�O�b2S�)ˉ���m���!h���zV��]�d�"e��ņѨH@2ֽ����̂��+5*���nv�LO��tϬ�1�&b��%���K5s܂1��8N��v�d��m�{lE�M��n~*C���Ϥ�17So &���$�7����4lg�l;#��6]��l�Z:6A���۷�����.����K4�rg���������2ȿ1u!�1UT�I�%W;���/� 6�a��^u��=&�ێ��X�|��/J�I��W�&�����]A��8khnsG����"�Ԇ�,Mzt�N�&R���]�Z�C�K�4�Ϻ�a��{��+�̴�"�����ͤ��Ȏf��]Q��s{O����t�z���&��f�u
.��Ix�n�4�Ec.�+v��˰+��{J��)�
-�g��Z��h���Cc�;�IՖRvu��v�'Q���@vۛ�$��|��Ip�V$;L�	���J���	$�+Uͽ���#���2�T���bk��'��:�zK�u�T-Z�
5/P�[�lM�m j���E�!���N�� �\@������j͏2�]�ͥ��`'�ֆ�������U�\6͖YXW���^u�-?���j
b�"=���SR���ނS��w��f��@l%qbV�s�����o�?:���n��v��O;�*�v�����D��'�a
�P]��*�T;��E����O����FD����pa��Pg&����M,k�G�N�q���6+�x8O[���D��.��ipK���e��E�$>���Z����KN���(��IO{�lVY� &�v�!����44C��%��J�Z�T�;�E���}�V���sbo����u#ن�Vcԕ���VcLh��x�ߙe9���������'�'!E?�����%,��͊��a%������)���#�L��?�v�d�2v��+�ﻂ���3䫫�N?/�_�!�t��؉'_ԓ��^����Q!�4��!!��WC\_���־�L@�p|�&a_��#�����☦�V��	��~-�m�5���Ζ����j'���QJ�:��/�t�����?����5��Ln��� &�[܇������f��K��b�g^px���$������l\P?pt�"ddG^��gM��b�ylC7�5��tR�;�d/�e�7��=2�XG0��*�*{�,M��5NR�I
0��HW�͊j�'e��<7��xjd`\J:���o�}1;����T%m)�U�X�ä�ȍiB��؂���\T�����1؄����^jNl1�PKe^�}�P�W�3$�XvqYY�uqY�C����Z2t��1i��$Tf�Xg���l�B4_K6$�wđ��/��&�G0}頙=`�S�ECveY�J	\QV1Ugl���ji��L	��h���޴�O���W���,���Ҏ��ь�؃iJ��n�2r�!H&��aXj��:�|�G^Ng0E�K��&����C_:f?��^Ls��ԣ�-�����j;Ud��C�7cU��1E����b�e<u����)��j"�:��Tv��2�N$�\�K���f��C�ҿ��o6%�`�!L�=j��[��QS}d����Zo6�C�$Jdg�}�>�px c�����>��*�����O��o���������I��D��Ee��<�s��M�a�I)$4��m�h������������Ҿ_��3�N���LK�
�����|�$��9�:]Z�L"�?\�ĥ��|����q�clW��������\�����d�����/��l��5��Y��e��B�5�34=��X�FwΧ�~���ѱ��$!������[������q�E��2��-3#&�:�8��P��v�(�mϪ	��ޱ[9"����?"�{�X�v��x><#7�7�#J�u�s�=.�%�C�����A���Z��-�>$d�+�#B�I�oz?C~ǝ��c�8�X�~������l�Yϓ����ɡ��M�|�T�bt�l>bЫH�+/l�a�%8�<Āay��O��.PjZۼ���Mz�I���J��u�LZ�l �2f;�:[����XfL�Q��R94boOM>~�q�|X�`�T�.ސ_�>�&f
��5�����t~�З��C��H]*l:�����D"f%��C���J��ɥq��,i߿�DP_�,l��DbI�|�� epӬ1g�RmQ ���%P�"��(��)ot�f#��v��o����̖�9�/��
�;�>���~��`�i�FQt�̄W��7�sБ#�ù��F����Zo�gX>ZC~[��{)/�b7�lC�#��:�� �[Xa���aX��S�e��L0�e�ݖ�ÊY��Mv��DR�z�����R�@��=�J�&�.*^�8m������B���k��$�Ů�0<0�&+i�E�ؒ�z�E=����=ߘxDA�-�p?IZ�I+ܟ��ñ�wm8�{��6��z��7�PS6���p��o8]����i�w=�%��+�ە}�3���]����^GL6�b�ݐ2�?�Jsx���Dٺs�#������g�t�k�T2W�w6����w�OQ�~U�6?���I&�k��֡iiӻp�{��/{��梕�`�x��5�����UN�Z�� K��Ui̭�e���皵l�����M$���'9.��M������I��}���mjy����[&�t��F�	,�5�wwj�TƵ\���R�@����P��7=���2��5Dcw�OkO��-,lN����J�3�.}bv����+�W��|�tު@�M��⫥�����-��3ő,M���1�����r������4� U[T]m��_=9���;T��Ėgꌷ�)%ك�{����|ю�ػ�|�j"���7�O���������!rCz�0��ٔ�Xs8��7p)��8�If�H���X"������=+y~z��-�5���1,)���9�����Rҍw��o�r bؑ/��n�N�[���I� �  ��w�BN������7�N�0��0�vCv>���M)*M{�S��&��)<�Ж����)xFp�jJq�{�j��͢f"^JqA�9})6n��d�0��`J�I���p�9_�A1��~$d�U�I[�l�cx9˨�VA��u�����X��Z:��"��/�9Gd�9������Z�T��q��?a5�����BՔ΢lxX���!gߒ%ޭၽ1FoHvޔ���۝���
oY��<���Zdo�ؖ9�bϣ������z,
��
o���'���Lw3`h��I�r7�-��dmä�<]֎�x�?m�J���i�K48�'щ��.���WŤUO,M�6嬆�JS��"�z�Ƌr�M���nմ�=�� ���o�E^w���z�h����0o���N�G>���|e��C�츃��E��C�����z"gIG#MK�,�VtJR�k�G_�L<�
b3�)xBT]QC�qw�v�?��*T�Nc�n��3d�J��e�i�I�r}_��H�@i3}���)����"T��+���:	������棏pY�-+8�a.-8zN���E�l9iS5:�za�a��RZ!&�P�1v�K�J��ꙸo���̪T"bKf�P*U�:ʿnQ�lWA������SIv����cif��X�<�TWh֟���O�m�6m��Q�]�򯏓 �c�<5b�ӄ",�\�бB�JU���lɱjj҆
M��E��fw /�EZ�T+&}�T;� �T�I9�X�ŏ�:�E��
�ǀ�/��}������������.�A�J�TI���mR(��5�kh�Ӧ��P�	,*�?���U�}����gJ���uSzLY���U}��.�._��AL8]�����ۍF�I�������.z}b����uU��y5n�	���}%$�~_��T88�G��U7�!�<?�lݢZ�e�
�T�R��Ų_ފ	��4�[aiy�n�79O��,]�纻��n�����M�M������?��������      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
����ݖ#;�+���W�f[�/��$PU�B@ZqL�iN��t�tF��'�#|g\<62��Z�f�N"�����r��<�r,�0�Eh���=�]w4����������v�}G���a���X,�\����Tvͩl��1�C�Xd�����bZ��;��S�,�Q)�b�;�n�ىG�d�.��OG�Ѽ$w���\�|SgU�XU�������ʣ�B�����@�7�*�����w}����� ��dQ�wh��P��Φ�f$о��/(�;���&�������
ioT�����|{:X����"�]�]Y�W���`�c~��������+�e�P��:F�J<H֪��J������q����Y�+1�-��Y���D#'��b�v����ǲ��0h�J��%<��UD��6%��)9b,IZBb{$v@��uy��e���oĒbጴz"x����}x���ɻ\��Ī���|0na���{�{�Z�� r�I��0�푮n�D,zm� ~S�C`O�{=[,��x-��*�`�I��Fa�������V���������l	ו�]x7�f|�-x$r���&w&k/���K$�j"�䉇���XhegW|��X��Y�b�-�j�,���1��iT���j��9;L�b���J�g��Ρ(�����vﻺ{�,^V耙�]�0����ɗ��'�-�X"�[t�� 4�E�w�qnq>�L_V��>��T�T�GލSG� u>��*H4�䵛%�B#է�Ԙ:�
wzɡtɮ`G+ �������U�?��\|�!�|�J�h�R�e��@���DQ�w��e@{GnU���iJ(�(3s4�Z�_�u��Q�0�>�?��=����b����`���є,.��'.Y�� X��%��;�����C\u�k�]%�<�#�iw�0aKn�E?��[�7(����_�3΁̮�ܳ#iHR'~���3�pFދ�ȯr!�Z2qWr4E�Z��ǻ��#�X����y�}{�Y/kb�MK2���ҍݵ�V�"	�dI2�hܒ�(�Xg��Z�.�,B(y��,\�w��L,ۋ3�^�1|@�5���&�2�<��?KW�*ob���EBt��=�5�ÃoUv�!�4��u!qY���Cca��&�ĩm��>�(v����2q"K�������<��7�.�x�b��𝾼WS��貐�`y�f�	��[�FG<�8�ˋ��R�U5=�2��V���[�b�f��G��������Ufd�r�'��u��'+q������'�o���l!��t߲�"]�e1������1w:�>�)<���wv�y�)[�^�}yߺ�*��u���jY\�]��s ����N��|W�e�AU*c�I|	c1fK����j�l4?@q�RT]Q�u�PQ�ĺh����..H�<M.^�m�m�z-q�����~����і<�2�,.H^&���R�JB�4�X���n�,�&3��`eXMy���'�|p[�ɭTW"Y�=��d��N    �-������?��uQ&_����������{�D�K:c���
vV�e����ºa�s��r�x��ւ����+1���� cc��={S�l�M���٭�`�๐�,ˏ�i��"�N����=��U90����ʂ�����|{U���dX��2�����]�y�g��M-l2�4a��9����u���������ŔY9q�����`�>RM�Ȉu��G�h"Ma�/���-l�����M�@�k�U�}��F¬G��<�b�S����G@��� ��{v���Z���\�%��.S��t��2>]> 	����ú˲#��q͆��..H�=��3�cW8�&��:^uf>�ZR��a��I.
f�Gj���/f8�ILA�����	v���� �&��kx��u�4�m���Yr*�������X��)��K���鰬��#&;,3��o�u�<��=��-�r@�Q�^��I�nAl��y�y-Vm�Se�� FY��@�հ"���Rn69Tx�s��i�b)�bK�V�Û0p+�,���/v�Q�"F����D�y���M�[����d�&�L���B����݄޶��9+���B��O�ဥBjđ�eA>S�$�nZi' +�vz�:,�v,�W�(�M�`M��`�<]����)�FoMf=#i����q�L����I"2cIX�� ��ò~�X��b�g���*ަc(����"���޺�z�;��Kb��V��{���$���@1��VBԈ�%��wP֍}|ÿ�bmh��(����׉Y��h`T�6#`�K�&,	��>Xl
[���}���RM�Ù'��H��i�������Nt��nWv��y����V�J\6ط��|�zƒ�/���OoC��Њ�E�ˢ�e9�vF�5�,YL;�x�X���CQH��k�mc��e}�Ln��}?y���1-6kb̫�Z|�X|�	�z$j����.��F:��.�Z��,g��O��������{����NF2
����czb͝�����<�g0������q���ia���(�C�� #��Q+Q~k�ũĤ.o-M�\a��뿸����h��O����� ����*$.]X$n4փq�#o�`��-^r\uaMGY�hܱ�UW@l پ[�:F.�0����^ڌ����a��p�ڔN's8��:?f�߫�3ɳ�YS�Q�,.g���w>ર�X:%	ȲD��ֻ�^����eax�^ٍn�.�xd�P��C�ء��n�o��gP�ˠ��5_aIqץ^�˚��:ub�k%s�n�E�Y��b�(a��2si���w1-ʗ���se��q���/�t�A��][�4=���%=σV a�X1y1wg�9� �ga�.��I���[�?}�H\�������x�Ŵ0߾�?�U;#6� 1	pX��ۚᬵz6p�S���F���O��JA���"(�1�ǡQ�Œ��h�;�-�h��5-����&B�����`���Q��Y�Ks��̋��[{�>��u\)�K&��Cv��%pG�[��Ni�Z��|�tBNy.0��X�~��1��O2�b�֨X�,�nQ�2H�׵�J��"������v,@-�|e�ć�m��U�d�21���Ҝv>?W	�{HY�+���Wv�De��~3.m2����m���k9l�}���3�A�ń��+��������1e�����;��)���h�@��Amd=x�7
���&�V��u�ެ0Ռz�a���z����T�᫑�b�!v˲F�K���=C�dq���+׼����Y~EYVW�U�qU��ܬ,8�(�0�r��,���ư;�/��d�H6��ZQ��U�՞]I|��g"��i�u��v���:dJ����P�[ry#F((������t�T��°��>�ޘ[��@����K)�(�k`pB17�sb��\�޽�r��M��*�߱�pğp�R�A�N���3*�.��K<m���l-{g1A���zۡ����3$#;������[�0]:���Y\����$,@HYD���W����%ی���f�DT����t�-3�c"�N�����>�r-6��j���}A=�w�os��zATV6�Wuკ_$�ȯ4��P���ISl�-L�Hl�z1e��6j�����esq��eR�[-��P�x?�箤)Ů��`�b��e	����F~�dsc�dG�ˉ��4MR�b�fw��'����M)�/����AwQ��ˤ:�|�4�_�����@yx�F�P��K9k,��l�eP�I&	)��Ó̡J6��K���0Е���N�Hd�Ã�l%T�/$`�[�yO�sHLf��]��Ǣ$�1'�����-zA6.�Y�<�ꩧc�s�l1�]��G���@�i�1I]��9��r��HV�,��PF�_d#�A��D#^��I�Av��"�1|��k�D�1��B��Z\|�	,�	�+̈��:A6.L���Ekif���0�g8�H�/G#T�$nV��&��mA��0 �iU�F��: 0;:J��ٮ� G�Vȶj� �Eگ!�B⼹&tH��m�Ö�Â��`f��LM�������p;6k<��G�!�����r���\�tw�!�Oⲹ��`T?:a�8��Ƀ�]�u�e15�Z�pc�d�����O�a�H�|�g���BV,Yo�LU�z�~O�*�H�g�[��kQTgQ�sX�u#�<9W2�wW����߱�Ur=�X�!�Au�]#om�L"���E��g=D��fA��߷Ol`����M��.֪��bI����1%L�_V3)#��y~��ᘌ喜F���BTʮՌ�_�fZ�ʈ�e���k�P�W~/��;ҕs������vm�l�e�8�*c��{��g�.�`	�7�1���Xr�
,���߄Q�,*�����y�卂��Fv�h��2�9�\�J�Ƽ	��-h7Yު 7ƚ�l�98UBtP>FƲ�,�߱��H�iErm	;�1�>��x��e{�S����Z�G��W0�`vPai`r���`�`:���X��:�b��FՎ����$,Z`)_�y63�6�t6�D�jώ�gZ3X\5o���,�k^ ����gZ���i|rq�i�er$禣a]H�c�o��vPɣ�al[h0�y��Z��ibyn�>�Z�����W����lV��7�W7���{q;�ɭF�C�~Ģ�<�PWJ��?��r�k�>�e�_I���t���.nsƜ�Kd�1�S��lw)�$(��"9(;�9oY�y�*�k1m�/�u�b
�0]�+�E4�ҵ�J�\V���L�*�s��V���!�(�Ũ+�!l�����坎R*�\���lKi�`�Ea9i�W�$C��lbp�#&;*,�����۫ń�������� ��E�a/�����J���w�����P��cÊ�d�H��?(1��60�BVS��p��n2���+�@���?�Ć-�I`�F�}:S^��D/�`�M���O����$ߟN\�ю&�JجwI
hX�O5"4+w�j��N؎֤5�dq�`���k,��~]����$[��P�E<W�}�"EVr�ǰ�
v+.Xο1M;���*���y�MƖ���m�tb_?�p�����5��l�o�_���!�ǶZ{Xv��n�ŕ2jZ=�#�s����e��_�*�J�R� #Ba/�{�+)ˊ��veg�IY�aP8G:m0�H ������R���z���ߡ�=������/��$,�f�I�w����Qt;L-�[,cyi��YU�C�܂�:�����;%=B	�ț&i��E2��aŴ*����b�0���-�q�^ ���}��qf���3�b����ⓘ�m�?
ɦ-h��(y�a���B�bzK�1����-&�P���}[�@ ��UT�{Ec���ԃ�EvʛB/A<L�f������P����l1i�X^b��́OϘ�,����)�CBL�Ī����X��yW@���h/W!    ��f�

v[V�i!�u璸jG:���5��XtE������')g��lm�]b�o2.z�,�iFbҚ����^ڒ�w�ZZ�hl�b/�UY���Մ���C�.s dqY��'��� �.N�Vnb�ئ(/F������=� C�Ni�eM��r(QؑhV��-X��/!�ÐL�DY���X�ھ�1�K�0���]âh�ay����"j�1캛��ƽ�dqA�|�����O;,��0�Sb�mr	�v��8�������G�l1�6�Tb�\',��]?���P����Ѳh"���~��8�(@�Ԃ��ǚ���?)UƵ�څA(0�5z�%�D[O�(q!�_���J���!`=��%J�ᬣ�s�3�P�*��a�Q����ZG��ír�Qv�n�@"��2���]X����l�W�G4$.k�p�0Y:P-������N�����ނdV`��r`�f����W$����ð�L3��b��|�N�]2"Z�i��/$?&:֟��e���%Hz��(����h&1�׻�e��e99e6z��U��: �� q��~Ys <.�٢��c@�u1��������8 x`Rk'�w�����G(�S>8��9aQ6�#�9G��&癃|���$��E�c���M{k0��6�Di�eYi��L�j�Ɛ��.{xz���r�|(`�Kz	�r�\wi��%w�מqi��_" ��Im
���"tP�M�Jݧ-5���
�ͦAց��b�&�OH��w��'�e�Li;$��W��Yx	N��?�`�G�_܌�ʱ��=�es*��B�'C��G�E+.P�*���	�^�y���D��.�~��k_'e�Dǃ���<��8�hǑ6�ߌ�J@b��߉��,M�j�̲�G�3@��,�!�p��=	Z�٣X�GqX��B2��G�CUiu+&W��	c��#��[p�[�X��HQ�.����0ezߡ朅b�ew������P���U�0��{ia�U�Q�nYV�+��al�b��d1e�_�F����V�T^@�-����`�w$��+�݃C"�1ao!Iޤ�+�����/վU������������%1
�тs�Ys�]���o,�b��SV���YLJ�0��,�"(�����Ŧq��R�>���P&�{@�������qऑ-��X��j��n*rH�B |J*�x�ⲹ�|>��ϓ�$�u?��O����>4,���nr��$����3�a���aQ7^���z��N\b,���ޓ���9]V�7��FK`����]ӯͺ�B�*F6�
nݯۊ)(�����4�1�ha�S�YS�S	#,V�/q�.�?7XA2�1K�J��ߏ�X�9��+��baO{��z�Ǒ��8�ث�l%�����MHѴA1u˹<����1r���]���I�����-�����v�Dc���|0�	���ʖ_[1p���@���C�[��TѴξZ��b�x0�\qXL���rb&�VP���;ᲅa}}Ӆ��\U{(�8J�ce�,��C��<�Jf�>zT�3�7&�
_���r�e�e��Eη)��*@�yN����910�*��M:$*>k�M��K"-�I�5�>�����)��p~aT�5�9��;��M{���P�n2����)^��a<���6ᵎ�`��E��+��8���O�Fo"BC&ڊI�}>34����c��������Q[�=���:c�\��{�;0�!�>	o-��VL^�[X�p[9����Jm�9�>`����Jpw���8�ӽ���i]���8�49a���I��6񊘜�[qL�a�d�WzW�R��.��6p�s���z����;��@/���ƭ�����z�i
Ă-�L�Ċ7ve�]���nD2��.;5�,�yI���kU��$�Sl��%y��Ge�J��Z��������<؁ ��6�zpY؉��v�.�����:'�SǱ�p���t�ivS��*� �S��]��������p����Υ����s�d%*����'a�uB�R�G��5��N��v$�ѥ.������=9�H��������G[������}JB�)���&�7#����q��|� kߝn��U�`)H|��3HD<j9��jh5��tu<?ޝ�̰��4lZY���m�H�P	��=�Ve����U�����������_���&�����#6^ӄ�����h�6�FΏ�VbVbPzy�A������ZJ�`>X��G����7aCF�j���,���(��{#�!%;0�P	PQA�sU?CW)�����������'5�b{�DBD#���E���oʕcS���hH{��@Lܴv��9�F&�h��+�>�e�$W5]%!��@�aZ�|�K+B&�
V�+V���*��ѐ�MꞼ��K��s�i<��ds�g�V\� �1�&0��5v�H�^����������z( ��e�&��(^���UF��z�;�S0Pڛ�]Lq/>ύH �$7o��Z�2WDߚ,�Y\5%��W�r���"q1����L�hH��6��x+Ih�X-���|�*D�#1EV'��7�l.�桓E��1��Z�b(���5��
������<˦�k��&�Hv<k�͝+�Ϊ�(Z���(�;`!qY���ɲ�Eqx������h�R�l���Ҩ�\f��~�ɚ/����76^�P 6��X�d��И ������D�#1|�����?��?���U�8c6�[���Ś� [e���7ba3v����,���������K���-�f�森�C3c�亇�i��t�i�5.=�,��\��ª}8��[�\D�]Xڝlw��ە���L�W%���s X���q��,)J����z]S�8����JL��K&9M�8�� �sD�z���,��k��l�k-$vR ŞQڠ�g/���@:���*��b�CS����mƽ�J��c�Vb؈mW��IZ��)�p�	�^;�-$���8�y��
����& \;���Z\Xw��Qc�*]c ����u�Lh�o��@m��&\'����^����H�'&�C6^JObR��x�$Z�tv	xs:�v��i�e��ݥ�����&q�]?��L\��SH�@d�#Jr=�iM�۰]w�B�_3�+ �A[/U�ˢ|�;<�c���-�hя|��5i�tYmzi߇D�-$����u�!b�'b��
G���M��3@P\6�@,� x�ps1���%Y,`U�|�V
��,�I�	�O����?�l.�dpr����J��������M�?� �����J\����Il2�8uR���Z<�P��Q.�$ȑ�v��5ӊ�����Y�;��ޢW��$�㡄�b`_�)JL���o���v��ӯ����>��B�﹂o�i���OG
�z�q���5bZ����P9Q�i�}��
8�9��ꇕu�~�.�a��D0ڲ�.fM�,��H~&���j�۰�m��m�x8�(	��k1��b�swi��'���d�UT�$⦗"�V�OB��H��bU�p�0Y\-�d�i��ɰ 
3�U�"g��oiP��늮�܉�ρ]���T�,w�v�$��i�L���s���]A�r��WHX��˼��~���h���K�s���F\/������G�2������ρ���C�2??}����G=�E����ղ!�F���Z*�I�-�Ɛ��C.�������xg_c0�l ��f���T�"8�҅*��9���5|�J�Sɕ|#YE�ŮY�
[K�_Z�4;����1�����4uK���**,��X:�5�y�X����Y(ߠ�e���d %��\5.2"TH�jԸF�E]t	�aQHL�C$���F��pu�	�m�4���\S�5a^�)9 !1-��3�i$����j�Ȭm��S;����s�@�bZ�7�ظ��	n؄�Uy��t5������ԃ�$1��~��	�NA� (��_W����L�K�{溘���Ϭ��L���i�$b�z�.�}�j����Y����� ?W}�T%���+_t��@�\�g^����NSn�r�wFP-�R    y����P��5��=^X�i9IUzK������R���3^�0�u��JLɇ��s؃�+�	�N�Kqyn%|�(B�_������IL�r|�?�����a8.0������󐥢F����L�dw�;��i�p���LKr\��*"2�E#5tw)n v�4�,,VT��,66���$`m�b�t���~z�e���k������#9P�k��<Ȏĥ���O�gvah*yb	�U��$���3�n�2���D�J���p�	4�Y�#i�Phn�`Pϊ�騊�T�=�Bs�Y��ȫ������=�#(�r�z��9SON�(����v+����v#�c{l>ǁ7�]�n/&O�1<-E����k��N�t�a�{�>��(�7c�G$�#�p�j�X_��'���L�,K_b�ld/#��x��V�qNc�Te9��C�ď2[��Uy/o I�uN88�8�i율�|�(ׂ�Q��c�KW��x�6�+U��BL�.^;+64+��@&���\�Ĵ���$Z��	k�c�"�%.��9�\!!σQ#Ŋ���y�A���0�8kl��@Wz=j�>Bj��*|�w�Em��{p��J
)zV/*��R��"�8}�1�#`�H1�ߊ�^�}_-��JC}Sʲi�ҫ-�B�.Ow��O�x�	�1/Vl��Ij��SW�p���v��7�	Յx�G*p���影��8��D1@n\.땷S��*qd�(PI���/��1�4�(��a��4��Y�/*����x����]C�y�f����3�֒��.��gu�Xfl}9ŸH��[�Ue!�ld�`=�	�߼>"Y�L8���rI���\M��1M��<.r�#IL~��W/�!׭|���8�W�%a�.	�%.�h>h-��H���*���d�*~�n莒H̪,�'��`��u�w1�X_nU�1���J\"zD��CA��tzA��;��cN� �J�F�_ �x�4��ȍ%���|��V�=s�_����mT�O�b�K������-��a�U	::��T{c0a��u���~*qY��N�͖�p�l�k��s��	Ih�h�;\iW�P���ϓ��f|Ub:�?���CS�4xF4m�+���?(>�ì��Ы��WfiYV�h�e��u�cYY��%,^�neY�R�N��^��NBߦ��(f�eqY��gL���5��$9/ЊhX�R�M��a���om��p ���1�������Ya5�]{oQ�[���d��с:�!q9�<}~~}<D�:FZt���c�Zc��"��y�:��a���Ry�,�$}A���)���*P��[�%;�G�}�K%�
�D�2i,
[*u��b9$�?������?���~����?f,�\O��}�����s��g��.�|��:Ò�G0�p�9ևQ�[��BJ<3�<���Tϸc$.H^��8.@S
|Tܒ/����m7���`p�ڍP&.��l������o�olyA�fK���^���r5?k���D�U.��dqAr��:1��x΢V@��<�h�m/�V�`.��fH���1���z���}f��l�iUt���J�_�xR�����N��
Ps���+i�˲:�7��WO��,���br�N�F�EC�UJc�훐�u�t\���cΤghȵ`L��*t_N�Fɨ��,�ތ�n���Ì�e�3GE�4���>��������?ϐ@B�l����E�ʂ�m�,�KȦ�%�O�Z����V��ġ�&���	��D����ݖ�����粯���(�vzy�@���MŤ���ۮ�pu�H輏p{�oэ�ⓟ�x��ktgB���B�����3��d�E_�T���n�G�ҫ�b�8���*]�p�_L�r�����_��J��cG�:.���F�_�F��k�t��[Lb��ߟXvB�ݦ]��0n�DR����`UU,5N�**X�`�ILn��ï3c�X�۬�B��
��+���-����1n��@.�
��������[L編�ۊ=��4�G@'����ˌ
�,̼��w\�$�g��yp��3K�fdȗ{n�O��:(�1�l��a�B)fY���o��o�<9��Q��
�(����@�5�*���t�^���g��m�'�|"w`�'Maq0m����{���`{Ċi�X�kM�nM�bqne��H�(�bn{	��pQC��b�V�m��IW3��{�ǖ{s)��E�z	�^
W]�?��	���`��b���݂�\�%���P@`G(YL{������\�ؔh�4�7���Na����8c�ݍ��0ҧ���|�8P�� ��icrZ4�Қ�4�+�����瞿��yz�b�(���c(2n�x��Ηk(��t�N!���k����՝	�m-�X�.Y\��t�UM)��	����lo�t����"������+w�"+�*l=(�u�q��(���'v�/.q��&-��4�BjBؚ|����Q�fJG��H��̒�2`FH�/���C������M�ND��R{G���߂�����Ӎ�ݢ���X;ݐ�<��6F#�d��Wjd?8���8	`�>��@��'W�=��|�A�H�!���D`�&e�7i�^t���<���$�UV\��o�B�����@���3���
[FEt��KP���g�^�%(+a�+�d�&;��ӕ?� �d��6+Y+#BI7� t@����YӉύ��*q���|����r�������� �].��e��[���E�H�׃��=������,e��,�S���Y�یX+�*,� �4�0�V�oo`100Z���@st�	���x���f�l�KaL��\�˲|<�=��1��4�OAX�{��S�N�W��-��,���K�*1ݕ�_�=q.Z��6�cZ�ºhu�tZ��l���E&���U�
�I�?=�l$�j�K���>V��#W�*�+��p0�I�Eށ��W�=	>; rJ�����5��-�o�����b����\�"�x�+l,&#I�u�`���vs�/H��F�À���a��bpqM�O�V�9(r�t[�x�^��Ja ���6|;�����5��Ǡ��_��oc�b3�8�ͺ-�s[�b�ؖ��, ���2����Uq8��n*�u������.���;.��_Y���J�#a+E2�kߢ�74��*���ĭ5N�KR���kK�E���EW~~��t,r�`"?)�����W���>��o��w%.KrDc��w8]Fs���*TB�U �H�'�$31����˙��#H��MA�\���o4`Ob|�N,`Wҭ�!{����밸��eK(�#���Q�@o6bQ�9��j��B$� e��K�(�X�~�<q#�5ֵ+c�4��D��:.���_�k��y1 !1y�x�#`���&4 ������N0��2�����������Ż�����]�j���[�&�Z�$����:���_l蘞w�T������4��lA��f�X�h�~�z�2U���$�؁��HZ�d��f�l��^��oPo�s$3adq������;^Ѐ���Z�a��f��l/)7�v$ӝ, ̂dq�Y�H"ܶl�ؑ��66%���4q1f��ܳW8ת�.&���cqgWH�6�N�Ƒ7�ds	����^�,��|�TOd�e�o�φG �Ul6��)\�K�&�a��Tv�lx[�&����wt�<������;[�Ѡ/)�ɓ`R��B����*�-lFbB�a��`Rv1y���Y�����m6D[̱+���qH�{���k��E
�廂�JL����+��# �l�9�aQ��B��k�Y����0���a�͈%�	������#*���x���j<ɰ�`�����y�JL���3,��G��ְ��,_ a*�Q*���
�a�,���t�i($SIU�՘U�ZU�]��tya��?�W��@_���4�8��Ɖ��C���sH'0_G����Ӫ|��A����cl)��#��f{YT���`Y��J�m�+��]�d%�/������������)(�M�    Bq]X�R�K9���.5.p��Z���JLs�t[c{4��fsZ,G��kӀ����VfΦ��:�(�L�f�0?�_�ZDWz*%�&�ڊ��YpƆ���g�}�bqe��4y0�$�IUv������SluF^�����Vx��(�IB��	Ρ$S頓4�m�Vu�wZs�&���^~i��Wb�dϧ�<=BT�[�N�+�aML���즅�_��[�&*��>\	&&���.b(����,�:JE�q���J\��?|=?O!@��{����i�.ѫ˲c�,��=Fb�c�A6]�b㦅�Xƶ(���Y4S����~,�'q�����AW���VeL�2�3\��9��
n�wev1��y����� �� e{�Y��7��s�u9�?���������4�%���j��A�e�0����Bَ�XX?Ƙ�b��]�v�nCWډ�鱐�e��Iib���� #�$h�]G���8�"��w�#���d�gG���;���+D>����|G]�v���g�c����6�Ż%��E��8�+��]�^%.{�a2e,��@��|��&�@Fe�L��:c6aN\��CU�0$맱>�̯����xO�!Q8/K8�U�����i�Ob�[t�ͪ�nVw����+5�?���,&��|�x��M���t��.��l�R�bGǱ�b�q 6'5Q��̔��嚉��lf�D�G�O�������V	٣�(3�q��f��mL�Zm��O�e1@Z#��>�ɲ ����[�:]��<m�03��.j��P��[��Ua�c����U�����q�ujê���
Q	1$��}[:��3��<e]�/�u{5���Z��NI��唹8���	opp�f��)�;4�v4�*��W������+\,P�����P�͡�Wi��
��=r%.*��������7�Ujɩ$ �G���1����q��8�؞��&��������Z_����0)���Vb��gv2�ٝ\1'��Ԟa;[�o��s]*|q�*�Y ���,e%�X�3��wX�#�$J����H6^�x��@�JF��1����Œ���UaL��Qf �F&_�+�V�|w��j9"F@ff%b�Gd�X� C��)�#��^�"!��{��B���P�Km�����,]���W�ɢH<���7�	3lחj��p�o��֋�[FKt]�z�#�y��J]ö~��`̃��=����N��k��6B�c������@�Qۀ��������"r,�tYV|C��2�	���x����7��}N���=�]L���>9��S�L����[��e4kcea��_[�/�Ē��s��6�J\���w>f���a��ް}��3��^��]C�t�c�s�󒕘L�[PT�VlT�}���`�bu:�^H���WbI��԰-�nhI�!Y��W����w�}z�_�:6�N�Fd�}B������I|';ϴxJ�1���
��1��K�U&_�z%o�`����C\M�T@X,����+1eo ��@ﰍͰ�9�n�IK����/5	�W�K�#�,��0_S��(0������T�x̤�@�xÚ�93R�'%+qA���5��ɑVm!8i�`Z��b��G}��hG$������{�#�Y��QS��
0s�p�E���7��U�]��c,�<i�j��V��9h]��5.ÒO��g�*��{����P���iL�4���Bá��@6W%�hv���ԋE�������\���� ���s<���-Uc�aMj�82z�رF2q/�"e�3 �e�=���D��ʀ����e�3q��_R-3c`ƚ4=�������`�
$A��*����<]��C�Yl�4;m�����J��/lg1�Tn/2�,
�'��g�*���\��A������Ă9ޢ�����B����V���.�o_��/��9ho��idQM8?LK�Yw)	�%34]$.K2�v�M<�������&��f�\�'��ڴ�&�3O������D*{�P9���H&���71��E�*o I�$�(��ٰ�@�l�c���I�|Nr$t�������Tbʮ�X2Dݮ�я"B��a���t#�eM��j]|��	#�uH )ҝ���Ъ;���}�b�����땘L�iB뒱`�8��f;H�vUn���Y��"�dV�)��ƍ�8
�J����SK�i|\#��w�ą�@��i�އ�`5�Ǚ�b�"�
t���O-�cx�?�W�A�{����!rD��I�z��s4?ha=�@_����W9(}��9p"��</����DO�"�MJ������lZ5H�j�W��9}�/e96�k��TK����#ώ���:�a�n\H��S���m�{&*�~f�u}aفZ���0��?HMx<:+Ȓ���u=�7>]A��n	��+���jEf���"���z��H��f�����n<���ˮ��RupϲH}; !����}���k`M2�&���j��R�3��qsa����Z��c`�rP>�̺��u�_����<J�,S��� 	h�����c�=�i��89���\��2�`f���ZB�JLF�u҃�;A�p���p$[\�M�Ӈ��j<��ϡ���XHL�rz�ʯ
v�B��Z�/���i��7#�h<n��9�����oN@�ߔ09 ���h��[ԓX��,�a N�g^��l� �&�0j��6�!��߸�D*�Vd/`�c��j��3%�d�kۯ�MZ�!3��bn5c����zcM�ޜ^��b��G��E�P��Q��q�S�8]���$��W�����X��[�y�[l��6.��%�����c�BJ �,HS���=��4l齶�]qy>�/$9�KI&�=�]��ħ_g:��Rmʉ|lEvg�.�%�����arf��]Ea%.�����ej�O&_^�ͅd��"�r��R�q����1q�r0���X`9��Iơ� ��a�"ums�Y��#&9p����;+�iE�����,���i���ڶ>�]mJ�P��q��o*$���E�����EA�zh���A��a� �m,"�A�y�$|�z�U_Y�������R
�����")�G%���a�Uݗl|�1�~/�a�BZ���lXŵ"/������VF�1�R�|==���Ag2� M��(����7+q��h�-;�Hד���7_��C�F�M�7�����ghOc��Y��h�-�B������2N��~���]\��~�2�� ����R �ß�,]Yq(J.�;��Ra���RТb��b]W#5�b�I�1��۾F��1�y�\�h�ӻ P�[����k,˴m��g}�P�bw��ӵ�O�����X5,;G׃ppMK��;h��#_=�,&����og�^�g��*��n�����C&���T`ؠQ���6��e������n��(�;f�\?,̠��M���00�;���˲�*���f5J�`�淶<���;��
�#�]�B����xeW@b�'��JW!A���&�򰑗���Voyu�[�%��h8�$���2��4e�qk��[��%�/&�i���a���JL��o/3{���0��07Zv����4�e�6ښ_���*1���S,: �.�d,�Q���f�=5P6}~ Xfe{($&my8}�<��|�`pY��E=�%d�i��d�I�%���?�Z5h��#�i��'&L���*�`��`��0x(�b���G�f���v�6z�R`�擓e�C�D�98d�q�*�;��;d."n1&���顣iO�uSI�Kf4��ã+1-��T�P��Ck�����б]��Zɼ�ő]�j1@!�[9��\@ٶ�E�[;����7��P�&��|���=�i%.@^�r�1�/�MJt�ጊ�%L�/J8J��/f�Ĕey}������MW�;��hN/(I�aU�]��]_�]�)�:W�'�,�N����#E�(7(}8bj�P3xEU,�@C�#��Fĺ<'eD$ܵň��"���E���906U�=`��x�    {���d���аոF���|�PM�����뱐��������0M�:��2�u����_b�����ЦG��)���4�S�Py<�E��X��S1��`8de4!��>r�U��JU����a���$4O���X�W��ㆻ������ޕx��f,G�Ʀ�Iމ /�-�4JvǘY�{Wh&v������m����R�7��d��:�p�ƫ�b�UҚ��#W��;���t�
���z�.׋�(Z������b��<��9͊)��ʟ˱P�'+�ЭjY�|S��� �x3��p�C���dq������_53���i+�°jSWM'4�m.QĪ%��f���X�������l�]�"����<a�rb��75�|L_���RC�.�rF��N�c$8b�k/�
[�k�2]�c�يX5�r6���PH\��v��|f�&����0�"�,��1Ͳ�V����y��=۠�$.P�?}�*�"�]��:1R�Y�׍�O�dr��\h� ��Gv��M�g 0�i3^I�ذly���[#�1�z���\"MR�=���6�����'��G��)��)^�59��1������<.�������<[��梶��A��gKB�iޮ$�U�D߱u�JfI\U�s�efM㫍���-�4u!% Y䚌otG�<��ė�?J��h�)��a\��R���ZV�h������0���)���?�����3M��!�O��x�ȵ�d,�ƃ�,�,ޕ��l�9P{�(��̲%��.iO߶�ˌHJ�Wc�
���q�2^`Ϛ&=�P�afuVt����+X�
�8#�,&u��7'=v�X��ؘ�-^�u+B��3Xx8��$��������������`�X��,}�!�����ŌQ|�S5�."9XHӲ�r��/��+��t&�`1�X�6.>��f��,2NG2�	̗�y�E��LB_����bU�0���d�Y��+�`A1ay>}�:�Y�7/�ʀ��$��vn�j���3��0���!1�y��S4ƗD�kʲ��ƚ�����XEJ�2-��ļ�KD��c)D rf�$�X��Kq��F�8�12��@j�ֻ<��q+s$�!*�/���6�=��b��b�+�)��#1���yỦ2�Z&���c��6��^8�l���7\K�F����U������>��U���$�Z�ε�f%�Wa����4��UW��	ek,I���B ɱ��&�g�\?�vR�u�hm��ė���KPO-��'��ea͋��� ��芙�ղ�?�e��x�!�t���� ���b=�a�w�n +U	��(����c�Ҏ{㒥8��I� �Ao��;/�d�f)9b�����3"C�	f�m:�H8X���"q������eO�T�����g$}�A��נ����K�8�d�ҵ���i���x
�^ۄ�iY�c�>�z<[����"�"�B�=p<?�d���)��{�*w��[�R v�q,���o&jk�o�Wg�����Q�s�eӲ��zC���LT@��4{͏�k>��k\��&�)�)<�1a�[K-��������¬J�p��u��lV�=��D��ږ���M"a�M jĠ�b�Ur���c�{��1�F�s��X��̚��*⠄��p�+��p�.X�.�NI0*,���ؿ���Jӆ��|tI��c����u���-�C]a]�Z7�1byw�����/��S$,�.��t��b[�	"b�+�
Eͨ(N��D%���������"j<@�ZA3��J��I��O	��/����(&��=��YH�%����_�:c6��'��]kֱ��E����aw�����>�4%'��t�x�g鵬n�������j��s�[KA��u���e�?j�&��^	�V�ڪB7/EL�?:c�E0���+�e$j�[��`$�`��T�-k�"�P�X��w���s��#W�Iޝ�;3D����z��e$lU��,+��|Y|��Ŵ�v0��$48���୰,�V��Z�|�����ir��GC�2/O/O_����F�Xfi+[E.��k(\����������t��~{�8���4F�����ڊh6��]�CA&0Q�CM:%��Z�_��F����f&V[qles�a�Ѣ�e�p��D�f�����5�H�L���1�����[�b�p���Ѻd�~����g�c+�S�A��-;��?���`��Dyk���$&0�s�e����2�5�-;��u\��+���[�B��r�y�1b�F� �p�U�C�������%2�߇���{�xe0�b����V[�]#]���Xv8Uq�0$޳���h.�(�S�t��eζ���/�T5h�2���@�ɠ�	���$_Fj�s Å I�Y�~-޵�ig+������ϯ�߂�A�Շ����vP���(Ӆ�~�J(�?��c�����r�Z�����C]U��3�?�)ct�4)�� {��ĥa �]d�Jx25m9(o�{>���%-9�>�9�u@�g] չ ~�1�)cJ�K#I4(����?��F�MF�5n4�P��o9Ύc0�#, ���������y&���8��ԍ�t��߻�%�����H[G4��\sh�������J�	#eqlӁՍ;�ޱ,�[��;�'1%�N�^�L&\̒k�C��[�kMoe�C�G��s8 ��w-�ӬlJ�|G�m=����]kZ+#Y_
�C}	8�H2PtUQ�����蔏��U�  v��v�-�j��Aˉ_� \�PH�_�Y�����x�����3ٴg�r��2��îW�@�����w����7�f�t�b}��I6���J�i-�Cu�Hk����0�ɂ�]Y\�VWX(�vo��pN��
�>[�gm��{=�k�ud�*�wMӵ� �����"�~V-�R�-ط��,}\��ǃ���o��d1%��Č�bl�;�0n�օ[�;.��z�TF��d�d�n��k"a�W� �-��ܵ�����2���GwJx�F,����;�(HΩDrZ�"ǲ�Zׅ-�:y��+�Xv�.�k�^�/�������� l������V�nˊ�Kp��؂��`��
ǰ�.�\�,3�[.�ZLA��8l�����Gʙ�2�J:��kc�����s^X~�qʟb�]���W���AXϒ�ڊ5!��=���8n]�Asq~�=��(V��+�)��p��V��2�2�ڊ�6!�q�+�E�n�s���GB�⸜yo?ha2-�W�dH�$-�Vy�k)o]�<8So6j㼽`����55� �cI�"�p��&��:���-ԵU�.�_q�,A^��w��%��D����4�bp�L��г�P�E񱃲����pw{|�*�@��bV�@b5�E F�l]���A���d���n]Y�}G\���W|(��9�7�B����Y�=Z���B��d�ho�&�/������@)�l��eq8��4T�����O[�Y���d�oy1I��z+�B�=E�x��d,�`����pϲkۊ]�/���L���J5�ί���
A�q�Z;��q�>t˲�#T�~J�R���֣�h�c�x��0IFm�(���,�VE.[dI�ͮ���B�aX$_��2`��i�"��i�5	b�D�U�c�T�&{�*"͠�$���m¬�?k�tgsQ)��x��Fف�eYʒh�� �Ļ�ܿ<��b�����Ť�a:�+��Y�M�+��l�-�z���3���t��m����'u,����P�a]XՏ�[�u�e�d�@A"�.�_��������Lr��>��,�a��;�^"����MJ�W�؀#��u��K���@�?j���,�w��e�۹6'�;	���H\v����sàE:�.
�;ŜhO1�88:��|vA*;��ZLa��{��+�M0~� ��h|c-�8\r%�p��9�g}~<~J
�rB���8>L����KW�>�
[!��\�씵������� K���Wx�2���Y�n�L�$B���U�%�>�??p�V�����Y�P8�؉�3�l�t    _��}%r��x@C]�9�&%��>?r��3���Nh����}EAyŢ_|Ԃ[�ˎ-�Ӣ��D����ɳ��N4�1�w�y.������]��rtM^"}BrX����lM�����E��b��T��pv1�˒<p�`،s�*��q<�d�Ӆ���	������C��;��|���6:PŴX�k�����~=O�ah���2^lA������.@x�o�p� D]�����p@�˳�N�d �/��vV�~��ɕ��t�L�.���������������X`�:�;{A��e��,9h�����
���B?a>�P��l�8i���Z4'���ݪ�r��B 
b�`l�}@��& �u ׀�����b��S�����8!�SK���Y��ȳ���.�T��z�}T�=<���sd��P�-����\zNM&^��Ck��ź*u٧���+��d�Y�sHʙJ��5�V%
��r�*�շ��L�b&�ō�����f����DW5+.k��iv�!$Y�ͅ��H�xOtE�RC��)��9�PK�C�W@R�z�Mk-0���庺.W�ܕ􊪘*�*|i���br�s]n  
��5��x�4ӮY��3R�V6ʪ
K+�.���(ʟD��d�4�����RѦ.��زU��? v1� ��H�*��ɗLN�5�?sA��x�W��@߾ �*qs��PX��}E-r��,��J�Z4+.k��R�e �pa*��J�ZJ�Xʀ쳤�os�@&�%Y��,.Kr�c�(
mQEX3�[3�VeX�QA�`�����b:�~��,��j�+�o�L��4E���HU%�'g�E����"q�q7))V�SG��C�t�
��d�u�éu=�����Fbϖ�:�[@�B+ѯ� �ά��r�*7�)�e�G@0S��T[X�\shɠ��%�53���mԫ�W>��0�� �h
{���
��\��^Cac����@�?+� O��T�l[�)<�3��wg��YL�Tp�k�*�Gc8��|LA��><�>�V0�PPB�^P�3n���Å���>�U��e
��9������S5�ݯ0�w�WN���U�NS�t�|�m$ܪ�mdKw�%3^���Ӌ��l	��A?�Aq�>,��cU&~K,D!#��X���3� -�1�M"݉K���4_CI[�{ ��x�=LG���]L�r��#��p���o��o}p�(��L�t�$�zS�8[��F�Ւ�\��e����y��I���Bz�e�v^�H��qk$�����U!�H4p��`p��'q]��a��5�R_Ba������S�)�rb���O:�V�O�����?e1��/Ā�Q�ϵ��fŻ/���:0��8��[^��FY��,ZȌe^��Da�ǀE]�<~x����rJB{#[���*V��/����Ц�7�D��~�e�Keǔ�j��	m5�\�+K��AW�KK��w�Wt��!��5�I�����V���K�(�{}FꑙyX�*��{�P`�Mh�2(�Y\��v�<G�AҪ��U����T?qz�iZ��eݴ
�X;�ޅfU��v�,�ģPp��r=_TeDM�I��)���ZD�_��Hd`�Q��_h �������,E*����!�v(�XۜtQ��b�����@�Z�͛4s�'�d�d(x�TJ�@��7��I_�'E�����\�E�b��]\4��*�H�!���ƈ����EY���o:���7���>����|��p��עD�K��jgU�z1�/3I٪�l�=0�uPH\�|>R�[�ʫ +����@�?x_��8�[�d/��RL��XG����̑�$B�ݕ�ɬ�Vc3�(3BE kl�����,�\��4����CA� ��E���y�|Hץ�e�phR��{��c
�o/�m�=�8A����"qY��ǻ_z�q��F0q���j6�t��EJ@]1�N�/�t+�O���T����EC-5�+I�PX�;��{Zկ�b��ߎv��/���|z�p�"(rq��8G��M�(�������&�0L#�ޱ��LB�N�Hm4{����֜�}e�����2�m�+b�;�P4r�;a5���.^v�b���L��S�jL���p����Bb�'s#7���˃�(��9��P^4�����+/���%�߶.Ih�\F�ִ�V������oinu�Nm��P�n�^C�``�@��[���QM�.�G;��$&��gј���S$uNP��6�Z?��2�q#�.��~��u��&��@NW{��	[	�u뇅�^d�c�����eI� G�3F����+�m����a� >��{$$ޗ�H�x+�A�%f��?��=��i��9��G Y�/��Ma�,7�t�^����}i���;dw���JL����S2�'n ^���0���6_l)�W��s���CG?�Aj<��8\�
<�,���ث�y��K��%�.{6{���n�<�O/S��g�A�5�c�V���^u��
�K}��8Hy��Wn�IꞰh��d��yߙ<��7��]�{?S�g�W(�w�``�]V�
 �JN��p��,@"�����^5�"-ķn��?��7����E������hoqXF`+��nԄ.��Ymj�$z8�I��Y>}�,��	٢<''�ӗ�n2�
,�H&���x70���@�ڔv�ݞ��'���W9�p�佡zE���[���� ��eKw��H��A��EV�	�]�t���Ue˾}]�m���ĖG���>�?������?>�c>���_J&�QN��)�Bz��8_%����������!g�p%����Q5:��f
��Lu�9!����=���y1�A�JE��AI��@VB���L/����ؤ9�J��{�X6��1�[W�;�5�p@P��,X P3.6�o�c��}�/��f���`�}~76e���=c����	��d���u��|_���Z�;��ɱlJ#���d1��>��N��[��ؘ����m��uÄ���sϕ���|�>�\���<�9b��_��J� �jM�U�,X~.ߣ)97�6)d��w�.x�[���."��X�KdU޶*��mo0m8w)M�-j�'1�$�K#!E#�1$[`T/@a;m�>T\�C1sړU3��ė;_��p�ٌ�ND���Zjvi�`V/�K�e3%Jܥ�+1y���Y���T�a�b�1���M�A�����o`�S���k�����2�<�˲� r~!�)RE�(�[�jt+$l��P�԰�H\��^^p������Y��cIW'�S��Zd/7U���*׬�쯟_~�o��+pT�WV�\����ճ��ZƳ8_j��^ЙB�}tQ��Ŏ\��ȕ�A�Ũ+n���k6
�OIVb���fy<Sҗ�faV4.
끙�)�b�nfr�)���;��,�Mh,��K+w���-��[�Z(Q���I� }���y�u6�/������X�Y巍��՚�
�/��k%.���<3�ĸM)�=l�XX��XLW8�X~aӷDWb�I�����p6,-`W 2`�Ec�� P��9��0D��b۫
d�nv[&'TC��ƕ�r��|�ؔ&_��RF��Ӛ\Ѧ>���@2���[�kQB����<kk(F��] /P����̢dqY�7���Hdi���%]�K��Yq捦{S�I��ԓ���o穇_f���Ƶȶ{�n/m�&ͥ�h�c��l=����u�J��� 
k�]g�WG����9++�3�h2�����ӯ|��X�A��C"���n�@�Ǣ/I�V�7�`�IL߯n�bGnBU���7���`'[Uw�+2Xp�SĚ�a������ӂO��H��
�����2t(��IO�&w/}��'q�d��HNV?	ē��#֕��+��4��&��s=�QU�0���9�=d�����a����h�-�Z�d����v�~2Y%� �����R��:P���,������#.;�/�(��5���`����d�I�Bɜ�b㼁j�Ȗ����a�    o�2��!�&NC�n�2:��Ǳ;��X��[lb��䶘�ܒ���!9㷐����AtA�U��"qx$#!�օ�d(_�_9`�Y� �Oꌪ�bA�q�U���ĥ���(��{}J�:�"�
�ł跘]��/D����
�+�������te�8��p&?����!w$��K&���.� �1軗�����e����߲�j���4H�KbK��i��W�$w�_�o����+�	/m�gi�CM3I�U
:{a�d3��\��.&,�|[4B�F0�^ {d�ZCM֚VE/^�l��ə{|���k\�,���|Y��Y�����Քz�.ʢ��t0�ۖ�Nc�*��O��/��?��D���й
j�V����f���4ߖ�B�{,$.Z�q2�?	�cq��貨+\�%Դ���Y��l	�ώ/[��ꁐ���׹�hX��A%U�5�B��.i��h�-e��Z/���%�ɛ|}x�/�s1�GZHm��[;�����J�,�o0l��rK�����XL�I �AHD�DpH�Q����T�B�*??}a�+��HB?X��1[�T��o��&ɼ;�7�����f��Cv�*t��ݠ��R.:.���5�|���{0$&��x�(-C��dY�4���.f��jB�d��,Τ�@)<��;�L��^{0�lx����O�㥆b{aӜY�g%�@d�(��_�ϓ!k�t�I�%���Ǳn�c����[y���e���'��J&�0�G�I��=����]ч�1x��r4B�*���P�
�GoPnD6�l�%��,��.���G��Ԇ�*1E[x�|K="jsQ#���%Fߤ#�_�Ԡ~�&(m�l62X�AY�󉓊M��w��X8@�U����=�e>�N��(M �Ϧ��mo_������o)-���yy.>O��'*�������D(I���yF��*���n���,u}��K�� U���2�g'�C�!�dl�N0��g��p4��CnaXS���R�f$xҽ%�T��p�i�i��k-�̼`���x:��Ӝm- $�mқ�!9X�ńnM֭K��1WC�ρ/W�H�� ����3׳�e����E�g���mm�M�rP�NH;�J�'�g�I@b��)"���Χ\dֳ��6���{�ݫYqA��������?�ݦ�7|1�!�FY<�e�e�	�Hxh�Ưɲ`��f�dS������q��x�X�8ؓغNU��H�,���c�LfqQ�7�(�	Mqd5�u�"��a�ƥ�l��Tb
Q>?�6�^8�L8���Q���,��{��ɯ�VG'X~���x�g��I�!�B蒄�Kd�J�y�r9$v3U}��VFW%nw���� 0��;��Z�,��\���X`:N�#F��u+]�_��_��&��a����yj�� �k���rͪ��Xָ,��o6�t	K`X����r��"��H�O��a&V;��t7��\<���h㻑�U�	�*fh_[E�����c��w���ܓ���zM����q�����Iĵ 	�S��	��g�$�X��6W��q�|��wwu�Q�8�:<Op��?s�l����ِ�Ծ�s�%ۧe[>�C[�57S� �E�,K�$���W�u�^+[q�p]�P��O��{��`�qs~���~.P�Y|��|>�=W�]����	���D�Z'��ʿ����x/�Nt��'���oRE8\�R�@�2�V��P�y ��"z �� y��i\!6*�����&�ū����h�pev��S�p�na�>��`%`a��7�^�J��&�g���@!�����ʗ�=z�^9��^'�R^,�+���~.d_�'�3��>b`�� �(�����[L�82U�K����И�&�I_��.�8��{��T
�}��b��H1�{	����".J)}��N����F#a>  a�F�[�,6G��Đ��7C�:1$A1W	0@!�����/.��0��p�)6����;:���b�+C�s��z����7~�S��(0��@�nctBy�V�dCW�u2���k���������\'�����C��y%���	�xb�����]\�|=������a�Ī�Z�)c�B0�ŭE�ć��z��*.�<B7��w���~Bh#���+��y�;��P���TqM~Oj+�%�����J��E�wK�|X����2�
�j��5Y���}�'m h���T��JPXb~�m���V�X�����\��&[��h��d"����jd���a�	äX�1p7*^�s�'(��@���S�])ج�l���}��$c�,V�r��*J�rW��,��e��l�f�}���<����p=1��Y�[��Xk�%��2yÞѐ$��>�����8�'�xix3�u"���Y�*�P�j�@�d�^6�v D��֛���+��f�0
���h��\v���j���­c��G��Q�xOa��+����+)p	l�Q�]�	L8�L�9K�L����.FW���S��C
��ſr���1m�O�O���*W�;�L��H��wq��gvʦÄ8Ry�} �E���N@��g�x�����Z4��*��� J�N���ɇ�4�%��o�Y��enZJ%!0c�G:H��ٰ���d%��V�w"�3JϜ�x�k����Z6�r�#���Z���M�p����\� A����X �����z���0����]��_��߳��8~�՟�..g��_1���,ܘ,	9�搥@�N����������ނo�5S[8'�˳Zp���~ވͣ��6)/ �E2Q��^�8���A3��\��!��zEN�e���Iw�>�0��=1#�E�������tH�`����/��4�������$��K&V�!+Iev}�C��$�\/]^��#���>����	s�$!�><��y����cz*k<_�+S~ ROWG��@�;2cƑ��b���=�d��u�ǀ��j'樍?��.�J�������]��P,ά����l�A�� e�bA������:Bٹ�X�8s4�
h/�8�[<�hK�h��
��6�	�}�2�X�x��B��r�ɵ��b��F��ĺu�� ���B��qq^��JT^�l6m�k
q�fbD�c15NqL�p^/.�&-�����,Qn�����NӍt�. Y$��+��e ��Z�/.".@�xy7	X2����KXu4���h���1u?����ˋP����2ɍ�ϗ��ZH�sB��ZB�*�~M���yxL�|���z��ŵ�zx�Ll>�l�ye�W���b[[��r@@�ϕ퓯D\�<�Kq�Z���Fc入�FJ�M
ѫ3�u�/k����������L�����,Z�ja�Z"�j���Un{����:%~�"!:,���T^f#�.���ݬO�9�\#{��H�����cz�G�����+.XN�_g�?�z٢�Ha�"m wn����ۃ����׿Iɨ�5��)h3 ���V)���H����Rv�Z�Px��w6��"�Pޟ�qٖ�r����*���I+[�Ӥ�����b�(�0rG9�!]̎�t$x��k���/6"e��p#��GH�O!![�	. aD���Hy{��W�		Rb�т�㐰Kנ���L+��T��������5�K�����<c��.�Y��Ė0��� ٛ�v�$�������l����������_*<`&���F�cݱk�q
(g�S8S� UZ1phY�����;}�Ɔ͙衶��	��u��c�(�rn�]��.�O�C������71��mc�R�ERx(��Y�8+�������g��t�k�f4�&ӳE�F�*v�a$v�>���~4vA:n�D�XH��)I�e��H�{��qsAX�����_��Ec�U��H�I��]{��W���h#[�[<s�XR�<�c�4��04a��x�H�� :�A�k���;Mr��s4����w(�6�d��A	�#YFx���
k����>f��d����tD\r�r�0U��#؊)	����� )  㯆2�����@�xK�\L:]V���%��G����WG.�6~A8�Ɠ,k7�Й���X�6ϼ���'v8`U\-�3��P��`���%�u��	^G��db*�4��U\��N,0(�#���v�N֟+���U?�֬qu],c7�n
�c�x��J����==U�C[�l�5���TRx���E���@���I��fo��&�#��u���Z4̎
�⽢2��e�A��Ɇ�A�8ԝ��W�>X�>����bp1�p�Wq�����V�0�!��7��u���>vV��+�b��@Rp��������	(�����K�-���u�X�~���~��p&F�����*��k0�4�$���P������p嶳��|C����oUS	��~���(Aa#��D`��Wؾ�W�*|gF/8l����ӅVq�� dP���_����"�����B���qMLޟ�~9 ����� ��b���ޏV�?w,���cp������$+�P
f	��|A"�6���G�.-������ �b!g$3�����g�`Syd�ﭶ
�h��c��G5��6�q���8�-=�xG���j==��$�g@� ݖB¬
�Y�����	~��xTX�o���Iĵ���~��[[�C
����rI����Õ�0K�G|��G_C�g�b�z��yQ]���͉�{y��)%Hf{�-FD\`�HRP)�J�:$��~c	���V�g��l��p�&8�y�gˆMXg1��L0��j�0?���G����'����wIt�u".@��f����$�)��&�'$M�s��~�ɸ�$�������,�����c�.Ƞ���b��aX��6��]Y��ҳZFR���S�Ae�vqM��]����KF-4Đ�����X�Z.>^�$����XzK?8X8�B���(0�5&2�:l��l�kM$��p�i�.�*EvJ��"�kR.��..P�NgW{��7oSdH��� 5�0WI��g�o�yC~���r�������?q�ɊJ��qX��7o��*��b      o      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��?k�G�d	>�/�;�vw� $#	5�dsd�f�gJ������a�~�����T�9`�+�"�It
5��QX���5
����N�PP+����e��ɀ�X#��7\@�����7�M�<}S�M��.g��r����,�܄O
������rT����5܎A��ŵ����y��yEܽ!w�����s�l���5���H�yd���L憖"�uC-��n�AYC���5Oћ��;0s�XţrKF�	9�S�%��U�0J��x���������l�'6)
�����ޚ�������0�� b[g���>��H�8۪���Pl��j��z�,b%`H0�8�0η&�s��7T�z&h�R��g�N�ϓ<�w�X�Q�i��olÁg-��F���,b��;��w!tB��n3��l.���y���]
��.Q��ׄ�T2i�a�6 �u�H���e�W�
´!�tV%��}qQ(�͍��-�!���~��|��!����&�<nC*5C'oY!�ra�9�g�[�Kh<LL���yA��?K���K)����/v~���H�x��NI)�9�V#��Տ]�<�7���I*5�_B��h�6�|�j/d�yR�$<�<{8��' ���۷h����t�Ɍל7l�9�~���ҕ��z@}v�>��7�6K�n��i��ð��/��u�A-���v��p��1�*�������*���l�k-ۛy9���4DG����cߧy:?�����x��% ��=[ۄ�Q@?�N�����퉶�nȼ�xۚ���,+Y��if�U�T��~!�$����a���Q ;��XV������`[Ir���RB->(�qS�S2(zw�"����T3�"�	�o�7?�j�^�EΓ�>
��N��r�����,�Q�����H���9+~9��m	p�ЌiF���p�mAuG����;�;]�.j?RZ-����!ʎ��j�P+�]V{�V�A?)h��}[�p=N��@�X<:�
&�3^Ƚ@�Ͻ���m&;ᴫ���|�v����8{bf��-d�Z��<<�`�W��,lb^�Kv������}�v�7ܯ�����A�1����\:�0Ϝ$���t�m.b��ۡ宠�o̥ͨ��le���BJ�%4�V�#��-�Ny� �@�9� ��(ms'xsnҚ.�P���9Н5ŧ�
j	b�Ќ�.h��^X��>�B�߈+K�U�Ζж>�*󻏇TȜ�jH���!����by��h�m%�m��wh�!Mb�����K[���媷��ЁY���a ���<�툂WvÍ��}�T����;���oޫ�x����,+�[�D�7e7hs�w-��ާ�����iІ� }�����|����]�n���i.���f��V1;��oib�P5b�&3@�h�ԑ�����V��:��m���������?���M)	�16�mV�[���>���ANS�ȭ��*ƃ>1&�;��$l8�Ya�����!�йĹ1#y�ݮh��|��x-/� �g�Y.xӾ����y�ZSݑ�z����x 6���;�G�ڐ$mH憭�;S�FOYە�`/�"�>�Ͷ�FԶW�Ocʎ���DK�6;ܪצ�e�؉J�Y�=�&y;L���3�*��� \.))�S`sL��l 1ǒZ�G��I{c`�?Gi�RqC���Z�?��_՛�9y\�6��3�k<�D]�\�)��>Tvdɕ��1wQ�ڜ&��F=rwo,�I��u*T*�./(=��+w��Վ��������%@x�l�����Y=Ah���Vg6h�
bh�\��|���Q��veEq[��r����$�Ƹ��=�țur��>��7����p3�gI���	����+䠲�<�Ţ����o�)B����:�@Aߞ���1͞� �`؆���\�6pYtY�^�̓梾>�V__P�$��N�^d�X��Z�IԢ.���\r��W������O�gYE7��g���9�T�y8��i�B۸B��þ�O�����'�J�e���r�.Wæ����~����?�.�q	B��O����Z�z~!��    �������5�hf#l\���C�pa��y�[!Ȇu�N_�.���6C�<7�9�%�A�u!����S&��w1?r�{����n����w�d3�Ջ�aL�;Ъ0�Ik��:�6���}aR_���*��'��R=`r5����Zǆ�c�	�v:O��e7��s��x��{���p��������H���X��	�Ɵ"?��d��U=ɓ�I��(�[[fq��|�8��a��g��װ2=,K�S�iWA;	�a�b;\�4�ei�2��t�<y���0iuשq���)<��H��v���&guN��(3�^s�q<E���{F:׿�bD:+�����\�Қ�|��Ե���C!�ͱ3�����|[�hŁ�SC7
��BC���� �Ĳ4�F��pT�-�>���*ԋY�;�8}|>I2���eB\��;i��<%Fnx�<K� <"���xN�=�N�O�u|D{�;���w)b��Nl�\'���
h
Gq3��.�����a���9 �bie<n޶�7�<$�<w�����H��K�y�@�,�<I��|0ZP1맗�������4�d�D�Ȩ�Ky���^X5d�������w���_iŜns��f����a�VȠ���[ -d{��]�*��DG��8]fF����ϓ�|a��_�kU Gl;�H&�Ze#�r'�:���a�#���6�����/
24˓:�4���>:d�WM���?�>�Ǉ�\�JBk0�����r)�X�1�����?*�B$:D����ԩ���r�Z�:W���l+�g"���%���K�1\W���ul@!�V�4V���bi(��^���&����vlGDd@����SK����J䃡�"$�j1���N�5o�LM�?�������?�}�����Ӈ_?_��7���>���Ȧ��������O�ЎA<~tȡU��� ��å�*i1�[,F�cj���ge0`(g��=ci�Lj����C&Xڈ��N�q)!tp���<�~��n����g�|�����P򿴠�;A����A�rWv�۾"Ԉ)�NV���Aݦ8-{(b���9�Xo��ܝ���9�dE=1O�เF��v��<����a~8���i�Z��s�~+�B���9p�Xz�
49lr�i�A9z',+fb�X.����
���#7b��b�%��l���z^S@6�*��s_s;^����l�9��]�S�hף�H�؛��c[=���gl�X���B��r٫wZȖ߿=݃j>"���m[=f���1o� !�����������p�;mQ���6rv׼�.e�M�yWx�ⶋ�}��v���HCLt-�	K����Īzs���)�/�@?�2�n�[ϟ���.O���n�^c�̛>ff6z�Ο��L���2��8��Hn2�1�!�r���//�FG&Z7�0�a��uޡ��XZ��3��~��~��|�&0h��.�(��ԍ�1k}.��@�1�0C��D�.� �>CD�S���M��v��ty|��q��7M\ cǶ����	�f�X����`"*0��Jy�RnO��hi� w�N�i�x��8*�G�`ĵϐ�\}���@�@��/E5�-�RĂB%����P��D����:}���=�*�0�w"���(1���:1̛o� �Z�9[r�;o��j�����[*�Zl��s��/݋�_��#"��#@��H���:`��h�#B_��I�9� �':B�ʸ3T��Дc�4���֓!^��6 w�ûus�k"N��"y2�M�1�p�ʭ�����֓������Z=��"�益R��Z/p�~_ȭctZ�=FC|O��	��U1<��FsDTKм��N+�\�K��!/�mA��p2c���ǁ��XPF�2��Gȼf�]]�ڑي���o+��[τ8�V!������ �2���x�[;��s�V�i�	s�@�~��4�_�����g97��`�� ��������V�A%[��~T��p'�%�"B�!b;:������x�+�n���&b��f��f��>��J×�>�n��WW�EwR���8t/!
���F ��uV9"Q?�OpC��)��)��S��Mu�} �dg䈄[��6�q�]kD�A7
db�G���/W��'t{A���M��<v��q���F�q�E���@�c��e.��^�Ft�t��U��'ta� _�U��wZ��I��	���V�B���c~�@�F�v����\�׷x�����`��`�ᘩ�慻�b&��AՔK#F,�t	�EK-i+25�1h<���Wnݿ���K��6����E�"t/�Ջ�u�b�K�$�ܢ��;u��/�O2�����*��w� �E�_)�7�uB��<yp�ܭ�$�q��f�*¾?q�<�~h�	]��9��*B�t��8��y ���|:=)�b�	])h�<��0̰�Y1[e2��~�Fƴ�����,k���ŭ�(yK'�������j8�Fè#����7�>��jBE�C��-�>�C+���N��n��+v�*Uo1�{!����~<i�0,M"CL��3�[���2y1w���Č�f�R��xo�]O�@�*��D���(�T�8Z�E�w�v�fE��WH��=��x�N�R':s��T	�:�;�4�cZ\Md�_���14v������7F��0����ܽL�[%��x�ڭ�,1Z�$>�����R�q�)>n�XfK�O��+�vӉ�Zy�a�XK�C���\qH���/j�8��U���A�+U�T�䬈�Ϧݏ���'xx�����u[A�IR�oQ��
Xg�ttl����I)�>S}ι�\�_��zֱ+��x� �����%{��xm�ӵ�ycs0�*ы���Ѩp�Έ2�,ջ�����=p;g�������ib���g*#65:n�>�x�R�N=� [�E*�o�P
�HF�ZăSv�[�g�*b�L��Yv��6ǈ���𛘢ӏx�m녚�O8<?���$�',⯠�6��gV�&n�5�����4��skv���ׯ4U�`�
27
���U=!#��9��1�m��l�E�,D���z<��W�:�jA,Fe�Ƕ�g�8y�M2Z�AD����G�̝|�`v^cv�̌!ðsn�N�5���+�柈��9��������8幔�y��I����^�;�;#��I,�� ��V��+\5T���*)/���h/Oj��"�bho1rO���>��[�ν�׉�}����t�9�)�kz-���c��܊y�M���/9�a�ڱ��P���<ն�����O*3M���l�ZHib�&��#�#��n���n	�_��(��?�]Z�S`&-�@�q��nd}�{O�/@�ig�xE���d�y�8o��4qQ� ��]�
��Ëq��i��p-n��FU�P�����R 1��5��̓;��`m)vG��BLM���r����i��)(���T�$�*�Jv1h4��������X���ֵ�T�r��T�^1�E��y���|W�f��^����bҶ��&�5ju�����+/�X}8���.`���:���N?F�����4ʋ˟ �.��LA�^X�:ĿHG�ZQw*����u�8+oR���=p��5 c����PXv�"�s�ȑ���d�N!�����w����p!%�[� M2i�� 4�`����O3��3��U�q�:��l��Y#v4��bf�ް�8ݝ��1�F��2�l�w"�XE���h�i14dȻa�p�y
�c#��AV��:��	��J"� gz�� �߫��8#Z���r�'�+蠞Bۓֿ�>�J>$$3�
�~���ɳd��\M�3�Y
g)���\w~���TO؉/>�d[<��I��Y�ba8��U���*5�z�*'`d2��z��%d��;)�����]��v��4J�W��KF
�'�� �:����J�0���B9Y���ϧ�\����39�$�jm���d���*��d2����ۦ)���:u�e�~�5ҏ|uz�Yf��i|���    �?����	���f����J�L�p֯
��@��R˫�J�P�M��vȠo�cs~]FV~=��y����)�p�ظVA��	��Vwt��Ә��$��12-���Er�YH�b8-��0���T�cH\�Q��6��5��CRΡERO7��&�q_j�n�J�%ȕF�0Сs�!�(�ј3���"v+o �z�koџ�=�>(�C���#����T��lQ��.�(wI�z�����,G� 5N�7�"�u�vΒ[=���.rK��DNG
�C�i�@�ل|����ͲE㵧�ӭ��r~��)!C�c[Ǔ�RoN��j)�3s��,�1�0+�,w���c5�y��[����k�J��/:6���5�1_�ޚȼ@����wb�@t_���L��"�/��$���Z�6�e���$�r��%� ÿ��b;���1������ݫw� �}{�+۝��()f��rs�3�wN#�N==:D�����_?��_��!C�q�Ŗ����`���I86S�-r��>��[Z����*A��5�����+Y��?:�����_94\g�O/`2&��j8��<=���9;?�<u�����zb�7�&},��o�G�6=L\��t|��[�G����r�T��sWy���|�ˋ��D�8.�����~�W^%�֦��������W�a��0iN�m8�g�#����ծ����䒷��ϸ&�Hy�p�qo���Q���[�����I.��R�x'�"���;w�
���|��������TƋ,7�Ej���ڍE��m9���b��޷q���$k1���m���7�ĥ�V���e0)�BΆ�;�+fI)8�o�9�=��^�J��яDL>�<�����z��B��P�Aj���X4"�i���Y]��	{��Qw���x�o�l�w��v;��d�~M��j����x�O�m34��ߟp��u�=?EF��ˣnzB"��#�����y�y�AY�r=x���`��e�?���-���ֻ_�ϭ
}u����_��/2�F:4F�nנȿ(�������3�t4�^d�(-�zTjg�_o�4������鬫� G���\�K�z�^�x�!_�	��������+a�m)��z5��S����S���=�;^E���^�;_���~O.�J�T�#�|K��B�1�uS��c�HlM'�5�����ڲ3�Z��D�(�{p���E�@!�����뤴���꼐�̄&v�q�P�&���>=>��-8>���^��9�Rؗ�^Ѓ,D&!�A���lD�8w= �8U7����L/A"ڠ�����*� t�m%�<�����I�Г�Ɠ���t+f�ZX09���#{���\8�$h8�6p��ꃽ�� T<��VNQ�uN���?gf|YE��I&4jn�ڍ�h3�`v�M�ץ��Ct~��M�DGi������F��0m��Q�m��Lq��ü����O�!!/\1~�ܩ��ABe�1�lmr��V��%���@�2-��Bv���6\�K�h&H9b,�;B�x�"
K�-�$���q��Q�¤6��_����?dP�����$k��,1n�Qh.K���r�xGe�/�;��08J"8���}Wݥ !;�]`��v���j!�n2�4'�� ����G:K�f�L2f��o��~H�Y|L�;\>���
i�^��E�`�1�(46Qh�����/<QQ�Hg*���\S'0���� �'uc�AN-�r����ٔ��X���q6��n�X�|���0ڋ�g�W�P��ɺP�z�lb�BQ�`g��,�|R̤�?��DO)��8������;����q���p�����Y�%�y�(���P���ڟ.��x�1��c�gk,%�ou�Kr����k߂#��K��O�	���~��p����Lg����/w��@v	�D�ݾ��^Ã��ZEw"��V�_�}������BF�;�1I���z��(	W5���Q��{���}|�ۖ������H���x��C('j�����;Z����,N�D6ep�*w���+�w��7�����"��r��F�^|XY�0��Y���j̮^���EN>$۩��ў	l��a��x*NԬ{����^��$�0��:��y<А��p��8�Ґܝ�k�9��|~���|��A�C��(��-��)V���q������ʷC�(��5WHyvadq��l.� NrЩ(��n^��!	k'��T^٥�2�D#$c�b�ϕ�l��o��VRք}�	:�d��������l��E��Y��s�+���N?&�Ks����1�h �N�����~x4	�Ư`����$N!nSUH�h��ƥ�o��8p��-�#0x�z�f.�5�2����\:���t��h`3�])�r��p�\g��}�qR�H�c'td���������c)2N����7�!��ȴ�5t�tϥ,4?m%�D��W���Ԙ��	f�BΝͺ�Fy�'��t
+��8�{b��gi<��S��8�v
P�ڨbc�E�k�>�~��9���x��Y���]j�{���������K�>��r�:p�@3�U9��y�x��Z9 ���g�?8�*��/���K�E�(|N�ʼ���Qv����+��#ٹ��}[��奈�8R��T���d�&�s����<��f���N������Ւ���Ff����_^�1�*��\|�t�3�� |~�?G�.Mx��q�WȰ�_ �rc1�d�a�|�?��I��$Y�3���h�����Ȑ���|����3K���&��m��4=o�'h{i���y�^+ؗ^./꠵�$ ִY���oǥK{��w��Vd��~lc��xw9}����N��{+�Qs��I�ι�)7�l;��A���FM)�N��,��D�\h�'�%��W;�����0Ȱ%]!; ��(�c=��z�7�w`A�v{KY��|���Е����A�klx��� �o,�mBe��G!$`�Bg�6�sW?�����hN/����+w�0,Q�c}���~�}[k��G#�c!��P�	���Ny:Ծ�6�vz�|Q���3µ\�ZSp#����B�&bV�Aa�`�g�4Ә��ִ�:�K��"� ��5�������!G�5m$�:��A��+b�bǘ!bF�&(-�c���T�b^�֋RgX���t:�1�A^����k1xy�]�|8}�(�.�Ƭ�$ڠ��ob���MNtAE�]��v��Z*ߞ��FtV�u{����.���ե%N�{����U��!K��"	]�	�Ӊ0{+�����^��H�	m�mB�y�˹cF��U�P�q+�BȐ)���D���`{Ś斫v*.�� ���1�Wu�������ec�F�Q(j��Nf��{j)������: 1��ҌDL%�d����@0:W�^:ƌ�����5bzU�X��9O�;e���~ܠ]����D#=+�y4i���y�ػB��a6���z�����4�nN�����H�~,>��2܈�},�z?�v)|��5\��|>����:VJ��Z9avV�����i�����i�)l,��ɧ��X�=��b6t~H�y�	��ˋ�6r��rV�X�-G\#WTP/��� f�.���B3�;�$+W9��;�q%����*f�0���Ё��OE�� Ɋ�$+�o4�_0h��#2��g$hH�f9AZ��/Bs�@m��R+�S%���}��?���?����-~�3d�4�"�E��"�/*~N�XN)�0����I�iHic9���`u�0�~��)I:��nB����^��46������s�] +�0��~?�� C�vB��� �7y�e]o
��O���q�l�q�X&z�|��2U���J�����yc����/�
v���+� Q���F�=�8�y8��'v��i�t�վ~��sdJ��q��5��6�5bOfh�Յ3����C���<��$^E�C�D5�5���?��5�,�~�ǭ�?jx�u��+u�١�    ���5���2$����
ԝ�^^�d�s,��#�IY���=�,W�F��>�!�mh4:�u�DŜ�js��֘a8������ϸO�����+��� ����6�s�T���z7��"�)��ǎM�ϲf�*4��>�6zp���h�![l��S��F�J�E<����A�7N��no�x������Ǹ[h\iZ���Ýdu���a4F�p�QvԂ��k����Nb NHcc����V'���*d���l�]#�^0H/�`/��)ոS+�N����?�Y.lq��r����:Bfc<9�:�9R�@�����y���δ���94���t��{�9�r��xݶfщ������"���%�جgk�N���C���Mϳ��64!�e�,�찠�萸��
��&���,�� �Q�yp����(���h�S�c������z����=���*A��=N��x���^c�(Dw��;�
I�)���q���Z;<\��Qj� L�ԟ�ksԨ�0Q�y����Or=�C�E�.���D�������t�x���������n6H����uwǦ��'EL�oj}9=]	��|	6���n[maB���v�q]>�6��$���(}�x����+`]��tt_�}��~�C>�gL��Gj���QZu�!�+�1�?�rR�O0��MD��	��˔��/�
��&� WNĮa|zR7�<�p��q�]���ȸ�M��<�C������$������8�<�70��5��J[R.H�x/��C��GL�[�ܻt*҄X�9�e�ou �� M���`\���\��K]֤�qߣ=���κ���6=x�r��RА˦Ƴ,�<q������`�@y�~���U&N��'1��!�M��H�羁C�!�i���+����|�Et��lj�F�6tE��e����M�.x��y�P���R��^fHEb��ڥ��n&_8CX�<�o����aՀO0�'���Ґ�!1;5lU?����8_3�'%ih�Rc놗o�>>߉3
��a<;LY�oZ�C�Ԇ��NU�J�ʭ�ő�]ݠͪ��w�-��Z��Ï֘�IaO;��Ot-ɤ�>֜t:�������Ԕ�bO�og-s{8?H18W.I��D��0M2���u��̒'�~�VBIs[9����Kí���{`�2��澿�u�I,'H��Z�Q�QUZP�'bX\��/Ti��o�~N�3a���*t+���X�A萶��mA}�"}܇���w�9�R�Qz2��^uy�CVu��-r��V�p�����n8�j��ȣ	n?�Qȡ;4q_i��~�����C����c��]�J��`��mu�vN�ǰQ�_����r�S�\E
8�3�P٦���M�dǃ��f�%�l���%�1v��#���8�?<�ZO1�˪����J2去L�Դ/\�?i݀���wy�e�Pz܇�{��%�[���taK��N��@7��z�m�� ��!��t�4��;��p��<��!˒����}�K���Nw6C�t�VB�7�q��o���YFI�ϊΣo�e����ё�!�H�[o|�<ݔ������Kt�c��E�cv�==E '�&��;�� �S��S6&��jg����v�|l���r����CC��2҇�WS���ݪH��5�f���r�Tv�29aM��mKs8Ku�~�+�ܐ�qR���f�ud5i�w4�ur
���׿H�����@�=��o_�!�"c�0���������!��l$W�����V\P�� ��h�A�>l��U͊y��b9�Kμh�cq{�]k���g'�y�;}�C475��:C��2z�ۥi=��,9�~#�U�RzH妶��c���);�JELY�n�p����	Y<75��k(K���M%��Anns�Ȣ����Y)	t�F��NE�w�����$��%*��hj5}��.$�qfR�n$��Q-�"���Մ��q�p}��oo��@)ZF^��:`�?B����Q�xH)�(tbp �z��4�)�&�/�m�V��vT��)	؃��6̿*lm�I�ܦ�/j��C& 7���i�����ÐCP�
Mb��?_%����:�4F:�NA�m#}8��֑G��tY�w{�L��!�3��:߶̀��sn�	��������,���Կ���{�ڎ���P��|�2��I@�fEhu:m���]H���E� �Z#,�2�T\�����o���r���{9InaYl��������82'nf�<p:� Te�ᕰ�C��$g�b~B1�H�<��M�c���ѩ�\!�T;�2�K���_4Y���*�6���E���8HdB�g���I�.�U$y������Տj��4xA�4VZ���踟���7��xU��vr�r5GTV�c�|����� Y��Vh�x ����qU!fR+��o�8�3�8�j�ށn��FȤL;_�v�*�Y�%��1p���W�FUk-��mMVM�����������B�rT���|���^��?����'x�����Q�/����CN�Z�=w�k���#��(y2�����O�w�!K��M��w�+ߪ�īV�&�T��7�|��y����D��T�El[���6���������iX�f�m	��l
/�Dm��c��.���\*`��Q4�u���L8�����jX�:��N/��8��V��[{$��;ΐ7�Y�e�U�N�s��I�e��N���c���C�%�D`����q9��==���y���~9���������(j�>]��W��Œ�P��}HC�ԑ�2^���G�Ϊ\���V0�t�ܽ"�C���1�(�]�=�䭨Uğ�9��.��@r+il��m1zЀiv'�.��ҍl�c\46F��-�����[B�8m�K?�ݝ�F��k���헽0
���r�13f��L 0�=s�	�R���k���(�6д~�S�����Z)��k���9���t���:6J����X5�`[�ϣڛ�p�ڢ��i$v�y��M��]h�]��w�2n��o@޸m�R*��O߄���~��rD�[s1�F�F�{���{�f�,�v&L������ >󫵧{y��C��oB;��niZY������F~�q�04|h,氂[7;���7H�[�}8�<�Z伈I�xyqiˋ��&�"F���#�u�id>H�"{w�'�9�rc+����U����\/.4�;�2��Iw���?׶��W���NdBr��S����F�P9B������w�6� 4Ld�Hd��i�V�/��g���!��1S����4\�u�	=b.�0�2���͚��W�XAv�!��"-\����"�m��񡯯H���a;9����I�]�B+�OT�z�S
{�g�z�Ӟr3d%i��A�d�?%�K,����9���凼�sԏ&6�i��s�VN�[=�]T�O��2�8���s�� ��3�B���\Ҿ/7rͦ/���g�w�iAH��BwP���vke�����!�Q���}#��@.�Ai7�?|+dt'�B��ğ���X 9@f/��W����k^`G�U���=���v6:@& �X)���4��t��i]��Ɨ��7�����.��p�g��J�Cm�i[a��qz��,`����FI�+[���v��8��8�7�������7\�����
��V7I�B��]ZΕr�i5�ʢ3-���������+>�3ϠG O��<Etgp�`��~�Vl����;��aP�t�3�pN�"6^ ����)Ȑo�q��<x�b�	�~�x�	�@E~+>Fs�����E��96�i��"����LL��]�#���R ���L:$�����ߝ q�t�7��{����Ëܫ�J�q*�<8
Q�y^�b�J���F(�Ӥ��a���i�J��a�ިڼ���*��ȭ��:s7x�z�/�@NK3 "�[�����y�ʰ�r#��r�ҋA��y=r� i�C[;G��~��I]*�Fǥ$0�留}    K`����=d�R��ɺ|y(�d�p�͍f�L�x�H�S�����
΃�k؎�����E=C�z���ޅ4ȐNr3�jc�.��6��4�Y����K�n��Y�C38�J�:��2J[��;���|�:Rw�Y�g3a�oPa3YêݼNӋs�E�|�x?U��NZ4H�4��Q��@62��ɡ-����8�&�vf�^�`ɿb��N��e
#&H����T���]�jA<P��P�	�_/jB7@�77��.<݆�5�&�<��ev�{I\x
�*��m6`2=�R��"M��	�Y�B?1u2ɿ$[I���<� m����h2��P�CF�
9 Ȯn�撘Rl�8�'+d�Yz��4��a�:�q��yT�83 ��������L1�̈�{�3����I�H��F��,w��5���h"^���~��@��S�0_;a,��u�
��[�nH^b�:y@��N|�h�ws]hx[�cԹ�Q��b��*�u7kޗl`��@S�ԅZ��w�d�sKc5�Ȩ���n/��T�R��Qg�Gx��?�<�Ŷ�+�;V� ^ ��/�>�=�%bG/M�Gg_�>���^9��fN3����dqqKs�!!N�A���ޑ{a��pO��"nikvv~UȽ�.Q �j3�rV��M� YE��ڊQھy�G�E��{��ڄh�#@f"�H�ws6�D�㲍�v$�q>���,�Hf���i߶H͑:k�Y}��d�A�?!�4��E���ZiT�����췿KԐL�-� c��$�%�S�;��o������M�6��(���*�IZ�h���}���Ϻ�i��Ը��L��Z�A?z�AU���q��^#{�'/�=^]Jo3�9����o�֐i�O�jjn��%l��3��	��1���^_�r#_���$?8�C���?� ������{���X�hȐA��ؼs_{�3�kuO|&R�>gǜ��9N
z��gla�����HU�D)~j2߻�t,�>�;(��"��Oہh� x��|�k-C�J�~!.-����f,k���&�l�6�B2+y#Z�9��%q� & �U-e�5���Q�kH��M[����Ҭ�(�G���nx��n8rȧ�2ny�x"�Ec�e�Mϓ��g
d+�_������1�
�jE���v���r���"���8��vr��I�b����O�^��2z�~,lz�����F����|O+?���b��	�X��D'�n�~��&��KͿ~��Ȝ�M��ub��z5{�pw�HY]�����Oy�]^�rÚ��";8�V��Q��!;�DY�c`����� �r��@&g@ŀ�Q���
ӈM-K+!�:��Z���0�yӆy�|}3d�$Z:Z �����u[�*�r���x#��|Ys0ݪ�;��x���zaf_����/���d˴��}ފ��V��� Ķi՞��y� ��m��v\�\I��G��㝆�zBy�����=��l��x/h��X��(����k�w�_�^@~o[M�c�7#�XB��2��/
Đ��[#ޞ�i���n��̜���o�گ8 ����yv������S�H��H�% ���ӗg]���O�ꙉ�fw���H\��c�8�3R�з�ַ������3B�'�;,���n���W��C��	G��u���j(B��ڪ�]s���>Gs��<-mo����!�˽
9M�W�__N��5� <gh���S�v�{�� �5�сt��<IC��)�L�I�*��߿^��|�|5J_^����h��_?_�&��Ť�?:�JB�Q��Ig�;�DV�Y]��\�E�>.}�r^����X��K�Ϛ(%@��YGH�ocK_؉���)חy5�J�vb^����ߐ�s2 �>���&d�R�m�"���'���υ�J����IoG�(���pdJh46 ԹԽs?�_Hm�]cS��=�;V�ъ���v�Ǫg�M��A���H1�����_��kB~�%�K�� �T�Fd��Nw��d��}޷���vxr�g8{�����
�4�s4�8
rDy׺uZ��>��z�s�|�c���FE�k�k$O9��/��8+��̪aҐ]�Aw��j�@J�S�.��L���hOM8����孳�����p���!`N��|5
�g'����*2A�C�ʮ��b���s� ��E&�����5���������o�@���A�����N���"=@b��`[�|kF��A|�Z�L��V��t��bx/2�;P�z��t�`ZG��<�YR����??����Ca��F���.⁜[�O��NC�����g���*M���Ey���EoqY�"��G���af[}���R�#�p���u��z��hY�8B��?W�S8�+����|h=�(�"�V;*�[	tam���+��HA⃴�i8�8���r6 ���p�qyb�<s>X�x�^���7>�f����KW2O�~�>"$N�A�?�Xu�u|��F��@��=�{�Gvd��A���=��H�?9�U�?�p���2�'�xh�xZ�q��E=�*h�G�sI{Q��!��"�v����	�)t����<���к��VQ��S��XE�T���G�J�ČF��#��{>�i�Q��^t�q��L��)���Gt�^��8,��4R��ȸɣ\��g�:B��Zԑ��+h9�bt�e�Y_�	�.M�l���|�ˋ���	ȇ&���yˌ�"gd{Е�Q@n6�N�?F���Sr�q��T�����,0H�sz\T*!������S��TA��F����rY�rd�(
3�i�����1=��{ӎ��X�����r����ؖ��4H��a	[��^��/_����G�����q��o�P�+��	��;�#��D���rֻ��k#�� �sͩ�%N0��"��354�n�v�L1{�lHu�^�y�*8;q�����i���mC.Qe�b�$���Q��k����P'VЍ�;�~n\�B�˘bW�c8 �P�ϕ?Knm��_�rC5B����4��!�e�R����y+���ǜ�-��k���T|j̇]Q-ߛݗW�AUy>�|laZ*�_��Ժ��R��Ǐ�>�~>?}��5���5%������t>����t�m\��)I�Sђ~��*�����;��x��y���$��\y�d�#8�Y��Y��K�����y�|�V1�$��U�a�kn�r.3,r��lv�����/�.ռW��$�����ȶ3�3�y*���2 g���@Ð05!a���|zY��jOqvR���3J'i#WY��	)�/?�Q��~n|Pw�� �ڸ���e�ٳ
3���N����ϭJ�U_5�K����\)Z��w��g8G�{;�A�G�x��V�G7 9��$�V��Bew�F�!+�Om�m� �sc��]uY�	It�V��tVG�h���O��Y��i���V:/�ùd�+� $���|&c�,�M
E�g㛿���Kg녎���z] ��Kd~U싐���b��ϣ�3k�g������E����O�2���i~n|��w�ƫޱ̈́X��2V鶉�'Pd�M~n3��h?���b��4d;�H��U3EȔ�gYaXF#�M/:����� �Eb�sP/��cD%��Ec�Q̔�?}��w��!j������~?!��t��" C����C�>ы���Fl2}M��]/���Pȭ��J���>����2��e��6�ЈIm��睥�F?~ՠ�Qf��	cwH�w���6�vѠ���r�0C#��]M�	t�U���
�*�q��ό����lF R4d����:�9;m�!��:z����^d�y�<���=����A+�<R@�z�=��cА��3��"�	��$���|6��]��s@��@�)N�I�<#*��6�Vyu7�6m�:{���+�/�O3�O���~�� ��̩9  #G����w��W��w�dm5���(�7fR���q,�=���P�"ن��(\��n��l#d
�||c�>��A�Df��e%����o�6C�05ᆉcW�p�9�6�l(�fk    ���I`�䅔�:F��Ɂ�$�&�����+.����gy\>B�05V.����"����9�J�6�3��K�pW$�V/��(�x@푿����;�#�&:f0�Q�6�̙��9;��Z��IUAWH<hG�@���h�f@�a���p�=1⠢���_�+��D�ƃ�/�ݼX�סɈ�9��h}? qѻq�I:�k@Z�x-#�-eEE̻��.�
�攔�-��t�WԄr�iR���Cj�v�
�X!����Gƹwz�M2D�G&��f���Qn�\��>!�O$o��C��`�@=Z�����\��D�j6[�����]�L0�67��~s�hFhC��Ό�,<�����E"G�m0Mjk� ������|]�b�k���D�}#������6��(���!+�p�?_�4�z��5�4��@��w?�hd���	�!�s��W�HC���v�#�QeJ��Ue�Q[�OS b��肑�����~�#�D<�ʔD:���o��"���Ķ�����n;zNص��ֆ���ahE�7v�R��u��9S̄1�ߧY�f�2U+ꩽ�l {Ǌv]ɉ�[����|�D��m���-.�;_+�8O6�dB�� ���֊�6�\a�T���!W^�V2��> �Ё� ��?�H�����~W����'�]�m])�B�I�� {@�ҟ/_��Z��N����s�e	>��&���b�Y����H�еZ�ZSgi�=��J[W�9;�n������}��5�	Ks��#�A6���>1�IS���D�kT4�}I��QX]ɬ`|(���� OcpM8���;I��@Urj��_����if�k<�2^�h�h�TɚTG5R"�G0O�U/����Is>6P��i!:�7]�Jy�c����˳m�N"��	�5�y�wT�逵qC��͐PN��M�Jz��u�z�Сޤ��|�@5��j�C^�2�r@��Z���9Gs�b��ܝ�Ϊ�#+�FVvl7�|뉅���X�1r�� oO𢗓n�JZ���,�n<�{��ڳ�����R�!Npm@b̟x�G�{��$S�e0�	9e�k�);W���_���Ҧ�����uZi�+��Ý"j���'�Ʒ�A:�-��jms.g��W���>|U�a��-s]T^��þV�L��f�M����C��Tb�O�|-BF��E~�n:��_g�l8��CxhVl��t����e�� �aEl�A�_�A��o{�1û�g��	�Bh���X��wDl���y�g㎾ϏRB���rdj�eE��K�����ē1-c���\�Aw�����.�������shrg��?P��o�(Ԧ�1����:�&�/�GBƙڔ �{�m����NQ���O��c�?_�T�R>�F{����3����+��`W��1z�o����#�6�>}��:��d6.�dzK��n��4��צ��J{�߄#����T�xi��E`�f~	<��qr��-�匛�Y�N�X���.���~xY��n�*����QzeFbl�Ǧ��(վ�$(r�c�	g�%�Bٮ�F�p��
[b.���Y���W�#P��(����꼭��yq[��K�	��b��������!q\�m�m��`�i^"X�Z	�`���|��J�:�p�3[�{w�S�Mw��ֽ��w���n����;��D!8�� #�ӌq�#'+H�׏�P
q��4���<�0�~�D��T/#�B1���QZ=��(����eܱ�&�(�, �91�Wb2n�4�NC��Sg��`�aiH';��:ԾU�`<-Gm���C�.��f�۳�cy�g;@�rR�#A����ri}�|�%b��<�g��_7�7�F׏���i�B�>��dȩ�*ؓ��k4B�f�s61���8=�_����r#˹�μ�7�p�|^�Q�.J���PX��"K�	r�ƅ��m�H���:􋨆H���V�Ԯ@%^n�B��g�zN=s��#��5�0�r0AZ����L�5j�T��~C<V��@���V�-�:�J�a��H�H!��J�Y�<�����!��̡5�I�#}���t�����s�e:hU�q��Y c� u�Q�����=��L���Bq�-o�$%�q�
c���{,c��+A��u�#ƩW��¥ d<����������ժ-�8�6Q��!	ثy���bO[J
q��CۙK��j5R��95�9ߐ�rG/�cn�y����,q$H�%_��0����l��-hUn���]�Ԙ�)�grk}�ߣ]t�Rt�f�31�R@��f�ȝ�^e�@�a�}:�v,r��SA���&�6��p�]�.b��0��K�"5�����ɔtՊ��z��\���f(�e�;��E�(��:�k�\��0{��D�M1���j�9A��0OB7�f�8 MfyR��#j�?io���ȃ[J�=��<����|"����F �Y�[�~_��d��N"��Q�ޝ^�2C�0[9�/��eFb�2�v`�'�?9�������Y�7J��&�^�^��R�]9�� �4�w0j�Of}.C��NdD��
�=%-��p�<,MtF�H����T��T��h�u�����1d�	s�.~p�UrT�")B�@�Z��SH|�6�ta��� ��Fm�ͯ���`+��4B	�=��q&�M��o��L��/���O�%5��� �MX���=c���xU��y��ݶ�Hԗz�'Aʱ0�%.3v�j֡�{^�����o5q=J� �QXZ�7O���ޚ!�{�1�0�{��t~y�#=	���qn$"0��n/Y%��a�⺪�c�~S�	rx��	�c�$�s�3��"s�x�8/�2^�*5^���v�;G�o��LW�����/�뿷j�ŷnp���q��1���*�:_ǅi������9d81U �^G:1��a�&nY��W�zØd���S�#��3�~=�9���i��b�K�K���䜫No��9��܆x.�����K�Ԩs�OX�4��s��p�z�<Ea<;?݋k�Ѵ��<n��@I�,���d���Y��tw����֓�q�17'2���s�X�
�Fr��������2�������\[���誟ט��%Yȟu�$��&.e4gT�l��a�@���h2�q��`�����pƹ�<+�c׏��!���YeO�g%�6���������������������'�O�`�\,] O��6��{��Gqjb�%ט+ъa�+MgJ�F@m�Oʯ,����4����@B�8��BG"C�����Xh�	Z߼ʧ�ã���8�A���a���=�w��ʾߖ�Y��|<qjm��PQu�a��U��[�r�֙�q{�H9�v{�m�:S7�����z�ܬL��]��񂲷�q֘⼯��o��p!!L4mIq%�* ��tT�Z�m�۪&+�މ����9�1��aۮb$A4�¶;���ٴ��y�(t�ݳMHَ�(�R��d��$��E��ǩ����'LFW���e0m2b�+�[H�n'ٝJ�K��H,���~�BK��D�X����75ٚ�D
¶�ĕ!��׎���Ik���`��Dv��{��G�"���Aa�Q�>��	S�m�\�$-Ks��Ю V��戏�aօ�F;`�o�x�ڹ�NϮ���W�L�����1�Ӊ�w:��1�i�*̀�r��=���쮿�L�,���u�l�e�9�u_��\��Ԑئ���zv0?1m�(\�ɻ��FƉ�2���Xm�������&Șm��̦Si>�LLC_	��A�j��������D�:��u��tᡔI��-,�q������$`�V��-���TWS!���Y012�8#��:�9����lL͋�c��̖��ij�}�yZ��3r���� �z�[���M�ڹC�!�;��*+���ͮ�ɏ�F=���	��D;AwH{�D�VS�U���"H+�7��8��/uy7Av��尮3d��L1!�U#,�<. �<q?���!N3d�х�2��Ǯ{ZQ�ƍ�q����y���w�#ߍϭ��%3�    䱬-�|uu~V9?����j�C 	M�ke|��e;�]8�lO�T��;���"gD�!�����,׹����b�L8�m3Ab����X3����b|Ȉ9#R���r��h�e�-P�o+��2vQȸ=�����$_"�k��5u�ɲ2��iF���\?�%d?39��Y0�P��Bݖٌ���~�]1j4M$ �}�=��̀�S��Ne����V�2��Y�e5&���^{��4�� �P�B��Ʈ�r�02*�,�*����I�M� +�6)q�m�v�7��O���$�S��5����9��f`��G�.���9�v��eF^F|z���}���Aǽ� uf�	�Wڑ�����URNE��K����}͕��^8G�ڽ5�8�gW�u2	E�X��-v?�3p3E�J�i>�1p�BK��%1L�f`3��0�V,@++|�?�d
����8�8zТ�Χ�>v��)������T����],d�����y�EaN�����E����{�]����}� �B6�饜d�ͼ=\�Ӄ�P0BʝA��hr'�/�hFN�7�5�Eo�p˙mn4z���]����q��8��9f���k���1���#��((�@����@n�<���:��>R�g� �.4c�<@8������>x��Ҙ߄`Σ*⟏�J) _W����Lƽ� V�/s����o����o��л����W���N(O��?I��\h�[y1~���0~w�.���Vk��T��E��B���<�3p:�|�-}�|�@�Z�}�����˅�{[����FE6�JV�i��.�w�g����l�Sͼ̐,#FQc�-��W;�(�����|v`?����fHIc��Q>x~1K���R"�Z: �o?C���e��Vc@�
�: ;2��|������c���t9��7(�#0K���T�gH�0D�M�DMVd<��;2[=����] d�i���$"�bY�' ��_�<˱��1�h��ِ�-��p,�tr�b7`�=77&:.��Rf��
=
�c�O����������rw������w�>~}}8}?�#��~��m�4G�^��bb�}ې&(������vk���@��� D��a�W�T5C҄����e�*�I"� ��g���U�y��%�^+��;C�kB'�T;�G�51 v|����3���!1LL"��V�.� �j�bi�\:�<뺰�����':��`�����^a�������s����+�Kn��ٯ]��'��2C6���܇0�,��,|�![�Q}_@.;[T�&��K��S����v������IE��L
	'�.���3$K�q��m5vV��W�Y�y'�"�*6)c� 9�󊩉^�b����Q��=dȲy%w����*s�Iu3C��d���,�^^Fȝ2��.����������wK]�S6%S���� mJ�{[甚g	׮_��io/�>�쏨��z��(�>��~j�zV��uj�u�J�eD��\���B"�h_��M�(��:�Ř!�TL�ndo4�
w����L�l4d3U��<Rղ�ĥq3��vS׭R��h����(U$���W@�9C&������-U�$��i>�M@I��ck�À�S�����G7;�
��Z$���c��E|����ǹvf��
*��`��Ct���4�ENL̐H&6M�qgh��7]d̎�@��U2�;a����ӽ�'gH3g ���r_-�l3Ȏ1p@�0l��s��P/�jҋY�X��ı����'�ʐ2+��Mf�7��^���q�Cm%��+=R&�?���I{"'���������D7L)���I�v�-!�v~���F�By��>,n�U�6�C��4Gĵ�iViR��w w��ze�IO�b[�c�'�#Q�d�z����J��B�˄�L	9��Hۻ�����'kM/9�s�����z�3���61778�m��#h��Ѵ_�}��__�RC擸�������� �*G�!f� f[�R��Tr�ĥ1��J`�{�4a�@��c����� ��$¤�6��x��-��Tf	�i�j����n<5� w|J��L�諷���*k�3$��G_Z��ۦ<1�h2�H��j�� M"���G:^�|���[w�隦�:�B��,@۱&�S�BNC�2^Z��<q��A��(Ȑ�#MA@��pl�M㹕��O&θ�r��,L��V]�c�նlX�]C�^a>�t�U��R�w'Ř4CR�45��9�R�9�=B��y6r)������ܰԱ�R-�$��6�e7gؕ�S�!,T����!�E��@>8�T��5��v�������"��!-@��k�9�⿡	�E�f�0b�����_fd����=7w�7F�	�Z:���@�#���d��2���RAlGA�{,9�-"��t���� �H2�|�9Rݺ�u���mPΜx}�r�ӫ��@�d� $R�;I�	!'�gVev���+A��d����Ai��+�:�m���S�#���$#��w�ҷ��a��n���cf3z������(k�Ά�������{,�U�R>�P;d�IFx������(���vHQ"{�@Q`��x��(J�;���&=�]~Z�.R�0`5m��bg�o <�^qu]@Y�H5v�i
���-HN��$��+�E�T��0띳R�$#2?8$T���o�̕,SAv���ǣ�d�!?X��t׿���[�
�U�[y��)B�X�A�$�s�m��� }gs��/y�B���1W���O:܃K��5�r����W!�[Y��)�2(Z����i����(�N�{~r뒘}�i�b�R=��!�e���$+Lt׋�h����� $�k����]��^��6��q+��x��
�����X\���`��݉��0x ��\���	[ڄz��L{:A���䤂�6T���L��塚L�5ɷXi���NO9����m��#�� �^���cn9�!I�u�=2�#���)��M��b���*[-��0La�Ha�&+��Kdu�.��:�Wf���=�zA�.J�	�]�܊�"V̂��Uzn��K�B��q�qR^W�5�,��@=3ԯw`�� %���G���D��/���-�����n=�>};�<)���)�5����E�B� �1)Zw��C�ա��l�
�Ot�O��K7�.���!��gv�/7>b.�&\���3t�!� 6r�ĭK��N\�1�[� y����������i�M$+���$�	2'��e�y$�"@�_���0r�ƯWr,��+�����]����fL���&�����ʨ����u?��b�*ՀN�[��5x��3n(���v�BL�P��py~�v��,�9GY���|���4~�|1S�M���z��a�æ�cn/��,5�n�jwL��#�I���G�z�z�m!j/�
jϊ��h)
ҩ$N��?��{i�k���"i֫I}~�w��3�tH��������:M5}AjH~��1��{��@~����&;N��v^�:��P��� >�i/�*C�l�oef
����L��mȌ��3�R��%�-���*(fHO�B��M���� Mv��QEc���~P�%bSH�8I���Z��Qk�.*�N�VC��@���	�7b��d��$�X��+�&��Z$�H�u��D�\�{]�����$��¾�f(dgJ����m�6~��P֑���-�v,�҆c�7�m�L��R<�>���82�0��S���őlG./`jr�%/s���m3��lC\����;���://�Z�@�{���~[�)M=�it���|��ؿ]t���Rh�s*R���r1q�� .� ��~Y\�OA�G�7`lP��Y���2�p�ׇ�k��6)���v9��q1�- z�/y��Iw� WL��@����=�����=OC�[:���/��N/���
�a�K�Aw2�,M9��W��mU��!�P
���`:��H�m�+���i�%=C�����]W=
/�=���hXWm]!�Z�j#r��:�N�T�    �*oNTɞm��D�ܟC޴�D&�so�2�Ȼfd�����v�E!_ R���]�_����-�����)�=yzT�;��0}i�/����N~�B��6����1\ HJm���\`�4BK}1�s�����9R�fo��KߜS�#�4{��֛U-��d��<�<�<ğ��<8HQ +����������	�Rl��Lqy�.��f�A����OU�^ cP�2d\��;��^�̳g�*Dx�,Lţk�Q��-}f�\_��?)�$Z[k�^O/u�sDұ���.#)*L�9z���O�{I�@2���������:�#K��C�;	��؎�~Uor���X�L�~c��t�
!�q�D��~�q�L�d�Iɷ�;{$���GAn�D���z_�Q��K�$�d��whC�N+b�d�+	����4.|��ۿ-덡�#k:*�Ӯ��n�\�a`&��L��i�'�f��Z������;=��@���Zc��F�ɜM��[B�<6%��do��\#$�IIT@��:R��Ƅ��!��N6 �C��4��8���Wn�-փZ� u[����k0�rԉ�dMK�L��d����y�V�$#c-�+�SBv�4���:�ݛ���Q��G��wO�!�c���@��4�e��i/��E�>�݋�
`eBR�����OOe%��C��	��뜩]��X���TM��r0�hb�0���"ɟ�̔�^��4�M�� ����4��-�F���͍�[\����cIG���f�^h��e��CO��5��՟cQE�k�+�slG�RG�YT�2w���y���\�vL�R~y0����<��f6���Lȗĝ���/���8] �_�ŸM�Q��+*lݽș#�6�N��f�l;i�� =�t_�Q�1��^��yz�|?kQCr��-�+��^r���_ӵӽ�c3�dz>�<]䕳n	�E�H�4��f������.@^xE<������_�b�{*������a�H�!�NZZ�ε%D:�R�H�.b���e-"i!'V��{�:_��Fii�~kQ�����J�i�A����ӥy�t���eA������~�M;ݟ^���g�q�"JQs',9|�MS�}N/ ڳ�����dl] KZD�r�da�*d� d�
!��/�!��'7^����'Rs/7x�c���OV<<?*^���Γh�η�����m�uWC�;�b�L�5�s鍸QX5O��x� w 8Z"���66��y|�������A�²WY�+Ey/�
Կ�^6�����}��)U����3��B`��ps�������ϔ˓Nb&js�yλӯ��w��S�$�}��_������_����]vU7���R��ZYִ�W@��!!�<���w ���Z͗�;��t��g�5T�I���a����+򦉺R���\!K{���I�U�G�6�׍�
� �����FR!d������B���|�XwtDJA���󝊸!q�<5a�������~7��W�*�.�{�a] m�<�`i8���֞��K�ً�M�&6W���r�x�(���-;�'3ȝɄBȯ"�yf��/����J��}��*2�q����~�B�q�%2��~���C%H�4�&T���{�����Z�Ɋ�v�H�1s��4/��H�r�4�_ԑ��C6�R�4����G���op��9b6�	��c�8�R�
97!�-���D�_��Z葹������B���sd]ûyd/�
��|�������;;�9!���@s��P���|E�5o���X���>���� d��9�T�pc�9�;�[t��;�� ��;����H����t 9��p>���H�|��t��V����V��r�-sH�3s:�k8��㦊x��'��5�qXo��n5+u��񻊕�z�����RZB�S��G �z��Y*�w��������цTM�m�v�;d��U;�l�s�FI;SՕ���������ߕ���҂΄I��@"=:�X���k�!��l�<|��QځG'�{�9r����s�е�(��u�7��V�F�b��ϗ���Cn��5փ��F����4V�C�z����*��l�%ss�Q�v��!��Mγ�]�\<�m�a!g���.&`�՗�pu��n��:�7���;M�(�Èϵ_���f�K�رؓ
E�wb�Wq�n�+��k�e�l�O񈔝�;���8��~�竼[�@���5�Sn�[�
N	U�� �q�z-}%��>'M�2\5�0w<L"�@��N�����B݋�<6B����[b�#]��c�ϯ�%q�Yg'3�4v��`�3T�H���~��Ǘ�%fz8zd#82��!���Y��Hڛ��C�m�1"<��򠱣b�ab�5��.�
���1�����j4J�������ӧ�EY�`2�F�co2�myo���S΅"�D����Ƈ U��!���-w/}�7���"k'"�=�����=.�n�h�^Ky�#�
5F�޶r�LGԳ՘�0�Q��H�"�dB�����&q��TYr��!}�F��꿐0k�^�H'fz[�ss!^!/�|�fN��Ѯm����D}�o}�����?9Y�{<պB&�S|{$�}>�<�3X��[�:�$�tP��\H_ʡ�VI���L�Ӭ�j�%q\]{���.g��IOH\7�Yhuǆ��1"�(���QA�W���狜��,7�o3F?�.586w���(?��!*5b��H��`�.�<���� �r#!/+�|���N�����EP=��X���	�[�e��\�����!����)�za �X����/	�B��ޏ�^����Cc��эx�vv��E&�m�O]�0�VH��{�D�ۿl�1b��X)����u�$�\�Z ��ZM����#�	�:�i�r<��O(r�6O0���j�H��i�Lsh�<��>��ƙK�퀼���(^3p�z�Ц�n�@(��<�ٖIB�ޠ���p��@��9��i�*yo�� �'��SL�c��k�ږ#�m���+��&��K�F�hwV7g$yKN��T���RN����� x��y��[�=�88X)�qn���x���T��xc��zX��+�Q�M����r�Z�|	P��[���N�,�&�7����s�꟟�I���B���N�4����b��e�~�m�<�5jy+R��Ϡ�Г��iE/��v�7z���"�O��`#�C����q�t񞥏��\�}8�d/`C�-B9]ǾyD��\��6���V��vޏ9?#����E롏��-dq��LP�"΀�M�)��T"�~X�x�G�j$ڬ4��vUF�E4���a��pF�!W������Z� �j�2�d��J_I�^re�i5�z�>�0��\� �}��0$/m�= �9ϻE�<e"���ɲR�LZ��F��*�Or�ˌf�\9�0w
�2̭C&��	a�L�B������Ock��#�ܰ�$= bV;z���?�%���K_��"�����w�Y��[M1��3����Z�s���mt�h��	�*���QEX���v��y8���3b�]�Mgȳ�b��Jv!�V"�r���w]-/�C�
l[�Kߩ���V�lG�ǘ:W�G�2�p��1� <�e���� �Hj���?k��=f�0�������3G�p �\Wd��rv wǧ
:T��-S�U^��o����#.���,���
iU���<tW�U�r�J/��3���:��ٓ6�M�T�te�7��
�E��f���4��ul;
�v��n����3�B6��|��V:��A�^� p'�[Q;�@���ŕ>f���c�a��|����l��Vo8����q����f�am�8���!?jTێڂ�����	ԯ-(��H�t�"�"$[&x�0i�h5�<�)z�)3ܞ�s����(� L�������nyK3cu�c#��Ǩ�]��.�K]�T�	r�1EEg����k��9#����ol�4��LpÇ`S�j"׌9L�Ow25��z>Q�9���2p{��v�<�;����$S1��A�$��>� �  !�F8���!Ia�����	��}�[�t;oc�4�3~!x�6��fQ��U4�>�K����� ����q�Mm�4�,�)�zD��%�EU���)�Y�||��U;/�'슒#��,�]��g�i~�̑����D�ߝ�įLiD����E9���U�g��!��!��W�ľ������A֬���I/̐a�e���0_�V�0�P>%�J��첋\m	��l���Ae&dvԹ��CF���`U%�\���8`(���n�� ׬^�*�x2ض.��6��R�vNɸ���πa�w�,�]��@;�UnRM�x8k.
�z	������j{���L���S5�����o����hQ&�"2���8Jԁ]QN�g ������@��q�ơ%j�&�N�&�KC�l}�����Zi<��0�Q����8,�[�ڗ�� �W�׳������U&���8��ñj���9$ȕ��'s�!d����4����
�֕��@B>Mr'X��#�k�ԙ�	C�\���!��H�"n}Y��� 7J&�0�ۧ��"j�R�5�����'�ðʢD>`5�u�����r���/%�嗅�D�*��OF]�TY�1��`r�I>��Ӎ�
PW"(��\o�8R�R��I�WIQ��O����t�V�8惇�O����KQ�k-�wD=2�|5�J	J���Md��G�#j.j�:k迕����͙yo���m��b�ҍ'ZD�-bۆɨ*�Q�>Z��j:P�f�\;pE���PNˎ�����;+��[��U,��7��$�Gq�4:��\�$�b�#�'���1؋��p}��Xg�0���?�����w���9�����<����"#3���TI	\%�N����8jL���p�f�	�II�С�@n~|\����LLܲcN�%�cF�ɫ7`+P#p1�x�fg���XO�t�n��!�Dy�z>=W�g�:�ꈋd�����;JKna�!MG<1���c�
:�P�&��D~���G\���Q����[�����5P�4p����,���&Ը�p;8M,��r�9��^"��-��q�t��n8�ю�}P�dI�#{@箭T�p�b�i˦�o���l10��"�����
�
Kk����F��x��9|y8ȜN�S8�)6��
�g�K� �����?j���-Oͬ��rx8�*�q�ɳFYIq�ur��u<׳�8k�
&謡�K�E�WDE^�ʾ���Е�� �)}��+|�i�܉E�c�텺F��Q��lp���R�5�T�>}Leg�y�1�����k�8߽�QĴM�_M]P��czb���*�'(�	�-f�.{@���x�j�+b�~w�cs{_/�����Q��Q�֊��+�'>�Z�Te)�86����Q�Ҳ�a�P"�L��!�����I���|'F��^�8���*�����2����!⇪� 1�2���(��"��t� �c}���� Y�+&�_�nO/ 3�a�"���1�����ɺ��M�ɺE%a�v5l�(^�2���p�]��ݲy�5� t�S�EN5�/�.)_Ǻ��ԅ�p�GɧX��S���E�L������c���>4�.�S�Bo\ԇÛ<i��"������X[g��V-s��|M��B��0���"��8�m~�ĮC|x֘�vfϘa8�	�8'�[鲬\����Gn	w*�p�Ȁ�r���
�Pu'�2���ڹQ#��f��u"��j�?o+�C�Q%��tw\Άr	w�j5�(ҿU�|��?!M!��;�� m{@���a�iGM�*#�EV��'�V0�@�����Ub%9�&�M�!��ňZq\Y���/|��u�-J��A2�ݢ����?<�TV��)���Q��у7���k�2
��Ύ��S0�Z�I.t�c�YKR�[��lŨ��}=�
e���/�N:�΄���FT����@%����gDe�Щ\�s^��P>��#�X[�c��������>(A��u`�����@.V�O4Ub�	c�������O��j2A��tm�H�B`��n�Ae�����'۫2@�3��GG���1�ML�b(a���lz�$�s�M��u�+Ȇ����%�����p}�wf���dcj�*I�lO���p�Cs��ij������)�	r�'�<�bO�s�Qb��\��v��qV/'������M-��� v��
�N[�F�z��ؙ���J�V������1(�̜y\�#��T"ru��K)����YǗ���^V?8���Sk��]�5��A:pEm�z,fGHEQ	�ϖ�Rix/׎4\l���(�է�#:p�m����\��
���*2�2�;�$J0s�
�k��nڑ&� ��HF�h̏���k}�u�̜wz`۱ms������c.τn�M�dF�)�+N���4�¯_'X�K9 [��I��ΐ��v"�O��f,( �	��x�X��m��W� ��b��{�����5i	B�MS�q��gi�p4�s�i�s��ե1W�q�,T�ѐ�v��"*�+.`k�ĎU��g����&�
qA�<��	> �N�QQ*ư��:�d�:�)�ߎ�wO��d|B������nqYH�����������T\B8��8��a���ٽ���-V�Ŧ��jQĺ���CU�Vp�+���`퀓�r�������$ �U)!�����p>US�
�K'r'ߧ��E�q��X+�7Xf�qN�����]yڑUt1�Md���
�Uǂ-�S�E���56����F��4-��B��W��<#��1�Z��uT9M~<n���]G)r:{��
������vk��U�i�{qu��կ�����(��m"C�#nô +pS]A�/��D}[%JИ�'��[���h������2�����`T�M���6�A��kh&�0������Vj�����Ĥ��{`M��ӳL���[�E�TM������D���/�<8
�����%_��k٪'�u���|���� Ð苐h[<�wHo>ӃZa�.�0un��T���9�A
�0.�".��x��E�� �
��){�^��H2,�C]���Pc.x(����:YZ%U�������q}L�e���AT>bR�]�^�ZGIb5e��uC��e�lx���������M�mv[0vQ��{b�χ�y��$�C?₀�p$�޼�q`�z���>���3t]�L�}�'����.e��D���0e/��\udT�
��gNX�ߍ��3��o��0��d��͢T �u_�t���65�NO�=(\O4+msH�sl�x�x��s#�~���͠n��yu�.��u#�b4��a~8�qu�B(_������=-�M[ix��n���9�� }�2�F�R��v�f!L44ҟRE���ay�������PA!�D�Ҫ��d�#�EEL��O�DEV���mm,�ԃx3��>�F����pG���ß��n���Ӌ<d�OB�OZ�����V��x��xAh��E�?�k"2*xD����~5`�7�3�����1R�	�h;�z�хp��WFn`�/��w�J�
�[�>?�^ެ�C��
�N�Q s���z�U!R/��U��r�B�Yot\Ɖ#:Q'\BV�m{��㬗�
�)H�CVq������4U4HC�Thg[�d	i�D�,!��'C�Zp�iS8�DN�����F�+6�]�'��C��ėb�=�:@���]���Z��C4��'U��r����k�{�g-���X6DS��:F<1����ɇU�����_��쥂JU!�m��:����ޯD r�v�(D�gАAB'�I����	ޥ��䇶S>$&��,ک��THP��R0�SdR�p����F� נ�9�A�mEWy��o(�7b�t�)C;�52GZh�*��"����}��� ht�T      q   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      s   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      u      x������ � �      v   �   x�u���0ks�@)�.3@Jw*�.@�x �����R�=�k���}~�9���m*t� ڃ�ؔqc��;��V������9��t��D�����[]�<�D�\lp���wr��k��sWgl�9N%�EJ^q�I�y�c�	�Zx����"�b����M�CD��LW}      w      x������ � �      x      x������ � �      z      x������ � �      {   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      |      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
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
�}�� M�nQM0�ɦ?���>Wc@��T¹'��PԸU-��'�����������g�4}��FM7��/�hj���#}�&�V���$�r�sB(��T�)�O���x��|�BJ�ca(���A� M�B�G)��>gR�(}X�dӟ�nK��(nK�xZ��}�xG��N6��IL���t_R+��>�m��G�(�+�I<°�ɦ?jz�m1@���M(��>�a�BM��:(��>&n�&5�B�ҭI=��m1�;5���:��g�BM��4(��>r��9��>�u+�l�3@�n�����Zz%I��9��g���vV�%5�j��}I��ko�������ɦ?ƀ�Ҵ�/��������A���-�4��}� ����AP��}ӟ���#�R��(	x�dӟ�[��X�������^� q  7���}���&��M(��>�l�BM���w�f���߇��to�kn|W�BM�˺��w�>�&ۼ��h�k�>#q�BM��hR�x���6���y6�;P��}� MjRk�d#�)ϱՔ�ؼ���h�a#z�{�`#Zc{_#�X�dӟ
5�O��P����
5]����I�x[K�h���K�QX�dӟ��$
1���ð(�$:�{2��%��l�3@�&�
ܓ��� M�w��5}�%��4�F,n�p�ɦ?6�X<�a��Mh��%��`��MhZӉݑ�����4JK��P���;�w��ᄓM(�$V�v8�dӟ
5��N8��g��a�&'\��g��#5�%�N8��g�BM��p��� �����'�l�3@�&�D�Sǹ���p�ɦ?j-�N8��p�ɦ?jK2���^o0p�ɦ?jKm;�p��� ��T�V8��g�BMb5g�N6��葼��M(�$��p��� M_�kw�#y���P�I4y�䅋&pquu�'�����(�����#����nȑ���%�^8��g��&9��'���4
R��IM*�:�ċ^8��=�I����ɦ?�&����IM�oMjRN:��^8��g���K�/�l�3@�&��>����=RC����\t���.�FGj;�x�dӟ�x��
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H�1��-D��g���g����u?�g��P[�Q�bkX���ļD��!�D�M#���(
5�5,CᇯlKQ��y���R��P3S����������ys>      ~      x���k��(��g�bM ���� ����q Gf:"���r���ݻ�� ������җ�_R��#��z��ܗl�%��>\z��O��3�E���|����?��~{�u�)���O~Z�1y��ך\m4��c����)yI����Fŕ����V��Z����v�<\y����3mOqK)[^�2bd�Ȍ�+F�\�憿	%T��������?�֧��P���R�D�����Qo�{��۞�<�Z�6���c�����ϖ�ģ��uk!�h=��`�
����'�%$XBK(`	�C���qWǧ��U<���m�r|.Z��ǒ�\@\׹��<+�{+���6��2��2��2�E��WYĚ�&D�	���P�:��%�C	�P�G ֡�u(aJX�֡�u(c��~�uHa����-$�!��[)�	X���"�*�Pb.��&悉�`b.��&悉�`b.��&��c�H,[J�Sz��^0�L�Rz��^(�J�Sz��^0�J�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0���J���S��)}��>`J0���L���S��)}��>`J0���L���R�@)}��>PJ0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)��o!�QJ���[H�C�ҫ>��7��QJ�O}�g��_O��'�YVI��/pB���		�gX� 9��ȉU6@bͰ�s�� �lgX� �%4��ϑ3�|�����$�-�$�N�)���ANl���ON�b�� v���\@\׹���p��8qog��`Vpog��`U��r���x��p���n>@bM���$>sg��`��:4��H�C3�|��G ֡n>@b���$֡n>@b���$֡n>@b���$֡n>�HqM��7��ϐS��@(�)�AW�`���H�P���H,!J����H�!����X�������X������$�?I����_O����w<LJ�����H���8)e����$���y��Xo)}|�-_������S֖;j+��2�b�([��Vܒ�\|���_��/�����o�z�-��O�Ӈg�Kt���>�|z{:Y����d��H��ߞ��1�P���y�k�R�9O��J��<�H��(���t �͌R�9O����s��$�!J��<�H�C�z�y�����R�)O�s �ϔ����P�s��$\bs��$-%�s��$�-%�s��$�-%�s��$�-%�s��	�OR �*<��<�ϑx��l��}��`�R3����@@\׹��R�Ĝ�� ɯ���41��>@����&�<�H,[Ju�<�H,[Ju�<�H~4�UF��� ��3���y��X�(՝�  �Q�;�>@b�Tw�|�M�}���Y������SmyFYd��6g = ���>L�1<]Y\ۚf�Yi�:YBNs�����]���_���KO�vw�ջ�>�%AI��xnI������3cw���k��d����ğ%��G����&�r>�k�����V�v�Ǹ�M&Z������?$7�	�Ӓŧ�;��5�n������ۤ���@eKҁʾbt�U�H�l2�X@��HGj6"����S���H�^c �i��e�?I����}��*�r�0Ċ?����5���k$�u������'�f�1z�w=��b �Y]$߃�ZќP$�O�Fd �ɩY��m�f]2�X�4뒁��!ͺd �i�%�uH�.H�C�u�@bҬK�f]2�X�4�q⚀�O�.iH5�AB��1FW�`�	��` ��4�	���` ��(I�#$�-%�z$�!!�I
�]�\W�D0���<LJY�HC��W5'��z$�1N��P�G"H����D"�#?#���3�`~>?�����0/�{�����%��翁����sRxJZJ	��lg��F9�L` �ZR�H~{�jI9�L` �Q�{"��}���:�G&0�
�H���`�EKٳL` �l)�փ	$�-��z0��Ĳ��[&0$�?I����(҃	t$ޡ)aW�	�}�2}=���u���Ժ�H�[��Q�` �R���zH��Ĳ�X	0�X���!�JX�� �o%���!�%�zH���:D	�` �Qª����G	��B�-�3$`���
ͫg����O�����O���o~��ϋ���~���>���t����?+����Yq�V3��&%?SX\���M6������?Wj/�a]R�[��)S�i��l�:�vU3Y�@�DЁt64ہ.�r���O���3���ŋ˕���Ŀ��Օ���KU�eK���5�����6t �x�A
�8�
T���Q�h�_*7 ]6x��p4���q�>���F�u ]V������Fu ��Fu U��@z�h�L�MG�X:�N�F�t ��^�;2]��ҿȄ��ê8&ݩU2M�]Zu #�EݟU�ը{��@:Fxw�Ru U xwT�Q�B�'������`�"�C�wU�U*�H�/���>F�m����}���j��:���u����?����
��V:B�7ڳ��z�=��@��Cj�{��@�q@j��w�{�Ȝ��?_�1?SZ�K�6����\z��2�l�ϴw�`����!ε�|k0�m����]�kOB�۞<��2��J���p��:�Z���<Q�>��L򔸄"ۡ��.ʑ2J���ܲ��2נ�z��g�Oq-ߕ[��ʨ���I+ISŬ"S�ŏ2r}7��q]��u����He�ۃK.��pa;�8�\��6��''�p�5؞��������g�����CY���2��'��=��Ò�ܒ~�o/����ŧ�e�>���h�����p�av�z�Y��Fw�ׁ���&7�_�c��t|�b��zA���~��htzH{
mu����aӯ{��@�6t?vH�mu���
 mu���A���d{���m|�뺾��H�mP�[�e��O?�*�F�.�:���]�uח1��=Rwtׁx��* �u����R��:��]��.,h�ӽ�u ��@ې�ڮ��@����@�9� �N�:�j$��G��E�r� �� �=��諾�����˗�l_/_�@����٩��Ȟ��K���:���~���^�~�����K��\��c��=~��ӯ�w�|���\��`3ޝ����Lmoq�^\ĵ��!/��'=h����5Lٸ�����U�a����^������&���8k4?PBm1�������5xLj�:�~�n՗ e����֙��WL���'M܇����*&����������h�.1��l08��A�����7�=�*D'����b��7��9��������Ģڵl	��9a��Иf#�7GWM��shp�e���ۦ�x�C㑍�m��L�V�}:��Ȍ�xV�� [�cS���tl$^�� �7����F��m6k��a"�6�%4��6KhH����!k6��PG�+�Hx�)�
6���%JĂ��+E�Y��x���-�H�	��6�\�?I�����9�^���W5&�g*�h9��M<Nz[T��q❄�2�H��v�`#G�6r�`���Vm"1p�`�k���Fb>��H|2P���5�H��P���6�;4c����k��d[�'����`��&�H�Ć��6������3@[����Rd�1Ͷ���m��ԞBJ�IeI�ʳm�ݛ׷>��V�9mKHy�0kp?�v������f�_/��G�^or��<��R1-��[�]h�_=��XA����QB��-��_-n��͗���e�̷ڕ6��w����NU�d	1�aV{�I�ɡ��..1�nq?�����i�����lw����X��ajM��q����o_�*    ezb�����ie���(�6��C���bjS�o�c����1&�G�B�����
�"�H.!�J,���+E�F��x��
�$�H�	�
7�I�?I���pwW�L$����n�`�i,Xj�S�lq]�z�{Km�J����'.~�V��u�wLjmTl$߿�.P;��`#�l�N�W���p���ᔘ�o4�Ф�-�H�C�ФD.�H�C�?*�6��J���M�}�?z-���q�Y	b����Gc��xFq�e�`s�`�h�`s�`��Q	�V��/o��	D���w�R��U�
-��P5�;�K�l��~���-�l9N�Or }?3��)[s��I�Mχ��')���"姏�V|Zg�a0�����7?;h��q}���Ⲭ~Z���bi�5�o+�Q�-eui��a7�����_{�n��%��>�c��_����Pܖ6�hQ+�Q��p��s��Fs���T�E�$��ya ����Ģ�Lx���'k�xV4�����T�����W�{��] *�F_*a�#����zX��-�@*7lC@\��t*�ϊ��j�8cVT[���,jo&�E���l /<�WK|�A�.W�}F��s��\d�E��We;q/2��L
�1�xWЬx�~�-�@⫉f3��^�&�u�@b�j6*�e�٨�ont�lTR�ҁP>z�����!=^�@�qO�2�p���B��R=^�@bM��C�2>I�������B�t���ä\E�2Dˑ|m�qRޠ���;	�z����z��H�T�x!cV�W!��J��1J�A�������)H|2P���H��Pn��;4���B�ş�x!��7!��e��..�H#�n�'%�z���ċ�Rd=��@��Iɵ@`�\��Qr��@(=��@��RZ�H.!�z ���+E 0�x����k��j ��I
�]���@�#�G��@`�i,Xj�q]�z�{K�z ���'.~���u�wLj~�$߿�.Pb�H,[J�� ���(1�$��P��H�C�?���z ���:D��@`|k�� 0v\hT�$��Z��W	 0L}����M%����@`|S	 0�	]i� ���Hh��;j�k�y`�Q�(�/���og{2L-N�@:�̈́��9�餞�����[�?� �Zb��),i��!U��?<������ڷ�־�۝����ւKw��írk}{�5uDI-"%��2�Y�����K����g��&n��t���{��{�Z��ů��8/�{��N�r��.��ڝJ��۵[�v����V��;�&�N���oRܭ}�s��p��m����Vm�so�r댺;���N��[w��֮�[7�p�rrkk��ۭgB�Uyo��x��½����{�9���[5$�:�r���jH�w�= o�7�u�r�-$�۷{/��Ω��by��n5aH�w�w^j$ߪn�V��n��^sޭso5K�z��{�����V�E�U{ӭڛn齇L��pN�^jҭ��﹐n=�ӭk!ߺn}�������+�����ڷ[����i�u-�[��z�Z�u��Yѯ�����Sf�Wn���[��z�Z�����]<�ν�3nOI�+1�n��ۣ5~ R�yy��e�·X�[��&�o� qa^n���l���r���[W}�w���o������'_nݑʭ{H��<��]Y�j�v�Z�����Ǳ|�:���^n}Β[&���1��kEn�Z�[ͽr�s���(��{�ևb��b&�>xʭπr��߭Omr�c����)�����#�Z�V���sEn��ʭϧr�Ǐ��|z����|*�ޑ���X��/On}��[�M�V���5�V�&��aMn}ە{_cou]�{_c��v�e[n}_�[�v%�;�{�!��n��ȭ�9��Kp��Qn��˭����������[�½7�[_c��w@��=Kn��˭vK�5L#�j�
�ڑ½�n�>y�ϐ�!,n]��痖�7�=�z��R�qZr�ys�SJ�j�a>V�?1��N�ֻ}�}~����,AR(�O����6��s��|��CXӅ��O{'�Y��R/�}��j҂F�3����8���?|�?�������K�J�~E�[���V?"��wBn�����­/ �^�٭�	��<����m[���On�-X�M|�3{f�k��͇{�s���0��j#�����a�.��ZM�������O&���N����K�dz_��~�7����,O���W!�}`�]�6�u���'yq9��!&݇�ю����؎�5�g���V�a԰m{R�]OZ�I�*��t����@�oj%����@b�jIS	)YÍo�Y��H�M%9�����5,٨��yF_��mF_1RɆf�����@*9�q�ө�l4�xV����V�~�c��o&Z�F�$j2�x�h%�R��@*%�R��@�CP+�h ��M5�x�Ӳ�H|5�2�H�d��Ĳ��H,[-+�q��O+�h|���4�P>�V�0��:$jm��	w>�d���kL/�h �8)��K6H�	�r�%�OR �*�*j�FC:|U�aR�"���%$_�x��7�Z��'�I(��K6H��Z�F	��^�ј%���@�d�1J�AZe�5H�a ��@�^��@⽄r#�d���A�Z�Ѹ�S�V�QG*%ҩd7�/N�䆁ċS+�a ��Y/�h ���Z/�h�\��Qr��lԁP>z�F�;Ki�^��@r	A=�K6H�R������r�d��Ě@i�Z���$���]/٨#�G��Z��X�X����l4�u���-5>�%$?q�^��X�xǤ��d�����J����˖s�d���^g���%$��P���l4�X�(�K6H�C�?�%$�!�����7��Q�荒�Ǝ�Jz�F	-�V�F��lԑZ�F�J�FCFJ�F�J�Fc�ЕFԒ��N)٨#�MS/٨��R���ۯa�F��l4>	�z�F��l4�J�F���*��l4d���zDD8d8��ï�У+-f#�"��|���l/�:^A�o��[���c���C~�+(���Y�PBdx��w��q,P7�:�_���a�o�]�Q�cA�"$kr#Jx,�vE	I=R���ౘ��b�D�Vd@�G�ӱ�ו����|�]M
I> 
�C�$�4�f��KP�mQh\��]��Ŗ�t�l���IW��Dx(�t��H�ad�B�HD�3>�(-?Y���yzYJw�57�I[����yB�Aߢ�ch�ҒZ�����öׯ�=,�
�{:���ۍi���ʏ�����?�Z�痐��{����xo.F��?���ͥ �C�=��[��Т�}K�Lyq%W�M��ߔ�[k�6��Yi���dzS>yJ����!&�^�I����'h֥ZѨ���l.R�]h�KUty^x�LģS��s\�S��M��p{�ѷ��c���K�-ujK�_�� �c��OF���K�+�C�s'轓���l%;W.,�]���/����>��S������%��	�o	�	]�"?�|���"��{B�b&��Gf1��>�]��|��[����=+#��H7V�h}!��\��mV6.��H7V�+�f�ې��FA�QX�������aAU�F��\A!�oH7��4#�BAf�cy�+(������`�����
:�ǏY���n î���c��+(�QWMϩy0�9'��*���	�Mo���e�Q�	z{�$��|,r��ԑ��X��ݔI�zdR� $��J�M=�	z�d�?����B�,�ǒWt�qsAoǒWPl�F{/���ܦ�[_/}m����ȯ��	]{���[X�i3�^����Y�SK���ݶ�q^'F�_3kX��5z<������~�;��z\�i��^{��j�?�z��%ǵ��Y��>�Mx�ژ�M.e���w�������S��9��a�R�{��d2Z�������n�����ͭ-���>ο�������������&ۼ�zc��2���5����|�=��Ʈ��H*�,(�|&Ȱ�R��m��G,0"�����Q�"m�x\�������j������O�^��    �3eػ�����,��1���ch���vX�zo�r��w��k��e��4S�ݿv*a5�gn/��8�e����/P��_Gן��%�e��j�В�#��C�k|́�}ïCh��Z_���\����@��-��on���ݵ���-ii���e�nvc[Fo�?Lވ���n�����?Bu�T������@�o*Q���.\�נ�~܀}�'-ۚ��gnj9%��˛��?��:^�c�~��ܽJ��شx����7�Q�����II�fn(�TkLF*Q�Ƒ��H�Ja�Q�Zm��ۋF�VV���4�nUJkU�6��щ��͸R�$��>y@+�����!�Gw���(���Kn�����z��te�9���l��r+-��*�5M-֮�|=(�$Vk���D�����H&��NQؚ�$���i=T���в}Ht:���*���\ϸ��	�:T�Vq-�EQ����V~���ti ���_0g�3����&��t����;��`�O�˃)0�u���>,�6�!�6��TjC��@���|���4�z�nUS�ނ�b� ��/i�˜{)�G7��O�;�VΙ�Y�ђȘ��n}�̭CN;Sʱ§y��}���L�>k2n���]�x}�M�K������	����&>�����J{�ºaD��T\�ݶ�7�(�J o�Z��gKK6c0|Q�*�߄l�����+�H���J ���sѨb ��+�H<Njp�+�H�	�<�V1>I����ԢV1��W5&3�D��!Z��k����hT1ƉwJ��J �V	�@BҬW1fEI�#1P�b�k��p�@b��H|20��J �%�m�@��>���@��?j�@+L��V	Ę�8�L�/N-���ċ�Rd���ċ��k��q2pM��G�u��Z�b|�'`'��iy��<`Z0-�+�H�R�J ���r���Ě@i�Z	��$���]��#�G��Z	�X�X���!@�b�&��[j|�+�H~��~�����I�z%��/����@$�-%�z%���(1�+�H|���Q�b �Q��W1�X�(�+�H�C�?�@�ob�����@���J Z|�J ��W�b����7�J ���J �7�J �8���^	ĸ�)�@t$�i�@;j�k�R	�0��Q�;���M��a��E�b�[ŵJ �l�Sj�0Y���j�zr�G�0�=���{j�U��0z9��a��ӿ��)�46��y�;O*d�N#f�y�-�SE&zP�юA9s���l9{a�ͺ�C� �1(�a��,��s3Qh��g�1��T�<����@{��l��f�dx^��Ty�Q�9�L�8���M��+2��Qt�I��n؄��)_�Y�[�{��!��u��y[�bjb�o��Z��Ⱥ�����j���e����+�p?��~�6���Ꟑ�y;$���G�7͈?)=�KZ�a\��,N�X[;�5�߯�d����{�������Τ�=��H�0ᶥl)�mz��#/Z	���ԗXp-r�ª��B)�m����cFܱA���Z%�X/��~ȓ�H��B�[N��"]�䔦�f/���_a���v-ѹr(�`�
ia��:�v{_�3�
;��Χc�9ӭs17�9h��&�%#��ZRr���k>�Iql�Rz�-)��d/0��'=OB_$r������5��z��
v���N���t`_��������%����}WX�R��[
>�WbrJ��*��� �q�R˙_�x�����4$���y�>���y!��L�0L�?��2(�a�������:��e��,�gk�P��)�o��:/Na��|�g�3����̄�B�|�'�D�Uy^f�D�Y>/3a��,���0Qh\�#L���&
� �#LҨ�&
��y��$�O�D!ɟ'7�E$?(a���#�;(a��0(a���
FX(dF�0QH7�F�(�T�1sP0�D��Ft�q0Qh���vP��D!"C������4����ELzpq0Qh��5eP��D!�3�y9S{���1�(�*��1�(4���3(�`��v�:���2<������X�A�U�9�Z���X�X���i�g�J����_�?���w36S�R�Y�)���=E^Os0�~��}��+�����N���g=��Z���=]z��W>�aj5��C�)��e��Z�����{́V��c����o�W�����o���[��T��=~~�ym�߲�|�h�r��A/+q�"�ĭ�9dP��|{@�2f�#��B�y�s3Ml��X�w���d��5���e�P2Ȅn��C ��9P�&ҷ����by��Lu_*>_x�|�h��+��3�V�&����/�7o��{�y���Н�]*Ӎ���E�э�a=��^�amîgښ���]��	r{ۍ�]�/�l�SC�a�0�ԁ�e���[٥���R������;�d���cχ�����ݩhQ�VOʾ�[���xբ�Cz]�ڕtaz^��_e~&<���U�\��5M݊�����{y����1�ck/�q��{���lO�����>o��S���Y<��g��?�����D�պ��
��]]z^��g7�l�Tx:�V����<��^G�-��ѕ$�r�)MmR��e:�v�s�>�4��R�� �v��&t}�سou���l�=Ro�������m��%�����ޤ�(!q���^0�h�����t�ޱ���ַ�����՗)ԇ���V�����>u��[ɖ�:�Z_���H���(��*���_��Q/�)��]�����svw��䱻�uz6�\Z��vt'��]���u��n�7��t�Oɉٍ�=�`�M�[E�z!r-��t��J6nZo�ޟL�,1Hc۳#;������Bm�d�D�^�-?'�����CN%�F?w����iF������"c�.mz�:Y�~���6K=���-�5`~�	�{��?����\o�iݦ{��v�톔�e&�ݨ�Z/�$w�Ű��H���!���N;��\杓C�xH	{	��O]��ʗx�.��d�)�"aޤ�����m;t�f�m�;�Z����;�s��i��f�������;��v[vݘ���n�,9k�X*xN���s��l)n+X��Iq����Z�C�C=��$�}9u2w����)淵Mx���&?J>��TZ8fӦػ����.Ĺ�M�:o����Ҝ�$�������Ň�6:��=�$��=^]L�"�D?u��ޡ�~�Y���1ϻ���\K膊�lq6�z�ئv�ם��2�^�}�#�|6��b��%_��^�l�������zm�ږRIʡ��9��W�x��Hr�N�� u��.�)�k����dL9��ܱ�@����z �(t�D�Z�:��Z�4[�1�&��EjG�;X� �+�>�֧P�ȝ}�lj.Z��1&
	�)���"�+��l1��;�ci�����Cv1�`;<��s�=��H��uf���}��o�=͗�"���;M���ۻ�P�9N�u����yY��<v������I����S淐U�P�����^�n������D��;ʹ?��Bg�y|��B;/�7��;Mҍ��N�t��l�Q��JA�uKj�}����&
��y,��-���� �D����c�����y��B��e�Y���VMҍs�S�����VM���U�4�<n�D!�3��,D�5�v5�E�k�j�@�A���B���A���B�����Z(�S1�&
���bdM�(de�����
��q͗�B��A��B�����(^�ä�4
=��xM���xM���4���P̦����_����A쯉Bk�<��D�}�؈;���c��"n��8 �t@nݾz���Y(�cv�Ev A6AvAV���ڋf�ݖ�U?��^@�J��QS{ѪDo��m�ov�@V�A��*�}YY�!�&��_H7�}#0F�^��d�M�B�B�KY�!�f�,#��U$ ^kי�^^����H����T���@����7���ZYx��4�\BP��� �
  R)�����P-D�I�Z.��&O	K*�"X��&q��H�?GT[��z=����-Tjk�g9�t�����)B^	��Lr��[����)�6G2��Ļ��E�-r���l.��h_Z�
�[���۵�\�Ԁn���j�G��Cjp���*�Ϙ��R�L-�����0�R���Y��W��g2�
(]�{�Z��y�#GL]wݠ���$�=��]�\R�q��}?��K

Z���W������_��OQF5zL3P#�VQ����z[�^{��\5{���h�ZX܉^�ӫ��Rj{kY��d�D��I����Z��7��c�FB�^��o���'Vh�ǡ����j�������M�-�ٵK�K%��b�c	��$��а��D�N�=�nL-=�����aؑ�B�9"�*|�z`W{8�e��"��0H���iӛ^�����%�����ص(UZ@MO�~�,-�S�׻���c5��ȶ`��4�6}+��e	ki�B��]��n�w����-OU�+s����ѷj]���b���-�Ǖם{�h���
�W?��LA4�O�Ԋw���0�KE}�ĸI��~�0d�HhY��W >�#��`ٶ��k	���K؈�wEhj9(�?אJx�WK������h��!���s��ly���Ĺ����|&��%�+$��0�U��d,�H,یe��l3�-}��	�ѷ�vQ�@(�o�_�0~a�� 0gG�5&�mBp�S�I>&��H�	�r�V[�W�U�U��@���*���`�"/ހ�|m�qR� �7�q❄��|C^|!�P�"/�B�;S�~�/\�(�%�A	kP�D�`�#��T$�K(7̍���톩�ɮ�Ч��b�h���֖�-��^��߄��Y0E�H�8)�L�.�0M	��LS�)Ӕ@iJ�4%P�����o�7�@q&F���Q��8�u5EH�[J�&c���q�cӱ��X�t,�HBb]�D%`�0Q	��LT&*���J�D%`��}:��t�����ߧ�O|��>�}:���4}�
8�&��*�)�k	���k;.$�a�.��s	-`��;zn��T��p.��1}�ҽ���2L����7{G��sm�е@^�Q�M���M���^�Ȯ�0�:ԾX��sͬ�GI|S<4H�ׅ�3Å�_G/2�a+a�x:�gTsmߊ_� x��V*����|���J.����~�
�z��_W�<�*��|���BNܣ�:j���!�|�nR������(��B=tk]C����8i��B�b{���e�7�J����鈯���A!@lN��=]Z�+2�]{���9�UD���듾g���/Yľ�V0կ~��� -����|~!?�Q��55J���		�%�2Ph���m(%8J�o��63J�c�P��(�B�<J�o��n�ҕ(���2�m�_��Q>JYb|��(!��Bs6J$dH��Y�L��2ezt-%$7�?̔o���0ʜd�v�u��f�q�@!�e�7����?NpK�V��-�-����V�i�_�`�����.O��-��.k�����nR��c�K��z�^�%Zb�t�
��%�g�~<�38�G���o*��h�Q�Cs�.������QM��Z��W��mۖ�Leq������5�G�$�/k�(!�q�&33,`�z^���R���e>���>��"S2�`�Є���a�~�&���@!�6Ü���FZ}�}�k�Gq�I�@�yF��aN|���lz-'��[�0'���3J�2̊o���I����ݥ��خH���
ɞ����Ak����Z��x6�po��,#��0ý����G�z����T!����x'�f`7z�R��n�3�7a������3�%n�_�!ӝ>��EL���Ӏ�y�LU"K�e�7�s@3�V�(/�����ϴ6����Z���C������ϧ�f~�)g7���Z>����|:��;��#�g��Ը-��a-�O�I���&��!v([���*�mi��.}��q{�!��k�4=�́�_�:sx����L/��ђi=b��\����3iS�����za1W��W��ҶF?�^�������˙��jBZ[������ۖس���1h���5�m~���ߖt����ڶغ��%�Ki^�uj�����n"�N6\wڲ��L'@l�Sk�h������g���};������ϖ�m��*�m��vu��ݬ�y���?�<};\��.dPݚ�Δx�b��ͧ%k�����AS_����%E��3�,����Uۏ3�OWgŕ���k]���D]�9�����:�tEťo��b����S�W�\��6??1��̵�!.����..׿.{�7�*)Y?�J=���m~ȩ���s����,ͫ���jB�&� ���S�{n�8k��e��d8��qn�[/$ܭK��W���]�.�U���V����U��u{����Z7�z;�Z"���[mq!;:�dZ������F�,�B�6����]#��q٦�9dXb�@��J9<��_Cn=<������34=�$$��e�k������M����������G���^�V���������������9��صT��Z�"�����c����vl��E���z���*wa;��Jk�kf�̰������ϋ�ѣ�&rv�{�.R��v�e�TI��]��y_Js�l�~w���~v�ߢS��6�ܾ���r�7��J:m4o9��F��g���9��.��z}14�������Ef p      �      x��][�|v��L���0�d,��8��ޗv	��~H��/BH�b��y)sZ�4�y�gZ��׿/����忋�g�m��_�?����S������mQ��V�m�������Ve��Y9+`i�/챍aKw��)�V��
�SQ��B/���m���U�L�j�}J���1��(�UQBk��2��WE�ֶ�6n���Ap;�5��e��(��(�\�YUR��Ц��f�]hS��)��jo
�wE{n�����#æq1�*��'���]�q=b��0
ם���dx\�L1�L1�L1�L1�L1�lRX[��2g���I�^�9f�Ie�Ie�Ie�a3
�dYY�`�X5l�5+*H0�L1��1�F��V	�=� ����n�6)�]Y��_Eᯢ�WQ�K0�L1�L1�.���K�K��� k��!'`�2�*�(n�r�\����`��c���al}Sl����(0�Q`���G����˂� ���8
��~�/CV�Y�2d�ːGAVYy�͊�!+^��x��eȊ�!^�,x��e���Y�E<Y�Pd��8+ލ�x7����ʃq~��Q�2m����JV�*Yz0Ίc%+���8V��Xɏod�p��fȊ�!+n�����fȊ�!+n�����fȊ�!+�oVl߬ؾY�}�b�f��͊��7+�oVl߬ؾY�}�b��jؤ%-C���D���+���#c�%���=|7��
���8���=4r~^/���M4	f�Q��9��/�3� �;y��0�^<�u�cp����K���\�����Tz��Qw��p�s��,D�^R��Ӽ]:	#���綝=�w��`��ɣ��ݤ�ݦx�Drׁ�S�{��ǖv��^�ha��S�v�s��ޅ�D��4X��{��&�h�h�T���^�j�h�\��Gu�ZI�_~���x�i��ކ���`��js^ڍ�:G�)s���~�����g{�Y�X�0�8+�]/
xU���}�����0 G���P;VF>�=#``O���9	��I��� �	
��� vo7������=4ؽ�hil���[���pI빮=�7o�ҌGKc�4��ލ�GK$wmE�j��H��޺iNs-Mz殥ɣ���;2r���܏�����2B����L���3��O��<�2��yVj�B�6�J�F���y���i�7L�n�P��v�-���%���74܍��ђ�ѭ���=�<����-�����<�+�����<Z�o�ux��\�(-)U7�GK/nH���7�h��n`��h�F�𧿤S�"���a�q���:�x�p[�r��ں��+�ͯS΁G�)�@����NI-q�bM�U���4m��+;��4��l��Tw�I��5ٖ֭�C���%���R�*<Z�s���,�N�~Ǽ�T-��b��%Ns�0x��in&��N!Ŋ��|�ђ^Rl�N�^�
qe~�ޘQ�n��W�8:���vI�����hI��$-	��.�Ԁ�ђp+ΆN>�LCKq���y��R�b��i���
X�� !��w-E�*6���N����Σ5�i��4s���d���ᙯ_��\�G/�������Kϣ%w����antz���B<b ��"`!�4��� "(Xe�-���$���ߩ���%yT��N�-�����\���M^�9;ex��k��٩���%^Sl�N�-�fs�?p�)����ӝ���>^�XL%�c7{�[:��<��)��-�'�R��-0�7�������?�'n��n�,� p���������e�a��3��)���^84�+�_��<�G�+abOl�VwV%�Q�M��⭽��Wf�޴��l$�R�]^Ʃ��3�%�l�	��xk���'{c�`1$�BJ��K��M��$�����
�bH�`=�d���D�$l�`z':	��ڭ�0�jI�Jv�&Xa���s��r�G�p;��n���q���J�	]���qQ�m�Se���������{�*h�U`�"h-�[���C*��(��,��C�2��E�f��6������|��*���x�H0�.pB	`�������(S�d|�������*ː�Z��������)<��k��
`qh�C���s�
���g�g-��	`���ئ��5�Y�s&��XY���)���ߥ�`���k���A�<D��y�G^:���!2���in��2�3�e\K/��u�!v\-p��Y�ߣ%�;?���	.��kLp�Y��L��	O &�Ǚ�N3-��L�y��8p�฼�A�^�LpZ����N��@l��]�&<Y���UؤU�$�����;���U�~��i�2g�7_��.�a��ke�sZ��a��u�/~���x&��6f^�jC�艓�@�0�㯣�,��G<�]�泝V�O��o�Bs�A&t|;�jd��D	}��D�ڽ"��ˆ�?`x�W܌p� ���v5�D��ٍ����F�_�Co
��w�l����5���s{o�����R���ߘ|��o��+�8,JIݳ9�)�'��8W���M��Bv�e(C׀��åֺ���L�z� >�o��h~��m2�k.�5uT�5V�ᄭ��̈́c� �L�*����S��͛K���B��`��1��KW:���ܡw�������5,��:u��Ή�<M�(և�=��5�GoJ��aך�L���Pz+-�%^� � ���0&*64G�ҵ~/�'��aJ�Ҽ����+w���O-z���
�ph4�jl�eo��Ӧ��DO>�/�Y{��I���x�_��4~�I�b�u?����E�'�'�Gd�A�h�}�����C=�_�c� ,e}�HF\����=烾�^���Y���;G�V��o�8\K�k�Y��|�M���v{=+��-����_�eT[���1F0V��wv-��u���/����7�v:*?���}3�V׆,�8�=�}���U�����QZ�l�A,�n*T�鴈��B)�^�X����%�/����������d���c{�b�u�;�b�:^�X-ԅ괋�kR)U����|I*�c,?�PЪ�3�/&X�k,?s���7���p]ĭ�ג����;K�cd��-&��t�b�hi�nj���h�jB+�N[L���}ܙ�My��Q<�[7��'�k�kw+����y%%����!��R<Z�ӈ�F�*����~����[�(�����!b"u�%0�m�*�?�I��n��<Z��{p�h�������9�y�wpS�wx�2����ŏ-uu/��]��2Vc�V�'��SG&腙	��M�e,$�Y ����#ӌ+�����&����,��)$���O�L�].d�0>��X�/Eo���.^���R֌�Bd��I���$�B��Bm%�L[�*�ߏ�,�|e�M�6}E��]F �F$R��#c!��y!�Z��cI��ȊX`�X��Ո�,H�)8����Q�1�I90f�D�ʴ�+�F��1�e�"`弐tV2���ZF��a���jF�T�K!E���,�m̅���zH��yƂH�X)��,��aX)V8L��&�M���"`��0�/VK#E�
oc�q��'G�p�Ğ�VI���{T��Nu����>;�"`�(S|�N}�X���S")D�)� ��;�84�����qH�cA��W�N���&��X�h/ƂGkTx�c������)���X�����)'����;G�y�]�~��t}��^����}����'qOu9�~��3Q��d����i�4���V8�]?~�湾jP~|�=�_�#(W�J�~�x�u�33�����7hj�:>7�`���צ���wA	n�v]`v����PtJ���[L(>ou�f�S:�7�j`ɨ��<�5���D$ػ��g1'�)�jh����NB����B�����ȁ?ϩ�5E���L=[�[��ᳱ�� ��O��^X���)p�_!��[y�7�
�|"#�߉��к�㨆5    ��4��c�S	A�a�P�`��cn +��!B�CG�"��&:O.�"Y����S{o^9u ���>�ا��T��8���:ú��ۼ��κ|N���,�7�HM��2��Z����Ӱr��	l�b��g"DS�c_"`�N�ؗX�e�+�ƾD�
�`�K�pƾD���+p���`�Uݿ�����cKd�
�`K�0
�����L����0����+V��^�,��DFV8CX"`�Îڳ�Eo �sc��X"o��H�
^�#O;=�����D��a{lS��RΪ����P���1�%NS��������{����D��<%ZH��鄴Dn�9!-�]�r�b����f9!-��U�O�y4��&�G�X�lw��hw�چ�q�1��}'tq�V�V\�Bo���t㊀��ӏ+2�)�����䊀�@2嵡��2�Ch�����������4���]��9��"`e�%�于�&��^����8E�_��$�G�i� ��;B��J=���7�in�ϩ��C�,N��S�m��>aÿ-��(�y:��@y[S�#��?m	�`�5
{��.�6ok��P;Pp�ӭ�ڃ���*�Ub�ko���k��a���4V��䨇w��c�P|<��)�񝘇��0,�����eX����7jϰ�6Y�o��=�^-A"�e�����(�Q�U!rW"��k���a��?�+�wؗ���(n��>������pj��_w�zNg��=���������ԭ�&������-, �z��n?<2Z�;�o%�>��b}:��"`���e>����/��:���B���ڂM�n!�E�Ύ��"�݃E�&b���KGm���<�w�Z
�����r'wq��[���+֎�G�](al?ã�����gy~��@�H�s�h<D��8F���q��4��u"�F��\�j����ڰ�|����4���	�x{
d�֤Y��ܟ���'�2��8˱�	�x�
����+�9mT�L�i���H%0�7"��6Q<�~��dg)U��ڤJ�NS��8>�X��Sj8�XI�Vj�9�X��VR�M��縷#`)�[Y�RoӤRwJ�Rǳ+�,��S�^:��X�g�X��َ�M���X:����1���)%VL*t����J%ƬԀ̘T[�x�#`A��64�"�J�*SJc�R�̔�I�.2徝�R:�ec|�J�ͬ\������ECQJ=l�?S,�Y9b�����UD�qX5ٳО0�]K� �8=8�y-�yK�ᾈ�$��"��ޡ���<�h�voZ�1�fn����ߦ��t5��\mNk�u��ђ���m�6|E�N/i}8]�y��l�R�^�r-)�"�w��j��K��i�$t3����h�I4�$�o�����ا�ה�ߦ4�6���IͿMj�mR�n��w�Ծ��~�<Z�O�7��n�'����XS&YS6Il.�[��b�ղ
�4� -[1�L2��1��њlK�V̡]��[�J�-e�-e�-5��vL����Fѷ�`�j�ޥUK�V$N+���+�$+�$+�BKzI�M����>��d*�,�*�����<�vI½I­����hI�w�I�-	��l0�ِ�F��%3,KfX�̰,�aY1òb�e�˓ !Y��b�eɆ��[\��,�Y2 ����k�0Z��b|f��̒񙵷�,Y�Y�>�d}f��̏�8���E�òd�e�˒�%;,KvX��,�aY�òd�e�,x�	GC��dSdɦȒM�%�"K6E�l�,�Y�)�hS(��o�Ǐ�E �8-c>��Df�+я�HpF��~:~���Ͱ�9�`��>6v~��it�&'�T3!�Ş��c���=ʪ�g-?���^=�/WG>FG����ȩ$��s�]�&Xz�aW��ý���~YznLc��۝%~N�62�'B�9�̤UK�Eʚ�sC$�~Q���X?��J9K��X">2�@�ZHi�dKg%�8&y���:��;yўD���������F~�ڳ�h��1�ў�ɣ=ۉ'��h�v{�<Z�17{�GK4�=�4����hϭã�����x�$dn����7x��������9fxu��<ZR.���GKJ���h�G�]�+���7x�Ds�uʣ%���O���t�����-&~�h������m������u�������do�hi�n�����XS���j��
X��b���<�4� -[1�:�<�5�&�Һs�����[�J�-��������<Z��:���yo�4Z{���%Ns��x��in���N!Ŋ�do�hI/)6`'{�ר^���zycF����Bqt���vI��FZ�hI��H+-	��.�do�hI�gC'{�Dw�7x�����-pj'{�G��go�C+`iڂ�t�7h� ^��-�f'{�GKW�N����H3W��N���f.��u�7x� )c���do�hM%J��a��-�\��:�<Z;�$U�N���.[�Y�I����)fA'�GK����-�ڸYp�b��p3�zL���/�����������6���L�19����'��h�v{1_<Z�17�GK4��4ܽ)�h�$��^���^x�$dn���b�x��ţ��/��Zxu��|�hI���T-)U��ɣ���F�w=��|�h���m�GK4w�[��/�T7�[8L��/,Ь�ţ��Z'�Gk�4j'�G�ى���Һ��-QM��:1_<դ��4m��c�x�i�AZ�b�ub�x�khM��u+�P'�_���[��ţ%>wc�x�`�ub���¶h��b��UK��5�h��ܷ-�B�׉��ђ^Rl�N��Q��/�^�ƌvc�x_���pc��풄�}��ђp��;<Zn�]Љ��ђp+ΆN����|�h�S;1_<Z��N��x͏��V�Ҵ	��|�hA�:1_4Z��N���(����/~�5^�f����/-�\z���|�ARƊ�ى��њJ��E��:1_<Z��b�ub�x�vI"��a��/-]����ţ%^ŜN���xM1:1_<Z�5�,P� ;Ew��� "��.���C��.�������G�+���������^�]�l^�]~l��.�n!&�St��lzEwi���ݥ�w5�c��c�[V+V��c��鼟���tq���]�L}�����
R��J<��*�sz�[K�t��$�~�WՍ@�����>]���ຏ0�O�x�"ۜ��W�� {|�C�+�־1`{��@GN�~
��M��!��K��΢�7��˼�w����ܞ����t��������J��[}�#��x{�4�,9lk���7�R�j��>��R�#a=]|�J�$�����y4�Q�0�S�k�b	��"Pl٦TX�3v�����wݷ������(�Ȏ����^�MY��)	k��]bU8�\a�P�<��c�+��˒�o7sX�笰�)����Zm��h��wJ
o��Ϧl�Չ�T�=�@6�|D6�ie�(�Е!pL<fe�%�Y;�(0�u���rVu���X����'!��l��3�}A!�iX�*�����Ū��U���lWQ�"�V*�.+���V+��E��$E�F�ð�L�&c]Gp��ZL;9tݿՓ����؟&�n�Q6�Q6�Q6�Q�Pd�2ձ3>adE���=��)�+�+��"`�Îe�h���;7���dG{�!�+xɎ<���w��"���=��]F)gՊ�C�`
���"<ӔitFx{%d���s��<�R:����h!�f:W��+�E�/[r3��,&lwY�,[�-��OԒ�U�s�CF��e���Ly2�?h���N��wBS�*Ly@4�Og��[q��R5;Ư��I;%6Q��L�.Z�ɔ��e2�Ch�����Xk@W+�K�_��Y��^�͖\��߆]���lU���U���$�G��`g��ig�J���c��n�s��v0�}fy�i�-��=z^�in�J�>��^�H�Qc͚p��HM��:*(
b��e����m"av�w���yU4�5z�u$0歆���`�
$�9�ف?��g������:Nl�"x��T� 7  �ܤm�Lə�J�1̳���������>���R�c���R�K1E}|s}|��� �me����9E{�vLu�#S^�\^�.�H���f[�����<3`�I9��\+�妋�c�=;*�֟p�OK�du&�kl�@ ϶>'y�#�E5����@�\V�׬�ل�f��9�q��3=��\?�Wͻ^q^?�������#=�} �)�G�Q/LK���O��[ ?#]���(� �3�Z�/J޷��U[j�#�xk�j2���c�t���/�ғ�{�b2Cr�՗P��1�60�H)���_�/k��g�u��k������T2���>�*��z�ޞ�]�sK���5���B���G�K'�nRz�Gk6mB
czҫ��EI���4�ѱ�p����(�7��ژ(�{��|��e'Q�G�f{��|�Y/Q�o �I?��(̓�K�����u{��|+j/Q��D�%
�h�sj'Q�����5�͝c�o��c��B���1Ʒ��s��3�z���O�����m�Ԕ�~m�1�|�}���|�Y]�
��4��o�g�H'����ݖ�'2����뾽�NZ|�D�t1vݴ����˶���K��'E���Nb}`�;���`�>p�v�K���B���5���Y�08�#`�E���w��T0�}G���r���P��v��5�q(�S�Ds
(|I'�&P���0���
���
}0GX�~�$N���1�-��P!�f,�`Q�B�M�"��K`,��Ǿ��)��qp���A�@��<�BD66(�� ���"���"���eN��),���0A��S�BddA{;E>x�D�*�-��םx4��"
�A�+F��(���2��B�`
{�id��Va������X�*,��m(���S!��q� T	A��3A�8)Awc�sc~�n��#��E�o���M�ٍ�[� D��.�"�b�`�Xa,�+�E"`�c�!Ѡ��:p8.��Ad��^c�X�k�!���Add�c8���Adڊ*�:0�1���N���
�a�X�0����a	-�1ܞ��Ad�X� 2q�����GW��D��yy`�Ѡ�A��u�:0�1�X5±���#�|��#�u"G �1�Ї`�`��^�2��AuF�1��,l�S� V�Jqk:u"`�I��A����ɩcw����:8�p���c+��u"`�ފWөc�_e�:����A�M��8��Au$S�^��C"�j�Wփo2��T޴�20�1�������Xƀw.:e"#+�Dqk:e"`�I��S�  ��Թ��}	��2�gȖt	85���2tt����_��&�e"��A�"?�E����{T\#�_w��ͪ.j�����Q���3���E��8u��ia��!��Ua�w�ı�
LX�*'�sg��~v�s�
�u�C��O���5;��?�a��CD��Z_�+�Z��"���r����sL�Z-���^�;��y:n���Oݣ�<�cc)�ǯו�x?�9�����R_�_��R_'h,p�y� "�;� "׆�D���7�.�^)���[��>���cR�S
"&���CeЕS	,3�/CN)�X	��JA|��7�[)�}�� ��*A�[3���_���c4��Jܕ$�/8	4�J}�{�w%�;0n]Xp����u@+�K�B�K�+$x~p
I�9{�9�7ྻ�D"��2<?�StNO���w^�exs��)7����q����NK��O
��j��Pf,��D'������4�w������I�cK
�i|C���I��w��÷4�����.�d}�K���B��[�_������I/`b}�ฎ�����0<���2�%�}藿�!�D���� ���a���|�F4����oL�냏�qp��Ԛ�s� ���9�$������$@�^N`���$� �9I���O`1L�c�
�I�`1�OL�@�OL'	0"W�� �hC``�0	�c�@��S�I�\�-H���Z'	02����$�{+Q'	�㬆��I�l�p�r� �`Ѓ�m�I�u��!����.��Y�*L�L��l�����$�oC /�N`@�<�$T	&F�� ?NJ�ݘanL�g�&F���0Lܾ1Z&B4E:0�%V�$L��]�I��b�``�0	&F�
�a`�I���I���q�I���+{�I����{ c`ddHԘ����0	0�$���� ##+�I���aN��a	-&nϘ�8&F&�$~�/ptE<0	0V�K'	0D4H�|0	00qL��1	�c��$�&G8&~��#�I��# � ?�!�.���[�$F��0z0	02��YN`�l���t� #`�I0	0V�S���$F���K�P��<78I���Y��[�9I��1~�u� ##c`�M��8'	0�$� �����q�C�Qަ���ZD+N]R�J�&F��^K�EL䝋N`ddE�(nM'	0V�D�:I�pKl�ԅr�԰O�&~| �!�������0�s ?F�hʚ��{�2��ur #��?iG}��r �W�,K� ��b�ߦ����g��E��89������w`{E"�_��˝�R����1��Ia�O��A���@}L ��� ����tL ��OL ���� �]N`D���v/$��� ��_#�*����d �����@"����
�e �*��'|���G�������� ��Z`�'2{mA��d ~�>xv>�������1���������y� ����N�_�D曓���v�����GI.���[�@!I_ୠ�zż������׾h �Κ����ȳ�v0�/ =w�_{-_�������;���ë�.]N��M���/N�_����5�NyS�Y���+�����(X��%q��]�5�����5�+ŞD��,���Hh�_����PU@&��G�������?���_�            x���ے��������4���RNTNT^%W�JaIh��]�������C%��v�l�6� �wϩ�y�?�ϧ7�����_�߻��ƾ#�;f�x��;*��������������7�kO]Kz���+QjD=��#iO:6�h=k�O��K�RO�6�S%�M{�j/���߿t�{ﾻ� �����x�*5�D�Q��ȈG!L�Q��*c�AB��=ӵ�\��adJ6�~�r=J�4�w��Z �L����O�4;Һ?��RQ�L�juj:� f�Y���l�G�r�d������7�u��S����%�# @�ļjQ0�<9֛�n��Q`���r{�ni�0�����룳n�v�~�h��	�p �F8�{�d���:�&X��8�zEp1�n��f������@cU�$�X�ΐ�1	��hI���#h
�7�"�06޿bLGC��`.By�P�GLĎ�z�ĳfaX� @N��P+���@@�[����i1���}����������ӱ]����1�U6~��1�a�:�U�M����:��C����K)h+�����>�'.���FD@HU4ͽ|���wھv���v�9��߮;�R,͡�b�,Gֻ�3&d	_dP�%Y�A�n�
pVg�z�fM�x_k'��7��O	ɨ��B3*d����Dx����1�$������G�ʩ�[@D�L��
Y����c�������k�]�HWFFQyv��C����<����S����_���C@�=P���_���0�^��~���>�}�|쎡	��~)g+��#��$�(~������ӹ�{�W�&Kz�����sm&g3��xGJ2*�;R:�B��Y�xG�s& >R��v�y��-f�H�
@��:��;Yj""P��'�H���1n�b"@��cM@��`�Q��)�	43�L%X��j�3j��2{�A�5'#a��^i �pvE|�p\\Y��U�v��}�EI���1�"!�bc&�\�� �4LG��1 !�ӗ�v��4�yC5��fW�X�g!�Ď,��H�a�aԻٺg�}8�q��7����q�e������3ڦI��F�6�]i�t��ar��G�;��vw�('����z�D�<�	Њ�"�2*DJgT�,��QzP6���I�D(@�����#,~h^"�+A��-`�"�*�!�к@�(C�"�mh�B)q*1�<|��d�ъ)he��+�3��1�x<D=����$4��%���&>BO��'� @U�����ЖM�7�m�O�n���z�[�x�MԐ�:u}{p�ɪ�FH�)��9����>93=�v�c�O��)���	�1��Z��1�Ƞ �ˆc )3���xmɖeh>�6�WQ�٬���F�C1YÑ��H���XH��i��!�_	:,���/���C7�*x��do�u������D��4°�ߞ�md�܅0Z�Uf�4��Ç�KcϡM�|��%Ҹ3���=n���l�2��43���k�|:�w?�/�ad��u��1'$��s���.���hJ�SXw��Ȩ�(ͨ�,c�rh}L�<g"B�P �""�2����2&&�P=��5d�ͨ��X�-�;`�`ހ�'����Է��v�X�I�U��:qu.Z�jO0���⸳a̡���)��ؘ�qU�4nphw_N�Ӊ�)�����px�����/��9�b�`����11`66⁊��	�i�FDH<<����&�,'�q�������G�{��	d;��~�l�1�=!oaFX���YYK�iI�Y����Y2��HY�	�����T����W�jn@9H#!E�lB�!	�Ec$D"�%�z�(1bQ"e�d���F�M�kGeiz��7�-����5)`��t΅x��`�9h>CLW��3-�dD&U�"��6���y��lӰ���W/C� C'���x��X|�A�܈���n#' ���
4�-�|u�Hc����g��J���3"�h��)��}�����F�a��[�'�-}S�N'��	�oA5Q��Mwj�/�\���fC�3���/���n���Om��6����i\Ƭ�Nhx���F52���q51X�$���O����	W��j����S��m���|�n��l�뷯�����}�{LwOŊ	�[-ho�qs�?���`Ȭ�Cj6�'Js�������5��_�w�يө�ւ��O�ڇ�M���͙e��"|�}�=S�y��gQKKD���S��ShC�gӊ��ן������Cן��S��z�4>X�������:q�3�p���]?��Xu�-͏�q�E�M��6�r*��J_DCq�~��Ip��q��=����j��;8�ӹ���Lё���DTm���@�/*{ى@��e�1��C��	(�+c �,S)P�v�!HHU]��9��$Â�pN30�� ��fM�'f���p.
PȄ��0�ݿ] *S���;j�q��]����0�ʭ@JÊ�u�]1w� ����y>W�L�w|��r���hT��о��Y��)�8����rN �C�����!�����s�����U���RE���*u�C�Ըd,$��`�p�H�a���1J@Lyz��\��ҁl�z��+�3�T&�B��ʜ �4ɨ�w�!,�2,@���L��R2�+�+�A]���\ˌ�1,�Q1��gT�a��0,�1��\z]��eh��<%�R$�U%<f��1K�L����b"D�&� ��#S c��ɐ�D��_27KnV���Ӧ�^wә��B�ےL�eJx�����Ԗ&S��w�jv!<#*<n=��Ze��U�%zH�N�.���x�t+�������sh��6Ǳ0�_�φ��|US�Y'h�G�&N�L��4�+�(�� n�S�Y�t�/k�����F�I�PU\`�i~�($�*gmf�,|�Ǹ�f~��c�t�n�v~C�ؐ�p	���}p��,n�>��b���/�g�s2+NÖ��Z�Ը�{��N��87��ˬ��c�rj,�4�>���W���cXqu1g|pS���m�-	��ߨhwd�(Zs.���4��FEcQ8>0��%�U�^���o��(�QcuK�cs�%ߩQ�@K
A0�����-+qr�`�+m�1|<<�v6���r+o�OO�@#�.�!s+k�p����2�HBn���$�LG�o��@���aB9���D�L��RI��qtDgT�KS�ɨY��J2,@��L�(+�T@T@y�x_�(qj�� �(���
ZZh�(�f�(u��FJ\�J�9E�h�T+*XA����	,*XA�����	,*XA�����^@B���V`�P���iT�� �Wg,@F�Ϲ�����!��r�(��!��d�F�)`!'��QԮL�8���|i\���ޞvI1ܟ�+�T��Po����W�?^�|��u�t\��Zج��_j������o��$Ę���!�J� O(tJD8ma&$��2��.IB��&I3(��J�0!n����C�`!��ڎW�+�.U
9�.d^�Ϲ��ߵ�|!��r�����B�)%���K�Ow�oT^�;��]��+wOp�Ry�pH*?�3�!�I��'<*�H��*Ŕ_�T�RU�\�S�9FB��+���ʇx?�}���W,z	ĔrZ������v���H]�&?RP����f�X�:��;t�l���8�JX�����;�_�v!�.�L�R��u׌��̯Q�xjO�o�L���ogƆc��`D ֢���Z��`��	�Z��X�9z�-�Aא9n��a����K���?T�0� B�)�We@��d0gU�)���$LA7�u���X���ht�ջc�F dX�a��f��A\��]iOh�DCx��] �o꺲�oxCׅ������}{�{߭�/��pIFm�����ve5h�s�W�Yb�ՎG�� ^B�A���$*E"d.�N��KbJ��'EIʅ�_R�R뽀�,C����I�k��Z�%�� �#��a<vC�U�8R� �   Y�5��墋����v��O؊���ٖ��@�/j��'���$�_�����%���C_2��4������>��4�27�˗��alu��H�r��S��H7�., T��n�A�j��i�j���j�_�^bS      �      x������ � �      �   Z  x�����7���SL���"%�t����Spc � @�4���ўÅ��I��Er4G7
_B|�p���mE	!��č�-��F�-���?������󯯟��!�����_���?��0KS쬼	���ה����~����ѥ��+������L�710��7��>_�1:�>����M���*Nc	�1����l�l!�b��4�ب8a�9�E �H�}N.��)�I+�����燼`�3m��=�q��&����V�`h#�����NAX�� �k�#1��Ӆ�%N��X ��~��%�׳����HC �� �f�$e��U\�~T|�0��YR�F=D/���l1 �ENs�0�	��JM^[�Nsn	߄|nqP7F�7���e@u�L(�Җ���ހ���@j��4�ګ�6$��k���_D�'�Ea�7(�R9r�:fZq��8D�9�aO�{��*����7� ѷ@�}*�v��IN&����y�h�F�A�!� �	¸^b���R���@���V�TN��aa{ ���q�*�H�@j|;Gc�Dl�M{34�8iL�_B~��5�����_dJ%�#��-H)>ӷ@kM�sPS|k��Ƴ!q�3��dvI+NR�z��4�Ni	a/�Ȧ�ҊW�BnB��$��U�N�P����嗏�wˏo��>������O߿}�����O�8�4>j��|��
��jC Q�N��^/ј׊��U���&$yJg)�tv'	,���m<U��2P1�i���iu�t�y���=�GW��յ
�j��j�lB��+��\�ډ�B,��[C���_Jqv"���<�D�R|���dۏ���>4Y�R��"D6���Y�>m�ĽR|��J�8k=NmG��g4�8�	���3RW|�2��T��G�5��Q>A��D��m/�x�ӱ�<g}��lpҬ�=_}��g*��!_��'u[)N_x58\)Lx|�+��#���DMl���1lh/u��3&�M��):#^D5�-�b�
��"�u^�S���Dó$]�)�g,��ɭsSUbk��{�hhZq�b18�a��ǅ˕��." ��!ǅ�иI���{�:jM���Β���:%u��+��s8�gAi��=T��)�i�����4�q~�cg����8�El�`��H�����$4���y��G���x�V�KI��;
i�|�m�Д�tG�8:w܅T�.�IM�����.�ݖ㞴$��R�����{G #.�Ǡh�GŉH��&�x1��"&H*u��6d��.�C�p�IG��+C*7!q|Fb��T �ܱ�	_}�W�R��V�����y�C��#O�� ��� }����:罏S4���e�L7V�Ǭ���Z�#�g9.6Fa�S��\�̆6!	=#y_g�|���׉�M�k-�,�R��r2�i������� �)�߯И��`�ZE.4�8}e���l�<fM�����L$�C��ޑ�>*����J0����W����+��!�S4is�'j��>*>_A�)��>�g$r�{=<?����<����T��"�Mȓ�꘳�3�V���0�C��9����_�_VR)N���7 ���h�      �   �  x���I��FE���T�灇zћ���_��d�a��<Jc	�
���#�n>��{�/�~y�������9���?���P�Pןk��翿�O����W�O_<hB,��p�ߦ�6���7�#S*��(H(��n�g*���7��k��W�i��)�O�����(}�G�l	��?�?��ݒ���s�(�ޑ(���'\ȷ�<��*r����(�(�wT6A�OIӆf+��
-�d�۟��D�ψ
�zZ=u�n��������`WZr�][Ds�����}�
�����e�$)M�����S�<��'���ܻe;0�/9��=�	�3x��ܻ�4M�j�L�n��������pE��˒��HF4Qy�wO����џ�8*��n�MR�!�$�p��#ܧyw�.��2�e�O��ԖP$"��=C!�H��(��f�`�Pj��c����G��O�����ZYED�a�hI�|<�B��Y
Z֎ �����DD~�l~�y+���:i�h<n�D� �����?>�m��TȺ,"Z]�Ϙ���+���b24����SPA��������|���	��FmJ��#|��ꓧ�ww���I�$HK�Kę��(�)*׏�E�M��ȱⰆ����1�L�T���&�f<	�ś����Ѧ%��;��l��孝���}��<Զ���+/��:aC���W"�]�F��D������2�9,�1:�c��Έf#��?�]�G<��Ԯ��.������Ew������{����h]�$#Z�����,�K�hQTPLgRy-�A��WD4I|��A�&|�{x�n��G�{:��h<,�@u)>��O�8���G �w�w��	��h�4�Z�~�3$h8Ҷ�;Z�kQ�=����y��@Y�@�_2���h7��bt��OG��@"�E0�#�����O{|�����f�]����:�Q$"��>�'�s&A@��,�W�azjy�y/O�r���ep�a��h���r��\�S����Z��DlBdD���tЬ�0���$���o�{,&�4�^�Ƚ~� ��ß�;m�zF4~|\R6�-����Bo���D4��m��R٨5�i
I]��/�\��G
�W�Ck�2�	�TА���^d���[5rT2MD4����Ѡ�2d5i�C͸eO'"<2�i�d3��剛�xx��M6>�ن�7����v��tv$�[�|v���ǌV7�(q�W��?4��GF�g���6�Dd��u�(C$�;�j�o�����x�\x�QF��j|-�9;�ki�'|���Ҹhi�=�x5����U2�=����v��F>��9{#;f�����GVu=��5�ўo|��쐜�D���\ě��[���\�hZӱ�y��Nw��q,󽉒\���%��h�����;�tW������9�ه�wV1J{u��5?c��ⱍOG��ni��|HDf|:�=:��;[&&�����k����Dm�0�?�1�xD����RC�>R�Nտ(��Ef|��#���������گ��Ru�2���3�iL.R�r:H�Wqt�^D4~�����͒���\L��|n�
��Ȍ/��d�o�d1��kD���߁�,�Q>���X�1�<�I��N6~�;�1������q HzQeJm�Ta�=t��ɡCO"23��+�X_�*[��H� "� AA����F~>o��������ˇk�����c�X���,ʺ��h�4d"��l��X�3QuM�� ��[Y?_�M&~B>��g�g�~j[M�F|�A�8��{D3�a��&��~�*���ED�g�{m20�=�+��7�r�`݃󋣑��h���r��9n�'����]�w�ɋ�a�T������ _�3m��z6~��� ���d����MF&�谠h9���ȧ����׎�8}��Q�C�G����N���m������0�b�#̎�0��ˈ&�`��&�Zo
�
�Ȍ_�h���ox�ԧ�������O�4���E�Yڦ�>�dD�A����L����'�NJ�SFf��|Zĳ�E�f���8�R��&�c�!v4�d�i�W�o�/�FACM3m��O]�E�>	n+L|��˜�%:G.#�a�q�f���d�J:`{�Ͷ�T��MD4��"�M�09Cn�c>oC�;����m&��O��6���R� �?��7��?JmS{�x;GK�3��0��~-��C�x���Lc*^�y�x�g�'�+=������&�$( ��!�8�=��LT�����o�$��������	���6�=�@�����%^�ʹ~� �[�N���jurp�SFfJ�uwiM�-1b��7*���B"�*����c�2���|m�oT���a�{o
�������s�Y����+���p���A�v��8�o��DZ��4��❗���8�d�hJ��io�"�z����L�@�f 4W&~�[)�ٽQP@�7�*�	��&~�'��n�w�~Nu�;�]��I���)#�!��ژ����}[(n+ө��2���0E0�j����N��	2�|o
��ed�/X@�"n�W䯣�|�r���+x@F4U�#��/w��+�b��[~U�h�5��Ǭ�<�u�i�d$�@0mc�"�w���ȇ6�ʏ��qU�*H �F����.uհG4C�L�����������C�7p��J�V�J�-�ӹ^��V���a����y{��F���O�	��g:��J�5�i��Ь�u�6L��|85m�',&[ܚ���
�ZӓB�������5�]�7�F��P�WEmzM�C׈&Z?��IT���g�O���N��6�cXe��(���w����|)����k�����y|a�g������p���T~�
=je`2����D������5�	�4p�g�w䫯�-с_K��=�=)q�W'�? ��Q?����$Jt#��&~��č��_���vͩ���3Zm3L���h3�k���M����`��Kr`Qr����_��FA@�Ae�G�+_�~ll�#~���y2
x$f��+5�įȇ�P����3�L��:�%����Z�����(�#WZ�)�DD3�aY}n��o{��5eF'"��ABg�����Cɪ)�9>fp�"��$���"2�7�O�``u��,�⨠�2�=�'����_I郓hP)"���H�~dD8�P��Q�����'E$"��QB�h;܉I�Q0ڎ|#� _�M��|�0���9�L�Nן�9�JvU���џ�(�ꞩ�9��(����^#���O~�\���?���8�&� �0���=�K6~�'A�a��~j�m���?߯>�iq��2���P5Pi6C���������~�_V8)r�h�8����b��J�� �����0����Ai�L���m��<�	�V_eD��i������+�(DDӌ�]k�	6~�t�פ�o��|m|�|xo����?��&Q��A�7��5"2�',����~������/J>d���~^#�>��ޅ�O�Ke�օ�"��oG�q����5���3_8G�-��YԔ������0? �6�m������&A����6~���6��i��Ư������%�Z��h�6T"�g{��'�z+�1?�}:
x�e�{�|�ۢV�͚����ȧE?"�Vbm�D�h}7�x�d�MqѪ���\�e�ț�&��T�Ԕ�o�x���5����}��ۆa;�M�y�~
��x+�_�X'�dd���ڕ���N�[5���z&~$>;L�DO��(?�桸�_���d>8���"��0�d/�^�h�f��׈f����0��j�`���&~tȟ�wVS��ED��a�X^<7�����B���������&Q����[&~����6�%uC&�Hm��}�q���N"�	�4�B��ߑ?;Q`�$>Q`�{��8��XL7���"DD�������"{�      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,����^�l�ū����u���B��ݱ}��!�Rt<�Oȟ�	������ӿ[�7��ٮo��r2�8��2��ߍb��5^�z|��0P�O*�z~��0P�O���o�X��Z�=(5|Sf����o���It�R�-V��X�H�)�5�����4o��z|����=�}2������W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6쟴�c��_װ����0P��,��b�U�>��b�ũF|R�����6��DS��)���j�ix�D��6�C���u%��.|bm�\�a�bÖ��VK4�S�Nm�,�0P/�k3�����^�bNU�D���bXq�cuJ���ݖav2ŻM�&��z3��À���ף/l�cu�sS�0P�sZ���9��1ba����X����cϺ5�)�H���A�7�������^鎭Ͷ��NѰ:M�����*~cb:�&њ�Ś�N�u�[^,b``�S����n��au�qX?���`��vzkv�����B{����O
3"(����~UC�ק������t`��Ϙ��.ad��J�4��'�@��n�͜�VM"�8�[��n�u[.�7���z0�ԛ%���ߺ��Y:H�ǫӋ��Yt�v�js��۲nW�0�C�\�ځU�/3;3l����p�>���t.�/�Ev��]�1>4�m�b�u��Sk3�"çV�F8��X����0F�k콞3�eo�{��^��ᘖ�t`�V3�t,W���r�����L��Z>�~lڼg2�R��}DZc���J�e�Y�����0P�حi��ԝ%z3���4����<�%.�=Y�7+��V��½�)N>1�6b>Q��q�s<c5~��fɍ�a�fqҥzH���0���"�V��ܰJ�0���f���i�4�қ�5�0Tu��ͯ�a���6s�h��|�a	��:%k3H7�R����Jk�<��@����f. 0�K��z	.�_�as�W�8���>o9<�B�a�@M�J1wCs����彩a贈c2_K�i`�T�7J��C��8%K���ڰ��V5���X�:����9����U�~����s�;-�OT���00O��~��!��}iê�_�"����)B��{�bX�����9gXeNM�3�%M500���!ön��O�5[�{c���W���BX<���W>�֬P�w��ŋ#�ARjN\Wu`���p�A��1T%��ԉ^WOg �%đͧ���$ő5��J�hq٪������KD�Z[���^���v�+��ڎ��00�9J�a������.�����~k�V��0P�%�(g5	ð�3��<)+n:�*qeE��M�qC./�M�l��S��^�:�{a�0�Hj��5}30P��d��>M����!{�BXlZ�jO�AX���Y��pd�E�$�^C�n'��}o�i]W�0M�;��I|�=�Peĵ��b��){q)��Hγj1�n]�40�#Rk�D1�]1��9({�3�R܉������K:p`Ps��Al��6Q��
�\��Ƒ�Nw�3�0�'�;����nf�R���;�fn��� �0�%e���"?�+���!d��{5�$(wm6�C��`b��.�P���Ln��f��D��KP�d����`r��jow&=��N\L0���u�ګ��p����RNr�?{P0��P#D��2����Wi)��
%8���� ��YS�5?a��� E#���]~60L�ŮI��&�4�a�E
P^�#�m���[C:ƚ�z8}��0tzIɥ.����r�i)��[�խ��\q�a�ju$��j|i=�e4�(��������}	���O/qj-^�i`�)hv!t��%·�n�j1��۽�e��BP(A�#��3���z}v:M��ʆa�qR5�g�9��[�!%oÆ�W���J�,��AS��j�Mm�����N��|��������z*#�|y�a��ip�b�.�0Pi�Yo�z5TZy֛9��0�9�Q�z��#V2E��a�M��?��Yg�}bmV(�y�Ek�T�{,,���}������6��J���\��o4��H��5�600E�U[�	>m�G@�?����[٠������t5#�n��%h�J��B�ټ�i��V�o�a�Շӭ�25��J-K�b��W�^��A�D��Y0˺�����Բ���*$j2L�7y˙C���K��׮�2wR�%Zى~��~�!�&�.T3�(;k)�<_�S0/��*k�-9�k�z���p�l[M��*���5uk͋���z�ץzU��k�̣a�JMe�(�����Z��j%5��ن�*�/���1`)�e2��G<k�DG6�;�dB�[�K���ֺ�AR��IԽ��jPe��FԘ��1�� ^�E��*}��9�.'�Bq��	v�����#���7'� 3��$��8*�Tv��eG���ʳ����s�u�^"����{���!�7��z�%��5��')�l�~�0�1J�,yH��)G\�k���ʛ�� '2�n���1�K�/<_ok�S��%��%��RR��19���î��=�r�a�f���W*-	�ͼz�[��Dr@�^rU�~m���'�a�6�_D�z��o�ٌ�����L�ڝ~ ��!�Q1�6�6�7T�(S�\�vo��sf�ᆁY��%��1Lu���+��~��H��V��Pf~8�N��E(�-�t�a��5��PÛZ?�'=[��čг/���;#�[�(��gi{<�6ܞ99j��鯘�7se�A����ݐç�($���DL�@U��j3�ky�*sT텔�ֽ�ͨ�ᢠ~6u!��?��91T���6��3T��&�d�g����ڞHQ*���˿K0�U�z�.��ϫ?�C.�c����j�k����Ϧ������#1#y��A<Jg�nı�D!1̩$
7T�2-��^���K�L���]ʙ���H��=��`�z��M�P��擏���;/w���-�f�$2ےDgu/k�S����L�$:R%a�C�R5,M@!g���~DqR��A�P1���0P�p1y����a���+��2膡�"�6s�cأ"�#~l$���0P��s!BC���l�k!�S���XW�c~��k�����{�� 4��W�:0d�ӧp�����0���o��7��6�%�2�|�]E�$�B�\U����P���5 U�V�k*�5��n����rf������R��5�e%���㶍a`�'=ɛ�a`��pM�Y�0P��`��3-;�'����A2��G�^�����d*����q��)�Z�K,S	e�/�2B�Z��̼+gqI7�>��f��@�+jͼ�ԫ|��s��;���Ƨ��|c�E����S�M��H���k��.W�3I�Oo�,�i��7f̼^n�]2�w��w��*���V����%���K7�aE������0L?�QoE:�'������:�eٻ��~���hk���@���A���F?��py��
��r���U�$��ʭ�[(7�XU��&�0p���@a��5��K_���J�kx$�̮�b���L��/f�L?��5�"��V�55�]2#a��L��zl2O�<��d��d�:_3��ǔz���TUi�����0P��g5	jt��5k��k��k��)�;c/���)jY"�_�^95�=c�����j���F��0�Ms�۫��9�����P��^��QQ��/Ԥ��j��@͊Zp:�0P��N�煁��<f�!�uU2f����@=5uz�ꥩ�M���Il��6�:��;�f�a���%s��f�ݛ�a`fɌ��,��VK2�]2�!��aH�?q���<%3���u9�q�V�Y�a9�(�����0y������-�n������ 
   �?����G;      �   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      �   �  x�}�Q�,)E�_��7��i����:�+�U��7�u�ۀ�R���������#mhzP&/1.��2h%�kH��FzR	�d��A�T�{H�\�N"СF��.��۪R������&������W-�'PX@6�L^zv*��C���-i�)��يV_q����~_��u~�z���*6�'�X	ڐ��d�-P-4��QR	&s�>m�`p����34E!�s��u�������z2x���H}��a2X���J���YH�l�[S�Ձ�_v�_���E��"i=X�h)�ɐ4�P�(�fin7����0n�}7��4�	�͐�Y��$�6�����;T��8s�[��!��[�2زZ�`��7��!�&�Zk��p��m�\ l�|;�@0�7ˡ��;��R��!�V�k���d8XHdĨ�CO�A������|w��C0Ȳ���J�����tC�*�em�+��B"cR�Ǥ�m�@�  uh���`�%r̸ђ�ɐ495ܘ�`�,��  ��5�0�(��ﾁ�A�B��R�ne���CJW���a2�C#uhQ=�� 9�sɍ���ho��gȂ!$�E}L�G�`�u�ZD`s�d׮+�)�$�r�!��T�iܶ�� Hu�ƭ5nA��mo��� �@�F#K:�q7� ���uߢ7C{�U�{k���KnL��f�2M�4��<��9�G���x�{Y��i�DP�`9�_(��y8���fȁ%}�o7s�6�ɏ�y�e.�B�2�<�
�3<�3��
���`(���}0�ˡ��0�K!���:���~0x`I���*��M������A�
7<p����G�Q�6�^��u�C��uׁ{h$��Ha�퇋4��g%��wey(z0$�<���T�iܖ�f)uke��4�a���Cj$�����p#�(����aI�r�?<��N����HH9�n��J5r`�$��҃A���il����VauPҭ�j�VI�G���%��Qj�� `�����n<)�谶Fō��k�� x���+�o���|e�"�0� �WA{
������ϯݕAЩ�A��V�!+�ं��2u���p,�|g�����������{zeH4����ne�"8fU��]�
>��� hD�&�`\O��?Ż��N3+�s������ʦ�Kqe�.p��NV&��y�^����i      �   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �   �  x���ѕ�(E�Mi {@����:��(^�$2g���lY��/�?W*ׯ/��F���Gj�ڕ,�u�9J#�ܤ���iĤ�LCz.�NqIy�`y�/���d�{�Sy�=rV�IC��@���4i b�FKU�hҐz��7��F�г{�yP֯Eh�t����\�Xu�i�~�6ʭ�LC�(�W����otҐ��M�k
:F'�����6b��	BC����F�#~âq��r��#�������1f�?R��oe��6��rQ��Q���s5?Y��_(�x��"|Q��2E��_�\�B:�4dn��Ff�U�+�U*h���L}N�E��)���������2ų6��T�����
9�v�цr����B��O\�A9�O*��������N2�P�ē���gP\W��b���=U�+S@�oj��9�J��Q|��K�c7��K���-W^=��B1V�RiP�)�X����F�����ݘ&qM��&��!s��+�?��o�����l�j4�{M_��F��q]�|�.��xf8xSU;ŤX���D��@hH'���� Ӑ�I���]h����j���/-w�;'/�*7��O�����MW9DQ���LC�������j��ˠ��B1)��>�B!IgyM'ku���y����ɭ�I
Š���D-�B�~M��"	E��e��	E�9��j@�X��_���	�Q��IE
&K�P=�Z��,Q�{���b��R�N��HJ:��r2���
ws�����8(�e�*�S� I�5
�x�~�}_%
����[�K�F��'�ב��
�LV��J�{��`�b��c��H�ld�ֽE�]�W�����西E�7"��͋ 0�4�Qlv��P�>�2��@�+^˲t��[t��ǈ�l�Q̶Z(_Ŋ�X�)K�Ҕ��NM1�߱�"��T�n�W](�+�Um��F��gU�F�)��RmR�!b[�������ܤ[���D��Z�����q0���@(6�A���M�g��j`6�LC?:0�b�1<M���G5�2�n��l�p�I��P����Ee���W�xŮ�P�遪��^���l]u����N�c����o��m
$}%X(��`��n4N՘b�#�1o]U}��,�=Sc
��6_𠬪m�����lH�!ST��@.�ހ	�����h��e>��W�j�z\4M����,�c
[rf0��[�[���ӳ��ǲP������/	ųF״�ZgjLq��㭩����bx8ɫ��գ
����;p۪.�zN�o+	E���b��xV($�>I�.�E4_*�xY�e�g�F�~S���u+�QȌ!iNϖio���jWM���j��K��%^��'iی�Q���F�i8�����B��,iKr�H���-���\d唹n���irY�e���?!�� ��!�      �      x������ � �      �      x��]ˎ�8�]��B�A�%�zX�Ѷ�VX��zdTj9@���撔dJ<���Ȱx�ѥ.�I��i|^�3��^�3���J>��$p�zy�U;��?���3�$Nď8��O�ivL�k�,9f������_���������O��ߒ,g'�ԑlƞ���W]����Ev2:U��f���̓$	�5Y?Ɂ����>��'�9k�~F�kr�:���Ap����{��XE��40>�ٙ�|�h�� Oq��f�������to�:��9���<k��Q?���rb�!KzL`�0d)W*ӵ�$�g�4ߓL.2�l�lyL�QĀ�<f1�?�l�dì�i�[0G<>
� �ol���%��&:���h�)�f���~ ��K)������}����k� a��'�IÐ�`}S?H	��b�{��==������8��@wY��St���9T��=�%�IDI�QjQr��y��~�G����9�{��oZA����=ɋ|��A��
@�a�g�UT�q�U��=�q�)�q��4<�S�q�
����ew��:�UM�G۴�o��ɦw�ǩ�Z(~�"�K�v�[8?�=)I�|�P?��(H���>^]���ng���G"��J�c
DM��@!���|��U��˳�ކ��LGK���eOh�uc����鏤��9IV�wCrr(���N�?���ͷj)��f�RÀ����_��1�^U�Ǟ!,h�Ұ�E>L�Z�=x2u{o�B�4ðuˎ\�&r�H�8 %��q1n�[������X�W�M~L�m�u~w�&_�z��ʊ���J'�J�1"�J�a��wϝ�J>��c�E��R�m&���;�s�xZ2�C�>�u=	�A9w���e#/�b���̦��I�H�j��ҲswZ�m	�L�3��p�ag���P����r�)JMй��}H\�5#.���3�_��f�z�ɐ��)6��I�'����tkS_�Ƶ���k�v�{�#? ��ӽ����Z��ҸP���g�Ԩ�8N&�p~��0u�u�[r"�e���\gB�،����KF��DC��i��M���� n�SB�mZ�>�R����M�#�<���+<��X�LF�r��* i�C@.R�By��\Z��/�epdޫ�r]=6��љ�`t������j.ŃV[}���xÔ��I�V�^�ύ���o�����l���c�6I}f=���z~W��/�)ol�m: ���,��E�̃���ǫm����$P]"u�8[��e���j���3Y�oA�p����:xҚ��f؄N����L۰X�!�:�ٔ�(���ÄM��1S�j3��q{��e,,c�e�V��qᵯ@�8.z�Z>)�VTu�#ʢGìKC�MN��q�Ԉܒ��Mߐ���3I��o�e*^���+�0[�f��ʉ��xg�u��'/�1�x��ת�k���W��q�m�M��T����歬_�D����~��I0�w&�	6 ��S;��&�0��H�Y�|+D��+[�����.��h������\��aG�ێ�T��R}9_�t'����aq�UU�w�����5/�qHb3װt'����J�Te�~N;ҥ�?)h�<Ai������
���$l�e�(���_!��L'��tb����A�q��-�k���W������.��7�NOg(��|�I���N~Q�}+�����<
:�9O���r E��"庩�[�b;o%^jK�Z�k�^d���K���@J]�S��3=�%/���Yp��+24j>�p1)�P��suR�4�1��!O�����KԷ�ņ��G������pJ��	��UO,��QbMPX�Tya����Y%3� {�j����+O�(.�O�1���q)���A��v�pyT5j^�L�5͒��1J�3F��sKt�*�2��O�Hl�<�s��/�!�c����8�3b;=c�̓�Eh�a�:���$J�T������d�����:�]��S9��X0����ہ�U�b_�=߬�0\�M|�,��r���Z���*����N��ҕP���J?�e8Z�/�ޑA����CM��!!��>mR0S��fZG]��Uݼ`w�xiuU�ʫ���,�V�VkJHQ���HR���`{��ay�Vɣ���[?�k�<�=~�O;iL�E�l;���g�^��B3�͚�漼<����-�T�y�/��fQ*"���=�n͈�`i��"���5�w01�\�e�<F�BO7'�)=Й"i�긱���#�Գ|˳xQƚ�!�Q6Cy��c�0+���4���%���`�o`ȗ��ۻ��uk��CC.a���O5��V����L��S��F�)�l��aȔ�i6��*�w׻�a;�xC��%7��Ev�3�������u�
�PP� 4�h��ֽ ;xv��L�ct�����a�;��7Q��$��g�uR��`��4i�Ϥ�ʸ���f�B_�ȽP`��*���8mr��F�r.������5]��յ�|�.H������R�H
�Dԟu��Z3u9��5�l��=NA�m���H٣�IK>��U%c���u�2�̂a_�Q���h|��}�L#؇�m6�
֐I�y��J��,���!�a�7s�U#�$���L崑m����vQ�i`�!dF�θOJݻF��4���߮��K��)����[�1�6w؜IY3��ނ������d`�0a;���������K�ߣ���w���܍ ��h�EJ�V�i�ɮ&�6�7w���f�,ku���l�Z˕���(����v��9���wo���^��b���zn�(�P�Ue����-��E�UmY5���Y˙B{�{_���F��9� f#�C쐘`�;��n�F�j'�:��h�p��ô��4�NM�����v�����l5��pĤ�qe�`Pt�.-0dN����=p��9`��]84j]�Af�v�!3g��F�k̄�?!���ߓ��Ϫ���.�ud$6����˓9�� u�y�ng�u�=ڕO��if�֭.�qo�v�|�}�I��}Y�0W��U������><�;J ��zx����Vˡ��6h!R��()ne��}4�N��	�)��ɊiJ7m�sG?3,[�-5��3���z�8w-�� ��5ߣ�e�z�q�h�B��,�/���0�10���������y�n��n١Z���pWw���#���V�V�($��Y���p.=��6��EB������S���L��[�;��i��7���`��Kތ(�Ɵ֊��ġ�2��̸�]�UeI�i��PŽBe�oH$���y�!k��J����G�$K<�H
���>+s֍R���	��|�@	���w�v��W�A��+F<�Z���jÆ^�[5l&ptvs^e�q��M����۴���öR	p6f�߆�z���i�v�w�"���`�㞦03�x��u��"�L���y�ج'���&_���l��b�N�HA������2Cw7#,�[��Cޔ�Ջlxd��S�f�2g���w�/�"R�\z��;�)z���̄�#S%��L���K4A�].,�/�/�2�},���|��2<��lv5�@;{d�x�[�l������b�x) gM��A㣯U<?�w�����o�qB�?��O�����\`xL�33u=�Ί��<Fr�d�E��/}?qzl��b�CYŦ?� ����lX[`țm8LF�������F�IΆ�q2V�R_I� ��Z�,]r�^�Poe5XPV�,y�l �\(w��\���*���[�xW]Qۀ�",��.;�k��`(qɦ��e�!��@x����H��w�v�R��Av<w&|sg	����iu�w����|��4(�@B8B��k僃��� ���]�r�yFM��.��5^�4^do�or�2��Q��Lꘝ�g�b=�|��C� ��zΞ$������\�śuc�	�C�r��xUtw�)��-��0eF�>��0��`c��Lڭ{L ���	�iz�����< ���Y+CV`{o�   �!��7Q`���@� � #�it[����L^x�́�*�#U�cN�@(���튈Cq��E����+)���僃�ة�e���X�,S�����η�g�>ˁ�9W�Jc�Gui������ XI7����-8'R�>%:�V�Kn�l�:�?���ܪ�a���7�rso�2������1ځ����rv\�T#õ!�sA�T����N����0d 3@�p?���qe2��d�p�P��h.r�����͙'�@�;���Bm�W�OM%�7]h�4l��g�7Ð-7����'�}~,��8� �L�"q�Qj����zY|�x7���3�2�Vi0ݑ���N�9L�%����D���"Q��ڮ�����+[/�㝧���ꕛ�a�QX��5ެ#ss�5U���j3�VS���YJ�yՆbz�;M�;M�w��$�޶aO�©�&65�D�R��H5Z��M����s�����v��s�a�V��b�3ѳ]ĵah�
����3h�r\�3�*9� }���G�7�C���c:����NΏ O��ieÐ�����ɷۃ����n�l��Z�a[�7�Ml�Ì��c��O���3â�{�l9����>�lI�)�3��j;�2ǥ�l�Y��<z���<��y6�cg�y��Z/�u��Xs�s��_qK�-�,����� ,O�O���{b{�=O�W	���\�����^h!L�����S�K��
r�{��}Tǆq\Cq����Wy�X��kR�l�nji�2��jC���y\��V�N6�N��"�0����D�2W�@~ˡ+�q�<���%�C�H�}hfu�����[7�φ�B���������m]s넫*��@F�y�]����rT:��Lf�ޭ5�m��7���	[N7����F���/������ �sO����R�ZN3)��# �$��.�#zU�G�Vi�MZa������Rz��o�V0@]f����r�7�52(_�]��a�d���KT�``�ok	[04/1�~���n���uȠ���l�<�j�~m<m(�Zl'�-���=�fh�{��;�2C���K�E��Af���B�ư���f��"R���?�^j��#=Iow��A�`�Dm\|��{��GKE��:I��=��֕��ޫ zYa���c���}����LJ�����]C~'�>�"��|s
��'��"�*�����̗p��1��c�Pq]�lC�,��v��4���5_g�ĩ|����P9�*=3;������o����3"�.      �     x��[ۙ�:~ީb�|t/b+���8l[(�$�*F�����?��-��r����|A�L��Sǲ\$YN����\�/��4��ܡ-ט�< �	)	= I����$aIR:�rm����G�GYcXS;�����g��s9��))t���5&�H��e]��)C�u��$x%�[�o��=����1� f&)�i��Z�Ag���P��r;'}t�=��9��
"N���1�+�����V�m��T� ϧ�!���f�x�l
��� g�~��������U��`���7pJ�cxw��޾����Ap?!{o�����m^�W
&`��/�+F�@���[
��� z� zy�O�A�� y�zr�$����78'�-%odK^E�^E*^)d/��M���^)���\��\��\�zP�zP�zP�7�^1V�5j�Hs����U&��zS��(�i� ;SǹB�QqBq����N�:��
U���{E�h�
���:Ԏ�oL��`G�`0�4/���:HY�a�
�+,u^�,��$H���/3R�`�@�g���

�@�WT�X���%�s*�EZ�n�c�Aջ�^1�w��"��g��bO����<f9@��%���P��b�JE3>4�VH)�q^-w�2�m�,�5���� !��$E<D�6�����,�a�`�/T�5;5�b�/��7UX(��,�`�⡘�j��?J��%��\�����.��l�(�z�IR��%�x����j�����t5��${�I����%�\��m�y�����8.�Q��T-!<����A�;̚��1[7�&I4��e�B���4�/���7%���i�+g���t�Dq�Q#�Q^zT⯂(������~�a��a���s�O)�ƅ��ʪ�]��{Q�T�������5�4D'� �5��6�L~&k��"�58�X�1�ƻE��$^�Ɲ�v�#��m���z�ӕ��i�MY�����������t�ŧ&�1�L�'����[6oUؼOhΊ��9gE��Yap2��*����S��@A����N���@�6��LDo�Uw��ə�"��UF����&�O�ދ\C�ܪI)�ڲ�YmOT�i��ýST��Bu� COs�Ma�8�NMרa�S�b�$�'^��6���N2z��-��.�v:������,�^�6�;2��b/�5>�+no�-8�^�ku��g��4o�@���p��!) ���	2�5��}VKS�2�Bck��Z'o6H�E� G��{�=+��ɮ$t)|�S�ۤf͛����f�oo�#9�!��/�|�ל\�v�P��� ����js;�
,��	��]���4Q:�s:�մ����UY@���r5~��/����;ڪ�hh8�c��yF��$윀�X�@��C�Y �6Ki0~7��q]�:ف��٦C�����nԵ�l�t�t�������qڢ�#�t��=�z�͚��~Qm�T6s��H�� *$�g~�1�|5e	����*�#�;ꢴ>6,������^aVu�˴K�=:�k6���:�I��`�ޗ�Xn �EM���R1�}��r���1X��1n�zJ2�)[tt���h�~�x1.z�i�Su�&;�Ѝ��}&_��7�3�ǰ���H�XfG9k��bG�n �m͋	�du_B㵎~iB�IOHg9��p��l��G������|��g����3#��ۓj�cё��I���]�KÇ6��A|՟�
%m����s���sW����~������|�      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   �  x�}�]��(��˧��a�����ϱ)ٔ������od���>�~�������Y˹��ϿL�F�@>(��m�sO������[������[�A ��q�Y3T�F�Hv����<�����C�g&�d�6�,� *oi�?%y�q�D�A��7o'�]$T��ş4JHA��ӹ&����D^�� *񁷸BeG\y�3�u���8��H�����{a+W� >�[����"Ù
j���d$� ��2�L��wO�A�*!���� H����� *!:�S�E.є��A4�c��c2R�ӧ2�9L�������>���BU|��)�,1D��pB�(��
����dB|��2*���]	�A�A�=&�M�b��TX<T�b.�]���F�Z��M�ħ�4wMA�&��L��S�M�d�����QuB���&� uS�DU� >��f�^X��Y�:T�����3�b��@�`�PyKBz;L�U�� P�~ǩ|*1��5ӧ2D�OS"5h2�#��:	�}�d���vMA*
&ᄀ�������d�(6R&� �%&�`o��^b2!�Ce���� JT2���LK�a� �� :�ѹ�~�`1<ۇe��bΧ�zM�Gr�'c��c��2��z�A��n��ǔA���)�����A�	�2�)��1WS�Ǻ)�@��Dב�utB�8�OĠDe�PyK��\Mh>�����e
Y2e,�5N�S��3����ϔAYy��)��nWS٣��ż�N=e��jj�t7e��j���0�P�a��N��L�yB!�x�"�O�	YMd��2R�0Q��Q�!�0&d����tUm'1O(6�Ce���Ix� ���g����{��b^�ib� H��D}��Gqg5u��n+�ˮM4��1�~�&r�3e$��E�d#>�
�>&oYo�|���p&� ��|�4D&O��,:e�͢���+�A���>U����#�x5eYG��n2?!_�p�:e,�d
�2?_�Iho7y��6�2��5�y�yU-�0n�@��ޕ� 
!�M�,����d��贷�� >�)l*�h��>0����An ���c�[�)��'��n���Gᝡ\�!��DMd�3�����g2R0���)� �[��[.�����"��eb�h2��%ye2��`�+/���"(��y� X%�!OD���p�<e,���!W<X+z!T޲�Vz*2�`
�SA΃z���qX<��#�8�.����Թ� ���Ȧ��C?R�"�-���l`��-Lz�N��diɫ�3j��G�=!zQ��=2�≮&w��� $U|^=2�J�ß��A����A4B����ew�2�o�����A$B?<2���3.�a���ݰ\�zJ&�� �<U�#{d����G�~t���q� ����#��d��c\������#o��q)��""�L�e9�#��<2�ס_�C��2!>���D%D8�>2���t�[�qp����H�bb���<R��h�M�G�j���,z��S�}��"�E�5y�ҮV�2���\�Sk{�� �#�΢_"�U0���_=Ѵ�k/��m�eɫ�?��}'z�h.obX��D��W_��u[��AtB��d����ٿ�����>u�+/K�*�e�x�S'�c=�(q�e��>n����I?t,���A,����]	▱��r[�{.y�ÈBV.˷�/Q�f;w�Df>���;��L|��>��K����l_��Kh�����I�EX�J��~ɑ˫c�k_D��12%
[���D�U���ϊ@�;*.D���ɲ�!���m=<a��Ӿ����C����&����7w�}���߲�� ^�X�GӍ"gB� � >�eN|���۫_�,wd��&�����g����uK���E_D�Y�<�w��H�k����n|w��������]����wQ:����V�K\]���v�:S��U0�F�w	Y�a-�G��<!w��>(�y�7�J`H�/ӻ>D"��K�E�)�^�"c��c,����f[�Q�\dB��>�� *!֊ZdT�x�4��{�Tb�6��c�D'D[��E�(���v��;���o��o:~4q�UP�>&kL�z���۟�m�ߴW�      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      �   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      �   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      �   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      �      x������ � �      �      x������ � �      �   	  x�-�Y��J
�o-�O�i/o��ha��
� �R����7���������=�_�.�e����֠�]�$�]�.k��e�C0��87�n�]�v�۵n׺]k|��_kv۷��Z�{]ov�σ�~��Eo��p�w��7H�q���l�Y�Y�Y�Y�Y��n��v�z�Z����z����ǹ���k|��n^���S^�g��5~��Y�g#?k�`��r�������5+)���?�_�����B���d�L8�ͻ���ԛ{�Q� 5PA��"�Ej�쑡"EE���O��\�*Ud�HUy�d�HY��=	+2V��"qE��+RV�U�Y+�V��H_��"wE���񢘋j.ʹ�碖�b�/j�.�/ʺ�䢔��*��(�2E�����/j���;H1��M�ij��&�l�����R~�}7^n/��GK�;����\^4q�>�yƋ�O�O�N�N7:u�t�t�t�>w���r}�v�2�e��`��n����r�6�m��(�Q�{~׾{��1�c��������Qwx�a~?/�%^��x9��^./���Q�(e�"��z��DFadđHF$�qlǱǆ;rlɱ'�ˣ壥ō�Fq��Q�(�������{��uh6{ѯ?���x��3�~�����j�l�ܿ���{���������ƅ�@b~�?�_�z�E�
�Mɛ|��D�6�m�� ��r�\�Vq�� ��%G�7@o�^�OӇ��Q�$}�>Ƿ�,B;a�"`F�fb�"�E(�L��V��(1J���Fi��Q��i��Q�(���v�1���w��C-�رG�(�׫`z5J�F��(��W����ҤW��J�^9�+@�^��e�^��e�^��������%�^�nعa熝.n���bA^��.n���↋.nذaÆ6lذaÆ6lذi��U�V�G�h��)�w���b������Z�xq��=�{��!�C�������������x�Rr��/�j�BHCn,�FHG"�{Gp>�Cp>�Cp>�CT>D�CT>�C >���>�D��,�ϻ17�ps]���`�szS
]Ê%�ДB7�{_y4�?cH^xMr�T4�hS��-��nлA��$oмA��doнA���oоA���oпA $p��H_��"}E����p��Q�F��nT�Q�F�oԺQEEUTT�Q�F��nT�Q�F�oT�Q�F�i6�l��H��f#�F���7�ߨ~����7
਀��8�ਂ��:8
ᨄ��Z8�ᨆ��z8
⨈�$��8�⨊�,��8
㨌�4��8�㨎�<��8
䨐�D�9�䨒#�Gj���=�{���������uii3Xg��b��+�㳼���u�,�Y�3?2~������#�Gڏ�	>2y�jo���[��Vv+qU�
�%M�K��A��0jxj�jU��V]jA���cY�����Xֱ�cY�'�:�u,�XJ������+*VT��X1��b$_޵�lѢ�b�6m6�l��h��k�ҖK�����
-8��ЂC-8����ar��	��|>�l���[0l���[0l���[0l���[0l���[�Ŭ�sbJ̈	1�^.x��傗^�/N���N������7�|��QI������?Ue��	_��ɸ	W�cɀ���]��eNIX��`9X��`X�5`	X����|�h�5-���"�R�k�m���L���������]^�t��G�D��G��s�ϱ?���s�ϱ?���oD��Gğ�(��#⏈?"���s�lt�ǧ	t3��:$� Q�:H�A
*h��$Ρ�`� 56���Fm���s ��< ��<Purl5��QŸ���s�Mꊳ��f=��:�k�u�})
Q����ug�Yub��<Ϻ{+�{���(�|���W���1@rp��ȱ�S#�FΌ91r`��q��"�EΊ9)rP��1�S"�DΈ9!r@�|���!�CΆ9r0�\ȱ��PȮs$�Dȁ�� �ѡ�3!GBN�9r�4�a�� GAN�9���2GBN�9r�4�a��y���=�{���1�S��x���=�{������ӻ�w���=�{p����S��v�J�����c;\4p��E\4p��E\4p��E�(��B��'��wh'؉u@@	x�p'�	vb�P'�	m"��&�	k���&�9�pH���
�'<�
zb�gS���L=�z.}� ��?X���+�\�*��������Lڡ      �   �   x����j�0������H�ς��P��]�6/$��~m��·|GG��~��b�t6����q �B�b��o+i�r���r˝V0k�u��ڥ��S�k.Z.�ˍ��ױ�uּd�v�$>�?K�u���r�E�&a�-��T��t��ңj1 �;����rџ��`���!%�
��\���R���x �;����      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �     x����j�@��w�B/ �3���޶�0��uK (�]�!��ځ�}'�-]�u�t����?+�n��i����ݝ�O����y�ps~�Ո5IE>��/:	Ҋ#@r�����������v��!�Ū��c��B��D��4��?��m�[��eq��đ�u\ jqԎ�j�?�a�y|�.�?�n�FL���P<���,`����-�����>U�L?i`|�}�tL�tB���.�(<�%j�l8���m��t8<�՗��B�j	B?U� ~�6��T����R���SMm�]�����i,:C���+Vj�*l"a�f�
��v@�ｱȟ�	Q
&��-qڥ�!N�28�w8�j\q��<S��s�.����-ОJ WWEQ���麔;�s)u��@˻�!N��r�1�k���#��E���.@�%[���-P��.%z����b�B��\6���գ���i��G,�x�y����Ê5����Wo�?�]f���C��
E���]�H��^{�7!Q�}Yq���m���SK���%�� �U���      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
�+�����dm�f�Ƌiu���0�7>[��Rv��ȝ��F�X̢<X�ݐ2�U_��'�:/2J�ؐ�Yv�7��g5RԒ�2�𧊍�K�E�	~u(c��$ii<��txv��_�M���3rQ���ڼgd=x�E~)�eV��T%.�"F�nq�� �����>���NuQ�~Щ�@�ui�Ϋ<\�(P�M+F�<%�;Q��ѝ�A�*)�;P����<��8�#^�C_��m���M��L˭��*qϒO�^�Q�����ek���!LB���Lr'��o�\��[���e����g�"Q5�|�?E?RɄY*���=�((�b�n����/�n]��%O�((�Y�ҷE��s��u���2�{���V�_eg�m�n[�5�7��H�P��SgVb{�N�x��F���-��hI�����T� ���Z6o�!(q/��� aƛ�q��v�bꋖ�ѷ�����h}�ξ�oV�&Os��\e�<d��u{7yP��������>��I<� �_��[�5�2#�K2��lO��$�MNF��y���J>`������C#��F��u������c7�    ����kB;E<&/��ŬE���<^�<�p���ֶ��+��'ޑ�Z�Y]f�=`nQ�5<Z����B:|8�RW�/-��e�/�py�V�^�F�o��Ey������f{h��ڎ��(/S��[�@�:ou��>��&*m�?�ja��1~<�"%�0[�e�yxH�tܙ^�\6�o�����Mf��lN�fDL�!�ʹ�;#n�.�r��^8$'?9�$ٗŚ����
��ZW����!wK����v��Y"���!�ヷ�!w��k�Q�*&Ӵ�:�!�_��S�MY6�y�r,��"� �sN�����y'
��\�Y{H��Ѻ.�]R��ڳ�M=��n!�0�mxH�~7�~�����u���ͦ���-Ɔ�m�Cn�H1=����/�|jޘ1�o�ԛ_���Ha�#��0y����&�31����#�ʻ�/.:[>3oL	��_������sD�8!��}왞��̩�Q��ŁBS��S��}�3`���ኼcrxj�X�5m��r^�s�t��0���OLÁ������㼌疂�A.j����u�.�ц����Z�l�����W���+ ȵ�����Fk��쥲ar���Ӱ��ڑ�f�k_�S�_��8Jn�u��6�н�2�z�=`:��{ke]x����c�������&e��L��D�}t��zn��Gʴ����9�=��W	�冔���H^��<"��RE��Z�����tF�uL�R���k��U#�F�R�j�I����FB-��Ѽ<�I/q�Ԁ�c,됛ދ�0gi3Qm����6L�E̲����m��P�w����{L[n��I��,1l�K��xLj�g�c5d�L��a�K�,1Ä˨�v\J����4���\�o��4��%@��;�����`����)G�훒�@h���ؔn��%�Q�����Fq�_\�g�eD�)��6�d�i�l;���މz�-�2R!����ib��+aF��B�U�p��o-3q]Y[r��#>p֍<Q'�7{3�!�Z��8l�[C5t	�#�D���Z���^��݉��˖��`��Ð͖#��(����W�A�:?x~d�/
nG��i~d�b��D���Zj|�l-���w�}j�W@��~�}�旅n�ȡ��~ݲr�~�{��1Z��k��q��=T��~�^�n�SO�C�o��5�~��%G��0vz�����"��������#�"����M:��m]U�o��|���lVtY�r~$��;-ON����ѭ�|�*[� o
��@��6����#>+{�5���؎�A'��3�GZ�_�䃿T�H���HFi6~t���0i0/>��[��9�}�%��t���s�2XTR%��U��Ҭw���צ<�606\y�PvU�!��5��3�?�a�@�ܴu�1o{fQ�F���J
�^0�\���/�H$	����W^�����0�<;oyh�x�ͦ��^�Å�(Oƭm�&�9�C5wb�F�R]��������`A����;Qf�e{1i)}ܓ�-�ԛc3Q/��N��dl�iP߫@5�㜍�mv�N�^A-�CζkܭM%a}&�0�_��'�r�\��T�h�)�dZ�F~O���s6��i��*��ɼ/���G��������F�O�N2�fB;ޟ������V$G�p��L�m�J j�%�͈�An{��	�ͦS��t�%?�ҁ�k�#k��^P�42�����}�	���}���[`��L*�7L��)��fa�Փ�1���,g͊~�PZ�<i�Xb���ܺ����Z���#f�׵�wL�}�6�u�s�'̄��|ޤ02�pʱ�1!N��O�I���C�U|�QV~g�I�I1�e�ɏ���A�u��͐w�M#Vf£�� qZT4iF���*c�Qy<�4b�:�׵S7L�2�L/��E���ě\#�]�7�P�|�����O��qe"�|����'˾8}.BOޟ�.�(���ȩ��{
AH]F��x�[�ȥ���W�P.�99�n���k.{��
��f���J���X�{���+�o�f�A'(�� Ģ�m�[�&�6x~���Ut�~/yO��1ר�Z������ K�\*u��d=�yL3iι�>�M9A�3Ћ�n��t���Ck���b{7�'q�t�AnO���^"����k�>x~����S�n����iv���16r��Eۏ�?�f��m�x����򾼟�9@;O}U1!'��
��p4��܏S�(����)�	>PF!H��)�q�@�����H��g�@��	B�}����0cv��fUңmz14�i6�yTr=�4<	�Wy�?��1�[
<�\B���/�˵o�4yg^4�A�r�5�Qҡ6���\}_�o����0*���0�?M|�W�sk�����F�?@�R�}DY�@�Ei��3ڽ���	���+h?gf��G
(lmј�북���x��"�uo�[dD�֐{�2�?%��wҀ!�H+e���zS⫹̕��5u����C���^ζ4�K��K�Y�pOޡ7�"f��v�&����c9v����t{K�ȫl^��������M�|��=D���h�r֓K^�q��څ���˃��T`�tw�|O��r��s��3i�n��ɩR�C6.�f>�@��kyX�7�.��s�<�6��*j����&�my7���5�9�~��M����{�h��0�=e=K!��a����Q��?�o��\�DY{�;�
E�Ҿ��k��<��ʬ3���]q��d}�C�d�#�3(^׭���n�
m��9B��_��� ��O����j���gF��U�=���D��'E�M�.�22h�?Bq?<W��ku������_�
��1��X��6�/-ŉ&������QC�R���SPC����>���C�4��n1(w�4�O�Vh�N+�OK�NZk�G��_�Z�0d���1�c�f��U.̴�[(�WLy~�7Q�	Κ+���e{7�
��0S�y�$~H�bPߋ�Ĺ\gx�� ����8�w�t����w�U�� ��e��s�(Չ;QT��S~��e�[��web��~S��YgL�u��S�W��W�Z}�5ۨ�s��B\)_�~p�j��њ5j7����M�vZ�(�.�^��8w�(��p��ۑ�:/N!V\�6;�ژ������U��IF˯�`�� 02���a��r�0���^	��U�8iaz)Aa����u�a�p���ilkFk�Z���
�0��e��>��̘^ׯ���nL�G��1#�&hb8aٞ&��6���|�{^�9K�؇���@~H
��D�����eh�0��2,a�Vk�������!)xK��KSCyS�Ke�ܗ�c�Hw�z�;�n���>��{]YRͭ9<�Y`���0���'/�,�m���,�>P�����H^7�oԑ���_��&����+�ި�H'K*V?g��Ƥ˦=���)F"Ɗ2�����Ip�� ��B-������&�"�{!��`ﺩ�ҋX�t���`�G�����x��)l���%Okgk���:8錋W��kP3a/0ȹJg\���6�3���s>�o�)�����d(�J13`�b�P2���|Rߜ1��N��\Q�.g;I��d�(P�h� ���̦ɢ��~]ǝ$+��+�r�̮�(>7���5P��g.�/>S��{�|��|o�;�75���C}au{8��w�7�D�u]H�'}��`g��A��5l�l?*/��1�J>(�I��װJ�XX�c4��e�e�\��	��z��}SG��-��fk�`��p:#���U���[�&i��u�3�Wr�>`��m�=k:�IK	���D綥49y�t�����O�0��,��%�f�h�tk����A��Kc�M�|�6��0iV[K�3磲������F��A/y-lo��}g���d�
�N�L����ä1�{�<��;�`r�hሙ�co6��a8�s�P�͗J���j�0(��}��~���CA���.��UQ��0�QwY�f�q�-7��g�)�I�    �V'�٭O�O��)]iͥo{M=a-)�rk�������iøS���x�䵝{t����e�Q'��k�I��M6n���R�����Zf���K[���0����0}��0�3�E��W�^}�����c�%}@�璝Z�w�X����zL^���i�D�d)w$�����M��i����ԺO�mJg��m�xo��&�-b��-P7?��zZ)b��]��/��y:N+�5��ke�V�69��9aTQ��n��=bLR�m���t�	�dN�ä�h�m��Z:���ݲq|"|S0`�՜tJ�sᔻ(���N���)��#�7����ɫ??qS�WL�\�3q7�jx���P%��?{�F�C���u�V�`#h����x��/��?����tX��d
ǲ	�>�_�������������������u@�Oӎ�����)9���Lh�g�BE��9�H��G?p���iO�vU/��r��.T8s�{'��N�ڄ��m�gSa8��/�^r����ͦ��n�8�]m��Ё���:G������CPr�'���/!t�c��a�Z���������iI�?��o�9dI�B˯>q�M o�^�� ����@����5��k�=�x-~u��r����u�;�͘�e�����RP�$�G0�����E�a�Z��5��r\D��gv�F�v+Ra��z���tn���誖{0�f�a���ۯ��Pk�D�G#���|U7�G,�h�[O��/#�#�~Bm:2x�B�,/�Z�z��%7��6;��T�	�5Zn���f^���6�Z��m�h]����>�Pp��2Ea^����u����M6�������
!���7��a��Z��8�{խ/���YKz�/y�fּS��ۏ�z�D$^Ѱ��
�'�/�>X5�Gq�8X���h��H6gf����_=q��CO����/�i�a��l��w�������80ct�,?f7������p�z�������6|Q�(�6��>�:D�AUCm�A���Y������#͓���0d��D�+���V
�0V���M��S/�5���
4�����}�Q�F�=&���?
�K�UѠ��B?3��<Qzk�5F�������ld�h��n��p�{ʺ���n�y�O�Z�1�A�hyBs_1y��K+��9�0�u]~7�f��FQM情����D���M텀�/��y��	�]�g�������?��|�z���P���6��c�T�Y��ذR7kZ�7��8L���>����[���6�e����H�T�%zo>��;W��0�\z_q�-ӗ<͈4��F��a�j7m3R�	i0��o�䙾�a'�5�������$M�h� ��0�2�&X)� �R�1��u�҆�C�a#\Sc�OR��}�������.M��Q�b�Ed7�
=�X�o
Nm���H�FJ� (b,տ^�dKv�D�/���I�dS�O�-�bI�?ސFY�H�Z�%�s|q��/͟^M$�M�Wo��kz��H����Y���{.�!��Ԟ�w�^^�2��Qy��L�v=_�]?6Nr1N%*�q\��n?�a�g
�Q���ձΚZ0@�u ���f'P��CZ�Ū$SM�f�}J
�H�w3���yfۏʝڏ�+� �ؽ/--�T����t�)fii��r��2n��kI�˅�YT�td�<&w��7�e&*����_��-�)�������]�ԿPZ��^�S�5
�ij�H!D����o�O�S������ޞ&/w�0Pq����4�F���3�,%~U�%����\�TrpyrK��o�	Y�`ٙ�.rBi�R���տ�t�7%� ���Z�0<n�n7J��)VK�<7�9��%i�[��!���!B�m����ޞ�a�`УIC�������EC��k@�ç?	�`��4�$o�S��KH�Q�@ul/F�t�u_!롡m|�h��9��I�b�B�4��ф����%�K�@hw"27��c	�A��v��=w��3a��ӗ	.���N���jٷ�6~
�>����`�}����6�=e�|���/����*��'�X2�������j�����4�Gо>M/|\�ަ�}������_���3[�YxBʕ�>M�90Ʉk��jy��Q��G���D垹ꔎ��#����r��{�O
T/�xa����7C#�C��W&z�ͼI���^V�0ׄ��fn�$WU�]5M�|F���,ɻ O)c�E�IkGիW]��P�~�)#ե��X�P�����O
T/�g�zɕ����"#M0�X�@��<4���Z��U�P��o�L��DY�}w�j2�6V��}e�vk��v�����{���支E�m�������t&�lk��[�Q��e��W��1EC�v���1Vy�~�_ɥAUZ�0,�Ҭ�a|�Oc�80��_5f���M�a0f��)�����Z-םk��<*"(l9L���K*l'>v�E��?o�;�~��H�:���uAO�]����YLv�k������������#�,^C�@�1f���5U!:a:��d!���eF�Ul��sq���ma�<�{A&1���ס.��^�@�kll�w��R]��Z	+�<�D��%P�y��:U�d�hn~G��a��Q�ϔ_)�'S{��A�����4�������ޫ�����=�ц��ײ��6��UAu��XBʊ��t䲠��)���=J*̬�"e@åIۦȍ�wO0�e@��?̀��B����s�F��}0
jV���)yqF8��z{�Q��u�����G��� �dڦƏ��0��>�Qsx􈱹,���Qs��A���]��������n�n���Cr0qhװb�nU��?TM{����� �ΔZ�Kd�*�pߔ��F�Q���A��^�y7X�g�ǌ�����Sq�hh�Ɗ� Q|�ʅ?0W���oH�f� #�y�7�a��Sfi~>�xH
�(m04�e���a�j�X��Z������>�%��ZSr�!��6�Y��C�)�C�E|uP-��-�|H���002���m���r�aֈ�6���OC��� 
ܪl��4�Y���*�R-"�q3�k�������4Qf�>L�N�>��iɎ|H�=F^���jrbr�td􈙽� 䤘1Ê3��ٷ�;3�M}"%=,��(�1wCޭk_^�a:��p^�mS�Bt�CJ�����X����F�E��B�%wS���Q����%�)V�9A�.�C^0lmA��r�-pΐ�J�'ʺ泿��G&�(��d�;��#,_B��Z���v<�b#Q/�4���]�sy��F<&w��~4�3d��&J��M�#�{��\'3��7�#�{Q�M���鑋pF�)&��^�(��8�G����� O�,yC���*�.ľ�}�"�'C`w�ֹp@0�b�"��殧Bp�<���u�����Ð��^�o=Pg�k�\xi�!��=`X�'��f���(�
��,@�0�&��r�@<��������9�����<O�T�H�6׭@�SL��C�}+��g|�6&n�|�x���R�����}S����M�ͣ8��+q�J���w�ub�<���'��5CB����<�3bL׆1Y�{��e�F���:���!���M���.f��M�@P)%`�X���6�q��9��eV���H[��F�U
�±�Ke0;=�Y�ۖ�}���n����� ���c~����b�a��	�bd�+J__�M/3S Z?��/37�=�#M�a�F�\�*O��L�F���9`���Р�o��r�b�ޔ/ↂ�.�?���ݶ�r]a�0t�)�m:Rdt�.�:�"b�i�^x����Ya���iھ�f1��cgS�}���`��i�16	��͜�#��n��C�4��̈!$���k��u�к�m7A��pĜ�s�<n���Ѐa�<i���g��G
zU��[3/�J��͎�)�;{��k���^����dUS���5^F�0���4�Q�~T��B��xL&�M��Ge��E(Fq�eE�����I�δG]T�5~}�A/o�x~��ŷ1 �   h��;�g�O��7����Qj�cx�4��&U�GM��8P?ؕ���hQSOɪ돔�{�ˇ@�;�D����֢���;
��*��7%s!���l�N����G.D�R��,���qQ�k���%��}tiˬk)�4Ѵ:�l���-ҷ }]n4��q�i`�[�Ae�7�X�<ۥ�u�%xl�A�P����pI�X�<���d��t����>B�[�ϡ�s��+��������j�Z�      �   g   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\f���>�^�ގA!���� u�F�P���� ��FV�#P��b���� ��      �      x�̽[�$9���+�I���/z�̎���2����A����Y@��7<.QN;4�N3�δgN�jy�N'�ǎ�c��������y��k����j�����?����:�ݸk�y�����o//�_~��������}���~���i������_����������ǿ����]�/��K�ߞ���O��Ac�~�{��aw��??�P*K�ޞ�X�f�=��^������\��������O�j�k/�q��V�g����ST�>?��$�3C@��J�A\��Ш��=��zwx||��><}{����x���z{z������p��~�/S6��߿9��3���/}s{6̌U��o����v���oϟ���z��������}\�>6��Ë;z�~���8�d�� ,Ǖ[7������˷e��_�|����������]=]ƽ�2ַg����̻����.��A3̷g"��A3U�_o.��Sߞ�`��9~��[�܏��=�������O���oo������O����"ivu}Er�e�{�"9�Ev�O_�����������<5O_�rx�����ǃ;� ��8+���޽���o/����|�pZ/��E��M{��������﷯������u���_�S5�>��ZA����p�L�6X�6�y���~��%q1�L{�m>�H$N���Ǐ������?w�8�~���rN(��o�/j�tX�q�~|�������_��v��4����p|"d߆��D�v����f��z���3q����3��Nf��=�>��i�|z���OQ���:p�ן�?||h��ZU�[���\e9�z�����f�=_]������|���A�{N}{&�i�awx�[G����=ߑ���#z�|�`�W���7���E�y���c�y?�,�K��Qy0�>�����<�t��]s{a!���zT���8�u�l>0'�Q��rS�ʄ�N�$A\�ɹއ��3l�$r-C �2	`�nq����B�~'V����̯[�k�SKcX����L����3Ii·�a$8 �A��Uߞ����%�����q��bWL�a�b"���*�y�ѻ�����o�S�k����p���:���g".>��]��t��ӛi����G⡕�B�ox"�8@39B!�~v�G�������O2�&=zm�颡�7R9��F�e4�H"dh8�F&ě�p\��P|��׋�1��|s���w�_޿�q�s��?z��d���{(�c�?Ǩx�N�wb����Yo��ÆC0o�N*$��.~�d#�DSc(�|sݓ!����Z��tdC��h�t����׌F~%W�m��Z6�R6�E$;��Q�>����+�*�u4�7*ѓ?�I�,���Y��1�xJ��(�M��8w� �(۽o��ʷ��φpW�%�����M- ����}��N����#ռύQ���s����c�8z\�-��3Ku�Cp-��>%Ne�Pm=����I��m�H���6�J���+C��.TO�r�
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
F^�_X��`2Q�W��BMC��/ ��2̵T� �L<��m��i��]�-`�4O��B�g��W����gڤ��%����`_�kJY^Щ�j�����d�b�%��[(�����2�PN���eKJ�7���f4�^�p&�!�1��rE2Yz&�=��M��<��kU��M��4� ��HhKoL�3I��#��@PhbbH�������38���"��5j2��z+C޷23ԀfX41��,�%��Ac�OZ!�^&��2�=;�P�v�������������޾27�uƮ�=qt�gCY�n�DF^ �\3Bt�jU�ƇG�"12�xb�U�u�;U����^���Â�������K��?�_}���Y3o�y�a�Z� �B�t ������ )'��\S��y��T�b�4T�v�y*�Z�l��[�1�V���#���5X��ֆ���M��(��Я��+~�C��)���C�%����0�� n����f�,��# )�w�8�EFm�lb�xC��Isn� �O񨭴|����F�r�iv�����q�>�_�X>}}=��y���e�^~i��3qr�bH=�w8�B�=��ޗ в�����%E��/Ѽ&-6���lؽ�_~Z������zؿ��ƻ���s���é�z��a�g\��6m0Cㄵz��p�^�����ܪ׭&I�惘wv��tNT�~;�K�����.,���睷M�̥)�,tK���>=�>���8��h^%`���t��{zhE���D�ct�^��v=@U�1�>Q��<#�h�p�r31��eDď ��f�Ci� ���+́_G�=,.\�\�6�(�6 �D�9��Tm��!e�� 7LVCB�bP���HZ��Z��A#q�Yd�;ht�7PE:ы�*d�4:S�d���9�`ܭ	��P�P��ڽ<�������Ю�=�G��|� ���ń������M~� ��Il~2B,:��Ƣ����iDL��,.��xɥPBáv��<����OB�8��o�J�9���
��F�/G�X�.cu�V�%����4'���'Q ������dDS�d�����
d���X��F�s��A��	Q��NA�Ӝ���d�:%|?�.��Re�y{�PO���cS���0��1�����:']uOz��kɛ���e�If�uo�-�~1���!GǾ��������2��_�!��]����)N�H�+<��JG��fֆtÅ��],I��:���.����:�k�[�>s7"�m�B�/���tG���UOA��G]2.�ѕ}��~4g�6~��W�e�duu�mL멍�ר��I����(~����G�#׺����;~}�v�z�k�p�䣛��0���k�mp��b�6�\��O�$
Ca��6�Cax?�	Ca�N{��i����F=�>Q�q�(����4/|	���F����!s(0���ǦZ=%=��S���Ɔ����8��	� n�a��p%���!�x�b	I� (cX�;L���ѽ8H!���Je!�_ٙ�7
O�_^�u��c��ggƊy�6%+�\g����	C�of�R��/f����wL�0�%nI b4!{`0�4Rr��:3�4��5is��a�9/Ǜ1p#�L(J�$_"�S�Ǿ!��ٚ�hik�@ԓz�.��F|[�X<LQ����y������'Vf�C��a(c�w'#������+�������X0��*sHy�����p����|��?<<�����������O�	�n�;�/�t��VjuL�}I����1��H���#ؠ9?� ca|F� ��3��P��
z+�V4�F���&{ɯoH�v����7�}R�U%9<g��!{:mt92ycQE��x�6�3~�w�;��mpaA�f������T�:Y1��+�l�	�n�c�4}9r���W���r��$��e��A�~��_�����������O��>�L������������bm���xd�u�z7����-�o��Z	��E��ZA��n��q=�h�&�mH3����s|���g�
��]m�a0lאY�
�NX'�ϰ|���,�����B�0K�l�h%��+�|�HNí�m��W������M�<RP��$mW�    8�%f��L�@zRj}��6:ɸ�1�/�)8���07�pZ��;0����M�0FeLxzO�r�m�Jd�&t꧄�	�E�������Te��_c�1~��Qޞ���z���IGxz��( �ǚ$�=O>�u^�vU��`i�Ē��0���d���[�����h�ؑ7�y���mF&b0l�#�91�~�e"J�rU���GNL�c90Ў�%3�Ŧ�#)����p���۔�~=��i�.Ԙ��j���9�*�Z(�{�7g�g�*ѠH#*�hr����� �`����a:h|Ѽo��Lx�7FT�2	,�{�'�;���NC8&cf�2�$����/��ӄ�#%1�!/M�hGvSŭc��e��ï��A���R�FsSͰf~�ܔ�zq$ʦ*����NU�  ���/����}z��wc��^_�.O�@s�˂���B{��a#�ca2�6�%��4�U�__٨`w�����fmoJC`(i��H�b]�|����[{#�C�����.H�s��*��i��	P0�|�Ѿ�����{~�I���0�L7������Am�W��X_�`�����m�$wi=�v��L��T&-[	[�OA*�`
~=e�=�����&��w�ȁ�O�{:]�qpغ3�@<�0���nG���(���
/G��h�?ᇚ���1�@J��&����W$]j8��>���b�����M�+��0ѡ#���t=c������:<����a�P���&��oS��������kW��o
?�hBa6o9`��Y��pi��ے��`�IW2�'��yu]���%�|d�������$�Ff`*����4�zJ%sai����~o�	H��G4�k�
md�!�G����T�N���$�|)�N����n�G�,��R4,��Z�6�^ހ�S��Zt�)�0c`0���ƾ@(S�mC`8�2쌫�zC7�#J���d���];�a���F���$��"*0n�i�'S�ƘZ9,��~E���M�yqr�&��P�*l�#��!�����2n�:���£ʇ�~�q?e�Ԓ���ό)�s��j��	��	a�0��Ѥ�h:b8�������5�JӃ׾�-��XͧF�K4��d|S��nS,�$�)��4�:�x�JEO�S��"�����A*:)fO��X2��跽�
/DW�R#t��jt��W��\�O�1��DQ:l���<߻�w���1���ۂ�RE��3�=y�w8ȳ�Ŵ���\����m�[�~eP�?���rS�Ca�:\��#�v�,ȏ�~�B>((�e�L���*��O#C�ڨ>���8`��i0�1fZ�Q��p�\m�%�:����� n5�M� ��Q�,^������`���ۯ���o�������}�ϧoy�)�9����Z&d�;�;�����[�*��nf^>��[����oq�+�f��2v�E�L��0�|�Ʈ�D�-���(�.IZ3hS�����G��b�p��OL�2�ώnb�7�tB4]�������-�i�t���vA�XK��;�P)F5�XR!9a���I�,��$���|=eV���'9#5�����>��n��(M,��_ۦ�z��#s۫m(Q
�}P��q�E�{���Ϗ���O_?���M�l]u�Jl�LφDd�W�t����y�Шљ��������5ΎD؜�����^2O�ʦ��3�Ԧ�C)�M�u�&ӯ�Q�[82� ȴ���%�GF�:�È{�X"�Z�I�Ĩ =e'm�*�ufo��*��6�dS1�|G.<�.X���	��56�j��z[�Y�uVh��
��\�/mi��G����1�-{5�ᯧ�8��OX���l�mg�(2'�x�l�w#�r���k_p��:v��NZ�(���1����������D~<"yy|=r�l2+!���#���試�M-ꮿB��a��Ǟ.�����U�~ve�i��77jT�RU����6�(́EÄ7�,XV��~�$���M���i�&���d&~&�gõ��ŹQ>0�_�f�#>�>3Z�|��p��`DO�j�J�
w�l3���d��T��[E�`����8}?�N]΁���s���~d��?L�u׷Y�����C�	R�D@�C��RH�;���(�2���j&u�ǖ`��h���b�j���X�N��m�+��;�6�'��{<��]�|����?�D^1���+���*G� ��n����-�ZnrE�d2~�Q]�T"]��xh4�U���_��n�C4>�T���P��j7����2�8����1�w� ��};,/�9qG�����?<�������_��N���|������_���E.�9�:�y�ʧ��%^>�R�'�v����0�e���o�_��"�1A�����R���E����EP�
@���������N�`qr=������:a��"��B$W�pi�4@,U]vU.��w$�$5�8�!��+ɭAAKA��.y&��B�ڮ*Cr�$���oJ}��)�r��*w���2����(��6�P%������ �<�9�ƙ�ݧ�����緯�~}{���}޿��}�O���d�i�'|�`ø��ݗ�����u�?� �����Ǘ���e�����Ӫ���EЦ:Dc0s��>{{:H����ȝI-�ԛ!�o����xq>?~�����"��߾.�^���y�/�o��J��A������/��*j��˺Y`\X����좫O��`|3�c�n*���xT���	U]�k�:�'XI8�QX�߄!%�I&+cT�bX���o?�������ǯ�?j��K�����+F"�S)0��'f}p�K~��P�2�~�N�zmT�1�-@uv��NPd���	T�����U�-����)�s����ӿW��Z�w�:�T��'*3ͶZ��ev��LV�
b(�cҷ����G7����$CelG��q�SWv��t��O�3�ȝ�0w
o�j"�>�L]�;�Jf�V�jCH��9�HVg�^"�*!�����lFS˨%Y�y[*E���C��r�h/A#�i�e�[�(y�e����D���Zu�HY�焰�����Q�����u�C�v]�*�����Jv��M<
T��$s��5�$���.�D��S�D�\��as,��Jj�BՋP�j���`~��y��Op�d�O����d�U�C%�����Yt��eR��T�1�0�� �d����H�%��Z����F]�Q-�tnv��?V�=�..�Tkoj8�t��,�"OB�X�ǥA�_7�_*Y ��;Q��qQƠ�h����,�g�Jv��wϜ`����̾�X
�,V���*� �V�
��^��2^C/�Օ������pV5���(�8�y�0�&,��+���&��&�h��=�^E�>(a��"���y�����K��h�=�Òe���{�*�d����?l��L=�FUS4�I�=�9j9��!�R{���e�~�����C�'Ȅ��┕��4���d�����a[��_�76d�1�Ƶ��z�B6\ϴ`�$#�Uu% sȍ�QVҭX�	�/c]m��ش<I�:.)IN�EY-��gQ�j����>�������$*�}W+]�i��>!,+���J*�Z3����9��(����F�7v]������̭�h#C�W������ۗ�/�~��y����Ϗ��p�g��)�]�Y�������vO����
��>��CK��C�i�"������(#ύ��lր�O�!jټ��V(*aA���"�3`�˺��)a#�^�*F%s=�Օ,�a�
�A��P�bj-�8�1���#�šV������!���1�Jv�ֲ
60x�lЕ�*Ǩdi-�
��h�@�ou=�Y�2���W�5��e����oѻV��\v���JF���U̦Jtr�tEYpu'�k"�b� &3�z�9q�e4�ZC#�J�J����j���щQ	�b��(�54|ķ�
䭗���JȾY��f�ޑ#�"� ���	�|�9��%k��	���R���ĥW�H-��$\�#��B�Ƀ�I� �  ����kY	�u�gx������<��Ȧ��q-HZ�l`�����7+z�Nτ֤��mh�[��U��^�=�Y��F1�Qɜ��OZ��L��`���l+B�q�j<�Ñ�U�4՝˳l�u 8˒D�.1�e�2V�wi��.�V�,Ñ�>c!L�Y7��\��j����Be��6X�ee��\�\θ�E��ǔ����T��qM��a�����z���4sFV�V"r׸�f)R	x�~����%Sz�;z� ���@d���eT���6#�)��U<7���i�,��:~RX��I�JV�i<�X6����P8�[/ĨB��)T�`cY��@T�;�����b#Iq/��7+�������d�TOi����h�V�*�~VtTQ	q�mS��0*��0��5
U�J|�C�ɓ���&�Pu�ŋz�Fu��10Y�����E�������T��C�5�y9��.�,4�l�t�Q���;��O�B�E?C�*t8�*��_��!m�p]��S4�� cI��lΞ�C
Q	�i�E_��22>A�/��.��cT�|2F�d��S�{y���cT�>2����[�4�pї�v��za����"`ɪH5#�e/Q�M&Qɗ\6K0}����2/]M=�⇇��-��F%jg|�{a��;D�
��	Tw�4{!ŧB��#fUlZ� %�k��X	X2"�����*H����0�9�4�Z`J�
�L���C�M�A�B�u΋T	�p��S��	P2JO1�]M/�?�F%��F\#�QEO�������,�p:�
��C���RӢ�	ʬ�^T�E%��֨d�jui� s�e5D/'P�W�a`��#��a��wbbT�mj5�5��1o�&@E��*x�)�*����dSU?����?�;XLK �4�oQ8P�Xo	{e�5�l��9*YX��:@T�:>c�0Ȳ�OPV�X�M�
f"1��A�bɼ?=M����j<5�r��	KK�E�t;F%�AT]?,x�D5��w�;����V�@>��� ���U��5TZ����%�1>�`{�A���V	wcmt��X��;K6L�ǆ�de�֪��o)�����fr[�HB�Wݭ�4mm]Tϲ�7��`M���Cf�44�s�Jz��
�`QEoW��d��i.�*�>Ũ��0��8�l��"wQE�&Pݥƚ��v�*v�!!�إ��Q����	ʚU���$c�t��h�T�!(a뜞!����"z�.Fݜ�Qo�#P�jT'L�lAQ�CXB�T1�A; &a6QQZV����0~t2,8�
�P�6��\�N,�;��F��J�?P��I�QA$#����
���#4�}NLPu ��4��M� %+^V�Y���
_�au��h��,����aWC@P��P�#	T��Tѹ �*x�	F%�M�VW�6iE�����z�D%#��u�p����i+Y��n,��E�x�����nU���?����_�xu      �   �  x�m�M��0F��Sp��\�l�H��
 �b��)HH'�O�,��~\8�y9v����6T�r�̘�q����*��lYd*E��ϯnF{��Jt\گ�q����x��x�	i�@��p*�m�����ݐ�2�<}�S;�PB�*�y�������L%�	�[_G�T��Ow�O��EQS��[A���u�~�� S%�p��I��Ԃ�i���H�Tb�a�N1?�>?�Qw9�OC�8e�dM1��^�~<�ۋȶb�������.������!�z������x�Lh(�C|���P|�7fB�f : �̈�����Tc.ӿ3�ޡ�M}Ǌ��,�����X.;�@�)�U�9y�Բ�;3!R��5H��۶��t�>��ٖ7����Y�;c�������      �   	  x���Mw�����+2��hw8�(���"��T�~�m̎`��위�����z�@ �(���6���E��G �C���n�]L}d�Ҩ_���_�py���Q���n�������������.k��N�ڙ1�v���������7��6�2FN}:���������y��,���O^A
�x�R;C�b>�X��uϕX����ؾ����D3|;�W�qd�qZ�Y�T�feۺp�����/?�y�m"�	�W.��;B�E2���J�X��q�P^��s]:����Δ����C_8����)�l"����|$��Apo�A��K}-�\"����Q�M_�0�Y��<' P}q(jo}q �-�8�H����f!D4�� ����_����o����Dl�-�Wy��z����߬��0	șt3��k:���+d�+��=S~U��񭹫�F�Q�޸c�S���i��zK����y�8��#q��M�T�,�{C���&�/c�ZB��Ҕ�����|(/�0G�'#Q��O*�F\�3[��n6'I�D�{�5c���-�8���`���׽�C/1gJčm���w2�m2�� ��&�5����?!�kO֮=�X�~�ҪL�v7�m�����aK������}f��K�g��gf����`�P�e	�&���R!�\9(���
��P��
3��E�D��c���k���!���jC,��J#eX�]v��1�JׯH�<	~��,��5�?�j<Gu:E���$[�BU�J�������w)���0:���U7��pI4�g�N]bE�#����X���!Eh��/c�U����N�uL�+���|<B�{������s�A�uη�mUlG�o7lp\�n�m��*!;7�M���|B�_�o"��|\��ML���R)�������>��TR��6��M�,#wOKu���g�V��i��%��y �R9��n��}���-�Ue�Ul������8������![U�TIe�5͟O�l͸�nnJ���a�w��9s+Ç^n��Hdv�}�b�B�/F�t���w�I�b~���FD�4@��G�"Y����)=�����E�[�D��syuI�:⦲s�ޥ3;��9܆d��E�5���=V
f��S��)Ml)����1�߹�\����]���h<��f9�'
>-��p�6}�[F�8G��ӄ��X��0BLS��c��.IӪnŏd	6�h��`����=�*���n=j�Z��'ھάvg�3��/'�9L�O��Q����*��G������J���XuC����S1�y��Y�δ�95S���y(�1����iq�秽8�lo$��k���X�¸b��Q�15����Z�W��)����/��қ��O�p>k�ImӝEN�7o�r��0�a�:�C�΋���I�}{@	��������y@n����|������qj�L^<#�!��L�G�����4X\M�zNG��9�M��w$�/��9��d�?�	S�;y0AXmZE�d
,v�Xy{0���7W�c��t�7��(���vך�&�t8�b�κ~
^1��*=�U9]��{'wu?�ĨƱ��SE���������q۽�s��U/V�n]���zw�b3�oT����Mc$��WF!��X��?����q�$VFvD��'>��nǐ�;�$6c:'E�za=��@9�NW�Y[�t��E���v֡�o�N�|��4&͸Ԫ�����j
��*�����������}fK4�?g�݆�`:��}��o��uJ�n"-[��-��������������oa1=�k��"������Tg\
F���#�=UR-�bFsR��z��M��P���,����g�I.�N��l3����F�!��;(W��F'B(M1�;Q�]�
Uz������PX�н1[.�~�,.�N�Ao�N/ `S�Њ��oc.�X�����J��qp�iYX��t�x�T|���6v��]��vk._��)I^*f/KO��h:�q������3�� �2�&��B	�c�P��/X���P��R	�xRV�����SY�C/	N23���ߺ��w06����n-��i��0�<��&.�ް�N��;�����=�;ю�s�`kX�\Q+wZx���\I5���8<f�������@��6=uG}Zن�]��8����Rp~uG���q��=i���V%W�E|�,+V�*央�/�3I$����ٺ���a�<Xvqo'$�0�[vt�{|12D����>b�r`��Y�U��j�U�~      �   H  x���Kn�0Eǹ��R�����%Q���<ɣ��[6ٴ�Ŏ2v�(g�2�!��+R��w�G����5�0�jw����0�dۮ%�E�0|��E���t�ۈ��}3X%�G1�`}�{.gv;wU����ى�1�rJ���}?��2#-8�/�Ɉ�1����h}�@�H����Ǯ��]k����dg��2K���U;�_é=����U�s홤�4w�`F�M�	�-;��mϘL�S�:c�Bl�318�۟bb�����Ob�і���j���u�ֈ-Q�ݹ�R��ߒ1v=���c��~�e��8��9�~��������      �      x������ � �      �   �  x�u��m�0E��*܀"ŗTD*H�u,��̘�u�#ҽ# ��_���9�v�n�MZ1��[��b(6/�+O}W�����7��e�J�i���b(�z/��*���y��<�*�E���Y1T[�'�v/����ޛ{p�P�zO�*����{����n�j��b���.����re1*��}^4�O�f��ϋ�^=� ������0K�}^T3�,��y�<��{�fi�ϋƳ7�,m�yѵ�g�n�Y��jN�7�A|�/�Y�(���7�y���!��Ǌa�6��H�Ͷ�V��ao�4���=V�0Kϼ�{���_��a�6�y�s�5cs�W���̋������G�0K�2/����ڶ�c�~�C���z+D      �      x������ � �      �      x������ � �      �      x�ŝ�r�8���WO�p2�� ��鉞�M-:zz�5�y����!(�([��dE-xe[H	�¯0���~q��h��^�|I����������i�a �-h!՟�_�����w���K��Ͽ~��L�H��g����.��9|��/����r�_4��~��?>���������侜N�ˡ0�Ƌ� �v�ƷN���ӧ �;�"@�3H �} ��s���A�uAh�.��0�axe�=�����G�Ax��7�x� �A�4}�e`��2p��2�tAX;��l�@�	�� (�� (羠�Cgll�|������d��G���S�Q��AGQ:�0��vaE��8��3�(�� ̰��	��� �����]U�h`d�P����t�ai�<ʟ��^�f�lH�Ae�46�7��|�C.��~��?�>�Ʉ�@w���v�V��="����t��oE�
��?|�c�������8� ��Gw�&B?O/�����R�~�vs��:E��-��kAHV�qI�x�"ϒW��|��Bbg�} �=�#��A0,�:�`XHz	$	C�R��a!��)�{m�	�$��e�<�	_i��������GSIJ�;ܑP��� 徏N!A;� A*�A� �� H�Zg$HSg$Hsg���o�Zg{��-	��w����Bӗ�|�`�� �,3�C���.���.��@����0��y d��~����-?���鴠Kr�h/�k����$�ͭ�o<8�:����ʌ���T�o6T��W^~��z�������%b7̅�%A:S#��`�N�݌� ������e/8<A�z��'a�o��v�9aͥ��	p�N�'�_[�π���9
^ ߳�s�P�8ߵ�s.1j]beQ��S��&��M���J�:s�C�XN�C�Z�
׺���P����µ�9'�&���m�cv��{61�Ag��Ǡ�{̈C�����a�h�c�p�PvG�-ӆ�8��iX��p����h�]��'��p��ñX�j����x��ϒW;5�q���5vK���tqG��J)�6����������1��z���X���!)%yi�Yx��`ޭ�<�0�V_h��wk/t	@�;i�������e'4,�f�兆E��۬���B�"mb6��P�&|�5kH}Є|���e�90D|[xO�c��8v��N�c�n��]��8�w{.p����.�\QT�=_q���T���a�÷����f��g8����c8�>o=��9��}��Zܨ�p�R��I���P���/]�)�����TXf���>� �I[8��s/8#��o�L�YÄ�>]v�Â�ƌ��h�^�_m!�1�.�5{9���~e8�R3Ef���I7֋��X��B���D��Z�I�5hI�������;�Y�ft���f�n��� �OD醘���r<B��n��!��������������	�F�k�)�/#�<Sˎ�Ǝ�L��0���l�W���F�z6��[��A��B΋�(��w��F�{�<�b#���:�t�6t�u�:E0�Za6t�D6t���z��kE��еb�l��ځ�Æ���φ����&tt*_����y�}
�u�۾������HbS��3�0��|���}���2?86�����ِ�M����a�i��&(���x\ ��
�� O������y����>C����գ#���ã�K(T?#�Q���n.��P!O*6${R�GY�'ۖ7��?�"��l=�dQ�8���a�A�A��)�8�۞��A<��������y����,��|�N.�!�z\C
��DO�O��x�#f�imU��-����'�a�P<���8L���ధ(� �=E�8D��?S��8�I�"��%�^v�Cᚰ~?8�	���C��~?8�	���C��~?8��w�C��78�����3�a�np�Ll�mN�q����	p�L����'�!2�N�Cdb:���8D&8�G���Y�LX���׌�,�8DF�8DF�8DF�8DF�	p��d8R<X�	p,�tk���n�w��
�|"��8DF�8DF�8DF�8DF�	p����d����:��F9Em$���@ot���Ke���w�]�ur�눻&�N�K��F\R��Ƹnc����Y��hsGcp��>�a�Zx>�,<%"����p�R�X}��*���FuM�������y|J���I3��w?@l����6~����e'�,��	�V��;ڀwtZ��hsG��3:"�T�b�Nw�@wt��8�a�-,����R{@��h<p�h<p&w44���莆������pVw44����F�rvGC����-��Z��,L��"��ѻS���uDȍFrGCH#��!�1��!�Q��Ҩ�hi4w4�4&o4�l4fw4$E�uޞM턆�ɞ��c�P3ٓ5~j&{�ƏAC�ڳc��P3ٓ2~q-*{2��Acp����ϰ�r�|��hH�w4�u{X��Z��q���q���ƸVuF3*�]�L�������*<���ݝU၆���
4<wgUx����;�����Yhx�J�F����쌎(������Q��"JǠ1_SpGc�&rGc�&vGc����|M��|M�Ʈ�;�
����W�S3��\��,�]k�F#�Y5����^s-'vۊGt�������hh�Ew44��7uGCR��ѐK�hĢ�ew4,R�s��1h�Y�s��1h�Y�s��1h�Y�sR�1h���<�CЈ-Դ�<�c���i��eAoWp=<w4zx&w4zxfw4���ј����1_guGc��掆���F�}m�pS�#��|�	I)�Ii6��А���hHJ��hHJ[��	I)ꎆ�sGCRJ�FcSZKvGC��J�xAs7��f�;:M�h���
ttG��N@�;:m��trF�>,dw4�V��Oz<5��������f��h�Ew4Ԍ�5�=g��&�k��h��u�0/���������.h�k&w4�5�;㚣;㺭�邎�*�i����#]2�k�7!�M��1��\�f`���f��{�!~3�_n���,��j�4�f�(�0�(�+t��}�jesG�s�F#��8��1��u��pC��r�,�;SLdw4���јb���1�b�F#��bvG�t�+����Ǡ1�eO��c�ײ�h�c�ײ�`�c�ײ�X�c��"�h�
��H�c�0dρǠ�f��8�C�H��&�j�匞.;�!)�ѐ%w4$E�I�莆�4�W^hH��;��掆�h�F�r��JRhAS74$ł;�b䎆���!)�ѐw4$��I1sGCR,y�Wl���P�[\q�55@�.;��f)���f���P���h�Y��h�Yw4�,�7!͖������2_vBcp���F��F}Z���^֧i,u��Sn� ��
������f%���fE�ш!���{xs`�Lզ�f9����1ɸ��@�/m|��A6(z�4���[�W��ڌ��l��8��jM�|�i�Q��J�~�K^n�8>�k����[m�7�H�@��=���ןF��H_��^}c����>�T1��}C�pX�NA��c:��7��b9�Ԍ�i�Am�����!�\�]���/EǎR���^�j�j�022�����!�����f1w4L�\��6ہD��n=���"�#�@q �m�ֺQ+��#�~E("9K\�������7�X-����tqG�FW���V��m@�;:��hqG������8+������NKܬ�rj&�5kT:��f��P��@�j�쎆�itGC�T��P3Uo4�㗶��Nm�^vBCR�"HNhHJ�'�BCR��KNhHJ[�	Ii�/9�!)m�%'4$���䄆����|Ј�,m�%'4���j�t/�Q�Ų;jf�5K�5K䎆�%vGC�RtGC͒���fI���&�d�h�YZ�����t���;���;���I�쎆 �  ���f8�$��R\N"�n����<9��w���L(��[G>uv��ǥ<$�(�69,,�����Ӟ�����<����U��:�ԡ���*N
M�G��[��N�4y�Q|��ʽ��(5����q �(Ob0�A�������3��;��7�,%��SXy2Įy���ye�z|�Z�Q#(}��ͰɭX ��pTIJA^i�)�=�e&�<�t!��I�Eێ��#�������Ѻ��|��a��4~���!q��\ m����^�#:B��w�T.6��،��2�tX3�Ә�sdU����,�o%��4և����bs����+O��v��úL�O��U.VliW3���Ϛ/6��F�4m���;�7Q��	��@h/��,����b��4��f���(�s�
�!�P ���	��@h7�&�^��̈X'��k���ݚ�!0��d҃�:!�i��U	v�B�nM�R@�K���c��DZ��=�Ӷ��B��tb���VBK�Pڨz/*�Uw�gxX+����]��"_�����0���}����KSz�-8��t���C,7�^�l2E����=��Q���Z�o��ފ?j+9`+9� g�W��&z<� ��8���'�1�D;���?Nw�p�*Y�m(<~���8o3	���O�c��� �8o�	���[�i�S�π��P�6��ӑ��78NOP8�"=A�P*���C�(��HOP8�"=A�P2���C�(�e�HOP8�";A��F������f� ��Y<�39�1;��t"c�8DƊ?�#(����v~}��Qp�L�sd�Qp�L�sh�Qp�L���d'�!2i�A"G�!2iϹMG�!2���a�Lk/%Df�l����P
e�o�\ϩ�<�:8G6���e�t�Z�i zlț�9_�.BZY��}����Aq�lś�cT\�X����nvYދ<�#a��»(��`�;W�YW����l���	����`g6��w6L���?���KN/6�wb6B)ڔK/6�%�?ڒ̟mIɟmIٝ-(�`q} �n%� ���j5��E��Y�1�ǻ\�������G�Vr\R�n�m��!-2_�՛�Ѫ�o������k��$5\��I.ٓZ@-~T�s��G*�J�T��Qu���Q#�ѓ*��'UAUO��jnT�a]�
{��%�:.��J�à��Q+kN���P���g��{����[�BYwWj*g���_y�]��I�.yR�ĞT�EO*t�ē
] ��BȞS�)ǁ�ԭz�rр�%M���B�W��H{� :�C�.^�y�7sM�<��K(�!�;R�Qxk���Dh�Dn���)n�� 4��ʱ���>��K ���[G�uC< �;�<�O��8���J�I?��u�TZ�g\LL��B?�B�9��J�3~ƅ��<��=W淹YΣ��-����xV�M��@��v<��z�#lZ�#��Ŧ��ƪ��6r�U��QV�|S���p�[��\4�)A�?���p{���}Q[��y�i.Fp#KY=��<����7�'M-Fq��fK�ܶs��]�QL�*�� NT!�.��(H�L��a���`�0��k�"݀�:���{��&���F4Z�3|��G�F�����85�� G�k��Wh��q�c"���H`�%���$&2?�>ǙN�uO�A����
�΂<��s\�� �հs��%�@����˩}����(͈�)%i�[q�*9��i��.%�Hf�ķ#(w"��r'��(w"��N����(w"�	��w�]��d��vG�݅��;�Fi��=�NXksF[�f�ux�*`�g�4B3uC`�&��xL��.I7�W�n��d���.I^գG�σ�Q���`zT��<voE�i)��fi��Y���f�Ro5 �#�bKi*
CJ����'*���8A��*~��ov�^�oңv���R�cC�&��L��586��z�^����L�	N�5��mH�X:B�by�!��x�icKB<jK��p�(Rܖ��!1�Ȇ�Og�S���ȴGD����:��݄��j0G.u?^٭*���[e�6S�����4$?���a�ؐ�㗤
S��}ԭa���K*ƃG�b���IŐS�bVٓ�I^�'CXՓ�I^͓
�F�9u=����D%��ṋ��$
��U-�k@�/�o_r�|xh���nr�ّj�T��'�a�I�pX��b0�xR!W��Tȕ��x�D��9�I��*W��Tޤn����jhh����ȋ�%n��΃�c���鳨u�=Z����!؛jm��C�{�3�����F��e|o�a_?�v�z(�ݲ�ӊ3a$&�����~��n��	�>��9�h:�Ǒx�i,���c3��m�ӷ�G~8����#��7д�jh\��6"^x������ �f���'�o3b_
�6�Ӟ��I�
�R]�'�_y��T���w��F�����w4#�I3�����6&g
�7�v�S��;�i�Y�66h�כQk�<)o4#�]�����.:%�z#c+;>�"_�!��Io�����fAȹ1,�tC�[B7�g��!�=+��Y���醀�[�6o�^,|C)�E�L�m���m������X
���#`�����"nsxX��#�N�l� �zpeu3B�tp�	�)�w�)*�áx��.y�m7�7�^��f�R膀�wC@�(vB��S��5X�/�W� gr�1�=8(� ��(*Ƅ��Y�6r�S���lL��&�В�2w�۲�7�p��Z<.�����6�hYݘ	S}Jϙ���Z�rk:2u�k=F:�H��fԚ&�֭o5cZ�dH�f�T|�j��1͐Pw(�_�$ҽҌڷkFݡȰ2�Ҍ��[W�i>�4���j30�f�ь4�.�F3j�Ș���Ԍ\kB�pt��#��������Щ��t���"�Qq"�˟�].���I�'     