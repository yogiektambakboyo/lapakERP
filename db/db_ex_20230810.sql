PGDMP         6        
        {            ex_template %   12.15 (Ubuntu 12.15-0ubuntu0.20.04.1)    15.0 a   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false            �           0    0    DATABASE ex_template    ACL     9   GRANT ALL ON DATABASE ex_template TO postgresql_u300188;
                   postgres    false    4082            	            2615    34376    pgagent    SCHEMA        CREATE SCHEMA pgagent;
    DROP SCHEMA pgagent;
                postgres    false            �           0    0    SCHEMA pgagent    COMMENT     6   COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';
                   postgres    false    9                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    7                        3079    34377    pgagent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;
    DROP EXTENSION pgagent;
                   false    9            �           0    0    EXTENSION pgagent    COMMENT     >   COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';
                        false    2            l           1255    34652    calc_commision_cashier() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier()
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
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null or id.referral_by not in (select id from users where job_id = 1))
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
		        where pc.created_by_fee > 0 and im.dated between begin_date and end_date
		        union 
		        select  id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.assigned_to is not null and id.referral_by in (select id from users where job_id = 1))
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
		        join invoice_detail id on id.invoice_no = im.invoice_no and id.assigned_to is null
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
		        where pc.referral_fee > 0 and im.dated  between begin_date and end_date
		) a order by dated;
	END;
$$;
 0   DROP PROCEDURE public.calc_commision_cashier();
       public          postgres    false    7            �           0    0 "   PROCEDURE calc_commision_cashier()    ACL     N   GRANT ALL ON PROCEDURE public.calc_commision_cashier() TO postgresql_u300188;
          public          postgres    false    364            i           1255    34766    calc_commision_cashier_26() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_26()
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
			        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null or id.referral_by not in (select id from users where job_id = 1))
			        join product_sku ps on ps.id = id.product_id 
			        join customers c on c.id = im.customers_id 
			        join branch b on b.id = c.branch_id
			        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
			        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
			        where pc.created_by_fee > 0 and im.dated between begin_date and end_date
			        union 
			        select  id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions,b.id  as branch_id  
			        from invoice_master im 
			        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.assigned_to is not null and id.referral_by in (select id from users where job_id = 1))
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
		        join invoice_detail id on id.invoice_no = im.invoice_no and id.assigned_to is null
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
		        where pc.referral_fee > 0 and im.dated  between begin_date and end_date
			) a order by dated;
		end if;
	
		
	END;
$$;
 3   DROP PROCEDURE public.calc_commision_cashier_26();
       public          postgres    false    7            �           0    0 %   PROCEDURE calc_commision_cashier_26()    ACL     Q   GRANT ALL ON PROCEDURE public.calc_commision_cashier_26() TO postgresql_u300188;
          public          postgres    false    361            p           1255    34653    calc_commision_cashier_today() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_today()
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
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null or id.referral_by not in (select id from users where job_id = 1))
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
		        where pc.created_by_fee > 0 and im.dated between begin_date and end_date
		        union 
		        select  id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.assigned_to is not null and id.referral_by in (select id from users where job_id = 1))
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
		        join invoice_detail id on id.invoice_no = im.invoice_no and id.assigned_to is null
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
		        where pc.referral_fee > 0 and im.dated  between begin_date and end_date
		) a order by dated;
	END;
