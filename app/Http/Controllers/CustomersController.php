<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Customer;
use App\Models\Branch;
use Auth;

class CustomersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data;

    public function __construct()
    {
        // Closure as callback
        $permissions = Permission::join('role_has_permissions',function ($join) {
            $join->on(function($query){
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=','1')->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
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


    public function index()
    {   
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

    /**
     * Show the form for editing the specified resource.
     *
     * @param  Customer  $Customer
     * @return \Illuminate\Http\Response
     */
    public function edit(Customer $Customer)
    {
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
}
