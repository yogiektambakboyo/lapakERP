PGDMP     8    -        
        {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    210   �      U          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   (      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   ��      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   ك      W          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      Y          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   ��      [          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   ��      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   (�      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   ]g      \          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   �"      ^          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   X      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �X      `          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   �X      b          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   �]      c          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   �]      d          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   w^      e          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   �^      g          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   �^      h          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   �^      i          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   `      k          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   C�      l          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   0�      n          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   �      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   7�      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   ��      p          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   ��      q          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   ��      s          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   )�      u          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   F�      w          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   �      y          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   ��      z          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   ��      {          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �       |          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   H      }          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �      ~          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   �      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   c                0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   �      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   �#      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   8*      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   �*      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   ,+      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   �3      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   �4      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   M5      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �5      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   S6      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   p6      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   �6      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   ,?      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   �?      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �?      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   @      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   /@      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   L@      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   ?B      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   �B      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   C      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   �C      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �	      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   `�	      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   E
      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   �F
      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ]O
      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   �P
      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   �P
      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   ;R
      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   XR
      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   uR
      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209                        0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1778, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2683, true);
          public          postgres    false    220            	           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            
           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229                       0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 517, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 469, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 70, true);
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
          public          postgres    false    281            #           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 7573, true);
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
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[��q��G�b��~��HP�ƴA�q����1�H~~�x��s4�nN�������庬ZU���������?��p������ܴ|n^����C,_�������XF���O��m7�����������������������i�|{��ۇ�o��޽�����7�~w�����o�z�߻��~>��W�_��@`R'�)L<�������	�0���_~���o��w���7�N�������׷߾�����8���$���>�L��<ˉ��m�O6���_����������'3�~���W߽�M�C����'Xq,�Z��\׫�u��6�XhN��r#� 0��W�d��Iޑ��D�*
Jt#�p���}?����#|��H2����H
?�U]Q.\Ӏ�Ը�q~���o���Y7���|��ٖXQA�n�/�o^�J��������Ou����������߿ywwS>y������E1�(��Ýd�N��}-��(���~]с���$DiBX2z�v��VA'�� �:i��@}g�toPX$	�ܳ�9�La&�"��DrS�jC��<��wt�)�*�`"r�06��U���p��\��\۰;r`���6pe�iP}��U^7�<�Ǖ���h�a-��m���e��D%͠�B��1��-��c��L*
��H��H���;i�QIb��Nl*
��y�7I�SH��I5���g$Kh�S&�<��R;3�U�@�o��Ɋ��ݴ�H`㴤���P^�BM�D�*�(ˠ���Iw�eP�Qh�zQ Q�2(0��;ґK&3i٤��Ե�/��,��u�fw`�8�jW�q�SH`:(fr��SZA�{����Oʃz*��e�D,u2����r
(
���ا��`�`��쵑�FAU�}#x�~d��HE� ٸ+l��2)z���Z`-$T�����Ԛ��	C6M�B�mI�eTs��u'�H��)Xٕ�
˸�8R%� q\')�#I�t�L���t�TR�RI��$�I`:t"@�uRah�3ƋC�e0��Q����TҴ��X9��/��/�k��'B���o˰�"�$鿌��Aku�*xE�I�M�nR��2�����7,�,ua�"��\Z=`ҮݺZ䰋�.�#��br�&�(���ί�NDi�a��D"�!i��q
���+� ����i!��v��M6��|.na�Ic�H��H�#�M���R�T�HE=��rB�6���K9[��,{�đ�~|=~�{�'���'�?�����	�3�I�֫$��A���uӡc���`���̶Bڬ.����k��~j�v�@����J�}�l4�X��n^��m�ITܿy���M�������˗Ȝ�Hn��8p�\�3��2�F�tMf(,����LV�	7��-�B"��Pn��H`jGʾ |� ���
Ii�E?I�����*�B��ԭ]$�|NИ�	=Qї�#Qb ��(�!��N�#"��l$�ޖ'��\�3)�*ɵ�͆����ͱ$�r�m����2$����`�e"�2u�GR�t>�Qe��Xo0�^�4Z^q�x�yD�zl��RF���_�9Z�����Jj%M*���&�$7U�$�e&M �M;�����`$�MR̴}-�1�+I�%��-���eq�4n���M%�_A�Z�,�H�&٨w��r:(���#�b�t�&9�� �ɾ~$��]0��6��Ӿh6�ә���k�b� ��Q��Ҩ�4�]Z9�1��V1���n�(=�JtX��mԆ�an�$Yf�["���^L�j��L�eaq�'Fېh?�Y��*���M�������o������N|�X 㱀�&H��ґ+�^ԭ˵K0��G�4h���.xjcM�Ԥ1eLjDXm09;)�.n��"	$D.�w꓊}����:�F@+����.�,��CrX��2[�d�}DI�偐B�g�b<gh�퍋v����a�>_����P:�TDLA�bB�=*�����F��Nw����-sp`�fV%�Hg
��gd��vU�$f�ŤJ�̊���i8����M���	�u��S5���6h��bQHMՊ�W���X5����S�,����I�H�%m�j���A2i��Q��r�|<o��ˁ'`��p�{���ԍt~�H}� ���Ij"��Yz �Pt�-��{�X��:�I��II�M��
c߂��4��$��@[�E��JR�+Fn�������׽��!��`&=òbd���+�Pd�u�2M���UH��I�Ж�E�����L���8��Y���\�V�c#s�~��0�< �')z��Mn(�����������]�gE{`�+9�:�Q�y���V������k���ы��r�Yru�5)��*�a�|�SfdP��c.UŜi� ����s`)J�&��Xֆ�[�H|I�$u�HM_&
�n��gEE]W����G[�n�<˪��y�B�n��s�e��tc�T�3J ���&�#�:���T�IN������R���4�Q�A*}�2��+)�;�hb����S�>���m�M��J�
���H9 }ڧ�2�`H}p�H�5��5����A-X�t>:2��.��1A=H��P��<d��Q�u���'!���Km��iLCب<��a9�2��%Y�d�'X?�������ϓ�H7��x��l���o�{�����Q���!f.&�f��H�"�2�)/$Xf�XE�I�G?go��s����ef�EfQ�bky���>���Dj�2�2}�f�e+�YjU��S�boJ��QI��my��YwҚm#uq��$�Y�.��N~�W*0Bp�=[������n�+�xŹ恇�����QSIKeM���N.c6%W\�P��s�qb@��}�w�H��+����!��L���˽�b���&�^�E��A��b�C�3�,I��H�<Q���Ɗ�
�z���Ӯ8�D�ӿ;l>^-$�y|����d��/@j#/z	L&E��F��a$�=Τ `��#;�t�	ʰ�lAA�AG�ȱ-�0��7�.��"�b!�n��%�� 	O%d]��q��`�g�(|J�I��*1DI��qX,{F�w��1�*�tFǏc�D��Y�f �P�6��9��kEҔy�Eɤ�c!�"ˤ湊c��w���c�N�5���œ� �Y�f$���灵U�!z���Cj<&Hu��j7��7ZI��#����9U M�3j�c_�l�N]�2&��$|�XF�`.�օ��=�/�Cu���M[��|���z�ټ�F��/��b�*O,� �Ә(��3.�c�������a��=i����E*S\�=OZ�ʤ!]��.���ȃ��A�1��
�h:�2�ːƃ+v�U�7�� ���$�ʄ<U_qؿc�Zu>�>�G-����3hP;hNq�����D���_��H�V��[��+d�%�R��:V$uV�$�3h�=#I��`GZ��W-kay֚�����@ֲ[* XY[�U"��L�x���?�-q&z�E�V�=131 ��BdZˮ�a�u6Кx���]�#qly�jL'�'҉���v4�9��S�� �]�����D;4�Z�[)thlE���L�r�X�!�N�Tϟe����1�G%|���î�U
�,��*2�Կʄe��&�Bֿ0�!ߘ���,wq;��i&��p`e&,�4�����!�U��Z�"=Va�|b:� �����KO0�,�*3��z X?w�:�Z(�O�� ����:<뚘&=2�ֺ���dU@�Xƶ	
X��İ��V
�+�G�A�����8��L�k` Xv�@�ŴV:+>�3�����jLkU-,���tjg�؊�ֺ�e��F�X��C���=��H6����%�'������ՙNLLkA�ؐ!o?4B��@�|e:1���q�]s�LacWhA��؉^&"C>[ku������f���ΜH�������,��ʉk���d��yVB:17�Ӳ_$��������l�h#�ǖ�L�İ�L,˙�PLk�_BM��*К��[E\|'���Z�>������J�r��Ntb�~���!aٗ�@�ZG²���LLbky��    ��2Q��2C~"Y���I@N<�D�D	L�А��b�f��y|ȷ�<,{B6A֚�ֺ�hĳV�Lkily�zgZ�!�5*� 샑 'چL ˳VLk1�8��	,���2KE��Z�pY^[�������*Z�wc���� �9���0aE$�8����*f��U#3�Z	���`5&,&o��`%h�3	"1��Q̓�(XH'�	U�Z'>��������#�)����7� ��|l�����k�o�={������?|����p|���w)~:^ı���-��En�,�H9�s�gY��W�]X3�<�zwH�޿�}����ͻ����U��3?����K�'�;��6����X���]w��*>v�'X��(!�3Xk%&�������ӗ�\k]]�ǵ��u�ƃ�x[���W<�X¡��8���"����]a'ˤOK3��߼<I�'��,�V���Zi�V��ra5��ԉ.����n�9N��+�3X'�"���q2͂5��Ր�5��5����Xv���񜜘�N|zĹ��ǉ��1X����Z��D����b�����ǂ���<'>�@�-,�U����'�ZIj-��0y+kyk]&R�ꧧ�Yt��'2�O7�����V�pH����`�|��
ȡ[��9�Š�x�.zM�����ʺ+e$�z�r��m;���
X��V@�L,Lk&����ũ�A�׼"(�q�ZPF8�-Nmf:15$��$�nj3�c�'X	�M-,'[b��H'�ʄ5��J0�s�&����8qN"��G�Y��YlQ�lO�钭����G�i-1Axւ�<4�B�[�@���P��V�&�J����|���!a�C��6V�Vlm䭸�����ηHNHX������+3aM$A������!�nx�=����6
��\"X��X����u�c�����"�Cv�j@����m,�u1,�Z�i-$#;�&Yk��5D�h����3��b�+�b6p�h5ʮ��4|��_	֦n����4�(�YS@²��4����ag� 'F�=Xb��bk^)�6̈́��l%9Z|�!o��0�2
ծ4(`=��fK5�K�����V��ؚbky!_���EU�)�U��e���ZdZk,��q���7������Z��ˌgb�z�)����g�aaϝ��2Ӊ�	�2c�ickA``����Q�!_���D�V�Zk9�e.�F�SX���`ªHX�YX�jbk9�̌����Ֆ`�����xA�x�KL�,3t@�xAU򞵘�ev5��g{~oG�C�.�,��8��;�(X�	�"a��غ�w��yP�d��X��r�ȴ��9�
�,,�B�v2����&�������*ֈ˙���៿���@�/.�粹��szӼǧ�	Ķ�;qX-�yep��,���[v� �V�z�Z�v� k��`X~��w�5�qqB~2���u���ت����>���,�b+ �u.l8�JHX�ʉ	�\�c��\�`��N��)�Z�Ll�N�G[�W�#�EX��ۇ�o�ޞ����	�����'�`
	̲î Ƌ��=ǟ��6J7�)��x(:�����GK���x��FQ�펣<z2*z�����ڷ`m��@��c�����Ha�*���)�T�$�=7�f+��*����~�F�O/נ�i�����4>9� I`���۷l-$=�$Y��d����ց�'��2d�����j���:o	{`@S�i;���3�n�)>�r	�=�]�Q�n��`�$���I��q`�ҥv���vAdm�#f ��y	u��Nb�N��$Yf�k��l�\��ʀ�C�����T�XD�˥�@�!Ӟ�*��H��o}߳S�	S�j.0y�IܓH$0�=m�Y¶A�L�X��ֈ��U�f�<Ĩֈ*^�1�'
��P2ʔt�/��>Q��n�@�9���NIO��`�f�RC�}�RH�aYbf~5��yL�'�p�3�q�t��\CI�ea/����G3H���G$0�ٷf�8��6�F'u��u�����r�FM=,�������ͪB�ܑ��$朗��U�<�!q�����+�%6@����j0�I�$5��qw�3Jq���5��RLm�Q؊I�b�o��Ņ֐|�~�C��� u��&Cw�Q��Q\�O�畦}ŧe#LU��fߍ�fwF�+��Y)�<4�d����}�P�����$2>�mL��&�fO� ���U�I��#2�ھQ���
�a��a�S��ا��quI&V��v-���$J<o-8eC��\��'+��j7�]�l�y_4MS�Y��-�[=֑U���g�\�w��N}��aܖB���TP��4 ��U1f^g�gi/�<�zwN{�޿�}����ͻ��<���?��//?��DN�VN��I#�Jb�`(���0�<��LSHm_A
��}�qh-�}�s͹��6:�7�F��~�uS�̦ݓiPA��X�	4�DƊ����5ay G�1�QD��Ӻt�5��i�(��w*�ϵ�B�,C3
ݵL���}b>��Gb�b�K��ep�α�U6FNF�A"��Q�'��ۂo��9yu"'T�@ʦA��D�e�G�d�9�I!�7Ld�߆>E��O�7H����R�e(�8�^Řr0Y �K�Ncu��Mv�d0��^E���~�S�.h��ط�`ʾnڴSrJ�e�Q����F��X�T)���2n�:�����Ƥ�R�l��I����y��?W+ص���YW� ����*�a
0��P��q���bc��H5s.S�B�gR�*$�u��ĥ���k��`FId� 0��gQ��n�X9ǿ�{��}��ƹ� ���L8��H3P�Z׹���7UW�Ȳ�N@3I��8�8���K�[Ki�H~J��^PLb��<ɤ��$uU�I-q"�čtP3Pj�T�~��I'�F"��
`RjWR6u� u���3I�d������,�BW
r�4�h.#�����)`ڹh�s�62���`���&3[Ӄi$0�Jb&q������M�c���0x�r]����q��o�v�I��E9q�K'
����Cn��L ɼ0�|�����^.�I�R��s]C�)�D���j�@�=fR�W
3ߗv�MR7��Uf��C�G _^�;(�2I�T�e
�}�Ub���<�tč�5	�^�H�YuQ�ӧGE^�Q:��5� �Y!l��)��:q���2����l����X�
��	L&M����p8'HamP�R!��#5�+����ɤ�\�aX(���
�!��*}�W�nl.2�l?��W{i���WIE�&�x����҄�U}������!�D�"Ϥ!X�v~�p1��1V!E�y��T��`&	� �1����L�e�@�������`&)f���05�<�1��Z�Q�\� 0}_��q�Hբ����� J�F�H�C��Ms����ԩ@�sQ�ե�D9E9�
>I�3P��D���I"���x��s�e�0�}K�F��QAC�tL���zV��%�,8�q`ً�Ym#��/co���d�}f�e�F��2��q���4��d7��`���$`�l"1pF1pE��Hb�,)^^I
��8����-W/�$j`��uR}�,Pdܙd<@�SHѓI"'d�T���r%T��\�n�#BR�IMyB�+	�2���YF��^�$�I�r�IIc���k>;�ڈ$J3�~R��)�#�F��q"�|(�4�^a�*�lt~"��ѹ��J�������'Y&��EB���Ӿet�QyM��SԦ�;�r0�d{��`*Cd��/����Cb'�mє�ɾ�Ɖ��%��9���TP��ICʫ^�y�)�e]uJ�J�p��%E��|� ӘfU���	��\���[�6fV")�F����Ud�H˽���mH��WIIq��q�7j��A`W�p�g�l��L:�u�D��4_h��~@[z�t*��v��BQ��x�ձ���EL��M��E��ѹ�Lj�CB5�eH�<���瘍4:l�]���W�QCRr7��Z��]O�_>WXk2��	����S5�j0�٦�޳�d�j)    c�.���|��������q������HvqP���E+lH�}E���4O\��vਁ��:�.�����d�t�;%r��E��˭G�q� �v�x�2�vS=>�{.'��=���(-,�Zv@�εb�.�`�ؗ��=]����\?5P�WE�p�G�N.����<I�� �q��W,�n")��(Sn̐�(
�[2I�&.g�U�^�ø�S�:�<�96�$��9�����tf(7��Q(B�����强fuwa)XyC�lt1�S�gT�/�\q~vX�[K�v��/,��V�=P�u��)���a�����kϖ�1��N��
R@y�߃$T3�2��qw%����T�����S���S!7�>��M�ؗ{6.aL��4���F�ls	�j��\ב���ҽ�[G�^
𢚴�����k#u� eyG� �AZ�[�@s����Ol�|yJ�M"-gҼ+�
B'��D�fT6��S��%��4H�]I`ʾ1��o�$�9�d��-��-jۃ=���$����̥�|��������o�P�      S   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      U      x���ۖ�H��{�~
�@����� A�T��Ԅ��(��Vi:+kVVe��y�7s �A��A�tQ���}ss;t������n7��2<���Û��}�w��U�N�W9�����n���]ռ�N��������#���Û�7��4��TǷu��r�S5�x����_���s� \���t�ؿ������ ��O��g��;�.&`1�7O_��jUCjB8��5���y�j�#�����{�zUC|����ݸ��WH���ދ���q�'�����~l�=H���ߛ z�G��t���bZ�V5�v����˰7 �wu�jB�f�o�gA7<n7ai�5�p��<n������P~t�q�]@��@�>��y||��оsq�M��h�o�.����\�j �GA�߂IC|:���w��g�4��6û���x���{T5����pu)����@������n4Zk޽�!�!~�-�`|ލ�! =���k6Z�ы�4��a�Ј���8iB��f�p����޳| �!��3�ٜq��+UC��O��5�z7n<�60k�ur����u�п��!Ѻ����zUC��> ��S5�����ݰ3��3�jm��6��\=���c0k�w��5�^�r7�5���{��Y�fA��<��)e�r����u�0�杪! ���f7<^]��-�|'��������ʎ��T�������TA��a8>n_�'s�?�EUC~n6oޏg���v7<|>�oS(�wm
*��h�"V*� �o����/o~��_(������YCLwo�s����kv9�Q��=�׏�*H�̶q�7CGi�}�RP�*GtW���I�j���6����IA%��h(�\o����iؿ�Eͦ�wՅy���<��R��Օ�!���?�k����r~ټ �b�/�����0��|�j��_�_�l��i��M�҅K�\����K��g���U�?�ҫB�OG�}q��B���aR`e�hX`�*�}��r��b�4�]�\dw<��Z���>w�ö��q���~����|�/5���iF+����pX�8<�W���9&PjL�aj��u׶}����/ަIC`x�۟���pۦ?�1���h8>;祆��ַ�?�?�u�-_�_�^���~:��W�W�����4���Ke{Z�E�Z�|SחN2[��K�jM�/����gs��re@���C�e a�l�q����՚�L��L��J��9�Vj��o6�]@N�ҙ�U5��Ӂb�j�?]��¶6�b�jL��P��;���Aq���s�rc�h����i��]�`�wq�HY�`xO>����������0�Z�n��t�[�ٞ�3/5�A?����_�R����÷�0z??k��7�k��ׄ5� _�(a(zU�<_�n���`tpZU�8�g�x�~���ש������#)5�7���ҩ&k�H�$`"h5�q���S7�@ї�jK7-�ӈ�7h��6������\�#Q5��692X�wa�z�!���+�x�-7���u�d?���'��229i��[�Bt��Ҫ�<nM���rsd2�_���O������x~x�ix��|�tR�K׏.�˵)�h|�S5�ysڦw3a�O��mr�޾}��Ƿ���W��[���<�oߞ����t	�B0�a�D�p�����v:���!�����@����۾�!v'_Q�y��*5�$���W��ZLi���&5� ��"y��O�z��Pbޭ����� ]6���� �t��Q��J-�X���~������� څ������ ����ˏf<�^ �!��zڌ޻����.WjG�^�q�XR�8(�:��7��}��a)�A ɏ�����/]H�A )���vk�eR�r�e����y4�ġ��K�!����g�������AN��ݰM7&�&���A(�/�( 4�~�z��U�N�ꧻ����K�T�o�����|����L$)Ot���D�?���_� ����Ҭ�V��A m�����s��,�R�8�7?��������WI�BC��D�'�_~��_�[AȮ�! ���$,|�Y�@�����m�yl$.��m�� �O?'H���db�� �Y�w�)�Ŋ�((��.�ߦ�+��YkU� ?�~8��!����R�HR����ňѦK�ت�A~�Ք9|q���1����U�AHYpV�V�hQ���ԛ��p���8g�j����U����� �T?�	�V@j�����ⶳ�Vf'J�[+�#K�K ����r�c�Mq��A���������"MSj����`������qh����߿p�cS���� �t޿L�l���H�!-���a#GT6�o�-�UWqt
Gs�>��1�0� Y��A |��y2cxy�-5�vџ�?�G#1�q�g��c􆽪AA=��O�����~�ð��>�r.�^��as~����@[�!�k�A=;�_˻W�!T�d%���ҬA����W��r�`"�Mss|=#Y�ӧ�w�x:?��'�Y��?��j���t]+U�h�|JyWv�𧪦�(�)/5��瑕#>��R�8h�\��<� J⠳�C,c�Iͪq���r0�m��b�!\��p��z�)�SJ�}����I�˕����q��/���Q/��K�m�4ǯ��~N�.5$����q����A[��w�����jI�/̕�x�#�ϑ�R�8ڹ���E<�� �.''�ᘯEK����֏�Oi����� 긽7s���ŝ4��^�Q/�ǤA)q���!p?ی����sWюz�+8�V
�q>.>Z?1>%�\,T� �R?�L΅��}z��̩/5������w+�������&�h9IlGlU�`�|�EW�R�8�_=��t�8��yf����C>�G�rw�4���?�ҫ�B>��x�5�����]<����Xcň����� 
�~��n^)C`{}rC�jC�N���"L�R��N� �&;��u֛��iC�)_^��L�B�\�Sj��F���"��3%r��^�x�XC(��+�\��+��y��e[�!��9��1�/J�^	����$;i����F��� j�JbjW!�D��6{�!L;�	�?�%��Ьy
񹶻� �?���Д �\R\j�\v�Q�^� :�[�Edx��o:�<m��ީ�An�J��	�p�ռ�9�L�/��A���tVv�MJ��p`e��th:�,���Y_|ȅ��ƹM�I��s�{�AtXO�Z��M�܏�� �C?�qY��/.2���f��r���Ȏ˘�S��j&�d6յ��B#�����d~&)�m�dY�@j��]�ὪA\�?<\�u��Q%Rj��?l-��.7ԑ'v�A����'�/��k�˰�������v�DVcs��a"i��^-nn���҉�%����"���x~���h�u����I�4��v��nk��(�s�O�A='Y��P��)5�#����vHX>� �:T1sx��^'� ����0�"�.�H�A$�Z�<�l��� �a?���d�
���Tb�Ip�[S�MNb�jH�ߛU ΫB[����z��d4].-AX�@r#�O׫yf��9ɸ� �^7{Kf�L��򁰆p�|�����qw5�[X��;	kI�o�~l���	�/�˛U�l3��Kwd� �YWq�Kz� �0����r)p+'��D@���+1D��e(`� .i:�֦s��4��o�_�?7�k�_�I�h�ܝ�-��/�4����m�_�D�r_�.bvW�d-,�A�p��ԱH��wL *:P5��^�u�<��� ���`�2�D@yAj�\��At��i��d�ٚ/"��\�{gB�E�� �nN1�N�>�Q(5� �&�^!�Q���j�*Al.	X��/��t��5��e�� W�t�p��ӕ�P�B���ެl-�@�N� �8�t+Gu��ݲ��d7}ubi��������T���ߔ	9    ��|�!� �+HK��)":M�y��}�Pj�4��K9�`���0�rN��U�M	��<�DKR�mC�/�����k�DT���������i�,�H��B��f�����g���_�iF�޴9]�o#{�y�b��1�M�U}N�bY� 4� �5o6��͹"�NhBc��,�B�h_ݘ*
=�������at�s�#�� ��fي=&��R5 �sUx^Ҫ�˒��X�dt�4�����2:�K�4�ÿ�Y��B� /�O��}O>�{��qĩ9�咊����VhO�;����f;��U���JW�đo�no�?LYd"4�瞕��ȓ�����!(\��ec�k@F}��"4�^Q�:ټX��A�'�ת/���a�yn����2'4�$pm�J�|Y�H��=�d4���G�B��)�m���� �ݞ��H�3wExNhI��fk��7[�-�� 
�W�����D�3�+u�.TZ��t�/@:0D�`)�4���oSÿ�-�$)��p��E��U��D��l�BR��A(A��vɞ/OUB���ٴ�sގ�t���#�� �A(S��+3�fkmq�D��i�<�q}4��5���;U�h�)�|�j?"�n�/ ���&4)V�[��k=>%��z7/P�E��*.}R֮۟�o�弭�xj�߫D��ix�����b����b���֜~�h_���p���u&Y���kAx�����H�i�S�� �8����8��8*4�����i8�u������飷g�Чvu������.w��FKhR���m5?l5�� J�_I�7�BCHx��F��z��_|�g�s�����UM�[�}���^gB�AD���o��r:e�a�E�DB�m�:W�}�'3�5�j�i����&���g�a��[�1��!4���m���4�L=��
k������(�@�k�R��qc|G\*q�aO�A$)8����k�����r���G���BC�b�s>�mtL�H��vC'�&B��ȇݞ�	g-U����AT�R��Ӈ�>��S|�97��� $vh��)vb�AL�J�B�U��cݻˤ��s^d#�AL��u��Ɯ�"����p�a0}�b�Z��qp�vs4}�bNt��/k֑tŽ�� .��wß�(4 �򪆠p��x�Pi�M,j�pҫ��h�J�����r�`;H]���s&�%7���T|]�@(�px0�D���<a�� �t?��(�q	�h�&�����R�BQB[��I�#( �h��tܫ��<8���5�G�l�O��m�šThG˃MVp�j�f��QO��l��b�(jU�Pȓ�~Z����Y�8�u�l3,��q^"�[�΁�-�p�q�j�l3��㻱8V���؃)l2E�B�0��j�"��6M� �n���V����n|__���>����AL��(��}�֮��UY�e���"� ��� TK˶R5�η�����6E�@h�#�4�ٲ˰���D�}�L��&Ϲ���B�0x�ԭş&���T��N���f��F��D�o�]#Jls�ݿ� J�}?��l��6�'qK� ���(.g� K0��&�c�j�lGP���L�A\����Bjr��ث�с5 uU�ӄ�p�����9��q��e�����:
Ht�q�9�Ôs�f]q��Ҽ�|0~���!�� ������O[������,4�bǃ���}1�FhGϓ6�����h*1\�T� �PQt`�b�DW��A{ꍭ�m��ׅ5����n����r.�� n]}x�9>�I�"KJh	��[ABG�ЩD9�6:D� [-G+	"i�{%A\(�ӄ���"eHP@��x�
/s�9[트�� �~U��d�v���Դ�ZOީ\�/Nx�ap6�:�^� rV?ǃ�b�����Q����N 5ˎ��,�� B͙�pCWwU��m.��[yY������؆��y&������t�m�e��B�	�������@B9�Vhm���G���F�"�)4�ϫvI����!$���<�M�-�����`�A �z�rJ�� �~��j�h[����1U#��r�̺2Sh
����qK�ٛ���$>wԳ���WҬ(�f�������U�Uz�QH?���eK�c�]�xFhH��ξ��}�j����_��7j�,�z�H�����X���l4IiB�@xoݎ��%�����rP�� �\�e�=b���L֤��T�T-��I�@hk��f��MW��q4���f�]�ѾX��c�~��4���ۛ;ˍ��"�A ���L�l��_%4���ví}�.�B�@x[]G��XB�H8�jr��T��b��}_B�m� m
$�J� ��i?�M1=6��4�A ����ޖr���A���>��5���pt���,m���QSC]�8xX������j��Ai]���}�VfO��j/G�>��Z�Ѩ��x�����ø����BYm���Tq٫�A���8�n�$��`DB;�a<BX
S۩�Z�j�Z����Y�@�\@�y7%x��-�5���V�{Ӏ^2::ae�h� �T���j2�.�YC0��(�rY�6SU��Au��b�|���4��n�>m�{�$�6'����Y�@<�Z]R�1g	�A|��)4$W�2n�ZTh��c�E� ���ո�9jBܫ���[�p���Yh�	XCT�e�kG��|5?���m�LY�8�7��1���CU�j�X�ٲ#�)lګ�u$mq�DD�;+I�JhI�Zh�Ah���A M��"2d4eT9U�@�ܦko+n�r'	9Xh
��_��3��vTB�88��$��k�z�}� Mq�B�����[K�$m��"�A |Q���/z�"���k_$�.y���7�l���-4�#�oS��e�C�A R=|�c���kF�RZHC��N� �V�"���_h����^vl4,��IC@�� �חZrV��A$|Ue��tS[��*a"q�[V�줃�tU�j���ԋ$�)4�$w�ڜL��lk�A$1�3��h\z$��4\��7�`�m»�*�X-���p�՗5�p��ZV�A$���Ο���v9�Ah H��5��]�I]�7����:<�����
��6��U6��A tmu��M��d5�H6����j��T��U��|c��$�)��W5��C����ޔ��v��V2iEZ�,7h݆���B�0(к�+X`"�d���a�ܱ�F;UC@�c��Ɣ���.N��j� 
<X�y�d���5�#�,	�]��)w�Y�8�A�:w�<�NF���*k  ]�EJ�� 꺲��-�u�q4�9ʹB�8�y�9Rķu�j��kA�SĬA }��Y�*UC8x���v؛҉f���A$�&jMV/V+kɺ�Z].���A$~U��>�d�$+�A$aMG�ɨ�������!��HhG�Zo�Hʫx�A$x����h,&u��j=���_�A �Ԇ���t�Z㳄���2��$2kThI�a�Oãq��T�j�v���l4�� �g�%LLFe�Yh���q��7�q���&�����O���~_�|s<ڣ5��Y�Y\T5��������#���;W5�#��6���M��,4���׏G[�7e{�! \n���h���e(^hH��|����l�x&-�i+r�Ս-4A6c�URh��"��t6�7����aB	�Tcu]ɦ_~�"ک'��Y��&5-^.V� �ZOw�xOW�e�\�A,90�p2ͅ��T�ګD��;ו(Ω�B���q�1����F���u3�dJ5����:a����e�k&�K�~� �r�DK&�uT5�Ͻ�� Q�8H�:9�9B�[ChG��e���Z�šb� �^��)˧���u�jK�x(�� B�@xw�ue�l��qh���S���f�<�M���Wӭ^��3��jm���AY^\}�0��4��".4$;�k@��`B�@?K�U�K���1kOxo�C�f�T�{��gSe�d�)�g�P?֯�    ����6[U�8�[��p4~arc�4.r�����\R������c�Vr����A��s�|����3^�SYձ�/��Ɋ��p��Z��U"�a ӥٌ��P5kw	x2�;��"�[\	���E�@Q2�/ǤA���z��NeƦ� �.�p�:���(�Q���R���ׂ���*5�����^'h�'Vj�J��d�E�5�A .�����Q}	�A�1�fcBp�?H�v$�]��1���f#/��q�x���p�QЙ$FU��|�n	�&�4��5�¦GS�e�)� �q�y����٨w����=�F������! <�j%G�U��i���exT�Z��A� ����7�V�̦�D�'|�7���(�"���z�4�6��~6kGnY�������FV#J��T+I��A$����'K�L�꒯t"�r-�J��TB������m�[�Z� ���r^ף�u6*U�P�)�k-K�j���ɉɨO~zժB��|{<X���fk�j*:����l�W�aĜ*������l��_���4y����{6[;U�P�<���snM�bƧ� �.� �����8�k����8q��.BCj�Q?睁����R��܉��u�t��\�A��?�2CIj�w���
OuB�ӪRv�U�r`�� ��?]	չ���bd"h�Rx��Ц�Qt�!���tu%��c��ґD�{�~k!��.4� _*�?�WK�i�ۧ�W2�$4���ҡ���&���C)��������*�(�Ab�A$9��R�2���� �7ߛz,d��L����{�J�Z�n�\u:|4�2�k�D&�����>���ok�L�����*4��B��m�c����¡ҵ$�>k��^̇���z��� ro��.ۢ�A@ty�9)D�o������Di&撈5��DQ��D�����W�صo�6v]�����(R��"�=h��ڵ��+_��BQ�/5��yq������7}�*@u�Y\�
j�i�����q�_�F��F�/5)WX�RS� B�Z��i��z9߷��)?^e
Mq�"4�)P��Nuw����o�<���R5���X���eP�YS�m�j��+y�����Q���;6ig_i���۶]�h�ؚr�?դA@�ǁ��{6km�{�L}Wwո1F(���5�r]o77������*��vqQ� "ڨ��V�{��).��1u�-���FF)j�؍�H]C��Z���ͱ�Z{��k?:��i�-:�/��YC�b� ��$4���O燭ځ�՝�mר.he�� (ڲ���U�Om�w��&��jm�?NԩDD{��F��s�j}l�V����s�k�%<�o��o�+��B^bJ��+U��^�;5}�r�oUժ��w�jU���i�]N�d�o�L�46� ]{�wyJG���k���
��� �\��#�������kSSpߪ�T�R�ۦO�a��D>��AH\.�����\nqkU�8<��>��ol���G��SM���\�jR�I�?��U���`��5����I�h����&��j\��e�Q�a�jǨ?D�e�AD|x�NM��觹V݆��o�Z� �<��G�:UC��j��"�'��3��v�D��? �־�B��[W�6��#�P�����6y�=��������ԩ�؞����AD<aQ��J����{�$�J_������b4i6Zf��|CuT�>�/Y��-�*�ߎY�����o����]�-��F�?جAL����H�W5镱a�ڷ�v�Ε��A<|�8ܾ1j�8���B��+4�i�$��H����D��q��t.���B�oSJw_T"����ٺ��_~�<�u��� "ڮ?P��ru[�6+��}q�D��G���ӥ����M��'lI�D_Iʡ[���
Q��-�&"�����R����{�B�ҭpU"�`�V��^�N�� �n���W��_.^z#d~|�d��� $N�K���_ι��}�./�=��;�oRj�*�G/�~���u�.C}d�.�u��|����|ۥ����0B�ӔA�j�D��z�*�Ҩ@�Z�EU��h���k]W�RhϫD�%ƭv7��'Cz�:Q1.Rj爨݇D^� ���X�۱M��5�A�Q��6ǝ�T�����&��ƞ�Ϗø��-��P]����|�6:�}=zBӮ[U�Zs����9��;S�pL���1i�h� 	(t��/<����E�A@��I�*Z�Ȟ�SPR!�9t��y� "��r�ԘLӆ*���
Q�.tE��� "�ֻy���钪�Wߵ~Ѻ_jR����*���D�𕾩ܔm�"�BhW��up���;���YO��ɰ��*� �����f�w�};:�/{j��\Ƭ!D5m�7z�{����U1���jR�ڴ���؏�U����E�� &��B��ʵQ��#۩�A�j��vv�n��fw�\":�����?��1�N}�Ք�ѩDģ�T�8�E�l� �fM��d�-&�J"�����(�<ލ���r�D�5���S�/�;7 /�B�^G�M#+���O�%tkWumw���q�T���8ڕ?��K����^�Œ7Z�,��/ED.�DD;��i���H�zUh����r&����6�A!��qN� ��AVq4�qP��i؛��q5��jH��nLa�@���pD��p�bx�:���%?�~N}}|J��+U���sl��1��iAh���m!�<�i[R�8�󅩇_��G_\���б�v�l�b"�� �]�M���f����qn��i{���f��#aB�22LG~2S�/U�@��=n��U2���V��e��E�� ��+�,qꐓ�b�jF��/��B�0�����O��e�[KK�l�/_�I�0ȗ��f���O���%��Pt6��뜪A \P�
$�b���9EA�����1(�A(�'���sU�@]����WhQ�w;��ی���A\���"�.%���	Q�#�iR��ٰ1us�8-�ٻ��r��"=U1-NjQ�b{Aj������e"�u٦Hh��m�m� n6S��g�`�v�hn���t1Rz���8�l���@8ש�����0c����=�A \x=��A��X�<	∜�a�X�]��vgk�)�Tr�������HF}[T��!��ۯk@U�@�i�ɓ�)[q�0d|Kh	����'��b��M��B� �z�N� �Zo7ǣ�J�/.ԝR7I�c��.4�s����Ҋ�vEր� �eׂ��A 9}�������闯ФA����V�qO��A �ϮiT�^N��9|]4a��s���{˗���n��O£�ւ��� �܊X;�h�[a��L��8�vk�s�e�U��tP�9�U�jW[�_����՝�A\cq{~�EgYV
bi�ZO�S���S5��w�a?z'V�P���t|i�ىy�o�T��be�٢K^���;i��}��[�HG3�u��[����6]�����޺�b�e��A��n>w�>�ѫ�A��A��Ib_���P.������z�1k'�~8hi':H��Ы��5��Ӱ}4�Vǉ7��A0������5;kL���iI[�	!�´��l�/�N�qL34.1�����k��U�~�qD��#�L���h�ة�s��[+I�P�4	"��<�����Jv�"�Lh9����������e;�A$\q���F7���*V��$����AD��nL��dr<���@�A��ÐQa�ATr6�2�<2�n��yGh Hǳ��U#%DU�0(�×a5�A�\`� ����A�[�����Y"Z��q�����Ѝ�L�����8��A��Zww��[��a�V9j���j>�A ]�X�$]B����}�tQ�6���!\�9�\�&7�v��A ��7�[�Ƨ���T"q�U�q����*4����m�@M�!Q����6��J��KG�A ����A t��U�֨q�䮻�jG����ݣtd�    A$�c5%���P��đ��},'=2CQ� 4���ց4�U�� rVS��i�z�g�֝�A$��~���j�@��2�BF��B��ęY+6Y�,�T"	k�{�ڪDBq�Ow��Qo�}���LC�ґ{�:N��5]���u�B�8(vc���6�"�)4������)�EV}Y�+4���3��P��9��R5����-�N����.�� �&g�/��I����k�3���sSEU�@ܛ�?��������}7�����A,>������Y9�r$�� ��g@S�)�,�D�q�7?�����?����T�F� �&������b��6u�jG���q����5��{�}�N2�-�����R�;�#�� �%]�@�"}]hHn��]A2�L�|$�A$.�~�>��f�8���AA�5�i��2��U]wڤn�V�TU� ]41�_��u�ǿJ�j�'���|�AD�����?�����8]u�X���9��"���W5����.�ۓ�HfS��Q5��[7��M_w]׾�.�ZU��8P;�,�-�! ��L|��)������ ���1e��Ib��	"q���v��ҕ[y^��nLg�6w���e�A ���:�N� ��3���2�)�� ��,q�b_�4�c@��?i�2,��~���"4�����r�R�PWi����p�� ���\���2=Gh�zm�{�����&(��.'�  �n�;K��8i��{[���se��� �OJ���]U׍SH��PfT	"
���4�?_[��Mq��W�ŗ3�t��pީ��#|����ft�qЅ��A�?�8�]���ץ/�8B�rC�:7�]jƬ�rޒ� ���aۮY�ܾ��������M�u��Hw�At������q���8����}O���U�kLV��A�\kZo�#ٱW5���7�����G�t_%딯�j�����'��m.լA �(|�a8�(�Ź��|�+��	`\$�R5�����1⑌��ʬA <#��`:�w�j�'"4�� Ý�R9��kC��Z%���e�� ���~s㧺�xH����z���[�0�j	�$p	���A�g��2!�ADS���"��S-��ћ
�g�D��G�Q��ǥ]�^��M�!]�������t)
�hn"4�͕1��.'���?�A$<�a�x�7�NS�\�ː}G����4���g=)�*�+�Q�!H}9|Pk�-L��AL�8��g:���QDB�@�k��I@��!U������1a�r'M�]��b�n�WիD�������dst��Z� n�x���iaY�]ӄ�
ST�@��϶�ʳq�xB��T�'-�t�AD��;���)��ԥ�˿���_��C��-.럄�9�o9�t9��/,� ���y��Qt�*�r	�m��l.�I�8�y��]�lF�j�»�d<��K� .����缺��Y�j	�ͥ�z��P��t�A(������[��A� �hk��Qd�[�.'��{���A7MoT���Z��U����`��#�1,>}�q��8����f�j��?mnm+�G\�V� �:[�Q~gf� ���^��m���k@Oä|���\��xZU�x�|�χ�m�Y����Q5��(�ۓ)[g����P��p�~#��S�dv�� Ff���9��-9�p]�*����7���q'���B�H����^f���[���U#�!.��Y�8r�m��dT�*	����@ґ|���9SuGS4��A���~{o�p�]8U�8���t�b��a�&5v�X��	 ��V@�6��:i�����)٧�g
�t�q���α�z��r̍��Z���x�<��^�d6�����k{
I��`#4��vԟ��^�l��;i7ߘ����`ٵ�q�܅���`����q����	Kh�Vr�<F�!��
������`�ȣm^����񕺌�����1iO�5���MRUD��a��AM��][5�Vrq�z*t^n)�AD<��G�j�jQ����$�����ԝ�A ���M&��A�Z�ny̚4�[���B�J� �i�M�altPh�h�\"�!,�Z���tG�	L�Q�_`�G��nT��>��?I�xEB�� Ͻ�Wp�E ZhG�9V�5E��t�AyK]��-ݤI�8�B3�1��6�.v��>����^� �v*��,:��D�5> �e�j� �����O�	��m�kב-	���*ԩ�K,n�s84׹�%d�λ�w�ytEGT�An%��x����\�y����ˤ|�A�m�Ԇ۱��}����T����Y��r�n*YSjAP�zʹZ�^���6���P�L�ѬAL-O/�a�V� $N�}:kMG��ՕK�T$�Zx�AH�/{�&6_EZ�ų� �Sv�6�+&���2]�̧|����TOI8O֓{�/�E��� ���"J\�5�OE�wÓm4Y^t�D����1�����x�]�n�S�ZT5(�w�G���U�ADMv�_(]_.��:ZO7�N�qC\}�F���ڀͻFvL���!H��S��Ļ�3�#��&Sv����qM�V!\��|�_�\L�AH�M�8�S��o~��5�DR=��v<�4��I�V"����F�-J"�]��`����F����D����n�/����
���R�@ؑ>�J���p�Hڋ��N�@��%5������x��X$^Iɛ�%��m�!��l�b�Ŝ�A �����5[헟�I�H�����U��;K���������i���A!q���߾��$uw��P�����?��fhh<[���A$��������Oe�Ϋ�Ѿ����o��ۿ	�F}�jHG ��w#HH���U5�_�d{� uUUD���Ͽ�+e�,��I�Xjb��������?�^�ߕƒ[7R���B�����xn����槒��*U�Hh����_���WJLѫN�0�f���۸���ʒ�^�0���_�����qv�S5����_���u�}���A;�a,� C�|2�P/�N�0n�h*�d��V�V5��u{��Kj��a$�#����vP:Kt��a,.�eZ�RL���B9b7���h�|�'	9X{$)��b�z�)L��hdW�aL\���L��aLO[�����2+WjW��Yl����pj�`v[�.xqh�4��s���V�?k	:{�~1��}�k-^�I�@� �S	�h6�U��r�0�vߞΦj6��Т�a(��Pʻ�Y�P���F�0N[E���a${rmﱣ��q�0�<����MR�8�@woꍖ�v����0�i���f���~<�5����1k��g�Խ�a$� �t0�FSox��Cq����?W��6l4�EgQW���PEj�'�o��S	^e*����1Qd��~���o�p%����	c��|~��7ˁ����"�_j
�pג��f�0���1l�y:I,SJ#��(5�sxU�P��;:��P��W����l�� ��j�}����ɪK�b�K=k�4�g��R������4;��)K�yU�P|�
d�hOf��a(a��0YN�0깸Ζ:	��"� 4����֡��Y�Pr������YQ�!5��}��a<F��Uj�jI�I�_�h���4$�>�yd�D��i�L�jI=�H6H�l(.6�����k��#���� �a ���j 4�=v���p!��n8ZJ&��V�A��B�쇻�cyL!�rxz[5}�/�~O铵��,5��w�C�Ņ��0$�;�2
A�7��{�T�n���$�4�a4����ժ$6��.\h��7O�������St�����9;w�f{eb��0��KJ����:D�Nj%~=l?]:����^�1.r����T����^�w� |�Q{U� ri��f{���42'��3h�6G�.�SHX>�0�6�OWץ�"��`#���ǣ�1�����a�3��4�Zڛ��8ȺS5�!ד��{�ę-�f��4���/ӯ 4)�QyU�x��ƀ��h*U�x���ҷ�]U��LwQ�ǖ�e��a4ϓo���� 4���q� ۋUq�    ��L��"���k/ǯgӮ�3��'��q��i����0�E��s�~���(j�jNX���w�xH�]&�!Q� �<y�tNŰW�jGw4��a|��0��?p�b��0
��L�1Oy>e��0�%G�W����۸"�*4��v[S}
m�٬a ���naɪ���Y�Hιy4eD��! C�B�H85�����.}.͎N�0���Y�Yf�MQ�#4���f��S{����Tb��]�eߕ�5�Kb{���'Y��CN��맘@����4��������+G[2Y����0�]��w��k16Yt�������ڇ��EDPh�?�?Ɨ�^2��1dGu��]g�HI���˱���q����1t9�t�r	�������u��30UC �i����Ve{����@���������(�U5�N����շ�Q���a>�51�UHB��l���N����.:p���;�"�2Q�0�&C�o�@G�e7�a|�d�AS����`㠛��iDG2�"�E^��0��od�� q�qNRW9���2/�t�M��0��;��M�t�g�T#a�ӾRe�;U�H|��jI�Q+U�@����\��(�#6��1�-�`
.��t�שF�L�l�R�D�jI�O{>�^�m���U5���!��#0=�6m�x�0:П���GG�Bu�py
����#��L-����������_֪#���-9�l����LƑ�u}�����5$��Z�*\쮓��P���`J�$��-��I�@��\����\ܢi����׋Ԭa ��~�>�AR7�^�0r\M��f���A<��V��6{�"Zj����e�B2��L�����g���TT�
��<��3�1��`q�0
c�8��Ó��N��0���N�V�4�eI�F�pݨ�LFc]D��������4"��^�r3�BwQǭ��u]q�-4����'�"c\hȺ��8���U#��,�݆n��0)��U��	���������BhEm����*Why��@��|�a ���ooϖ�M;��5�{moMe�Z�5E�Shm����'��ҝz�U#!v�s��(�������S�,�e_0�A(\6�;���d4�",4�&wmL�q��jT�����q�4 �W5�����S�_�4����܊�걥�[�g�0�²��9U�Hv�L��l�]z'���p��)s�n�U� v�(�l��q�a4��2���u���'bi(Pp��n�-�)�����a8�s��S�|���hʍd�mqK.4��g�qI�j	����Dj'){E#�뾂d�v�����t�YCr���e<5WT�%q����Yߦ;�ɨ�5���ߛ�LVC�jI�����>�ԙb�L&#� uĚB�=U�@r����F{U�@���o��� ��P�FBm�V�,����P�����/߿�ji�@vS�x�jK�������+P������<��o��1����a(]��֒�^�0�N���2�Z���A$]E��~������ʤa<��ۯ���i��
K�X=�u(�2�8i
�~���M�)v�O����_����%����Wg�0n���Ss����.������Q�m��5��7�����,[],�I�Hȏ}?p���,u�t��&4��2��Χ�`��kr�MY�.4�j��ޤ���z��B1��qkj`�V}Q$'4��Ӷ>ڗJ�V\�:�a ���<����7ERh	�R_	�A�솺�
c���������y&4�"Ogc����|�G0�a(����6Ah
��Z��}U�@h�=w�G�)�N��:�*�ֽ=)���Wc�����`�Uq(4�w�5 ��OB��~{o	T7y�dժB��*��h�%4$rj�)ɡ��|�R5$�d��<?2Z��B�@89��Y�Ʌ}�o2kH��]|�'��ljXc�eTh���A�r���0�_O���J���e��a$.'����S�Q�����<n0��7�	4���a(�\0<M���l�j
]z���L#��j�E���0��s��gb; r��4����;��\שFB���pg<�^Sl��a����kHRՒ�5��gi�gѭ%����r
��0����4e�4T��[��a$�Ss֑���Y�H��FTdt<�.]����&���ic<�qn�W5�6���ߎ/��I�Pr�`g?r3=_��B���`�%���R5�[���6iH� ?����n��� Τa(��~��~c��"@=k%o��#�W~(�D����#{�`��(�&����	ց,\�I�@��������j�T#�-��(t9\w���p�����q4*�tag��\o���h���E���0��Ğ���ɪSHЗ�K�>�J$'�~���|�q������b�Ay `ư�"�/[[�?[EN��0���V�����P��n؟֠ԭ�a(�U���#`�N!���<��4K��6�#i�GB�����Ԅ�W5��w�5 m��&4d���;��'�95v%�b���')�2����z���E�bP�d4xU�@�}���W�D]�H؃]��/8�����:��7����d�tgc��lY��T\�F�r0ioJqoS�KU�{A�Hr�SD����FTh��,?���rc��^�������e*B�Xj�ܱ�8i
d�j��ɐ��g+I�I�a$��u��g����l:�a$��9�Nd5���Mh	W�nl��[js�
�^h	�umM�b�I���q����#���0�]������f���»�݃6M['Ic�*U�HZ
nM�`����\<�0�|�u�b�i���J�UCqܼȔr�R�O�K 4��g��S9�ˡ�B�@mi�M�*OhHn�e	a�\'i��ޔj�F�b��0�[Ϧ��r\bq(��{�)��N�+U�@xo}0ζ��t�kHG[�'�r?�4djch�,g�Mqq!4��q���$m�E���0�)�_��$�QQ~I�F��Ս�kC����ͬa$1��o�����mi�|X�=���4?J��a49U�Ԥ���2HhH���|"xk�U]�@��L�A =o����6gd-<�I�8jΡ��&�*�U�@h��m��}�R�[ۤa �ɮiUᩅg�g��k��a ��'k)�r�E-��0��~��.m��Q5��;���TCf](��C�V�i)��^zJ�����[�����՟���^Hh���|�Y��0��s1����zx���%MFB�	~��wK�9]�c�y{[�CKw�e��0�˵ĵ���P����a:��	�^�0�gO���a�Q�}��\_q�������9u�j
ﳧ�)�r�کFҳ�b]()*_$�
�ú֒t����&�qs4���jyڙ5��[r�myI]j�@�a$�=ܛ�66��B�@�M�fc�_�B��	C!o�~�mMU]�����p%���Av�Gވ
#�x���D|Y)4�#O�2ݦ��X6��񇹨h����f��\Tl`%YLF��qS�>�ŝ��0�{��vc�u<�mtC�yr�)��V��/B�H��ks��O��U�Hȍ=�O��0Y�uq,FB�]���VG1�2�Eh�v���d3�)5��qt�@v��P��}QU&4���a�S�_G�p_����Ԯ��7u�-��0�*c�;�����0�_ol��;��-7	�;G[L�Ƒ�����Ꝫa�~,7�ds1�XhG���2O���?T������q���L��>GhH�k�Ҋ��*b��a=��5/hG���r��\���qЮ�����A�S5���oۢ�dt�Uh^6{c��dx��N�ScKĝ�F�,`�\�us^ҩf�7�K>{;�5$w 0�h��n��M�������鬛nmU�Xzj�?��;&�^AA�GT����x�4�@du�MFR�_bk�4Y�Q�0�b�-ks�����-ۍ9Y�F#	�8�lh�
�a$����Hok\�f�fZGcԕ��"T2kH�����`�Z+$`�@�\7�i{=�E`@hH�    _M[	-6�A M�
ӥ#�>/4�<��Ã�5����OhJ���:D���)�������֘���Q_腆��v�7�Sv�M�%k�p�f�U�X~>m�[IҌۨj	�>oL%vl�+��!G���qT���\T5�⯣�h��%��-n��М����-�9(ʭm�0�a�Y@�Ql�VD�&��V5���5�����Z�0�c�����Q꧲-�j
��^��t�fC�b.[2�[P�a -�v�Z�D�t��,�œ�����f�N��a �4�b�ܴ����.B�P:ĮB����a(ܭp�ekI������TB�H�]���ܧ�׶�(�3��K?2�J���a <9�vW�F�"Vh_r��j�E$Vh	�����H)W �F^[�`����U�Hr���͡�㋽d�0�a���%���:6�|$���_3ͻ�ul�W5�'s�zX�t7�y7B�@ȅ�o���09�O�a ܉`|$�0,�m�/Τa(�[Iޚ����4 �U5��°�No��f�"�Ah
ﰻ��#�M/ܤI�P���-륧­n�R&#�!������"l2i�r��a�IC@BU�[k��l]���oGk��v�����ݸ�],��&�\�u��[clՐ-K�[���ZK���t@����\��'˝5-�,���p-��`�ɟ�.�,kI��`no�(|iUC�ع_G�0�2p)��`��8Y]|'"�]�'�x�B7�Y�H��k�
%*(`L�]F9_�VK�0ʇ�8Mm�&�e�d�0����|�g#�9���u2\^f�C���`�5���a m��W��ʚ��5;��ޞ�,��t�jGem�)=�6ˇ2i��a�76πm�.�a5z�w��j[�?F�r�����[r2[z����x��a���Ѡ��iJ��&{zJ��_���p_M���a��M��l5]{U�H��Y���Ө�,�a��Q԰<��b���0�.{���b������Ti֒�aT<D�Lm,�[�����s���l	�f���򥆑p�ِ8�lRn��`H�p|����"|!5�糠��W�.5��B?��}�~+�+5�wٟLq�l5,ߘI�H�ܗ����'��Ftv����!]��g�h���8�,w�l�x+5��)%��d4�^z���*�W��2Tj	W͞M��j�,�T#�@�:']X�a(9;�(�F�zU�P}0%��UϤa$17ɳ4ob��H��F�{�}��|r�M��UH�������8�H� �S5���[K '-�@I����4P��r�LD+%�l� Eg �a u%� �d���0v]oL���t~Xr&#���Ϋ>c�-_�I� hg�/�f1�@j�u���AB�ĥjHÙ��O٨_�m&�-אt2�Pj	�%��������5�w�U$���A$M�XhʹLV�t��^�0�]	��&�R`�S5��i��fS_�jʔD�q�PC�z�����p���h+}`��/�Tca�u���N��kF����-�'�l�
C�jJ;n��#24�t98n���V��>?i	_m��L�(w`� ��5l�g�C�C�j	��kQ���~�Z���Z�̻�!MF�M���D���F��[��t�a{,)�����R�`��a<�&����a(��7Ƶ�V˳߬a$y��/r��^�0�.W�϶�4��

�?��.S�=Msk� �A ;��H�E�|�0�:O�04�HF�@!Y(#5���uN�0�d��m�-�$H	��:�N�0����F��F噀�C�gt=v��1��FVMU�MI�Tչ��3(5���;:+Ww��l��Ԩ��3�_W�Y��:�KC������>[u)ͣ|(��p��*��\j	�������f��s��R�Hh��`i=[�RK#��#��q��U�&���]���pSK�
[�T��kI��y�-5���F9��g�MVC�i*5���69kHD�d�a$<��c��Z��a ��pxo�1���UA�T���AR����0��5$�M6kq�Tj��=|�~�?YM��U�H<��
f��s�R�a$!��7�Ǎ�I�����0�����l��k
W��9�w�{>��A��v��Z̚�u���gc�r��qs��O]\�jC���G�&����U5����NOir��x�d7%/�
kK.�5�� �/)w�Y�H�����z[��n��-�Jca�n{�]-�f�u*�\<�I�Pr�����b���[jE\G�<�K�ࢮ��+���Ԝ�R5���^�)��邭�a]��4�Sel�|�VjI�׳v��[U�2�����m6��e2iH�S�n��`ͺ'�,߫�B��J�|gPj
y�Ǎe3uo���T�a�S�?�	&�.<�,5�%�X��7�Bq�O���[uԬP�,+5�����z*�l�tӄ��p_�����띭خO�7Ϋ��7]�����M�O�� ѵ��y�e/5��;qoL�<�[I�Z�0�d?���LE��R�H<�����Vr��K��qD�K�����A{�vww�*���TSP����P$�i�t}�l�?���F��ITH�[��C�V�P�x]�D�c���;H�6����R�8(����}m2�ޓ�jm��f9��0�Y�+
��֝�a�vG\�#��qp���d�p9[<,�k
�?\�"
1KC���6Zm$-�;U�H�3�:������0r[�Ο� ��Q5�'t��'뮖z�<��F�)fϵ���N�0���?W���vcqI/4�%Wq��7��_G��V5%p��vd0����8��s�O_l�6y��©�5�a�����g�Y�X8�?��5�H���y��Z�.S]/a����`�0��=�ғ���)"Q�fB�A]�[K��l��a��n�^�& k>.����溹^�2m�٬a �{�[8<�C����ay���穑�T�ЩFB����v��抰��0��C	���0N�:M+�����8m	#ᰫa��d4�\N�0����zo��h���5�s��B�0�W7W�NVee[�a$XE�*���a$|��=]`�V�2�GhI�s8l���4����0���D�
_@hJ�Cw�W]LF�6B�@x����S$��LuF����s��<����I��4"�U5$�o��[өϧ�f��q�a,u>Q�\��#��__�F������j���8	�����Oy��-4�!{�?�~��t�+/o��!ļ,��d���1W�a$���u˳��\wYj�4*�x�pղ|@hI�c5O�@4���e�a(=׌����A3��֪���7�qIF�w/hHͣH�7�b��.~[U�@\.�^AR/��Y�H�R���h��&�~�,�F���P|UܜCɛ�fg}�S]��7kJ�K��ŔR��P���r�����-�ń�����t���{2�k�a(��:��74���E�UhJSQ��q����W���,ʤa$�:��~�ް���e��0�3TO�,B�Z���'4���l37�j�ˀN�0�����������7HL��jHL �}����ZIR:t�jI����o����D��]�T�h�_�e�h��`�a{�jh��F�g���a ���}�n$�U��p�֧�Ʌy.��i���ZSsa��r�F6],NB�8�g�%B�
�-~�0��"��1GhI�5r�;��4@�HB�ss�Ӎ_���n����������"g]h��^�!̗�ѭ������A����?����c���"᪭���`��e�q����Q�u,�񪆱8��0�����E��a$��nLM1Ȩť��0�l���{�%Ȥa ��$��<F�����.Σ�H�����r7����%����$4��v2�PBq���+�nla2B��'4���6?���Hie~��0��c�&��/Z1	a'v{:��I(�S	C����(Mq�"4��vۓi���S'�?�a$\a��bi
'VhHî�%ZO6]( f  
���q�\�k�h��A��A�q0%�DJ�wE�!�a ��~:�}�k����N��h��S5*p���G�s@V��V�FR��;��H�e��0���`�+�1�����w���׻w�Ew��4�����踥ж�F��d�8�M�o�jK�;(�M��d��E1�a(-��kH|�
PhI��0���$2�³�5�O1��~����_(M��+oT���<����@V]��)4�����������<e��0�g��B����qU�⹜���7��Q^	�3�`kIfS�V�0rf�CJ.4��EE��0.�}��I���e�0�d��Q��V���B�Px���oMQ���ChKω�SUC�M�`"��\4�ܔkAf��UC����X�e���a(�Sk���7S��J�0�i7��Mn�*K���q�;��~#�hU�����l�<�#���9�E�^hw~}:[�t�h
Kת���{<�L�M�x�HX�Hx����h��5y�_�TB᪮u(��k
���6�M�!�qy2���^=�7tZۄ�Qxn3�L�V�n_�х���|�o}uҎ^�-����|+i��S�/��Y�H�T�U(e���0��[�b9-���#���̩�V�T��T�{��킴M��|mT"�W�*����*4���������2�Ah�{������n�0mm-e��b�C��vo*�c���FB>������0�+s셆!D~MN#���a "8����UWV@#i�r��e��8���՚S�V�"_Yh	�xL� �袿�� ��kS�16�`�a ��~��Pn��H�j�c��lsgר���躚��-%���y�r3�5(M��$4%�frc
ܐՔ�V�F����;�颥�f��ci��i{s��P X�0�.� �r�<�eA2i	����O���m:J�2�@hI˥]���邖͖�����|y~�3n��^� C��-[MFG�8�l{�a �aI�Fr!���G߹຾�L���dQ�.��Aў��8���Q ^�0�������;jtԋ=w�B���cd0}��l[��C�x����d:w�C}�UC�\+Y�c�� ���+/IHN�,YF��6��2YM�=��a$.�>���t���XٺOh'p톓%��K[(��a$�0�{�\G=��"�"4%Nsŭ�J�^n����4��Ș`Б��[8�a,yP�J�2�Mh�͞�떲Q�^�0rm�6ǽa��l�-�����5�8TU�8x��u�ti'Q�0%s�d�a�t꒱H�a <[vcke�V�;'�a$<���e8�+5(.6����7{{���,=���E��0��=듭�b��1�"4%��v��bY/}����t���D�mB�@حN{°��ɴ���+���3e����Vc���Ԝ]}k|&>u���d�a ������o�Y�n��e�B�H8��y�y�hC�@�b�N��~�q�3E�&��Q5e�kM��l5	�B�Hx��ٸ��e���0Ι}�Z�K'��V5�����aoj���h�2�@hK�����l���T��Q5���V�8�jJ�?˶��ɬ�UCq�8|]����>�U>?�n'�Q��m[.[ɲ��.4�%���a����s�P���pb�:��t('c�M�M�2��V�B�@(d�}�%��4p=}������\kH���4k	�m,	�uEyvŜ&�a\�0���lU��R�H\��v?l6��T^�a(>���g���fC1fEj
O�^I"�6�a$�;?�lm��p�d/b�a0|)��`���R�olU#��L��dե��ʫF�n{��f�"
'5�iw7�o`2J��7y� ��5|�̦��֍�a(y6�Z�Tc�,������FR.bU�F�Ma�g���a ��.l6Z+ �Eañ���qk�P��:���4����v.�t��kH�g8Z��f�7e�0�eׁ�J�0�<׉q;a���A(m���Wp��������L|6U�@h=mo-A�l���?�a$���;K��l��x&x��G|Y��f]�jJ����WK�F2ۦ�(��x�0rd�gK5�^N^���ؕ$��a$�p�Ѽ�v�*p�L ��ǿ�ۿ��M�H�      �      x������ � �      �      x������ � �      W   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      Y      x������ � �      [      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
j��������<�?��KX'=��W���Ĉ�A��w�?j��c����N+�gk�t�7�"��?����]LL��)&���-U�K0��SU�D��a�.�h�����eIv�Ȳ��U�
�21���ES�D�mE�z���7�̃!���6���b�(���'v72������7f�� NL�N2.Nn"�t_�͔t�UOu�#����������D�uԗ]Z��"��I�u`�{i��i+�8�Ę��#�&��Od�I6T�N
�ֱ̪ӴtY)a��7����xc?CeƜ-�ޱ��e�w)�̖�bٕ�����86A�p�CO�IЍA��y��+:�B�lﰑ�~7Hf��0{,�ؑ�֍�xpٟ��%�\Vvhg�����О虝�܊{�3�q�� �1jם����z��m�4Љ)���HEY�ň��R-<7!�T�~	ӥ-�"�(�¿2U����)R�]G7¿3Wb�֭�Nq�e���"b��BfK�Qu�L�P*��e���	�P:ؾn����ت��z��㢌+P&��B$��uX����VŽCF�ƤT�iLFƑ�Fs����q�ax�;2�pȇg}k�QW�á�:��Ýsu����$_ɖ'����k���n�)u:qBy�͗�XO:Q��i&ѿ2�e�=��gβĴQ�[�ǟ/�"	ycB�oY�tac�H�cLtc2RE�d~�4�/l@�?�D�ɢ�L٨��.���@ �\��cTښ�𩎭��&Ҍ�1"tF��E�A���:UM�hXsicJ	�t�>��    �|<�|9��풐~ղ��i(}�?<���'R"j_�Q�����:.��*���A?��38�׉�g0���s=��ŵ!����IEs�kx��FyN^k(���+���,|Ȕ���kQx�M� l���E�_�pQ��P.��[�M��l�D�j0Ѕ).�	[���P70.Dظ�s����0"��x���CC��3*����:��w���.ω)�rxF`�	0�EL��g\�I?81���	S&�;\�	�D��\�+�+�Lt��H�3�2`�����Dm���:#.N��^g�K�y��AA
�F�n����1㢞���d��.aCAZf�n�ݥ�9CZn��T8��ץ'F��:�k��lu}и�E��orQ}'���D4N�	�b�qqa�|��:�+��H�J�����IGw-븑��:��l�>b��oxc��²�!"�o�˼K^�M.�����)�I�$v_}���5M݋��I���)�7x�Q�11"6P�!#��d4�I�L>Oc��S���Y��Y��.���0��y���\�}����N��E��nr�%1�tֺ�6ԧ�*����'[lN�P�t���g�p��7�h���Q�l\x����uhh���>���"�� ��w��o�'s�R�}����؉+��EL�j�y8�T򤱻��znԉ�j�ή�wVlD���8��ؤ!b�xB�?fp��J�c��P8*�h%8	"�(�1����'�u�E��aVt�	�o;H���VmԦ)����"bC]���i!������*%�eK��:�V���O�a)��0�H)=[�@ ���"�V��T@
o��؏)�~JH�y�g\dӌ�݃�B�0�M�T>!rFhl��;<Iku�.�'sx�Y���f�7[�b��p{q'g�^Л�z6�?v�ܔ2�&%Ù[A0Z���6k�{�l�H��w.V�8'b����������� /b��MΥ_]��r���q��I����ˁr�l�WA�ҭ��ѷ�3.P�}�~T���y<mĐ������#�Q�ox	�~%D��1u%D�������̈m�*��~iة��0�>8�0�	��+-"�W�!\V,�6��4]r��&����o����q2�y"3h�*�IQ��j��i�2cQ��Å-jDc	�V�t��,���Es���lل'ɹg�r���R���(���j�H�0;I�O3���秮K��������/�DW'�#c� ����﯊o��;�1LxF*���w��AbH4�ڀM�K��ߗs�O��sy�tH�L3	��O�����i�5���{E���-~y6D���]�z�;���ы3A.f
�B�1���V��ΰ1���|�P�G&x=�ƶz/g�|���)gqo4��,b��	��x�={+��)gd�A��N�?4��ôT��Ӧ[XL���6�.�ἋS6đ�y¡��bH�K�.�Lc�U<��#]3����g2B�V?C�35�S]<?;�e����U✀�*b���ϼ��#?7#Z�Έ�:��|Eσ��ӭ�Ď7��M�M�:vub��9��#��Y�F��K������Ls$���#��ft��B!'��`��j�&���:,4�4�e\�	���ɻ�9�~9r�̐~���A`ҷ2�)ΰ��A_/zר���vƅ��������ǝ)��Uw��b�����t@@z�ΨN�����a�`����w�O��wA��ϸrs!&L*�����6̖�wvC�N�	ߠr�Ol4�if(��|��0�w�
+�8�f�������f#"bQ� �@� F�f1!(PR0tK�]}
��, 1�𮵡���U�$ݥ�����W�6C��osQ�tB��U 		y9	�$H"��BЇ����î3����[$�<�a5<�*���!2���=��׹ �fH�s����^�DLe@]�>(�����167��q��>��y[��iQ�U�~�v�Y��%q� ���/ �\T���;���&	1s;HL3�F���L����}���O���ǂ��t\@կ<c���+c���+����>T�C����<�N;�q������v�N����_�|��G�U:�'�6�}p��
�cf�V-KSX|�����aR���#�y�z�
3���֧!����Mn\MV��U��k2�"7��12��
c�x��OQ��\'YZ�v$ֽwس��Ę�*>�q}y����5_��_�h�ġ;'���朘1y�lU��(�"6��A�*b��Q�E�gD,����{��߸:gWOv��x�ȍ�i';Y*���CL��.�_I���_	#�n�<ix'bZ�s�֙�Uk� a�:s����I@}�<�pEO�va#�"6�Bd(��	-Q:ڋS����Ԗ5e8�J�����!��33r J��b3����l�y�7c~1��g�y�͝�	ܻ�G*2�O���Td:r��+2}E&碭�d\�Td2b�i!%�%�%�x�^�>f;��:9~�3t�F�^�?S'0�Xq@��Ӝ���sr��3��Sy�K(�����F���\�cȔ���[�ty�z�S
���"�8cLn͆Ď5�� �g�B�Ӈ�S�#�"2��u�}'O�;��Ǩ�;#8Yj�ʍdC��H�����`�,ò�.��$�q�m0���TĞ1�׏���O�����?^~����o�KBׅ�8Cct�]���1+Iv��%t<����0�h��G���-�#mb��1"ֹ��P5|�6Y[�y';T�2R*f;AU>k��v��'b�ѷ8��4�&�~�iD�v��Nx�yU紆����0�_:�iư���)�&�[b�����.d;x���BN+�>����'81m٫�U�����1ї�r. �:�eP��A|*F=��#qy+P��r]#�f�<�2K�ǐ����F�',�?�VĈ��mC�����F��RۈR��m���O}tX�e���7E��2[��ϰ��x��z���h�i}9-�B������u��i�l].ڢu�D_����iVw��8��lX�0�S�+C&����X������i�\�1�Lt��!C�Ѱtxf1�Kv��!�����pq���N�����BZ؋�:� ���Xs�E��"J1ÔW^�p.r�f��`�LA���#	֊[DLq|�� ��noh��5�N]}��ֳ���G�נ�Z�>�	ӛݜ�8Ks�JOMT�dƯA���
/>úc�j�hU�Ҫ���L��儏d7Ȋ˔\�����!zӁq�xS/(��}9'�6��:D�v&���3��Z�5�����9a�Z��F_ˑV]DL_��������{�\wb�L���-Db���:{�,Db\�"=z 	92���\�QP��6��+�#m+#3�����Zn2�ו���o.4�3L��w�6��ʛz�{��
ṺB*a�1��{��uM�ǵ���e��mDb�����be�ʂ̗�ΰ�O���ȇ�˓_����\�� "r�͗���\^@���N�E���P�S*<�V��0�@₊����ī�H�KW�Ak�%�v��\���֧2P����R��Ց��^����Ə1���1.d�@��Wv�����."v������0���!.�U8o4K�*G֛�0}�<:�(�⢉�^��9�P���%��b1&�Y���t��^,ީ�GNL9�e!�t�M�ԩNF���5Y� r)���bj���rМ�6%��El(%���tF��t����-�U����3kS/����mp2Z�wF��;c��*���<���H�(磝.����2	���66���Gյvb�2�?���c��C:B۩$o�蠶ӜŎ�l��X�Od�3S���NN�Q��2��aC]}������fd�\׽e�����"9�6D���6<qa7X&�5L��4T���S�����6��=�:�u]�OKo��嚟V���9�-ĤTK��E�Ē��0Ԛg�Cn�e�R�Va�W`�L����v��Va��P#��'�
#a�o�z�IvҒ��&h��J��>�ށ �����6�Ɩ�12DzF���|�ڞJ�>�ӡ��41��ɨ��:�g    �C��o"����py���?���[/��u�,���lJ��6�*A���^>����y����rKF$<ҼD{�6������G.ڊ�D_�¹ Gr�˨雍V�� �B�w�dil13 �FF+��1��S����ɻ�3l,d���ClY��%��M�ba$?��@�m�v��b��L}�6v�t��1i+"���>�U�Q���Zmz�ܶ��0�6�!:n9h��k���V�SB�C�G܊��q�f1��~�GH-�F��e3���Om}��a��g�Bu���"��iѦ8����L����a�Q�Am��t��	��J�2_~E5)C��Sǜ�R�r�Y��!��%
V�x��چ�n��p�چ���\�-Z4Ê��E3L��ݰ!`P�}����P��>1��7ILp>���c�]��	ƅԂ�&RZ�	JY�ye��7�A �SijXudp���	K�E�f��G��& �2Ȉ�"b�*���֗�.��U��m>�q���3�D_���9���F��m�S�4v�gi��?��|}�����O��G6R,�	L]��"6�����%T}���W��̰��:�G�Ύԑ��-��(������7E#�>N�<���:���X���8�]��g�0�Q�0�Ehb2XN�"bcR=���{�RTeiEL�uK��Ӭv���cKJ��Sr	��E��ln��^���%��������.b#��P�'��{-|�&V�N�Rmw�R�e�K�1�]��k����Pk�3l<8�Q���"b�+���㏿?����H�"�?���\�y�#uS�oa�ɉ�V�v����&�Qa)�u3L75�8R���Ϛ^^�B+bd��fv�b��[aBC�5"�,'���HE%��h�Cg���)z月�(VA�q�$����\�0U���ʠ|4��6�\O�1ɸzr}
E!<if��N�'r��T�f�w���z\��4����M퍝��e"9�7��1ɔ�^����8
�tХ���FW�����yq{؆��[	��"�;�ond	���l�{�ͯ�,��af�jM��k#��B<�&�$�>�MĘ�9�);T|4�����sQ�
�Vm�J��
��z���U�62*`'�7X�4�F�b\HaM��������5	m�8-���>lL�`��~̱m1]�CL�"�M�����cTPM��`&��
����2�W%�N?3O�g��<�����_�R�J�vR2ޔ&�n/���Mɪ}mR��P'��l�ɓ1uD*<qB1�.)v�G'�<�ui.�X��W�b"N����Zz2գ�YĘ���YF�c���2<��6�!n�M�rp�
��y����6^ٴ{���(����ւ�'��s����#��Cd`i�]���u@���׹�u�>�F��7�$��\T`�������чP�V�+|��j��0��W��3,"3Ү�萾���+-nB��;�D]�l�ug�B���%�������;T�-1���%�^�������K�6��z�%]��<0t0e]]:��H�lG>�H�IQ*SGz\���TU��I�����>�]�������>�x�����Et�Ǹ@w�� ����#v�Q��C��d��F�Z�����鷚ѹb��;�q���,���<����i}�Ė	W����J��W���}�2#���t����].��AElݮ����i�����Mu���Hէ;aC�C���� +bcO����*{ӵa�q��'$aL��l������f*.,bnS�&��i�Մ���_�ҰѦ�u��r�V^��S��1,���G��K:\t�Y��V@6�Jp���Z�7{a����c��:!S*��\�@&�CF��n��\�*f�d6�6T�����l!�n�b�n!�pQ�;�\��;��V��1�2�ț�Qi<5w2��uFa����"{�a�Z���������al3&R1����&�|-����1y0{,ٙiű��ⱡ�;K�"�-9��:-$]Yג&U�����Xi<�{0�D��A0w��2���%���P������l�V�^�O3Q� ��m�ryn���|� E=�1|��h��0�lǉ��]�C��1�[g�-���VT�g�Q�߈���_�_l��"F����NgZ}��\I�8&���5מ�k�d,j��=��&b�6��q�Ji�gSd!��X!��P��\RE����pmK:��V�>;�F�-NL�9k�grP�����U<.0x�"Wة	ݸ�-,�ۚ;+.��S�0\�w��2A��W#MfS��t�J:Qo��EC��a>&���R��ř����a�P��q�a�#�*�3n��U�/L+�@bI+T�br�����u� �Zk;ȗC�3LӪ頟�6�^���Bc�,b�~��w�[��5GڄbN���VV��$.�ڳ�;<ҥ���?_����q�4L������;1��O�Ѝ����&
����g�RNGF����Hȅ�2�"�����ӊ��@p�՚a��I0a�$Y��xJ}�&bCB��a��Fp�nk=�v���iJ��rخ���C�����r�a'�a��B��7"6���VL��ʵ�Cђ[?:I���{^���3s�H���<o�3�<0<�a'��lί��Ǘ!v�����l|�;pfE���s�����"��X*8��*@ŉح�A�e�.V���J2҄�$cQ���c��^�>l�^~}����s�~���8G���Elh�3��g�������
��Z��*5�kM+b�j6q�`�|Syؼ<�`�� �b��{n���χ�����~������}Ǔ��s�.�k��JĬ��YQW�T3l��e�w�ɟj�����wJ�)R<R\t1~���Ʉ�fT�C�`1e�kpD*����;����j�������l�!i��q��d."�����Ҫ��pETV�^�0�b̆�j��E�\Y��a�K��G�ad����p{DV����5��`��V���,l/T|2�W�>[�����3k��uĕk۽)�R�|�vNB�_E峜E��p)Z`54I��>"榖K؈���vRW.$�/[���0V�`�c��t4��o͊X���[h�X"��~��g�O��0m���ؒ��p���X�w�pl"FS�V�L�h�F�͗)�%���8�6"��W7ò'��c��+T�vGU?�a5�X��.��X�'b#�_���)c谹W��#�O�vh��> N5���G�4�i\����KG��!6�U�C����_��j`�����=�ka��Qd]��M/b��Ϯ����}&�^�����p��m�l�Q�<6�n��Jo�_ۣ�0&=�x��*�X���+$UAqn��ߋ�r�)�ȵxRV�)�͐!6��Ԁ(M���^����v"v�1��,��jBK��MF�:s�ݶ�H<7N�zX�EB6Ø�⻞L�i��%�UY�'6�T��0$+�<�KTE�DL[�vn,�4�P9f_�I;���Û0�N�i���i��%ܴ�1e��Q!	��G��*�|���QNS�q�����,Ml�و��_���2Xv6Qd��������ITLm8����W#y�d"�IMؠDF����Z��ɰ�y���B��;�r1��t�|����9���7(��4���(r�Wc
9�6'������JGi)�f�D���#�/��C�ߓ��iT�N�Rԉf��y��:�pK,)���8�@�9_��A���Vp�k��mur�V#�u���؝��ucr� n,�-��*+�Ĵau�/9��i-�=���B� +��q����z�FHk.���r�W��M\_���Yy�Ӿ�x��-�BT"�Oԗ��l��#�lPmʦ��4H����I�Z�+9S�g�������1I�F(�� ���"v�t|z}{�����_δгP����X4NCZ�:�,��u��z8@<�s�@�a�� S�d�k�0��V�ȅi�^�7`=6�.��v����w�;\H��6]��V\.L_H�DJ�� �u碳/�TR��0�_�'.dK    �mꫠ慱>�K.���	P	{3{3��A�	f��ֵ12�9$57'2jj���ԍ�щd�_S�S7HI�%�.Z� �隝��͈�4���+�:���T\YO�t���*�ua��%3��j�_�[+/�´�Tb7:�\l�����&	#Iq�k�����1Zo�B����Jb-J�3�2��L�`	��"	/��݈cOK����4<~�q��x^�H�,��d}��IW�;��$9�x6��I����)��!b���92:��"G5S��F4�ɉr����;��9��O�4Z���o�H��Bb���L�0��)cn�F8/���M��F
X���������()�O3DapΒ��f��t��M�_�u�B�_�O~q������z`2I��=;6�Vѓ����i̞�NZ�qǸ�t�,[EkN�ak��8�����Jb�$�D�K��d%��~�?�Pk��|ƥ��%�(kί���ݩ9�dI!�m���ò=�-��S�O^�	�Y�&Yܚk�"6`���'"�4�C���C�II�oOi;���Ϯ�~x�g�%�2B�s@9��������\�)��EL��}Z}��w��2r��Z��SZyUZ��ˉȭ]�(�]���� ��Z"��e�\��N���f/�6W��"��%e{ �+�� �i�嗛��zI�l�U��a��n�l�L6\~��ת��0���8��T��#l�t�"F,�ِ�\-���Z�4D��E2aHh�E�����X�|����j��	��̂f�a7�0�2!C|')3&�CL��m�����COl�DL�g����`K��w4�1r��y=\5ɻ|2L�z8�E����}{��U�≱�w��$M���q�ًXG���z=���~/XD���1�/�S��r�E�9S_�'6�-~YvTe�˥.Bΰ;=�F'w���lvh�:1;i>kN�	��ؠC@�w(Z>D�]�?ʏ̼mΑ��kg؈��ᣩ��yG�4#��T��lE�@�1c���-�U�|�}��q�#b�����o���[�Gޅ�VN�\�	Dd����B>;�]oI����څ)������hر�C�t��i�'aʖ��ll�"r�%�q�p�#����<ZNg-���$��\��	��u�1m �H l+�Lb�a\\<�mr�����p�9,��݀�z���6��wb�>�x�]Ѻ�alj�B�IԒ1��؇JĮK�#]�v-qh|m�&�\`�_7���ĵ�wr��q�X�"[�4�5FD��"�}��+ȸ�Tu��o�@C��%E)̈́��;���=L�����o�n��81��������Y;K�����
Ƒ�ұJ�-"�>Ǌ��=X�ms�يR��	t}ex �dD�]�	�&�y�Om�<S�儩���B�7����8�B��J�]�wܡ���T��@΅�E��T����y5�c�����g�[ �vC��)9��o��-$��1m��mM7[,�����Zm$��f�h	a㷵'��L2�4e6�M�(����8��%p�-�V�P��Y_J�WY�����E��8DӚaRw!�a�+6o��|t�$c���{����\�wk���B䅅�t �����y����R��'6�#Z܄�g���6�����4*�����k���ؿY�`����n0�f�4����U��$��Z�%���3��u����{�)�N��yC}��c�؇�N]]va��Ixqa�!&��l)9�H���SZG=.e��;�L�����k��H�� �2ݮ,�T�z�eZ{/��2LY���1j�-�ʹ�P�:�R���rۙ��j�'bc�:^���ۙ�M-;�����"�hq���Hkm�O�Ĕ���iٛc�����.�WS��g�aP��������n~;&L�5N���!tGP�e��<Yt6EӘ�aq[��r#��!ILʴ��)���ׂ��CL�Ћ�+���`�^�=���>�Kx��z�!�ǲ�<B�A�M�〦�8,�g���*��
FI�~´9"v6���zB���Q�k�/��Ỉ����x��6�\�dw�u&x����W�����K��E�H�q*yF���~���JLP��N��e�3�[�T��ݚ}unavO�[~���3���)�1Y�%Hi�僛ELY��{ǜ%c��Vl!��*���Cl��������U5G0�|a��*b�9��0�Y\P�^�6�,"Ʋw��L�׷_ʮ�㐰��<�0Б��12]{�,U��d��ٍ���\_5	c5�XZ�9e�.���N�n�e���3lͱ�4�&b����7
�Xcln��0bX�zk����>������,�"s/��x�Ck�ŮJ��؀<���M2n�ݨ�S�`���C""��v7T���\NZ5Fr-��==k�f�a��;�P�uz��J�����z#�K�V�"v?	�#׸�f�Z���e�:/�)�cfx1UZ�j%��R��?OL�g/���b2�T�<��i����^��f�����(~�8�ڃ�d�7�*������(��i�-Q�ȋ�ȇs�@����g���i�E�h�=�8C��
��l_�4Dq�N���a/�_u.g�]�$(�Y��eZ�靴nY�a��N�yÇ�!�1yG���#*�m�v�#Sj�"a#}���@�T
36w81ON����<1ms��Ȝ��	�u)@�i��pǯ��,ml����x�c��ń�ΰ�9��S�0��hoLG�wu.mWl���H,�pL�P��@,��A�|>���+{����d��~⿽fqCc��(�-�r� �r*�!� 7�X\Ҁvւ#�m�i�g�9#�XEx���@�%q���/�3�������d�C�^�z��3�Ǹ��_�l��rb�N@����]�5�0a �{�l}uxZo8h*V�f?��U���u��D}�%L�3.�v�LZw.�2L3]f���Jfi	���u����C���D����#b���eu��i����Ͱ��4�D�1"qoz�\Ʊ��m��fnEL�IxV�C�m�sl'b���9r��A*�.M��ּl�'�B�d1u�W����aQ.�t�)1�T��5��=1&l�c�a���2����ԅ�]	H@��Rn�bd����	?��O"sDU�	K�X_S��.L=���MYa-��ؽ
{�kŲm&a�M5V�Xq�V���&a7%�:�½#��9H�`��n��q/�U��\�����cD����WZW�^8t���K�0�����-4zs3-�&�b��*��3�C���k�)���Gg��S�����}�=�ށ\e��}.� �-�
F��"!6RŞ�	�u;5�F��޷�����ؾ�o����-;	�,bM:�no��FAd����(Zn�q���ҿ��Xwzvwte�"�����"12b�voM��"�m�7sC=DcL�=D.�4�l�{i��E���h��a�d�hz�(�j;����Z�(鶄1��%$�['��2ke�_�>�FwaCW1 ����b��@����哛��������Yc�hF�)��>.��~�f>_���N�є�!.���HNN��^C�0��ǌ�X;W,�i����g�"�����[���3�*�ޡ����gi�Bm,ǔN��ۡ����~��E�;����ǂkn3瘺��ǊTφ���ȇ}��&�Ò�ެ��i�>��B���K%��~�C59�[��Id��$�V6G'Ǆ��ıh@x�1�6_�!+"b���{D.� ���b�5gm�����g��As�Ρ��l"�Meᡉj�1yG	4#��蘨���Ŝ��DG��P����������_���������[��6���	k�����8R�A5+�D��}1A�o"6��v�O�]j~x��V�c5t�\�e�p�{89cp$Q��h�����O_zס�� ��]�����_��7��$�������Vo�������˗��ȱ���sj�{�"b]��L�lN��L>ǘ(��vm�kXˆ_�5"��WO$������-����7*i]ͧ䕩2���z���8Ŀ}����/   �?�xy�q\������s�؞�cEU��ˇ��Rh�쒟�ƫ�u�9�&=+u&��nC�ku眘�`����r?�a?�Wc䘦��9	��Q$�{l�$�����i�h�
γ�6B>�	����Qy960��� I��"�58�����ۇ}�+2'v����,�D%���{����Ĵ}	.
��;:�b�qE��);1m�B��2P˘��&��H�Rc�D^��+'���
Js(-fE�9D�� kt�A?rn�'b�r��������M��U�SbDEX�l�p����%�W��+6z���jbİ�������d��Dgy��Mo�{6��hc_qU�CJ��-�X��$�<��`1��!i�����-a�s︉;����o�1��i�v���EL:3W�4]^>1C��+$��vك��S7�"�D�j��#�o\�	�;0.�jZ�?��7��y|L���v�⃆io߄uG-�N��Z���9���\�oI&�Ii.ѥ�DL����i������"F_,<�����U�Gr�r�����[d���2��q����c �zU��L�_j\��zN�#%�TӃ�����7\��55T�JF(!"�ϸ�ai޹�V�3����q$j��8.˪0�����1�6ݾ�ǺV8���^���ֆ��n1Up�����3�G�����F��������e,'�g�A&���K���j6c��32�ǘ���#���̬��pb��95D�f�p��)̱`��(�p	F�<&h��DCq���������5��M�hk%�n�j��qO�]���p����;�_��s����/�CC}�`�klL3H����D/��ě�� Ǩϱ�:&G�t���NR�Ѳ�qRX�P}�$?1M�f��)�r*)xf=������Ŋ�PWe[2RP�ol�����
˾���2��P��%�[��/�k��wl��FĴ���	\��t��{ڱCD���ۧ�h+�ȿ�����_*K�do�i�ˮ�[rbj�To�zDn���������� w���      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܷ�ZrY>���� 'y'�V��ƒeTI�n���;�A�̓I�`�hM70�5�}����uE�X�6rE�@�);1{Dҿ|���������u�����R�X�4:6�>�oF�v�f�o#l��f�/@l�6���b�V�%P�0�m�hͨ{ϓt�Ng��PW��+�8��h�<C"Y&�;����}u�bb�a�f�(l�?a�V��OC`h��Y�p�?�q���_c�3������#vb�"�O�kF�	U*��f���gu�9�br=�E����� ����;�Tx���.n�ef�Y9�9����-�T������ɦgq���[��v�w��<��9ނ��+K����u��o�3���%�x�]m��쇏q��v«��-�o�݃�)�s} +�#�Mrf�k�	��G�2��Z�g���k<� ~���HT��OTl���7W��;�����.����_I(��3?k4���0����K�OL"Qr�h����Lv;l�IW)�ʞP��L��w�������ԇϯf��5�n�ꢭ�!�T��!�b�^R4��F�WX� ��S$gTi�h��|g��ڳ
�G�ݏ�bjɝ7���pS+=�s*���4�A���\�KKC��~�v��X@�������xd���=��o����;N��{�-�z��rBn�-;cW��\Y�MXK<�� �.sK�=wK��&�M*�~��a:~�fP��g��Yhd���d���=��?���/�4�g����/��f�}.1o���~��P���ҁs1�P��ϣ%}�&�4��TiX_A���`�
���Y�V���y,�5��Y��_]@m⫳����4g�y��!�p��Hz���J��^�<��+^�L~��޼�%��������~���!�?�'��[VzҖ�1���n��o�\ޙAظ@4�N��]��R^sZ�M9�6S�7��p,�ET2eLr8��ϻ�c.��]���2|&)/�[_M�.(?�����F���bP�2���w�M���;`L����L�_�mՂ=�晏eiڸ�.��є��G$�i�%����4��?��[���$��_�rq����mx(�X.�h���@�fL�QYǣGZ��sZ�7FeY����=oaΛxs;�a�ZU�Sfh�����Ր�h&�Ƶ�waG��3r�F��ǻl�I��l&�p�IQ���.�T�bz�յ�#:-�jK��m7$D��|T��iOP�&ԅyr�-�dw���$����Q����_E�7t���7�i�f 6V�@E��������K4c�j��q��k!6��K���Ir�-��v��	�`m���g���Dy�)��&y��	A���ĥs,�M2�,��d`A��üc+�w�r�e�A2Q�����-2�5-<�wkZDT�U-<���Zi�Nߠ�Y�ct�&e~^�4�Wmڂ�)��d@���N@RDs" ɒ|/ )�i��,gAn�`|w�U���^O����U�\^�BpĦ���ΤG�;���W���G|����1����:Yъ	c��o_��[�h"aó�L؈��6<��6�|]]_jU,q���{j�:
��5o�:l�&&��
U0[�b�r�5�����5N^o�U�Fq��;E-H�� S���nzDR^7�HS~=�m��<��w=V!�L�V���E�����(c$�G�&�G3��8������R�y����-� ���c�B��q��{B}DTZu<�9Uu�Dt"WDH���l�[��uT�%*�UZ�!��lN�E^�/�c��d�AVH��e�c�^��Tp�p� �F
C(�V����l���r�6��f�ɓӋ4y��>��:������ `�@��ݱ`6�&*F,'�<�~��z�"�����14#	���k(����gH&����4gE�zh+6��
#���I�
�G.�?U���}�4ADu�4�%�^i�3M='2���A�YŊM���uK��1%����#�e%��_�+��q}Ry�*R���M&r>ErJ	t���c���p~��TL8�Dy,%Aq��z(=D,厙�m���Ď�"KV����87����;l RW$���h=K] ��L~J���4�>�9)��T�YA�\��|`�hV ')����[�)���`*��)͊e�Һ�Ӊ��E�|Y_�JT�Z����2T�H�4� ���l6�h��<�F�P�Fy���,�C�!v��Z��O_��ۿ��R����,�����l*��A��p��YyC�M~�]G3ޔ���E��7�����ي	��W-�Z�Z̺ZԿ���_?��o���W�X��t�r\8�YV1�9=��u�:̣��;̋4�$V_2U4����	�S�>9Te[]�,������0�Q\ֵƒ�'��X2bς�<DU��ܮ�K�0�����!Z�9�tFH�X����ؔ�������t��A2l��!ڞ��MXKk4yo���А��)=�������]q���C�+���[u<ERnZ�i�|kg}Tѻ�≍tR}�Wl8b��2�\�{���,Z�I��Ҍ+����*:1yƵ�Qh�y��l&;��t�9�s&��T����"ľǚ��Y�L��k:��}�t����{_�Y�]�gTL��U���T�f�bT��S.�6"*/.]�iyk�O�?�H��`EϤq�}7�R����QX����GD��5��sKw�u��2�B)�}7���?nSΊ9��S����L��E��'/�[�iQa��}������,3��uU��i�=��M�,�Y[CDm��`��gkhy�/�j5dOl���2UK��{�;V�c���GiR\��SG;�����$��:��@<�h�d���)t�^�"����*O���t��[O{8���,�;�S._�l�u��4��2��aWT4$�W/���?��lO�
N+�`��e�c��k�Vyz~)�xQ���:���2 �a�/"�>8b�����95+4�=�{�߉��i�
��FQ�o�gv��9��=�g�v�h��p� &����4E� ��3ҦH�L�Y�9hjG�,i1Y�
ǒ���1zn���9�Қ�5������hO��M��.����>�J[�M9'8ڜ���ɇ���T�LX�L���x��2�jVle�(�|���{�g�]��U�&��~�M0�ɉ�u�U�/�fJ���U��Swj3IYܘ���ퟨ�;\*���	kֆ�fj�V��Gӧ�hz�j=�[)M�E�w�d��d�Mٔ�Uˋԇ�'�ԛi{T�"-_(���v�(蔺�[^H�Cj��8����������t|3����im��22&���ݠT�!�Y��1\����~d��ҩ�v�Inu�M:EN�-��������O� b#��s��IMo�u%�T���q��3�Ǖ|���'bw�~xڸ��<����:��&�J'�{Q
'�Vi:a���'��\�(��>�ͫ�C��M�"�H�vrń�H4��3Ma�zHR��^��v���d�����u�3���$1�l�n��5qD����1�Nv^�)l��7B/��	tնj��*~}�����?��f�3^=~P����bR�n���f��8{@�2���Ul<����S��e�	
��-[:@38�xK�=G��L�+�n%UYIK�10/�qT�{5M���Y�lr����gۭ�*#HF���!�9���Uj��B��[*�	�6w�9�������nN��=4%�D�[]�Ղti�B͚R;���Ӯ~��b ������:�F3�7m�O�����Oj�6+�Ik���X~��E�>ԑ��8�=�,U[�!ap��Kg�S��&�گ�������ѧs�����e.�Kǳ�'���6ϊ�B���J�Rd_l���t3_�/�w��    ��6����"b�x`V�u�01�o��7��#G��x��MV�or��_�qtWu��A���-�k,����<U�<��������-��T~Y������e�V�kߕ{crW��ޔ��v�_9��G\AL:�i��e	\���!&������q*?�v�����W��C'@G�I��;�S���:��:� ���)vZ��Iһ��cD{�-��!='
�a��GueHu�[W��MF�j�^gK�U�
F>t!&\�xo|�����q����[d� 6k�M�*ܨb.��E,��x��Jvڽz`(�|�1j��*$�8����畆�e�.ب���)=����ڠ���{4㳵%l��ƴiq]T	����H��	�n��5�������G�G�v���R�M"K�D��'#s���,�5�P��B^C�$��i,����bꟀ���_�����~��ۯ�oSG���EU[���q����y�-���z�����/\��<�P�yq����vb���I��PC�9JA�wi���}���D'�iD��C�L�E�ǐ"B�/����8��5�� ��������� ����9oc�;���{��>(#��"���V1�N��P,	���Ǡ�r^��T�e̞��T�4�M�h1��壴#�g�f��&8t`o��zSކ���@(��Rn4?1�rC3��&�0��i���~�zj�;&x����Sѯ6���l[����d��3^����&���J�@[r�\0
�1���x�D�/�OCL���n1U)o�x��GH�$~�C �SY���ȉ�U�ޅn��L4w"jgQ�~�-�u~`>W�D��v��姌o�����Gߢ�-e2���TP�Ѓ�We&�}`'�]�iT<R���!�;�򣴠&W^��������~/��;h
]$-?Y��v���~��:5k�w��:U}��zx�|&�~ϻ��������ӝ������Џ�{�ETі5�D���;�� ���*��+<��2�)����f��R\��i�o��Jv�Z|k��+�+��PYR�o��}����OkFU�[�7�Y�Wn�<Sj/�M>��	%���)�>�f�f�@��ɥ	���CLp%]�]W�25Q+�Ӧwǧ�[��=�b㘝�`l�j��25.U�E$����|�&K�J��+�`�+�P̊b:a3&�v0���1�\Al�">K{�9J�֒gtu�.��ڲ���@oZe7	��u�#��XW	Ge��4�����+=:�����;;�z�2v����S��G��bx�|3o!h�Ï�/���wׁa��^�x��4PV��T�L�1++��U�+}���l��Na�J��v<�J�ן�ǧ��6Y�4@g�t��� �^E�m�W�b�٪�T�Z6�o;ǚ��l����ؤ�H��6�h(���;kߌ�����i*p-q`c�g��e��fC�F��y��'Ye!6&yfal�B�T-�6�E�ō�q�4G)�I�*�D=�ǈ�҉��|\�^/�2'2j�̚���~��Ik�0MR
�v;�x��y����ױtL�:��G��媌��L"��jD�Ȫ��*6��N��9��?فN�v�U�㬐�;8�b`�~$�{�K����̂���}d�V.?�l�{�����}9�����v���4��m��g������\��z�M�3+Z�h� F�ӽMO�)�#�-�w��=)��S���b���}7���U���姨��Cl���P�H��4݃��qP]仯<"�"��a:;LB͋׋*X��+o5�T+��d�q�����5�68����j��Sp�� ǀ�b����AH�
������I��(6�R#s��:�j�^���Hkl '6��ׄKњ��Ф���-���P�ၹH�a��tm�����q�V֖�l(��
y�s�Z�?a���U�t�cg����p�-!M����9��{���&��m|��:���^'�R#Gv�ɣ��l02��������>�)�T�(���^�W�������4�\��D�����c�zLoi�Jw�?L�Z��Ǿv���н0��-o5 ���| �p�k�-�U�̅���=��L������	3��leYΘ���2�4(|�lTBXF�3��Ф��-Q�8��3M�o�!i ��R�GS�8��{������;R/g��w��%$�P��SvA�'v`�3���b��*��,O���q|�\\O�4���`OlbF���S?�e�/Yl\��L�b�<�9WYS�dOd>Y��]Iq�Rg���=]Kzd]�XBs �	�<��v2Mƹ��)"��f��T��=TsbKW�"��x�`���y<���Rn�s�������|��|�9��S�ľ��o�������Y�ox��r?�q{���{�,����?r�?y7S�;��0@��y7�h�Ţj�uo�΁	ۭ��\�=���4��[�C" 6��ꕄ���P��0mEԘf�)bs'�M�jP�z����>|+ �`���i*[˿��ڔ�p6X�`ڷzR~�s
bl����u-���I�%�l���k���L�L�nf��)�)٭;OU�����{����"�h���[���!&׬����h��9�O��J�����ܩ�{�9+6y��ܚ�V{g��kpۤ�y�օ�8��궙|�a@�-�?0�W�EVм��.{'�*@�Y��C)S#�����(��s�g��4�0���=l�ۿ��f(eO
g!��ÆS�Ov������>��A��G�tfwV�A��Y�Jo���2�@���X���{s,=���7�5\���׷}���۝�Z��Q��u���NLZx�Z��R�6]�j��͊��jG���O`R��f���	;��T���o�����M薱L�N�{;R`�L9q���0T�t��`���
��I�q�2+<���b����ƵD�m����o �F��m#��*UW)Z��V,+�9>�3M��mQˊ��L����b#�n�?S��ֹO,�S�mg+_�4y����2���A�-	��;����=���{ѭ�nu�/�HP��]:qt��?�cjv��1�F��,5g6m�7�N�|���Fn���Pϗ�Vf{��͛/Hk���9�r;0i�^w�8�is1�8�+� ^�i���� \�2�[�6���<�!�%B�N�A��D���A<3͇���jj)�ݹ)�@`�XS<qWj#�6"l�Tf�.7����z+6������SµZv �ڙ�E4�)��z�\���Α�mR6�ƽ9�$�!�b�2慣��\cl�����m�͆جq+�6c�R��,zz\��*���b^%��1ly�R�V�g°�)��"jrÖ'��a�LӰC�LoY���6���X}ݕ�E~sAk(�Wx��0O�b�2�E���Q���Le�8�ߍ,|��7w䁽10·50�������؟�[�OT�����ȟ���԰}9���}y�[\�A"�Ak��gL*�H��t�6�k�F�d����μ,"'�@L�lʲ4v:$�+ja����J�f�&�!���ҹ-F�c�m┗�4�VN9�O�٢!!W�sW3��c�X����Ω���	5�3Z��;����mq���`#[�c����Mg�F��Ϭ��[��f���C]ٜ	
.+�K���dq�t�j��xԅZ�}O�jT�ݏ��g(Q
bǅ����?}��o�6�����S����~ٷ�I���q\X�j�%�[�U,=Alp�T�-���\ݸ�������v�2�4Bl�6�2�iSAY�W�Fɐ=��f�`S�#y���`/^_?��7�~��~��ft� =jb��;T�R~cm����`���eގ�ͷ�DQa��m?/U�[���jhE��|�y�<��Wa09�=$�s���6��9ҕ����*��E-�{����:x�}���[י���U=�៕��~�}�*���h\M;�	e��,f>�F/�0E��:jx�<W,结^�?��w+P�Vy�\n6v�h����Q/[�c�!&W.Y�ie����P[�e�x{�ߛd-gXy3�;�\�f    X�9{�����{�f-�~�m�;~�1��]�^�sW��	[4Tw���g�h�YL���
�TC��{�₍ܛn:v�w���MY��a=�Ԭ�5�^�YjE�_�-c�iّ�=�:�"@l-���*��	b{������]�gjQ����($���#�`���������f����]�x�����'���x���Q^����y��<����4"%f$k�z`5h�Z],�K���Y�`Mw}�G��M��[��[�䌆�b�;�)T:�Ejl�.�[���AlnI�Ε���� ��m�!yh�E�\��˲�2����s�V��F�ɵn�+��D�Z�r��ͦ��xS�1D��9t���7�5W�	�M����N�`33�M�W[��2��8�_-7d�!!���]r4�)`7�ۮ�����/��<��"rE�CSU"Ӝ:�k�4Blv;��Ȼ�{���!Sc����q��d�%d�X���`\��r�V,���"/��'��	ɓ����L-��p�_04)�ae��GZ��C�0��Iý��~(����q�L{2ԭ�\�P���3�\2c���[���[cgOP��-{���=��u^��iZɴwd5�&܅P*v��Lt�e$��z2h�b�	�}�SFS�	Y)�[��I�hM*��¾��*FtvO�>6�y���{�Ji^��7�-
UAy��c.B�< ��̛&����'D�VrD�;��������1 �VI������:��V����P�}w!����|��?RՊsz���o��L��&``R��M&����.�S��f/�^������X��wZ�_~�������S)�(�������~���/_����~Yl��d�Kr2���KJ=���ծ��wHj+�/������y����}���������l�S���?7]���Pk�.�@�p�K+�����Mm�M��H0��ҵH��Yo���G�L���b��&���/�2
ޢZ��ίHE��@�p�Y[x�h��L�޲�󓥆ز���P̥�7���FQ7�;Q\!���DRx�F^=0���Z�I�V(����j�d%O�C:����if\��;ף�#4h�FӦZ�&�����`r{��]�͆�C��BJV �@L\ ���#K6��=����m^�ɛ�󨴣�.Έ�� o�s������QՃ'��Z5��������� �Ҫ�Rf�`���
Z`1D�i�w���X�����?���i�M��D�sj�Gi|k�և�X���֝*J�Ji^���:� �5�DLC�8��tǛ$P7�b�����LE�d٭q�U�*
��&�ڋwq�&�?���DMiݡ3��A��A� Z��=8{br��.UPYC�+�Љ��>"�v��p�pg#�C0Bl�F�S��{**����&��4�r��Y�Uj\�),���V����`�@u�R(��EEm*8�͹A';G\ClP���O���/�-(�^���m$�?u���`�p7���
���&��cj@3�`�f�`{�A�/ei0��9겢�����t�]0�@�S�N7甃��sxD�,�)��S�bDlBȎe�M�u��y��w�g/v@��4��)�W��dC�N��yt���/�T���i��|���Z[�i�D�v?_0�i���'�� ���	>���W������X��҈��;0�ei:�X�;~P,���q*R�'����w��|�0�Zx����K��i��=*�{��I����n*�*���J�b�XM�n�&]ͮ%�ҌD3%�p�j�f3����i�(���r��>v��v�O�|�-Ĥ1߮8��t��^�L��A�n�,?g�e�l���"{y�qL�0CBΝ��3I�}!���o?��Ͽ��g7��"�̄�)���H˰��F�w�Q��hܚ���z�ݜ��Iو��)j��>�`KԬٌ��k;��}]S#� �����V�ud��g�pR]W��U�u�߷9�ҏ�ޫK,ڱD�C��3��o/Ɗ}D�?n�|1���/������s8�]q��n蚐��d�|6!}���ӏٝ�%�@�޿>ʫW��PE7���8�}����(���Z�R��B���*�UO���D;���K�z�w��/43_R;^���
�4h.�Ƃ5�όjǕ��⎮�h�-�@�~���f���s�O%� �=n!]t��o�h����|���#�n3ɏ�}Nzk_���;#ܕ��1��W��"f��%�irS���=I�/�ޟ�u��~�)z��q�����*���WL^��,�&����;�F�M6j�v����f&�k|����KcFk4�f��]P#���� &p6B�-�c��#�4ُ�$����3�m�{[�ݿԚ�����Q�9���;���r�ٻ����!牾�?��wG��}i1yե��D�a���	A�$\��ݕݕ����	��Dٝ/U���H�w�);b%�'p�����eL5[V�!���S��*O��ehc�ؙ`�)�]�vmB���?0�5l)8�#�9��=�D��>���0n��AE�Udw6����z�]��(]:Ҟ����8ȗ���)��0Wl���������4Qz�8���G�%3{��Nl�=���֥!�d*�.9(0N$Eg����m���;3��~،�繧V���{g�H����^c*J�]X��~��v��N8)hP���Aco"�v(N��L���	v�2�Z�7���}t_r,��P4�ҭ�悍Y��\,K����žSkY~N)������|͎��������[r���Y�mK�7�B��8��b�^��w�7���"eH�/�a�*/���I��m*��z�Y��n�(�7F��Zb����]�Z��)p�c�z��4Fp�D�w��T1a���:��-�*�X�k�0p�>|)*n��x��o[�"���0|#Qk)vm3Cp#Q%Eǰ`�6?�\iֺ1	jΓV4���K���Z��*�W��e��������?� �V���O��cv^܃�`��ظo����A�v3�h(�f�A<{�?_���K��!i�vx��}w�d�?�������]n����v�����]N��2���:��.ؠ�ܴMօ�%[z�VdabX��bZbϩ�n����(\���UljYa��ٔ��F�Dw����:@l\.��U���CW����W���er`#���E�+Ĩ~�f�E�.�Cl�\�����)4��ك�c^b��83K�`�%� R=����L*�t0ʏD�:�M�S���
��Z	 ��j`�K.������~��߯�����#��hݮ�8��wU˸bo�wB|�6Ʉ��S�>�;��x����~�߿����<��L�B�M b�(�+b&ܖF�s:���1.�:Hj�׎b\����\˕��>����Q�����s���\�avgr��B0������6=�?�b�.�n.Q�wd ��5�E�c5z�М��z4ҁ�W�b�"���F�L��ܖ�����x[o���H�}6g���z���N�5���Z�ӭ�/J	j˶��ƍt�t�ْ�Co?IFc�\+�^������͠3��I��~�`b��M���6���N�ju����il�g�?�=�p���[���&�FĘդ~�-P$_�ܠ���qe���\�e<��ɭY��x��A>��T���c� -}�+A1���W!�����z5�Vt�,tv��5���sO�`k�Tl��P�;6z��"�b���r3���T~���6Z�vH,�B��o|�$��ߍ)E�KQ9��^�y��:�]h1�|�������D���^[���R����s Og���~Ȇ�6P�����)U:�VQu�uJ,CC�RT�M̌i�ϝh�n��80y�MgӕN�ذ�i��ہ�� ��p�`'�S�<��,��w�5�v�vѫi���Orc��$�lk�(Գ)��5�]���w�u2<���@��*��$�B���2��$R� �2S<Mbn��i�1���׻Ȏ�v�Vl��ׇ���g�8D��ˉh3sݵ���)�$6�F�F���j1;p���$�wvq�* ��+�b���* �  ��1�$��9m��g�>a����lFA�o��#v�]�����v(�`ʼhD�K�"lf;��	�C��N[̖�G�KX؟�6e	'��[�'��3t�L��	��=<%X����є�#�	�P�qPuԾ�V��0��	�0ʎt�Hݩ�;�Ug+4�Z�E��6lキ�E�]�b���o��5d=���HI�Ąqkk7U ��Tmky*�Z ?��Dd�f�ʷ8�#?�ݒ�1�Olt�/��q$�T�;L�8�R��MJ�p�ů��6�[{��+~m\��;��f�+��9Mi����ǎ���j�0��ї���QeM�6P�	�r��u-Rc�0�ʇ/�hj����B���i�
�}[f������,� b�Ok��� 6n�����T~�1�80(tK͖ ����ںK���e�M*�7p0*�1n���{��6���ۛ�j��n��AI�pd3t�H�c�[;���*)����d�F)�d���F'�Y�'js��~��q[��y��z�E@M��cwNm��Zj����R���ҵ��ћ�{05��~��fJ��4Ҏ�k��@�ll��5��=b�܅�nie6�C���L�Aq������;����߂�~����X�E����.�q2c0��wV��̧i�X�ff#�TM�cR�|~4s���h>�-�{��=��u��o�1lF��c�
�F��:��͊���J:�����R��W@����)�Mr���,#�6�z���ᮘ�Q������-[�J�3H2��0V���lmcɪ�$�i��/��F��1�D4�k�䣉��j��U��]��	'��b+��v�sP�ߤA]ow��Z��ALp��^�/��YӬ�a(����Pw�&�zF�"��Օ��{;�����%��-˨�1�-��Aӹ-�L�Q[�F������60C�5PNo2����.��=��v0��?D��*���H�1��h�0�"3�c�mKn�Yg���]�I��	X�2.���L^-�Yn���޲OE��C�|w�*mG�!1�Ж�4=�4�1�����S�>�����>h)hN�n��4����V��YhP��ALx��n�G��਴X�O4q�x�$�2>�uCyD���?��M\�M]��I�����T�i<LM��I1�����"����z���L虅�[��u*Y�yK;��� ���'&/E��3S�M-2���r S��lD'5���	��u4�2^����K1��ѥ8Y��9d9p}�z�$L3��M���L�Ya6n*��v�柠 hj���[�x�^S�\�v�+(%`�^���I�b�ez�+��=O��̸�E�L'�on��Ls�+#{��.ؘ�},C�r�iOt3�f숖qC��F)�.�\�9�L�B�	����5��qg4�&*�uk��#y�gK=Z��>��]eb���n]Ń���;X;��J-�.���`�j�.9�J6��0�����puB}hsk�`뮎��6q��ǐ"���s���:@+,�p�xzu�6�ρ����o]Kz{���LqXy���RAL�j�H�r{�;�u A���ҝ����Ƃ��?��b���oɤȨ�!�z(r6Al�z���S�󖊀��/�e���S��%�(j�rWoFٌ�[�*j�g,���U��"KO��	�I*b[��9���1��y/R���>}ڷk�=�Y`C�@))m���k��{O�it�`��.w�ԞD�#�2-H��B�*��k�boM��;ޡ�T���RN�ۊ�A�c>��_�:�[��[�Mg�NSx�f+���v<�I]���e��⃦�����kq|gj�±�We�ڰ��;X�a��F&ݟ^Mӽ)IX>�!j�:*ơ	{x�ʆ��6
il&yإd�&;1�k(bi)�$K-UZ�&�s�fRK]�Kz�KwO*2� �29��3�V�dx�s`|��,&T�Xf����Z�?J�����Q��e�SI�jr��Mx�l�-�j|`>�j\���a��h,zKbBo���Y�O�7���11�9��1ݏTbw�,#6���TI1�"�kY+(�Qa �O��%��B�<b�G���ѩ�������{AOܟ#擩��8��7�Rߦ'\��qVgj�ڢ2��<k�KU��t�*3���Ē��L-�xr��Z�}"|)ح�f�'�fG�j)E"�p5يF�Ҫ6�{`��܏�_�e]I��p>_	��à��a��ՊI�Q^���f�"��Y�~��Ք�ڽ|w�Ole�K���
����2��ge^�̤{s��ͽ�LS�7�$�ޛ4#�W4��)	���T�+���_T��zM�H�8���b�7/Ձ=�H�hd�h2���>I�h���E]��{^�Ħ-jU�S�-zo��������+y�S�I�T��eGvJ�w/a�
��
\��Q��4��s����d�i7PeѲ�6��x�1�ٷ$+�V���n�e��Az��
N�+�E%	O��%	�L>��k��I|?���o���`l�tt��� ��*�bodPXc]�4	
�hi0��a� 6�vj�T15�ҟZ��K�2�gi�Į�iR�j����_��z�ޒ��_a�P�s�ӿHS~Ӗ�����-޴��e�
���-�6�8�M������u~�*i�� #��4�&�v�[��][��\��^�����J�w�f�9�!�&M���l�dt9�����7֭Ip`#�մ:��Q+{v�v,��v���uF6���!���o+���R`6�|�ћ_�8=ɌՀ���V�1��?6y�l'�	yF��+?yń#R������,g
������� 1e$]��*��dvRsaS�Y�F:�����s���!&oLG���\]v��c��y��s�_�̵o�ɛ�!M5�i*\���#Z�tm��b��x��-��$�e��ÂX�7Vv�Jm�v���[n�������T�u�YNs�EZk��B!UV��3�=�:.��Wl�b����D?讣J��G�L5�L1�w�/�dK��ɓ�g�}ؤ�|�֌W8�|�l�E�:u�N�)�+|��Yc�9���KA��!�FX��mҖ_~,ܠv���
?.�&n4m�����	9��a+��-�I�w�ňn�e:�\Z=�H��s����j.]���g��o!<��:O�K�%irM5���i��X��#�R�Ƹ��o�Qզ�V80�K���Ev\�_��g���W썹\�D%�)E��Yh�f��lm���f��1�b��Xd�:^{����M��:�ts#�̼3�*6�L]���	��Xh��ޏ��&5v�"�����Y�����I�nzWl����^�J�*�]>[&a�|0�l��0Ķȍm��%�"��H���'o����J�7�M�����H�,R���>�Q����X���>Y����p�Z����U����fF*v�ba�Ϯبs�7�/j4![x^+Y5��ׇ�}���FR��(�f���>�z������8!QYZ��k���zϴ;�I=�ش�~C���P��Yi����Lk���Q�t��ܥߔW�����/���*�u      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
����ۚ#��4�ۿB`O�~�[�Hv���ԲI)Z�� ώw��NL���/2�<�K�(��pxb,�)��W@"/����ܝ�U.�F��}��G���U6�pᲜ�aȺk�'qqd�N������EH?>`aOeל�&�c;���A&:�((�u)m�(8�B�(�)�S슚�x��JK��������H]4����X`���oꌡ
c���6��3`�7Ty�XH�G/w|�J��TY��G@�������� ��dQ�wh��P�=Ϧ�f$о��܁\�|�}��k�L|K��7�W�]L@�>,	���K\֮�Ʈ,ϫ�M|0�1����Q����x����D(@f�H%$kU|R�,�%����w\ ��=ku%��ŧ3K1��h��^�A���;���oX�Bm5B��}��À���h٦dW7%G�%IKHl��H"R��3/���/�+���X8#�ނ���Ṻ/\:y�K��X5p��o�-�P�x�V�7�vRx�:l{���#�^!�ߔ�ؓ8c�^��..^˹���}RA%�Q�zy�[���%+���}joe�AI��p%j��r����z��ĝ���0�b��]M$�<����,d��@�q�e1m1�5-�R������}`;�]�1�ʲx��5x����0���7ޟ�P����X`��]ݽ�H�:`fi:L5s�eqA����w�3���-:h`��������a�[�� ӗ�U��0:�����7#���� u>��*H4�䵛%�B7F��:R���`W��KŠKv;Z��x���?�8�����U�����'�Dζ�-E^vJԨ�H5zqa},�;r�J\��HSB�E���۠���bÕ�G=�����rH��Cr��U��.FS��`�����Sp���,�8$����N��⪃_��b�H���,��u�Ä-���Hvo�ޠ,T��~g��]%.8~�eG� ��N0���g�ጼ��_�B��d��l��$�)�w��#�X����y�}{�Y/kb�UK2�����k���EE�ɒd�Ѹ%�Q@�����B2\�Y�T��,\�w��L,ۋ3�^�1�C�5���&�2	����+qY�� �X�"!;����� �A�ת
;�_�ú����|�!��0t`A�Զ�rx�X��L_c�8�%��`���t���7��B�X�/|�/o���T�B�?�,$.X�Lo�	��[�FG<�8�ˋ��R�U5=�2��V���K�b�f��G��������Ufd�r�'��u��'+q��B����7Hzg��|x�oYu��ò�U���q�xw:�>�)=���Wv�y�)[�^�}yۺ�*��u��ɐjY\�]��s �����KN��������T����6:�b̖����j�l4?@qE)�W�*ʟX��1������I�����f�����.���N�>ζ�8�	��� y�����J%+	�Ӑ8b�j�W�²К̜c�w(Ú��h�㤧?	��BLn�z%���s�M�*>���B�    �KP�<�N�
]er0�j(K^����b�-P"�%�����f;+ӲD�E]a�0ٹaa9]�cakA�Ie�醕���KX��1H�֞��T����Wz?�Z� ��˲�?O3���u�'���7�ʁ�oWeT�M�tU�˫�-�$�=�Q��T|.0��E�Z�d�i8���s^5��u����������t�r�.��I���;6}�����:o���D��2�_$���-l�����M�D�k�U�}��F¬Gw]y:Ř� 1]rArV��"�٥��k=�s9L�b8�HLY�әo��X<Pl�| V�u�ۇu�eG2�q͆��]\��L3z]g�ǮpM`iu���|�ﴤ,�Þ�\�R��\���f8�ILI�����	v���� 1f�5��ʺwO��6���,9��I��`�C,Z�Tm��r��tX֣GC���X��7�˺|���xr�sA9�
�I���NQۼ�v�i^�U��TY�+�Q�,.Pf5�%i���M��*o��XJ�����0nž����Ŏ<�X����?/�Û���V�w���I 7Ss@���P.y�ǸD���l7���Al`��
e&�P��w8`��qdqY����� ���V�	�f;	�Uy=�I� !�E�@-X�#0xE�B.���8�������HD�1��S�v�������"2cIX�� ��ò~�X��b�g���*ަc(����"���޺�z�;��Kb��V��{���$���@1��VBֈ�%��wP֍}|���bmh��(�����Y��h`T�63`�MK�&-	��>Xl
[���}���RM���'��H��i)RR����y'�UY�+;��<�Y@]�Z%.���_������y�]l�������iEˢ�eQ��L;��Q�,�F<z�ރ��($�򀅵����@鲾�&7�羟�P�w����51�Ua-�k,���P=5Ab�c�\#�Y�dS-����}���������p�6���HF�Z|�Y|��Xs'w0��p��3�]L`N�8�y�ش0�@u^�!�|��˅��(����TbR���&u�0N�y���_\����h��O����� ����*$.,7���΃��x0�(ʇ׆;.��0���,o4�Xƪ+ 6���l߭w�#�}�}t�$t��6���Ż´�'-2�6����ǸΏY����L�Y�)ŨM�3����pUXh,��ܲD��ֻ�^����eax�^ٍn�.�xd�P��C�ء��n�o��gP�ˠ�I������R��eM~|�:1
赒�L�q�|���-JXmƹ�\�Ca<�]L�������\Y��~(e��%��N}5�4���cK���=�^��<h.�+&/���4�$�,҅�{e��D(����BF�,��`����X[<��bZ����w|E�ǈM)��8�[V�m�p�Z=8̩\�[#�� Gק����Azc���L��Ш��b��g4�ڝ���4�R�����=�!�`rqh0J�xɨXǬJ�楹Fm��n�=j��:���%�Uڡ ;h�8�#�-�c�4z-�W�i:!�<x��X��p���燎L���5*�#�[������i%R~�Vf�e���g�
�L��A��ȶI��M2c����miN;��+���=�,ޕ�|�3;o"�2@S��6�e��˂��ڵk9l�}���3�A�ń��3{mU�� c�*#�'�cw8/2S6j3�5�Ё���z�\oR��MZ��w��z��T3�MP�m:W�M.��[P��F��Շ�-���~,�32��˒�˯�\�zFs\�fA�eY]�VY�UQT�s�������,�R��h�;��0̾\kc�}#�/�SjE��W�V{vU`$��j��D⦭�6���c�)�V�VC���F�2PPL��_����Ry0�a;�}l�1�� ��p���K)�(�k`pB17�sb��co�]�E��݅o�o�]8�O�d)� f�F��m��q�%����w��=������V��P��et�����c�w�P�.��Ί��,.��	�y�� \YD���W���rؒm�AD���*+�E�r�a���ƱJ�@Y��b{���o5���}A=�1�׹}j	� *+�櫺���/V�W�Oh(H���$�)7��&e$6`��2HG5������8i)���V�s�� +ޏ�+iJ��v:�ٹ,A����ȏ�lB0�Lv����IO�$+�mvs�u��-�ڔ9������Z�(^&��囦i����F(�x� ��7�`���/嬱p&�5�A�'�X$�̫�O2�*5�|_,%�R�@Wr���>��և��J��_���o5�=���bb0�$��<%a�9!�_�m��qa�"�qVO=�X�Kf���b���,�i��6c���r(���歑.�@Y ��~%�ȘFZ�"��*F��I�Av��"�1|���x��ؘf]!�y�K{��
o��v� &@A򢵴���s�3b$ޗ��*@7��X�ζ �����õ*c#I�: 0;:J��ٮ� G�Vȶj��Eگ!�B⼹&tH��m�Ö�Â��`f��LM�����<�p;6k<��G�!�����r�������͐�'q�\�H0���h���A�.�ײ���z-p�1P��b�on�����H�߳�yAu�
+���7P��b=ߓ���!��߂�֡��Z�Y��V~��L��>OΕ��ݕ�9s�w,iU�\<vHqP��o��[(�L��k�1�$1�Y�(v��Y�j�������`��@��ZZ,霻b>|a ��i�e5seDb������G*��Xn�iT舱-�Au��Z�X����M��Qq\�,�s��|��rغ#]9�Yk�:kiצ�6X&����2ހ�xO[���%,�|Lg�y3��C~����o�(�
��V��`�<����Z�X�e��sxs9�+IL�"c��q�\dy��h�k�o[���������13��eYn���D�L+�kHء���i���k(�/��K���T���=#6����A����Ep6���鬿[c���`�aG�U;ʏS;��h��|I�����L���+.U{v$�<Ӛ��yS��da�X�X$���>�"��F��M���!��ɑ����u!񎅏(3���G)8�ض�`��د� �7�����t}"�xw/�_�y�X��f��������t6ߋ�L�J��#U�� EAq�����sP\���,;�JR����� G0�Hvq{g�i�D��<�Ѱ��n�v�1��I�"{(���ӝ��������t�.�CLa�K~�����+]����eU�̔��<w]mu-��B����Z̺�b�6���^���B��#�~�RZ*mQXN��J�dV��A�u��bGE������t}{�����>A�qK�2)>[$�"q�ߠܯ�*�_�p��7����{lX�~�?R��J�i�L�� �Ք�<�༆k�g���
�bEi�����ذ��Fh$ ��ߧ3�IN��ߴO�C}z�6�80�� ��p⚏v4IU�f�KR@���}��Y�Y���:a;Z��`D��e��
Fr�� 0�uU��XI�44쥡�x^����Y���(�5��`9��4��O�8��"$�6[�b��҉��q��M���$ ծa�e�}=�4�Q�_�xl���EawX�vX\)��Uѓ<=���^_v1A��i�ۡDp(�2"6(ދ\IYVlde�+�;K,H���;�b�9�i�AE��v/��8�­t�;���5��h]���p~m$aA6�M�`�,�����aj!��b���KK��Ȫ"�
,���Q%(,%}�)�JX�-@�4���_$�VL����N-�C����'��p�~܇ gVz�;0�-���rP|���`�G�i�ø��Jd(�P`����a���a��)$xz�3p���*�ώ=����qi�A�";�M��$&�w3ɥ����\Ml�`���86[L!����G�2s��3&?�ia�y�?Ɛ&����y3�fn�+ �{_h�����N�Z    ;�-�Ѵ��sI\�#�����,�"s	�	[�Hѓ����Q���.1s�7�	=�F��4#1i�×��^�r����؜�^�K����O�	G5=�j]� ��*OA�]�(�Db�ئ(/F������=������&��B]9�(�H4&+}�,�f���7$�5Q��$���_�Ęͥ ̣�paXM��N��.�FӮ����l�+J$����O�@����k	�?%f.�&�m�,n���.�>D���b$�#lT�m�N�X:p�{}|l	���ؗ��Ѳh"��6>v�fa�sj��Y�c�LC��+UƵ|��P`(k��K2����vQ�Bj�z'��&�C�z��Kt	���ޟ��%��C��tN�G��%=�u�![<D�K����p[At���Em��,ecJ�z>�!qY����Y�ҁj��C&l>;0���[{�Y���ʁ=���7�������2ͼu�5n�U;wɈhi�墾����Xv�N���/� �m���KX����d4�o����`99e6z��U��: �� q�p��� x\^�E�Ǆ�bJ�+U=��?q ,�
���N�����G(��S>8��9aQ6�#�9G��&癃�b=��$��E�c���M{k���m��t˲Һ�a�d1�J�)�]v�p�����P����z%�\wi�����g\��Ǘ�H�dR[��]^D:(��J�_[j��r(07�Ycc�u Z,��}B����68�,�fJ�!Y�_�����K8pbt�I\� ��Ƞ�?p��fV�%,�,�SY��z'=2O?���-bXq���PA�@$N��
�c�'�vw���r�}����=!1y2�q�ю#m.�i���1�'�6�4]�2���8J���eA������H��ź?��r�$⏸����VL�ط�.8�G"f�����X��HQ�.���K�2��P�b�ew�����P���U�0��{ia�U�Q�nYV�+��an�b��d1��yv(z[URyI�H<�6�w��ߑLή���DVc�^B��I/"�W&$��׭�_�}�����+��3�+��7���+Jb���ĳ�D�nw�G,�b��SV���YLJ{?��,�"(�����Ŧq��R�>���P&�{@�������qऑ-��
,c`��v��\�����f<�wq�\�>�Ώ�I]�º���'���{�ɂCS7��oގ���ְ������E�u��y^'.1�O�A�IL�򘂕i���h	lޢ�kc��Y�]h^��fS���u[1%ſ�>>��<-�R`*=k*uc*a����K�����V�p咰R����1k7�ar�8[,�i��Qo�8��g{���^X�	)�6)��9�g35�7�A.#�}�K�4��׼���P�ٮ�h찿�f9��_��Kb+n�_(�}hu�b+��*���WK��[,&׃+���ܞN�$�
J��.[��7]z_�U��2��+}�,��%в`
��G�C�L��G���zc��ƤZ�����Xn�����bR����6E�T% ��ω��}�6'�S���Ig�D�g;i�r�A�E3ɸ�����w1e] �/�ʳ�6g����MnѴᤶo�2u����A�.�|E�㑄�ڄ�:B���m���+�(�W<����h+&�������W`T��u�o��v�sPFm��"�u(�B+����Vw`�S�0�%��h�j[1y�/a�m�4�v*e���{���� (E�Ō��8�ӽ���i]���8�49a���I��6�����kqL�a�d�WzW�R��.��6p�s���z����;��@/���ƭ�����|�a
Ă-��b�o�,�h����]�drS���԰�H\V�$)NIaU��$�Sl��%y1N�怣2d�rw-D\�_����<؁ ��6�zpY؉��v�]r�,!�uNc�,&e����,R��*� �S��]��������p����Υ吽���4�����{Z��B��Yt�9H�J�]^�P<�/:��ؑ�G����*�/qr�d1)ʙ�o������+8�&B�Wr���8jb}3�x<\�Cv�� @X��t��������H<�Dģ�#|��V�JL�������ħa�ʢ}��h��l�E��
�P��p�nU��|��XU�xP�������ǿ������?OT9ߓGl��9�	k���@4�FΏ�V�Ġ��2������:�|���5�ε�\J\	�MѪ)F糘���@<čx)١�хH��
����J�8�<]�_��-m��,?�1�+%"V�/�ŕ}S��r_q|!���W_��Mk'<��lfȺ���Z�JyU� ��%�(6L+❏viE�Ŀ�U�+L�}�ڊh��MꞼ��K��s�i<�N�9�3g+.H��&0��5v�HɆ��t`��KO��o=�Uⲿ^��Q/	�zՁѫ�^���Ԁ��~Sދ��F$�U��7�m�g�+�oM
��,.���T�+C���~�������	�¤&<ĊEZ$V�e$��>E��q���2����7�l.E���"YN�|E-C1t���?*j��=�����qv��?���3��f ���71WR�UUQ�,UQ8w�B�,_Ο&�b��m�Ez\V�C��J]��JꞻF��2��L�|��o���"��a3A8�EJv�g�i�k���/�L4n0������_��ߦ�bq�lHQ���Ś� [e���Wbao��K;����z������w=�J÷p�I����͌��������=�5ָ�`�xOHr]�
����Nnqr�waiwb���nWv �#L3}_�x����:-���dIQbl�����xh*�Ĵ ��d���3��8Gt�^o!W��9z�/2��;)�b�(m�سdhH�@�WE+84����쮯3�UZ�`���Fl�z�mJҚuMهL�8�z�ැ������(���'��p�J��kqa���G�Ѫt��<�G�3���A����.��p�DJ���{���"�����jPz��pL��'�:��K`c��I��&NK.3��.=��P��H�0������iⲄ|�D:�$�C�֤���������_Y�z�J\��ᡰf�m1D�~�ې�I���զ7��mH��B�j���\��!�z"֏�p�@��ؤ���ⲹ^ b��k���1�H��.�b���೵R�gy�H�x�����v����%bp��+	0n������sa��O/�B�}QN%.����$�
7�8u�1�͵x(���Q.�$ȑ�v��5ӊ��0�>w,���E�P9I��C	����fS��N[��:4Z1��/?�O3����
m���
�����?)���1
�aĴ���r��&�ƛp�s�;$�+���ilܺ�q~�h�ʺ`�5m��K#���p�{����aG������p��%d~��'�	��y��ϟ�#ד�WQ�%7�9�j*%�E�U�R�c����ja&{LCL�� Q �I�9+�K��,�+�J�s'2>v�6\��EYn8��IdG�����*q�%����ů��_�y�]�D%.�%$�
i��s���F\/�{�;���(e�����۟�G���ee~|����z$؋�c��ղ!�F����U$~��[�)Uק\*qY�o��ξ�d�� *Z��
��SYtX��K���o������A+a�L%W�d-�f�+,l-E~i���Tb�c�X`��f���-��O$����E�ҙ�i����g��̲��@�
%.S$�ؽ%)�L�q��B�V��5.�KzX�Bb� "��/�m�Ѕ�3L@l���a��5u`Y�u`�2�Ӓ<?���F�`Iؠ�V�����:E��C�(
>��,�5y�����p�&�p��˸X���i�\�K�Rf�Ĕ��o�B$P;E0���~]���i�ºR0�/���b��ߟYC7��	��5�ѻ����F��fQܺʛ#��\��S���.�|ё.Esy�uxx������\�Z���<�_    '�R"C�2��{X�i9IUzK������R���o�ta4�"+1��w�s؃�+�	�N�Kq��J�vQ�\?��'1��Ǔ������?s�-���p\`8!m/ŕ�!KE�D�I��L�dw�;��i�p���LKr\�{UDd4n�Fj��R�8 �bivYX��ЗYll\#�I��\Ŋ)���vz�e�H��k������#9����	�y��K%&,�/>�مQX���K�^Uܝ$�V``�ٵP&^X�9B�b�rϒ��7�c�F��k�ui$M
���Y�}6UR�J�Yh2k/�*(l�t~g�q� �_b���3���ɺ�=v���Nc�~���"�=��!�sx�!����b�5����$-ܵ��N�t�a�{�>��(�7c�G$�#�t��M��tsO���Y�,��(��^F�70��V�qNc�Te9��C��2[��Uy// I�uN88�8�i율�|�(ג�Q��c�KW��x�6���*lm!&w/�����j ���x�\�Ĵ���$Z��	k�c�"�%.��9���pσY#Ŋ���q�A���0�<kl��@Wz=j�>���#T8�����6���޳�R�>�*��R.��E��>��m�d�p��B �<~+nz�}�p+�eL)˦�K��
�˺ܝnй���@ c< _���#)Z�"�b_�����#x�<o@��x�G*p���影��8��D1@�\��+o��3�U��tQ��d"�_nMc,i�eQ2{���=h�?*����x�^ွ�:�u�I��6�DhZKf�����%b�����2R�nMV��`Ln#��qMH�b��d2�:\.䒢K�E�z������bE�q��Ib�#oo�ziw���n��3}[&�0pY�bю����|���MҨ�H�NF��g���(�Ĭʲz"}�Y�|S���V���*��%�GĬ<d>M��� 
��j:�.
�7�>�Tc i���KN���������=��'S��mT�w�b�����-˫�X�MV%��kRq�	�m��Ÿ�u�2����eY~9�2[�¹�E�E s�1�'$�A���p�]7@��9�'������tߝ��CS�4xF4m�W�_P|n�Y�wu/)>�/�W5$c��Ҳ���2`��ǲ�,�KX�0e=J%:�_����u��6�,D1[,�˺|{�?�%��`n�\�O���8��u(�������p����+0(.`����H�Vc�űq�R��,��6F����L~�����p�i�c��j���T.��|��}Fb��;߱����:3@��r���0@Y�o5/���5��.��UP$��I[`Q�zP��-�!	���wO��pz������d,�\O��}�����sȫg��.�x��<Ò�G0�p�9ևQ�[��BJ<3��n5���q�H\�<�~�� M)�QqK�6�+��@�փ��kWB��02�1�B�þ����mŚ-��Ǹر�c�j(~�,�$�W��vD�������P�9�ZI����}���Z-�����!1�';�$.�����o3���`�M���{�/V�HW�bœ
o��,���俨 5Ǌ���W�,�#Kp��y�t�H0ʒ�_(&W�t�7d(@�R/�ؾ	�[WL���K>��Lz��\�D�B��t�#JF�-����x�!���fd�,뎘9*7������.�/ ������?͐@B�l��~�E�ʂ�m�,�KȦ�%�w�Z����V��ġ�&���	�ً�(i�-/�9"m��e_Z��Q�����s�"���I��?�]���0��y�0��ߢ��'?m1��ktgB���B�����#��d�E_�b��n�G�ҫ��eq�}�U�d�F����������xm��%��.�����Q����Hs�q͝vp�IL��K�NH�۴�Q��M�Hj�z��������I�b��Uƞ�����<3��ź͚(Ě�0yEU8��U��4ƍ>�%U��^q�V�|�~�����أ�ISz�p���J!�N��ha�P������'�=̃k��x�Y*7#C>	��,���=>H����e�b��?��?�ir�!��J�
�(_d��o��kUF=���46�g��m�'�|"w`�'Maq0�q%�o�yv���+�A`Mخ5i�5��Ź5���D@
��@Qs�H`��z<۴*mcTL
ͨ׾�[�ͥXz���%��P�*���( ��u��GI'�Y?�K�񝡀��P����/��)��X�)%$�ji�oVIߝ�jywqƼ���a�O%.���|7KP�� ��icrZ4�Қ�4�+�����瞏Uʼ=B1u����17a����˂5�Rl:j�v�.�q�jugBa[�2VîK,?��nUS�(aB����4�[$]��{�H�_#����ݤ�J��
[J@�E]k��9����&�K\����x��R�jBؚ|����Q�fJG��H{f�A	0#��K#2�p�E��@fyd��i�;$���#`��oA��������n����P��nHr��e���Z�j�+5��Y��8	`~}dK�B'W��"��|�A�H�)���D`�&e�7i�^t���<���$�UV\��o�B�����@���=��w���躥�� ����KPVҖ������P4�M!��d��6+Y+#BIG: ��A�Ӭ�����V��h
XN�����r�������� �����2� �V-�yQ4��`�x�%ߝ�����%�,�V�6#��ʷ
��Fت��,F<�h�N;a�5���lu[��R�� ӱ6W�,w��{6?f1����)�z�6����*���Dבe�7q}�[%�X������o �`3>��,��VwJ�eY�ͷU��D�5���]!1i��ϧ���\m�`���Ǫ9^p$�W�BBv���f1���;0�	�J�_�ώ0�܅�*�y�v�6|˺�|��{c|.B�J��6��$�:���^�����\�y�i������So1����W��9p��i�S/�f�0p���6|;�����5��Ǥ��_��/c�b3�8�ͺ-�s[��ű-)�Y6��e<0,�篟'��p��T:�
k�cc�]\?�w$\�5����*񎄭�@��}�>H���l3���[��8e/�z�_[n\İ�H\t���M�"^�'�Z����gX�c��C�]�˒�X��N��}>�
�@�Pd�#���=�LF�AL����tf�z�W3qSм"W�,�XƓ�ľؕ�;do]��R^�:,�/{Y�������(_�7�(�_v���B&���8?�8QN��=�<q#�5ֵ+c�4��D��:.���_�k��y1 !1��;�0��]̉[a ���U��
'�Yl��_MΉ�s�s�U���m���.T��@�-H�s-��Z�{�@Y��V�/6uL�;r�J\T��|�Oi��~Z�m�J�J�Z�S�*
��YC��Ȇr$�H2�p��J�V^/R���7�9���0����v���;^Ѐ���Z�a��f��l��+�x;���fA���c$�-<v�i��M�&�-M\����k��+��kUe�gz��E�ٕ�M��+�qd�M(��8~ыܗe�G��̲�������ͦ��5�K|)�$��!��*�^1�VwC�x+���];O3f�>>>�ʖ�e4�K�d�$���P�.z\�ܱ��HL�7l�?L�.&���<KzC�?��m�`�9veT�2�)|����cm�A�H!�|W�R��2�t��^�i6��(lg�R]lkE,�5L��|�j3b�b�rs�rf�����R�%�Ǭ'�O2��/X�D1<��=~%&yE�L�#�m`kX�qY�H�J}t{�`�����B_r��4���*�j�Uy��,�]��t�´�M�hb��B4�i�qBՍɻ�B���N`�*��ڰ�Ӫ|z�̠�	�p�1�G��L��,��eq�,���	%�ŕ���E����߿��o��o���R�dZ� �    �5-u��Á8k�R��G��esW�iaΙnkl�&0�lN+��H��}m0b�~����t�[�6�	4���_��JO��ܤ�@[��2�ذ2]�"���OT,���&�$�R�����?�[��Wc�z��F�E�$T��pp�J2�:�@c�voU�{�u1Wm2=O��6}q{%�M�x���#d0@E��p2�` �51un��f���MT����pa$��t��u�@�L�/fY_��Ud~�����������tap�^���.���F_ �^]��dY ���1��K�ta���ZbM�z���Vfq�L�fb�s�����E�O@~�]e/LD#X�1��,�8p���b*��u���b:���	"��@��:��s/���0�rP�{ipKB�����2��<�aP�5(�ۅ����~�1�Ż#w��a�]i'��B�r���&�a��B��&������ve;� D,t��G~7w���e�"�.���;=���&��,���/�����)s�m��%��E��<�+��]�^%.{�~2e,�c��H�}��&�@Fe�L��:c6aN\��CU�0$맱>�̯����x��?B�p^�p���7��z���辛U�ݬ�RK5�+5�?���,&��x�;����`C~�+���mYJ(vt�![8�� ��9����d�l�.���89�f�@V{4�$.P>�~��F�p{���0���i�QO�ƴ�����4�X�5b�IL��\�@L�B�)�����;���Ϻ�-R�Fn��W�͎�&;�Vi��-,֩�B�*D%Đ8#��m�$60�L���u��,���h&{kuƘ����)sq������b�NgS�wh��h&�T���$1����+\,P�����P�͡�Wi��
��=r%.*�CJ^_L�^�MAq�Zr*	����c�kfw�l�b+N%�'k�	d����ЂQ�B<b�/e�~�JL��yf'#���s2
��3lg��M��\�
_ܥ�g�����S.鑻�wX�#�$J����H6_�|��D�ʍ~�c����%�c/��Wޣ�@��L�pW��P�.��j9#F@ff%b�Gd�X� C��)őܵ^�"!��{��B���P�Km�����,�e%�C�ɢH<���7pfخ/���w�>_����������G2�6Z���m�P���3	�!z���ϝ`���9�m��..�1+�����-Գ/ !-�KE�X*2 �nY�E � �r��&�[���[�K_q G�9q�"r�Hv1�����H�Na3%�&�o��ѬY��Y�q�~ql���K���շT�(����9c���P�@����3Pu�����,�
�+۟c/Y��ĿE%o�F�P޶,��W�N������@�"�����E�-i3$Ks��p�}~g�_OT�׮�M�����m�Pu��g�b ��d�7-����U��H����U&_�z%o�`����]\�d���>X~c��Wb:�^@����a�a[sTݚ��d���_jX�ؗ�eG$YL�0_S��(0������T�x̤�@�xŚ�93R�_JV���3k(3�3��BrҰ���Ě���X�юH�yׁ[�)��Gb�*�����`�:��l�����7��U�]�_�X�y�՞����sк,��k0�K>Ic[T����K`��d�*�7�Lc*_�@���/4�kdsU��ր�a� j��J�X��_j~������ ��_������l��K_;hR�ƑѫĎ5��{����� ����-x% :lV�@0�--;���m`�r�2�0f�I�#!q�_�o��f �@T�[Ɏ����<Ԙ��f�G��F��|�٭Ļ��v�O%!z�i=`QX=���8�XV�_����u�T�/ג\��@,��-j�`n�a;)�����n�w>v�|�j��H|�*�#���-�FՄ�ô4�u�����0_n�ƣ��eI�Ԏ���'3���wԓѤ�>��W�E{�6-��I����Ӣ;�`�:Q�ʞ;T��5�����M�px����H�=	1
 p6�8-[����o�q�=��	���y�����F��!��nWN,� "�n���G��а]`Z�ɲ��y�.>�������uH�*R�����Ъ;��z<l���s����JL��4�u�X0o��q3���U�*WA��[��"�dV�)����8
�J����SK�i|\#��w�ą�@��i�އ�`5���]��J:�l淪�1���+ΠIi�?j���@�iҵ������AZ�-�׺�U�*�/�4N����E�}{}���^D�I�5���M�I\��ʺ;�o�,��qM��j)~�y�ّ~�^G`�0l��֍�P<�MNaІ�g��0K���Բ�o��L�@ 5��� K�b���`���)d}g�%�nC��)�Պ�,��)=�E���0בD��aqk��xZ��]+���8� βH}; !����|���k`M2�&`��j��R�3��qsa�����f����|��uU�>J����<Jq�)��� 	h���xqǶ{hӆ�89���+�@�e��̾�j	*1��I�G�	��c�ӑlq�6�O�s��h.>�rG�c!1-���3�*�
�vֺ�xVOL�'����D�p�/Ω�EOnx~s�����		��F���ۺE=�žϮ�"����+q{[�1@�	'�Z5�=�MsG��q�b�H��Ê��y��\M2w���,f��*�t��+n��>W̭fQ�\/��՛��+�\l:´��ۢ���0*�0�}��+b��d1�*߸9�kA��rK��ǽ��p���*m	��apg0��庐H1��t�p�=��4l齶M��<���yP�I�Dc�6��癎 �T�r"[��Y�Kt��o!r��Y�yWQX�ˮ�9f���ɗ�as!�d������Ӹ�Y^�8�
9�CVu,���Iơ� ��a�"ums�YM��#&9p����wVӊ<�o=�IY���ӘbԵm}�ڔ���#��n��TH���E�����EA�zh���A��a� �m,"�A�y�$��/�ī�4�S�����R
�����")�G%_[�ԫ�/��*��o�N��慴X�ٴ�kD^,;�2ޭϿ�
��c^�`�|z�oL��`4��E&����X�sȭG[o��E��\����]P�:�yat���{#Y�����4�0˟8P��߲-�n!��*�d��Q��W �a��˯�O3(��z�-P8�N�ҕ���ҿaY�/&h��/-*��,�ue1R�-���������k�+�ϓ��GSL�@�nk/���,Ӷ�KΞ�)C��Y�JLa	���C_`հ� ]��5Y,��_젱_D�|�@�����ϟ��9{����B���a�ŇLXkU���I��=bOmZ��{����"8Y�7.̬�~X�A�˛0;lia`Z	v�A��e�Ut�	�j��L+�omy0uE1v�MFG�]�R�o��xe��ĮO�畮B�2#��)L��a3/��2������SKb��p�I*3:��e;�iʈ��,;�D�sK�%_���?ˇ�H�+1e(o�>��%�����h�a2:��Ҭ�IVX�lk~i�O���t��'KL�� T��X��@G�)�b{j����`q������������
��#��ea����Y����K&Y��F��A(�j��F���3NL2�> ��U������i�P
 ��/A���YL;��-��JA�՛ON�������q�qr�l�(��!s�q�1�d���NM{���J]2sȠ��]�iI�N|R)C�^�Z��C�vMVk%�>Gv�9� ��/���
 ʶ--
Da�4# �,f�C5�|���{i{z�J\�<=��+$����65(ѱ�3*FtA�\_�pta��뾘��-���� F(�o"I\��2�9��$�U�w�Wv}�w%���\Qp���@:i��Ʋ#2���\��ሩ1C�,�=U�������pa�]�"���E����*�x�r�{� �
  ��d���аոF���|�PM��.*�9l�c!1��7�# H7a��u��eT�~�u�����Uɳ�M�dSv��i��ġ�x���,ۧbd��p��hB|'}�૜��#�,.�����~���$4O�|�`��V�q�]��W|x��r�J�G�����im�w"��g�&���1f��+4;	�C_FU��6���K)ӛ�H���:�p��P1��i���؏���]��F�-�3�l�����"\-��X�gs9K|�Y�fŔ~}���X(ړ���	�V�,y����a�Z��k(�F���� F(Y\�|x�r������݆�Ǵ�paX�����6��b��m3|np����KD��0saX�?t�',VÝ�e��M�7��-��P�c����b��	����K�隺L���mE�n9�I�G($.P~9}}<�V�؈�d{�q��ܘfYV���{����=۠�$.P�=|�*�"]��fub�ҳ���O����S�Жb+���{������x%�bò学.o���,�>�r�4I��@HLz2�X�&��.�>�MѭM�B�������)̿��F�qAt���,��ْ�6�%��=[jL��vu q�z'���CV2K�b��O3�h�_m����l!��)�"�d|�k8��$$�$��QrE�M�t㚰�K��
�kuXa|�2��G3�$�/@����?�����3M��!�O��x�ȵ��X���$X��,ޕ��l�9P{H�(��̲%��.iO߶�ˌHJ�Wc�
���q�2^`Ϛ&=�P�afuVt����,cv�K��L����X,[wlL��κ���d�,<�b���ǿ}�����o,k����1DT�c��òxc_�T���H�Ĵ,?���|�B����,��ŷ��}"W���1��SÑLb�)7F`Q19���m#�X�-��k�e��,D��0XPLXO?Or��͋�2��,	�����z�ZÙxbx���!1���9��h,�/�>`הe�ٍ5�����XE��e6Z��y�9��D'�R� �̖-H6��0�?���������:��Zo��ƭ�� �PQ�}q,]���A����;^���1SN���'�k*cI�e2�ʁ;�X.`���S�Lx������X%�����ݏ8�SmNX�N����\KpiV�{��k�*@3X\�<N([c�t�
z�,$���mB{���#l'5�X��6��HH|�==����B�:p�;Xּ�μ`@MG���\-�L�Z����矞�hl.�#va|g\ X�J���D��^��S�v�W�1.YJ�C>�d��d�
���OvY�d��#�,.X�n�.�`Vۦ��4���,��,G1./��l��\�N�������qF����~
)K?�D��K(]kH,�F�9����MX���0V�C������(�K R/�)$���#L.M �r���rw8��E)b����f�������wqu�~�8�3*}����bZ�� �@o(�ޔ�
���f��x	��o��U
l����s��Zj1]?ߜO�O̪�G�^7
��aUأ�*A���m�K�$�����F�,�\%���?V�;��5�c�����g���U%<�c��b���`����n$����ߦb��+�fT�+MB�s��$�Rw�Iןg`�����u�u��j�ƈ�ݕ/'^~Y5�"1`Q�p�/GH,���� #�zEY�����X����VQ��HQ	}`*�Ƴ	��4Y��m�0����`��� �t�yx:�bB��P��B2.	���t��H�3fsQ��z��.+�ݵf��9\	~�v�)�<��q�)�RJmA��=K�eus����_~wPK��C�jX
_��'��u��1��z%[�k�
ݼ1�t��n)�`�5SG%?W��������7 � �#��� lY�������py���py�r��6ɛ��/g��a_w�7X�X�	[��f,��~�2_�e�j1���2	��l/=x+,����C�V~ �d��}�D����ѐ������ç��9|��/�Y���_��i�
�f)ﬡ w���:�o�_��P�ƨ5F�,Ѭ��f��e}1�da�9Ԥ3PbM�����o�*h`+oV�Ūc+��l�1,:Zt�������̓��^����)H��cyM��ϱu,���aQZ�K�q�>[��*�ulٱ��A���'�[K�'&1���S-S4�.��0��8��ت�qׯ�0.o��
�Z������ ��42  �s(����K������}8�H�_��ް�`��ű�Vua���c���*���m��#��4
�!]�c���j��Œ�S&R^�14�2aUc����Hz`�T4�6k����]k�v��ڑ9�I\������-X�4�1P}��~�le�l��2]��dq������V���Q��jUk����Z0uUykϸ�$���I�Ȏث`�$.� �.�Y+��`Դ堼u`�|0w�Zr�>�9�u@�g] չ ~�1�)cJ�K#I4(�c��w/�Qq��j���T��k�������=0�rF��8p�ɠ-.k7uc7�b���g	�;������!.לڿ�x��Ri6a���,�m:��qg��e�9�Y�d8�������dB`�\3"F3l�5��YO�Ϳ���h�k�~��^�O����42[�kMke�"�K�r�/�I��*�?���=:�@w�E� �������VO�      \      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��k�#G�d	>���_00��Y�9�'��q�\��<d�t���m����U��TT�1�sQL6	g�����*�Z�ѡ�y����r�3ѻ� 0�kd5��(�t�������ԃ��J;����ԥ��X���;\��X��I��:^�X����������#�W���x{�l55���w�.��:wɖ�YC����)�,�#^��)���RBĴn�e��;(k�t���)z�1z�c)�xt An�(w!�:�Q�H\E�$��g�YhP��@98/͎{b��P9�q��L<,m�# �ef;���������j�����:��A��O"V�#��	�rk���ZqC�O�T���S��4�8�3}W݀%?��6��Ӂma8�e6�H�ް�El8`|��.�N}�-]Rw���e���`�>?}�B�{�k��5�2�L�tX���m=҄����2��+yaڑ:��H���(����Җ�����W~�����!����&�2nC
5C'o� /rf�9�g�[�kh<L�;#��ԣ�����R�wmY_��x����e�"85�$�R9r��F�+�Fylo����Tj8̿��5�c��5%ld���^�dӤ��5��}j8��' ���۷h����t�I�ל7l������te��P�]��s�� ��{7k�4�́a�����]ƃdP�om�]o1�;C���=a8G�Jj!9��D��f^⻵9ёs aG���4��W0x��V/����gk�6J ��V�ϗ��ϴ-&pC����|�<dY�R4O3C��luꅈ��¾���oG��cX�n��m!	H�ǳ�kH	�����M�G�dP���E���)f�E�&6m~��>v̽���'}dv�J��z�������Q��_���Hϖ�9+~)����EhF�4#�z������#j�b��߾�.���)�V����eG�Z_�`���Ϋ�a/�Ѡ�4�澭�'�{ w,�y�����W� �so(�j���N8�ʮ�8߲݀:4t�,Ξ؁4{����>*�r�թ3����]��ib�_�^��+fhP�F�}s�6�w�'IĠa<Dn������~h�+��[3*s�d:{Y����|��RiM����S^ʀ-�rJ�� ��9J��� ~:7iM����a�heF�)��Z��?4#��t�V����P�qy�ೊ� ����gZe~����C�i�Gi#z��Xޯ&f[3˶��wh�!Mb�����K[��X䪷��ЁY����a ��:x������u�T���w4�%޴WU��#�gYV2��j��_JnЦ:�Z���Oo���=�Ӡ-z��1���t����M�n���i.���f��V0;��oib�P5b�&3@�h�ԑ�����V��:���>���������?���])	�16�mR�[���>�-�ANS�H���*ƃ>1�w*��E�p���K�6�%B��s�KcFҬ���������Z^�v�9����u-l'�k5:�yjMuG���2l����T b�XS�jhCfiC7lAܙ�6z��n��Ћ��T��6ۦQ�^}:�);�������V�6�,��NT:��3k�w�ôk��`S$Wk@�����=6Ǥ��s�sk�h�6i���(�Q*n��������z�0'�k�&b7tFp�G�����1��Ӈʎ���^s���i��l�#u��4��!��O�J����'9e��ú���`�`�׿"X�P^T�'�vJ�����zilu�a��/#�&�u?���6jq�n�(n��"ZY��yVcܿʞZ��:��JK���K���E�Ȍ�΋��	����䠲�4�Ţ���ׯ�)B�17c�1|{��r�4{b ��a���or1��e�uz��6���� Xy}Ay�H���4	�>�f�.����$�EY��+�$�@�����ߞ�/��n �ϺH7r"���p��f��q�,g/�}��!)�֥�#IOn�r/� )�]��MY�������?���*]����;6��������B*    ������+��5�h#l\���C�pa!�y�[!Y̑u�N�ϗ?NR��a^��� ��KU�p�)�A�U�/���@�um<�[:���f���,Y��i��pS��*d�Z��7��ns�p_�ԗh�4���ǳT�\-2���ֱ���i�m��N�ߕ�Lㆾ{i}�<�����#:ܠ=�:Pw��5�kc?A��S�������'yr7�a$
���EF�90�rF���Yy�5���L�ڸ�9�+����k����貴k�\I�i	�<K�a���:���8����v[��E;O�d��:'E��H�9�8���C�=#��_@1"������@.�umM]��rk��Is�����(�@{��>ߖ:Zq 乡����!Yy~у�b]�xcN�pT���>���*ԋE�e;�8}|9I2���uB\��;i��<͌��ry��AxD�-��jz�h� �����+���7)b��Nl�\'���h
Gq3��.f��]�����חr@����xܼ�/o:xyH�i�����H��K�y�@�,�<I��|0ZP0�7Ӎ���}�h��Љ�Q�	3��8,Εʽ$0j����Ǘ��7���_i�<�.��#�Fe�iÂ��A1�G�@Z���2s'�ȐUt��d7q�̌H�ǟ'��8�0�꿂ת ��:*�H"�Ze#�r'�:���a�c�ݛ}����ۯ
24˓:�4���>:3d�WM����O���Ct.t%�5��H�h�9�`���c���X��*�B$:D����ԩ���r�Z�:U��Z���3�X�͒V��%Ђ�����:6 �C�l�Ld�z�6�VJ/�[y� li�a?���"2�K��᩵{Έ��J%���rq�D}b'ۚ7sM�������������>�z��������Mq���b@�-�i!�������Y�1�Ǐ9��<�d�:\�+���b�|L��������z��,m�Im�6@�|�K���6.%��W������;�0�V�����<��ۃ�mD������	�@Н�5���廲{���FL9v�2v�v��qh�C{5Y�1�z�.���$od��a'+�i"�4
���ԝ�9�V�;�gu������J��k�"�O���;
�~��	c�%*�0�M����蝰,��=�s`����o*�FTď܈9�_�r��#���>����Vq��}I�xQhF�Zv��y��ZO��]���<�7+)όm���WDb@���cI���
���y��i![~��� ���l�N�m���RL���m�����������ǳ�i3�J�N������p)Sl:�U9བྷ�ۮ��7��=��z 1Eе�&,�7��+�T�A�Ӯп\��@K�D��Kn;6�ƺ4�w�ƺ�z�m3o��Y��:f�2��r��`��h,�#�m�Hl��h��������d�h����s���]����:�X��;\�)�7�)����z�H�`�R7~�Y�s&�P��A�3t�N��Rp�3D�8�j�t:�����Ӌ~��Ì�h��8���^N�-0����U�uQ�ѕ�V��r{���EK���v:L��=���q��>CS��/Gd �1^��(��J
]�hc��C�>��B���1���x����߉�?R�pĸv���0m�1j j5�lI�=���B��ho�o��k�Q���v�����#"��#@��H��{0�w���/l�GŜj��ie����Дc�4��鶓!^��6 +��ݶ�ĵ'�y�|6�M�1�p��m����涓������Z=��"�益R��Z/p�~_�mctZ�=FC|
O���	��U1<��FsDTKмI�N+�R�K��!/�mA���lƪ��ǁ��XPFg����Gȼf�]]�ڑ؊��W��`��mgB�M��S=-���Ȫ�k!��֎t����l��G��6P��!-��딿�_�,�ơ3s�<C�� ����9�d+ߢ�G�.�w2ZB,"t�!��S�1��ɈW�������`"FmFhlF�L�l�4|�������6��que^���%����{	Q(tg6b yG��*���:��çۧh�Na�7��� &�%���	��!�}���"�2���n0��8��[_�TW't{A���M��<v��q���F�q�E���@�c��e.�Ǜ^�Ft�t��U��N���`F����+-��f��ul�ca���c~�@�F�v�3Y 93�oo��p���`��`�ᘩ�慻�b&��A��K#F,�t	�Es-i/25�1h<���Wnۿ���K��>����E�"t/�Ջ�u�l�K�$�ܢO��:�������s��d;�����2y��W��c]���'�A@:w�1Ƀl� ���P�'����-�?�<G]EȞ�0��<�#�1��O�g�Q,b>�+����q��;f�LV�wn�aL��
�:ϲ�۸Zܶ�r����Rq3U=^���Aj4�:b�j9{s�#�&�:���)X�Z�YX�yp���A��b��R���	��������Yd����&ǌ�
f�L^L�Z?���]*���m��	�^�(�w�ŚjGݱh��ێج�w�� )R�Tc:���"u�3�P���S�s'�&wL��������E"��nn��4�h
���g*�f�qu����b�D<�?ާv3G�V5�����:��E�:m���>��R�)���n:�\+8�[I�c(�4�+�g3��B�g�\�j�!�8(~ͅ(59b��i����� ���q}�VPo���-
8Q �L�����OO��R��sn��%�����uB�V��:vŲ/`ݟ��A��d.rϢmt���u"mlf~E%z�2�0�QƖ�zW1�бn'��lR��ق=<Mlw��CeĦF�m�goV
שd��He�=pJ����C�xp�.����ZA�i�]<�nv�ks�ho�
��):��wض^���D���ˡ�Nr�"�
�h�yaU��j�_���n�NsN:�%�����]�|���;T��Q�4���o�q�f�Q��ǈn��fs-�d!��V���E����V3b1*�?��?�������"&"�g���<�w`��{����ef��KvҬ���h�^i�0�L�%@�3�����@�x �S�Ky]���t�����Ӡ�32>@p��"�"�n�y��UB�̐���ʋ�v���k,�( ��� �)���빍��[�y�诣���̡M]�k1?��s�`f4�o�/rf�µc35����y�m	�5bKY�Tf�$f*g�v����LM�FtGv�]���n	�_�����?�]Z�S`&��@�q��n$}�{N��@�se�xC���d�e�8���4qV� ��]�
��Ëq��i��p-n��F�P��ۮ})��˚I�����b�����^!�����OwT<�:�BQ3e6��JÛ�E�R��.�������ޛ��c7к�#�jSn0�ʫ�_\���qNw�o�;�u���*&mYo�Y�V��>��M���ՇS�y���.�m��l����hЙ�m�O����	�!���4��I�SA��t�u�����^�,���&�Z����C�49e�y�a/ 9�����Mf�$�Ș��A}'j>P�RB���$�VK@�6�(�4��?�-�X����}$`������U3���J�tw�;K��b����G܉�3b1��U�bhȐw���Z1�FZe����ex�2��DHAN�&�A~xP9+$q2F�����O��A==:�V��_ߞU%�cd?vR�C���2P�|���a�,��\}w�;����&U�� �L�K�=��H�,d�0���*����J;��J	�/�>_�2y�J�r�/po��]�a���B�%#��[r��I�*���Ǜ�1̱9�P�G�86��ө$׿�B��DN0	ĩZ;��w2�/z��B2��d�mӔ~[g�:�Y?�
�G�:��,��4��˿�ן�    �����	��Jf����J�L�p֯�/@�+�RK��J�P�M��vȠ�cs~[FV~;���y�׋�)�p�ظVA��	�~� �褋�19/If�cdZv䧇��ڳ���pZ�a��vǐ���T;�m��k�4���C��>�tΛ@X�}��۲�+�Ol� U��@��y�Ȣ�Fc��Ĳح���=�ڢ?}}~{Tr�G�O�����٢J�]�1P����r��^���ڐ�2	a;gɭ����m���\"�#��ȡߴ^ �lB�����fޢ��ӧ��^�x=?�����㱭�Id�7'}�+5�䅹�B��C��s���O����<}��F|���%f%V�W�@���X�io�d^���X�;1v �/e�|"��{�'u�BB-c	�2��L�߸M~&� ÿ��b���^w!�qF<��x�z�N<�4�o/r%b�Ӌ�e!Ō�V@��beF���i$ө�G��s��ǿ��0d�0��ڼ���w��4F}=��f2�U.x��R�bO˿���$h��&�5�w:}#kAR�GW}9����ˇ��L��L�A�$�f�t9O���c
��/?N�~g6�ë��<�IK$�{��DSפƯ�r���=d���;a��U���_ο�*�ID����`.���跁}�U�j���������S��I�	��y�� ��t��|��UI�<I.y���kb�9-�9�����4�2sza/�~9??�åRj�Z������;W�ρ�f����Oy�Bj*�E���"�dce�Ƣ�;�Ko	��i��8^�P����ͶGYЛP�RF��~�2��W!g�����7�{��^�B��я��|�yԉ���z��B��P�Aj_WS,��4vi嬮ߎ�Z�}��d�0^f����<[�������N�G>YS��|W\��/���m�&�����.����H�~y�MO�Cd|{���@�N�w�wF���׃wY?�`	��^�����9�,L/o����ܦ�W���?����*Ch�Cc��v���r|�ǿ���0���г���ߎJUF��M�:Y�κ�r��*�u�4�@o���'� ����[n�y<��ۖ��oW|��~TG��7�߹~�xɺ	z�|Ur��0\r�X�bG����B�1�uS��c�HlM'�5�)���ڲ3�Z��D�(�{p���E�@!�����ۤ����꼐�̄&v�q�P�&���>=>�����x�A�Y)���� �	A�x�`>+C"N]�@&N��!�|}�K��Ȅ6h��j�{`��; ]v{I,M�}�34����.�8݊�f�F���HEͷ�ϙ�J���Sh���>�{N�GŃ40k�������KbƗUtȚdB��&ި�X�6�2f'��}Y
���p�n�&:J=8��-]W7̈́iK����l30t0f���<�n��tr	y����NŦ�(Î�dk�3N����(�u�rv�i��-d7��å�d�f��S!Ʋ��>�˽(,9H�`f��vp]�C�،<&�9O��Z;�A��6|�;\��A��@ĸ�Fa��,u�6P�˕����/wJ�ap4���wX��KABv^��l���?_�B��d:iN �A_N�t�"w�ҙ$̆�߼<=�4���(Jv�|^��
i�^���E�`�1�(46Qh�������DE�K:S8��g�:�����=��>�Srj�ؖ�?�̦�G_`�_ �/�q6�C7},u>��A� F{Q�Ҫ*U7Y�X�MZ(*ڣ�=��"�O���A�'��iN_�/G���ҙ�r<��hg���<�M푕>h�Pr����L��{����G`�<�x��R�z[��(�,�v�,��-8�� �����	7��lP���~� .�4V��̀B{>~���N��.afQc��;�����VѝHȸU�j�R�>^Ȉ�ٗ��#fF�j��|��;JB�U�,w|T��"��qҶ����/��r�3�ϟ��r�6iM��M���G/���8�ٔ�I`�ܙ~�?l��������E�u�3�;�0�x�ad9�܋fݶ_�1�r�F, fHe8QT�0�Nm�'��fF�鎧��D�Z�����ْv���,��N��@CBc�5f⼳JCRw��e������IzJ��a8�ai�8F���S*�*I� �����oʷC�(��3WHivadq?�l.2#��SV���:���C�NX�"��*6�K�e܉FH�����+�ـq߲���	u�	:�d��������l��E��Y��s�+���N?&nKs��͵��1�h �N��s[6��h<l�_�L3�I�Lܦ�$�0Ѭ�3�kG?~�G��Q7���ꡛ
\�k8�{e8��չt�׳�н��f$�:���*�����Գ�����;�pǬN�� ?3�1�9d[9ǒe<�����S�<vj Ӻ�`�Q:�=�������g���^ݷ�OPc�$��9w6�z�N:94�6^Gp�Ć���x�'h�6uqp? T
P��(bc�Y�k�>����9���x�Y��[��6��V�N�V�~���.$�0k�1H���͠�p�B����Bk�<v��e�������t�.ig!��y&V�}�(d���|~�^$P���m��ۂ0},-E��Hi:RU ������[l�r4kC����;�cn���|RK���5�7xP~}�Ƹ� l�Np�y��wȃA(��~�0<]��t�b/�a�?C^��b���C�|O?��I��$Y�3���h�����Ȑ��Z>U\Arϙ��c�p��6k~��7�	�^�B,�b^9l�
����U�v�Ě6X:>��q��� ��]&�Yi/�m>�]N_��C"�S+���� nԜ)�ìq�\q��i��D� y׹DMs�=#?�6CC�p����<�dd<�$r[?�� Öt���lK�A�d3��L���ށY��U,e��垲B�o�JW��-���?k�� �	������!����]��+;hN.�9���}r$2l܉b�0G-��EO� �����4��F~�B��P�	���Ny:���>�vz��+����Z���)	�R��@!v�1�M���;�4� ��5m���N��$�H/ȠhMv|�����U�o�cMI��~�{�A��z��1&E��Ѧ	J�b�X�6�F�8���נ�b���ִ>į��~F�jЙ��t-f//�����OE�� ۘ5��Dt��MB�`�6�ɉ.���Q���QK��������Ί�n/z�ih��CbŰqui��_4~9��>d)�V$�;Av:fo%U}��R���.�d�p����&�Xƻ�3�-���Іʍ{�B�L�6&:���+�4�\�Sq�G���Z�M7�j@�g�� �A�F��-��;�aB�1��s������:��t�J31�l�j�Bq��\�{�v[�÷k���� Ls��w�x�%��A�!���)"�FzV�Y�h�b���N�w�,3�d�=�;������Yi
4ݜ�+���둘�X|*
qc���Xu=�v�|��5\��|>����:J��Z9avV�����i�����i�)l,��I���X�=��b6t~H�y�	��˫�6r��rV���-G\#WTPϪ�� 3f�.�l��B3�;�$+W9��;�q#����
f�0���Ё��E�� Ɋ�$+�o4�_0h��#2��$hH�f9AZ��/Bs�@m��R+�S!���|��?���?�])4L	87Z��f�ninE���\E"_T�����R�a��ۧ�2Ӑ��rJR���a
�($�,���	�����z���XNc��s���wlt���$2�zF��F�o�v�6����!�:���6�$���D����y�����5J���;a������7,�P�%xW�A���^z�q`��q��O�"���N�}�(o�8Ȕ`}�S)j�mN7jĞ�Ќ�g����C���<��$^A�C�D5�7�����5�,�~�ǭ�?jx�m��+u�١ZL���_t    R�Yo���D//g��9�tđV�����V��K�+d��Fᆐ�64�:d�bN�ڜ��5fN{/$=x�3��c�;B���Cbqc7��	(;H�`�i1�N�� k)w�aO+R�b���1�i���,[��>���FN�p�8d��6r�7�h[Ȱ耇�ѐ8��Ɖ�����S�7��`�M+|��l��}� ��h.2�Z��x�>:�I��ill�<��d��tX�l��S����k���W�rJ5VjE�	:"9C�'6˕-�]�_�~�ZG�l�'���B�<G*���S_q7���ҙ�u�>��>۞N�s�<G�#Q�����,:ё�0�A�q����l��s�vA9��jw��y�Cb�4Æ&D����ْ�f:$�"�L�����8��,HcCbܾ�;�A���D3����z�|�5�QX�8�#b���UY%��#�ǩ��gݼ��56��At�K�������݁M��������Z�v�dL����5G��	gʽw�����Y��xHQb������.��C5�w:�%޿�п�x��4���	<��7�.`���Tw􄀣���M����E�pzȗ`c����&t�OQ�kw��b�ORY�/�җ��Z��� �U�H7A���˃�3�i�(<�<�Mq=J��2�m�a?&���YN��	FԱ������c�yJL��gi�:�	����k��O��ƕ�66μK��w!�IҔ�m(�����d��Cr;7N1M�L�њ�Y�-s*H�Y�WE��!Ç��#΃[�ܻt*҄X�9f��Pou �� M���`\��+\��K]֤߱��JYwg�vG`�<�_�)hH�e�Ƴ��<�NivB��K0I��N_%�n������IL�xH�e��d��{���C���\P�e�]�x9�"��DXvn�FH6tC���(q���]��g[�v�B�&$�R��AfHEbgQ�����|�a�o�@���$3�U>�Y<�y�Э��S�V�cu�����i=+IC[77�nx�&���N���XP��aʼ|����m�O�dP5��;��vZIٕڤX�p7����5Z:�h�٘����A���.��2���5'ݟ�����ttvnJx�'�g-K{8?H187.IW]��k��2���u��,�'�|�VBIK[9����kí���{`����u�I,'�?�.�e�FqGQiA�>�����J�%|˗�S�{�"t4�T�[	=}Ʋ0B��Evi���c��Sߑ�8s�F���z��qY�m�|HE�[����������5�#�&���F!���ĺ�Y��5+���c�k��j%{H�d��:c;'�c�(�/W��~��i�\E
8�3�P٦��.M�dǃ��f�%�d���%�~1�JX���D�V-��eU��OG%�|�]��j��OZ7`p�4�]�~:��Pw/��Ds+���EW�����
t��(�Ϸ����?D�#��fStμ�˓�,٥��Jݷ��t�[�tgdO�k%d~#��n=�V�0JZd�����<��]fI�|I��$��Ƈ/�M������:�a3���$gQ��ݩAOϙCQ�ȉ�����}:��T�aҔ�	?�5��	P�t�n;ǎ>v��N9z-7A�Аs����ګ�����ݪH��5�f���r�Tv�29a��!�ۖ�p846�)�	 ��
pC�Y`H�W���}�����A��S(����*-"$��k9��0�}� ����ȼm_��M���U�H,g#��8t��x�l�5�3b/���/����75+�!ߋ�|/)󢙏1��w�Do�F����m��a<9���d�n�����o���1��`�q��7�K�!q��ڲS�mn w��q+1i0d㺥�m���J��⹩�x&�\CYB��hj�A���6�,�:?\^��@�n�[�TDzG���O^�򉎶����v!��3��v#�.G�j��G�M�&�֎����6x{�J�2�j�Ԙ�S�
e.69�'5\�!����Љ���� �p��ȿ��[=}����	P�{H�Y�5e�a�U`kM��v��vyT�O2�i��M��L�m����Whf6���M��zȮ�Lc���D~n���m��*#���]����>d�pF�Q����p�y.�2"�up��8#r��3[x���y��ޣ�#i�~7��5���bn���Y�D�N�rwrRn�$D�o 冖�K�N�� ץ��r��۱|��&�{��^O�[�Cg�~�v��js�̉[�%�N&UYqEx#��:�G��0ə����PL� R�!�3�t�XF�/ct�8W����L�ҽ���&��X��&�[{��A��L�C�L������YE"�G����\�(�N�g�ANc�ۜP�{���y�N�|#�0��P�m'�WsDe�>61�Ƿ���zL�9k�F�P��N�7Eb&�r�����>�!������^����fp��j�D�T�*_�#�TAΊ,���s�h� 6�Zh���	d4Y4���#r/�#�ڃ�
��5P1ඪ�m��t�{m$��,:Vޟ�5���2F�_�4!���ε�{���Hy>V�d������*?�ޙ�,�6^��.|�V�ZM�:��"�oe�A�[Dλ�o� ���d(bۊ��Ƚ��y���::�6k�,S�-v�Mᅑ�m#�t�t�e���K�u�6��Z�T�!τsm�o����E���酾�ܚ��V��t��8+#������#rN�#i���;C֩Urz���cH�����R�|\��oO��ɼU��_No[��mfA��e�6���N�����n��T(G�>�!qN��xo.��G�Ϊ�L5��`��t�{C���5�c�Q�{T��P��&�X�\����V�0�pm�b����Nҝ!;��
�Ǹ4hl4��][Bw��e6:�4����.�L�:�>C�<C��/{`8T [�cb̮�L 0�=s�	��^+�=��3�Qdm�i��R�����Z)��k���8����8-Ɉul4W�>�b9H���mub<�jo#�)j�2^���:�X����о����xd��f�<��sۦ�T���	?Si��������&bč>v�Bk���{�f�,�v&L���y;63� �¯֞�M��o�	�0���ie!�~�����f6�K7�a��@c5��2��ޤ��A�^����I��A�"�EL:��׶��![ k2.b4��yP9B[ט�A惹\d���9�Enl�ۡlvU���G�!׋��S�ѕ����x�۟k��竟��NdBR�U)H�`R#j��U�e؃���{Yaƻ I~�	&�^$�k�x+鎗��3X��O��)]�\I.�:߄1uG�K���e�f�Z�+t� 
;����E��+�{�F�>�����oH���a;9�O���I�]�B+�OT�z�S
5��O=�i��	��4T� Z��_t�%fAO@М|���]^ƹ
	�G��4̖9o+�ԭ���*�'N��8���s�� ��3�B�ͳ[p���și6=�x�T�4�^e�!�M�A�?*�m��bN��Go���'�?� r�J������ �;��%�����2���x�Լ���e]�;��r�4@��L��3��2���Js�hp��MÈA�0o�"�lܟ���7$�t�Н��?+X/Dt*����m��#�����Y���q���2&� V�vA��q:q�?�VCcc�pŮF[���n�0��b�0��+�
6�j�EZ��?�%{GK	V|�9f�A�"@�"�y����<�R�~�V쐣��;���aP�t�3�pN� 6^ �ϔ�)Ȑo�q��<x�b�	�~�x�	�@E~+>VFs�����E��96�i��,����BL�ݝ�cf�	إ@&ǙtH܃w�IB�;A��h)n��k�����ܫ�J�q*�<8
�x^�`�J���N(Wi�[�0���4I�M�|oTm�x�{��Z�V��.�����K�>���,�H�V�})��H�]e���0���b��{��<@�����Q"PB�>�K���y����̾'�H�    ��2ws��I�|y��d�p�-�f�D�x�H�R)�a}t�B�A�5��RS���!d=pKc��<ȐNr3�jc�.��6�o�,�UE��� ���"��q�X�E��-@��h9K
� �;�"쳙0�Pa3YêݲMӋs�Y�|�x?U��NZ�|��iX=��Bc�ld���C{���p,0*�eTڙe<�z%`�%���+;M��)�� 5�[ZS�o\0dv��@E�C���]Ԅn�D/ni9]x��k�M"�i�<�� kI\x
�*�-m6`=�Z��*M��	�Y�B?1u2I�$[H�3��<� m�[��h��P�CF�9 ȮlΦ��Rl�8�'+d�Y�Iyi�!��u�;�J�Өn1$pf0@F�32zq���b�3��k�3����I�H���F��,w��5���h"^���~��@���^a�v�X<ʑ���-v�6=ܐ���u�";�E����:��ƨK���Ű��F�n�R�l`�%CS�ԅR��w�d�skc5�Ȩ���n/��T�R��Q��#<��� Y�j[	�r�+�� ��/�>�=�%bG�M�Gg_3�>���^9��N3����dqqks�!!N�A���ޑ{a��pO��"nmkvv~EȽ�n� Z�f�0�Ρ�n�������}K�G�E���{��ڄh�#@f"�J�ws6�D�㲍�v$�q>���,�Hf���i߶H͑:k�I}�Z��� I�����<��=�2�j�QY*�����o��!��[%�A��e�=HsL�<w ��u�����U�6��(���*�IZ�h揱}���/��i��Ը��L�ϵz�~���.ŭ�,F;�F��O^H{��4�$�X��)ȴ@Tw��ZC�?����m����.4��&����/|~{�ʍ|��_3������q�$4�֨��)�4�!��7���i���mg����B��}Ύ%�eS���1���>���� �R��d.�w;�X�}6(�wP�Yޑ���\�|`���Z����z!.�������f�[��U��|�m� ���-��Ё��n �Ϫ��ݛ�D��5$a�P��T`mVo��#NDy7�|���)���[�4��z�Xif��$��ك���~5�m�|z��d�¶Z�������(��F>�������O�]�4~�v�X��rA��rĂW���^�+�^�z~~<�� ��<��J�|�&$=hBv�Dr2�ɿ�t��HBS����_��bd��M�:1Ho��=G�����.D���ʧ��.�J�a�Ԉ~�k���(�K��d���1�C���r�T9ވT �3���l@���p�iĦ����c�KW-�?d�i��iüT��2N--G^�ǖ��L�t9pyg��t��9�n������e�0SW:}�E=<�l�6�"��[w�
���6��Ӄ<� �����Aڎ�K���(�}����B(�R�xڂ�'`���m�������@����1~������ȏ�m��i��f�kA�U��'��@I��5�����nX��ɰr��&n,������������xۚg�Ki��J�J�D6E"n�:}y��i��䭞��m��J�XY�*�M[�A����Ŷ�%խG�m���4y'�a�g���N_t&	G<'YS�ֹ�ޛ����jt`gh�v͡��7`�`ͩ~Ҵ��mh�#S*�*�4%^�y{<��� dh��
�O��I�	�����Gҁ��P$)<�<X-&9������r�����(}|}�&���	N�|����6��[7��*	9F��Ϊw��<'��������}\�`�N�#(%��oUK�/�(%@��YGH�ocK_ى���)חy5�J�vb^�����ߐ�s2 �>���&d�R�m�"������s��2��o��Q6J��6�� u*uW��'5����kl�ܣ�~���v�"�������W�f���s�R��6���ǞwM�Ϙ��v-s� �J׈������N���������O�u��W��I���@O�q��Y�Q�#ʻ֭ӊ������0��k;����5*]�o\#yʑ�|�'�غ1��ICv3����T�Rzxߘ�4p1TdZ�t�D{j�)�D\���z�cx�[�����9Iz��@(����OS���I��*�N�{��S_ḱN  ̦�������	�ߟo�_2��7-����t��3h�� �u�o,t�m���^�5jU��
[a��-ȋ��\g`�@5�A�q��6��0�a͜��o���?��ǟ
3�4�$0wv���~B�tZ`&�Gv>��˯T��-���>
؝���>⺍1D1���¶�N_�BG���ck��	�>}Ѻq������I�ܯ������\@�dZ���Wn%Ѕ�j��eV<�!���i����p��� �>�J����Y����`��z�s�|�ԛ�r^
?,]�<}����8�Y�c�Y��>�5skh�����n�Hi{{.�t'~&rP���d.�y8O
:��8�y�ǭlR����2��%����Cf+D��7?�<3R�4@[��<���к��VQ��S��XD�T���G�r�ČF��#��w>�i�Q��^t��L���fS ���2�l�d�qX[h�TJ�q�G�f�/u��~nQGj&n��x��m�]f}m&к4M�Օ1���뫢��	ȇ&�N��-3����AW�D���;5��Ƨ���c���B��w�f�A����R�iH|n0�Fu�z�����7f�],��!G���0ӛ�<p*ss?��Zyo�q�+�>��P�0B����u8�#a�bt������^;�ـ|I�\��foe�L�/ �0��M$�/g�+qq� �6"3�*ל�[��(j:�QBS�fl��d�φ��U�7S�'^�<�}���6�f��̓�<b>��t�?����1~p��/�k\)sS��~ Wj�;��⻤�Ѿ�x�����M�b!_�:��o䭼Bs��Xr��0"$R�sc>��j��쾼����!�c+��RH�Z�н̭{�(ey|����������X3|��D�>~�������_O�N�Ƶ|���=�-�%UY�7�aw:����"���(/�r��!L��\g��fq�/%��H~#�i򳴊雀�W^����i�"ȩ̰jȩʳ��ϗ_�]�y�0͙Eƞ�#��\�h�)�N�ˀ�m]쁆!�܄���T�����)d՞��j�g�N�F����R<\�+����������Ap�s٣4�6�gfz��N����/�J�U_4�K����\)Z��wJ�g8E���w�#d<�K�У�r�cd��y��;�?#̐��m�m� �sc󠸗�]uY�	It�V��tVG�h���OH�Y��gi���:/�ù&�+� $���t&c�,�]
E�g����Kgۅ����v] ��Kd~U싐��/b��/��3k�g������E������O2���i~i|��w�Vƫޱ̈́X��<V����gPd�M~i3��h?���b�<k�vb��ݛ"f��)�/�°�Fڻ^t�]���Aҋ�m�A�����j��F1S����J����P�&oLL����ܷ��ӫ��?������tD/��K��I�5mwC��J;�B!��g�*Y����6�N�˜*�����B#&��2^*K!�~��AC�̘?h���ޯ�����A'T�R�0C#��]M�	t�U���2�*�q� _���6�ٌ $k�n�Y�u�rr�VCNE�=t��vw9=��	�Hy�#��z<t���6�i���˵��B�AC�.�����'|��>����cti��N{|�8e#$�4(��������-����Z����=K�0@b<s���=�;ƃ0;0�͙  9�0����X�;u��;[��!k�Q��D��1��/L�c���X蝄�v��D�xN�V�6B��0��7�siDA�`��YV"x�|��l3$�	Sn�8v%`'��s�lg`�e��l�W�0! 
  	L����X�(�!9�����	d��l�˲����E����)LA`c��?|��x@��6�7̎c~T̏�ք�1��<6����q���b�d�ؚ��������ZUN�����I��4/�L��i��1wD�����4��ٱm�,���3��;"@;`�mF!tk4�9Ә97xр#%��R���H$b���0q�L����\�,��L�����E��EȽ&c\c�B!l�p��*.��Wt�'7�4Z��l��ӃbS���(L���t��R��VN��M} =�3w���%B�*a)
�o)���d;��>�!�|#yH���obtkԼ����딅�g�nK^�^��ɗ	c<��m<�9kڑk��H�YD�����^"�.ݴ.=R�l?�0�N�������N����!CI0"Պ���Άp�L���+G���Y��GȶLcigu`#���r�F�ۙʩ�#$�
F��Wj�O
cs2xA�h:���%!�^0�v�lߏ�v�>5�2%�n�V;�5��$x��6����mG�	�VZ4ѳ�;��(U��$����N�7%���F��u �jV��!�F����"�w�8a�ŧ(� ߞ�wJ��{��{�ޮ� x����_��If�S��;�l��l盋»ʛ�:�J{H�J����G :P+r�a�E�Gr׮���)ȷO� ;t��u�������a�Y��r�6�"��
V�7]���-K�v7����Zce�Gb���
�:w���~+v��#��fe��N_�x�[���_�4�MIT-���!���J[%z�\㠢n�
z����J"2�s�2�Ԓ�5�@����$E��UI�E�9}y>	2��x�u�^��0ј��5�&p�D�F0ϧWU�T��Is>6А�ș,:�7]Ț�fJ�5��&�m�Y"d�	�5�iyT�����#Ի!��h�/IC3�Z3�3&��1�s�lD��|wV�Y��6L�c�)�GO,����DƢ7��;0gy{����&��̓wg��KT��*k϶�߾)��ݵ�ݘ���GUp�@�4�X�N0�	9e�k���,�+���R��<���Z�WVo�h����"j���'��P�A:��W�+�9��f��˴_��(�0��M���.�7,��}-�5�6�%J4�cj��н��Q0\>�}���|�a�:{5�ec��C�b��'��	^&lW��kE���ƛ�fi�A7�N}���?N�?L�m
!ON�g��x�ji��"�)�����a�?�����������*>�p      ^   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      `   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      k      x���k�䨮��EO ���� ����q Gf:2�D���Z٫��� �EB�'Nĕ�_�������_�����R��Õ���|~��)n+����?��02c䎑�"w��y�oB	�?�w���k�+n��e�/�L4Z���F���������-�PB���n ǒ3�~<[��F�׭�Ģ�X��e+X�2ޟ,$��`	,��%�.[�I
�]�RVW� Ǜ�%V���h�X�K�sq]�z�{����z�ۀ�ˈ�ˈ�ˈY�^ekBĚ�&D|�F�C	�P�:��%�C��X�֡�u(aJX�2֡�u(���!�ڷ�X�k�BbR�}�"�5k�b��H��O�a.�0l�6��s���`�\�a.�0l�˷�
 �l�I/ؤl�6���BMz�&�P�^�I/ؤj�6酚�Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�>P�>P�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>P�>P�>P�>P�>`�>P�>`�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�^�ɷ�X��I���[H�CԤWc�ob��&���ɟW�z*�>��ȶK�~�½NH�8c���l��Xe$ЌU����H,��~������3�� �%4c��\�����:q���9��Ċ?9q�v,��|����� �v�6��v�6�
��m>X�x����H��fl����|�Ě0c���̝��<֡�|��:4c����:4c��X�fl��Ќm>@b���H�C3�� �uh�6 ���惋��}3��r*���3A?�*�\� 	�\� �%D��8�nsq�$�-5����H,[j����$�?I���Ծ�
gH��$x��L��J��#����&�\��`�x'�&�\�� �����o�����x������v�Tr�m1Z��W��+nK{.>����D�?������z�-��������|)�}5���t�e��������x�?ǜC=�'��jz�E��x-P�{.�}��돚�s��$��Q�{.�}��:DM�H��5��"�H�C����t|k5��"��P>S�B��E��p��E��X��h��t �l��>�>@b�R�}.�}�Ĳ�F�\��@B����
���H�{$ޡ��?�>�G�`��`.�}  ��\po�kb.�}����[Ꚙ�t �~I]s��$�-5u�"�H,[j��E���h�����s�$��PSw.|��:DMݹ��5u�"�H�C�ԝ� |k5u�l�`���쭏�<�l��s�^�J�w�\�1<]�\Ǟf�yi�:YBNs�����]����[']z���������J���{O�%Ͷx���9�+.�M\��'���>�.�,��=�e�5!�����g]����
��>��2�b�?��!��OHϘ�,>]�!|�,��UG�o1�F�O��~��-I*���U�W�Gd ���@bi>"����r�H<N�_�#5���:��k$�-�$�*�)��x��5�+��r�3�4��1�\@\׹��j�c�������-��4���Ļ��u1�|�kEB1�x>5���'��]2�i�C�w�@bҼK�dX�4�:�y�$�!ͻd �i�%�uH�.H�C�w�@bҼK�u�k�>ͻ�!���0]���s$\(z���҂$\�z&����F���` �l���g"�@�Uj몙�t�~��IMV=�-G�U��I�G=�'�I��g"H�����D�G��8���ߙ����)i���3��u��z俁ĺGV=��@r��s��9)<%m���e�3xc�6��L` �ZRXO&0����Ւ��z2���:Dm`=����&`��6��L��|�d��P�z2���KLO&0�X��z֓	$�-���d�eK�n=��@b�R�[O&0$�?I����(ғ	t$ޡ���&�,���dC@\׹��RL` yo�G}zJ���K�>N�)˖��zJ��Ĳ�6��` �Z���` ��zJ���:DV=%�@b���` �Q�UO	0������J	0���)��?���P�^��w���ٟ���?���1��"�k?���1���t�����9��8緲g��IWX�}Z���Las1�O4�\�ʢ�����R{���R<�NY�*N��@e�ց����B*'�����t�[����=�{Jټ�\푹���v����b�z���)�8٢��ЁT�4߆�O?H��ͯ�냮hT4�����.<�T8����q�:��O�����Ң�u ��4�PҮjf��*��:�6�y�馣�X:�N�f`�@:�y���t!kƕ�E&5V�1��A�:�i�Ҫ��,��:��F=�U�1»����������h?�]U�D��1"���Q��P1�E:Fx��P�1�mލ��SHuU�=Ձ}��珏����r��Hq;!���LR���t ���i�G��@�q@�H������;ͅ�|y��Li�������1h���Ls�J��s8?�޵����>�8�^v��\�Ioߏv�gڟ����V	(�]�T��[��A�26��5�C�$O�[(r\8tQ��QJ�O�=�#��e��V�(>��k��ܾO�PF���4J��*f�Z.~T������%���x_G�*C�\r�\��ە��lp��`���K���˙s�`{�7W����f�Z���Cَ��2��� ��=��Ò�ܒ~�o/�V��ŧ��>��/�h�����p�av��z�Y��F�ׁ���.7=
_�c���|�b��zA��~��h�zH{
}uz ���aӯG��@�6�8vH�}uz��
 }uj��A���d{�����}|j躾��H�oP�[�e��O?�*�F�!�:���]�uח1��?Rtׁx��* �uz���R��:=�]��.,�ӣ�u ��@ߐڮ��@P�kׁTs����@�9� �#��/R���o�W${����ڿ����+���^�� �SOdg��W {:|����_a��+�ݟ?>�b�;|4F�=���������7İ돹���漻!I%̹��������kU�C�r�)N68z�xk��{��q����ܫä������{'H�M�=,q�i~q���b�uI׽#:�k�Z��_t����ݫ/A�d/��;����3�-N��/���;TLn�>m���G��#��!]bޣ�`p�A�����7�=�*D'?���b��7��9̯������Ģ��l	��9a��Йf#�7GWM��s�p�e���ۦ�x�C瑍�m��L�V}����#�=A�lǮ ;t��H�@�	6o~Cυ�Ľ�.l$֢��D}6Khh��H,���mo�x��f9NU0�p�J����G���`#�8�^�d,�H�R����I/oJڂ�Ě@/o������J���[:|U�a�{���`��#���㤷E%��'�I�-S�d��Xo��6r��`#G����|�&G	�(�Im$֠�3���'�6����j�(����X�$���?�� �ɮ���`��&�H�Ć��6��C[p{g�����3��c�m�G%�l�7�=���-��&��˳��ٛ��>���ɜ�-��K�u��M;���W��q�}�����C����:��y�u�b�B)�O����Z�z|k��r�ߣ�g[9�Z<��o�/���˞�/�+m��Ϩ�ks���b�ì���K%>]�b2��ypů��������>��*�M�����Ԛ���H�O1J�o��.ezb�����i��qNy�����a����g1��)	�7�1E}i�    �d!�H�Y�Sl$��%�F�d#�H<N�Sl$���$؟�@�U��+y	&oz�}7NM��4,��)�	����s=����F%E�F��L+Y
���;&�6*�
6��_X�NIV��X����+�H~8�uF�pJ΂��7�hR�l$�!�hR2l$�!j?*�6������X����{ǅ>d%��F�5��~��1؞�Q"���Q&�-�Q*���Q.�=NG%tz>y��O ��0�2����Y�ԂOj�}s��~�_.��!w[(G����@_��x���c�y��eo�.Juy�H���v��YGq�����:����+bܟi���,����X�k�﷕ڨ;���4��p:�����_����%��>�k��_����Pܑ�hQ�è@y���9Bl#�����*Ǣ��S˼0����@b�j.<CBʓ��M<+���@�o*We���_�{��} T���*���W�T���a�j�8�ܰq�ө�zH<+�{���YQ}q:V�H�����[��T��$^-��T|��3��!��L���U9n$>�b�H�+h^<�w?�g ��D�ȟ���&�w�@b�j>*�e����ot�|TR�ҁP>z�����!=_�@�qO�2�p���B���z���Ě@M5_��$�R[E�2��W5&�U�|!C���&'��|!c�x'����/d ��j�BZ*z��1+ʫ���@%_�%� -N�@b��$>����H��P�H�2v>�|U󅌋?j�B�]�0ĠO/����B�42�xqRCW�42�xqRYO 0�xqR�ZO 0N�	X��q�&�@(=��@��R�\O 0�\BP�	W��@` �8�Y�'H�	�,W�OR �*����7=jϫ	ƚƂ�� =���u������'H~��GK=��X�xǤ�=��@���5���eKs=��@���3j��	�h���'H�C�~�$�!j?�	����X����cǅN%=��@B���@`8}��է��T)	�7�c�0�FO 0�pJ���>M=���6�*������by��
�'���$���L�+�3�N	��s~�����
E�LaK�/����㵵엶��o�Ҿ����^󶦵����|X*�ַǵ^SG���2Rb*��"��\?���������Lq;���n0��`O�y�<C+r��=y�ŷvjW�]��K»����J|���R�-]_�/[Y�5Y:	~eߤ��}[��}X�n��3�,ն�{���3�V���J�������ka��.+'K[[�nKτ�Ty�^A�_*����_��k�����jHX:��t�������p���ґ��[HZ۷��ޥs��^,W�m�C�ځ���H^�na��ĥ[o\��[:�q�[j��^�^-��p��".�޴T{�ґ�=d���9-�Ԥ�&����\HK���t-�ka�Ì_{�W���/���-��<�K�B^���ka����Y��KW־�����m�:]���ka�Sq��x4�{�g<��6Wb2�ZS�Gk2|�����g��;b�n�����|#4j�Xąy��}�9����T���U_֎t��V���K��|Y�#��{HYz�kW�R9�����k���u���^�>g�Ҁ	Y�8&K�VdiԊ,u����,Y�(Kｲ��X�z�d郧,}���~K��di`�,}��>K�`d��Q�F����YzS��ϧ�4�G�>�.}`��ϧ��$Kcei\�,}����&�4�F־�.n��k��mW־�.]����q��-�l���Y��+q�H��C����jd����,�4�R?�,����{oXk/,}aK��ڛ���XY�(K߳d��\��-ei�FX��
K�Ha��{�o���3�g���#���%�����o���@���~�����X͢�!��*�'�����z������[�c�-H
e�i���os��=�o�k1�=}���m��=�xC��c�o�^MZ�hxƴ4������g�֜��q+GIӯ��4�J�����	Y���������o�4>!��g��R��v��H�)���m��v�qzϔ3������3�2�Zi��~�H�ӥ-���}~�̓�
�g�+?o.'�>n�G�=�!��n-�}Ϲ䙍�qU�5lۈ��a�3��~�J� �c5������T�NH,Z���!!����M<+ZIUɿ��3�|>��u��og�U)�f�#��e��a�juJ�R}�W >�
���ĳ��+H,[�N��ժ�H��h�R)�d �j���B�h rE��+H|j��
Z�S�w?�N���W�f��T�$��V��@b�j�;���}���M��7'
B����` �uHT��	w>�\�@�5��+H<Njr��k59TrE���Jm�\ѐ_�x��Vl�����M<Nj7�J�h��$����$�[�\�@BKE'W4fE���#1P!W4F�5H�p0�X�4�Oj����%�6����:_UrE��O����T��S��mL	^�9��ċS#�0�xqRY'W4�xqR�Z'W4N�	X��q��+�@(�\�@��R�\'W4�\BPtrE	W�N�h �8�Y��+H�	�,W��OR �*��urE�7=jϫ�ƚƂ�� �\��u�������+H~��GK�\�X�xǤ��\�@���5�urE�eKs�\�@���3j����h����+H�C�~��$�!j?����urE�X����rEcǅN%�\�@B��E��aurE��+�T�)��7rEc�0�FTrE���+�H����u�S���7$Wԁ���I���u�F�h rE���+��+�������.�z?A�o��[�Z��+-��KM�OP��A	��-��ƕnuI���SE�u%m��[D5�$l���Ƀ(���%$�H���W�OPh�!Z�	�OW��Oz��c��v5A($��d(H=�|d�`��/A=�E�q�Ct�}�A��^	�>�ᅀ�"iD���}I#iT���ϔg�F���O����$q��n�tt��G���|�{���=Kj5
�{�{�^����4�yqO�Pr�1M����2���]+����Q�t���2����?j�O~�{s)��P�,���/^�+m*Z�}�\�U|ӳ����{��ڽC�gV��=�!�ޔO���m{�I��Kc� �k� ���U@#j�>���"�ޅ&�TE��ש�t�?��?cj�x��n���V� t
�ڹ���V������I��}�}2R�]��]!]�̝��N�7�˲��\�`ٞ���|�\�W�)��R��vם�/�)��������,!���<�Y$tqO�T��T��-���'�+8��}��<�ge����t�/���R4}�B�������ƎtcG���}�|A�(H7
�!�ނv���� =,H�
Ҩ�'($��s�f�Q��/�mz���E�W��ӕ|��!�^A'� ��������4v%)��4����{� �F�+��� AN�+��'(�8���W�O<�LH7�[� 縠�A�O¼��)N�ä ������/�S�6|��H������*|�b;6�{���}�ӏ��׎�.��ێ����ϵ�	��~�}�v��d	��p���?�Z��V-6��s�Ǎ���a���Нn��%�|���B=��s�d.��=]�.?C�rܛ�9+;9g�	/��W�ɭٹ�����M��ӟ����0}=ͽ{r3UU�p}���OFwP���������>οt��u�O�n�zq[t��c^x��G[o�����P�KuK��=��.���)��'�&�E�
�m�(�+0����I�d3%����Y�ͯ���V���߷�n�~�*��x������h�����A��w��}�֫�ۺ<��]�;Y��C�d/�)j���J�K|8��+��7��8���P�W_G����g��2ut�~h��h���Ί����wz�6�Vᮅ��!hu��!h5$���	����~9w��<[:B��h�?��    ��-�/��-n������R�ǘ��Z}ɿ��s��:������]���v��a��I��`��߰v����8��u<��篻=2@�ܧ=6-�n�&V��V���}�ۤ��
7�DIY5&#�P�p�Z��|0ը[Mm����A�iG�!�i��q�<���m�/�D7�%>c5:�����Q�d����г@=hڻ�T^֐�r3���O�s���+[�)�v�i]���܈[�f������ڵ���ҿ��j�U�7�h�_?�����)
Gs~İ�8��j}Z-�NǗ ^�c�+���+1�3���iSo*qc�uQ��f%��RQR$�a5rs&��Ѻ���V����R����Ϟ �;
��ԋn�g&�Ka^0�0/H�y�@��=u˼o��4�z�n셩Lo���>����D��rL�N���N��ۈ?�]����Y��J�����G��ͭqۙR�L���K�+-����xx?݈��ڛ�w{�ݷ��I��T+0cM|�]�{#��}?��Sqev������x6$޶�"0ϖV�Ű�EA��0�	/�*φ���y6$��t��ǉιh�lH��t���IN:φ�Ě@�C*φ�I
�]���gÐ_�x����C���&'�ڣ��a��$�8�y6$�[�g�@B�Y��0fE)��#1P��0F�5H+�i �i�<$>�����jm�<����T���O�φ�i��x6�)��S��j ����H�8����lH�8�q��l'��}ԸԸVy6�/B��Y�Y�Y�Y��lH�Rt���I�r�g�@bM�f�ʳa|�qW���l�H��Q{^��0�4,u��y6���z�{K�:φ��'.~��y6�u�wL�~�y6$߿�.P�\��0�X��0�y6$?�:���γa �ڏ:φ��:D�G�g�@b���γa �Q�Q��0����ڏ���0v\�T�y6$��Z<��W��0\}
}��M�gÐ�³a|S��0�	�t����l�H���y6?j�o�³a�Q�(I�Ƴa|S��0�p��<Fo�W\��0dK�R�g�B��P���>�g�#�5रP�%YT��{�/k�<�ݗ�1Q�Y�꾶��)�"=`���E�c@a�2Ye�"�#�YV��8�jH&L���ji&
-���6淐J�W�2{x��n����l���"L�Gu_��D����>��D��rl>>��[Y���?�+�Fx�'/G�Ϸ��*�[vLli��x�Ve+��n���E���*��cs��K��\?�7�����6����~f�7͈�)=#KZ�`ܥ%N�X[;�5?ޏ��������-">N�U�o��&����3"���[9R�����P4��VCԗoXp-�ª��B)�mv��G��"�ڠ�kk��������ؒ�[���rV�䔦��$�yKъ��в���\�������Gi�;�~��Wi]u>]��̙n���)�E�6ɭ�@�����n����Nڈc+`��`I�_&'}�~���}�H�)NK�$�ik���,���&���+�$�����\[�R����\5y��/�B�Kj_}K��"�JL�Q����p_��רܛ�5t�ݗ��P���L�s�	#L���F�(d� ?Ȁ0�D�K�=a����ve��,��B�P�$��|ݓ8�(4_�5�Li����c0Qh��Й(�*��L��{:�f����D�q�+�(4���
&
� ��
&
i�=���B�qO�`����5�($��2�淈��
&
�j8��bEv����"�; V�P�!< V0QH7�L�9�[r@�`�����(L�e�nP$�($C�P$��9���c܀"�D�q���E��B��"��$ϼ)�d��"ޓ�(�*��L�e����w�S�����qO)�4t==�<�Zm5�{���3�/Vk`�]֫8�z�-����/`�݌��V�[�)����l]/�rq�~9�}c��c޿ￊ9u�]ö���yz/F�%�/��05��y'8+T7%���\�]���yWu��ߨ��>�ޞ]��z*�q^����+��zq�������A�����v�;�;i�]v��0�́����1��P��B�=����&6g�t ��C3= 0��^���<��M
�C��.i�D�VW��^,ϔ���K��^_�M~v%�kb�Ҙd�/n���5�}��:z�Y��>�O�y�ޥ2�h+H����Y�����6�z��y��_� M���n,�r ~s�����N��(�艳bl�[�{���<Wv��ɛ�̴Z�����C~�@�y=�b��O뼸�;{��itf�x��@����^ǭ�G�>�z����]���5hߙ��x7��-"��~�w�K����x2CI�A��o�}���E��5mt�����<Yx�
�_�r�f�@w�`[��Kk����SL�QF����I	mE��6-�3�^9���6�f�B���#�Hy�b��̷"˒}{��V�|��ڳ����֖w_�ﾍ��n����~��J�W#�Hy��j����-�oG�����x��\¬BL��.}M�`��N[Z���۪B4w�t�ߺ}1�B���fP7n�j��6׍�Fl�������F��� �*���b�8����?8_�h��mZ�Y��Y9�����ݼ��k�͝�l:�)���i?�'F�����j���;��o٫u�A��,M����C5��]$�v�ȹׅ̇��{��I̔�M�{�v��}=�_47�>?6	{5�ߤz&=ȯ1t����u�܋����t�wֶz�o[��c��]��W� ���B׍��&O��|�0/������b~�*�/���a���k|�=��7q�z��}��n:��>�Ai�7m�bw��?��c(ם���'�r{���Z�_��͇�6:��39�]�_]L��B���;[����������CO����=���n��;S�H�j���r������K��B-s��ɿ�����<+�ت�S.��M��(�˩s�d_O��HG�7���8�#�u��Z�?�������S.��%%�yܥ�jFH�M���@*��MZGr�*e�o�Y�*?H�M�ځ����o�ץ��J5����W0TV+�d �"	�����T�$����@b���t�V�@��D�#2�J淁īE�#2�
㏁T���c �!��H�+h��$���rJ_M��FR�1�X�Z�"�e��2�^��i0�7�.�r��@(��@���c �8�Χs�H��t��IM��@bM�&��c|�qW���r�����*:�!Z��k���:�1N��P{C�1�Xo5	-�Ƙ�����@��%� �Ԭ�����5��d���c �^Bm#������U�1.��q�vy��^�1�/N����ċS��k ��&��c ��Ƶ�c�\��Q�Z�сP>:��ĝ�f��c ����0���@�qR�\�1�X�Y�r���@�U���0:ozԞW9`�5�K:�! ��\po��A�1���ŏ�:����I�:�����j��0˖�:���^g�0�9`$��P�Q�1�X����s�H�C�~�9`$�!j?�0�7��Q��0Ǝ�J:���_��p�*0��O��0��p�2R8`�o*0�8a(��c��	}�:��Gm�U8`7j%���8`�o*0��.���-��k0�li$���B�s�X�1����o���n��M�A�v_��@�c��˹?>;��r���33Q��L5�]x�JKq=gt�=\�	�iii@ǫ˥�^�<�F�k?�OK����)	�j��La��kd��t,q��2`�1���UC&��A4~��c��,ߗ�4Qh��3��B*u_����mQ2��l��:(Bo���x̥�4�#�G���c~�mTh���(��s�9ӷ����Lt#�`]D�g�0Q�U$�ӻ�[Ɉ[��Zj��-�}�A�����&
-�{n	��vd_�%L:��%,�=���B�|�-a��%�o����0Qh�����@�u�-a��,�sK�(�*�%L��{n	�f �  ��[�B���g_C��0QH;�9)L�9�9)LҎ{v	s��v ��4Q�]�?�1���6��-��A�����D�R�(d �Ƚ.�����g0)�i��Y�y����Vs�ǵ����{=�^Q��(�%��^�gyk9�JE.���1�3�-�����=�VX�������3��)'����Vһ�K[r��gLol�u��櫽6�E.D��I;���޽ܫ�����zO���F_Y�%�a{9g?�\~�&����zo�����p[a��ꓕ7��b�������.@��^��tɇp��IZ��i�#'׀Y�B!�Y�D����Y�D!�r��eLzUD���Y�D�YF�����B2D������3i� =N�eLzJ0˘(4_ȟ:`�1QH�̗z�,cj/��=���B��Y�D�YF�����j����l��~z��V�\>�<5$�05� �p3L��a�_,����&��f/c����?��0�D�8(t��:�髎�gO��F���g?�,׊������o��xLG��խP~|�uQ�oL����BTa�ѳ�w'Kz�az�V�}s��}���|V��.sy���F""q�ew~~ԭ�r+#��0{��R�Rܪ�0h߉/�]��$�ݬ���Ӡ�Y��
�x�b��4�j�4���&w�ƣ���m������'vj�����y魏�
}�[�%�kc'�5���Q�NS%ylGU�yQ'�h$����7ח����ns�ô[��lNݛ��y�R�oW��[Q�}?�4�G����W���~����Vȼ��ն?+�W����c�"[���U��٧���,'S��|T�����F�So�9��$��s��\�k����եYAE�5�w���������TU��z�Q}�W/������w�fc�۱�L�,��*�?��'�F�t7�R��畩q����銐���Y��/��7���7��&����]����	�	�b���^(����å]>X���NEW�W�E����㖝󡲍����u��C#=Sآ{�0^��t{�H�����U��*/��-�"R?�\��gQ#�	�'�x����W>���aѯEr?�%����裳l<����l�(�{��K>����Osm��99d^��3���پ�M�9�c��ޙ��~�j�s�z;�Sc��:���b|�[Dȿ��u�̍da�9�uv�)e�j��W	�I)�ES��G�����N�Y���yr����!����L��|p��'�_X뒞�;�tZ�V=�څ�Uz��Q����{�M��~o������/b���*�K�$vΨ����M2��)�5sy~�2�z[ۍ�.7*�j���d:dsS��L�I<*�52�u�ȡ��F&���+t��q��F漎�qu��壢܋���M?���vmխ��{3��I`�"u�{����?0��ɾSW�Ts�E�'h�\H�m�G�2]���s=����n��?����V"      l   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��_9Z��4�H�ձ��L/�K=�������5u+      n      x������ � �      �   M  x������6��3O�*��)�[ A��\8�7��8�������gwb��Ͽ�w~rn�ҍ�C�L�/��Ԕ��p´*�·��:ׄ������Ƿ�az���?�~���>~���P�����aѦ�]eU��+�)ϼ_�����A��s��=l����_f(�	��逅���X�󥐟W3n�Q�b�0�Zw]6u��4��˥j�~l`�g��5Brwc�����-{m{ʼ
y�Q���s9��x~(�=��To�����`�eF� &G�A�rYy��c,:0�g�Gb2�?�K-�g*1G<�/*��(�ץSZV��$Η���] �� �e� u"^+���7d@q4O��h�iWb��!v�\?�[��7�ix�Z�G��l.�໐/-�Ũ�f���h̅b��Q�۷w ��@�ٸ]?����![¦�qi�Q�H5�N[�u�Ҷ)�GM4if�`��¡&\B���oE�W���j9L�r�
D��d=}(�n�j&g�s�۞e������?B>�.y��F�գRG���$Q�dj��@^i7.C%�dַ<��%b�n���%H�����K=�q�7% �@��"�*���&� ��@B���ZzǠ���NĬG�gT�ݒU��:���yT����Q�e� ��:܀�wI��Z�L�\n���������7��>=~�c�����w���w�o'�IɹO>j��z�ز�bC 5���_�3o�`�U���$�K�`+�tNȃ�Gw>z����4;څ�<e����3�j]>{�����h���OA�]-���$��2J��I�4b���mF��2JpA`r8$��F��#`�~i�j}h� ��1�8��Nr�6��(1gl�Gq�ڌS���3�Q����B�Gڕ�������1a8v�AN��p�|��3���:�J��U\q�i�ߞ�X+ g)܇Cq�Jۓ}�(A_3��p�P��H�+O�{��j6v����lN+��:V�����x�G�`�+��᱅�ԟ`+x��z�Q���ϓ$�t1f��1=����]W�6�o���Ѭ�%��p�i�+��+��_���>�=^hv������U����P	�ˠ��<�ލ,CҮ�|��\N�YP�Rn��aF	ښAG���I�z��l���0��)y�Qb�r���ԏ8ϻ�Q��<��K�2B6���;
m/����B3J��s�<�.���2&5%�!˹\ݸ��{ҚHr�3�]	d=�������ؿk� N!g���b�(�C̐M��߆���K�4��Ϥ��U �7 	�#I�7y�lj�r|��D�=�^iF	�Z�$��3��U�)e��ܕ_� ����      �   �  x���[��6���Vq6��/^D0� /��&���.�'U	�ꠑF�'�o]H�����=��K��{���Ç����{����'�-�-����f������|�u��?!>}� by��{h�6�)? ��#vS*�'
���YtPy������p|7�>��	��~6���<��p w������o:w�����;!�w�p8\�˄����;Z�ֵ(�P�[T�@Y'�L#��_�:-����Y��#T@��]�ӭ�빪�%�ߤV�rе�EӢX��?�>N������v<aM$=}�Og�	tb���ޑ��x��
M ?��z˽�K�)S�2�y����k��R�E��˖��A�[4��������֟�H��ޚ�E�ϐ@$�p���ɼe���f��;.�-bM�=CB�D�,�-S����L�a����;M��(C᏿ٺ~\'��D��,ZF�I%�Jz�sPt��0�L��ʾ�3Z���&TAȓ���ʦ4��[z��F��c�Jd }�����Ǭ#T��,�\�ϘAg�+��a1)T��¯� �g�~i6��]L���ٔ��������V��G~ңH[�[�ʋ[�)*Ϗq�"0
�{� +g�)(U��|�� Re Y�[f2eh$��7���G���W�x�L��k��%}��J
W�Pۨ�����~/I��r���X�]�A�BG疉DÁ���eg�RtE�h
��7}<*t��\�R��}3��-$`M�=3[��5y�5y���ˣ�)���hQ+<sA���n��"QAbZI�_�&�/�h"��Cl̚����n����=�h,2^t�H,� �R|4�08q��!��ƻ͉��Y4�Dn͢ߕb��#�M^�¯�EQ���RW��zo@ٷ@�߲�!f���,;x᧛#F� ������W2e>!^�!X�a�O{�>�]��]_���(�,�P}v/��:g(�����H�S�����d/�����M�ܢ)����~��5���Da�B�E[��t�� !��y��O����I�����|�/�� 	l�������h�L|�R�-��E��7Nt�̄D%)���R9�5�E	)�R��\��#��vĞ<�h�*
������y��t��75rT<�Y4�#~G>��PRV�Lp(CM��F�A ��|J�lJxyDq/�ȴ��ǻ##=^�ǻ#J�6��ݑ\��������^nzQ┯��?4Ə�G�w���#��e�:�()����i��e|��<v�-S����X���|͍�M��2�7.�|�G7�U~��Uܢ��~�x�*\�n��.��¬����I��jbQ�+	^�m|�ł�g��J?܋x�喙���I�5�۟�d���>�2�+	'W�c����i1:�|[���j8��/�=jȑ"��b�����k~F����6����.KE�C�2㋫۴�D<�2)����\�ܤ��Ej$�n��2�IHf��֗2���ŭ�e20�2��\ͨ����[�k�e�~��V�+g�ۊ������v�r��ĵzf����	��3F�J�r1��e?)�t�Yf|6O'��~��ŌWf��t��_� 0�#���ت1)ylI��N6~����ď�����8/$���pmfѤI%1��m��#.=1�L��]9sM|)����(��,�@$��4��B~�<���i�օ���#g����G8/g���>�E�gM,�s�:�\Ɖ%��ILWf�2	�Q�ď�Wf����/_�3�x~[M�&�J@��g
�ES�����M����)���̢��3�3�6�L|/�U��7)�[����͉L�Y4~{F~��N�	���l�J��a�"q8�&UN��E�w��+k�M����a�� ��C������-�谣�v���/�����]�yq��'
â($G
Q��6��;�8Uelj[���-�%���#̮�0]^9�M��`v�&�Zo
�
qˌ_�����o��bM��;>�t?9䋬��gn�fh��>�/p�&@I6;��LXȏ��7�.J��[f��|��g�3�U���8�_R�Mܢ	P��N4¤ʴ�+���KX(�P@��6~��%�"����&���dN撸G�-��8�0�keA3)D�0�j�J%�o̢	P��1������<R��?�S۔г?�S۔4��5��g鹈_��k����;8��]M��s����|�;��S�?p��D5({��$S>?_Y�M��ϯ�(�@�O҅��̄�s���M�D]����cm^'Pv�tkߋ��;;/^�{�ܢ)�_1@�V�i����.�r�LA8�~��;�p�&�����k#����Ot�?�(��_��e�&���n��߰��{o
޶����Kϳ�ϯ�֓#��h
��o������-�=fє��g＼�>�i&��J�?�#�*��7PL0f�I%��=��ES
�݅>��&��-�����p$�����_�����եop��_��M!���LL
o����P;өȷ1�ESJ�AI���	["W>�@]�+ߛ��9���;H����{���,�ic]��E��$uzv�宷z�_�>���G��OU�u1��J�&���i��
yl	L*+? b��q�qW�*�@@ٓC�.uU�h
��hYƁ(�-3��� o�X�U�[Q'ѷ|���^[ПǇ���=��x�k!�y����Ψ�Rp�h2�d���u�&~D>ܚ��v��V��2���Et���E;f��+�)�Ξ�~|
�5Q�>S��ݢ	�W�B��;δN(0�u���=6�c؂�lfQ���O����|�)��Q��X?a����������0���ݢIy�*b��<����[��&㥋�E$�P@�?�#_}-Ũ��k)V�G���%N�j�8��r5�#�?'&�$"����8�d�0���������n�")�G�1ä�\:�1#�@~�QIDXf�	t���E%9PQ|������дP � �Ae�G� ���|Y���=�_��[4�Ld&f��+3�įȇ�P����3=L�*u�V�Tv�S��k�{|�٧�BA��ON^�,�B!���q,f|��
ה��Y4�J	�י���7��2dΏ��W��Q��2�Yf����B"�!�8�Qb2�=�'���A<���''���Y4�F
̥����C����?a�˟!fф:	%�ؑ�%&��;�B~��b���p`f�7�K_3�x��H��]��MM�d̢HU���?��������      p   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      q   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      s      x������ � �      u   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      w   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      y      x��\k�,����^�l�ū����u���B��ݱ}��!�Rt<�Oȟ�	������ӿ[�7��ٮo��r2�8��2��ߍb��5^�z|��0P�O*�z~��0P�O���o�X��Z�=(5|Sf����o���It�R�-V��X�H�)�5�����4o��z|����=�}2������W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6쟴�c��_װ����0P��,��b�U�>��b�ũF|R�����6��DS��)���j�ix�D��6�C���u%��.|bm�\�a�bÖ��VK4�S�Nm�,�0P/�k3�����^�bNU�D���bXq�cuJ���ݖav2ŻM�&��z3��À���ף/l�cu�sS�0P�sZ���9��1ba����X����cϺ5�)�H���A�7�������^鎭Ͷ��NѰ:M�����*~cb:�&њ�Ś�N�u�[^,b``�S����n��au�qX?���`��vzkv�����B{����O
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      �   �  x��Z�q�8���pr/�L�q,H]A�G����"��=Z� �(�Җp���3�	�k���*3?�=���Z"y~�w��5)����iuMN�yȸ�e��\"�Z����"��_׆HZ��h�&"�w��svzԵ!�m��5Qs�m���B���r�]r�q~������Z�59�wS���bμ]ԓ� vj{�o��X��h�S�ο�F�P.��SQi����,R_�;�=��vSsq�i�$1�Orϱ�!�Z�B䂅O�P��!Q�z�������Ii������_ 0G���	��f�����儧/p���	�:��R�
%z�`, ������)�D�����W�*�~����/[c/���pT��B�rT9Zr� G�������=Gc)GKc�:R�:R�Z�D�X������D�P�V��s��s��s��A��A��A���E�؂������~��Âu!2r�QqbKã0��I�� 7���&	��ڐ�)�IE��n0�d���!s���Q�EڧÕ�zak�D���������i���Th��:EZI3լX�]�8%@��=��.t("�:lj�-pP��CB�m�86 �C���3a(vP�]9Ɨ�x� �d������ڨm8��v�y:���Y�S*�o|c:ˬ\Z2+g�8��gԨ�������Q��͇9��ݒ[r2rW�:2��|��<��/�0���$�L�-�_����Y�wtLڙ�
z¼�I~�\��L0%y�t%>8�t萧��ed�_����;��d���r�Y��\�C�K"������շ߀֬���)���9�s &��uU�RZM�M3��"`����I��K�����z��0\6�A�q��.�kÃ���e�Œ��bҒ�>�6�3��/Ͻ��ҚԜĳ�����K���![~ʾO*��,&mhi0�i[��(���+�`�Q�S�����1��)�e0���D���f���AX��F)o���0:7���(�Cx��/�j_<l������D��;t��F�e��QQ���'��x�6�N��o���3��=/�����H6:ٮ��c$�~��<���	F�H����d�Y�޶y7e<��Nm��y$:�!48��S`kP�5wt؄�a�������$i-[��֝��0�QJש��R{6��FV\j�u�]c̛zh�w���Qx|N"8�(����n��N.1���O�L��X��;7R*mx���_v����|T^�e��' �W���o�@Au?vYz�Ӌ�H�mca�,R�~Q�k�[Ɋt��v�8����2��Թy ,x}�ЩQ?ヤ�C����W+<�ֺL��qI�i���h����K����4�5�[�8�a�ȧ��/C˲��7b��&V�ՐK�D.+惉�o�/e�'V��j��o5�p��aI�MW"�ds�����[~΀Qf.	J<;����v3c�:�v|i�p`�f��������o��wR0hn� ���<�9��J�U�8�t���5&��)���c��~6�\?<!YH��!,��8��2MpT��K.Y��թC��B��I��X�ߝ�X�D�[�D�K���}�Oeұ�k��;�:m=I`IxL�������|%�Ծ[����9��������o������?a f      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�PƯ���/�?G�}n�^�A�ecP(��X�d�%�����)���̕�wF?�ҧO"�ͻ������������ad��j֊1EI�Z��h` �c����������q<�b�F��+�$���6� .�r��s��ay�R��Qk�Ē�
�Xǐe�g���<Íf8���W-����7�'���y���-c�L�2���,`��]�=������7��4�>�S���阏�����^!rQz�K���:,AO'RP��|8<�՗���®bNha%ڎ�qek��N�e���Xũ�̜'�*XIG:)C����PKkO:�\/���F���`��g�]8�L��4�w8�����7#�9P�#�o���T��Oe�֟j�7C]M螷� �#ά�ǤINN�v�Ğ���|��їhB��<�ۑ`�ۺ�L,n,ӝe{��y,-�<�mu����,�R����
 ~>�R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-������K�$���s�U�
� I �Zf���<�B(y�X��YW}��B��(�DFi�jloJ&zu�p1!�7e��p�A�k�@!�j]'s?��4\�pB��g([oӱ�����۴�I�!�+�֖{�l3$�Ԟ�!�A�*vu��k���Z�R�'U�C��I���@�#tYx�����'Ն������4����~�AGh~����d�0/�ҋ�2e��1\<����y�,��}��=��rօ�k��lI�F�p�&��cr�kg�O<�D�}�s�<�U��j+
�?�=d�|օ�آWW?�Ն�����RQ�ž,����>�=��2ڍ���V�R�a�<���soA/~E?E��Z|�W{�z�z����ir7�Q��ڞFғ֋��UZ�%����Ke�E�xM��E���F�}!�I��u�c���dBF�H��n���&�0y ��0��g�[:K�cѐm�e� ��!�j�d~˺8J���E�54u��AC>p����^�?m�p"���ѷptK[�Z��n�u����'���|�d%+����5s��khj���[���� T��U��2L������o j=_�2"�
���?��N[���E]��~|;Wz~���`�F�[��I�c��������3��B0�E/�wL[���j?ryEk�^+�K
����uz^��K�@��x�-敶����\�ennړw�(����-%xvF���|`����Z�-`0��*۹��`�4��ڌ��y���U�R�v�GJ0�P�A��(IwB��7�񷿛���f���/��������;R�peu�nC]�u��J��}x4Vo�nO1����E	�Q����$.<Q�(�]�`�μ?����;"H�����P�yooJ~���v�:�y�*��%��~�Z���U�BK^��=���9�/٦cw$1�8�G?�/Ӡ�'�I�)�_js�Ԛ/�>"��a�(���<����C�9D�]2f~�@�����m���꽧` ��C��y.��̈́�9\G(z2'��gA=Ѻ�r��/�Tǳ�>#��Z��.�ȞYkӇKd�y�Ȗ
y�2�o�A�v���|��0N��"���QF�kZ�T�3;=�E�5�%y�c�<8`Pbұj�?��dj�̲WZ�eC%��0����##��(	��	�>��4yA��k���4y*��Y/Ə��V��s	*WR�>x���LtBj�!���5EC#Ɣ�C���t��23<fİM���E�h}��%b:n`Pv�5�T    �������`���:��}qA��,�~�7����R�5�۳䁴��[6kT7��cd��2��bxJ�Eh�A��DhP��r+�-`�BW���c�[�-�bp�/Ȥt�^+J���髮�C��&�s�Y����٩��W9b���ӷ��4L~����̃?�Z
>`�7�o햵������V2]Lck�AT"[��hu�����ҴL����T��i2y�#F��&�M�(d�.m+%ʋ�U�-��j#_$E�{:#f��3fO�����D�u!����ʽ�Ɠ ."�m����m�D(�v[/�@�7<[�t�VU�t�P����[L�$��DY�+�"�R��A����O�e�m������C�/W��6�)3-�C�	�?,�sn/'������e�q%�y0m7e����!�wS�CY�6}�7�aGʲ(,"���כ'4��%0.�Fpn��F�i���v���3R�P��J9Lz������^+O6 Mz�}p��6m�W/R��y�`��o�#��[-5bԲ�uhݞ&u�O�e��f?%5õ��1%%M�+�����l���h����IT��#��B+Y��a��\-1?ډ�� I���
�X����a�������}�	�4$|����s~{�4&\ˈ�D�Z��aR+|�<>o&�>�Z4`�Fʐ"�m�R��!����Jwi9����� �ׇ/A�T(�c[Z�+�ifk.^N�P�R�ł�p���=��^7��JVO��%NW���_�Ƨ�o�(&��21�~:JZ�vO-}�	-�߽��
��g��i��6���	Vƭ��a�֡��}�T'���4R�D4_�C#�9ax_��G#�!j-Ӯ�۲U��ȗ��!�ۘt�^�5~�fzb�cTo85m���W]�ՎI{�jm�K_��2y��j���)}j���,�#�7LP��"�Y�5:���Ab���f��ܷ���~��y��)�W�/c�(�zS�r ��0�v��B�+�(���S��I3�]�~U�	^���2����Q���xz����ۋҖ[�NIW����/��(���o�'��ݠم�w�L'�H�U�/zp�)����wNٟ((��~QG�������{����s�[�}a5=�u]p��3����~-ۂ��7%�z=Rs��Q�8���QS�%mʻ�,?���(K7z �"��E��i����4��L���j��%3�V����Cp@�&]
�h������S0��e��f�)��4;/� ,�r�豗T�ѣY2��cK[��7���A�-9��5�t����<B�!6�;(�V���&�l��:��ȼ����浧�ڙ�:MNÆ� �:P1�����^�s�1��^bJ��~\Ӛ���.̼��s˷p˽���֨Ǥ1��ծ������<�wOi�ww�r%nxi����k~����:��sa�ӷuT����֥I|�B¨���F��@�;uF�����DR�p}�h.H��=e]:j��23��%����\�s������4IR�&�aȂ����c��f��ދ��쥯�Ch��c��a	�`Y��kĘ�9��ڔS| 	Z��$AG�P׭�y�]��S�3�
y뻨�3y�]�jQ�$�&߬^��^-�m8O1j�k�0=�`��j��d�L�^���K>��_k�-��Q,�|R����_V���=E�����7[�
//cU��7��9�
TJ�}Ė�;?�W��(j�w4�
D�0�����Lᘳ5����C����eݎ�o��?
���|e�.]�hQ����?�E����C��|�6����L_��gm1v_Ŝ6����$�V[=Fd����)��FĘڔT$���,'Yq�xi�Q�~��5R�%�K�[��^��FZ�a��,��4R�f,W��1� ���b �g:`o�C��A@b��q@��w�1�q�\X�3`��t��l~HϓԷL}�l�ä	�Jq����<w��8����<��U����$?ʒ�-Y}P�!�wK��ר>ԑ7�}~n�[/X�ߔ/��Ea(л�`|��/���Y(�j_�>����<AB�B���w�y��.֙�L�h���_<�&n"�*�MP�t��q�����r�>Rn���&G�Mw���3��to�L��|lS|�L6���ٶ��`�/EK�Z���ִm���/Z�d������FBy{��X�R���3�a���P�T�0�X�ˎ#��0X#f��-���% 8ｫ�=��Oy�6��+��Z5q\7���+���<��CE�E0�mJd�� ��XjF���=�,Go}��D��g�XA���V�������x̘[��!3��\)��M*�gn��E���ju@��ar��4ތV�ct�&�b��K�|��^M��Q�#�RHCl���<8qG��_�.�?w��q��R��RR)�x�[�(��w�xb��vf~)�6�<�����E�3�K��ml)���2�6������u�!��5��v�����S0b���i��M~с������k�%P��W��"�o�	�~�ӆ_�*y�]<i�]��WЋx���� ����j���7%՜����ԕ��䷷���7�i����Ng`�����M�x-u+����΀i�m�J�����+����\}3�n�������Ľ�/}G�u,�J�����^˅\S� x�͢�(�*�Gi��=P��|C�5wAr�������S����!�v��9�?�ڃݽ�`�����~/�Ww��R�����]CĤ�VHHW��;n"�۲fi�tއ�	�8U��m�(�#��"�V\�Y���*��/�H*�^�_r��{Co�j	=��5bl����nB.o�뤐Y�nȞ&��-	ub�QښtK�	��˛�_?�%�h�Ai�~� �	�T|�B8��I�D�>�:�����C�M�_��kr/"��i�+�P�@��{8b-�v����^='�8�p�|E"��ͣ��� ݚm���+����J��z�E��ɣf�|��7��Ȼ몌�6��I�����["Le�l�Hn�E�m�a�2���ܛ̈QB�`{7�w&0�1�2��򡗈�?��Ev$�W��í�x�x]��F.���"�jT�oڷ/�{���ltmm�U�!��9P0魾�L�N<t�0��~R^�%Pؒ�Ԭ��yH��b�P�c�a������_�F�cP����!���󋲎���o�7v㶬�����)�GJ��ש�Z�\��|��:��~��#b��m�~r���e��O�zAՏ?�)x�ψ�hy]Wc��L��ZG	t2f�o~����F���Rp$e�����,�߆��,��:�&�`����fhF*�ZG�M�D�?S�y���ɴa��4#�@|b�=�!�᳇�[�N���Yi�VU+xD���28'v���q���T+w���1�����'�$���=e9F�џ�Ԭ��D����(�����B�U���J>�����M��ҽ��`�O���Zk������c*mu
�强墩@J����:��i��'�a�C4�Va%y��5�qd��I�GL�&1���f��^G��L�� )�U_��x(�v�KV)�^}2d<����o9@�Nq:B�&���Ƕ�kF���u�\���L�[(ٴp96�@,2��s�V-�}G��7���{f����3�s�4F�����%k���2Ą���4�0�������w��I�_*��tŗ6��S��7�#�>����<�O�r4sy��j�\��zA�!%V��X�m����?0�����&��00ae=L�"ӛ��ņ�1ƾ��Jz�/�
:훃�Qj�~yAȜ�9P��~�5�o�u�(;�����n��ߣz��Y�\䅁��r��#���;��K��/?;��r��ak���O��5_�^�Q��U�[��`����,�!��&�s�B�a�	�������9�}�Rd�|���oNZr����G�@�Ɉ��)y���]�KK�k�����oV���/�읹j�,���pik�1]cyG�0i�9P�nb�r�DK��d���-���QV�=E�]��O�g	�u�����    '�*UOy0���B��qs�A���=ePewa�;�^�O�׆��}3x��&{m�c�h�Zu��]��C��C%��[G�G�E��6VL���ʂ�Cwށ2��ߔ�}�)݆DBHf{3��0K�d�0W��:�i��4���EWw��7�Y�e���t[2�ଳF
Y�#bq�j���lc3yr�m��=�Ѡ%���xuR��#�;5��8_����B��[�1�.3z����y��<�7%bԊ` k���|	kĐ%$���0w~p�)ww��L�e0ŕ�t����Q���P���X����l�]ݎ}I'*�(P�Oy��=R��UF�Uw*<90�oH�:�p^�h��N���í����|$^�#b�M��u�ۆ�漩3l�Ӝ�!)��Ќ�������9�z��G����_����`��6{��u��ن�>�=�t��z�ϒ���f�R0�
9�����@����CS^8�B�ĈQ7��_���fEi�7�R�a���ÁҧWÈ�_��E�Z������X?�٧Zx�M��z��$N��?���h��/�{ȃ�p!z�y�� �[�Z)�rpa�Ev}�K����o]r�>�`��	��Ji��S�M�l�ep���ڟu��}E%�t�?(�;m��БwK����Аw��QX��䷶[�U�L�
�q��-3��l��r��[
2E������(�@�U�U7��k���?��1ͪ�Uԏ�Lv$Eہ/�u�vM5�O��C�;�~�~��&���L�{���{Q0�ٚNޔ���/�"\켏���V8P*�Q_<&�&�>Ӡ�=��ū��vt�n�#� ���w���m�
"��B_��nB>�2���e�?��s4$9��11H��My[zyG^+3b��voO���Z-Ӯ9�L�w��g�Z#��f����G>��1&�^1�yL�A�<��/�&亣��o�[�H�6N��?Lj�O�����7�f�r����������1��/��u����U���`�l?*u�O��~Ӿ�R��1���"���\���ѷ�<�F���h�0��C&�^��i��=�^t��Q��C�#Pl`�k�����'O��0�E����%�[#Ɗ.r�s��y�΀!k�^�{l[a=�L��=e�|�oo��멀?#�\Kܨi�щ1e�ގ�@�휦���u�6��;��[8@�p#��T��i�ژ�t�(p#�O��Ҷ��>E-���O]��?��0�Z�@�����K�3���#��l�E��e�h����=`��`cӬſ��{G��f�ŏG{0�)���.�n+#O��(˦w��|����6d���;|QȠ�1�5��Z��Ms����K|�̖�(����Y�����=�dB�'
�`?�2[u�����G��#��ո�!�(iL�=f-��G�Ɓh�<���Z�}{�7��?ʜ�6J����P���� i��Y6N�������"�-��6P5��G��<�J4|�p~��A�������7�o��Q�Z��~s�{�`�������Y�~F+���
��e�p,y�Ar�{�`z�{IC��#N@���\��5
A�Fy0����\�KH��>6.0w5��'ѰrEUȩ u��3�h��.��҃#��%��P�����v O7,����=yT���/��	=�#^t�:JC��	������"�����������	Ӧ�ohy�_�J���$�R��������1��~zǺ���c{7yd�K�]����t��B/�ya�}��aO��W��(l=Sݮ��Jv7�\ta:dd�������r�FM@`�t�e3R͡��<�WG亍��m�1ʖ�#���Z�c<,�m/������v��4Fa>PР���G��׼|�QЮ��V�8V>X�yQ��S�&^�۪�'��U1�u];�����Ii~���U=%�(���,y�_��u��6�#�7��{OQ&vE4y��\��Uξ��9���W/͈A�������/Cs�:�lS�^�wt7�V���Cʫ�MHzS�2���h��^����7��h�2�#�Mx��Lf$5��~��-RLp����#�-�Q�q��zH�������]|pϚ��;C�y�f_f�������䞷v�D���CƱ ;=�d��݇f�r֟��L���C����o�������f2E�u���[mq��o�,Ӯ1i2�l�k8��wy:���Ie�N�e6j���PT��sTp���u�Q5-��1d�8�un�<��0R��6d�c��2���(�ϫz�a���-���$_��%_�R�Nk��X���83����2�B��aEr��F�,������`�@���u�;*����`k�b�z���淸[ʺ��]Nޔ+L�b�L:J��Qr#�񩛅��3���iM��o)k�����9���j�����s� f�I|�d��>â5_��/�U\�ڶ�d���wu��h���1�(�4:`꥽�ɵ7�p�@}v��nkVч�H�4K����mK��i�	M0q� ����x5Q:��r�F����颌�4���w���?W�ƺ{
-���%��=������������Aᔄ�"�+�Cɿ���J|�v����T�^r{���^�l�NJyxY�o�J�Z��-{w�@[�{3�=�H�]U�8�0
��і�b�dL�����EA��T'��j�/��_��.d�� �G������@�!����5�;a���!J���ZߏI4����DG���ַ׈����P��1����`pq��4頋g�CԷ!��!�����!�Υ����sbv��o�C��O��A�v��R��@��Y�oM��y�S����k��̴�������_�5a����;�Z�߉'���u�1�����`�* .g܇E�!��G���z	wt�;̃��d!��\�b����3
tzX����u'�:���N��f<�ᤁ2�_�r�����9"��f�oWXA c��?,�0d���^�� �<J�ؐ�uLn����2��_׫e�>U��ޝ(˝��y{]t:MJy]����}d��ɣ'
��O�Ɖ�e��R��6yw��z'�@����~HN�ـ���گ�̓���(J����U|ʤ,m�����u���ӑ;�"��j�!�c����k�#F�Vh���4��	��T�K��\���	�B�kB��_���n1�B,��u�]�G!�RIe���7F�X�_�&~9L0d��cP����)3R�f���W��1-3`ɹ�v�gw���߾1s�ͦqc�+mbx���.�ƍ�0���k3�����ƍ��S����HZ���~����{�'�����|�41U�M_X�����~+�q6|���k�rF��삥�*��8e*�%�E7d�֭�ǛfM�)4R�M�Cy���i>�����JO���G��Kޯ���4D�i�~6�>��!S`p�TC���X�/�ч\�n����9��?��՝�b��hep��>`��D���~�n��l�h��^�|h����E���\E�,y M5R�<�!�A�>}����0��Ѹ��%�mh�
�Y�@�-e��X��S��g�0�!.(2K^$K�HQ��5��;�o�(8χ��yBg��q7^��?�̿�=�G}$x>$�f��ns��n�0����b�k�g$��D��ս�nHd@�mB^�T3:�%�|,����嘬mq�r^�{��z,F����ȝu�1��[_>�T��>2זl�[fo�Ʊ
{֫
y|k�r�kqw9k@�C1"��?�������K��u���-�d�t�0i��RZ��Ҧ��`��Ts�,�T�Gff�O/�va��`н�-�Ľ��)�mH�bb�Ǥs�׏1ܳ�Z��ʆ�]q��ua���������x�W�2��KK�-?
�Z�a�bɃ�����t�i��k���nb�|�j�Q���2]������]W-׸�q�_�a��Ӎ���̇����(��6u�xݿ�|z�rA��%S����8)��Q�o���V+eS����&��j���AG���D�į�k�,�����M���p�t��)�\<&M�c    �6�W�NNG:D+�[��,����\n3	�0N�݁7%���l��\oF��ɘI�`i�uMa$�xu�iI��B�Sx�.$���P�o����p�]�����Вy���[�ߟ7�Q�b����|�	�Ps�N�����/�H�6�R�p"v3�7�Q�D��_u�<>*=Rl�,
�|�r�	A*#b�&'М>B9%�(��3l���z뀄โ�C6Pg�����̈�x��4(>�����2y��e�x�AY�SK�4k�]�M�
e��II�FL�ec��/������	?�m��yT��p쁩��t�� ��3`�-�W���e�[�0��O����ǳ�&�j�Rd�)ǀn�Ǥ�MT�b�W����g.�y¬="�����a6��IC"'�����ET��ͦ�%����ϝ��΀i�dM�4tߘ\z�C�\}u�F�vx�Y�Eu+ٞyk^4|:g�VV��ݥ��!��p�қ�J�X �����H�����f��U����}�`g�rEtĥ��Hoq�j��E���I3��Z��2�����.�Im1b9`�x����0yN�E�]�
I�ټ�i@�G�B�P�&O
R����"��ʞ��!?R4*��MS��".�z5�dQߔ������Uu��S��!~)�w=%m��WL�q��O����ŉ�KAe�7U�P�Ų������y�KYN��(�.�/Nl�) �u�;���Vjl��Z�oHZRt��_�&��F)}���s�����\u��ǫ���N�_�0���x4�AۯoW���R�*I����Z��d����T�	L��m,�+[%��;a�{�\�¤zC�k�I�v����^�|���0b7�u?~�/H*7���G���h���[v�E�Χ�|0���1iA�=��n;���u�����!��8L�;P��L߄?&v|G���,Njx�<ݡn]c�%�&�xg��ls��K�?'o�#�H��c+���y�#��$��c|����È�GM�󆤵�D�;5�Ki�z�\~ar�K1j�Bc���n͍�e��7$���|焙hyܾvz�0�*]�w�Q���{������yX�#b�x[�Ʃ�ݴ�%��>�	{����F�X"�u�2y.�L������m�ݟϷ_
�������Ss��Qr��>�v�3S�Q�����B�<Hw���ce4��Kdu�B���(����E���M���U�w�j�'��xL�ōK�X�WQ��=MZw��m�@�[a�8�
�e�*�̓����E�	��{KC�>`h}'���4�R��?֧���3ޏ�u365�Q�
4�<sc����3���Y"�l{#��7�����b����w���e��Yd�2l�i�1����#b_P#��C�kĘ,�+~�p��0{��V��a҉w���L���0y�����fC2qR"��e�:���tp�	C��ޞ&w%�֋��6��0����crWBj��^s��o�Z��K��	Ǧ�Z7�QrS,����f�R:���|G�龮�b��G�y��1����5o(��`ѡ�x=���[�?|���tw'�5���A��aA�&�$2��k��iO+���(�В\�ג�%RP6[_4{�sT�do�a�k�1�ݔkd�S�ױa���M�3��򋲎�֭���4����эP��ϒ/^ٿu�VB���j6K����fd9i�$<d���X��L#�����K����/�0��&
�6��^"��<I��g[�#_½FL�L���7H��1r�SU��1RW���d�K�d��^�Ȇ��f}��=F�r4�16u��տ}���!������35�{�t�p!a}���)CJ��Jh�А��e9#�v�����M'����%H(����_xW� �!wP�WD5���Bx��ݥ�fF���j)�P1��/��XX�?<d��~�4�����ʛ�:�v�ĬS��yL^	N�f�p8�9]�Ɇ������@r�x�qIn�@|^wh�y�5
�<p�=%/��[C���c�n��}y���Zn�<�|KAdO�
}Լ-�D������Qf~O�6���4�Z�����)��������rq�F��0��zL^�v��u����Z�R����=uݳe���7�S���5�}w��Xx�o�&�{�?֚�Yj��<��׷f�%G�5��֋Q��������kG;`:�R��I5��K�\�)��3�c�˧�8%�g׳-J^q��L~�������1jMR}�.ï�\"�|o��Nn(H�Ҷ�j�?|`�$���1�����{��u��<Om��Bj���:1K�����f�=܉r�l�y�ð�l�K�7L���b��ѫ�Vȇ�э�(�0�,�5=&�y��@1�u"m{�y-�3�̳07�mCA��]��ӧ5��<Q���4� ���1jR�b�Gߢ���8�Fp_�w�ɨ�F&�!a����,L^�34b�u�Y�Jy�@Q��6L~}�!�/n%JCK�����*�%bЀ��7c�z?�Nw��0��SF�05Ry4V��o&/��1f<���:���hJ�MMz�i�nν�FF����C:N9``$�fl������H �D�Mob*O�a��h��̧���c�{]�*�/Ź���n��u��ӒS��{�����T�7%O)(���?˃w7�e������L�Q��0���W��p<Qf��5W��ܔd���.�]��J�C|P�Gak��:
�g�-����O*�!��}"�>�X�p?5�Ђ���I��}@ ���{-���H;�f	H��k�)��� W�<a���&���5b�����y���;`�Z���+x���R�#�vL�K>`���b&/�1V�0�K�M��ˆl�I���VS����C�%�9���k�R02lVoh�iu4?�Q��}k�[M}�O�4����}��t�E�Z�a<��{��0�����j����B۫�0D���J�:zx���|X�=e�#����*\�(�|EO؛�`�5Pl������J�+.#��>P(e������#��ԋ�}�7E�qf~)���[�9�Ei�r����[�#�Tl&��)�UG����5Z1������{�A;��{h��3`��<зX��A�����x�ݥ�7�ϫ�Re���6�yw\�L�1��z5[N��>a������:.�7~Ċ'_�q��̅��:�1S|����@w�ä���D�i���ݐ�t�c�D�^�ua�[\8�Jqs�.��p������Q��*�ps	03O���e㎞��n�J�;�P�1�F[9Z��=�k	�f�zC�;�a�E\k�p���}]p+%K՟ ����a�h�	#���;L�`ĵE���� sߞ���Tw+1zEt�'�n�0i2�c��YF۟&Mhp��間�.���,G~��e�UV�IK*���Q�x�Ï(\͟���!�yX�#b&,hE���Q-Oʝ0�;�dD��!�0�X��[��4mִ.�uF�w�iy�\4�U�t�.���__�ij���kaOyX���j6x�b�����{D�,cwn0W�ڌ��Wp�j�D�(Њ�劔�����KL�=F�{5�N��q��o�~������ZK��Oj(\���1j�AŇ�4*����,�@�n����0����nrO�����v��Ϧ�fH�O'��66��kTr���R�����ݤ�Fכ)ۏJ��8bغ�n�|n݉�Ɨ�����4����aH��(՗
~����C���1Z�#�����2�.P���JC"�LV�!ǭGʴ�mZ7����w��?�iK:��l����cZ6��zX���u�ݒ��EjY�����i`Վ���OB�CwSi�{���N:�Eyȣ%��sm�u{>B��]�[�9B�������H�jq��3�g�F��)&M�%ThB(���R���k�Y�{`�h��'�;tdÏL}���O�e�Ơ��]��g�n(������\m��E���-w"dه3|y�މ"B�J=[���#���������S���גF�K�LB�_<&,���V؟(C0��Q�
��P�� �  �}Rx��H�9�^���|r)���[�؋L��]s�{��<[>C���a�	�A
��a�h�a�Ec��\[�����	)�F���l�)F˓��eW��n+��:��o�&�N{ݕ�#��~Ժ����h��I���M�-���*���Iw�Γ��k�?�bܡ�����JF���NNl�\_��f]z��"r�3-o�c�jsQ,�Y��m�Mz'ͱ_T�� {9�#p:e�-�w$����s�ō<���_bU�떬���������Է/ڌ��;i�\�m��nO��Vn1k/�������)nK)��Զ��#7��0dA�)nqJ��0��DV�.ڷˁ��T9Ptyr[x[�"�h��ҺP�v����+�wL֋�I�P���{L�Q��Z�&_÷�q_���g0s�p����n7Ӈ��C���mդU��1�����EnC������6u��͇5\F,�Ѫ8���҃a_��)u(�Ss'�̣��#E퐃.���3U<az�`��o��"ú�M���܉��-A3k��r�^�-�����lRù���k 雒�`�bsً�-���	z��a.O]����ćl�̀AbY.95�*����3ؔ�&��{��h�ֵ%��ɦ5����R&_�icO�n�B�Z���Dy�މ�S�[�w�䈿�<��`|%��oʃ����u2�%�#�XJ�tl�u=����T�3L��aq2�[�S��+-b��3q�c�I�X(b&�!Z��RzH
�%�*�i��^=���X��s؛�y�o1��q���(I/`�^7Q{�K���#N<a���3dD�a$6��w�h�ؔ��.>c[7i�2���3�Ԍm3������Qǆɭ�C��/��ѭG�%L�+�7q��;��
�M�Ly�᰼�~�o_��2=��Qi���ޖ���E��늣�q�^"�R���!1x���7A1\���?,A��[���<P��;.�Ay�^<W��^�#�ܲ�܃����~�7�J��8U�"�|/ş��{�P���,��N���b�/޿Q�z{|/�]��?�~�YV�|�aP(JB>�Hy���~ɔI�%XK�cf�4�A�Ɵ�6��l}����n8��������RvL��{��˿Z�g�d�g�q��1�^M��4�����Qӳi�W�ҙ��hC6�����r%D�o?��k��eS�KٟF3����a�D��&+n�M	fD��vK^��������qc�)!��*H��ѻz�Nu�P� ��ߤ���/�>wjW& �+��ڝ� d�_4Z�`�&�K�nN�����k����53yP��u���$m����:�X}̞�^�f,��)�^ǃ#���e����W�a�x����^Đ��nG����0�U}>�D�sn�vY������[cW_�J��7��X�ըy�a�����(F���<q�T��{��ϯ�c�ʆҠ�K��1F�ݕ�,^��4g���f���<'��A���XwkI%;閏��G�Jhx$k��:}�)Z�~�YN_�uzAFSVI>��������JcC��C��oJ�����VY�vf!�*�;\�r��;+��=k��;
!g��ao&���m�uIw��恈d}#4w�)�'�"�p3����R"�y��~�^^�N'd�ޔ'�BE�;�q�u@��p_�$3�zn���gq��咙'�M�ꎒ���
U�dq�ҽf�u�&�E���9z��rG�0R\�/�@��ߏ����W��&��O��G�Ey��K�_
�3�%���Q�/�QRŶ{
�p��(��=�]�P��տ|/�g��~�䊙'�D��/y1�-e��V��0�,�xN��s�LV��a�ٺ����f��zW+Y���&q�0--��Ŵ�b���~�u���Q���:����i�1�hfޞ&w~w�������"M�wW�E֝�Mj�D܁��C��uV@8Q��i�2�^�u`g�\7&�]��ѥ��}>�,�S����H�V�/�A�r�X��SJJ���+�~,���u��*/���:�)]�wzI!㬾��q��~&3�ťy(/���l��ȼ�|������M(����k����=f�H�o�V��m�{���?4�F"���>������;̺��:9�w�,#��a�H��tm��VF��DM�Dib]�`�9`xZ�����g~Na��3'�s5�Y���rc�*=%��pRV?A`���t�<X�4�~0�T���>>����Š��B��arg��YKx[��竝 �e�
Fť_4��N��¬uC7�M#�z�0�~���=4:�������n�����x�E+vΞ��JB�en�;�8P�:������/���ܞ^g�T�!�w��P��P+/ΞF��b%�#V���1�t3�eD��-�|<�M���Z��*�L���������:����Rj����ѽ[	N%��1=-�l�;]�RZ�ěEy��C���	��y�Mk��[Z��l���j"�~��R�m�8�<��8��=Q:d����VX

[%&y�&���(mCZJ^y1#fm��P��_������]�J�8O�I��f���e�9���"cbK���|�|L^<r����ܮ��d_�����|����<��N��������||G�2ԍN�"����F�<�u'suCV������,S�'�/�
����|L�{�!��5a�` ք�{��BC���4��1�^n�����`��S�h�����~Pش�!���H���I?��uL!}i�D��K솑��z������P鄦E����2�W%}R4b:rH��e����|Rf�륇v�����y��;��FF��a�|�ԸhP ��Z�y'd����X��A�듺�<d�lt%�r�����RĈ��IW�0i�Z*GL�`�&s_Ě�`�1&l<���7'M�����]�x�Q�*�=b�ap�nO�VoJC��,,c��2��	�Zj_lf!���[�[�R��y�<��{��7�>��I�S�|���'�:Xȷ�r>,OZ��:�e%�7�t�0"�[�0O�I����.�w�X�!{�;�au�B#y��1�Dd]����Mx'�9����yM�(b�5�����'��c:�6!_�:�q�L�|�m������a�rmhn��p�40���������=�]��I�F#���?���vEʞ�#P8�~T�P�1&4�,�&4g�w�4��nS�aG��� o"&���;a0�sn��aG
�o�Z���Kt�c�Ѿ�Vr�N�hC��@�Vo��J����߲���ʞ&��f����~s�J���G9mN�Gr������9�ڵ��l�i�DA����0��ﷅ_����UЙ����)�?K*��F��Q�����8����W��{��;5�+p��]�`Э�<8�q�P3QW��EXp�}��v��7j*NV�����Fa�G�p�Mvh�݅�����C�`}�\���
o�*���nd�i�Aɛ�N��Z��/��<잻n���Q�����<�+'�(ȷ��ӫ�|��R��o�W0���(�J�S�r�)�����y2.:�FA�jn
˒��N(���_y�F�y��v���ߋ�L�1�Y��}�ȵ�������S�l�IsI�}]V��d��K�W��/����zS��{�boߐ���_-'�E���rzN���ƺ�����_��e��b�lo�W>�QC+^[Q�oJ,�-_9�FL��ከ%Ͽ�(��O�<���F-�a���r�]�H�@�ޮQئ�n��!�vK�q^�5���	�;�cD9-$�>�!��x/7#_]���S���DG󄁻;���W/���?76��J���[I�iq׾I���m�BqH�H$���V��;ao��S�K����Z��lX�q?IÍ�R�z�50���K3�y=8���q[��+�?���jr��ԇ�L'o3���J����4�&5�1���gs�+�e�&���V�-/��ݟ&w}?1�-[g�F�/�L�F��]�F���D
��*U�!��7��`�5>+V�{��(��1����������n^�      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x�̽Y�$Ɏ���(=4���"����;+��K��'a \i4��ϗ{,Qn<F3s#��L{�t�>;e+yxH�q��鏏�_���χ�/����_�����=���KQ6������k�]5����w�}<?����}����z��}W��vw���������?������o���������{W��v��_���-w�?������R������~=�<�P
KS߾�X�j�=���Ǉ���e�����{�|x�t��_>`�e:�?���-�`���������A�93t�b�&(�3q�NPE�*�z�������;��������q�0���\�=�~<�?��/���<e�����A֞Q���i�۷bf�lm�M�����w�O/��C�{�sGw֫�}�������j�v|vG�ݳ=޾����2�ܲ�M���y�^�~9��t����8��.�^~���7LSp`����˻�fp�t�훈�d������q���o"�ʿg�c�J�R����M�RO���=�8}�_oo�O�y}�ݗ��t�\$ծ,�H.��w�T$�_d���m���_���/���<~����/p�?��5X�iV�i�^��������_��~:�a���"q����v�}���?����������a���i�����?�4\�]~vw�4h��i��w�����~^wc���m��E"�B���v믯���x?�~��Z��v��t���y�N{���˧����?��w����7Nɟp�"d����E(v�=<1�c}�ο4��8z�N���r/�8�wߴc|�2̾���_��d��1]܁�_�<}������ZW� O�u��<S-�L���]�߾�K�z����n�o��_Ity男o2���v���}ġ�. .?��7q�����r�#�׼j{��w�	r��r�1¼�|�'K�ɜ�P�ʃaq��_�C�zy&�<5��`!���zT��i�-��3jWnʱ�M@3�	�$��<9W�<=ݺI"�2�b+� ������*��4x�@X��\#�o5��/��ư�#��<#)�g���o��܊�8 r� ��z��o�|������IxW�!*�p�4�+�!�h(�R����n�v�pxx۝�^��7������K�ݾ��x[�v�N�47���׬O�#��JY����3�N�P������Ql6���]�I�פG/-"]4�E*G��hj#��F��B���Ȅx3�+0����z�5F�X��1��a�����ӟ������'s�����C���1F�vpp4_܁yvd�-J��<<�ÊG0o�M*$���q�B��1��A��q�$G�$|~��07Y�o!?�� �`�t����K�q�nٚ>H�|�o岝E��I��X����)���i�Qш��xM�f������|�	��PD�h*���-Ȣl~��7f����oφpW�-����K-���aȎ��`'��3�H5}�2��8�pN�&n���eآ�}��PW�y�2��S�d��У��M"vdhE"vd�yU"�+��^��
׻P}���!+-֮�o�a��z<��_x�Iq�p�e�yx����=p֨�i8��h���z�+NPq�\��,��_,p%ñulxE�+���=�tb��\����᳂�������a��7m{�M�b;E4�8��;��H��Pr	B�M�,2���4�t1�^���1!��"�U��@�`�J>d���	�
]��1
]�(���K��Z����ښ��ew��[�ڕLpA���J��Q�t�K���c�+j���5��2M��?s�DWm&0:CP�g�(�8�ы������%���U�NT��h�MF}@B���.�0�
��#�z�Pf��������������U|���o�\�ݾ�8��G�f��&��h4yq2I��q���2&�b��P*.��k=-o���M��z82�#�1�RI���~Չ>A�˖�ʘ�u�2+(�|rnv��o�0�'���@���>T�YdF�/s�#(�)�Wv����D]>Q�B��|�VL�D����i<��Ç-����h�5Pa�	��PA�h;�k=����rN0F�{�W�Hͦq4��7�5��S�U/��=��o�D0�-T%�a(EG�qhma8�My�t���#� F��K�N�&��:�D� ���8��ֺL������.��)�����k��:r����|F�����������m��ӻ���Ǝ/�d��$%�����Z*�u�w�Jwh��`�_z�on�J� ig�K7�ƥ\�9b���\T�)J�BlYgH�l!M�2Ά*���:���7bT�-�[&��W���� �]D��"i N�A\��R�N��e�|���Vqo�o�����꟪]�[�a��P��܌4!"��q����n	

��\y��q�h`��j@@	�����[6�")��o� =��aE�qĩr4"@I�DZ�����2�]I3H�_Ⓛi�%w�z�ZE����;��O$�C#q�3!�= �.#"��0�w4��n�����'	 0(fI#�ꙉ�h$&Ac�{��>��U�:�m`k��Q[N�/"�w�������b-,;�8h[4]�6�|%��\XG3f�z�Q�W��0Usr_~��o�</ D�b��0�톘��F�܉���[HR��`
IH"Y^���}���\�į�>ϊ:| �Z)$���0ŭ��]h,������32	@�t٩~��� x��H�/�S���<�����jw������q���?�t����1M偘:eT�[����F�IxE�?�q��9���4�u�uG��Ƚ��Z�dAN[�E�}�׈)�"c�����$*�Ң�.�����zxW-.�jӣ��x���m�B�WL�̂!8�q�h�'I�����������U�\)"�����.CB (l3�yr2}����ln�D�1�6�!�!��L�?骙n�LFzp&�G��4�,|N[��2P��C���)!��)�__) I��*#��J )Y�X!Z��]���EO Wy�����C�2y����]��=-�QF�EWt�����NJ��VD-}��ĤW#%�;�EQ�	�j`��n�÷k��Io�l���P1FO����=j�]�RR2����ᐢ��"���55)&���p+��<�$T3�!rAɶQ��t��W^BI��JC�L81��ͣ)M�������Y�t���� *B��Vg�%��Y$�T�<{ߥ���ťr�e{�SɱE��JL�Ӟvw|xx{�&�������47�=c{{|�x�?�|�����uϺb��r�y�l(��=x�Q_���x�$7LA`z^ES��+��?7��r�`8K��}��x5/��Zq����\�P^U<]�__\�w������$P& Bq�$DpxF')�4�PZ�O�o�(�t!�;D�*���pp�j��M���.�'�{�����(��!�´�	���_�- �=����Z�\�LHP,{���-�ޜ2��bK�Ш�v
J`��ݨ���(UK=v�X�8�����;(����� ��z|{c^���z��NM�T�T ���34�X�1-��No�[>ʇchw����Ǝ��5��9]�Rwl���v��% �7�p"�����QHy��fH�m5�,�Z��%��!������ 8�d���	��$h-�'@S��D�h��?�M;C�������~��P\!\~	� �ު�?m��ѓt�y����v�g)!��uF�ƴt6��
�&�L���Ǔ�}�4��vv��q��������N$�x�Ͳ����Dw?��/�G�_]_���/�ݗ��പ�" s9<�`<u�JWW+�����S�"��%���b�(���0�7��/*o�������,�+Gg
C	��$��s�%�v �ғ'�9��<������%,��o"� U�)ݫL��wÃB�
=��;JC��%�{aP��!��&:��$z�i�+��3O��q����JŔ��* 7�O �Gob�;��.������/c��b�	�sk�    *�U�R�#L�HQ�u�&|���|P�xZB�F_Q!2�q�Fl��e��^/�r��31*����
V����8�q'��hϲvv䮇L�w���V�1�D���|V����`7����w�G<�}E���W�d�77 !�*|�{��iY����5�D2�+��ƕ�g��DH<x|R���T��Y�Ykxi��aF�VmBy�����
x��atĚo�lL����xx�?N��������7zWB�� w,#p���z���ە�ގ;@�%��X�lz�� ��.�q�B%Zh�* �+T� ��`%��ų-%C
P�:�tU�>���Ƌ;����.�(�X���njN��[^�ʩ.ᥓ�('�Oxt��p|O{��YM�/�F�L���n� O��yu�M��E�2��@��ժg������c�E�`�D�x!�����M������}�a������l��m-���JCBJp���s��c�y�#�T�ɮѯ=�(�5����<E^��[�z���=���^��<���%�戼?�-��ԗ����0g����n�[���#�P���w�e�*Z�iqD��a>��NQD����˭`�v����3Ԝ��f�}���X2�qIu�i�ЦM0���:Ẹ���7���ӆy�D�=�)w�7B�;`ѥ�q�z24=�+�c5  �&(�@�Ȑ4>�(db�p*�J���X`q����zx�ǲ�m�$t
U�X�r�""b0��������(� ��QZ��i$n[��+#�!u:�y�';CbR��}���ѽ.5/�р���U��ջ��K"G<�����s�-6���q�'�	B�B^B��6d�A����"�X�t�V'�R���Ȁ'}bp�uD����3 �L ��2��re8�ĕ�iC�K��(�4"ĵ� �Dz�Ar��mO�Y��4}��:VB�����>&"G��Xt>��gtUu����djk+Z�U����ܝ����L�4=w��þ�Ь�^�TA�W��W��!:�(����ajIt��F�"6�X��2)�љh��V	Bq��^�'�_��cb��e��C(n����`p���pt�>
L�����.�����R�OG����� R��C�*߃j�ŧ7��4���7qNh�׋b1'1����`"#R��a�		W��0"ʍ��_�޷\W~ZNL@�}E{�k֧81��� �|���V���H�h�>�mD&vsg$�l	��4���J��;�y��UB5-8&OH�a�a,U��f�=����F~��{��O��Z�$&=����X-�f�I���aJ���n�X,� 4�6� ���R���iS�Fʨ��n�X��a�q����Ҧ[�Ø��dӛ���X3R�l�$���J�<b�0�)�D1��fY��L	bp�À����9{[%MF�b�H���Ih��f��rL�K!dg�x�O�P0�&�9����Ce���NfV�L>�X�'���{73�(K��⟙�%�cEa�xHmIِ����#��yBIb�3��3��4�ۧB;61P�&�i��Æb�/<'�B���)�����We�	2��$����Fo]0��ޕ6C!MJ!5#�M]L�̊�a���/�:�~Q�^��pU�Ъ#_N��!��U.��w�tx+���YPU���'2䦈�!QI8�[�ɗ׼8:�*�ң��R�����uJ5� �:��|��x���)���.����0ca�M�6y#��Wө��B$�n��f�,����Ų=0�S���H��<�%���{~tJ����<��:}�2�3�̋+��/�-� 3u3����W!K�B�9<��ҹ����XJ��w)z�T]��ܪ�T E�bnc��A�O��JF	GCang��3JA@z\�%�߾���ZjBO2'CjE3� @�&t��x�z�2�+=�$d�g�U�!�2n�J!Ko��������Mo����l�P
7"-&|��"��00��!���+��R�k�o[�t����ש�	��dO4�9$R��?O�{xbH��&;��4�o��a2�$�d��;[" Lr��mYk�ۯ��x2VP�Mx�1���w�8��L���6K�?�Q�G�Ko_��Ut�k-����!���y���oT�[�	4ÂHL��4���̐ß��PC0�P�x����w�QV5����뺷���h�q�T�a������{�Y&�F�`�\y���A���7�����p	��}o��s�yxڴ�[VBx<׭�B%� ��g���m���6[[&� �a�g&�o/��Cef��ä�	�W4�b �+�9=���P���h�K��k,��6���)��o�S���M���m��j��5��ZF�A����4��R=�t�aE���[#�bU	�D�v%V=2�w$�1M��c5�q���R�F_d�htƞ������)���$��¼~���0��d��i`Lk��D�(�E/�D0�e�ٖ=����[J��ȱ���^��H�b�P�[PEơ�G�dR4�rH4�!���Z׋7'*�Mcs).c�}�R;ң3��B�<�ń3��0��J�"���d:L�uP�-�̶a\+�6�g��hD:8 8F<
D�ك�>L\�9�U�F�B�	�	Y���Ƙ��БB�Ť��Ѣ��#�2�h�7�� �Fbҵ����aj�)�E�_Y��nNs��TaE��`Sp��b�9��oٞ�:[�=/�����R�P�<8�!9���!I��QIz@F�s�A��)�����e�Ly�(���;I�U�y�P@�]�.{b��ـT�FD6D�8zx�ĵbN�����5������d���l׊e�
�����y����k�8� ��bHT�D��N^<�"C��;�BN��)h8V,.�ð�B!��qMD����G��)�H�q�q=���L�s��rt�N���Ly��2ů��2�!� �0�~��~<|�?\&O��:����Y�x�
�$�|0�E"	)yGVt����@(~^���'�z�1%�Bc���^��� �4��ɔ�iE)�*O�э;���)�S��j����n�L��a��ǯ_��=��b����M�p:��B��u�� �W)g("�*%�<�%�q�d��w���< �Ԩ
ܫ�t#ܶ���^�����!���	��rӍ50&�U���  N�,�E�Go�i����T�x�M�5��,�ϊPY5��ʨM���x`8T5[�!9����D�nЯfJ�U��@���M��0S�0%�4��F��=<H����@�_��ó��=�Ʈ�£��I#�)>�]dC�49���me��Au{�Vm`KE&BDna��<�	C|M9V��q�=�X�ժ�D���8<Y�nH�(zkg�H��J/2zq���Hh���;��O��@4����
���k��<kM��TbI��침�P	K��e4��{�h��{׹Q�m��\ܶ9t͘�f{�e}[�H�"��&�x��6����S@��dU�ɪ�&"��j�����NkZ�M
�����OL���<K�p�&�I��sΗ���7�Z�г4�4���׉��E����}W`�w_�>v_ft��1��<1�����dx�\��(oߴ��$���Lf���F�T�
'�X�Jx4��%���4&�-F��h��^&�EC�)�!�r���M�jƖ�.F?(���oQ��*t�c��R�?8zx�3ĕ;�9&u�
�lZ �pn�<�����ζ��y���Y3\�]~�E�ӡt�j��Q����K��f�P���@C1q� &�D�^��0��D�^h���0!��w��-�����1A ��;	L��{�|5�07��M���PbR�i(�}�|�V��ZR�"����il�M_���w�2���уPQʩ��A��͖r��D����iLi LdDF�HCq[Ȅ��[�4T4�EqbK�%��}y<��7qZ�KTF>@R��'M�KF��R	d�2.�AfyHV�e���{sX(W
a���U����X�]�E�"    ����F�$�M:��+�t�hxF݌�$��$��2i}(Be(��Fh��mh�hxsq"dc��xy�W�ҩ0Q�N
#L�I��M�FǾ~f�y�xE���x�TM
�A8�k�1�Uq|}@Y�:�q�1����*'7t�ư"��F�����G�P*�kH������hn�D�ǟƪ�%���M��rx�/�ѻo"�t��0kt��T��H�dZ)ʴ�½����mᖙU�ֶ�+j�#_��q;����j����/�|�\#=]o벞���yx���h��_�,S�S3Yx��/hR �)��aX D�XO�r]I���Ә�*��� ,�(�v �^�#Si\FZ��؊K�yW�"nA��J#I��-�*Ӵ�>�X�_v�j����K��_;1�Y�l��7����mQ�X��RIX�ptF�*���wCDP�{v8��O%��!}���u$Q���	����z��S�<y[T�Ҭ�t2��x{���d���\BHLK.����R!G8x.�6_�ߩV�߻���K
 &��h�:E��VkG==�F��'�y�]�VI��]���MO9Q����:�2q	��x���^N;b�����^2��DB������(�{L
 Db�`���$̤��>OWn*�N+Z���|��tO�Q&�,z2B$��p3ܴ')~�|в���Rx��y4�1�D�j����W�r	�_��gr��fq�KD�c��I��r��@=[l*�CQsl��υ��\}\ֵ�-�C��"QuZ/��Ţa�(D
�!T0;)\�:A�`�3�(�!��`�2���CuJ�Q��G��JYT&�P�'��<AM�ח�t
XM ��R.���):�S�T�4��9o�t�A�-��C��R�֗-y��vၨ���E׃��N�Y9ՙ�����;t����y����9�~�R|j��4��ɩɦf]5�L�Z=P���ȃ{�E�8��������C�*ƀF�2�'�c�t$a��5�D��y�趏����:/��K�ʜ!4���Q�����E��V�è�ٜyx{���O�����y�=�~<�g�������?a�:�1��9���bS�/�x ��MO�ʸ��F)ztv���:����-a!ۊ�n�K�J�ԃ�X�v�2�v8Ȩ��$-M�1�
�6Qu��B"���B�c�WLV�_����c� <�jE��bZ`�TGPL�������2
"�TAD3c5_u5�ƌje���ޘ�2�%�e�kht���t�X�B�ݖ:%�0׫�Rq��U���W�I=2�	±U�kG�d�ht[�M.3e?d6��AI霜ϝ,�]D3�GH���˓IX��ʓa���cc���'뚩ЪHX�Ƅ%p��[��b�\�SVA��DhrR���U�1N�154[�Ǥ�Hr!�A�g���t�1FQ)T�a1��F_���x�)BX�X)�#R"���F�br��
	@49����f�ܾ�|agLpШF)^M�lL���B���9y{?���?��ɝ����?>�$�Kv��zhp�[�&���oTqx��ԭ�ŭ�0�f�"b�ӔO�w�&��	��]���Pt�"�(��|�����Fn#yE�@`��e�LŴ� �<A�ǉfS� �"�#��M����Uf�)��6%���+z�I�F;@8��*]�xB�d�s�JWP��N4�}�	�~�A�%BbZ�����]'-�]�	��mC(sà�m�}t1S��L*:���T���G»g�;��%׍��]}#F^��K�3R�A�b��2��5I.�2c����` ����I�Z��8�H�n�H�8�m��:eB�z�֓��t9�Y˜���BpL� �r��f�_jb�
�\	%���u�/#��yz.��W"�B(��qe׺VZh����.����፟H��p�%�ANUݾ��l��ֺ��%��zg��&�1ql,}�)BW� C��m	��c�u�$#(��)F�@Q�yK=i�U�V8���zDFH���l0���3�5{�T1�:�8SB)�IDI%E^+r�zwVs�c��ZY��R	D�nc�9��R1W��a(������2&	R�-,mk�׿��lU�t�I�D��0p�^3�9��+�;��Xe�^��TaN'@3��X^Bc]�
 3*����"���qn/(��ϯ��,��Z��޸T?��+��o#�N�!�;� mS7����6h�^�����%�l<�eM3öMB�C�Ӥ1��4�%�S�
D�YA�
]� �FTӦ�\�^ϒ�ڌ����l l,�Z�(%{��p#���\"��u��(V0���#a��4s�^�H��0fy �r��t�����x�k���g{�&*0�L���Cן��O��DK�a�,�061 �m0�h�&�1��e�����Le�n��sm�$B��iW�)��S����M*m"(�k7Xq�/2�e��6�.�o��2D�3U2�?`��TG1Z;�j��A|�� �DS��|��eQ�B1$���d�HŶ�:E���"�������&��CTG%�z�JM*����4#��*�Tb�^��
]��Q�5�C�۶����L�B�R��m���V� ��
��a{��&��H+�Xk�@I�O�L��b3�e���'��NP�rA(�%!*:L	�S�e��-��1[�fA0ls� �M�����՗O���xg�$���������J%O�e����1�S� J������b��7!$�!J�@I�6����P�w�T<�"Z׋JD=��lP=�'\T��D)}�	��	�h�����j��Zhy}�0�D�����H��j��y�N�����;��f�Lú��55L3�wa�}7@ԩ�RB~j���Α�4DcM-ҁ��ov$��#8L7�
DD`���
��Ȕc�h�}�҅��>]�H�0�a�N��0�I��	��&U�0�h�U�w�T[��Y��A���CFg��؆}ITӼY1�9�')��.#deu�&��#�n�������d	|�.K�)JRi�)2�Z��kA0l2�gt[�n�MV6��3�J�ǜq�*UaS����B�@4IVAP6X8�eҝ��",���t��C�hJ��Ng2ű�\R��:C�q[�~���Ɂr �-:=�j!�ᅠl��<�,�I���������	J�~Eh�W�3u�|��LTC ���=���ዺ��(6(8�p�-]r1�:[6�4�*�"8�V*� �z�8~��@k]�*����
�i��X�=�]����sV��`���CT	%7����	���S�Yb�P�<K�TET��ژ]����(��V�Ôr	�[; �b��s75㺩�L[��nw|���!�..?ﾉ�`寊�Շw��w�d$�;I��YTUI<�1&=����*cؠ�M�����9]AS�6�+�e���[�@��k��m�h�ݢ����bը����`����(��� �M�yL�[=ڶ5�7!�81��OO��y���'*QB	�
!���g1��#R�Cٞ�����4M�����$�h�:
!8"�\I�dLc*����M0v�^���[%�i�UN1(�R�Q��z��c���8a4���@RnR�n���~FңX�����c1EsY6L�e���q�4	�|i������O�W̃���0�}�)����2sG��0t�W��iK�F�`[ʘ�:�t(��]�F)C�H�Ơ`(D�A��_BN����<f�:{���U���S�@��A�ۺ;$��q�Ŷ1Bc�Z�`�����(���	9���SJ�!Rk�iBx�8M�{�4g��9_z���\Qr��oِ;�Ch�+V�,9S�KS_Y�,Lk��E���Z�1��z�j˴��!|���F�)4��_�$v!$��]���u�^cL�_͛fp��2N��B��i�xU�V���`oǲ`�}LC��N��C1-�K3�~��P_>Ŕ6���F��v���B�t��a-��F�L�ۤ�����P�c��7Jϋ���+�2�pl���X��DM�zB1H�zB.�"��7fh��y9�Vf�M @XҤ8��jŴ�>��<��}��z�;�W    �@��"Fy�q�޿�j��)Bc|�C��Kr!*��,����
(��o1���o9a������tTYI�G�b�x�E�)hx�B�j�XE���9Njng����6����8O������˧����?����<��b@pl�<�8 s)+���j��Vv�b��(��b��iz��5p����X��b!�5���d%�x��X���V\bf��A٠"��%'��in�;�tAEHL���HnY&X������ f$���Q�5xc��3��t��*��>���@	0�Lz1<Bc-�"�ٸ��5�~}���{R�%��:%r��|�1��
���zz7�� iB��`G}M� A�u�ir�B΂�l��N��JC�u�!:ɍa3d|��$�Y:�m�k"Yż�ju!��s%SX��`M�&@���6�,R����dl{�ֶ��ό�Q���@d�
5OD�۶ǰ��d����2+���1x��۷��ۛc����%.�.?���,��rg�U�����` ���D�u�QI0�Fߞ`��ݭ��K���(�hT&���|����)�P�O�0D4�杵ƒ��T�W����22T�d�ze\ae��W���D�hhpS!͗���b��!�T�(�Ow:�J�G�ۚ8t�F����l���4�e�
�l�>b�*NP�W���p6�^�?(,ӂCٞ8y�)ɪ�Қ���Ԥky�����MS����(Q��dC�(n��6�I�lv�RR�|Wh��w($�G�o��y�h��v7Bc��鰍^M.�I���YQ��ɸN��ĕ2�Ѩ����̱f�q�,��s�e}�֨���H3�=���vu��&�h��/u@�0���0�`�t�pl�N4��G��B�7)�m��j�&".j+�#�c�AK�t1d�ՔH�.�H�)GhL+��:b��7Kh�S6�@(�c�%Wo���w��o�t����,o�Dm��1�1���I����|%#iAPl%-d�݂� �m��Z%QU�� �"��&� �δ?B6�>z�!�P�/H�+;�ɻ�r�6"�p�U �ۀ���d4���h*��*<�"{�b>�i!�+S����H���s���^���Đ��R�ծ��jj�d.@�e��w�z�1ʎ����q�ڟ�����;lL��v��a~a����7L�5.���p��a�͖İ�
��tҲ�}�����!3Z+�Gh|� 2y�j&�J�>Bc��[g{��d*V6�J����i��"S�A�^A��9������lvMY�	��g`��������<J�D�=��
��nK���-s!�������Ҫ' �����C����n��(��`�I"�^��O`
Y���\�L�]����7�2$7W�׎*W���c�b.�)�*{�7Es���������������I�����\��}��1;H"���&�ʨ����oZj�мR�!Dc��T����p�����s'��EP6Xd����2�B�A����D�6�D�3�Xź7��,t�դ����u�οdP��$V�	Fj�BD�-�C�%#�y�!�|}R]`�/�XVT��h��La4�ma�P5JÃh�ו���&Ch�:A�����):vŐ De g�-i�2�LeQ���2�0��Ls�|\P��i��Т�	sC��H��!ї�&xKьC\K���}�f�<`��:�RU�ML�=�7c)r�U��%��jb�!1�����T�^.��2��(�����7��h��1�5��7g*IX��Y�;���+����(֔�J�Q�>��v�*	�EJ
���#<�9�4�̘�2�����y���s�UW:�N�Cy{#�1>/�&�Z#2	�B1e�1��|�Y���Z�⠵�Pⰴr@����4e�1���{Ӡ�`�1��^�����[�U~�J��1�b+���3LK
���И�$:ᶤPl��땩����c�L]f�q��4����C�#�2j���1�~h`N\M�t�ѳ��|%h�91-��h'K�G��WSp7�f8�&��S�;+	
Bc*]��y�J1Mǹ�uG�+�1���J.f /ٸ!!�:�VmZ��К������݆oz[̣qO�QN�bz�踐÷�LF�o��_ЏM���ck�ф:S�H,���f�A�UځpL� �J���ɞ)˭�#r�5�ED���q�}� ��$�BN�(c�^�����RE\�"�t(�/��̍�j�6A��Xy����p����N�	{(�>b\s�ؐM18e��2�K��i�m��2���g�9cCY���e#!�j4	�"(���u��0��,�~�L�`�LsL���<�b܈���\ًL�}�`wz���C�����Z2����oZV�H��ʝ 4��_�ޏ�/����ï�������<+9ь�`j�[�X�&��Ƙ�z�Y�=P&@7 �5�&�� �-�h��+!V�s��R��}Sq��4�eT�Mʘ(�mB���4S���m��4�U�Li��`���A��A�q]t�9h���L_�?�t�?&�E!�^�.`s]��k���'5��)ㅪ6lqz��Z|ۺ���Ej�Y��N�f��� ��9}�W(�mcX�"���d�&�LGEhLC	(MS9)XB4�#(n_!M�����E�4wP
I�5kc�!	5�s��y���4w�/~&S�!�^}�Ѣ�b�*�*�k��4>��\��;c|�e�.?��7�<��L&��>�ė1�U�+� S�:G8�H���^�ؠ^�h{/����Ҍy@�b�%�-�^��e�=�|�bZO�N�Ha�蚢�(VL 3�$P�`Z>��*��l��}�F#���t�Ĕ̝��b��YƦ\?��^E����\62�0�u�~'	W(�_b�e� `�-�B�Ȝ*�p7aJ���i�-�1Ü�mhƔ��I-�c��	T�^�:"�눴�6ѲK���v)Z�-R�L���%Ŷ?z)L�jt��5�����d.��2{�������M� ۦ�$����fO0&w�a�a����L��b�ԨL����.D��ѷ���"u��C����"����&��.}�����^���gD3&�S{V.uH�{A�G�D�W.�%��pb��1K��o���7-h�bҫR2��&h����L�!�a1֞�4��6��S7]��a�4��W�j��r�z���"�
��l[��);�P��G;W�`t����Fg���<��N�0����P�^���kXB(L�f&�.��k!a��J-���n��G��i��G�7���\���#���ӯ�C����������O�,:�Eᖠ�@��V�i�G+���sA��t;=<������CPa���_���M�xt��x�gE/ՊQ]kް�_����\\���Qpy�gǿ�}{=��9�n��n�`����I�j�& �Z��h*��H~�����L=�D��o����ix�x;��������y��/O/����5}�e�gSo(���6Ej8�m*��ẍʤ� (LA��엨�<J������[�1�dI'����w��k��-�ބ�2�^0I����"�@	�\E�D�eFH�Kc�+�d��Hj�N���L �����a�W�{��_���MD���a`KB�4ݮ�\`�m��׷o"�~��Mcq�|���[<
��`6Ff�����Ni��7�k	>�噽�iy��?O�i������mx|���	������ϧw�k�����ڶ�36"���Hn�L�z*�4P�hC*zI� "�ǅ��Fo��۷�%\�(��q#R2f==�#*H�R�W�$�e�p�����A#q>�WigQ֓F2+iw�_vW�h����*�U�Ʃ������R�=z�
�4M���}\�t,\���e]\ �s��� �y�E�N 
��+�`}@e�[�SW<� �l��7�}&�]�BB�����q�5k`V��"�J u�zQ,.ݻo�$hJ�c�$MBb�AiJ�����L�T�ųsN.�v��]P-�i��    ��u�I��0;]�������'���_���/uw�&^��P[5}��V������̚���o���/��7J�G�Ek���&.''�� @�ET<�̒'��&�i3ϓ��Kϋ�Nk�e���˘�GF8��1?C1�`i(�6��Y���
Fh"Si����/�����Y{�M�@t���8�e��/���i4|0K�i�9�RBT=������љ�\����0e"���$�Ҫ+*�×͖
r�x�$&���2���]�8�\�����'�",y�������O�ewR*���ܕ�ܜ\��InZ��_;$��^�Ui���h��
蒠���p�ޡw�f��J�Da��E陖��(����[!aոҧ�aY�S�	Fѳü�BV9�b���r�!27"ݴ�(ܽ��hT%<S"jy���7m��DF��4��rblBdބ�f��Fp�+�A\�'�$oA���O�rYX�nZ���><5+��C�����׎ l�2V��G7-J P1RUZA1m�v��i4=�&f��y2�Z+/4�qg(z��c�4���$x���#"��i0Lkd!="�b�%���T
��:.t��ޯ�;��N�����k%�w���c ��t�~�8B�(Y��y���c��[�.nZ*,�a)���-)J�U�<�2�Y%|+C\�'��0k����������1e|pO�v���\��8?��Ƿ�O/�.%<����DH�A�� ~V��p6�-����p��iL�QgRy����_�Y��bۀ��W;0����J�-��f[�?M �1)�'N���[FW�֐~OY��(�b�O��F�$B�ԾEPl-~�YU����j,҃0�V�4�^Y(al��_3'j�������a�͝F�PD�mp�m�I�u�������Ht�S_I�S.�h>h�׭L�������!e�V4���
Am� ���Ұ@ �������w	}��V1`1� A�uiTL#1�b�m���T_Nբ��~|~�~�y��������ߗW�������?��9nᥴS ��V+s�R[Nӱ;<~>��>^>M�����˄���x�2��i�����'�_��zy��}Ӏ�i����z����K��K:�`M~`iKy��?�u+�UT/��ivc�{~���N�k�U����6Ե\z���_**b^6�n,wϟ�F1�z=_ޏ�Ʌo��d��/��~���B(�n�wϏ?A9]�}~�M��E�aY�*��J=�k�n��k3����I�kz���f�&�@�ݤ���]�F\�?��h�� )�.�KE���J�Y �>	q�R�5��ȭ����s�V�F�f6������˾�y�=^&[l�r������s��&���Q��t&��;��6�rC6*�1o��w˹R�#Z X�C��T ��XT[9X]�I�ŀ]�qM�{���N/�F�3)�3��V*4c�K4'˦1�6l�ܭ�	��u�����Z���͕�Ѯ�#Lhe-ʛ����̫�Yg^�������:ۊ�<yr+<�3�t�J�.��2W�&2��h"_rwΰ�I�j��,�I/�.�ӹ��;�F���/��U:A�P�q��ur~~Z���0|��T�+��	�����'���4vPx[]�!�~�xmҨ�ޘ�2	k��5�-�ُ�Z�1�v�R B/L7����W]��/�����̯�׉��)��7B��^��*=����BW'�ʷ\ U�se�3�� V����XIG.��`�=|�^U��w�8�7] �$�*�MEKtE�-"��[t]Ҏ�;]4��u��g`�	�O��obvTIΏ̫3�!?��U�h3��*���ǠTiObƗ����b�,�"��x��a�0T��PLdUڝ��`�Ո�q�|:��L3E�
��M�:��� �*�d�#Ho�Mn��f�wJ����tm}i��Ҍ�l�)�azɟ��E���%�imCѧ��.R��������5�{AH�}rY����Q�)���X������h�7y'�J��l�|�d����L&�Խ�.�c���.	U>�4Wڎ���� ��i�t�h��B�.�uA����p��T1��i փ���+<ZX���f���Ą�'��ڹ�����ʳ�t"@9��T������uwx|�@|;�|?~:��Ͻ��g�g��?ic��x>^ަ���]q�7���\ޠ�ipT_:o��C�(�Q����̊�@�rٮ�����tNXc*t��jI�aF)}��%;.���}D�MZ6�+QY��W:����O�E�5�>m���XbLQz����B��)+�P�I�������қ+Q�*���������(|��+�O)E�=U�X?� ��vV�h̶�4�2m��	� ��V{FTi��|9}$�D�p�\Ve��B/a��-߂^A�$TZ��E��J�'��Q����"�y��f4�6- (��i�LF%]��6��L�D:$c2Q���k����*���0�r��4KA|ђ���6(	+͓��
�se�������J@��N��1͏��*�se�� `Y���e�O}�g,�!��Ҩ�2T��4�4�P>��D�&������Db��|D%F����;k�L��26�hPi���J�l�i�Ӱ�3�hTi��lIG �5YD�z�!-l����A�9�Yo,�u���\���;��@m��̝�V�La/�iMFˊ�5M��.�&Q\�ϻ�QYG�hT�,-�8�FU&m����(}�4��NON�*YPiG0/C�YH㷥Ө��f�d�470�A�ɰ��hTiND�˝�e^5����e4�hX dh`i�C�K�T�%^�Rd�F�eh����|s��&��?��iڰ�kKk/�C02	D�	i�y�gZM�����a�ܒ���b]�|tr%R���MU�͓QgBò�f`�S�A%���,qUڅ%����q�tr�i)t�'Jr2:S��e��òv�iTi���e���g�@R���Z4A�JS��D7˜@�6�bu���(�PQ��7�Xޜ��6�����צ�[N�N�~������.aX�Y�P���&�D�8c������/��(�1���f�3g��M�Q�1�[�]�X`(c�tԍ��#�7|g�e��V@5�\$5�G�	���J��dH�De�p����wa�Ad��k"�
�"�RI�[F1� �yb�5�!�/k1}Ȍ���!3�(��퐖)*��$����ԑ��d�H`i�3^$�ĤL�78��L>g,�i(��IcWrE���l]�d��0t�Gb���d"�4�5B��F���22�)δ{T��6�� e�
! ,�4`�v<=]���ՎNL�a�m�G�7��'.�5�6�{k!0�\	���s����*��h�����U�e�s������6GLms��H��2�|�}n\�,��#C���F��M���?N�V٨`j����� ̄���p�jg_��/��h�&134߽E�J4B�y��m�#�Vs�=>�4h��w��͕�f��R���	hk@РKJ�M� _��0K����Ì�h�ݴ�;\�4�[6�^Ak5@
���8��u8��,��ϑ#�
o�̥�֊�Q�=QL˘6)��C�͙�g����e-�"��q���:��mc���7�Z�mi�vxk,����T5i^=����:}�D5��A��)� h��;�K����ixi��0��j������O/�������߻�y}���^�'����I�<-ڐ3�����4�)_!T�ے�+M���	,��R��74*�+��v�颹iڠ�q,��0�D��W�/�A���KWzL�����J�f���@�!j|��+�{�(h�'˖L�V�n�|�] Ҿ�0�.��;=c��:�M���R}hTiS��g��:.	`�==�um��P�Ѻv%��l�.��k�E5ӜVyFm�Wi"#��R��M���/R�xcr����6��^)�f�t�&Q��	UK���ʴ4�a���?�_*b�&Ti.�\Q��!�&���;�-ٴ�J�d���l%V��Y�N�w���U��l�d"��2��jɆ.U�He
����t�!�`�m�X�*W�H�j=��N!�!G��t�M�d��    �b�R�a��q!�5�8��������o���z��oߧ�q�,�����?��������������(���/U���	L\�e3���A2'?���Ǉ��H���/��^?�W�����.n_�C A�:���}�����d|��m�C �B.s�9���g픹n�g}�,�%��Y�z�}��h��������_���������/��l$/G���Λ���=�5������H����M\��C�qe?E�u����w�3��z�L���+�X�\����KwN��7qNj����I�Xz�N�o�d,�[˽g�^
c9M����{>�����O����Vi�.fC\�'i.+��aB��S^/O����y���s�\<���{���7qÖ���D�T�O�� q�>?��A�d�i�b*4����8�.�\H���z	ft&�)o���ELĕ���w��L������������8O�E��u�8�uvο\Ь��~�.�[����]�%(s^������﯇��ӗ����o^0?;o�i�����x����j��h,��7F��['�ǆ�oN\8ry�j�eCog���o+|�@\�	�aSO���)��Ꮈ�L�nc�O�
��}�k�<�aQ�S�xf[�R9��%�A��!��I�M����@U�9����r����'H�Qb^=/������|�(�I�}���X�����c�=�gt�D�E3�\��d~Owί�����W��������w��/�2�����9��g.�كUD@���J��q	�q���M���#ƕ}�j���`�?�-�)�x�zG�����5��Q|��G퍯�[FS�TE���%h��!�it���+�+�@�.cx�+�Eȸ��4\��)�J�JQt�˘Л�RnFMUZ����PT�X�n��j��gW1�:�����O�0O@�?�Q��4]�1���r��y~j8�3=g�#)�oJ��ۤ�Q*��75�S�]uU��v�|TS5^��j���ʆ�UL�ZD"ã��9ͩT˗w5��+1��v��rm�lơл�f(�ZA0�*T�\�b���NR�֞���H��3�Ҋ��z���_�O�`qSqEr����&#��>l�%6�֛��K�,�o�c�=�&9��B��i3Aj�iŤ�豧U�ץŞ61.�c�!}e�+��l�k��I]��ﾩPL��&&��V��a|>Mޠ���2��:C�d��_(��~5��*71�dZ�ƼT�{�۹�;)����g�����aXCnuL�XM]Yw�ohsgCTLz�b��12�"85cd(Fo�C-z������&���+�0���:���4�Թ5W��ˋ-�&������}y���N�q�u���_�̵]�U�_�"��[�U�c�	h���2�:�Ί͜����6��t1�4=2�3���Ę^Z,ek���"F)�B�Zk�͘#��Q�ce�Wq�U��!�`׌g�~�]�mc�5;�e�.�w����ީ�y�59�6�%��)C�yx���:C�_���M�3D�"{1��zU����Ҹ
��='k!<_O���zS]g��i�2̅���ݤZ����n���C�m�7��J�H6'p<�*�+V�(��F��e�?~�����O�w�G��zB�Yb|�	˘Y�3��H��b"5b��K�+���q��)F���ZD�u[=(�ژ�EjꃖɈ��6ژ�h��l���V�������cqx���dN,�_���Mt�ͼDD������*����)�[����M��m��~4}z7P3n��d�p���c�YK7&�Ǽ\�1�� �q�R+���f{�q[x8a�����ڠ�c�B��(Xf(��^C3�<��S'�}5=�!F����T2���!&�U3�>��(��[|�+h��#I\A=I{3E�J�z���bW�	�	�Ip��AZ����b˧�B9�Rշo:;��r��d�$�$e���#T:��������/����}����[��c��m�NiQ�R�_�I��9L�?�g��L$d�#,��9�Z���ԍ��&F5 ��A�b$_2�9�b˴Ѩ�9/����~?>?ߟ6�۷C��ܾ��c�JPm��w��U�'S�	�|�&Aq�������¬2}��e��"(��1��
�� ���ِ�|5���j
�J�������x�����}��@F؇���0�����h! ���I�A�Ɨ���[���3�En5�>(C>g\�,D�w�J&�\&���ض"$��έ!�SO����=s�)��s/���"<�)�ԊUs�į��k������[�C�M�N��t���y�n��,�z$�=��~YM+���(�J�HfHTLu4��@Lu4�k�g�4m��ĥ&�v�����?��8FU@�tF󡷋b:����IjV�`b]�q0�ː)J��SJ���[פ-��AeW�W1dU�W-dQ�����z��ڦ7�b)�N��^Ix2����j��i���2��I�hd�b�������;(�������o�Ƿ7�q�_��٩+M�=���(�O/����p����?��`����UD+���[!���������p�������ӴS�����mx|��>^���������d����i`�M��S2K��CPR�Sa�W�Y��ܤL0%|��!(�ծ�KqNb��*�	��uUNQT5UN\��XaƤ�|����[�CY���|L
� (��m�/���S$�W#��+r{3h?�1�NM�u��t_���e�/A�������l��N�l벚4*��( �#��a@/c�al*�g(c����7dÆ1������y��d���� C���;)����U�o�޴n�B�2+���l0���j1]��j��Q%�Ej��:W���u1��K�s{T*�.�i��q�Zᪧ���aO�V�A4�_��e4E]�W���>�:E1������t14�Z�������'�֔�EH�I�u5!<�o�����'��Lc���2=#�Q0�12��@�~����[�]�ً錠��o��k��b����*�e�������Tc����:k��3i�z|�����"���@�IZ��1�g�{GNp��h!8���7q�����aL����-��H��L����CMƭ��Q���-l�������u?����b�CB����"S�7��=�������ԩn�t~}�Rէ�?�������/:W%&c�����#�WL
6i��^W��L{v���5�pm���X �h�-�2���hM�[�r�����
�P.��)Q��kD�1]v�9jpø
{E�5�ٽ�:8)횪�!�����C޲�v8�^�Y0޸Y0�+ ��r[���������a��˘.�Bm�}�z~�(�}�K+yf&�t���d:��+���`ᆂ�B���[L+KiƘJ�,+Z�֭+��erx�Mȃ�w�V� ��i~C��o4	���G�oW������1F��q�$z=�oF���uP�[7�~F��\�.�:��g8ۣl�­��G�̣�����ҹ(����An�DEQ�ZWe�n-M�'��L�:����<c����k������<�E�Y'(Cw�,{9���^�Ƹ��#��)W:�ڭ`l<#��/����M��M>�c�������o����X�#��Ϗ/h��V�o��Ĩt��2�޳;��1qh��̮�L�讈	JKԋ&��z;��g��?ao�ܽ�ʂ)�&����a
�
E��
4��:�c޹2�21e�
T�0�d�zS3�j�H	�bl�Ѱ��
��e]͊DU2�e�]���e����B^=s��&�p;����а.�J�2���&j��y�xS5�ܔ1�D�F��w�4}�`�� �Y��3=K۹�M^��YVg�W�OB ��!���x��g��Yn �²�N����:����^�I�D��2�4� ��Hl�1������S��3�Fb�EA�b6�j�>�9�bed�hp�T�U�/�*ϐ�B�hZ�f�l�[    1l3�>�	�2�?�N�F2���Y�#�I��� ��o��4~(~�������VF�FWk;�''i�� ���|M&<�\J�_�IW0�[����xU߾��Ҡ4��� �mb}���I-��Rˌ�dǉ�}h2���M�3���24I4���C��[���O���7�h�Ǖ�1�-	�0}ҙWC&uA���9r�Z"�Btu/�X��-P�DS�Uń��X�V
=�VSDwq��t�>0>Go�;5�iuFy��wU�Ā$��7�Đ��>�:��>#FѤk�V^zѠډ�j�r꘤951)WJQS�DȲ�`<�7�邻��.^MtŴ��>I��nY����ʊ8��\X�^�F��7H�5n�ŋ׼'5�ʭ����3ofN��P�YL�nE��u�E
���_$�S�f�z{�N��8�z��G�k�5�buL�X	�ݼ�� ���ݾ���ۀ^qmZӾ"�b�\u	�&����Y7&U�>��f�Q~	�͸^��f��2NP�v$�*�a�"�>���T���P@����wHě���]��軀?�y3W�P�CN�t2�k��F�5��#:��ƺ��ʲ2Bd^���]F�e7����1X �A�+C*�x�ޖ�x�nEߚ7�aU�IH�f^o��'�/"�)�b԰1M���G�J��ʁD�M��P���ݳ6o��;�il`�VW&�D��R��]�=(��I/����eI{�L���<�s]E>���e�袎ɰV|*�q��SI++<+M��U�Jlb��k}��w����qrٞ'��� ����4Nĕ�i��7X�����Q�d=h��K^�S�m�#M}DE�gb����S��2u�\�c�v� ����Z8O��<Q0��_��i�zO�{�pF�R���u�L�<����R�)M�+gԥ~ۼI�Y2�lP#���^�eJ+z�m��HM*�2�J��6&r��l�1��a�.F��V��u_T���6��F=����\���������J��*�(�	��P����k}�.�ґ�/I��5ժ�
]ϝ�P�Qx%�ly��1���6]�ݥ���KQ^�Ř]j���%Eu}�~=7i`L������#��aF]�M�'�bd�J�[�T��Q4SB�s��GZC�ӑ/�S�TD���d��Q�б�����5)Du�Gs7�#�bF{�ϔ;M�x�hT��Fu'#B𮍌/?��i���,��1�ew�����>��jy��u��L���r�!�%��|��41ѻ�0�>��8��Z�3�M�4!@7�H��b�-��3����e?n�vM���Y�t���j`�e��r;��~��{ƲW2�K�g���t��M;�BTQM7h�����*���>&FM�|ҳ�__����i��OM�VYpn���1U\�p�Di��ed����l瑴w��H�!1Ѡ:�i�M֤A"�sqe�F+)CCPlch4*����p�1��PCs�%"$��y�0�>裩��j� �蹥�ez��~�	��悇ƥo��Rz���}��dC_ �7դ�dJ���]�\K��ۅO��>M1mL�ڞA`D<͋aE�LCL�7	�*Be��I�
BX�Ry��Y	=�J���]���@OL�\2�|�w �d ����tա��)��y���~��7H�V��2{�}c_)�33(��PM�_���FFcGK�m�L�����W(G
a1Α�s+Nьe�S42[IM/m��ҕʹ��h��U����ںjs�.ͦ�}0)FMBaN�f�ktKv��C�����R���m!�{��p�2����t��H��m~�׺��ʩ�"S�n�~��U����j�s��Z�*��J��RJc4���=0�3�"���{|f8�?U�+�)>�3��=�}��7J�FptXn�͑��)�i�乤�{y��oƳ�K�Lɶ�q񕦉Ȏ��2b G-�ISrL�,-�sq�%&�Aa�8zzվ`�#JnY�e{�پ`�piZ�1�b-�l��aՕ��h����
cEo��A�t=_�˧���_>��?u���
����q������tb^~}ڿ}L�J�h���*z��ǐ���ʍ�%gD�h`L�=E��%��(���I�=Xǿ�}�����@���%QU:M�=�o���2o��x�64��u�RJ}+)9�iȸq�*���֍��U�+���z�M�
�I�L�AZ����j����Urem���7�^�~Fc��.�2+��9w����W*On�:Fm�V��f�	��K��������t�f�B����ը��+�7�+��z|�究�A�FE�KBU1�M�v�f�N{S�L1��Ժˀ�jzG����*�
�(U�"DQ�T�D�%Z�Ѩc]�:�"�l�ԩ�U[/�qݶN+�48B`��Z�`�E�j7�YsN��àU�B륾��AVT��1YM�S�s���9u����i��EΛ�:-Ͷl�f��g��J��gc�l�r��)ڞ�&��S���A��_ڻo2��]�W��j��uU@U��mb��jm�(���	�P�e�xͨ�/%���
��4k�T1��]Xd��Z�UL6��E_�φ���Θ˒����ğJ�{� �~6��%}�C�^o����k��w71��^�E�����a�+r��b�&b8
;�3~����u�b��I+n1]
� ���i�p���I�=y�!����B���ƍ�YJ+t]*[FKׇf�H�ę�s�yI��6�,o����o��;�\-�-ݺR�V���j�V1�������t�?ޟ���鏞�����a�<߿Ǘ���^7��[���6�o��8�H�� �0�n[۟���6UP?����A���K�AwiqR�ւ�dU�h���o���K_�n�_/�t��ɽ.=��
��C�x�ꂐZ�S�~w|����i�/�6ܕ??f�ObIp�R���JM&�o��2��i(��_�z}�>
�&"�L��*q��eHeN9u�V�x����?%��Q��ai������L� �c����\6L��T�&�n�V�E�4�P�(615t�d�����u|X3.�-�hKe^/J���΀[/B�줇�,Mi][i�F>$�K	j]�B1��ƨ�Ԫ%�v��ߢ0�e��*��b��4����*I�[�$�$h+�=���Bڌ���Im:׎�ԯu1Tz�57��j��N�2�ԌuW��T7
���Ў\$
�Y�����>Aɕ5��"�'9=P6���஢��qS�t�]�d�B��2w�?!�F�d<��D O`z�F���tZ�| r�je\!׵�+���8�ZH�$�(R�]L�����Z��E�̪�.:dGS�m�ge�k��= �I�����ٻGW�z�~Kg�f�Ϩd
x��.���k�7�6S�gX���3��]�~�i�3�����w�fsr����}����.����G4��X£睽�+�֕Wd_���E5�eFU��E�|�Vݝ9���L����,��Ќ��1�
��mǨ���ig2�n����u��+�����6��nF�1��sswY�*�s�1�+���}(R�a�%Ƹl2*8�?M@e!a����Q̔*��X���B�(���1�Њ��!u��f��Ǆ��2��A��ڇtn��b3�q�R3�3J�1$'�҉���]���lON�����������������?)���.(�d0R"B4��2 �$݉�� Ӳ�4���$�D� ��X4��H�S8�i�S��2�D�!�h1@�Q����?	D���A!�oa��M�A�?� ��L���Y26�"�X�M��D�1F�=�\1~�L�̐q[7p�/;�"ey����A�1!����%�IQ�TL#x�S>䔒f�ĮvAB��*��&�G�@� ���(�錈B&8��f��Z.gcI���}���F�E¤ptӊ�xNH>"HM9wLa�_c�&j˷D�zIDH#�mi�L�U)�D�S��q�J����Y\�����$�/��
Z.\�,߹��E$,A�Φ�	g(�~��YfD����KNӣ��lѣc�5M�|4N��PD    ^���f\ TuCԈ��戂�h6Ð�Xls@��J�D����yz`�����3����-�G̣����v�x�R�Ѳ�)���5;G4�hA�:/����O��X�E`D=�x�����P:�$��[pt���t�w���I���yx�4, ������}�Ǵy8LXi7D�~,�ͼ��>5�\���ٿ\|�����՗�И��P��h��S0����p�z$ζD�'6��	UP�<��l�?UϠ�#�Cr�	}�w��(d�J����lGV��ZR�S���ŅO�����0�{��s�Øv��~����}H71�Q�����B?>LQUŔێ��y
&GW�ƒ���R�}�[ӹ��2���	�*�\�ݲ漡�c�*6$ڈ*F\k���4�z�}���W�[�1�Sv5���$��#����Q9������oP�3�~{D�,�c
e�E�k���(n�f��nq{w�.��0lS���~�JK�K��0~�f����i޺�ߒR|��+J���pj�8��rK��0��x��f�e��~3�������������9���M��I��J����h�ƍ	 *�W��ƲA7�b�",HZ^E��3ƅ�*��R�V14��8t����V������կ��l��)Vݾ��c܈��(�<,�rv��7qv2vg�HQ0���5#!y!�_��`���όg�ae�se-��k�cW���,�]��o*�-z:���VSQ[��k�s�-�*7h��-U��.��E�jmY�t}{U��­u�Wx}��v.ܡ���7�}S��='�{vt��&��hZ/����t,����5���b ���D�J��&�p�q�b�����7A\�hE�XW�B�}��9���W�zSM�ţg71���JMLPD-lԺ֐�ڰ-��Cj�1���~!/��Ƙ�\�l���vƸfg�-�����>�����O��A�mc3e�]�/Ǯ)Vh7Yҫe4lzq�v�u�����)�m�ݩGO094�\Ek�x �[~ya���-���Y7���v腣7�C�Eoܞ����(�X��q3�M����(srV���dH3ENh��'��{����Zm�w�m�-t��� �y7M��qw<���]����ɫ��z�m�����z�x���n>IOg]��s� �G��1����T­g-�7練���/�k9��_�W8a"{�M�۪�Z�+���hԄ�n�.�t�.&�_�w�'�k:"mL`BM�����v�^���-ޭ��bd�z�VB�-�f�G���)�.��R�@��V����o.��h�������.F�F�Ψ�j�l+ֻ�w��H}L�YS/1K8l,e�o���b(��	��BgT�x]�ʷ���[�U�i��lo�D|Lkq͔�>���^��+~	= ��a�3��s*W��&s*gT	�˾x�rKD+���gL�.5xF�p� ��穫�Xv��Q�9�3����.��3*%������j(�)�@�z���P�G4��)�Y'��t*���'Rם^,?����N��f�	�(��&��l��~���`���O�^��}��Z��B@��c|��
��M����ӓ�"ȍ�0��8��R�t�RS���й�+�WET}Z{[�/\<Gf+��M����[JWx,TX����ְJSۺܴ���o��7����!8[�7�n^�BEp�.�̢���7�;g�R����eʛj�^n���C���@'4��L�O'�'�s)N1���[H��}���2ݽ�����)�i���Ihp<Pl��Ѩ�ٚB��^`��b
�Kt��a�}"hX� tw�h]p�sE�� ����ro�,�CM��tGU&WMh�H,=�_\�AGp�J0¢Ly���M�#��C�!(�ɠ���R�  ����H4U  ��!<[ȇ ��X8ľ���F��O����7�
�!�z�2�}�+D�)�!y��ɜ�$o��&C}D»Tw�D>���:���kj�������#J�Aقv&�يwBCѢ���M=��R�K��WJ�@���L�ڎTv��z ���=� JFH?K�q����N��-�@��[qK���m��G�G-Q�*U4}�[��㻰*���Mb+'W�m�`�F.�-�؉������U#'r�X�m8�#��+�0�ے��p�v�ۄ��x����>?�|�?<}���β?�j��Q嚴f�I�]2L�4��31l)aII�g�SH˞�72�u�� 
K]8-���d0�8Lmq=�e{2��h@}:o�^Z�:�4B�s������M��hP�/#�BP��e&�S5*`۩F�L�qt؆�Ί�sU��0.ϙ�.��:Bc�4CFt�B�.$7Oï���U9�.MC���[�����z��^�Ŭױ�<1lϳ�d��7qzb/5��X՞��w�rz��7qzbBrjvW����e{��ce�2���8��t7�U��h�U�"�'�y�8�%�ø��hB��H�u��"��7s�e�Hv\~+��B"Idwo(^�e��@��'�jVS��l����%��!f(�jU@�0�*3��Հ&h��8Ca"��5]c�N�2�ޭ�a����2�F�
8�&�o=h��*�U�iƳ��Ocɋ%03��UV+ǻPv���S�;����%��aX!Χ�g[X)�aD/zOW�6�T�s���td�Բ��<�IB�p:^����ݯ��N�
�4��z��w���w����g���ڕ�C�0��FVw;O�2���h���o�&��I6��_��gY]��}Ӡ1����6�/G�6t.|h>GՌ�����V���:�uL}.!Ǜ4�g��vl�6�G�Ba���A*l,�J8B�]����)�*�#�b<����2��|2���2k��X1�DqwĴi�W�w>��zMqU=���V7���_����a#�P6~y������B����f����/���d����:z��5�Lf>']].@,��VѸZ��NSӦYw�K���
0����]=<].��]�KJZ�9=t�	���L�r�n�(vǇ���i�?ޟ�<��?z����׏��󼇏/�U�x=K�_������1�/� :�ڤ�����ǂ�	&�O�§���e2.7ML8��g�� �P:�о "�̜���)bl(VE�{��VK�kQ�����a���:&�\-9�q�p�t�&"ޭ�n����&&ޭ�8o� �&���P������+��M�Κ�bݪ���=~߅��.�� �������[���X�X����hU4�ژ�X! cv�1��6&WK��ꀊ$"�8FCEz���޶�R�y�T�N62zrMIw�QQ�q���bz��&��Ӓ���b�:B��+�y�]�ֺ�:D�%��v��</ǶD�mLi$F���ǚQQ�� ��NV��kj����θN%�N�b���7�y����ǺX_o�e{r�UB�m��e��2R��5_V��w⻘.�v�,aQ�^I�W����.zZU�o�#S���[(�<�0ٙ�6c�S��2��&˼��417�'��P���m0�1�Jp<!��w&#>�d c�}Hv	L9�N�,��PZ�/x�?����NmHf���R�Sz*\�^OtT��5��8��W�д��x&f��N��vapY�2F}w�:L�n�ĝ�Je~������p�He2��ypr7��K�0H����M�����k��*�5�9h�fI�xUq��~�K� &�c���W��I�K���W�I���2���Tz�?�2�9�J��b	���#>ޥj*��Ehzh8f�+I8c@���j�=��iv��t�?<̤����C��8\��嗶�}O����K���q�zx�x;�������7%�e�����Ε�j�A'�2�HB��}z��]�%���ϗ��������0m��b����w����/Q���� �v�X�|]Ɩ1��]�?�/goS�NŪj�8k:z#�� ^x 	�z��+6�^q���/�ݗCB�Ė��`~1����}�b[+���E
���ٕJѠ�0���8�qe�!88)�oo�Z���7ߞsكS����    d���bc��Ko� U�AL�aq+	�r�r�Js����7��O7޾�x��+ľ�K1r^ �t��7}�@y/�ڡ��\-�[D�(����1M���zjl:��X�ƎzWim�G���ئB�ztz�F��2Ku�@�48bh#�vai#�^.�}��
��r��U�W�VMT>TܞL=Q�G��)M�d���W_I����0���m�6���^���������s���VȠI]0��n��
� ,*����#V����2�|��1�5��Tke?sNL�9D��Y�@n�����t�Š����t�I�K���{�0�Y����yܳ��P�YY�ܘ*�ģ���9�M:ܾ�8�r����)�i�ib
��������
u+��PT4�^�h��b�
��7���js�%�o!���ws���zt*�ѩnG�Nu�w�y�HH\��6�j�=�޿���>��W��o����C�u)3��������X�1��ч�	{z�e�����z�H4nސ�2��m�!��Û���Px�I�=����a�h8~�TL�>�l������8D���-�k�$ߏ~`
NW�5�kt542���'5Om?*���M��'�)�Y5R����}{C�+���V�z��/��������=*V3����oԴ�GN��_��9�_n�x���:��+��B���eCo�h�L��J����s�s��w��|jw��mt�2�Ƒ'L��� K��o
F����4$�{b���$�n��p����dMᨰ4��1 �HѯkJWK���7�)k8�W��F��wgYs�U�]�߾�h����~ӛҕn*^���T$cH�$�����pt������]��)^=J�)����ۜ2�)~A�䘮`�M��H�Δ�Ҝ��DxOo6[V�ai*�*q4�8�$A�/��������o��
e1c+$_�J�Z��L4 ���u�+ڙ�X�Hu�&��N)�E�0�`�h̬��ڕZ�9��L&��EC�IZ���_�j(w��2el�P�^al{�;4Q7*��o1Jih,�����,�(�6������P�ڣ2aLSY|��ŉ��^(\�X��a�]���K��x����E�h8|� ��F����Wz����y1�pH(]@�r�ej
](NМ��OH��s��U�(I�gC�>����^�Y<B���5�U��	�*��Ƥ�}ř0J��t>P��[ffd"~4�JK4��4��m��	�Y�}�7��zT�����������0+�+�����'�9:��8|/��8��d���!9�OCp�CM��F��2ݥ1)���0��'�3Q[�PL4�4�Q��������̨���B��#��Q���$SM�gS'��S"�Q���qC�_��%��AM˕��Q$v��(s���dI1���Io�z��.Ēמ{Z��-=���AX2�bSᰁ�D�ˉm�=�K4�ݵ#\��D"(E�MSOYї8�;�%Q�rqÐtڼ �n�����͋)��޾��5&���Wԥ�Z�������p�����c12M+����{PBv)�B2�D�ɰ�wW,�y8������L�:@a��2t�bX3l����Lw{0C�4Z�xh��Dć�$7(�Θ�L���%z<���`���4�]�0]���0 f���7KY�}�G/x =��-���	��h�ΥI�^��I.�����M�sKFĨh�q)º�����@�L��L�@�(��Q�'���D��#���<���+'���4ݘ��PP|�+�yPc�Z�I��MQkUZ�[�g ���	(X�F��e�d��QQf~�-�.����\~��kP��A�5.�:e'���sZ���E������ܥ��e�hVU�u7�run$�{��������e�����y���H������?��/�k�r�E������2��'ʭ��4�X���q���>?�_�6�$��kЬG��Asru�~ ������&��R;��+-��(�@R%�N;a!�lٵ�����9chҧd�����v�������*W���v����~Cr�M�]������BW� �^A��)\xI�I�wJ9�U���,�g'$��Ԗ����������������e����e��:'�}>L�������������?����x�e�ݎ vJ��v]�3�:;�Y�l�
-��L@u�Ϩ\����`]8�3�1�dM��.!��!m��QM��d)?z��:i���^�Ǘ��������� ��.z�A�rO�����$`����/��:�N��KgTNܵ�N�T�Ol���UeդM��̼�4��U��p�Ψ���j��U��ˡIz3���M{�eo�9Cy����J������e�cNR�흽!���'�6
7�Єm����&&��2ɜ�2������� ���2߹�Q��y�}�¥���.i�.^T5�'R/��(@oVe��i�` '	UF��D՚�2�
�yU��4���Kn�4GK�m�.�mդy�mNV"���@�Q%���KؗA��t�mP�=1�&�e���.��T9WC�A%|Cis%}IK�R���|/���普M��MB%<U��=E�׊4�X�vE�×�����͗�E�iޖ��2&��\�2�GӮ,ana4]At;�y���
�Yis�-�F*Kko�Fe��!QM�v�v�ϟ~v �
6W��Қ�.J���ປB�BX�������K��g���T�qQ k��43����0��]�#�����(��oy^*�W�&AdXA�@���G7_��6�x�|�P��J[�|B�,���,��~����c>K���%
��I��xUe�J�(�il�+K��J�jd�Wr�I]a,2+���0���MT��+-������͝Mn�P���)r��,��
4@�E��z�sTZ�p�p�y�y[o<x�?Cr�Q�[�5���$���L_�+��K��,��GW�Y^"+����*����5��C'��򱇺d����~��D}��O��_�7��kӮ���p�k�&��V[)g�Y@���YK���S~�c]{��y:�&ɯ����]d�>2L��^���I�I�Ss���ּD�޻�uE���sB����sJ���ШX0�`��,hw>u��9t��K��6�n;:1T�>-���>·�����������y3E߾n���Mp����㼫��hp��4 9��c�}ǥs���'|k���Dئ�D-���������f�ɴ|1��82�_s�<*����0��M	t�Sp�7��Q�г�\��Gw^
�A��Οt�Z[:~�c������/�z�2�
�)���̸@�n����F��2�+�)רXY�"T�֜���s4�,ĝ����ek[���Y��{V��]`��bD�/wШNa6�0������+ww�����sȾ��x�f�4�X)����~�����$�}�Q�i���]E|����`Ш ���Tؼ�stO/�`*�;�����a�����b�(6\ᕄ����fy��|m�զ�$�Z^aZ�H�Q��
՚n�l���xWkV=�D5�%]�>n�uX��������Ok���
�W�\�h�1m6���]�nۿ#0�ˤҳ��X���ni�~@m���f]�4l��i55,��ZU�+ㄜ�����/Q��el����(���}�:�˲��h]V�,��y���=���l�D5�E�$(V7r�}V�&���̕F�:�u��[ss:��e�Ut&�B�C��*NKT��]�� �cX�k�<��v�������y���)�-!뷡Jǣl�0�~V:+��`!����*	c�Q1�j4��ƮF�`�|t�hyT�U�
����X?�j �H����5Z3ljh��3�z����ހf��u9�j��C���if:_N�]Ê�MW���g�QE�D������
+xHPP˹�UAU
�{���K�m��/ ���҂/�Ҩe�|�pD�sg�"��]�J��U��+A���������%�ר�1��^�|:�ɳi�[ l�]�Z	b�X,�E��t�[d_�-L.Q�HӖL��k��,J��� d   U^YR?n�Y�_�*��T�b1q�9_�@L�!X�L��L+P���ՠ>f���-�*P�	�U�
W�bi��뷀�x�^7���QW¥AA��n��.�ߟ���      �   ~  x�m�Mn�0F��Sp�T���T(�$�
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
8���*����{��9����������a^���\Y���x���ӻ��󢼯��m��yQy��f���>/���a����h~���o�Y�������0K}^t�����0K\�|�2�_{��0K�~�}F�s��0K�{�q�fiC�� �l{h�0K���I����cU����˼�^���_�fi�9G\;6wy�0K��9�Y�xT� �?��!N      �      x������ � �      �      x������ � �      �      x�ŝ˒�6r�ק��_��+ ����6ZL�g3��O�y�0��_��ݬ&�
-�::��E�g"oH����/�ŉ�G���钖K����?�����L�����d�R��<�����߿��?�x�_��������t����ƿ��w̗�����ɧ/L����r�_4��~��?��������qp�/'���r
8�/��S�r(-��/� ��q�=h��)��� H:� �� ~�*�UxY�=��
�@{t�����+ (�Q�@e�=��
��e`����;����ӧ (sg���3���e`��2���C�=A8wA��	��� ,Xi�~L/��[��;���A�OAXG"�AXG��AXGb�AXG�AXG�;����t�+�/H�`5�a��o�ޓJ��>0T?��-_ް����Qb/_3_6$z�:X��������+m������eF�5���C�h
F��ˬ��-�����O���ͱ�����p�O���L���[��N6�2>ԗ��n~�St�|dX|.� �4n� /A�E�d#�ͧOA0,T:�`X���C�s�°P��a���B�@�N2h&��>-}����=ad˷̗����7��ard=���OSIk�;RܑR�k� �?�A�L:� A��A� �� H�yg$�rg$�Jg��Y�/�Z�{��%	Z�w����B��ryg�ؠ�[Q��!�zg�c1�\&�|qe벳��2]?'��rI��v+���g�[J�6ܰ<������<�����Ν���?�[ԏ�_���Y�2�+7��?F�|��O��7;���5_��#Cm8�~�l�e�;<�	�N�;�~<��]ױ����Q�
���QK�|�g� 8�R�ƥ�p���!VEm�*G�
�C�XO�C��8W
�ƾ��P�6�µ1� �e�u�/��mz�'�tz�!q��ǌ8]�=��,O�D{�Y8���p4b#m�H��6�$�����; �������N�f8\r�l��n7��>h�kٸK�����k��j)�h���S���6�)�@s8:-�����!)բ�p#���h�Y��^`��l�"^��Ho�~hX�7�4,қm_ �&�=c���Q��O�r�	c���E�asG�,l24��0����(4ԬI�BC͚�4�ޅh������O��{Hr<��p��� ��Ƶ��ƹG��ƽG��88"����Z6�X��>]�#�w���0��K�v
6��������{|�UPki�$[�%�����A�-Cݲ�p.W8�n��;�͝�u�_.;�5'|�_d�}&<����v��gw>�X_!�>�)��;���}f.8�>s��{˵�D�n��{!v}MyN�a�9��+r��^V�|���Cli5G@�����ĊV�悐!?E0�b�������!�p �K��K��K��� y�46uPnaA�y��-�ʖn�]A�y�x6�9�ĳ��^4����6^�F"{�}�b#���F����Fk��ȀoõA�
]�)�]k�A)��V9�]�φ��1�(6t�Z<�V=�]ۆmc�еZ��еZ�ل�N��}8/�VIs�.|u�].��� vZ�ф�M�S?H��XC����p�73=l���̾88��i����	��z�IN�+�z� ���|� ^��xhh>�34�-{g��8J�9�[Ji�.b��un!9�*ERᐬI���J$n˫�ҟꂜ+߮(]W���0�*���L�ǅ�X��|a7��w�!��_�O�������q ���	�V��p$1m_�y�w�md$1�	pX$'�aI�� �%Avk��8��'�a�P9��Gvs:�k
���=@.���P�&�>�k����P�&�>�k2���P�&�>�k����P�6�>�k3���z�mN}"#�v)(+���EN�CdDO�Cd�N�Cd�O�Cd$� ��H9��G�f�t"�[�I+�[Ԙ�)�UN�CdTO�Cd�N�Cd�O�Cd4� ��h�����-� �v�6)�\�p���h���'�!2&'�!2�'�!2f'�!2�'�!2�O�Cd�� �%c5�&%)(Y"m�h:E�3�m.��m$����~ׂ����H*�F:P�C�ƺnS���X����hGcq���a�zz�Y#x��U������2��Q�S��6�ބ��t������}Y�Ǉ��t%Z�P���D��tk����,_8_vB/"k��;AhZ�����3��.@{8���тDOk�n�5���4E��ȇ���G^O���ix��s
G�g
GCÙ���p�p44��2����������hh8�h4�_�K8j����oi����fa��� ��n� �ׂ�
GCH���R�p4�T4!GCH���R��h$٘�p4$E��t�����j�c�P3�S�}j�{j��AC�ڃZ��P3�S�}y-�{
��Acq�G�֏��ML_|��hH��p4�u{2k��8�um�ƺnO?Bc]������`��������!"Ј���F���`�4"7CD���9"�����hD�j�F��������H_{���EǠ�����(��5q8�k�p4�פ�h������*����U��FJ��VM��f�����Bܵ�h4қ�J8��=�z�g7W<���)wGC�]���p�p44�-IqGCR<G���f^�ѰH}ϩ�Ǡ�fyϩ�Ǡ�fyϩ�Ǡ�fyϱtǠ1��s{A#���s{�Ac��������cИ�%��1���1����.����h8��b�h������f%G���ޚ�ה��mY.;�!)5��!)�S:
I����T	GCRچ�AhHJ�p4$�z8�Rs4Ni�%5�5���Ћ�yJ�h���
4��h	G;���@[8� ���
tF+�><�p4�U��Ow<5�������f��h�I8jF���ў�KA�5�p4���hZ�{��Nh��m��4�5S8�9�u��ƺn�~��]E,o=H�Z�>|�Ҡ_��U��:[�l_����b�{L��0�̾k|ԯ1�F��E9\��l� V+{8?8�h4*ݜK8�ٶ�NWt�����˅��x����	G�#����F��K	G�t����E��c�X׺�u�1h�k�s4�1h�k�s0�1h�k�s,�1h�k�p4L�s$�1h�
��@�c�P3�s�!h^ySxES�傞/;�!)��ѐ�p4$�8I1	GCR�«(4$�,I1GCR,G�ѹ�m#)�����)Iq
GCR��ѐ�p4$�5IqGCR��ѐ��h���p4��W,SÖ́sG��Nh�YN�h�Y�p4�,s8j�%5����e�F#��s	Gc]�f]�rt�.���X�%����
G���K	G��ۃ<��ԩ,E�k���x֕���*�hi�h4�׽���Q�s����kqO�:n������M��+��ƃ~�<u^�;��4�G�}|��`�����Ng[��,��0(��k�S��ֻ��4��So�qz�5���5���@����_c�<<���_�ƹU,��ܰ��9l7��$&�x����"���k�����Q��ah�o�*m�0b�x(��Z�PcETFR+�l�BI���cy��L���O�pj���;�fg��w��GD�E��:��U��-�ޓ$�o��N�O�ΐ8Z������ڶgB/�V��6�)�@s8:-�����+��F�lmb�Qhh�n��^���ö0Ǡ�fZ��P��fjf)5k�a��f��h��I8jf����E�э��=��zH�����\
BCR��l�Ҷ{
BCR�vOAhHJ��)Ii�=�!)m�� 4$�m��FRhm�=��f�U���{�fH
�^��P3��h�YN�h�Y�p4�,s8j�%5����e�F#�P����fy�f�W����cА�\�ѐ���ѐ�B�hHJ�p4$�H0��Ҽ�|�@��o�yB����A��ֺ�b��"��OH7J�QFm-ZZ�}�a �
  �P{����l����p���hsRj@iE���4Y�[��Nh������u��F���nzg�:*���ʛ�?LN��W�s0z:�wA�h4�gj.�_aM��|�Q)�w�]��ݦ�r�$�ɞ��a��?,��jzS4e�I�3���>_B��6)�F�l��v��C~�(�JT�h#纴X��r��cø���xY������?��晤�4�e��7_����Sy~��YI��n�A�7_dF�1$6���HF���}yˌ�+uC I@��n��*�n��vC �b�)S�MW�k�`�T���pGĶ��j��4�ė@툨���K��!�0 ��n��vC �Kϼb�3"�u� �r�#V��n��`V��NEsZ�5x� �OjC����rI�_~�; ud�D޲;�"PH��Hd�PJF�Z�҃ơ����M�.p���� i����7�Lֺ9���岏KS�6ݧcЊ���6���87�K���2t9���m�AD�4X����~�g�Q�Q���n:΀o,� Ƕ .'�p=�׉�	p�N�O�c�I��#N�N�#�����/���X�mv�\�8ֹ�	p��6�?�uކj��Z�y�a�x9�ks���0����C���C�(�ݢ�NP8�";A��1���C�(�]��NP8�";A��9���C�(��7�O?�g9� �¹� �¹� �ȸ� ��x>��r"�5�FV��	p�L�??��(8D&�95�(8D&�97�(8D&�	p�L�����,������覣��\���Z�m�"3_6�N>�2Ju�/�\ϩ��N,��:8J6oO���?SC���~ /����g��ƪ����6��;ɠ�p/���ڛ�����\��M����I�q�p�f?j5�-��`{<;���������Ά��r�g#�"�s�������F*E[ņ�d�gC[�ǳ�-9ǳ�-����\�g� ���Ub�w`��a��ig^w��妾�go����h+9!�D�綴H��].��I�h�LO������k��\�H{�%�ZA�qT^��@*�J�T��Q�1վGP%���j$�@�H�����V��J�-�Ne��<����[�j��VPk ��M�"��&�H*��8�
m"��B�H#��&�H*��<�
m��6qj/���*M�_E~��_7&��D%�}��E}s��B��b�P)�X.t�%��`��B5؟s�2M��SM���{�2U���f�z(�.T&'��ɷ|�PFsRߴ�Ƞn����τ� ��j���f�v����̂��-8O��i$��/�= +�����Z7�FZ�t?��О����@p����US�n��e��+Eޞ1�����g�y���\�!��iCz#P^XR'aP��'�DEq�5=Ĉ>�Zo��՛w��'���P�8�� Gg��×ǋ�j:��^�'�G�v�\Q�p�"���T�T�<�6-�tt�j�lS�l��l���:��MՑt�P�@��nt�P�@�����h�g�uB��Y$j�!��xF���xvI��x�I��蔒,���I�v�f�m��&���u*��L�X���!��tC`�e������u��B1�ڝ���įv�w03������j�nǺ���>���̫������:��������_�P�]�J ���R?��֓ʑT��T���3�j$�"�"���G�Y�T6i�[�B�`�ɜ�)���m�����A�E);b��7��@��3���>�����|Lp~���ՁT�IԐ&���h��>U<�#���&Ľ�_+O3=w��Z_D� Gd�Ep�:�z���<u�~�q��Z����M�6��5AR�$/���l��E揿�x�i�G}����}J�4�H5�[-ER1Ӎ"�x�GR�F7����jIŻ�<�
���9u�N�Ai�'*�%��+-Mn�+۴	�t�������L�5����nre%��O�T�S$��I�p�DR��\#��+�H*��=r��Eo�9�I��I��xV}�������\��ϥ,֦,��y�ҌȧD([���n��c����Ն�v���՚��\�_�o�_C�s���2>7��������f�B۽�11?��13Vb�}�����_1�*��y��9_6���G���9to4p-�0��m�Η�W~:nuzG��O��OIo��^z��P���A����O&��aH
BC�s��=�Y鸪��y��f���kp�^iN�|e)>HC�<K%ˎa�!=�އ2�LÀə��ø4�ю�5���4ؠ��?��[Ǔ���0d��H٦�>��s	��!c�4E�����T6y�ד.��']�Y�J�@�L������ ]�n�*wC @W�����y�uC�����o������~[9|0�e[&|0{��&�`�m��X�m�ﱈ�;<m=�iA0iQۚt����×�&@*��Bߠ=M�9��q�o2��M:���j��kz\�YJ��4�nhI'Z����D*��{h����C���C8E�M{��A��6Ǳ���$�&�וK�2��N�X0�P.Ck��2��"~���)��~[4��ۨ�iQ4���],��a^����xEh�L�!�|G�����M g� �|S�{��cހ�L��[ð�E��{�xe�&��Uײ��cZO�c��"��3��\x�����0�X�4���F��}a��(x/��0�ԙf4O҃��K�p��?{{{�՘�X     