<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Product;
use App\Models\ProductCommision;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Department;
use App\Models\ProductType;
use App\Models\ProductBrand;
use App\Models\ProductCommisionByYear;
use App\Models\ProductCategory;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ProductsExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ServicesCommisionByYearController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="servicescommisionbyyear",$id=1;

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

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $products = Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_commision_by_year as pr','pr.product_id','=','product_sku.id')
                    ->join('branch as bc','bc.id','=','pr.branch_id')
                    ->join('job_title as jt','jt.id','=','pr.jobs_id')
                    ->where('type_id','!=','1')
                    ->get(['jt.remark as job_title','years', 'values', 'pr.jobs_id','product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name']);
        return view('pages.servicescommisionbyyear.index', ['company' => Company::get()->first()],compact('data','keyword','act_permission','products'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];

        if($request->export=='Export Excel'){
            return Excel::download(new ProductsExport($keyword), 'products_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $whereclause = " upper(product_sku.remark) like '%".strtoupper($keyword)."%'";
            $products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_commision_by_year as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->join('job_title as jt','jt.id','=','pr.jobs_id')
                        ->whereRaw($whereclause)
                        ->where('type_id','!=','1')
                        ->get(['jt.remark as job_title','years', 'values', 'pr.jobs_id','product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name']);       
            return view('pages.servicescommisionbyyear.index', ['company' => Company::get()->first()],compact('products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new ProductsExport, 'productscommision_'.Carbon::now()->format('YmdHis').'.xlsx');
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
        $years = [1,2,3,4,5,6,7,8,9,10];
        $jobs = JobTitle::get(['id','remark']);
        return view('pages.servicescommisionbyyear.create',[
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id in (2,8) order by remark;'),
            'data' => $data,
            'jobs' => $jobs,
            'years' => $years, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param ProductCommisionByYear $productcommisionbyyear
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(ProductCommisionByYear $productcommisionbyyear, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user

        $user = Auth::user();
        $productcommisionbyyear->create(
            array_merge(
                ['values' => $request->get('values') ],
                ['years' => $request->get('years') ],
                ['jobs_id' => $request->get('jobs_id') ],
                ['product_id' => $request->get('product_id') ],
                ['branch_id' => $request->get('branch_id') ],
                ['created_by' => $user->id ],
            )
        );
        return redirect()->route('servicescommisionbyyear.index')
            ->withSuccess(__('Product commision by year created successfully.'));
    }

    /**
     * Show user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        //return $product->id;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id',$product->id)
        ->get(['product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        return view('pages.servicescommisionbyyear.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param ProductCommision $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(String $branch_id,String $product_id,String $jobs_id,String $years) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $yearsarr = [1,2,3,4,5,6,7,8,9,10];
        $product = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_commision_by_year as pr','pr.product_id','=','product_sku.id')
        ->join('branch as bc','bc.id','=','pr.branch_id')
        ->join('job_title as jt','jt.id','=','pr.jobs_id')
        ->where('product_sku.id',$product_id)
        ->where('bc.id','=',$branch_id)
        ->where('pr.jobs_id','=',$jobs_id)
        ->where('pr.years','=',$years)
        ->get(['values','pr.jobs_id', 'jt.remark as job_title', 'years','product_sku.id as id','product_sku.abbr','product_sku.brand_id','product_sku.category_id','product_sku.type_id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name'])->first();
        return view('pages.servicescommisionbyyear.edit', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'years' => $yearsarr,
            'jobs' => JobTitle::get(['id','remark']),
            'product' => $product,
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id in (2,8) order by remark;'), 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param ProductCommisionByYear $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(String $branch,String $product,String $jobs_id,String $years, Request $request) 
    {
        $user = Auth::user();
        ProductCommisionByYear::where('product_id','=',$product)
            ->where('branch_id','=',$branch)
            ->where('jobs_id','=',$jobs_id)
            ->where('years','=',$years)
            ->update(
            array_merge(
                ['values' => $request->get('values') ]
            )
        );
        
        return redirect()->route('servicescommisionbyyear.index')
            ->withSuccess(__('Service commision updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param ProductCommisionByYear $productcommisionsbyyear
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(String $branch,String $product,String $jobs_id,String $years) 
    {
        ProductCommisionByYear::where('product_id','=',$product)
        ->where('branch_id','=',$branch)
        ->where('jobs_id','=',$jobs_id)
            ->where('years','=',$years)
            ->delete();
        return redirect()->route('servicescommisionbyyear.index')
            ->withSuccess(__('Service commisions by year deleted successfully.'));
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