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
use App\Exports\ReportPurchaseExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ReportPurchaseController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="reports.purchase",$id=1;

    public function __construct()
    {
        $this->middleware(function ($request, $next) {
            $this->user= Auth::user();
            $user = Auth::user();
            $role_id = $user->roles->first()->id;

            $this->act_permission = DB::select("
                select sum(coalesce(allow_create,0)) as allow_create,sum(coalesce(allow_delete,0)) as allow_delete,sum(coalesce(allow_show,0)) as allow_show,sum(coalesce(allow_edit,0)) as allow_edit from (
                    select count(1) as allow_create,0 as allow_delete,0 as allow_show,0 as allow_edit from permissions p join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.create' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,count(1) as allow_delete,0 as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.delete' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,count(1) as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.show' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,0 as allow_show,count(1) as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.edit' and p.name like '".$this->module.".%'
                ) a
            ");   
            return $next($request);
        });   
    }

    public function index(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $report_data = DB::select("
        select b.remark as branch_name,im.dated,im.purchase_no,id.product_remark as product_name ,pc.remark as category_name,id.qty,id.uom,
        id.subtotal_vat+id.subtotal  as total
       from purchase_master im 
       join purchase_detail id on id.purchase_no = im.purchase_no 
       join product_sku ps on ps.id = id.product_id 
       join product_category pc on pc.id = ps.category_id 
       join suppliers c on c.id = im.supplier_id 
       join users u on u.id=im.created_by
       join branch b on b.id = c.branch_id
       where im.dated>now()-interval'7 days' order by im.purchase_no               
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        return view('pages.reports.purchase',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
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

        if($request->export=='Export Excel'){
             $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new ReportPurchaseExport($strencode), 'report_purchase_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
            select b.remark as branch_name,im.dated,im.purchase_no,id.product_remark as product_name ,pc.remark as category_name,id.qty,id.uom,
            id.subtotal_vat+id.subtotal  as total
           from purchase_master im 
           join purchase_detail id on id.purchase_no = im.purchase_no 
           join product_sku ps on ps.id = id.product_id 
           join product_category pc on pc.id = ps.category_id 
           join suppliers c on c.id = im.supplier_id  and im.branch_id::character varying like '%".$branchx."%'
           join users u on u.id=im.created_by
           join branch b on b.id = c.branch_id
           where im.dated between '".$begindate."' and '".$enddate."'                  
            ");         
            return view('pages.reports.purchase',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
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
                        'display' => '', 
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.product_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
		            [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.service_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => \Lang::get('home.transaction'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => \Lang::get('home.reports'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => \Lang::get('home.settings'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ]  
                ]      
        ];

        $c_user = 0;
        $c_product = 0;
        $c_service = 0;
        $c_trans = 0;
        $c_report = 0;
        $c_setting = 0;

        foreach ($permissions as $key => $menu) {
            if($menu['parent']=='Users'){
                $c_user++;
                array_push($this->data['menu'][0]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                $c_product++;
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                $c_service++;
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                $c_trans++;
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                $c_report++;
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                $c_setting++;
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
        }

        if($c_user == 0){
            $this->data['menu'][0]['display'] = 'd-none';
        }
        if($c_product == 0){
            $this->data['menu'][1]['display'] = 'd-none';
        }

        if($c_service == 0){
            $this->data['menu'][2]['display'] = 'd-none';
        }

        if($c_trans == 0){
            $this->data['menu'][3]['display'] = 'd-none';
        }

        if($c_report == 0){
            $this->data['menu'][4]['display'] = 'd-none';
        }

        if($c_setting == 0){
            $this->data['menu'][5]['display'] = 'd-none';
        }
    }
}