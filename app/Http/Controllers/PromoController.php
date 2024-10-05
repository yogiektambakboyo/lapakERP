<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Product;
use App\Models\Voucher;
use App\Models\Promo;
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


class PromoController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="promo",$id=1;

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
        $orders = DB::select("select pm.id,b.remark as branch_name,ps.remark as product_name,pm.doc_no,pm.remark,pm.product_id,pm.value_nominal,pm.value_idx,pm.dated_start,pm.dated_end,pm.is_term 
                                from promo_master pm 
                                join product_sku ps on ps.id = pm.product_id 
                                join branch b on b.id  = pm.branch_id 
                                join users_branch ub on ub.branch_id = b.id and ub.user_id = ?;", [ $user->id ]);
        return view('pages.promo.index',['company' => Company::get()->first()], compact('orders','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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

        $user  = Auth::user();
        $data = $this->data;
        return view('pages.promo.create',[
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps order by ps.remark;'),
            'data' => $data, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param Promo $promo
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Promo $promo, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $doc_no = "DIS-".$request->get('branch_id').'-'.date('YmdHis');
        $user = Auth::user();
        $promo->create(
            array_merge(
                ['value_idx' => $request->get('value_idx') ],
                ['value_nominal' => $request->get('value_nominal') ],
                ['dated_start' => Carbon::parse($request->get('dated_start'))->format('Y-m-d') ],
                ['dated_end' => Carbon::parse($request->get('dated_end'))->format('Y-m-d') ],
                ['product_id' => $request->get('product_id') ],
                ['branch_id' => $request->get('branch_id') ],
                ['remark' => $request->get('remark') ],
                ['is_term' => $request->get('is_term') ],
                ['doc_no' => $doc_no ],
                ['created_by' => $user->id ],
                
            )
        );
        return redirect()->route('promo.index')
            ->withSuccess(__('Promo created successfully.'));
    }

    /**
     * Edit user data
     * 
     * @param Promo $promo
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Promo $promo) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $promo_detail = DB::select("select pd.doc_no,pd.product_id,pd.qty,ps.remark  from promo_detail pd
                                    join promo_master pm on pm.doc_no = pd.doc_no 
                                    join product_sku ps on ps.id = pd.product_id 
                                    where pd.doc_no = ?;", [$promo->doc_no]);
        $promo = DB::select("select id,remark,product_id,value_nominal,value_idx::int value_idx,to_char(dated_start,'dd-MM-YYYY') dated_start,to_char(dated_end,'dd-MM-YYYY') dated_end,is_term,doc_no,branch_id  from promo_master where id = ?", [$promo->id]);
        
        return view('pages.promo.edit', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'promo' => $promo[0], 
            'promo_detail' => $promo_detail, 
            'company' => Company::get()->first(),
            'products' => Product::get(),
        ]);
    }

     /**
     * Update user data
     * 
     * @param Promo $promo
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request) 
    {
        $user = Auth::user();
        Promo::where('id','=',$request->id)
                        ->update(
                            array_merge(
                                ['remark' => $request->get('remark') ],
                                ['value_idx' => $request->get('value_idx') ],
                                ['value_nominal' => $request->get('value_nominal') ],
                                ['dated_start' => Carbon::parse($request->get('dated_start'))->format('Y-m-d') ],
                                ['dated_end' => Carbon::parse($request->get('dated_end'))->format('Y-m-d') ],
                                ['product_id' => $request->get('product_id') ],
                                ['is_term' => $request->get('is_term') ],
                                ['updated_by' => $user->id ],
                            )
                        );
        
        return redirect()->route('promo.index')
            ->withSuccess(__('Promo updated successfully.'));
    }


    public function promolist(Request $request) 
    {
        $user = Auth::user();
        $dated = Carbon::parse($request->get('invoice_date'))->format('Y-m-d');

        $promo_no_term = DB::select("select pm.id,pm.remark,pm.product_id,pm.value_nominal,pm.value_idx 
                                        from promo_master pm
                                        join users_branch ub on ub.branch_id = pm.branch_id and ub.user_id = ".$user->id."
                                        where pm.is_term = 0 and '".$dated."' between pm.dated_start and pm.dated_end;", []);
        $promo_term = DB::select("select pm.id,pm.remark,pm.product_id,pm.value_nominal,pm.value_idx 
                                        from promo_master pm
                                        join users_branch ub on ub.branch_id = pm.branch_id and ub.user_id = ".$user->id."
                                        where pm.is_term = 1 and '".$dated."' between pm.dated_start and pm.dated_end;", []);
        $promo_detail = DB::select("select pd.doc_no,pd.product_id,pd.qty,pd.value_nominal  
                                    from promo_master pm
                                    join users_branch ub on ub.branch_id = pm.branch_id and ub.user_id = ".$user->id."
                                    join promo_detail pd on pd.doc_no = pd.doc_no 
                                    where pm.is_term = 0 and '".$dated."' between pm.dated_start and pm.dated_end;", []);

        $result = array_merge(
            ['status' => 'success'],
            ['promo_no_term' =>  $promo_no_term],
            ['promo_term' =>  $promo_term],
            ['promo_detail' =>  $promo_detail],
            ['message' => ''],
        );

        return $result;
    }

    public function destroydetail(Request $request) 
    {
        $user = Auth::user();
        
        $product_id = $request->get('product_id');
        $doc_no = $request->get('doc_no');
        $promo_no_term = DB::select("delete from promo_detail where doc_no=? and product_id=?;", [$doc_no, $product_id]);

        $result = array_merge(
            ['status' => 'success'],
            ['data' =>  $doc_no],
            ['message' => 'Success'],
        );

        return $result;
    }

    public function storedetail(Request $request) 
    {
        $user = Auth::user();
        
        $product_id = $request->get('product_id');
        $doc_no = $request->get('doc_no');
        $qty = $request->get('qty');
        $promo_no_term = DB::select("INSERT INTO public.promo_detail(doc_no, product_id, qty, created_at, created_by) VALUES('".$doc_no."', ".$product_id.", ".$qty.", now(), 1);", []);

        $result = array_merge(
            ['status' => 'success'],
            ['data' =>  $doc_no],
            ['message' => 'Success'],
        );

        return $result;
    }


    /**
     * Show user data
     * 
     * @param Promo $promo
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Promo $promo) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $promo = DB::select("select id,remark,product_id,value_nominal,value_idx::int value_idx,to_char(dated_start,'dd-MM-YYYY') dated_start,to_char(dated_end,'dd-MM-YYYY') dated_end,is_term,doc_no,branch_id  from promo_master where id = ?", [$promo->id]);
        return view('pages.promo.show', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'promo' => $promo[0], 
            'company' => Company::get()->first(),
            'products' => Product::get(),
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
