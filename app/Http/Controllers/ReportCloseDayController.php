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
use App\Models\Settings;
use App\Models\ProductBrand;
use App\Models\Shift;
use App\Models\ProductCategory;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\CloseDayExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ReportCloseDayController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="reports.closeday",$id=1;

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
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $report_data = DB::select("
                select b.id as branch_id,b.remark as branch_name,im.dated,sum(id.total+id.vat_total) as total_all,
                sum(case when ps.type_id = 2 then id.total+id.vat_total else 0 end) as total_service,
                sum(case when ps.type_id = 1 and ps.category_id !=12 then id.total+id.vat_total else 0 end) as total_product,
                sum(case when ps.type_id = 1 and ps.category_id =12 then id.total+id.vat_total else 0 end) as total_drink,
                sum(case when ps.type_id = 8 then id.total+id.vat_total else 0 end) as total_extra,
                sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
                sum(case when im.payment_type = 'BCA - Debit' then id.total+id.vat_total else 0 end) as total_b_d,
                sum(case when im.payment_type = 'BCA - Kredit' then id.total+id.vat_total else 0 end) as total_b_k,
                sum(case when im.payment_type = 'Mandiri - Debit' then id.total+id.vat_total else 0 end) as total_m_d,
                sum(case when im.payment_type = 'Mandiri - Kredit' then id.total+id.vat_total else 0 end) as total_m_k,
                sum(case when im.payment_type = 'QRIS' then id.total+id.vat_total else 0 end) as total_qr,
                sum(case when im.payment_type = 'Transfer' then id.total+id.vat_total else 0 end) as total_tr,
                count(distinct im.invoice_no) qty_transaction,count(distinct im.customers_id) qty_customers
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join product_sku ps on ps.id = id.product_id 
                join customers c on c.id = im.customers_id 
                join branch b on b.id = c.branch_id
                where im.dated>now()-interval'7 days'
                group by b.remark,im.dated,b.id       
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        return view('pages.reports.close_day',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function getdata(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $filter_begin_date = date(Carbon::parse($request->filter_begin_date)->format('Y-m-d'));
        $filter_branch_id =  $request->get('filter_branch_id')==null?'%':$request->get('filter_branch_id');
        $report_data = DB::select("
                select ps.category_id,b.remark as branch_name,im.dated,id.product_name,ps.abbr,ps.type_id,id.price,sum(id.qty) as qty,sum(id.total+id.vat_total) as total,count(distinct c.id) as qty_customer
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                group by ps.category_id,b.remark,im.dated,id.product_name,ps.abbr,id.price,ps.type_id                         
        ");
        $out_data = DB::select("
                select ps2.abbr,sum(pi2.qty) as qty 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id 
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material  
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                group by ps2.abbr                    
        ");
        $payment_data = DB::select("
                select im.invoice_no,im.total_payment,im.payment_type,count(distinct im.invoice_no) as qty_payment
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."  
                group by im.invoice_no,im.total_payment,im.payment_type                       
        ");


        $petty_datas = DB::select("
            select ps.abbr,pc.type,sum(pcd.qty) qty,sum(pcd.line_total) as total  from petty_cash pc 
            join petty_cash_detail pcd on pcd.doc_no = pc.doc_no
            join product_sku ps on ps.id = pcd.product_id 
            where pc.dated  = '".$filter_begin_date."'  and pc.branch_id = ".$filter_branch_id."  
            group by ps.abbr,pc.type order by 1                   
        ");

        $cust = DB::select("
                select count(distinct c.id) as c_cus
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."                      
        ");
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.reports.close_day_print', [
            'data' => $data,
            'payment_datas' => $payment_data,
            'out_datas' => $out_data,
            'report_datas' => $report_data,
            'petty_datas' => $petty_datas,
            'cust' => $cust,
            'settings' => Settings::get(),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');

        return view('pages.reports.print',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function getdata_daily(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $filter_begin_date = date(Carbon::parse($request->filter_begin_date)->format('Y-m-d'));
        $filter_branch_id =  $request->get('filter_branch_id')==null?'%':$request->get('filter_branch_id');
        $report_data = DB::select("
                select ps.category_id,b.remark as branch_name,im.dated,id.product_name,ps.abbr,ps.type_id,id.price,sum(id.qty) as qty,sum(id.total+id.vat_total) as total,count(distinct c.id) as qty_customer
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                group by ps.category_id,b.remark,im.dated,id.product_name,ps.abbr,id.price,ps.type_id                         
        ");
        

        $out_datas = DB::select("
                select c.id,ps2.abbr,sum(pi2.qty) as qty 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id 
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material  
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                group by ps2.abbr,c.id order by 1                  
        ");

        $out_datas_total = DB::select("
                select ps2.abbr,sum(pi2.qty) as qty 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id 
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material  
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                group by ps2.abbr order by 1                  
        ");
        $out_datas_total_drink = DB::select("
                select ps.abbr,sum(id.qty) as qty,(sum(coalesce(id.total,0))/1000)::int as total
                        from invoice_master im 
                        join invoice_detail id on id.invoice_no = im.invoice_no
                        join customers c on c.id = im.customers_id 
                        join branch b on b.id=c.branch_id
                        join product_sku ps on ps.id = id.product_id  and ps.category_id=26
                        where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id." and im.invoice_no in (
                            select im.invoice_no
                            from invoice_master im 
                            join invoice_detail id on id.invoice_no = im.invoice_no
                            join customers c on c.id = im.customers_id 
                            where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                            group by im.invoice_no having count(id.product_id)=1
                        )
                group by ps.remark,ps.abbr having count(im.invoice_no)=1 and sum(ps.type_id)<=1 order by 1      
        ");
        $out_datas_total_other = DB::select("
                select ps.abbr,sum(id.qty) as qty,(sum(coalesce(id.total,0))/1000)::int as total
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join product_sku ps on ps.id = id.product_id  and ps.category_id<>26
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id." and im.invoice_no in (
                    select im.invoice_no
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no
                    join customers c on c.id = im.customers_id 
                    where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."
                    group by im.invoice_no having count(id.product_id)=1
                )
                group by ps.remark,ps.abbr having count(im.invoice_no)=1 and sum(ps.type_id)<=1 order by 1                            
        ");
        $payment_data = DB::select("
                select im.invoice_no,im.total_payment,im.payment_type,count(distinct im.invoice_no) as qty_payment
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."  
                group by im.invoice_no,im.total_payment,im.payment_type                       
        ");

        $dtt_detail = DB::select("
                select c.id,customers_name,br.remark as branch_room,string_agg(distinct u.name,', ') as name,sum(id.qty*id.price)/1000 as total,string_agg(distinct im.payment_type,', ') payment_type,string_agg(distinct to_char(im.scheduled_at,'HH24:MI'),', ') as scheduled_at
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join users u on u.id = id.assigned_to
                join product_sku ps on ps.id = id.product_id  and ps.type_id=2 
                join customers c on c.id = im.customers_id
                join branch_room br on br.id = im.branch_room_id 
                where im.dated  = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."  and ps.id in (
                    '280',
                    '281',
                    '282',
                    '283',
                    '284',
                    '285',
                    '286',
                    '287',
                    '288',
                    '289',
                    '290',
                    '291',
                    '292',
                    '293',
                    '294',
                    '295',
                    '296',
                    '297',
                    '298',
                    '299',
                    '300',
                    '301',
                    '302',
                    '304',
                    '305',
                    '306',
                    '307',
                    '308',
                    '310',
                    '312',
                    '313',
                    '315',
                    '317',
                    '321',
                     '316',
                     '309',
                     '318',
                     '319'
                )
                group by customers_name,c.id,br.remark order by 7
        ");

        $dtt_item_only = DB::select("
                select ps.category_id,c.id as customers_id,ps.id,ps.abbr as product_name,ps.type_id,u.conversion,id.qty,(id.total/1000)::int as total,coalesce(id.referral_by,'0') as refbuy 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join product_sku ps on ps.id = id.product_id
                join product_uom pu on pu.product_id = id.product_id
                join uom u on u.id = pu.uom_id 
                join customers c on c.id = im.customers_id
                where im.dated  = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."   order by c.id,id.seq   
        ");

        $dtt_item_only_total = DB::select("
                select ps.category_id,ps.id,ps.abbr as product_name,ps.type_id,u.conversion,id.qty,id.total/1000 as total,coalesce(id.referral_by,'0') as refbuy 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join product_sku ps on ps.id = id.product_id
                join product_uom pu on pu.product_id = id.product_id
                join uom u on u.id = pu.uom_id 
                join customers c on c.id = im.customers_id
                where im.dated  = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id." and coalesce(id.referral_by,'0')='0'  order by ps.abbr  
        ");

        $dtt_raw = DB::select("select a.customers_id,a.scheduled_at,sum(total_316)/1000 as total_316,sum(total_309)/1000 as total_309,sum(total_318)/1000 as total_318,sum(total_319)/1000 as total_319,sum(total_316)/1000 as total_316,sum(total_309)/1000 as total_309,sum(total_318)/1000 as total_318,sum(total_319)/1000 as total_319,sum(total_280)/1000 as total_280,sum(total_281)/1000 as total_281,sum(total_282)/1000 as total_282,sum(total_283)/1000 as total_283,sum(total_284)/1000 as total_284,sum(total_285)/1000 as total_285,sum(total_286)/1000 as total_286,sum(total_287)/1000 as total_287,sum(total_288)/1000 as total_288,sum(total_289)/1000 as total_289,sum(total_290)/1000 as total_290,sum(total_291)/1000 as total_291,sum(total_292)/1000 as total_292,sum(total_293)/1000 as total_293,sum(total_294)/1000 as total_294,sum(total_295)/1000 as total_295,sum(total_296)/1000 as total_296,sum(total_297)/1000 as total_297,sum(total_298)/1000 as total_298,sum(total_299)/1000 as total_299,sum(total_300)/1000 as total_300,sum(total_301)/1000 as total_301,sum(total_302)/1000 as total_302,sum(total_304)/1000 as total_304,sum(total_305)/1000 as total_305,sum(total_306)/1000 as total_306,sum(total_307)/1000 as total_307,sum(total_308)/1000 as total_308,sum(total_310)/1000 as total_310,sum(total_312)/1000 as total_312,sum(total_313)/1000 as total_313,sum(total_315)/1000 as total_315,sum(total_317)/1000 as total_317,sum(total_321)/1000 as total_321 from (
            select im.customers_id,im.scheduled_at,sum(id.total) as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 316 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,sum(id.total) as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 309 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,sum(id.total)  as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 318 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,sum(id.total) as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 319 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,sum(id.total) as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 280 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,sum(id.total) as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 281 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,sum(id.total) as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 282 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,sum(id.total) as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 283 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,sum(id.total) as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 284 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,sum(id.total) as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 285 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,sum(id.total) as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 286 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,sum(id.total) as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 287  where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,sum(id.total) as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 288 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,sum(id.total) as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 289 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,sum(id.total) as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 290 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,sum(id.total) as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 291 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,sum(id.total) as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 292 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,sum(id.total) as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 293 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,sum(id.total) as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 294 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,sum(id.total) as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 295 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,sum(id.total) as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 296 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,sum(id.total) as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 297 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,sum(id.total) as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 298 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,sum(id.total) as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 299 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,sum(id.total) as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 300 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,sum(id.total) as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 301 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,sum(id.total) as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 302 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,sum(id.total) as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 304  where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,sum(id.total) as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 305 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,sum(id.total) as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 306 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,sum(id.total) as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 307 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,sum(id.total) as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 308 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,sum(id.total) as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 310 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,sum(id.total) as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 312 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,sum(id.total) as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 313 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,sum(id.total) as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 315 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,sum(id.total) as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 317  where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
            union
            select im.customers_id,im.scheduled_at,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,sum(id.total) as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 321 where im.dated='".$filter_begin_date."'   group by im.customers_id,im.scheduled_at
    ) a group by a.customers_id,a.scheduled_at order by 2
                "
            );

        $dtt_raw_oneline = DB::select("
            select sum(total_316)/1000 as total_316,sum(total_309)/1000 as total_309,sum(total_318)/1000 as total_318,sum(total_319)/1000 as total_319,sum(total_280)/1000 as total_280,sum(total_281)/1000 as total_281,sum(total_282)/1000 as total_282,sum(total_283)/1000 as total_283,sum(total_284)/1000 as total_284,sum(total_285)/1000 as total_285,sum(total_286)/1000 as total_286,sum(total_287)/1000 as total_287,sum(total_288)/1000 as total_288,sum(total_289)/1000 as total_289,sum(total_290)/1000 as total_290,sum(total_291)/1000 as total_291,sum(total_292)/1000 as total_292,sum(total_293)/1000 as total_293,sum(total_294)/1000 as total_294,sum(total_295)/1000 as total_295,sum(total_296)/1000 as total_296,sum(total_297)/1000 as total_297,sum(total_298)/1000 as total_298,sum(total_299)/1000 as total_299,sum(total_300)/1000 as total_300,sum(total_301)/1000 as total_301,sum(total_302)/1000 as total_302,sum(total_304)/1000 as total_304,sum(total_305)/1000 as total_305,sum(total_306)/1000 as total_306,sum(total_307)/1000 as total_307,sum(total_308)/1000 as total_308,sum(total_310)/1000 as total_310,sum(total_312)/1000 as total_312,sum(total_313)/1000 as total_313,sum(total_315)/1000 as total_315,sum(total_317)/1000 as total_317,sum(total_321)/1000 as total_321 from (
                    select im.customers_id,sum(id.price*id.qty) as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 316 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,sum(id.price*id.qty) as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 309 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,sum(id.price*id.qty) as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 319 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,sum(id.price*id.qty)  as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 318 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,sum(id.price*id.qty) as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 280 where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,sum(id.price*id.qty) as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 281 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,sum(id.price*id.qty) as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 282 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,sum(id.price*id.qty) as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 283 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,sum(id.price*id.qty) as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 284 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,sum(id.price*id.qty) as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 285 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,sum(id.price*id.qty) as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 286 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,sum(id.price*id.qty) as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 287  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,sum(id.price*id.qty) as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 288 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,sum(id.price*id.qty) as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 289 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,sum(id.price*id.qty) as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 290 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,sum(id.price*id.qty) as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 291 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,sum(id.price*id.qty) as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 292 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,sum(id.price*id.qty) as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 293 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,sum(id.price*id.qty) as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 294 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,sum(id.price*id.qty) as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 295 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,sum(id.price*id.qty) as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 296 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,sum(id.price*id.qty) as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 297 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,sum(id.price*id.qty) as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 298 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,sum(id.price*id.qty) as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 299 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,sum(id.price*id.qty) as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 300 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,sum(id.price*id.qty) as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 301 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,sum(id.price*id.qty) as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 302 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,sum(id.price*id.qty) as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 304  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,sum(id.price*id.qty) as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 305 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,sum(id.price*id.qty) as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 306 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,sum(id.price*id.qty) as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 307 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,sum(id.price*id.qty) as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 308 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,sum(id.price*id.qty) as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 310 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,sum(id.price*id.qty) as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 312 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,sum(id.price*id.qty) as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 313 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,sum(id.price*id.qty) as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 315 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,sum(id.price*id.qty) as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 317  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,sum(id.price*id.qty) as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 321 where im.dated='".$filter_begin_date."'   group by im.customers_id
            ) a
        ");

        $dtt_raw_oneline_disc = DB::select("select sum(total_316)/1000 as total_316,sum(total_309)/1000 as total_309,sum(total_318)/1000 as total_318,sum(total_319)/1000 as total_319,sum(total_280)/1000 as total_280,sum(total_281)/1000 as total_281,sum(total_282)/1000 as total_282,sum(total_283)/1000 as total_283,sum(total_284)/1000 as total_284,sum(total_285)/1000 as total_285,sum(total_286)/1000 as total_286,sum(total_287)/1000 as total_287,sum(total_288)/1000 as total_288,sum(total_289)/1000 as total_289,sum(total_290)/1000 as total_290,sum(total_291)/1000 as total_291,sum(total_292)/1000 as total_292,sum(total_293)/1000 as total_293,sum(total_294)/1000 as total_294,sum(total_295)/1000 as total_295,sum(total_296)/1000 as total_296,sum(total_297)/1000 as total_297,sum(total_298)/1000 as total_298,sum(total_299)/1000 as total_299,sum(total_300)/1000 as total_300,sum(total_301)/1000 as total_301,sum(total_302)/1000 as total_302,sum(total_304)/1000 as total_304,sum(total_305)/1000 as total_305,sum(total_306)/1000 as total_306,sum(total_307)/1000 as total_307,sum(total_308)/1000 as total_308,sum(total_310)/1000 as total_310,sum(total_312)/1000 as total_312,sum(total_313)/1000 as total_313,sum(total_315)/1000 as total_315,sum(total_317)/1000 as total_317,sum(total_321)/1000 as total_321 from (
                    select im.customers_id,sum(id.total) as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 316 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,sum(id.total) as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 309 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,sum(id.total) as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 319 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,sum(id.total)  as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 318 where im.dated='".$filter_begin_date."'  group by im.customers_id,im.scheduled_at
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,sum(id.total) as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 280 where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,sum(id.total) as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 281 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,sum(id.total) as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 282 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,sum(id.total) as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 283 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,sum(id.total) as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 284 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,sum(id.total) as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 285 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,sum(id.total) as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 286 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,sum(id.total) as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 287  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,sum(id.total) as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 288 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,sum(id.total) as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 289 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,sum(id.total) as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 290 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,sum(id.total) as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 291 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,sum(id.total) as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 292 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,sum(id.total) as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 293 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,sum(id.total) as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 294 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,sum(id.total) as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 295 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,sum(id.total) as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 296 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,sum(id.total) as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 297 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,sum(id.total) as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 298 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,sum(id.total) as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 299 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,sum(id.total) as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 300 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,sum(id.total) as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 301 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,sum(id.total) as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 302 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,sum(id.total) as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 304  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,sum(id.total) as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 305 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,sum(id.total) as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 306 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,sum(id.total) as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 307 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,sum(id.total) as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 308 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,sum(id.total) as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 310 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,sum(id.total) as total_312,0 as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 312 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,sum(id.total) as total_313,0 as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 313 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,sum(id.total) as total_315,0 as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 315 where im.dated='".$filter_begin_date."'   group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,sum(id.total) as total_317,0 as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 317  where im.dated='".$filter_begin_date."'  group by im.customers_id
                    union
                    select im.customers_id,0 as total_316,0 as total_309,0 as total_318,0 as total_319,0 as total_280,0 as total_281,0 as total_282,0 as total_283,0 as total_284,0 as total_285,0 as total_286,0 as total_287,0 as total_288,0 as total_289,0 as total_290,0 as total_291,0 as total_292,0 as total_293,0 as total_294,0 as total_295,0 as total_296,0 as total_297,0 as total_298,0 as total_299,0 as total_300,0 as total_301,0 as total_302,0 as total_304,0 as total_305,0 as total_306,0 as total_307,0 as total_308,0 as total_310,0 as total_312,0 as total_313,0 as total_315,0 as total_317,sum(id.total) as total_321 from invoice_master im join invoice_detail id on id.invoice_no = im.invoice_no join product_sku ps on ps.id = id.product_id  and ps.id = 321 where im.dated='".$filter_begin_date."'   group by im.customers_id
            ) a
        "
        );

        

        //Buat hard ciode column berdasarkan banyak perawatan, perwatan yg tidak ada pembelian akan di hide

        $petty_datas = DB::select("
            select ps.abbr,pc.type,sum(pcd.qty) as qty,sum(pcd.line_total) as total  from petty_cash pc 
            join petty_cash_detail pcd on pcd.doc_no = pc.doc_no
            join product_sku ps on ps.id = pcd.product_id 
            where pc.dated  = '".$filter_begin_date."'  and pc.branch_id = ".$filter_branch_id."  
            group by ps.abbr,pc.type order by 1                   
        ");

        $cust = DB::select("
                select count(distinct c.id) as c_cus
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."                      
        ");
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.reports.daily_print', [
            'data' => $data,
            'payment_datas' => $payment_data,
            'report_datas' => $report_data,
            'petty_datas' => $petty_datas,
            'cust' => $cust,
            'dtt_detail' => $dtt_detail,
            'dtt_raw_oneline' => $dtt_raw_oneline,
            'dtt_raw_oneline_discs' => $dtt_raw_oneline_disc,
            'dtt_raw' => $dtt_raw,
            'dtt_item_only' => $dtt_item_only,
            'dtt_item_only2' => $dtt_item_only,
            'dtt_item_only_total' => $dtt_item_only_total,
            'out_datas_total_drink' => $out_datas_total_drink,
            'out_datas_total_other' => $out_datas_total_other,
            'out_datas' => $out_datas,
            'out_datas_total' => $out_datas_total,
            'settings' => Settings::get(),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('report_daily.pdf');
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
        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        
        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $branchx = $request->filter_branch_id_in;
        $shift_id = $request->filter_shift_id_in;

        if($request->export=='Export Excel'){
             $strencode = base64_encode($shift_id.'#'.$begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new CloseDayExport($strencode), 'closeday_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
                    select b.id as branch_id,b.remark as branch_name,im.dated,sum(id.total+id.vat_total) as total_all,
                    sum(case when ps.type_id = 2 then id.total+id.vat_total else 0 end) as total_service,
                    sum(case when ps.type_id = 1 and ps.category_id !=12 then id.total+id.vat_total else 0 end) as total_product,
                    sum(case when ps.type_id = 1 and ps.category_id =12 then id.total+id.vat_total else 0 end) as total_drink,
                    sum(case when ps.type_id = 8 then id.total+id.vat_total else 0 end) as total_extra,
                    sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
                    sum(case when im.payment_type = 'BCA - Debit' then id.total+id.vat_total else 0 end) as total_b_d,
                    sum(case when im.payment_type = 'BCA - Kredit' then id.total+id.vat_total else 0 end) as total_b_k,
                    sum(case when im.payment_type = 'Mandiri - Debit' then id.total+id.vat_total else 0 end) as total_m_d,
                    sum(case when im.payment_type = 'Mandiri - Kredit' then id.total+id.vat_total else 0 end) as total_m_k,
                     sum(case when im.payment_type = 'QRIS' then id.total+id.vat_total else 0 end) as total_qr,
                     sum(case when im.payment_type = 'Transfer' then id.total+id.vat_total else 0 end) as total_tr,
                    count(distinct im.invoice_no) qty_transaction,count(distinct im.customers_id) qty_customers
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no  = im.invoice_no 
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                    join branch b on b.id = c.branch_id
                    where im.dated between '".$begindate."' and '".$enddate."'
                    group by b.remark,im.dated,b.id         
            ");         
            return view('pages.reports.close_day',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
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
           })->orderby('permissions.name')->orderby('permissions.remark')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

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