$$;
 6   DROP PROCEDURE public.calc_commision_cashier_today();
       public          postgres    false    7            �           0    0 (   PROCEDURE calc_commision_cashier_today()    ACL     T   GRANT ALL ON PROCEDURE public.calc_commision_cashier_today() TO postgresql_u300188;
          public          postgres    false    368            m           1255    34586    calc_commision_terapist() 	   PROCEDURE       CREATE PROCEDURE public.calc_commision_terapist()
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
       public          postgres    false    7            �           0    0 #   PROCEDURE calc_commision_terapist()    ACL     O   GRANT ALL ON PROCEDURE public.calc_commision_terapist() TO postgresql_u300188;
          public          postgres    false    365            n           1255    34764    calc_commision_terapist_26() 	   PROCEDURE     Y  CREATE PROCEDURE public.calc_commision_terapist_26()
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
       public          postgres    false    7            �           0    0 &   PROCEDURE calc_commision_terapist_26()    ACL     R   GRANT ALL ON PROCEDURE public.calc_commision_terapist_26() TO postgresql_u300188;
          public          postgres    false    366            o           1255    34591    calc_commision_terapist_today() 	   PROCEDURE     .  CREATE PROCEDURE public.calc_commision_terapist_today()
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
       public          postgres    false    7            �           0    0 )   PROCEDURE calc_commision_terapist_today()    ACL     U   GRANT ALL ON PROCEDURE public.calc_commision_terapist_today() TO postgresql_u300188;
          public          postgres    false    367            j           1255    35042    calc_stock_daily() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_stock_daily()
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
       public          postgres    false    7            �           0    0    PROCEDURE calc_stock_daily()    ACL     H   GRANT ALL ON PROCEDURE public.calc_stock_daily() TO postgresql_u300188;
          public          postgres    false    362            k           1255    35044    calc_stock_daily_today() 	   PROCEDURE     
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
       public          postgres    false    7            �           0    0 "   PROCEDURE calc_stock_daily_today()    ACL     N   GRANT ALL ON PROCEDURE public.calc_stock_daily_today() TO postgresql_u300188;
          public          postgres    false    363            �            1259    17914    branch    TABLE     i  CREATE TABLE public.branch (
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
       public         heap    postgres    false    7            �           0    0    TABLE branch    ACL     8   GRANT ALL ON TABLE public.branch TO postgresql_u300188;
          public          postgres    false    206            �            1259    17922    branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.branch_id_seq;
       public          postgres    false    7    206                        0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
          public          postgres    false    207                       0    0    SEQUENCE branch_id_seq    ACL     B   GRANT ALL ON SEQUENCE public.branch_id_seq TO postgresql_u300188;
          public          postgres    false    207            �            1259    17924    branch_room    TABLE     �   CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.branch_room;
       public         heap    postgres    false    7                       0    0    TABLE branch_room    ACL     =   GRANT ALL ON TABLE public.branch_room TO postgresql_u300188;
          public          postgres    false    208            �            1259    17931    branch_room_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.branch_room_id_seq;
       public          postgres    false    208    7                       0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
          public          postgres    false    209                       0    0    SEQUENCE branch_room_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.branch_room_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7                       0    0    TABLE branch_shift    ACL     >   GRANT ALL ON TABLE public.branch_shift TO postgresql_u300188;
          public          postgres    false    297            (           1259    18718    branch_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.branch_shift_id_seq;
       public          postgres    false    7    297                       0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
          public          postgres    false    296                       0    0    SEQUENCE branch_shift_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.branch_shift_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7                       0    0    TABLE calendar    ACL     :   GRANT ALL ON TABLE public.calendar TO postgresql_u300188;
          public          postgres    false    309            4           1259    26917    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public          postgres    false    7    309            	           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    308            
           0    0    SEQUENCE calendar_id_seq    ACL     D   GRANT ALL ON SEQUENCE public.calendar_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7                       0    0    TABLE cashier_commision    ACL     C   GRANT ALL ON TABLE public.cashier_commision TO postgresql_u300188;
          public          postgres    false    339            �            1259    17933    company    TABLE     r  CREATE TABLE public.company (
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
       public         heap    postgres    false    7                       0    0    TABLE company    ACL     9   GRANT ALL ON TABLE public.company TO postgresql_u300188;
          public          postgres    false    210            �            1259    17940    company_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.company_id_seq;
       public          postgres    false    7    210                       0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    211                       0    0    SEQUENCE company_id_seq    ACL     C   GRANT ALL ON SEQUENCE public.company_id_seq TO postgresql_u300188;
          public          postgres    false    211            �            1259    17942 	   customers    TABLE     ?  CREATE TABLE public.customers (
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
    segment_id integer DEFAULT 1 NOT NULL,
    gender character varying
);
    DROP TABLE public.customers;
       public         heap    postgres    false    7                       0    0    TABLE customers    ACL     ;   GRANT ALL ON TABLE public.customers TO postgresql_u300188;
          public          postgres    false    212            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    7    212                       0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
          public          postgres    false    213                       0    0    SEQUENCE customers_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.customers_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7                       0    0    TABLE customers_registration    ACL     H   GRANT ALL ON TABLE public.customers_registration TO postgresql_u300188;
          public          postgres    false    307            2           1259    18772    customers_registration_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.customers_registration_id_seq;
       public          postgres    false    307    7                       0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    306                       0    0 &   SEQUENCE customers_registration_id_seq    ACL     R   GRANT ALL ON SEQUENCE public.customers_registration_id_seq TO postgresql_u300188;
          public          postgres    false    306            9           1259    28173    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    7                       0    0    TABLE customers_segment    ACL     C   GRANT ALL ON TABLE public.customers_segment TO postgresql_u300188;
          public          postgres    false    313            8           1259    28171    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    7    313                       0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
          public          postgres    false    312                       0    0 !   SEQUENCE customers_segment_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.customers_segment_id_seq TO postgresql_u300188;
          public          postgres    false    312            �            1259    17952    departments    TABLE     �   CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.departments;
       public         heap    postgres    false    7                       0    0    TABLE departments    ACL     =   GRANT ALL ON TABLE public.departments TO postgresql_u300188;
          public          postgres    false    214            �            1259    17960    department_id_seq    SEQUENCE     �   CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.department_id_seq;
       public          postgres    false    7    214                       0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
          public          postgres    false    215                       0    0    SEQUENCE department_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.department_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7                       0    0    TABLE failed_jobs    ACL     =   GRANT ALL ON TABLE public.failed_jobs TO postgresql_u300188;
          public          postgres    false    216            �            1259    17969    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    7    216                       0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    217                       0    0    SEQUENCE failed_jobs_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.failed_jobs_id_seq TO postgresql_u300188;
          public          postgres    false    217            �            1259    17971    invoice_detail    TABLE       CREATE TABLE public.invoice_detail (
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
       public         heap    postgres    false    7                       0    0    TABLE invoice_detail    ACL     @   GRANT ALL ON TABLE public.invoice_detail TO postgresql_u300188;
          public          postgres    false    218            B           1259    34018    invoice_detail_log    TABLE     
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
       public         heap    postgres    false    7                       0    0    TABLE invoice_detail_log    ACL     D   GRANT ALL ON TABLE public.invoice_detail_log TO postgresql_u300188;
          public          postgres    false    322            ?           1259    33377    invoice_log    TABLE     �  CREATE TABLE public.invoice_log (
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
       public         heap    postgres    false    7                        0    0    TABLE invoice_log    ACL     =   GRANT ALL ON TABLE public.invoice_log TO postgresql_u300188;
          public          postgres    false    319            �            1259    17984    invoice_master    TABLE     _  CREATE TABLE public.invoice_master (
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
       public         heap    postgres    false    7            !           0    0    TABLE invoice_master    ACL     @   GRANT ALL ON TABLE public.invoice_master TO postgresql_u300188;
          public          postgres    false    219            �            1259    18001    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    7    219            "           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
          public          postgres    false    220            #           0    0    SEQUENCE invoice_master_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.invoice_master_id_seq TO postgresql_u300188;
          public          postgres    false    220            �            1259    18003 	   job_title    TABLE     �   CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.job_title;
       public         heap    postgres    false    7            $           0    0    TABLE job_title    ACL     ;   GRANT ALL ON TABLE public.job_title TO postgresql_u300188;
          public          postgres    false    221            �            1259    18011    job_title_id_seq    SEQUENCE     �   CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.job_title_id_seq;
       public          postgres    false    221    7            %           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
          public          postgres    false    222            &           0    0    SEQUENCE job_title_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.job_title_id_seq TO postgresql_u300188;
          public          postgres    false    222            +           1259    18727    login_session    TABLE       CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.login_session;
       public         heap    postgres    false    7            '           0    0    TABLE login_session    ACL     ?   GRANT ALL ON TABLE public.login_session TO postgresql_u300188;
          public          postgres    false    299            �            1259    18013 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    7            (           0    0    TABLE migrations    ACL     <   GRANT ALL ON TABLE public.migrations TO postgresql_u300188;
          public          postgres    false    223            �            1259    18016    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    223    7            )           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    224            *           0    0    SEQUENCE migrations_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.migrations_id_seq TO postgresql_u300188;
          public          postgres    false    224            �            1259    18018    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap    postgres    false    7            +           0    0    TABLE model_has_permissions    ACL     G   GRANT ALL ON TABLE public.model_has_permissions TO postgresql_u300188;
          public          postgres    false    225            �            1259    18021    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap    postgres    false    7            ,           0    0    TABLE model_has_roles    ACL     A   GRANT ALL ON TABLE public.model_has_roles TO postgresql_u300188;
          public          postgres    false    226            �            1259    18024    order_detail    TABLE     �  CREATE TABLE public.order_detail (
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
       public         heap    postgres    false    7            -           0    0    TABLE order_detail    ACL     >   GRANT ALL ON TABLE public.order_detail TO postgresql_u300188;
          public          postgres    false    227            �            1259    18036    order_master    TABLE     Q  CREATE TABLE public.order_master (
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
       public         heap    postgres    false    7            .           0    0    TABLE order_master    ACL     >   GRANT ALL ON TABLE public.order_master TO postgresql_u300188;
          public          postgres    false    228            �            1259    18053    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    228    7            /           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
          public          postgres    false    229            0           0    0    SEQUENCE order_master_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.order_master_id_seq TO postgresql_u300188;
          public          postgres    false    229            �            1259    18055    password_resets    TABLE     �   CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 #   DROP TABLE public.password_resets;
       public         heap    postgres    false    7            1           0    0    TABLE password_resets    ACL     A   GRANT ALL ON TABLE public.password_resets TO postgresql_u300188;
          public          postgres    false    230            �            1259    18061    period    TABLE     �   CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    start_cal date,
    end_cal date
);
    DROP TABLE public.period;
       public         heap    postgres    false    7            2           0    0    TABLE period    ACL     8   GRANT ALL ON TABLE public.period TO postgresql_u300188;
          public          postgres    false    231            �            1259    18067    period_price_sell    TABLE     X  CREATE TABLE public.period_price_sell (
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
       public         heap    postgres    false    7            3           0    0    TABLE period_price_sell    ACL     C   GRANT ALL ON TABLE public.period_price_sell TO postgresql_u300188;
          public          postgres    false    232            �            1259    18071    period_price_sell_id_seq    SEQUENCE     �   CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.period_price_sell_id_seq;
       public          postgres    false    232    7            4           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
          public          postgres    false    233            5           0    0 !   SEQUENCE period_price_sell_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.period_price_sell_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            6           0    0    TABLE period_stock    ACL     >   GRANT ALL ON TABLE public.period_stock TO postgresql_u300188;
          public          postgres    false    234            T           1259    35031    period_stock_daily    TABLE     �  CREATE TABLE public.period_stock_daily (
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
       public         heap    postgres    false    7            7           0    0    TABLE period_stock_daily    ACL     D   GRANT ALL ON TABLE public.period_stock_daily TO postgresql_u300188;
          public          postgres    false    340            �            1259    18083    permissions    TABLE     l  CREATE TABLE public.permissions (
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
       public         heap    postgres    false    7            8           0    0    TABLE permissions    ACL     =   GRANT ALL ON TABLE public.permissions TO postgresql_u300188;
          public          postgres    false    235            �            1259    18089    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    7    235            9           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    236            :           0    0    SEQUENCE permissions_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.permissions_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            ;           0    0    TABLE personal_access_tokens    ACL     H   GRANT ALL ON TABLE public.personal_access_tokens TO postgresql_u300188;
          public          postgres    false    237            �            1259    18097    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    7    237            <           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    238            =           0    0 &   SEQUENCE personal_access_tokens_id_seq    ACL     R   GRANT ALL ON SEQUENCE public.personal_access_tokens_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            >           0    0    TABLE petty_cash    ACL     <   GRANT ALL ON TABLE public.petty_cash TO postgresql_u300188;
          public          postgres    false    316            >           1259    30759    petty_cash_detail    TABLE     �  CREATE TABLE public.petty_cash_detail (
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
       public         heap    postgres    false    7            ?           0    0    TABLE petty_cash_detail    ACL     C   GRANT ALL ON TABLE public.petty_cash_detail TO postgresql_u300188;
          public          postgres    false    318            =           1259    30757    petty_cash_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.petty_cash_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.petty_cash_detail_id_seq;
       public          postgres    false    318    7            @           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    317            A           0    0 !   SEQUENCE petty_cash_detail_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.petty_cash_detail_id_seq TO postgresql_u300188;
          public          postgres    false    317            ;           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    316    7            B           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
          public          postgres    false    315            C           0    0    SEQUENCE petty_cash_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.petty_cash_id_seq TO postgresql_u300188;
          public          postgres    false    315            �            1259    18099    point_conversion    TABLE        CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE public.point_conversion;
       public         heap    postgres    false    7            D           0    0    TABLE point_conversion    ACL     B   GRANT ALL ON TABLE public.point_conversion TO postgresql_u300188;
          public          postgres    false    239            �            1259    18104    posts    TABLE     $  CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.posts;
       public         heap    postgres    false    7            E           0    0    TABLE posts    ACL     7   GRANT ALL ON TABLE public.posts TO postgresql_u300188;
          public          postgres    false    240            �            1259    18110    posts_id_seq    SEQUENCE     u   CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    240    7            F           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    241            G           0    0    SEQUENCE posts_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.posts_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            H           0    0    TABLE price_adjustment    ACL     B   GRANT ALL ON TABLE public.price_adjustment TO postgresql_u300188;
          public          postgres    false    242            �            1259    18117    price_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.price_adjustment_id_seq;
       public          postgres    false    242    7            I           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
          public          postgres    false    243            J           0    0     SEQUENCE price_adjustment_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.price_adjustment_id_seq TO postgresql_u300188;
          public          postgres    false    243            �            1259    18119    product_brand    TABLE     �   CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 !   DROP TABLE public.product_brand;
       public         heap    postgres    false    7            K           0    0    TABLE product_brand    ACL     ?   GRANT ALL ON TABLE public.product_brand TO postgresql_u300188;
          public          postgres    false    244            �            1259    18127    product_brand_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.product_brand_id_seq;
       public          postgres    false    244    7            L           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
          public          postgres    false    245            M           0    0    SEQUENCE product_brand_id_seq    ACL     I   GRANT ALL ON SEQUENCE public.product_brand_id_seq TO postgresql_u300188;
          public          postgres    false    245            �            1259    18129    product_category    TABLE        CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 $   DROP TABLE public.product_category;
       public         heap    postgres    false    7            N           0    0    TABLE product_category    ACL     B   GRANT ALL ON TABLE public.product_category TO postgresql_u300188;
          public          postgres    false    246            �            1259    18137    product_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_category_id_seq;
       public          postgres    false    7    246            O           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
          public          postgres    false    247            P           0    0     SEQUENCE product_category_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.product_category_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            Q           0    0    TABLE product_commision_by_year    ACL     K   GRANT ALL ON TABLE public.product_commision_by_year TO postgresql_u300188;
          public          postgres    false    248            �            1259    18143    product_commisions    TABLE     _  CREATE TABLE public.product_commisions (
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
       public         heap    postgres    false    7            R           0    0    TABLE product_commisions    ACL     D   GRANT ALL ON TABLE public.product_commisions TO postgresql_u300188;
          public          postgres    false    249            �            1259    18149    product_distribution    TABLE       CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.product_distribution;
       public         heap    postgres    false    7            S           0    0    TABLE product_distribution    ACL     F   GRANT ALL ON TABLE public.product_distribution TO postgresql_u300188;
          public          postgres    false    250            �            1259    18154    product_ingredients    TABLE     H  CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_ingredients;
       public         heap    postgres    false    7            T           0    0    TABLE product_ingredients    ACL     E   GRANT ALL ON TABLE public.product_ingredients TO postgresql_u300188;
          public          postgres    false    251            �            1259    18159    product_point    TABLE     �   CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 !   DROP TABLE public.product_point;
       public         heap    postgres    false    7            U           0    0    TABLE product_point    ACL     ?   GRANT ALL ON TABLE public.product_point TO postgresql_u300188;
          public          postgres    false    252            �            1259    18163    product_price    TABLE     -  CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.product_price;
       public         heap    postgres    false    7            V           0    0    TABLE product_price    ACL     ?   GRANT ALL ON TABLE public.product_price TO postgresql_u300188;
          public          postgres    false    253            :           1259    30122    product_price_level    TABLE     �  CREATE TABLE public.product_price_level (
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
       public         heap    postgres    false    7            W           0    0    TABLE product_price_level    ACL     E   GRANT ALL ON TABLE public.product_price_level TO postgresql_u300188;
          public          postgres    false    314            �            1259    18167    product_sku    TABLE     f  CREATE TABLE public.product_sku (
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
       public         heap    postgres    false    7            X           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    254            Y           0    0    TABLE product_sku    ACL     =   GRANT ALL ON TABLE public.product_sku TO postgresql_u300188;
          public          postgres    false    254            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    7    254            Z           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
          public          postgres    false    255            [           0    0    SEQUENCE product_sku_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.product_sku_id_seq TO postgresql_u300188;
          public          postgres    false    255                        1259    18178    product_stock    TABLE       CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 !   DROP TABLE public.product_stock;
       public         heap    postgres    false    7            \           0    0    TABLE product_stock    ACL     ?   GRANT ALL ON TABLE public.product_stock TO postgresql_u300188;
          public          postgres    false    256            V           1259    35203    product_stock_buffer    TABLE     J  CREATE TABLE public.product_stock_buffer (
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
       public         heap    postgres    false    7            ]           0    0    TABLE product_stock_buffer    ACL     F   GRANT ALL ON TABLE public.product_stock_buffer TO postgresql_u300188;
          public          postgres    false    342            U           1259    35201    product_stock_buffer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_buffer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_buffer_id_seq;
       public          postgres    false    342    7            ^           0    0    product_stock_buffer_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_buffer_id_seq OWNED BY public.product_stock_buffer.id;
          public          postgres    false    341            _           0    0 $   SEQUENCE product_stock_buffer_id_seq    ACL     P   GRANT ALL ON SEQUENCE public.product_stock_buffer_id_seq TO postgresql_u300188;
          public          postgres    false    341                       1259    18183    product_stock_detail    TABLE     u  CREATE TABLE public.product_stock_detail (
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
       public         heap    postgres    false    7            `           0    0    TABLE product_stock_detail    ACL     F   GRANT ALL ON TABLE public.product_stock_detail TO postgresql_u300188;
          public          postgres    false    257                       1259    18189    product_stock_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_detail_id_seq;
       public          postgres    false    257    7            a           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    258            b           0    0 $   SEQUENCE product_stock_detail_id_seq    ACL     P   GRANT ALL ON SEQUENCE public.product_stock_detail_id_seq TO postgresql_u300188;
          public          postgres    false    258                       1259    18191    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    abbr character varying
);
     DROP TABLE public.product_type;
       public         heap    postgres    false    7            c           0    0    TABLE product_type    ACL     >   GRANT ALL ON TABLE public.product_type TO postgresql_u300188;
          public          postgres    false    259                       1259    18198    product_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.product_type_id_seq;
       public          postgres    false    7    259            d           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
          public          postgres    false    260            e           0    0    SEQUENCE product_type_id_seq    ACL     H   GRANT ALL ON SEQUENCE public.product_type_id_seq TO postgresql_u300188;
          public          postgres    false    260                       1259    18200    product_uom    TABLE     �   CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.product_uom;
       public         heap    postgres    false    7            f           0    0    TABLE product_uom    ACL     =   GRANT ALL ON TABLE public.product_uom TO postgresql_u300188;
          public          postgres    false    261                       1259    18204    uom    TABLE       CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.uom;
       public         heap    postgres    false    7            g           0    0 	   TABLE uom    ACL     5   GRANT ALL ON TABLE public.uom TO postgresql_u300188;
          public          postgres    false    262                       1259    18213    product_uom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_uom_id_seq;
       public          postgres    false    7    262            h           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
          public          postgres    false    263            i           0    0    SEQUENCE product_uom_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.product_uom_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            j           0    0    TABLE purchase_detail    ACL     A   GRANT ALL ON TABLE public.purchase_detail TO postgresql_u300188;
          public          postgres    false    264            	           1259    18230    purchase_master    TABLE     �  CREATE TABLE public.purchase_master (
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
       public         heap    postgres    false    7            k           0    0    TABLE purchase_master    ACL     A   GRANT ALL ON TABLE public.purchase_master TO postgresql_u300188;
          public          postgres    false    265            
           1259    18246    purchase_master_id_seq    SEQUENCE        CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.purchase_master_id_seq;
       public          postgres    false    7    265            l           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
          public          postgres    false    266            m           0    0    SEQUENCE purchase_master_id_seq    ACL     K   GRANT ALL ON SEQUENCE public.purchase_master_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            n           0    0    TABLE receive_detail    ACL     @   GRANT ALL ON TABLE public.receive_detail TO postgresql_u300188;
          public          postgres    false    267                       1259    18262    receive_master    TABLE     �  CREATE TABLE public.receive_master (
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
       public         heap    postgres    false    7            o           0    0    TABLE receive_master    ACL     @   GRANT ALL ON TABLE public.receive_master TO postgresql_u300188;
          public          postgres    false    268                       1259    18278    receive_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.receive_master_id_seq;
       public          postgres    false    268    7            p           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
          public          postgres    false    269            q           0    0    SEQUENCE receive_master_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.receive_master_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            r           0    0    TABLE return_sell_detail    ACL     D   GRANT ALL ON TABLE public.return_sell_detail TO postgresql_u300188;
          public          postgres    false    270                       1259    18292    return_sell_master    TABLE       CREATE TABLE public.return_sell_master (
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
       public         heap    postgres    false    7            s           0    0    TABLE return_sell_master    ACL     D   GRANT ALL ON TABLE public.return_sell_master TO postgresql_u300188;
          public          postgres    false    271                       1259    18309    return_sell_master_id_seq    SEQUENCE     �   CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.return_sell_master_id_seq;
       public          postgres    false    271    7            t           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
          public          postgres    false    272            u           0    0 "   SEQUENCE return_sell_master_id_seq    ACL     N   GRANT ALL ON SEQUENCE public.return_sell_master_id_seq TO postgresql_u300188;
          public          postgres    false    272                       1259    18311    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap    postgres    false    7            v           0    0    TABLE role_has_permissions    ACL     F   GRANT ALL ON TABLE public.role_has_permissions TO postgresql_u300188;
          public          postgres    false    273                       1259    18314    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap    postgres    false    7            w           0    0    TABLE roles    ACL     7   GRANT ALL ON TABLE public.roles TO postgresql_u300188;
          public          postgres    false    274                       1259    18320    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    7    274            x           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    275            y           0    0    SEQUENCE roles_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.roles_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            z           0    0    TABLE sales    ACL     7   GRANT ALL ON TABLE public.sales TO postgresql_u300188;
          public          postgres    false    301            ,           1259    18734    sales_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sales_id_seq;
       public          postgres    false    301    7            {           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
          public          postgres    false    300            |           0    0    SEQUENCE sales_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.sales_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            }           0    0    TABLE sales_trip    ACL     <   GRANT ALL ON TABLE public.sales_trip TO postgresql_u300188;
          public          postgres    false    303            1           1259    18762    sales_trip_detail    TABLE     b  CREATE TABLE public.sales_trip_detail (
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
       public         heap    postgres    false    7            ~           0    0    TABLE sales_trip_detail    ACL     C   GRANT ALL ON TABLE public.sales_trip_detail TO postgresql_u300188;
          public          postgres    false    305            0           1259    18760    sales_trip_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sales_trip_detail_id_seq;
       public          postgres    false    7    305                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    304            �           0    0 !   SEQUENCE sales_trip_detail_id_seq    ACL     M   GRANT ALL ON SEQUENCE public.sales_trip_detail_id_seq TO postgresql_u300188;
          public          postgres    false    304            .           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    303    7            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    302            �           0    0    SEQUENCE sales_trip_id_seq    ACL     F   GRANT ALL ON SEQUENCE public.sales_trip_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE sales_visit    ACL     =   GRANT ALL ON TABLE public.sales_visit TO postgresql_u300188;
          public          postgres    false    311            6           1259    27178    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    311    7            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
          public          postgres    false    310            �           0    0    SEQUENCE sales_visit_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.sales_visit_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    276            �           0    0    TABLE setting_document_counter    ACL     J   GRANT ALL ON TABLE public.setting_document_counter TO postgresql_u300188;
          public          postgres    false    276                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    276    7            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
          public          postgres    false    277            �           0    0 (   SEQUENCE setting_document_counter_id_seq    ACL     T   GRANT ALL ON SEQUENCE public.setting_document_counter_id_seq TO postgresql_u300188;
          public          postgres    false    277                       1259    18332    settings    TABLE     	  CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);
    DROP TABLE public.settings;
       public         heap    postgres    false    7            �           0    0    TABLE settings    ACL     :   GRANT ALL ON TABLE public.settings TO postgresql_u300188;
          public          postgres    false    278                       1259    18339    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.shift;
       public         heap    postgres    false    7            �           0    0    TABLE shift    ACL     7   GRANT ALL ON TABLE public.shift TO postgresql_u300188;
          public          postgres    false    279                       1259    18348    shift_counter    TABLE     $  CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);
 !   DROP TABLE public.shift_counter;
       public         heap    postgres    false    7            �           0    0    TABLE shift_counter    ACL     ?   GRANT ALL ON TABLE public.shift_counter TO postgresql_u300188;
          public          postgres    false    280                       1259    18352    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public          postgres    false    7    279            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    281            �           0    0    SEQUENCE shift_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.shift_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE stock_log    ACL     ;   GRANT ALL ON TABLE public.stock_log TO postgresql_u300188;
          public          postgres    false    321            @           1259    33391    stock_log_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stock_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stock_log_id_seq;
       public          postgres    false    7    321            �           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
          public          postgres    false    320            �           0    0    SEQUENCE stock_log_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.stock_log_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE suppliers    ACL     ;   GRANT ALL ON TABLE public.suppliers TO postgresql_u300188;
          public          postgres    false    282                       1259    18361    suppliers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.suppliers_id_seq;
       public          postgres    false    282    7            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            �           0    0    SEQUENCE suppliers_id_seq    ACL     E   GRANT ALL ON SEQUENCE public.suppliers_id_seq TO postgresql_u300188;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    7    299            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    298            �           0    0     SEQUENCE sv_login_session_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.sv_login_session_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE terapist_commision    ACL     D   GRANT ALL ON TABLE public.terapist_commision TO postgresql_u300188;
          public          postgres    false    338                       1259    18363    users    TABLE       CREATE TABLE public.users (
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
       public         heap    postgres    false    7            �           0    0    TABLE users    ACL     7   GRANT ALL ON TABLE public.users TO postgresql_u300188;
          public          postgres    false    284                       1259    18371    users_branch    TABLE     �   CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
     DROP TABLE public.users_branch;
       public         heap    postgres    false    7            �           0    0    TABLE users_branch    ACL     >   GRANT ALL ON TABLE public.users_branch TO postgresql_u300188;
          public          postgres    false    285                       1259    18375    users_experience    TABLE     P  CREATE TABLE public.users_experience (
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
       public         heap    postgres    false    7            �           0    0    TABLE users_experience    ACL     B   GRANT ALL ON TABLE public.users_experience TO postgresql_u300188;
          public          postgres    false    286                       1259    18382    users_experience_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_experience_id_seq;
       public          postgres    false    7    286            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    287            �           0    0     SEQUENCE users_experience_id_seq    ACL     L   GRANT ALL ON SEQUENCE public.users_experience_id_seq TO postgresql_u300188;
          public          postgres    false    287                        1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    7    284            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    288            �           0    0    SEQUENCE users_id_seq    ACL     A   GRANT ALL ON SEQUENCE public.users_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE users_mutation    ACL     @   GRANT ALL ON TABLE public.users_mutation TO postgresql_u300188;
          public          postgres    false    289            "           1259    18393    users_mutation_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.users_mutation_id_seq;
       public          postgres    false    289    7            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
          public          postgres    false    290            �           0    0    SEQUENCE users_mutation_id_seq    ACL     J   GRANT ALL ON SEQUENCE public.users_mutation_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE users_shift    ACL     =   GRANT ALL ON TABLE public.users_shift TO postgresql_u300188;
          public          postgres    false    291            $           1259    18402    users_shift_id_seq    SEQUENCE     {   CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_shift_id_seq;
       public          postgres    false    7    291            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
          public          postgres    false    292            �           0    0    SEQUENCE users_shift_id_seq    ACL     G   GRANT ALL ON SEQUENCE public.users_shift_id_seq TO postgresql_u300188;
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
       public         heap    postgres    false    7            �           0    0    TABLE users_skills    ACL     >   GRANT ALL ON TABLE public.users_skills TO postgresql_u300188;
          public          postgres    false    293            &           1259    18412    voucher    TABLE     	  CREATE TABLE public.voucher (
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
       public         heap    postgres    false    7            �           0    0    TABLE voucher    ACL     9   GRANT ALL ON TABLE public.voucher TO postgresql_u300188;
          public          postgres    false    294            '           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    7    294            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    295            �           0    0    SEQUENCE voucher_id_seq    ACL     C   GRANT ALL ON SEQUENCE public.voucher_id_seq TO postgresql_u300188;
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
       public          postgres    false    312    313    313                        2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214                       2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216                       2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    298    299    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223            "           2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            .           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            7           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            9           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            <           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            =           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            @           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            C           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            M           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254                       2604    35206    product_stock_buffer id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_buffer ALTER COLUMN id SET DEFAULT nextval('public.product_stock_buffer_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_buffer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    341    342    342            S           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            W           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            g           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            z           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            �           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            �           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            �           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
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
       public          postgres    false    320    321    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            Z           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
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
    pgagent          postgres    false    323            �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325            �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327            �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331            �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333            �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335            �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329            �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337            s          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206            u          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208            �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297            �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309            �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339            w          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210            y          0    17942 	   customers 
   TABLE DATA           t  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id, gender) FROM stdin;
    public          postgres    false    212            �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307            �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313            {          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214            }          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216                      0    17971    invoice_detail 
   TABLE DATA              COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, ref_no) FROM stdin;
    public          postgres    false    218            �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert, ref_no) FROM stdin;
    public          postgres    false    322            �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319            �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219            �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221            �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299            �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223            �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225            �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226            �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227            �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228            �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230            �          0    18061    period 
   TABLE DATA           ]   COPY public.period (period_no, remark, start_date, end_date, start_cal, end_cal) FROM stdin;
    public          postgres    false    231            �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232            �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234            �          0    35031    period_stock_daily 
   TABLE DATA           �   COPY public.period_stock_daily (dated, branch_id, product_id, balance_end, qty_in, qty_out, created_at, qty_receive, qty_inv, qty_product_out, qty_product_in, qty_stock) FROM stdin;
    public          postgres    false    340            �          0    18083    permissions 
   TABLE DATA           m   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent, seq) FROM stdin;
    public          postgres    false    235            �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237            �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316            �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318            �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239            �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240            �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242            �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244            �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246            �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248            �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249            �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250            �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251            �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252            �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253            �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314            �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254            �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256            �          0    35203    product_stock_buffer 
   TABLE DATA           ~   COPY public.product_stock_buffer (id, product_id, branch_id, qty, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    342            �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257            �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259            �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261            �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264            �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265            �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267            �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268            �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270            �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271            �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273            �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274            �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301            �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303            �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305            �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311            �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276            �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278            �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279            �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280            �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321            �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282            �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338            �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262            �          0    18363    users 
   TABLE DATA           d  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year, level_up_date) FROM stdin;
    public          postgres    false    284            �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285            �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286            �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289            �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291            �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293            �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294            �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 24, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.branch_room_id_seq', 308, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.branch_shift_id_seq', 20, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211            �           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 6384, true);
          public          postgres    false    213            �           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306            �           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217            �           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 9367, true);
          public          postgres    false    220            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            �           0    0    period_price_sell_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 13517, true);
          public          postgres    false    233            �           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 538, true);
          public          postgres    false    236            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            �           0    0    petty_cash_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 1980, true);
          public          postgres    false    317            �           0    0    petty_cash_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.petty_cash_id_seq', 385, true);
          public          postgres    false    315            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            �           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            �           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            �           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 55, true);
          public          postgres    false    247            �           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 530, true);
          public          postgres    false    255            �           0    0    product_stock_buffer_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.product_stock_buffer_id_seq', 4664, true);
          public          postgres    false    341            �           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258            �           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260            �           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 59, true);
          public          postgres    false    263            �           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266            �           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269            �           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272            �           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 15, true);
          public          postgres    false    275            �           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300            �           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304            �           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302            �           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310            �           0    0    setting_document_counter_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 132, true);
          public          postgres    false    277            �           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 14, true);
          public          postgres    false    281            �           0    0    stock_log_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.stock_log_id_seq', 26802, true);
          public          postgres    false    320            �           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 6, true);
          public          postgres    false    283            �           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            �           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            �           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 314, true);
          public          postgres    false    288            �           0    0    users_mutation_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_mutation_id_seq', 331, true);
          public          postgres    false    290            �           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            �           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295                       2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206                       2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    208                       2606    35553    branch_room branch_room_un 
   CONSTRAINT     b   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_un UNIQUE (branch_id, remark);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_un;
       public            postgres    false    208    208                       2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    206            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309                        2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210            "           2606    18467    customers customers_pk 
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
       public            postgres    false    313            $           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216            &           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216            (           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218            *           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219            ,           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219            .           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223            1           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225            4           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339            6           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227            8           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228            :           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228            =           2606    40428    period period_pk 
   CONSTRAINT     U   ALTER TABLE ONLY public.period
    ADD CONSTRAINT period_pk PRIMARY KEY (period_no);
 :   ALTER TABLE ONLY public.period DROP CONSTRAINT period_pk;
       public            postgres    false    231            �           2606    35040 (   period_stock_daily period_stock_daily_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.period_stock_daily
    ADD CONSTRAINT period_stock_daily_pk PRIMARY KEY (dated, branch_id, product_id);
 R   ALTER TABLE ONLY public.period_stock_daily DROP CONSTRAINT period_stock_daily_pk;
       public            postgres    false    340    340    340            ?           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234            A           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            C           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            E           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            H           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            J           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            L           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            N           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            P           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            R           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            T           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            V           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            X           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            Z           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            \           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            ^           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            �           2606    35211 ,   product_stock_buffer product_stock_buffer_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_buffer
    ADD CONSTRAINT product_stock_buffer_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_buffer DROP CONSTRAINT product_stock_buffer_pk;
       public            postgres    false    342            �           2606    35213 ,   product_stock_buffer product_stock_buffer_un 
   CONSTRAINT     x   ALTER TABLE ONLY public.product_stock_buffer
    ADD CONSTRAINT product_stock_buffer_un UNIQUE (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_stock_buffer DROP CONSTRAINT product_stock_buffer_un;
       public            postgres    false    342    342            b           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            `           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            d           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            f           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            l           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            n           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            p           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            r           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            t           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            v           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            x           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            z           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            |           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            ~           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            �           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            �           2606    18551    roles roles_pkey 
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
       public            postgres    false    311            �           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            �           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            �           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            �           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            �           2606    18561    suppliers suppliers_pk 
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
       public            postgres    false    338    338    338    338    338    338    338            h           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            j           2606    18565 
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
       public            postgres    false    294    294            /           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225            2           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226            ;           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            F           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    208    3608    206            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    3628    219    218            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3728    219    284            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    235    3649    225            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3714    226    274            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    3642    227    228            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3728    284    228            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    228    212    3618            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    284    3728    240            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    248    254    3676            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    248    3608    206            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3728    284    248            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    250    3608    206            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    3676    254    250            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    3676    261    254            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    264    3696    265            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    284    265    3728            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    268    3702    267            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3728    284    268            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    270    271    3708            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    284    3728    271            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    271    212    3618            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3649    235    273            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    274    273    3714            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    293    3728    284            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      s   �  x�u�M��0��ί�S�C�p�8��5��J{ɹ�V����1¢��<���x�;k<�K��ӎ]n�op�����w��?�ش`�Ι�R�x��D�Q��}�D��bb#V`a���g��d����V�y_�P�{�ނ�Z8���� �v%�auBˆ�XQ���v�X<UqFOc�ޑ���n�)���ū����,�#�\;��ƌ�n�1�(*�:P�kf-]`���'�Kӏmp{�/�&�� w?झ��)��@�=��G��Q�.�8I��>W�P�<�0��e�����A�]�g�<Q����%|��V�ᨫΡ��%h���Pj�Z] p�;�?C��:����P�6�v�֏��[b)!ìw8��hY��(��"s!?�~�A���i�����d(�d|(�*��֜��B�qs*�a7�#Ŗ�����g1��|v	Z]R�^u�m7 M���#���u��	�~�lN�a�9�.(������i� ���<9�����>^����.�Ƙ8׍|��!�*�d*����֯���^*ZcMBl�t!G-��L���Ҷ:N"��U�<y#a5��'�̆������j�������h�;+��	V1E/1�`HQ_� Y(�$�5�W�j-��"^���������?�/W�      u   �  x�}�]����G��8(Q���o��8c��3@���P��%���O��I�խ���,/?������ʻ���%�G��#-eV9ʏ�EZ�MaM茴����������I��𴩥<,	���>���iIx~y�#�O����jyp�%�
�8�����A�_��`EaM*pj��v���e��(�mj�Xa~l�x>�%Z�B/�����Nl��ri����GZ��� &��ai�N��l���hi��lr���59�9p$ir@�����R)��%.�A��R����Ǡ~��������I�7�T��~�x\�k.��ٰ�T�~��&^�9i��
��5IB��z�X��aSO-լ��C=������ɗ���>�]9���vb��d5�0y��(i�V��3�}/�FK��hHG�%��}�9;?�� ��a®� �{ñwU��z^�L�HK| |�!��/-��`魗��>��=Bjq7Zb�P�/���~��_#�%�W�~k්��]k.����ç���e��[Z��Y�W�/��w������\Z�s��?}�i�5@����P����f�ԲC!`޻��R��~���g2�
i������KK�����,�����sv�%.�Rk C�mo�FK�a7�KK�Z<���i��	��HK��$y���i���-	�/�7.-u�v�V�L� 
�ԋ��E��z���� 
�kg�1O	<J��=�q�ĥ��5<�m֗����V|DZ�����(�|7́��7�KK#?�oA�뾎-�k9��msFZ�vU��_�Ө�Y�q���kj�~ݸ�4�^1�1mF��H�4_ZC��ѱ�d#-�S��soj�<4=���l�tf����?Y�O�*0�`鿴t�;-U�W�i�T�{륥��;�B�>�t63`��^��Z:������;��sh.�@I�_:O�A�[�!����845n�{i��ɑU���K�.�zq��^����̈́��U���`�����a�#�l��	ٴK�1
b�3V��d(�XA~�&�Y3p=�A�M-�l� 0�{j�.��[�Ԅ�{L� �A�&dyk^j�P�*�/�B�75�l@v�i���֝�ޤ�c-8���TOM���`��oLM@�<������2�%L�4�X�C�y(�������]#®��h0P5�)%H�/I�.��q�0���L��9agũ	i����_0\��Ð0��k�Ԅ���~{w�6e��s��R�/t�?��6rk�H.+.��O�F�&�w�ۨ�=�hV5@kC��H�W�Mߥ0�pMqm���h�u�6��g�	7�TsB��1�I.�Cq�ی}|7�p����s.�ni��XĆBM�rs%�W|��&\U\��{{3�p|s�����h�5Ł��w�	ׯ	a�(#��NM��A�8�"M�S��>��2�<PPZ��Aߐ�W}.M@� d��X�k2B�>�M@�``T�(�ԑ�OoT�U�hv�"Byo�&�� ����� |j2�.�FK��:����&`� d�q�^��f��6\��&`� �Q��4��U��Q�P�&��9滄ۦe쫌�)ʯn8FN��wn^?��Hn(���:gM���'�9�Y�h)ϗ�g�q/7/M����6n#�4�HqmJ�	W98��	W�|���0�Ƿ4�Xq>/�_��	���2��/M��_����$?w/M��8����xi��8i��0Z��P������4�� �L.M��/�]6�/K�(�R���҄�O.8@�U�.M8V<��7�F�=��Ľ�J�L�]���x\_0F%���5NBޫ?]Z��A(>�m����D�zi^]ۖQ�1NM��A�*��|:���0$��u�d�����l����E���e­)��;�Y��&�P9����&����/��Y��J�%Z�I�2��q��-ތ��F�,ZѬB$��M���_�n3�B*M�jQ_*�V�4A٢0��o�J�Ytx��'���U��Jt�����^i�&�o'�����D��S�2���4a]Ce訦OgJ�uTM�`�&�j)\�.���N�	X5#����k�6ֲۨ`�`� ��c�k��N�O��H�	�5��Ȍͻ4I�~�����4��x���K�j�7�����qi�}g�/M��ə��i0x:�:?[}-����2j�!�	8��;=�6�8�oFh�OO�M8����r�����M��&�\��&`� ��z�4I���B�5��7�&�4�90�S�',oF��M���$g<��5�����4!�&!;�Y�&�A��i��%��� ,�ª0�	�Z����m�Ǔ+��՘��t-M����&{K�����#���W��Wi�u��� ��Jա8_��A<Ğ�?�Sq�����%��"��f\���3s�4����jF�4�^��hV4� ��6sM���F���h��3b���h�'hn#��~�a4��|N�>j�#���U�h�l2����j;n�D���&\V\�ﾥM8Ry�U��o}B�(j����FN�͊sM2�ߚ��AB�jJ����y�g�	Ե��F��d4�a,e_��&�AF����o��}�2�@����ebk��y#����,Oo�m���G�	g�%xx�dNM@V!-��2F�)���FδKT	F8�W���!t�i��D#+��%\��� �A�Y�&\UB�G�фӅ����b�h�]����2�I;֤����}�6�@������b4��7jv�}}k��k����͆�&�#;�ֵ5������4�����j�4��)^	���	�ox���h�7ȧL(x�t\���8?�&�x��'��z����j--���ﯟ��	!������O�c��4���A*朹5�����	X5<��qs�i��-g�A�&`� $"��4�#
��߿������      �   �   x�u�ɑ!��
`C%���;Vt죻E��"AGMh	H�O�ZX
4c��
0�˒c\5��	�ai����j��1���1ng�r�?�^xd4k�Ӽ,9�#���ۚlm�F����la��ޝ�ݸ��+���l�߳��+&T�/5��iY� �?�5sm&h�g5��곎0�ζv�mY{?~t�|�[�{^��?&��wm�����6������� ����~%��?      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[o]W���Y���Ƀ�u�䍮fX�OɁ,�[@��d��JP$??G"u87u���<���9d��*��9֘�u�?�������|���ow�7�i��ݼy�_~p>�\�?���󩦛��������O���|���������_������������������w�����;��o����w��?����w�~?���/?��I�[0S΃ɮ����6�BpA	���@`��)5R��� ���������	�W0!��_~���_�v����o��O������n������ǿ�����+�=�z�N?6����Q����MD�Y������A��&k,����>���)�1%SX[�"a�ȄeDM[�Dטle$�dK��c�b��ly[;UWba�Ŵ�^�����O�?���cY[n~}����n~<�O��>�z�������' O���N�B��_X�"a����J2��yT�L��-,�w��-B[,�P��݂uz���B0��� �YW�4����S@�!I9e��A��bw�St�V��j[�l1�l\�i�"Vr���X12a$,9,4��D��Φ߾�������&��y����)���훇����?:���?�N�~�2��li���J�����~1k:|8|xw�������������w<������KL�G$[rNҸC�zl�+$[�3���J^3��^���������������p����^��&Yn�4N�j@��	�tSX��"��̔|�HX���-&[�v%�v���� �-[��=�-���N?V�J��+���N;Է���`�<�}gj�QA�w�vf�H��U��3���IX��J�aE���� �J�����JԂ�*������Za.�P�lՎ�x0vͨ�AHX%3a�5XS��\����`��cS��.Clq���HXE���q`�p�Ȅ�la)�Սa)l�����V��[�|+|�%�W�:Q\@�1�(v�H�ӷB\��A���-�V�␝b��L�Z�����8�1,b��5�4*�u�*�<�"�8��Dѯaal]� ��
H�JA��#���"��SM����x���V��2֖D��z$�̄�̉�ɑ��%�U���V$[5�jKc�-c;�\�طX���	V���k��ޔD�UO�<,�N�'�
�Ґ��d��D�����-@�d�[��z&[�A|5[��t8<,'�_���훷7��>���t����E���CF�A�c���j^�;`z���:�����HX� �ވ��3fK	b	HX�8�
�l�֐A`�*ɖ�LX�Ĉd�
X3�k>KX� �И�:VNHX�����`��jˮ �IL!�*��f�X�6��U}۰�lEc�*0�2�ғ�Ah����%c�W�U��' ��G�&,)yX��C&�j�0ay&,��UV�ȕ�j�����l18l��4���҂����\�}u%Nyg�cG�4��պqݧ���;Ԩ�@���VkPm�um���j�<��qO̾yY�w��/�vY�X|�^�%[.Xg5��<֐9A��lDM����	�o���n$t���U�*��Gy�+��8�#�::zB1�҂X�l&[��G�z��4�ė2��$Zf�T�����Y���l��C��d+�R��lE&�U���$�1�IEf���9[ޘ-M[	�K^ӖC�AԼ�ɖܞ �2�-S[	�K��_a}����ϟ�Ǳ�7?��»_>�n��iz�k�����^p7��I�p����,%�����t�p����~���_����������7��?d��s���Cվ#��"a�� �y�7xٔV�0ͻ�d��,����d+D[�k��L>5#a}_< `�A��bV���=4����h�+��A�Qh����
[�J㔁���҂�m���jHX	�VD]5��)8cX[�	+ �(���|0>��Ԗ�|@��n�e�3Wb�]�[�DcmiAtH��#� ��1,��nlZ�1^���A��;J�Yo9cX��"Wb�y�	b��h%��R��+3��Ĉd+A��A'�L���	K�Q�
H�s%fc�� .��1�WMJ��X[,h�l$�dK�C��Ad��Ģޢ$�(�d�1��;��LX�+��1�`��jX�"��B�DX�#%=S��K$Xʖ#�8ɷ��-[HX�"}+d���T$��+��̕�m�:��d����X�K��]? $,���-qsŖ3���%w�H�V�Lme$��b�5շ�A,LX�v��b%N�4�.�l�+�ua��V1�֘�9le�J,�+Q5�@bυz���*�ēw���
,��bK\2���H>y[�4XrS�7���!<,9;�e&,&[�[̜�vJ��RpH����ݵ��|��#~
,9 7�x����La�AtLXD�����L���
S[�" 	�N#��!D�&��AP��,��c��y������\!������cJ^�V���VV��@,�A�pyJ�I�v%*�:�2P�l�A��eCf�M[�MJXcA�����H�:V�Ֆ&yy�Ė<�	b+ڲ����8�mY��ؒ��@���`D��6	��d�R��n�-u%B�X�A,L;�p�ʄ�la�I�3}K^2�j		�3%/�؀�jH�/r��\GO��`e	�RA�b˖�fb�<�uV�7������>>��}xw������{)_p<���[p����J��QE���K��0D9���t�QUM��Q���a���+ �[X��V�̜��V^]��0�J�%ܿ}���<2��N?6aX���c(��i��K(Qت)3aUSXZ�Q,,9A1B�
H�RBLߒ�x@����U�l�Tek�[��e� :�-[ɫ9��V�uy��`������	���
�����)[ZE������-[�������m}K�U��bD�Ֆ�T[�V_��I��6��l6W|6D��CJ^��&�"sb�R��&v�Q�*��.@�rHX℘,� ��LX�+Q�%�'aQ*�l%����5X�]��y�Ɇ+ز��,`Qα5q��D�)�
+ �mB]�Lߒ3���=5���Q+ȨE&[K���}�!�*3��F%>�Ɂ��,�,�8����1,�-9��x�HaK�^!1E$�����LX�	+ aU�J4fK[��Df�)LmŌ�%�51� d��,��7h����A��!�-gK���A[Xr_�D�V�5��#=�I2jN�g�7�Q��m]�e,ym%����<}�w�e,y4�������⊲K�@$�*L���s,y�+2�%���`1�%^�"��� c�+9Q��KbKK9ly��⊲�!a���s���V���H�G$��c�՘l-$��A	K}�I�|B�K^�e,������W���d
���r�K�U��Bxv��8�"�x����œ0(X�0��R��%�KL��l��$X�x%j���U��8��[	K�	A�۲�Uɖ�E�-�,Oc�z�'X�tP��� ,g����O��i�+,���P�W�ƖgJ��[-2aU"�蘰N�+l%2�Ս]^�4��f5�̯�c`�[���А�b0N�Zh��z��N��-�A %ҷBHX��VD1d�:VE�V����1��N�,X�a%�ma�}�;q�%b`5y�+��R��b���<Y�Lm�W<@��Ma�nDU�	�� � f$�
��,ȁ��Axf���.?�[�T�d�C%�����-ܽm����o',��%XZ&��'��� �jKe+#aE[Xj��2�i� z�9���K�p���ۇ��x���w:�؂A�&Q�������O�?���c5n~�?>.hy��ǻ���ǯ|��z�e�-��T<s�u&,��s:���Qv���
[r��V�H�N7���(�ik���o�.|}�\�:�ư4��H���.���f�2�	+�Ӣ�/:a�a�:�.֙�AX�X�#aɳ��YN)1��H�"R��-�8� 4��qr[��J^Ֆ�A�+�#٪L�o߱��N�t������������o޿y�;����_>>�i~���[���QD    �.V$�ʴ�b˖�rڂ�+g'O�e���#����dJ+Wa`MΖ--�ѯ�i��UH"�T�QЫ��گ*ǆ�Uw�Yg�O r,鶴����*3���J,H���JTٲM>c���
���8<��?�y����/;�o�,e�c�yY�({�����*,G��]Y�_JR�����Ȉ�@�#[[&+�v�²��{H��5rΘ����엲sg²eKb�HX��T���-,� ����(�:�MfPS��#��	˖�� R��rdJ^>��U�iUX�	�6'��g&��gXdaC�MaiA�li�Jf1 a�WOAA�P�3��VE��C���\��f��l����-&[�6U�A즰T�bD�M>�j��zZA ]>W�>Qm1��k�J���nk��JdJ�#ay��`&�%7	�ÖG�J	�t&,��VubHY1._��k�ӷ����j��j�l�ALDXE6� my([	��Q��d��e˖��A,r�b+,|S�wh���� T����T��&�
bL� hh�[j�	H��3ՖZ�xb�cJ~پR�X�N+R[ID����&A����f
K�|����%�A��E@R�l%�d�-�S4�ĄMa�+���U�<��d�[j;V�Lm�um]���¦c�j2� Xrbc K��<�O����S�	*�Jb�Hm�`�Um�Quy/aQ��+1y��=2'��d���$XL�G�o-����c���91#�y��T���h�DI[��� TX�����[�Q�U
���aKbfHX�V��{���%�},q�����题4���>N����� �x=Â-�N�8j���|[ՖAу��TX�րA\u+Jˉ�+qL[����1��l�$��ge�d%�&�)�@�!�	�S2�~��c�[��+���і-Vb��HX�Ę���ڪ��R�t�&'�C5�T�����Vf�#٪����[�V+W���S,cڢ�:�@�XM��bq������%},�?����VF�o����lU[���L�Lm��Ǒ`�m�k�rL�"���ĩ;o�&V��-9��*Vu�A�^�'>��b�3�bD`Q�t1�;�#�Z�D����+ �J�[���jAd&����*s%�k���u;�	Q�l��Ȗϓy�o((lu(,��ө�9�����޺=��x��苪��.�(>�TO�_s������}����q��Ԝ�F_�p"�/IE,�6*`NO( �X0�i�V3�L�7LZN�X�����mmYuB��O�d�h�j�ǖ���u��B��Vc�Z�&Z�]*3��+�4�I�)$f���P������e�J��Vꪔ��-�Vj}����o��'ɖ��S�A�&-��NH�LY����u�\u�$'z�%w�k
5 Y_!�Mڷ��pae�Jj7���MN0�*��렮��6,%we�:
$��$?��2�E�:��`����B�IS���"��:��
�X�� l�|P��SG�(fH���)�9�/OZ�yF';R�̤�l���&�m�zouͫij�"騂�l^�� @Ƕ_�R(R�5qC��,*h��(&��L��e�g�yԜ�P�hk[�V�Sv-�qd��NZXҍ���-⤀).�.,-`5!a�A{�Vf�����|Hq���9��i/0���7}^&YhF�r��!����Rʌþh.\��v�{���I%W",!{��,8R��,m�<�˝������� ��4�-��J �rn�QeG9aG:avDgQ@��#U�4���J#1I�)$0�T{%RߗQ�
Մ�&ϱ��zo����p�����P�!�	$#��NExȤY�G�� e�Bm��\0O6xy'�}���m-��
����:��Hu�P���Z��v���TR�I�NZ��T/ԡ"�H��2V$���$0�v�x�ز�@�yr&�ƹ��$z����0eRBͤ�n�|8i���+I�u5tS��ȕ�nyR��Q��]��f)L�!�⼞��&���4��$f2hxQ���f&�і�<󪀙�9x_d��0UhI$Ƀ�:�e�9��.�`H3r�oF���$0�fHaJ��]QK{�tp��yi�Fc��}A��@J��b�i`���/3.�J��`�G�I¢�Q}٢2V���h�޳�*cOҌ'Y���	\UOG�;��@UGM�|�H+,��'�&9)¤� I9X���׍Ъ�t{���ʾE�eGɋ'��YkdTO2�e�Y�5�D��֠UO$qT,2���?��4�Ṇe9�z�Vf�@�����Gu	$�l1�S��g�*5��^2il����iPԄ�"�����ay���|�߾y�pS�y��N?6�'���s�V=��X�E�R5)Nٶ��G�;*��
�@:I몘�QK,Ҁb)��HK:�KG�D�m�9y�The�X���T��u���M���3׿7�EH�oX�Re<��]����b17�n��}�`⅖M
�I�I���z����d[�|��z.k-���Mr@�,�r�I����Iq����8P�*��L�H���Q`���%{$��Vu�~�1�{ ���ԑ�a�I�}Տ�y*S8�i�K+��B�[]ڄb�j�h�Ո�N�l�RoX:)g8Ҙ,2'�ޢ1S��-Gj�M��w�_}�:q��f�"L�+�*�d1���^M�;)����p��U-�10��y��5��u�Z=�b�琜���{!m�g��K'm�5fsSH3���\/6z��u�b�B-��M��ȇ ��;&�9�j�Ҙ#^GJ^Դ�D��z��F��O�:��f�4�u�����/��1Z���UPۓޢ�Q)��x�qk]���̅[��DMB�*��Q&<	T
��Tf�L�aU4�8�Dځ�h9/��`�`y���8nQ9G�C{�>��@O�P��;ǆ��IG��[�{^s�$�������*�}��K�+&���ˠ=��,6�/XO׼�>6��X���79K�:���>�j��9X�����ub:+�R��![�d��ϟ~����o�8j#��t8|\l��������ϗ�~��QG0ѷ�&�� ��L3�LX�#a�������wo��=�z:Ҥ�\a��T�1[�4�t��.�%䡳�I�oL�$F��4q�k���&Y��S� 0��6T�@`^0�����&v���'��U��=3�9{f�#���P�!�+�8�3S۾�jt�L��E]��)Y(X�E*W��XN�f��W;)a�}��GU?���Z-��̐�Q��9���M��m���1��n���c3RI������"����T�4���z�}S���'El��p�l�fUU���d1gQ�!�����/�~�H��RW��R�D́�J�i��mPYO]5P�]�XK�Yb�4O�(�B�4�]s�E^@�F���7Gb�5S/�����w>v�Zc��H��HJX���;�� X�dR�Q'�H�N ��E��JI#�̜���k#է� k/G:b��i aeu���+�CGA�m�4`����"��ˠ�̓��Nʚ���j�q� ��t�KR�4#�뽌���f��8m�5�.���@�m�v�� �b�6a��@��W�o��9<�_�X��>�������kS����;�~�|�z�	�xG������K��m5R��\���s�rZe��)Y�v�"w���^�ei��U���h���e��?1樟���fT>g��4r'Ps:6M s�c3��0��X�+��򠀥}օ3aF[�&��0S뚔w��T0��0!��t�� &u�T
L3ɔ��d�|��'�j=2a�~$%,�oº�Fv�(�H�I�������5PJ���to��i`L�͍I���f.uch2'�'g,MH$'t�6���5f�i<���c�9���ʿ*�!}c50�5`�ŀպa�.�ʵ�L�h̀����Z�&�V�c&��;�� ��DT-r���:L�!t�&�\��zpk����I
N�}��>b���.�N�Ԇ��l�3qMˤr"쫞K+-�FR��^-k�9Z�H��H�^���ԗ�F�`Z��̓6�2���;�NE5R��H��/�Y���Ǚ���6^~�pHcf�X?    �lsD��(G����5G�c�HQ���p�F�v�G��/�kR`�@��h�i	�9�8�dőuij�C�!Uב���In �k���:b�=ɁH�݁��~��j�_��T6�tt��ab��t���Y���zD�%�I��J@X�� *��1���u��gX����#,ǄUlai9�8�h9�h���ط4;e�|1��;� 2Ve��d˖�[���ATcX���<�`9$,��E1/%oKY��Dy����V��O������n~�?>.� ��������ϗ3�GO/�oa�#uT�m�X�3u���<F�V6�K�D���Ղ����L����ӌ��P����q=������uy�J��J��Y�:D��R`ɍ���v��6�3�m��F"S��8H3� ��1[
���#J���G�C?B0�S#`�wIA��1,ͣ����V6N4
[��\ư�*�k�P�<�eA�19'���JIB2��8��J�Vp��7�w�3U��8���3R[���Ԗg10�h̖���M���V��}XJ�%Ă9.�� ��Aڒs�ꐰ�+Q�����Ė<}���-N���`1�43�O��j���j�+�<�(�/+F[Q������$,ʶj������A�G�A�̕��<<C����|@+1A�X�lef�Wp�����&HX�����tyo�-� ��zY�ί��$�	�������B}��c����k.0X�V��a�6�UX=��x����я������ۛoG��p<�^9���s��t��Ҹ�!R��"�>����������~)���n��߿}��r���x�q6j
��{DGS4ViHX�4X��i���y���f��_�����z�ox���YT��^�O�5�Ө�+��g<G[�aQ���a����M��3�)`+��}��v�ȩ�|]��l����d+!�*ٔ-VaћQ��ڪ"�o�kl�J��&�-����:��e�jPm��:S[�[��� N�#��1&b���,>P��cKc�ٲ��:���
��`�uzÞ+��҂x:��%��.�J>3�
�l�ɇ�[�ַ�V"��~��òS�L>��|��u������%��0����`�87j�DW%J��M��W�f��}=��ﲰ`�,ʾr��<�-Y#`�4>j
�!ay�JLL��_�5�l��KOK��QӒ���5�����'73�
VfD��H�VA�*���K`� �̄Ո����Ml���މ��C���B[�9[r�O��s��4�(L��Bc��Е��<Ʒ�*�	.����%,��R�[�ύh�
���Q������օ���aͿ���|�Ć���+Q�ԑ`E&��4��� Op�T�oa�#r�U"��-,%���������̈f�VaM9ۗr���9VԪ1,���d�I��Il�z��Q��u�Ԓ]a
ɸ���(A�5J�_r�W�uQ�������;spHXr� �:S[ir�
�7��� 4m�+i뢙P�'[IA�&���y�΁%�4X�:�"Su�Oε"����n̖&���%/��`uc�2,Yo�|��=e[m֎�,M�L7hL7����U��(��x�;X�"(�����j�|��؊� &���V��֐A``�r�1"!%��B�|Gj+u[�m�ˡ��),��֘�2V/Ʒ�1[
,1c#�Aa�5X;\�4����F��2�u�:�4���z����S[⬦,�Y������AV4����;�(X�	+#a�Um]��zU<�D��C#�Ma�Ad�%��yΫ��9	�R!W9�`K�U�Gj�&������J|���o��|L�n���Q��t��sj5�y�O+����b��(��&��`���M`)ڒ[��y���
Al�#a\����*�k��H�3�蘾�\�me[miAD�Vm�T-���l-[	K�pB� a-ky��.[�8�Zu
e����S�����i�~V�
��p��ݻ#Q_��'L���VO��I$0��M=e]=�w�x�`��M}���h���Gn-��'�0�iy�E�g��Q�Y7���j߄u��8R�L�(���
�`RXh�	%�}ˉ-������0��RFe'���W��q�Tc��^_�N�S'�Y���4>�h�$0����[.M�z"��rM4&c���&��	m9�2C$�	����چ4EO���Ă50��Z���We�i�˓fz=G�]��]�,���&���lգ����:`�%�Dv��>�;�&����O�$��$f:���/3*X|��>Kx������n�Q�z��Xw�GdHT��o~߳��&N=�\`�U%yO ���,K �zʾ����=�������6h��CL��Q��dL���^h2�4�R_?���>&E����泌&�v��B�Oc�� HRA
I>@i/$Ұ,0W~5�/��H���tǁ��ĵ�*��{�����;�BV�#���[#i]A'�Z%u��<�Y�&���N��zLL������>6h������c�y�|�z>@+6LB��!�F��#�Ul�־8i�9)뤆كNܽ83J	Xw���mv5���55����I�š��/j�ԏL1,ޘk��4��D��cT��(^�O�畺|ŧ��H�-�h��FTN&ό�,�f���5��;s0�Bs0���X�I[ۍd�˵�IX����]%��Ef�Beu�z���ʾ��І)`����fq�F>�g�#h�Heb�(�UfPe"���'mXTf*G$�D0cE�u���`.,��h.�&#Wy�7�_�����>��b������z�m)��cR��}����8[��Ǩ9k{����~i{��>��������}���;�~�~S��b�9Uo&��3Ɂ"t�a�LՀ���DM"�}	�(H�����fˌw�I(�5���9:�7�##�~N����
�3�GjP�Y_X�Mǀ9���f40򘰹���멚�(�����r�k�;J�a��ַ[X��'C�!�i��L�i��}t>R���:j��ڟ�8�,n�8۾�\���L��d��S�ٷ���	r��ќP-i55���s��F� s�E�~�Dv�i�z8^|��)`��7�����P�v������D0�r�$0��2�<f������fN����9y@��|��L�7L�)9.�u��(n��|4�iaERjh���-�Q��"3`�����zHٳ����r.\W��V�V��h`Ʋd�~X&��0T�L�q�eŅM^!�̾n9�z$%�D
X������
3a5R!Q%2iH�3Y��j�X/r濽{TϾ�ׅs�F*K�G:a�0��-�@%چNmtH����:�F���I���������^��H#�@�S %���`��E��H$;����Nj��%.�����&H�!��w"�����@SH�Q&-�LZMբ U���#����CۋӘ��@Wp��/.#ۃW��ôs^α�H\��,�ha�5{0�Fd)�fP`��̨��s��&V�k�v�>����M���(�@�m�j91㥌#��S]�R�K*f��sݢ.���1xm�;T�\�&�K�͜c9&�{�9&����*�}$�z)1��z��y�T�Ѿ�Y����|�=�W��"��$f�}��Y�N/ֹMG\�^@�����Wk�9}��Xת�A[Vޣ&$0����E�+�0=^$��#5��b�.,���+�H�T�b���g
�Jy��Z<R�;P
Z44���ƅ<)�&AR�����6���������^6�t</��H��Dj�=�&\���Ͷ�2�h�y$��m�7vӐ.��0�IQ��c��I`�x��LG1S@`*L	F�^h��4Sa����"��*L�
WQ�k����}��G`��-
)��O;���R��y(���µ��(y*8�|^�r��@����R�$�i���@�?_IEN%yqG��$f)1�}S�ENE���M5��"G��ZT���3
,yq?Zs$�����7Z�Q:    y�ٜy"מ�(`�G��$O0���Z��dF[M$�(�Ȕ�I�M���L��8����)Wma�T��I�#���+�ČC�qe�q�'��IE�wH�8T�4.w4X��Pm*s�t{��Z�Hj�*_��ј1I�3&K[K�$0��"I��4�D^��Y�#RQI�;���/�rݓ8��Ǔ������+̺r$��;���EV@��M�Y[�$f)YT�Ha�7�����h���dM�<�j������&3D�@�}�\��L�QV�L��q���q����hK$0���I`H�&�u�U�]uJ8T�p؊&IL[���̆���f]�����E����Y�H�s!��NS22K����b筙�Z&%��H�7j�QA`
��ᨧ�8
H�v�L2�N�/RKߠ-=i:�Is;�t!o��h�&UǐA['10�o2�ZTL��Τ��$��b�$�o�|���F�5�s&�R8j`HZ�Zs��r�]1�ο~n�Vg��:"���Ϫ����m��k����`8�&��׏8^�@��H� ��#�b_#i��Y��ֻh���Ϩ�����&�H`
���&`�z{LO�H��ݤ�?�(�{�y�	�(���h���My����ܗ3�H��p8���ƖP[��$�.��Ķ�]�t}l6�Ʃ��{����X,'LAZN�$)[�Q�8���+��a"U�"M��!	8Y$5e�J����:���M��|UI�7�pTI��9��9��T����FZW����kfw��+_��^���g�r_�|���G����W&T�VP��Hc��I����
	L"����-�1��;I=T�N|7R�I�d��I��L
S"�� N�w���ɋ�B.�)| m�Ķ��\x��ƧU��riæ0ad۽65t$'L��^�ͣ��4U��c�����:[�VyE�m �F:�7p�fb���,�l�CI����H�wERB���&�&���H�)�Z��Haj���I`Ҿ���o�$�Y�d��-��-�I=�����k�&�3�G����}��?���4S`���+,��@�y�a5Xg�3�o�U%,��w�yۈ-E[�a=_�ci�#�z�*`�:���
b0fK�3��ڊ��̂U�q:���\�*yfNH�?,`��D;eR�HX�0X�liڪ	��?,�ä� F��c�"ي��W}+1a�J^]���R%�H>�k�G��jk� 0lU��Vhuj[�lA%_���P;��l]q+Ja+�i�w���CG�r����\���O�����WR����p�x���������#�w�|�;�>����j��r���/w7�m�F����%1���!#ay�e��;HX�L��RA�*Do�[j�v��Y��b��漜o|��y���7*	�jR�U���*��o�a;|8|xw�������������w<�ؤh����r�ۮ5���*����4���w� � ������<��S�ٲ,�i�`]�4�+"ْ�����er���W`�΄�S[P�ܕ����,��kc��J^���aͿᔻGj�C�ĄUl%��D�
B��+R�5#�
�2�j���Ȅ5�|�;�J4Ή
[�t���OlJd��	+v&,gK�|1���%�'�ؒ��쑰T��1�|0D5^���dKC��ư� V$[K��|G�Ȗq��i�8�ZNd6r�'�?Tn��塚/j�����Myz
��w:�����@�4U�[�f��Fj���Ty=����&�1&[������#h��L�2V���W�tǌ�-;��ªw^���-5���X4���,PGZ�v;Wt�:[��2��b�˿4&�n\�j�V]��y$j��*O߀`�טQ�:�1Y�RҊ\vX�3%�T�	��DVbj+G$�Ȕ|e�Ve�%o�s`5�|��|o'4ٷ�`�h
K�x��Ė<BEb�"ْ;  X����VA�%�Ăa���#�N_( �%'��4��2V���1^֫x=H1̘R!y$�o�����g�4X�u���%��[|�O��ڢ~�#a�s�ߑT`ɶ$yo�[��*R[��N��.|�w��x9���:����a���_L��@(�-��ٚ��7��d'M�����ՙ+�{�J�Pm%d���^F[�UPG*� ��bf�|ejk�ޚ�Ua��mS��f?:y
	�)�#���%�T��9�`���ŧ���*�}c�~۟��Y����f�?�]�
�cQ�i�]A
��DX�T ��R��L���u�DQAt=ay��G`�f+yU[Pߪ��T�X�E1�m����l5����fJ��)�T$�搰jD�*��R"x�d+3a%ە�1IX��,���ַ�Tݙv��lASuB�Vt��h���^���T�AT��c!o=�ؒ/�c�:V��6Rl�@-'FfQ�}b4�Z��6�juj\o�=�q�h�0g�K��-�$aA���X��lE'�
+l�}�J��VDj+kK�:2�	j��V[�U�+Q��H��� f$[9�����ط4�G$�`��ڊ���w	=����2���U�-W����� J�Al@��˶��UX������֌O!E���D�A�*&�Ձ�Q��J�[b
,��:-s`��(l9��,����U3��T�*���x���@�1��-,�-�d�2�O��-5���}�� z�`�,��,Ju��3w� &��ě�$X��V�eK[��#���`�'I��|�����<'U3Wb�Mժ�l�(�ؑ���7�M�[�M��؍Ŗ3�{��bJ^�����=s�l��d�Cad�1[�A��A4N>�Jd&��L>Q>܆�}-Q��
�	D&[��7�|Ń+��R|�Q�%[��9����4����\���N�
�8UkA4�-�N�S�Df��2��ڪL�I>ӟ�1�#���ay�����o�>ܔ�Ǵ�ӏMn�,��(�Br�I�s>�d뼾�h
9Ǐ���-,%�b~�V�Pm�5���(+D�����d�JDD�Ȝ{FjK����eġ
���$�4IlE[�PO
3:�i�b
K=��<6Y���O�����<ӷ"�*�-�<�m�T��A��γղ),���dK����m���*� ����ma�+q!y���:�k�;iڂ�3��Ȕ��eK��0����F۸3�4klQ�1����+��*�2f��+�Oi�`U([	K<wL�uz7 �X[�A�o�rn¿�-��~ʙ����U��rթE-���DX�#ae�����KX�?�������q��p�����qq���/�����������rwS�F��2/���'�8-tN�n����linlaiS#�1́NM�V����Z�T�2�-���<"
��/'�Z�����koHz���,,��p�#ȇ^����1X�2s%����VLXP�
Vc�򦰴�Xm�RaٮD��JTaE[Xژȸ��`!�Y<�a��ϏhJ�e�d�k���Y�gD�x�a���ߏ����c��?��ϸ�@���Կ~����A���k��b�Hq��d+�u��0.�k��!��&y㤨�)�-y�F�VtB�aE�a��9CٺV�V@J�8�b�-g k����p��l^�-��V6W�*7�$�ZT�h�Z�l�j\��V���VW�5sGJ�d�i3ɁĜ��u�(n9�n@�:,��p��c��7���a�M�Y\�<._��䅹i�V}�:��/�f�
[~�nqy����5��1]�GL��4�V}���F�+\���t��+��9f5Ӭ�?M��$>�I�@KK�����H�
���#���3�U-���/pq��"�t�kU�t�`��8�q��뀱[iو�n̖�M[�52���Q�Q?�n��2���=�Z����~p�#�~ڳ��댸Ο9����B�����#1��ȟ�~}0���]<�v��73v����ASy��78���VΠ��Z�.�C{X8�u�!�K�J۟��ӥ�5]�����xV�
�:��-��_^o!��U�����zu�G�4Ƶ���ϫW����B�ޝ˼��ը�CF*��!6\k}j-y"    ]�V��_�������Q̫�p�(����]LLZ.U�ʾ�����q�O�j^DS�x����Vg$�� �#������(��D�Ɗ��O���
S]�4��6Q��7@�O\�[`Q	��,�8��]#a�(�-��D����D��04�KS�t"j��������p��iY�P����-C��{ ��1zCmP����j[�c'}Խ:���]�s#a\]�{���ȱ>�ᚸy�a��L=pt�����W1r�g2�rE��H{�1��ޖ0��q����[a�.�#��Ÿ�+l��j}�HH�z�H��߼�x������>*�8�:R[Ԛd�MJ�˺��r�u9��b��	�Z�����Q}�qm0�����Oõ./y�n��VK�Tla��{�H�&���N��0uE&,o ��`�U,�k�"r)f��8@W��k�J��oʢ��E9��.g��(z����`b�k9׺>���_> {����'�-Wk{b��3}tS�j�
���p]'�g��b��ZҲ�EW�n��Z�y�:���73��*�+Ϥ��9��Ҭ.JL�:��ڠ� ��6]��b�<�lE��\Y���Vd�r�F4�m5��%�=bEm)&��8�Ht�ڡ���p����>N�kñr/&�(Q�0���z�F�+]+�>��y�_�ˠ�r�x5*�<�DOݐ�K��5���R�0�A�&�-W��q5��V���)*��,%|7�׀�Odk��˵����u�wm�b��F��]�[�~��7T��#���������k�4u�����F�F��k$�y5��}�yKEh<��*������c�!�l��٪ݺ	R��Ju����s�2 ��Tˀ!����O�]u��I�ͣkK�,�[���^WםQ?q#cK;��7qoxˤY��>���b�u�Ed�FJ����<�Z|�����m͋�X��EX�s_��یj,�`GpM,$^}~�c^e"�aA��� �翀��7R�k�0qi�1�jq$O��Q\�#ԉa܂Kn��p�2O_[\"E(_	ʗ3�kݾr�k�s�-u$�`k@\3s㆔�,�5��s���'��S'�8�ύ�
4���Kf�ǼZ^���@kam�ڲ[��>iV�X)o��0�� UWa�2y�Gm?Ll�7�yb�� +�v;cF�'�5��ޔ�<\��Q�_}3�]��,��#tQ����yYd���.U��kC
�9��2�Xҿ�3�ˢv^�����h�У�Ս�.��9���N�����Dqma+3a1�r�F���/�k���4o!�Cm�p���ҹ�|���~�� nY��r��pƸ�w�?�޽��#T�#����g.�MtY,�O���O-H�D����-�34����r=���}���(�(��7�Ml6��71��e�53F���;v���g��D���b`#��đĆ0v�I��'��ԕ��su���)��w%����$�|����y�󸺿9<�_��������û������^4�O����=�<SO���:����,���dv�`m��W��k�Կ�t��ϒ$7�Q$�õ��D�ܲ��̅7nLj�uj�YY�qI[�`�Y�d�N^�6�ME���t��A��:�<3lB��Xi"�-N�-p�D7㺺���(����Z����1����m���@�w�:4HX/>: ��qO�vb����'�L�X�2����N=���cˣ��?�u���ٱ�[�ͫPΓ�y���S덩��JS���tm8���������c����71;4ej��V[��?������O�?���_���w?ܾ��O���?�y�����'�������	��o�sú�S��}��vC.�VoS�yk�������hg}VC��#��()���`�K;��Wǵ��J�׀�<R]b���Y��.Y�5 .q��F���외�8��2��^�)�� �zy%ը�'�z}1�yS�h�[p��5Φ8�8�g����Є������(�%�VV$[yb%�� B$l�,�1ԩ�qe���)}�~Iv��H�1Ѱ6d�4��ߢ�lQ�8֢��|C��#aͬ�7l�d��ѵE\����_�ԝ�D(y9N���y`6�??ѡ6u�C��5�ѵ��N�Zu��5���-���]���2��y>
�����-�Ru�"�A��B�#�Τk��}S�91�l�б������֬<&V��,��g��3��'/���;\#kp��ye�]�����d딨U�qm&���{��i����-"�P(�d|�nh��⫛����b`�na����Z;ptl{��&Y|�'z�''�[���>�cE�Ƶ%����4\����DX�?:�����ؒg�LD�y�D\[�^va���%����8����GXϷ��=�O����Eo�w���?�_/��㿙�����~kP5�︁H)��eP5�Kh�tS,a�����X���fo�i�U���*?��8B�Ԛae#zb��O��}m�r�E�5`��߉N��Y��km�3�Mk0M,��Ij$�
S�SEP!�.y��库Z�ԅ7�&S�
Љh�X�oiQ-:��f�b��9��;�*���T�\�����_���w�朣[Dk ��^���X$�\�ߺE�NG��?�xA9}Ib���>z��hKc+0a噰V��`Vs鋴�$�	D[PV[�Xmt�U)٤�]���>Ndk�41�m�Ŵ�`kd)NĵŹ��u:p��<�u�e~��>�����|�4O �	���[J�<��7��tof�F�d�5?��2C8��aa<�O�2��H������߲[Ɣ2ijC3������g����WgjgcaS�C=/�� J��Z�.;�_N�!�ڒm��8n����x�j�5)��֠�1���>�o���qO�MѺ���>m�FљFQ)���(N��?������� ��?�����}QI#e���Ty�an�U&�q_=`�cZX�@ޫƫQq�NU=S]}�ӍLu����~=��Q͍֫Q	c�U�X�w�{>[�k��oR}Y��߁|}M���¼R�m�z��i�~��
s�w��K\���'��[�u��沋�Zup֓mmld1�P=s�S�PW��U��$\���q��IZ��rU��.��5w(���%+����rR;�~l᦮���'��^�C_���5��iP�hj�&�j�X�p]��=�U^f�<1o1�����bDi5yUp�5���(|�6T!4���U5Ty]^�ϱGp%��q���������v}�xc"][����qк���ZbS�5и��5xhI��WX1\�^H|b~�$��`�a�QmɃS��bybQ����������Ц��Qǩ�VF�a^�۶'��u�O��4�V�rh�[L�F��vĈ�ܪ�,�ՙ�˛�ٯf�(+�t���b�2ߤ�[��^w_���5A�2��������i������Eת�����ͣ�*_�qa�7�M]d�r��!N���'�#��(.�'�7�Z����n�Y�Z�b�Ŋ�be���W+�vJ��&����G,�1�ZDq��UC���ϴ�������E]���6S]+j��w6<���G1�ڪ3���>:�y����F`���eY��e��ju���am�NSC�U&�k]Lu�+��Z�A}�9y��v>O˱�y��������KH^�#��2�87��8�77�e���T]Z��]�$Ό�������讄��;�+��zM5e9Ƀ�eg2^����p�.v����@,R\�am��/�C9��d�2��XS�����f���^�+0���f����lۗ�(Q��Dq�.y���t�'����r�y�P�Ey������Z��W�Au��,���kSq\�t�ĤK��ˡ+uk��y��!���S��tq]������-QP�WSѫ�zD"ҕ��bT�jU��.9">k�_�TM�e�:��"�$n|��W�f�[���j���LljV��M��m�]�9B�ł7�Y�V�E��k� -J
�-�t$�~j�&�� ��C��7.��p[j��kn���E�;b��Ig��%���%/婠,*�ي�Z�,jb�T�Yt�#a�Gpٶ��'Vɫ����M熷9F+���bZ�."9�j�"=�o �  ��`EX���!�õ�9�E5�"Y^�0P�
+!a��D�bTv ��"�4��"4�j���X�	�B�Q��k�2�V7��Z��GL̋[<­�~ΎV����+��|;�aUH)N9P{Fj�L\�"��5��7���@�9�ܲT^޺uVp�'���h �rB(��S���6��r��ݤ�i�����ր��H�#�⃩�TX�y��	�[�:��-	([���f.�-��j�`������ \��2�r�<����byϷU�qU��։q�"��n�%iO4�ձ_��S��r4��,ؚ�h���0���[#ve����FQuQ��g���H:#��ĩ�uE��k�z���t�u��xJ5�?� �rb�D�Q��0���������F�	�      w   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      y  