<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\Voucher;
use App\Models\JobTitle;
use App\Models\Order;
use App\Models\LotNumber;
use App\Models\Customer;
use App\Models\Settings;
use App\Models\SettingsDocumentNumber;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\OrdersExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use App\Models\Company;
use App\Models\Currency;
use Barryvdh\DomPDF\Facade\Pdf;
use charlieuki\ReceiptPrinter\ReceiptPrinter as ReceiptPrinter;
use App\Http\Controllers\Lang;


class LotNumberController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="orders",$id=1;

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

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        $orders = DB::select("select l.id,l.doc_no,ps.remark,b.remark as branch_name,l.qty_available,l.qty_onhand,l.qty_allocated
        from lot_number l
        join product_sku ps on ps.id = l.product_id 
        join branch b on b.id  = l.branch_id 
        join users_branch ub on ub.branch_id = b.id and ub.user_id = ?;", [ $user->id ]);
        return view('pages.lotnumber.index',['company' => Company::get()->first()], compact('orders','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
    }


    public function update_lotno(Request $request) 
    {
        $user = Auth::user();

        DB::update('update lot_number set updated_at= now(),qty_onhand = (select sum(coalesce(rd.qty,0))  from receive_master rm 
                            join receive_detail rd on rd.receive_no = rm.receive_no where rd.lot_no = ? ) where doc_no = ? ', [ $request->doc_no, $request->doc_no ]);

        DB::update('update lot_number set updated_at= now(),qty_onhand = qty_onhand-(select sum(coalesce(sa.qty_served,0))  from stock_allocation sa 
                            join invoice_master im on im.invoice_no = sa.doc_no 
                            join invoice_detail id on id.invoice_no = im.invoice_no and id.product_id = sa.product_id 
                            where sa.lot_no = ? ) where doc_no = ? ', [ $request->doc_no, $request->doc_no ]);
        DB::update('update lot_number set qty_available = (qty_onhand - qty_allocated) where doc_no = ? ', [ $request->doc_no ]);

        DB::update("update product_stock set updated_at=now(),qty = (select sum(coalesce(qty_available,0)) from lot_number where product_id = ".$request->product_id." and branch_id = ".$request->branch_id." ) 
                    where product_id = ".$request->product_id." and branch_id = ".$request->branch_id.";", []);

        DB::update("update period_stock set balance_end = (select sum(coalesce(qty_available,0)) from lot_number where product_id = ".$request->product_id." and branch_id = ".$request->branch_id." ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$request->product_id." and branch_id = ".$request->branch_id.";", []);
        DB::update("update period_stock set qty_out = (select sum(coalesce(sa.qty_served,0))  from stock_allocation sa 
                            join invoice_master im on im.invoice_no = sa.doc_no 
                            join customers c on c.id = im.customers_id
                            join invoice_detail id on id.invoice_no = im.invoice_no and id.product_id = sa.product_id  where id.product_id = ".$request->product_id." and c.branch_id = ".$request->branch_id." and to_char(im.dated,'YYYYMM')::int=to_char(now()::date,'YYYYMM')::int ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$request->product_id." and branch_id = ".$request->branch_id.";", []);

        DB::update("update period_stock set qty_in = (select sum(coalesce(rd.qty,0))  from receive_master rm 
        join receive_detail rd on rd.receive_no = rm.receive_no where rd.product_id = ".$request->product_id." and rm.branch_id = ".$request->branch_id." and to_char(rm.dated,'YYYYMM')::int=to_char(now()::date,'YYYYMM')::int ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$request->product_id." and branch_id = ".$request->branch_id.";", []);


        $result = array_merge(
            ['status' => 'success'],
            ['data' =>  $request->doc_no],
            ['message' => ''],
        );

        return $result;
    }


    /**
     * Show user data
     * 
     * @param Order $order
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(LotNumber $lotnumber) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);


        $data = $this->data;
        $user = Auth::user();
        $doc_data = DB::select("select l.id,l.doc_no,ps.remark,l.product_id,b.id as branch_id,b.remark as branch_name,l.qty_available,l.qty_onhand,l.qty_allocated
        from lot_number l
        join product_sku ps on ps.id = l.product_id 
        join branch b on b.id  = l.branch_id 
        join users_branch ub on ub.branch_id = b.id and ub.user_id = ? and l.id = ?;", [ $user->id, $lotnumber->id]);

        $in = DB::select('select rm.dated,rd.receive_no as doc_no,rd.product_remark,rd.qty  from receive_master rm 
                            join receive_detail rd on rd.receive_no = rm.receive_no where rd.lot_no = ?
                            order by rm.dated asc; ', [ $lotnumber->doc_no ]);
        $out = DB::select('select im.dated,id.invoice_no as doc_no,id.product_name,sa.qty_order,sa.qty_served  from stock_allocation sa 
                            join invoice_master im on im.invoice_no = sa.doc_no 
                            join invoice_detail id on id.invoice_no = im.invoice_no and id.product_id = sa.product_id 
                            where sa.lot_no = ?
                            order by im.dated,im.invoice_no asc; ', [ $lotnumber->doc_no ]);

        return view('pages.lotnumber.show',[
            'data' => $data,
            'order' => $doc_data[0],
            'in' => $in,
            'out' => $out,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']),
            'company' => Company::get()->first(),
        ]);
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
