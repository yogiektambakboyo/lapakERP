<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Customer;
use App\Models\CustomersSegment;
use App\Models\Branch;
use App\Models\Sales;
use Auth;
use App\Exports\CustomersExport;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Carbon\Carbon;
use App\Models\Company;
use App\Http\Controllers\Lang;



class CustomersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data,$act_permission,$module="customers",$id=1;

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

        $user = Auth::user();
        $Customers = Customer::join('branch as b','b.id','customers.branch_id')
                            ->join('sales as s','s.id','customers.sales_id')
                            ->join('customers_segment as cs','cs.id','=','customers.segment_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->get(['cs.remark as segment_name','customers.*','s.name  as sellername','b.remark as branch_name']);
        $data = $this->data;

        $request->search = "";
        $request->branch = "";
        $req = $request;
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);

        $act_permission = $this->act_permission[0];
        return view('pages.customers.index', [
            'customers' => $Customers,'data' => $data , 'company' => Company::get()->first(), 'request' => $request, 'branchs' => $branchs , 'act_permission' => $act_permission
            
        ]);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $branchx = $request->filter_branch_id;
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$branchx.'#'.$user->id);
            return Excel::download(new CustomersExport($strencode), 'customers_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->src=='Search'){
            $Customers = Customer::join('branch as b','b.id','customers.branch_id')
                            ->join('sales as s','s.id','customers.sales_id')
                            ->join('customers_segment as cs','cs.id','=','customers.segment_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->where('customers.branch_id','like','%'.$branchx.'%')->where('customers.name','ILIKE','%'.$keyword.'%')->get(['cs.remark as segment_name','customers.*','s.name  as sellername','b.remark as branch_name']);
            $request->filter_branch_id = "";
            return view('pages.customers.index', [
                'customers' => $Customers,'data' => $data , 
                'company' => Company::get()->first(),
                'request' => $request,
                'branchs' => $branchs,
                'act_permission' => $act_permission
            ]);
        }else{
            $Customers = Customer::join('branch as b','b.id','customers.branch_id')
                           ->join('sales as s','s.id','customers.sales_id')
                           ->join('customers_segment as cs','cs.id','=','customers.segment_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->where('customers.branch_id','like','%'.$branchx.'%')->where('customers.name','ILIKE','%'.$keyword.'%')->get(['cs.remark as segment_name','customers.*','s.name as sellername','b.remark as branch_name']);
            return view('pages.customers.index', [
                'customers' => $Customers,'data' => $data , 
                'company' => Company::get()->first(),
                'request' => $request,
                'branchs' => $branchs,
                'act_permission' => $act_permission
            ]);
        }
    }


    /**
     * Show form for creating Customer
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {  
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $sellers = Sales::join('users_branch as ub','ub.branch_id','=','sales.branch_id')->where('ub.user_id','=',$user->id)->orderBy('sales.name')->get(['sales.id','sales.name']);
        $data = $this->data;
        return view('pages.customers.create',
        [
            'data'=>$data,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']), 
            'company' => Company::get()->first(),
            'segments' => CustomersSegment::get()->first(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'sellers' => $sellers,
            'segments' => CustomersSegment::orderBy('remark','asc')->get(['id','remark']),
        ]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {   
        Customer::create(
            array_merge( 
                ['phone_no' => $request->get('phone_no') ],
                ['name' => $request->get('name') ],
                ['address' => $request->get('address') ],
                ['membership_id' => '1' ],
                ['abbr' => '1' ],
                ['branch_id' => $request->get('branch_id') ],
                ['sales_id' => $request->get('sales_id') ],
                ['city' => $request->get('city') ],
                ['credit_limit' => $request->get('credit_limit') ],
                ['longitude' => $request->get('longitude') ],
                ['latitude' => $request->get('latitude') ],
                ['email' => $request->get('email') ],
                ['handphone' => $request->get('handphone') ],
                ['whatsapp_no' => $request->get('whatsapp_no') ],
                ['citizen_id' => $request->get('citizen_id') ],
                ['tax_id' => $request->get('tax_id') ],
                ['contact_person' => $request->get('contact_person') ],
                ['type' => $request->get('type') ],
                ['clasification' => $request->get('clasification') ],
                ['contact_person_job_position' => $request->get('contact_person_job_position') ],
                ['contact_person_level' => $request->get('contact_person_level') ],
                ['visit_day' => $request->get('input_day') ],
                ['visit_week' => $request->get('input_week') ],
                ['external_code' => $request->get('external_code') ],
                ['segment_id' => $request->get('segment_id') ],
            )
        );
        return redirect()->route('customers.index')
            ->withSuccess(__('Customer created successfully.'));
    }

    public function storeapi(Request $request)
    {   
    
        Customer::create(
            array_merge( 
                ['phone_no' => $request->get('phone_no') ],
                ['name' => $request->get('name') ],
                ['address' => $request->get('address') ],
                ['membership_id' => '1' ],
                ['abbr' => '1' ],
                ['branch_id' => $request->get('branch_id') ],
            )
        );

        $id = Customer::where('name','=',$request->get('name'))->max('id');
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $id],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  Customer  $Customer
     * @return \Illuminate\Http\Response
     */
    public function edit(Customer $Customer)
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $sellers = Sales::where('branch_id','=',$Customer->branch_id)->get(['id','name']);
        $this->getpermissions($id);
        $data = $this->data;
        $sellers = Sales::join('users_branch as ub','ub.branch_id','=','sales.branch_id')->where('ub.user_id','=',$user->id)->orderBy('sales.name')->get(['sales.id','sales.name']);
        return view('pages.customers.edit', [
            'customer' => $Customer ,'data' => $data ,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'company' => Company::get()->first(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'segments' => CustomersSegment::orderBy('remark','asc')->get(['id','remark']),
            'sellers' => $sellers,
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  Customer  $Customer
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Customer $customer)
    {
        Customer::where('id', $customer->id)
        ->update(
            array_merge( 
                ['phone_no' => $request->get('phone_no') ],
                ['name' => $request->get('name') ],
                ['address' => $request->get('address') ],
                ['membership_id' => '1' ],
                ['abbr' => '1' ],
                ['branch_id' => $request->get('branch_id') ],
                ['sales_id' => $request->get('sales_id') ],
                ['city' => $request->get('city') ],
                ['credit_limit' => $request->get('credit_limit') ],
                ['longitude' => $request->get('longitude') ],
                ['latitude' => $request->get('latitude') ],
                ['email' => $request->get('email') ],
                ['handphone' => $request->get('handphone') ],
                ['whatsapp_no' => $request->get('whatsapp_no') ],
                ['citizen_id' => $request->get('citizen_id') ],
                ['tax_id' => $request->get('tax_id') ],
                ['contact_person' => $request->get('contact_person') ],
                ['type' => $request->get('type') ],
                ['clasification' => $request->get('clasification') ],
                ['contact_person_job_position' => $request->get('contact_person_job_position') ],
                ['contact_person_level' => $request->get('contact_person_level') ],
                ['visit_day' => $request->get('input_day') ],
                ['visit_week' => $request->get('input_week') ],
                ['external_code' => $request->get('external_code') ],
                ['segment_id' => $request->get('segment_id') ],
            )
        );

        return redirect()->route('customers.index')
            ->withSuccess(__('Customer updated successfully.'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function destroy(Customer $Customer)
    {
        if($Customer->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $Customer->name],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $Customer->name],
                ['message' => 'Delete failed'],
            );   
        }
        return $result;
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
