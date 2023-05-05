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
use App\Exports\ReportStockMutationExport;
use App\Exports\ReportStockMutationDetailExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ReportStockMutationDetailController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="reports.stockmutationdetail",$id=1;

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
        $period = DB::select("select period_no,remark from period where period_no<=to_char(now(),'YYYYMM')::int and period_no>=202301  order by period_no desc");
        $report_data = DB::select("
            select branch_name,dated,product_name,sum(qty_in) as qty_in,sum(qty_out) as qty_out from (
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in  from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c ON c.id = im.customers_id
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = c.branch_id and b.id::character varying like '%'
                where dated between (now()-interval'2 days')::date and now()::date
                union 
                select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps.remark as product_name,id.qty*pi2.qty as qty_out,0  as qty_in  from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c ON c.id = im.customers_id
                join product_sku ps on ps.id = id.product_id
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material 
                join branch b on b.id = c.branch_id and b.id::character varying like '%'
                where dated between (now()-interval'2 days')::date and now()::date
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in  from petty_cash im 
                join petty_cash_detail id on id.doc_no  = im.doc_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '%'
                where im.dated between (now()-interval'2 days')::date and now()::date and im.type='Produk - Keluar'
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty  as qty_in  from petty_cash im 
                join petty_cash_detail id on id.doc_no  = im.doc_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '%'
                where im.dated between (now()-interval'2 days')::date and now()::date and im.type='Produk - Masuk'
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty as qty_in  from receive_master im 
                join receive_detail id on id.receive_no = im.receive_no 
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '%'
                where dated between (now()-interval'2 days')::date and now()::date
            ) a join users_branch ub on ub.branch_id = a.branch_id 
            where ub.user_id = ".$user->id."
            group by a.branch_id,a.branch_name,a.dated,product_name order by 1,2,3   
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        return view('pages.reports.stockmutationdetail',['company' => Company::get()->first()], compact('period','shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $period = DB::select("select period_no,remark from period where period_no<=to_char(now(),'YYYYMM')::int and period_no>=202301  order by period_no desc");
        
        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $branchx = $request->filter_branch_id_in;

    
        if($request->export=='Export Excel'){
            $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id);
            return Excel::download(new ReportStockMutationDetailExport($strencode), 'report_stockmutation_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
            select branch_name,dated,product_name,sum(qty_in) as qty_in,sum(qty_out) as qty_out from (
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in  from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c ON c.id = im.customers_id
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = c.branch_id and b.id::character varying like '".$branchx."'
                where dated between '".$begindate."' and '".$enddate."'
                union 
                select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,id.qty*pi2.qty as qty_out,0  as qty_in  from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c ON c.id = im.customers_id
                join product_sku ps on ps.id = id.product_id
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material 
                join branch b on b.id = c.branch_id and b.id::character varying like '".$branchx."'
                where dated between '".$begindate."' and '".$enddate."'
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,id.qty as qty_out,0  as qty_in  from petty_cash im 
                join petty_cash_detail id on id.doc_no  = im.doc_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '".$branchx."'
                where im.dated between '".$begindate."' and '".$enddate."' and im.type='Produk - Keluar'
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty  as qty_in  from petty_cash im 
                join petty_cash_detail id on id.doc_no  = im.doc_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '".$branchx."'
                where im.dated between '".$begindate."' and '".$enddate."' and im.type='Produk - Masuk'
                union
                select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,id.qty as qty_in  from receive_master im 
                join receive_detail id on id.receive_no = im.receive_no 
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                join branch b on b.id = im.branch_id and b.id::character varying like '".$branchx."'
                where dated between '".$begindate."' and '".$enddate."'
            ) a join users_branch ub on ub.branch_id = a.branch_id 
            where ub.user_id = ".$user->id."
            group by a.branch_id,a.branch_name,a.dated,product_name    order by 1,2,3        
            ");         
            return view('pages.reports.stockmutationdetail',['company' => Company::get()->first()], compact('period','shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
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