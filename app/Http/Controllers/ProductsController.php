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
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ProductsExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;

class ProductsController extends Controller
{
    /**
     * Display all products
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
        /*
        select b.remark as branch_name,ps.id,ps.remark as product_name,pt.remark as product_type,pc.remark as product_category,pb.remark as product_brand from product_sku ps
        join product_distribution pd on pd.product_id = ps.id
        join branch b on b.id = pd.branch_id 
        join product_type pt on pt.id = ps.type_id 
        join product_category pc on pc.id =ps.category_id 
        join product_brand pb on pb.id = ps.brand_id 
        */
        $data = $this->data;
        $keyword = "";
        $products = Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->paginate(10,['product_sku.id','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand']);
        return view('pages.products.index', compact('products','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $keyword = $request->search;
        $data = $this->data;

        if($request->export=='Export Excel'){
            return Excel::download(new ProductsExport($keyword), 'products_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $whereclause = " upper(product_sku.remark) like '%".strtoupper($keyword)."%'";
            $products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->whereRaw($whereclause)
                        ->paginate(10,['product_sku.id','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand']);            
            return view('pages.products.index', compact('products','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $productsReferral = User::get(['products.id','products.name']);
        return view('pages.products.create',[
            'roles' => Role::latest()->get(),
            'branchs' => Branch::latest()->get(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'productsReferrals' => $productsReferral,
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param StoreUserRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(User $user, StoreUserRequest $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        if($request->file('photo_netizen_id') == null){
            $user->create(
                array_merge(
                    $request->validated(), 
                    ['password' => 'test123' ],
                    ['phone_no' => $request->get('phone_no') ],
                    ['join_date' => Carbon::parse($request->get('join_date'))->format('d/m/Y') ],
                    ['gender' => $request->get('gender') ],
                    ['netizen_id' => $request->get('netizen_id') ],
                    ['active' => '1' ],
                    ['city' => $request->get('city') ],
                    ['employee_id' => $request->get('employee_id') ],
                    ['job_id' => $request->get('job_id') ],
                    ['branch_id' => $request->get('branch_id') ],
                    ['department_id' => $request->get('department_id') ],
                    ['address' => $request->get('address') ],
                    ['referral_id' => $request->get('referral_id') ],
                    ['birth_place' => $request->get('birth_place') ],
                    ['birth_date' => Carbon::parse($request->get('birth_date'))->format('d/m/Y')  ]
                )
            );
        }else{
            $file = $request->file('photo_netizen_id');
            $user->create(
                array_merge(
                    $request->validated(), 
                    ['password' => 'test123' ],
                    ['phone_no' => $request->get('phone_no') ],
                    ['join_date' => Carbon::parse($request->get('join_date'))->format('d/m/Y') ],
                    ['gender' => $request->get('gender') ],
                    ['netizen_id' => $request->get('netizen_id') ],
                    ['active' => '1' ],
                    ['city' => $request->get('city') ],
                    ['employee_id' => $request->get('employee_id') ],
                    ['photo_netizen_id' => $file->getClientOriginalName() ],
                    ['job_id' => $request->get('job_id') ],
                    ['branch_id' => $request->get('branch_id') ],
                    ['department_id' => $request->get('department_id') ],
                    ['address' => $request->get('address') ],
                    ['referral_id' => $request->get('referral_id') ],
                    ['birth_place' => $request->get('birth_place') ],
                    ['birth_date' => Carbon::parse($request->get('birth_date'))->format('d/m/Y')  ]
                )
            );

            // upload file
            $folder_upload = 'images/user-files';
            $file->move($folder_upload,$file->getClientOriginalName());
        }
        return redirect()->route('products.index')
            ->withSuccess(__('User created successfully.'));
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
        $productsReferral = User::where('products.id','!=',$user->id)->get(['products.id','products.name']);
        $products = User::join('branch as b','b.id','=','products.branch_id')->join('department as dt','dt.id','=','products.department_id')->join('job_title as jt','jt.id','=','products.job_id')->where('products.name','!=','Admin')->where('products.id','=',$user->id)->get(['dt.remark as department','products.id','products.employee_id','products.name','jt.remark as job_title','b.remark as branch_name','products.join_date',"products.phone_no","products.email","products.username","products.address","products.netizen_id","products.photo_netizen_id","products.photo","products.join_years","products.active","products.referral_id","products.city","products.gender","products.birth_place","products.birth_date" ])->first();
        return view('pages.products.show', [
            'user' => $products ,
            'productsReferrals' => $productsReferral,
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
        $products = User::join('branch as b','b.id','=','products.branch_id')->join('department as dt','dt.id','=','products.department_id')->join('job_title as jt','jt.id','=','products.job_id')->where('products.name','!=','Admin')->where('products.id','=',$user->id)->get(['dt.remark as department','products.id','products.employee_id','products.name','jt.remark as job_title','b.remark as branch_name','products.join_date as join_date',"products.phone_no","products.email","products.username","products.address","products.netizen_id","products.photo_netizen_id","products.photo","products.join_years","products.active","products.referral_id","products.city","products.gender","products.birth_place","products.birth_date" ])->first();
        $productsReferral = User::where('products.id','!=',$user->id)->get(['products.id','products.name']);
        return view('pages.products.edit', [
            'user' => $products,
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
            'productsReferrals' => $productsReferral,
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
        
        return redirect()->route('products.index')
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

        return redirect()->route('products.index')
            ->withSuccess(__('User deleted successfully.'));
    }
}