<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Customer;
use App\Models\Branch;
use Auth;
use Illuminate\Support\Facades\DB;


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


    public function index()
    {   
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user = Auth::user();
        $Customers = Customer::join('branch as b','b.id','customers.branch_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->get(['customers.*','b.remark as branch_name']);
        $data = $this->data;

        return view('pages.customers.index', [
            'customers' => $Customers,'data' => $data 
            
        ]);
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
 
        $data = $this->data;
        return view('pages.customers.create',['data'=>$data,'branchs' => Branch::latest()->get(),
        'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),]);
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
        $this->getpermissions($id);
        $data = $this->data;
        return view('pages.customers.edit', [
            'customer' => $Customer ,'data' => $data ,'branchs' => Branch::latest()->get(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray()
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
        $Customer->delete();

        return redirect()->route('customers.index')
            ->withSuccess(__('Customer deleted successfully.'));
    }

    public function getpermissions($role_id){
        $id = $role_id;
        $permissions = Permission::join('role_has_permissions',function ($join)  use ($id) {
            $join->on(function($query) use ($id) {
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=',$id)->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
            });
           })->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

        $this->data = [
            'menu' => 
                [
                    [
                        'icon' => 'fa fa-user-gear',
                        'title' => 'User Management',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => 'Product Management',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => 'Transactions',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => 'Reports',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => 'Settings',
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
