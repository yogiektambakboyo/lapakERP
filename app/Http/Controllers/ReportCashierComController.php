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

        $call_proc = DB::select("CALL public.calc_commision_cashier_today();");

        $report_data = DB::select("
                select com_type,to_char(dated,'dd-MM-YYYY') as dated,invoice_no,abbr,remark,created_by,name,price,qty,total,base_commision,commisions from (    
                    select  'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id 
                    join branch b on b.id = c.branch_id
                    join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by  
                    where pc.created_by_fee > 0
                    union 
                    select  'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id 
                    join branch b on b.id = c.branch_id
                    join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                    where pc.created_by_fee <= 0 and pc.referral_fee > 0       
                ) a where dated::date>=now()-interval'7 days' order by a.name,dated 
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
    
        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $endnewformat = date(Carbon::parse($request->filter_end_date_in)->format('d-m-Y'));
        $beginnewformat = date(Carbon::parse($request->filter_begin_date_in)->format('d-m-Y'));

        
        $branchx = $request->filter_branch_id_in;

        if($request->export=='Export Excel'){
            $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id);
            return Excel::download(new ReportCommisionCashierExport($strencode), 'report_commision_cashier_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->export=='Export Sum'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;
        
            $report_data_total = DB::select("

                            select '0' as name,dated,'0' as id,0 as total_point,sum(commisions) as total from (
                                select  u.id,'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                                from invoice_master im 
                                join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                                join product_sku ps on ps.id = id.product_id 
                                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                                join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                                join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                                where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                                union 
                                select u.id,'extra_commision' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                                where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                                group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                                union 
                                select  u.id,'referral' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
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
                    select  b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join branch b on b.id = c.branch_id
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                    where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                    union 
                    select b.remark as branch_name,ps.type_id,'0' as id,'extra_commision' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                    where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                    group by  ps.type_id,b.remark,im.dated,u.work_year,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                    union
                    select b.remark as branch_name,ps.type_id,'0' as id,'referral' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,right(im.invoice_no,6) as invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                    join branch b on b.id = c.branch_id
                    join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                    join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                    where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$begindate."' and '".$enddate."'   
            ) a order by dated
                       
            ");

            $report_data_detail_inv = DB::select("


                select distinct right(invoice_no,6) as invoice_no,'0' as name,dated,'0' as id from (
                        select  u.id,'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union
                        select u.id,'extra_commision' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                        where pc.values > 0 and im.dated  between '".$begindate."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                        group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                        union 
                        select  u.id,'referral' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
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

                select distinct to_char(dated,'dd-MM-YYYY') as dated,'0' as name,'0' as id,to_char(dated,'YYYY-MM-dd') as datedorder from (
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
            ) a order by to_char(dated,'YYYY-MM-dd')
            ");


            $time = strtotime($begindate);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($begindate, 8, 2);

            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{
                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("

                        select dated,'0' as id,sum(commisions) as total from (
                            select  u.id,'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
                            where pc.created_by_fee > 0 and  im.dated between '".$date26."' and '".$enddate."' 
                            union 
                            select u.id,'extra_commision' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions
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
                            where pc.values > 0 and im.dated  between '".$date26."' and '".$enddate."'   and c.branch_id::character varying like '%".$branchx."%' 
                            group by u.id,b.remark,im.dated,u.work_year,u.name,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
                            union 
                            select  u.id,'referral' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no
                            join product_sku ps on ps.id = id.product_id 
                            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                            join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
                            where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$date26."' and '".$enddate."'   
                    ) a group by dated     
            ");
    
            return view('pages.reports.cashier_comm_day_print', [
                'data' => $data,
                'report_data_total' => $report_data_total,
                'report_data_com_from1' => $report_data_com_from1,
                'report_datas_detail' => $report_data_detail,
                'report_data_detail_invs' => $report_data_detail_inv,
                'report_data_detail_t' => $report_data_detail_t,
                'settings' => Settings::get(),
            ]);

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



        }else if($request->export=='Export Sum Lite'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $call_proc = DB::select("CALL calc_commision_cashier();");

            $report_data_dated = DB::select("
                select to_char(dated,'YYYY-MM-dd') as datedorder
                from cashier_commision a 
                join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                where a.dated between '".$begindate."' and '".$enddate."'  and a.branch_id::character varying like '%".$branchx."%'
                group by branch_name,to_char(dated,'dd-MM-YYYY'),to_char(dated,'YYYY-MM-dd')
                order by 1
            ");

            $report_data_detail_t = DB::select("
                select branch_name,to_char(dated,'YYYY-MM-dd') as datedorder,to_char(dated,'dd-MM-YYYY') as dated,'0' as name,'0' as id,
                string_agg(distinct right(invoice_no,6),'##' order by right(invoice_no,6)) as invoice_no,
                string_agg(case when type_id=1 then abbr else '' end,'##' order by right(invoice_no,6)) as product_abbr,
                string_agg(case when type_id=1 then price::character varying else '' end,'##' order by right(invoice_no,6)) as product_price,
                string_agg(case when type_id=1 then base_commision::character varying else '' end,'##' order by right(invoice_no,6)) as product_base_commision,
                string_agg(case when type_id=1 then qty::character varying else '' end,'##' order by right(invoice_no,6)) as product_qty,      
                string_agg(case when type_id=1 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as product_commisions,   
                string_agg(case when type_id=8 and a.abbr not like '%CAS LEBARAN%' then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as commisions_extra,
                string_agg(case when type_id=8 and a.abbr like '%CAS LEBARAN%' then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as commisions_lebaran,
                string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as charge_lebaran,
                sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total   
                from cashier_commision a 
                join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                where a.dated between '".$begindate."' and '".$enddate."'  and a.branch_id::character varying like '%".$branchx."%'
                group by branch_name,to_char(dated,'dd-MM-YYYY'),to_char(dated,'YYYY-MM-dd')
                order by 1,2
            ");

            $time = strtotime($begindate);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($begindate, 8, 2);

            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{

                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                        select to_char(dated,'dd-MM-YYYY') as dated,'0' as id,sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total from cashier_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where dated between '".$date26."'  and '".$enddate."'  and a.branch_id::character varying like  '".$filter_branch_id."' group by dated     
            ");
    
            return view('pages.reports.cashier_comm_day_print_2', [
                'report_data_com_from1' => $report_data_com_from1,
                'report_data_detail_t' => $report_data_detail_t,
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                'report_data_dated' => $report_data_dated,
                'settings' => Settings::get(),
            ]);
        }else if($request->export=='Export Sum Lite Produk'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $call_proc = DB::select("CALL calc_commision_cashier();");

            $report_data = DB::select("select b.id as branch_id,b.remark as branch_name,im.dated,sum(id.qty) as qty,sum(id.total) as total
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58 and ps.id != 461
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
            join branch b on b.id = c.branch_id
            join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
            where im.dated between '".$begindate."' and '".$enddate."'  and ps.category_id != 60
            group by b.remark,im.dated,b.id
            order by 1,3");

            $report_detail = DB::select("select coalesce(pp.price_buy,0) as modal,b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total,
            cm.base_commision,cm.commisions,cmt.base_commision as base_commision_tp,cmt.commisions as commisions_tp 
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58 and ps.id != 461
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
            join branch b on b.id = c.branch_id
            join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
            left join product_price pp on pp.product_id = id.product_id  and pp.branch_id = b.id
            left join ( 
                select branch_id,branch_name,dated,product_id,base_commision,sum(commisions) as commisions 
                from cashier_commision where type_id = 1 group by branch_id,branch_name,dated,product_id,base_commision
            ) cm on cm.branch_id = c.branch_id and cm.product_id=id.product_id and cm.dated = im.dated
            left join ( 
                select branch_id,branch_name,dated,product_id,base_commision,sum(commisions) as commisions 
                from terapist_commision where type_id = 1 group by branch_id,branch_name,dated,product_id,base_commision
            ) cmt on cmt.branch_id = c.branch_id and cmt.product_id=id.product_id and cmt.dated = im.dated
            where im.dated between '".$begindate."' and '".$enddate."' and ps.category_id != 60
            group by b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,cm.base_commision,cm.commisions,cmt.base_commision,cmt.commisions,pp.price_buy
            order by 3,4,6");

            $report_data_dated = DB::select("
                select to_char(dated,'YYYY-MM-dd') as datedorder
                from cashier_commision a 
                join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                where a.dated between '".$begindate."' and '".$enddate."'  and a.branch_id::character varying like '%".$branchx."%'
                group by branch_name,to_char(dated,'dd-MM-YYYY'),to_char(dated,'YYYY-MM-dd')
                order by 1
            ");

            $report_data_detail_t = DB::select("
                select branch_name,to_char(dated,'YYYY-MM-dd') as datedorder,to_char(dated,'dd-MM-YYYY') as dated,'0' as name,'0' as id,
                string_agg(distinct right(invoice_no,6),'##' order by right(invoice_no,6)) as invoice_no,
                string_agg(case when type_id=1 then abbr else '' end,'##' order by right(invoice_no,6)) as product_abbr,
                string_agg(case when type_id=1 then price::character varying else '' end,'##' order by right(invoice_no,6)) as product_price,
                string_agg(case when type_id=1 then base_commision::character varying else '' end,'##' order by right(invoice_no,6)) as product_base_commision,
                string_agg(case when type_id=1 then qty::character varying else '' end,'##' order by right(invoice_no,6)) as product_qty,      
                string_agg(case when type_id=1 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as product_commisions,   
                string_agg(case when type_id=8 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as commisions_extra,
                sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total   
                from cashier_commision a 
                join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                where a.dated between '".$begindate."' and '".$enddate."'  and a.branch_id::character varying like '%".$branchx."%'
                group by branch_name,to_char(dated,'dd-MM-YYYY'),to_char(dated,'YYYY-MM-dd')
                order by 1,2
            ");

            $time = strtotime($begindate);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($begindate, 8, 2);

            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{

                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                        select to_char(dated,'dd-MM-YYYY') as dated,'0' as id,sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total from cashier_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where dated between '".$date26."'  and '".$enddate."'  and a.branch_id::character varying like  '".$filter_branch_id."' group by dated     
            ");
    
            return view('pages.reports.cashier_comm_day_print_produk', [
                'report_data_com_from1' => $report_data_com_from1,
                'report_data_detail_t' => $report_data_detail_t,
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                'report_data_dated' => $report_data_dated,
                'report_data' => $report_data,
                'report_detail' => $report_detail,
                'settings' => Settings::get(),
            ]);
        }else if($request->export=='Export Sum Lite Produk API'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $call_proc = DB::select("CALL calc_commision_cashier();");

            $report_data = DB::select("select b.id as branch_id,b.remark as branch_name,im.dated,sum(id.qty) as qty,sum(id.total) as total,to_char(im.dated,'dd-MM-YYYY') as datedformat 
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58 and ps.id != 461
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
            join branch b on b.id = c.branch_id
            join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
            where im.dated between '".$begindate."' and '".$enddate."'  and ps.category_id != 60
            group by b.remark,im.dated,b.id
            order by 1,3");

            $report_detail = DB::select("select coalesce(pp.price_buy,0) as modal,b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total,
            coalesce(cm.base_commision,0) base_commision,coalesce(cm.commisions,0) as commisions,coalesce(cmt.base_commision,0) as base_commision_tp,coalesce(cmt.commisions,0) as commisions_tp,to_char(im.dated,'dd-MM-YYYY') as datedformat 
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58 and ps.id != 461
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
            join branch b on b.id = c.branch_id
            join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
            left join product_price pp on pp.product_id = id.product_id  and pp.branch_id = b.id
            left join ( 
                select branch_id,branch_name,dated,product_id,base_commision,sum(commisions) as commisions 
                from cashier_commision where type_id = 1 group by branch_id,branch_name,dated,product_id,base_commision
            ) cm on cm.branch_id = c.branch_id and cm.product_id=id.product_id and cm.dated = im.dated
            left join ( 
                select branch_id,branch_name,dated,product_id,base_commision,sum(commisions) as commisions 
                from terapist_commision where type_id = 1 group by branch_id,branch_name,dated,product_id,base_commision
            ) cmt on cmt.branch_id = c.branch_id and cmt.product_id=id.product_id and cmt.dated = im.dated
            where im.dated between '".$begindate."' and '".$enddate."' and ps.category_id != 60
            group by b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,cm.base_commision,cm.commisions,cmt.base_commision,cmt.commisions,pp.price_buy
            order by 3,4,6");

        

            

            $time = strtotime($begindate);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($begindate, 8, 2);

            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{

                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                        select to_char(dated,'dd-MM-YYYY') as dated,'0' as id,sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total from cashier_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where dated between '".$date26."'  and '".$enddate."'  and a.branch_id::character varying like  '".$filter_branch_id."' group by dated     
            ");
    
            return array_merge([
                //'report_data_com_from1' => $report_data_com_from1,
                //'report_data_detail_t' => $report_data_detail_t,
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                //'report_data_dated' => $report_data_dated,
                'report_data' => $report_data,
                'beginnewformat' => $beginnewformat,
                'endnewformat' => $endnewformat,
                'report_detail' => $report_detail,
            ]);
        }else if($request->export=='Export Com'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $report_data = DB::select("
                select 
                coalesce(ex.referral_fee,0) as base_com,
                right(im.invoice_no,6) as invoice_no,b.id as branch_id,b.remark as branch_name,im.dated,to_char(im.dated, 'dd-MM-YYYY') as datedformat,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join users u on u.id = id.referral_by and u.job_id = 1
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58
                join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions_ex ex on ex.branch_id = b.id and ex.product_id=ps.id and ex.product_id=id.product_id
                where im.dated between '".$begindate."' and '".$enddate."' and coalesce(ex.referral_fee,0)>0
                group by right(im.invoice_no,6),b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,ex.users_id,im.created_by,id.referral_by,ex.created_by_fee,ex.referral_fee
                order by 4,5
            ");

            $report_detail = DB::select("
                select 
                coalesce(ex.referral_fee,0) as base_com,
                right(im.invoice_no,6) as invoice_no,b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total,u.name
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join users u on u.id = id.referral_by  and u.job_id = 1
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58
                join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions_ex ex on ex.branch_id = b.id and ex.product_id=ps.id and ex.product_id=id.product_id
                where im.dated between '".$begindate."' and '".$enddate."'  and coalesce(ex.referral_fee,0)>0
                group by u.name,right(im.invoice_no,6),b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,id.referral_by,ex.referral_fee
                order by 4,5,7,11
            
            ");
            
    
            return view('pages.reports.cashier_comm_ex', [
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                'report_data' => $report_data,
                'report_detail' => $report_detail,
                'beginnewformat' => $beginnewformat,
                'endnewformat' => $endnewformat,
                'settings' => Settings::get(),
            ]);
        }else if($request->export=='Export Com API'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $report_data = DB::select("
                select 
                coalesce(ex.referral_fee,0) as base_com,
                right(im.invoice_no,6) as invoice_no,b.id as branch_id,b.remark as branch_name,to_char(im.dated, 'dd-MM-YYYY') as datedformat,
                im.dated,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join users u on u.id = id.referral_by and u.job_id = 1
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58
                join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions_ex ex on ex.branch_id = b.id and ex.product_id=ps.id and ex.product_id=id.product_id
                where im.dated between '".$begindate."' and '".$enddate."' and coalesce(ex.referral_fee,0)>0
                group by right(im.invoice_no,6),b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,ex.users_id,im.created_by,id.referral_by,ex.created_by_fee,ex.referral_fee
                order by 4,5
            ");

            $report_detail = DB::select("
                select 
                coalesce(ex.referral_fee,0) as base_com,
                right(im.invoice_no,6) as invoice_no,b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.abbr,sum(id.qty) as qty,id.price,sum(id.total) as total,u.name
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join users u on u.id = id.referral_by and u.job_id = 1
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1 and ps.category_id!=58
                join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_commisions_ex ex on ex.branch_id = b.id and ex.product_id=ps.id and ex.product_id=id.product_id
                where im.dated between '".$begindate."' and '".$enddate."'  and coalesce(ex.referral_fee,0)>0
                group by u.name,right(im.invoice_no,6),b.remark,im.dated,b.id,id.product_id,id.price,ps.abbr,id.referral_by,ex.referral_fee
                order by 4,5,7,11
            
            ");
            
    
            return array_merge([
                'filter_begin_date' => $filter_begin_date,
                'filter_begin_end' => $filter_begin_end,
                'filter_branch_id' => $filter_branch_id,
                'report_data' => $report_data,
                'beginnewformat' => $beginnewformat,
                'endnewformat' => $endnewformat,
                'report_detail' => $report_detail,
            ]);
        }else if($request->export=='Export Sum Lite API'){

            $filter_begin_date = $begindate;
            $filter_begin_end = $enddate;
            $filter_branch_id =  $branchx;

            $call_proc = DB::select("CALL calc_commision_cashier();");

            $report_data_detail_t = DB::select("
                select  to_char(dated,'YYYYMMdd') as datedint,branch_name,to_char(dated,'YYYY-MM-dd') as datedorder,to_char(dated,'dd-MM-YYYY') as dated,'0' as name,'0' as id,
                string_agg(distinct right(invoice_no,6),'##' order by right(invoice_no,6)) as invoice_no,
                string_agg(case when type_id=1 then abbr else '' end,'##' order by right(invoice_no,6)) as product_abbr,
                sum(case when type_id=1 then price else 0 end) t_price,
                string_agg(case when type_id=1 then price::character varying else '' end,'##' order by right(invoice_no,6)) as product_price,
                string_agg(case when type_id=1 then base_commision::character varying else '' end,'##' order by right(invoice_no,6)) as product_base_commision,
                sum(case when type_id=1 then base_commision else 0 end) t_komisi,
                string_agg(case when type_id=1 then qty::character varying else '' end,'##' order by right(invoice_no,6)) as product_qty,      
                sum(case when type_id=1 then qty else 0 end) t_qty,
                string_agg(case when type_id=1 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as product_commisions, 
                sum(case when type_id=1 then commisions else 0 end) t_tkomisi,
                string_agg(case when type_id=8 and a.abbr not like '%CAS LEBARAN%' then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as commisions_extra,
                sum(case when type_id=8 and a.abbr not like '%CAS LEBARAN%' then commisions else 0 end) t_extra,
                string_agg(case when type_id=8 and a.abbr like '%CAS LEBARAN%' then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as commisions_lebaran,
                string_agg(case when type_id=2 then commisions::character varying else '' end,'##' order by right(invoice_no,6)) as charge_lebaran,
                sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total
                from cashier_commision a 
                join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                where a.dated between '".$begindate."' and '".$enddate."'  and a.branch_id::character varying like '%".$branchx."%'
                group by branch_name,to_char(dated,'dd-MM-YYYY'),to_char(dated,'YYYY-MM-dd'),to_char(dated,'YYYYMMdd') 
                order by 1,2
            ");


            $time = strtotime($begindate);
            $newformat = date('Y-m-d',$time);
            $newformatd = date('Y-m',$time);
            $newformatlastm = date('Y-m', strtotime('-1 months', strtotime($newformat)));

            $date26 = substr($begindate, 8, 2);

            $today_date = (int)$date26;
            if ($today_date>=26){
                $date26 = $newformatd.'-26';
            }else{

                $date26 = $newformatlastm.'-26';
            }

            $report_data_com_from1 = DB::select("
                        select to_char(dated,'YYYYMMdd') as datedint,to_char(dated,'dd-MM-YYYY') as dated,'0' as id,sum(case when type_id=1 or (type_id=8 and a.abbr not like '%CAS LEBARAN%') then commisions else 0 end) as total from cashier_commision a
                        join users_branch as ub on ub.branch_id = a.branch_id and ub.user_id = '".$user->id."'
                        where dated between '".$date26."'  and '".$enddate."'  and a.branch_id::character varying like  '".$filter_branch_id."' group by dated     
            ");

            $beginnewformat = date('d-m-Y',strtotime($filter_begin_date));    
            $endnewformat = date('d-m-Y',strtotime($filter_begin_end));    
    
            return array_merge([
                'report_data_com_from1' => $report_data_com_from1,
                'report_data_detail_t' => $report_data_detail_t,
                'settings' => Settings::get(),
                'endnewformat' => $endnewformat,
                'beginnewformat' => $beginnewformat,
            ]);


        }else{
            $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

            $report_data = DB::select("
                select * from (
                        select  'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
                        join product_sku ps on ps.id = id.product_id 
                        join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$branchx."%' 
                        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
                        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by  
                        where pc.created_by_fee > 0 and im.dated between '".$begindate."' and '".$enddate."' 
                        union 
                        select  'referral' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
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
           })->orderby('permissions.seq')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

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