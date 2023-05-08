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
use App\Exports\ReportCommisionTerapistDailyExport;
use App\Exports\SumExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Settings;




class ReportTerapistComDailyController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="report.terapistdaily",$id=1;

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
        // Closure as callback
        
    }

    public function index(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $users_terapist = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);  
        
        $call_proc = DB::select("CALL public.calc_commision_terapist_today();");

        $report_data = DB::select("
                    select a.branch_name,a.com_type,to_char(a.dated,'dd-mm-YYYY') as dated,a.qtyinv,a.work_year,a.name,a.commisions,a.point_qty,coalesce(pc2.point_value,0)  as point_value,a.commisions+coalesce(pc2.point_value,0) as total from (
                        select b.remark as branch_name,'work_commision' as com_type,im.dated,count(ps.id) as qtyinv,u.work_year,u.name,sum(pc.values*id.qty) as commisions,sum(coalesce(pp.point,0)*id.qty) as point_qty
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id 
                        join branch b on b.id = c.branch_id
                        join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                        join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join (
                            select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year 
                            from users r
                            ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
                        left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
                        where pc.values > 0 and im.dated >= now()-interval'7 days'
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
                        join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.job_id = 2  and u.id = id.referral_by  
                        where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0  and im.dated >= now()-interval'7 days'
                        group by  b.remark,im.dated,u.join_date,u.name
                        union all            
                        select b.remark as branch_name,'extra' as com_type,im.dated,count(ps.id) as qtyinv,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,
                        sum(pc.assigned_to_fee * id.qty) commisions,
                        0 as point_qty
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no 
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id 
                        join branch b on b.id = c.branch_id
                        join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.job_id = 2  and u.id = id.assigned_to  
                        where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0 and im.dated >= now()-interval'7 days'
                        group by  b.remark,im.dated,u.join_date,u.name

                ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty  order by a.branch_name,a.dated,a.name;
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $brands = ProductBrand::orderBy('product_brand.remark', 'ASC')
                    ->get(['product_brand.id','product_brand.remark']);
        return view('pages.reports.commision_terapist_summary',['company' => Company::get()->first()], compact('users_terapist','brands','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function calc_commision(){
        $call_proc = DB::select("CALL public.calc_commision_terapist_today();");
        return "Executed at ".date('d-m-Y H:i:s');
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $users_terapist = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);

        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        
        
        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $terapist = $request->filter_terapist_in;
        $branchx = $request->filter_branch_id_in;

        if($request->export=='Export Excel'){
            $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id.'#'.$terapist);
            return Excel::download(new ReportCommisionTerapistDailyExport($strencode), 'report_commision_terapist_sum_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->export=='Export Sum Lite'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $call_proc = DB::select("CALL public.calc_commision_terapist();");
           
            $report_data_detail_t = DB::select("
                    select a.branch_name,a.id,a.dated,a.name,a.invoice_no,a.abbr,coalesce(pc2.point_value,0) as total_point,(a.commisions+coalesce(pc2.point_value,0)) as total,commisions_extra,total_abbr,total_commisions,total_point_qty,product_abbr,
                    product_price,product_base_commision,product_qty,product_commisions
                    from (
                        select a.branch_name,a.user_id as id,a.dated,a.terapist_name as name,
                        string_agg(distinct right(invoice_no,6),'##') as invoice_no,
                        string_agg(case when type_id=2 then abbr else '' end,'##' order by invoice_no) as abbr,
                        sum(point_qty) as point_qty,sum(a.commisions) as commisions,
                        string_agg(case when type_id=8 then commisions::character varying else '' end,'##' order by invoice_no) as commisions_extra,
                        string_agg(case when type_id=2 then total::character varying else '' end,'##' order by invoice_no) as total_abbr,
                        string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by invoice_no) as total_commisions,
                        string_agg(case when type_id=2 then point_qty::character varying else '' end,'##' order by invoice_no) as total_point_qty,
                        string_agg(case when type_id=1 then abbr else '' end,'##') as product_abbr,
                        string_agg(case when type_id=1 then price::character varying else '' end,'##') as product_price,
                        string_agg(case when type_id=1 then base_commision::character varying else '' end,'##') as product_base_commision,
                        string_agg(case when type_id=1 then qty::character varying else '' end,'##') as product_qty,      
                        string_agg(case when type_id=1 then commisions::character varying else '' end,'##') as product_commisions     
                        from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."' and a.user_id::character varying like '".$terapist."' 
                        group by a.branch_name,a.user_id,a.dated,a.terapist_name
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by a.branch_name,a.name,a.dated      
            ");

            $report_data_terapist = DB::select("
                    select distinct a.branch_name,a.id,a.name
                    from (
                        select a.branch_name,a.user_id as id,a.dated,a.terapist_name as name,
                        string_agg(distinct right(invoice_no,6),'##') as invoice_no,
                        string_agg(case when type_id=2 then abbr else '' end,'##' order by invoice_no) as abbr,
                        sum(point_qty) as point_qty,sum(a.commisions) as commisions,
                        string_agg(case when type_id=8 then commisions::character varying else '' end,'##' order by invoice_no) as commisions_extra,
                        string_agg(case when type_id=2 then total::character varying else '' end,'##' order by invoice_no) as total_abbr,
                        string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by invoice_no) as total_commisions,
                        string_agg(case when type_id=2 then point_qty::character varying else '' end,'##' order by invoice_no) as total_point_qty,
                        string_agg(case when type_id=1 then abbr else '' end,'##') as product_abbr,
                        string_agg(case when type_id=1 then price::character varying else '' end,'##') as product_price,
                        string_agg(case when type_id=1 then base_commision::character varying else '' end,'##') as product_base_commision,
                        string_agg(case when type_id=1 then qty::character varying else '' end,'##') as product_qty,      
                        string_agg(case when type_id=1 then commisions::character varying else '' end,'##') as product_commisions     
                        from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."' and a.user_id::character varying like '".$terapist."' 
                        group by a.branch_name,a.user_id,a.dated,a.terapist_name
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by 1,3     
            ");

            $time = strtotime($filter_begin_date);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($filter_begin_date, 8, 2);
            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{
                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                    select a.dated,a.user_id as id,(a.commisions+coalesce(pc2.point_value,0)) as total
                    from (
                        select a.dated,a.user_id,sum(point_qty) as point_qty,sum(a.commisions) as commisions from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$date26."' and  '".$filter_begin_end."'  and a.user_id::character varying like '".$terapist."' 
                        group by a.dated,a.user_id
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by a.dated           
            ");
    
        
            return view('pages.reports.terapist_comm_day_print_2', [
                'report_data_com_from1' => $report_data_com_from1,
                'report_data_detail_t' => $report_data_detail_t,
                'report_data_terapist' => $report_data_terapist,
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $branchx,
                'filter_terapist_in' => $terapist,
                'settings' => Settings::get(),
            ]);
        }else if($request->export=='Export Sum Lite API'){

            
            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $report_data_detail_t = DB::select("
                    select a.branch_name,a.id,a.dated,a.name,a.invoice_no,a.abbr,coalesce(pc2.point_value,0) as total_point,(a.commisions+coalesce(pc2.point_value,0)) as total,commisions_extra,total_abbr,total_commisions,total_point_qty,product_abbr,
                    product_price,product_base_commision,product_qty,product_commisions
                    from (
                        select a.branch_name,a.user_id as id,a.dated,a.terapist_name as name,
                        string_agg(distinct right(invoice_no,6),'\n') as invoice_no,
                        string_agg(case when type_id=2 then abbr else '' end,'##' order by invoice_no) as abbr,
                        sum(point_qty) as point_qty,sum(a.commisions) as commisions,
                        string_agg(case when type_id=8 then commisions::character varying else '' end,'##' order by invoice_no) as commisions_extra,
                        string_agg(case when type_id=2 then total::character varying else '' end,'##' order by invoice_no) as total_abbr,
                        string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by invoice_no) as total_commisions,
                        string_agg(case when type_id=2 then point_qty::character varying else '' end,'##' order by invoice_no) as total_point_qty,
                        string_agg(case when type_id=1 then abbr else '' end,'##') as product_abbr,
                        string_agg(case when type_id=1 then price::character varying else '' end,'##') as product_price,
                        string_agg(case when type_id=1 then base_commision::character varying else '' end,'##') as product_base_commision,
                        string_agg(case when type_id=1 then qty::character varying else '' end,'##') as product_qty,      
                        string_agg(case when type_id=1 then commisions::character varying else '' end,'##') as product_commisions     
                        from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."' and a.user_id::character varying like '".$terapist."' 
                        group by a.branch_name,a.user_id,a.dated,a.terapist_name
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by a.branch_name,a.name,a.dated      
            ");

            $report_data_terapist = DB::select("
                    select distinct a.branch_name,a.id,a.name
                    from (
                        select a.branch_name,a.user_id as id,a.dated,a.terapist_name as name,
                        string_agg(distinct right(invoice_no,6),'##') as invoice_no,
                        string_agg(case when type_id=2 then abbr else '' end,'##' order by invoice_no) as abbr,
                        sum(point_qty) as point_qty,sum(a.commisions) as commisions,
                        string_agg(case when type_id=8 then commisions::character varying else '' end,'##' order by invoice_no) as commisions_extra,
                        string_agg(case when type_id=2 then total::character varying else '' end,'##' order by invoice_no) as total_abbr,
                        string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by invoice_no) as total_commisions,
                        string_agg(case when type_id=2 then point_qty::character varying else '' end,'##' order by invoice_no) as total_point_qty,
                        string_agg(case when type_id=1 then abbr else '' end,'##') as product_abbr,
                        string_agg(case when type_id=1 then price::character varying else '' end,'##') as product_price,
                        string_agg(case when type_id=1 then base_commision::character varying else '' end,'##') as product_base_commision,
                        string_agg(case when type_id=1 then qty::character varying else '' end,'##') as product_qty,      
                        string_agg(case when type_id=1 then commisions::character varying else '' end,'##') as product_commisions     
                        from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$filter_begin_date."' and  '".$filter_begin_end."' and a.user_id::character varying like '".$terapist."' 
                        group by a.branch_name,a.user_id,a.dated,a.terapist_name
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by 1,3     
            ");

            $time = strtotime($filter_begin_date);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($filter_begin_date, 8, 2);
            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{
                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                    select a.dated,a.user_id as id,(a.commisions+coalesce(pc2.point_value,0)) as total
                    from (
                        select a.dated,a.user_id,sum(point_qty) as point_qty,sum(a.commisions) as commisions from terapist_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where a.dated  between '".$date26."' and  '".$filter_begin_end."'  and a.user_id::character varying like '".$terapist."' 
                        group by a.dated,a.user_id
                    ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty 
                    order by a.dated           
            ");

            $beginnewformat = date('d-m-Y',strtotime($filter_begin_date));    
            $endnewformat = date('d-m-Y',strtotime($filter_begin_end));    
        
            return array_merge([
                'report_data_com_from1' => $report_data_com_from1,
                'report_data_detail_t' => $report_data_detail_t,
                'report_data_terapist' => $report_data_terapist,
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                'filter_terapist_in' => $terapist,
                'beginnewformat' => $beginnewformat,
                'endnewformat' => $endnewformat,
                'settings' => Settings::get(),
            ]);
        }else{
            $report_data = DB::select("
            select a.branch_name,a.com_type,to_char(a.dated,'dd-mm-YYYY') as dated,a.qtyinv,a.work_year,a.name,a.commisions,a.point_qty,coalesce(pc2.point_value,0)  as point_value,a.commisions+coalesce(pc2.point_value,0) as total from (
                select b.remark as branch_name,'work_commision' as com_type,im.dated,count(ps.id) as qtyinv,u.work_year,u.name,sum(pc.values*id.qty) as commisions,sum(coalesce(pp.point,0)*id.qty) as point_qty
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id 
                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                join (
                    select r.id,r.name,r.job_id,case when r.work_year=0 then 1 when r.work_year>10 then 10  else r.work_year end as work_year 
                    from users r
                    ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years  and u.id::character varying like '".$terapist."' 
                left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
                where pc.values > 0 and im.dated between '".$begindate."' and '".$enddate."'  
                group by  b.remark,im.dated,u.work_year,u.name
                union all            
                select  b.remark as branch_name,'referral' as com_type,im.dated,count(ps.id) as qtyinv,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,sum(pc.referral_fee * id.qty) as commisions,0 as point_qty   
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join product_sku ps on ps.id = id.product_id 
                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%'
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                join users u on u.job_id = 2  and u.id = id.referral_by and u.id::character varying like '".$terapist."' 
                where pc.referral_fee  > 0 and im.dated between '".$begindate."' and '".$enddate."'  
                group by  b.remark,im.dated,u.join_date,u.name
                union all            
                select b.remark as branch_name,'extra' as com_type,im.dated,count(ps.id) as qtyinv,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,
                sum(pc.assigned_to_fee * id.qty) commisions,
                0 as point_qty
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join product_sku ps on ps.id = id.product_id 
                join customers c on c.id = im.customers_id 
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                join users u on u.job_id = 2  and u.id = id.assigned_to  and u.id::character varying like '".$terapist."' 
                where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0  and im.dated  between '".$begindate."' and  '".$enddate."'   and c.branch_id::character varying like  '".$branchx."'
                group by  b.remark,im.dated,u.join_date,u.name
        ) a left join point_conversion pc2 on pc2.point_qty = a.point_qty order by a.branch_name,a.dated,a.name;          
        ");  
               
            return view('pages.reports.commision_terapist_summary',['company' => Company::get()->first()], compact('users_terapist','report_data','branchs','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
                            'icon' => 'fa fa-spa',
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