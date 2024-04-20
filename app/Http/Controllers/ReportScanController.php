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
use App\Exports\ReportInvoicesExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ReportScanController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="reports.scan",$id=1;

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
            select sa.doc_no,sa.dated,sa.sales_id,s.name,sa.created_at,sd.product_name,sd.lot_number,sd.point,coalesce(sa.photofile,'-') photofile  
            from scan_activity sa 
            join sales s on s.id = sa.sales_id
            join scan_activity_detail sd on sd.doc_no = sa.doc_no             
        ");

        $sales_data = DB::select("
            select id,name from sales s where s.active = 1 order by s.name          
        ");

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        return view('pages.reports.scan',['company' => Company::get()->first()], compact('shifts','sales_data','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function get_transaction(Request $request)
    {  
        $res_data = $request->get('detail');
        $c_token = $request->get('token');
        $s_token = md5(date('Ymd'));

       

        if($request->get('user_agent')=="BaliFoamv1" && $c_token == $s_token){
            $begin_dated = $request->get('begin_date');
            $end_dated = $request->get('end_date');

            $dated_1 = Carbon::parse($begin_dated);
            $dated_2 = Carbon::parse($end_dated);
    
            $diff = $dated_1->diffInDays($dated_2);

            if($diff<=10){
                $res_data = DB::select(" select sa.doc_no,sa.dated,sa.sales_id,s.name,sa.created_at,sd.product_name,sd.lot_number,sd.point  
                from scan_activity sa 
                join sales s on s.id = sa.sales_id
                join scan_activity_detail sd on sd.doc_no = sa.doc_no  where sa.dated between '".$begin_dated."' and   '".$end_dated."' ;  ");

                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $res_data ],
                    ['message' => 'Success get '.count($res_data).' data'],
                );
            }else{
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => [] ],
                    ['message' => 'interval date must be lower than 11 Days'],
                );
            }
            
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => [] ],
                ['message' => 'Not authorized'],
            );
        }

        return $result;
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
        $sales = $request->filter_sales;
        $branchx = $request->filter_branch_id_in;
        $shift_id = $request->filter_shift_id_in;

        $sales_data = DB::select("
            select id,name from sales s where s.active = 1 order by s.name          
        ");

        if($request->export=='Export Excel'){
             $strencode = base64_encode($shift_id.'#'.$begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new ReportInvoicesExport($strencode), 'report_invoice_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
                select sa.doc_no,sa.dated,sa.sales_id,s.name,sa.created_at,sd.product_name,sd.lot_number,sd.point,coalesce(sa.photofile,'-') photofile  
                from scan_activity sa 
                join sales s on s.id = sa.sales_id and s.id::character varying like '".$sales."'
                join scan_activity_detail sd on sd.doc_no = sa.doc_no where sa.dated between '".$begindate."' and '".$enddate."'    
                          
            ");         
            return view('pages.reports.scan',['company' => Company::get()->first()], compact('shifts','sales_data','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
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
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
        }


    }
}