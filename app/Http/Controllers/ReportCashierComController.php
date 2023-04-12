<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Product;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Department;
use App\Models\ProductType;
use App\Models\ProductBrand;
use App\Models\ProductCategory;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ReportCommisionCashierExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Settings;


class ReportCashierComController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="productsbrand",$id=1;

    public function __construct()
    {
        $this->act_permission = DB::select("
            select sum(coalesce(allow_create,0)) as allow_create,sum(coalesce(allow_delete,0)) as allow_delete,sum(coalesce(allow_show,0)) as allow_show,sum(coalesce(allow_edit,0)) as allow_edit from (
                select count(1) as allow_create,0 as allow_delete,0 as allow_show,0 as allow_edit from permissions p join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.create' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,count(1) as allow_delete,0 as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.delete' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,0 as allow_delete,count(1) as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.show' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,0 as allow_delete,0 as allow_show,count(1) as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.edit' and p.name like '".$this->module.".%'
            ) a
        ");
        
        
    }

    public function index(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $report_data = DB::select("
                select * from (    
                    select  'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by  
                    where pc.created_by_fee > 0
                    union 
                    select  'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                    where pc.created_by_fee <= 0 and pc.referral_fee > 0       
                ) a where dated>=now()-interval'7 days' order by a.name,dated 
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $brands = ProductBrand::orderBy('product_brand.remark', 'ASC')
                    ->paginate(10,['product_brand.id','product_brand.remark']);
        return view('pages.reports.commision_cashier',['company' => Company::get()->first()] ,compact('brands','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $branchx = $request->filter_branch_id_in;

        if($request->export=='Export Excel'){
            $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id);
            return Excel::download(new ReportCommisionCashierExport($strencode), 'report_commision_cashier_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->export=='Export Sum'){

            $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;
            $report_data = DB::select("

            
                        select a.branch_name,a.com_type,a.dated,a.qtyinv,a.work_year,'0' as name,a.commisions,a.point_qty,coalesce(pc2.point_value,0)  as point_value,a.commisions+coalesce(pc2.point_value,0) as total from (
                            select b.remark as branch_name,'work_commision' as com_type,im.dated,count(ps.id) as qtyinv,u.work_year,u.name,sum(pc.values*id.qty) as commisions,sum(coalesce(pp.point,0)*id.qty) as point_qty
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no and (id.referral_by is null)
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id 
                            join branch b on b.id = c.branch_id
                            join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join (
                                select r.id,r.name,r.job_id,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year 
                                from users r
                                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
                            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
                            where pc.values > 0 and im.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."'  and c.branch_id::character varying like  '".$filter_branch_id."'
                            group by  b.remark,im.dated,u.work_year,u.name
                            union all                                  
                            select  b.remark as branch_name,'referral' as com_type,im.dated,count(ps.id) as qtyinv,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,
                            sum(case when pc.referral_fee<=0 then pc.assigned_to_fee * id.qty else pc.referral_fee * id.qty end) as commisions,
                            0 as point_qty
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no 
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id 
                            join branch b on b.id = c.branch_id
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.job_id = 2  and u.id = id.referral_by  
                            where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0  and im.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."'  and c.branch_id::character varying like  '".$filter_branch_id."'
                            group by  b.remark,im.dated,u.join_date,u.name

                        ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty  order by a.branch_name,a.dated,a.name;
                       
            ");

            $report_data_total = DB::select("

                            select '0' as name,dated,'0' as id,0 as total_point,sum(commisions) as total from (
                                select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                                from invoice_master im 
                                join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                                join product_sku ps on ps.id = id.product_id 
                                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                                join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                                where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                                union 
                                select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                                where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                                group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                                union 
                                select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                                from invoice_master im 
                                join invoice_detail id on id.invoice_no = im.invoice_no
                                join product_sku ps on ps.id = id.product_id 
                                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                                join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                                where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                        ) a group by dated
            ");

            $report_data_detail = DB::select("


            select * from (
                    select  ps.type_id,'0' as id,'work_commission' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                    where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                    union 
                    select ps.type_id,'0' as id,'extra_commision' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                    where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                    group by  ps.type_id,b.remark,im.dated,u.work_year,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                    union
                    select  ps.type_id,'0' as id,'referral' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                    where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
            ) a order by dated
                       
            ");

            $report_data_detail_inv = DB::select("


                select distinct right(invoice_no,6) as invoice_no,'0' as name,dated,'0' as id from (
                        select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union
                        select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                        where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                        group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                        union 
                        select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                ) a order by dated

            ");

            $report_data_detail_t = DB::select("

                select distinct '0' as name,dated,'0' as id from (
                        select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union 
                        select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                ) a order by dated
            ");

            $report_data_com_from1 = DB::select("

                        select dated,'0' as id,sum(commisions) as total from (
                            select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                            where pc.created_by_fee > 0 and  im.dated between date_trunc('month', '".$begindate."'::date)::date and '".$enddate."' 
                            union 
                            select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                            where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                            group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                            union 
                            select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                            where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between date_trunc('month', '".$begindate."'::date)::date and '".$enddate."'   
                    ) a group by dated     
            ");
    
           
            $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
    
            $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.reports.cashier_comm_day_print', [
                'data' => $data,
                'report_datas' => $report_data,
                'report_data_total' => $report_data_total,
                'report_data_com_from1' => $report_data_com_from1,
                'report_datas_detail' => $report_data_detail,
                'report_data_detail_invs' => $report_data_detail_inv,
                'report_data_detail_t' => $report_data_detail_t,
                'settings' => Settings::get(),
            ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
            return $pdf->stream('report_daily.pdf');



        }else if($request->export=='ExportSUmBC'){

            $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;
            $report_data = DB::select("

            
                        select a.branch_name,a.com_type,a.dated,a.qtyinv,a.work_year,a.name,a.commisions,a.point_qty,coalesce(pc2.point_value,0)  as point_value,a.commisions+coalesce(pc2.point_value,0) as total from (
                            select b.remark as branch_name,'work_commision' as com_type,im.dated,count(ps.id) as qtyinv,u.work_year,u.name,sum(pc.values*id.qty) as commisions,sum(coalesce(pp.point,0)*id.qty) as point_qty
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no and (id.referral_by is null)
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id 
                            join branch b on b.id = c.branch_id
                            join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join (
                                select r.id,r.name,r.job_id,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year 
                                from users r
                                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
                            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
                            where pc.values > 0 and im.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."'  and c.branch_id::character varying like  '".$filter_branch_id."'
                            group by  b.remark,im.dated,u.work_year,u.name
                            union all                                  
                            select  b.remark as branch_name,'referral' as com_type,im.dated,count(ps.id) as qtyinv,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,
                            sum(case when pc.referral_fee<=0 then pc.assigned_to_fee * id.qty else pc.referral_fee * id.qty end) as commisions,
                            0 as point_qty
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no 
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id 
                            join branch b on b.id = c.branch_id
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.job_id = 2  and u.id = id.referral_by  
                            where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0  and im.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."'  and c.branch_id::character varying like  '".$filter_branch_id."'
                            group by  b.remark,im.dated,u.join_date,u.name

                        ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty  order by a.branch_name,a.dated,a.name;
                       
            ");

            $report_data_total = DB::select("

                            select name,dated,id,0 as total_point,sum(commisions) as total from (
                                select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                                from invoice_master im 
                                join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                                join product_sku ps on ps.id = id.product_id 
                                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                                join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                                where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                                union 
                                select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                                where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                                group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                                union 
                                select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                                from invoice_master im 
                                join invoice_detail id on id.invoice_no = im.invoice_no
                                join product_sku ps on ps.id = id.product_id 
                                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                                join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                                where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                        ) a group by name,dated,id
            ");

            $report_data_detail = DB::select("


            select * from (
                    select  ps.type_id,u.id,'work_commission' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                    where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                    union 
                    select ps.type_id,u.id,'extra_commision' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                    where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                    group by  ps.type_id,u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                    union
                    select  ps.type_id,u.id,'referral' as com_type,im.dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                    where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
            ) a order by dated,a.name
                       
            ");

            $report_data_detail_inv = DB::select("


                select distinct right(invoice_no,6) as invoice_no,name,dated,id from (
                        select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union
                        select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                        where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                        group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                        union 
                        select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                ) a order by dated,a.name

            ");

            $report_data_detail_t = DB::select("

                select distinct name,dated,id from (
                        select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union 
                        select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                ) a order by dated,a.name
            ");

            $report_data_com_from1 = DB::select("

                        select dated,id,sum(commisions) as total from (
                            select  u.id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                            where pc.created_by_fee > 0 and  im.dated between date_trunc('month', '".$begindate."'::date)::date and '".$enddate."' 
                            union 
                            select u.id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                            where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                            group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                            union 
                            select  u.id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                            where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between date_trunc('month', '".$begindate."'::date)::date and '".$enddate."'   
                    ) a group by dated,id     
            ");
    
           
            $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
    
            $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.reports.cashier_comm_day_print', [
                'data' => $data,
                'report_datas' => $report_data,
                'report_data_total' => $report_data_total,
                'report_data_com_from1' => $report_data_com_from1,
                'report_datas_detail' => $report_data_detail,
                'report_data_detail_invs' => $report_data_detail_inv,
                'report_data_detail_t' => $report_data_detail_t,
                'settings' => Settings::get(),
            ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
            return $pdf->stream('report_daily.pdf');



        }else{
            $report_data = DB::select("
                select * from (
                        select  'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by  
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union 
                        select  'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
                ) a order by a.name     
            ");          
            return view('pages.reports.commision_cashier',['company' => Company::get()->first()], compact('report_data','branchs','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new ProductsExport, 'products_'.Carbon::now()->format('YmdHis').'.xlsx');
    }

    /**
     * Show form for creating user
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        return view('pages.productsbrand.create',[
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param ProductBrand $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(ProductBrand $productbrand, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $user = Auth::user();
        $productbrand->create(
            array_merge(
                ['remark' => $request->get('remark') ],
            )
        );
        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Brand created successfully.'));
    }

    /**
     * Show user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        //return $product->id;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id',$product->id)
        ->get(['product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        return view('pages.productsbrand.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(ProductBrand $productbrand) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $brand = ProductBrand::where('product_brand.id',$productbrand->id)
        ->get(['product_brand.id as id','product_brand.remark'])->first();
        return view('pages.productsbrand.edit', [
            'data' => $data,
            'brand' => $brand, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param ProductBrand $productbrand
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(ProductBrand $productbrand, Request $request) 
    {
        $user = Auth::user();
        $productbrand->update(
            array_merge(
                ['remark' => $request->get('remark') ],
            )
        );
        
        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Product updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param ProductBrand $productbrand
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(ProductBrand $productbrand) 
    {
        $productbrand->delete();

        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Brand deleted successfully.'));
    }

    public function getpermissions($role_id){
        $id = $role_id;
        $permissions = Permission::join('role_has_permissions',function ($join)  use ($id) {
            $join->on(function($query) use ($id) {
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=',$id)->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
            });
           })->orderby('permissions.remark')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

           $this->data = [
            'menu' => 
                [
                    [
                        'icon' => 'fa fa-user-gear',
                        'title' => \Lang::get('home.user_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.product_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
		   [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.service_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => \Lang::get('home.transaction'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => \Lang::get('home.reports'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => \Lang::get('home.settings'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ]  
                ]      
        ];

        foreach ($permissions as $key => $menu) {
            if($menu['parent']=='Users'){
                array_push($this->data['menu'][0]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
        }


    }
}