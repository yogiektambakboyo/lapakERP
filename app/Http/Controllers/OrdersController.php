<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\Customer;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\UsersExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;


class OrdersController extends Controller
{
    /**
     * Display all users
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

    public function index(Request $request) 
    {
        $data = $this->data;
        $keyword = "";
        
        $orders = Order::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','order_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->paginate(10,['order_master.id','b.remark as branch_name','order_master.order_no','order_master.dated','jt.name as customer','order_master.total','order_master.total_discount','total_payment' ]);
        return view('pages.orders.index', compact('orders','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $keyword = $request->search;
        $data = $this->data;

        if($request->export=='Export Excel'){
            return Excel::download(new UsersExport($keyword), 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.name','LIKE','%'.$keyword.'%')->paginate(10,['users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date' ]);
            return view('pages.orders.index', compact('users','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new UsersExport, 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
    }

    /**
     * Show form for creating user
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {
        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','Debit Card'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.create',[
            'customers' => Customer::latest()->get()->where('branch_id',$user->branch_id),
            'data' => $data,
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type,
        ]);
    }

    public function getproduct() 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        where product_sku.active = '1' and pd.branch_id = '".$user->branch_id."';");
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return '<a href="#"  onclick="addProduct(\''.$product->id.'\',\''.$product->abbr.'\', \''.$product->price.'\', \'0\', \'1\');" class="btn btn-xs btn-primary"><div class="fa-1x"><i class="fas fa-basket-shopping fa-fw"></i></div></a>';
        })->make();
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param Order $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
        
        $user = Auth::user();
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();
        $order_no = 'ORD-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.(Order::count() + 1)),-8);

        Order::create(
            array_merge(
                ['order_no' => $order_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('d/m/Y') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
            )
        );


        for ($i=0; $i < count($request->get('product')); $i++) { 
            OrderDetail::create(
                array_merge(
                    ['order_no' => $order_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['seq' => $i ],
                    ['assigned_to' => $user->id],
                    ['referral_by' => $user->id],
                )
            );
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $order_no],
        );

        return $result;
    }

    /**
     * Show user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(User $user) 
    {
        $data = $this->data;
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        $users = User::join('branch as b','b.id','=','users.branch_id')->join('department as dt','dt.id','=','users.department_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.id','=',$user->id)->get(['dt.remark as department','users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date',"users.phone_no","users.email","users.username","users.address","users.netizen_id","users.photo_netizen_id","users.photo","users.join_years","users.active","users.referral_id","users.city","users.gender","users.birth_place","users.birth_date" ])->first();
        return view('pages.orders.show', [
            'user' => $users ,
            'usersReferrals' => $usersReferral,
        ],compact('data'));
    }

    /**
     * Edit user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(User $user) 
    {
        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $users = User::join('branch as b','b.id','=','users.branch_id')->join('department as dt','dt.id','=','users.department_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.id','=',$user->id)->get(['dt.remark as department','users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date as join_date',"users.phone_no","users.email","users.username","users.address","users.netizen_id","users.photo_netizen_id","users.photo","users.join_years","users.active","users.referral_id","users.city","users.gender","users.birth_place","users.birth_date" ])->first();
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        return view('pages.orders.edit', [
            'user' => $users,
            'userRole' => $user->roles->pluck('name')->toArray(),
            'roles' => Role::latest()->get(),
            'branchs' => Branch::latest()->get(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'usersReferrals' => $usersReferral,
        ]);
    }

    /**
     * Update user data
     * 
     * @param User $user
     * @param UpdateUserRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(User $user, UpdateUserRequest $request) 
    {

        $user->update($request->validated());
        $user->syncRoles($request->get('role'));
        $user->update($request->all());

        if($request->file('photo_netizen_ids') == null){

        }else{
            $file = $request->file('photo_netizen_ids');
            $user->update(['photo_netizen_id'=>$file->getClientOriginalName()]);
            
            // upload file
            $folder_upload = 'images/user-files';
            $file->move($folder_upload,$file->getClientOriginalName());
        }
        
        return redirect()->route('users.index')
            ->withSuccess(__('User updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(User $user) 
    {
        $user->delete();

        return redirect()->route('users.index')
            ->withSuccess(__('User deleted successfully.'));
    }
}
