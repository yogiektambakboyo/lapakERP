<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Product;
use App\Models\ProductDistribution;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Department;
use App\Models\ProductType;
use App\Models\ProductBrand;
use App\Models\ProductPrice;
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



class ServicesDistributionController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="servicesdistribution",$id=1;

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
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->join('product_distribution as pr','pr.product_id','=','product_sku.id')
                    ->join('branch as bc','bc.id','=','pr.branch_id')
                    ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                    ->where('ub2.user_id','=',$user->id)
                    ->where('pt.id','!=','1')
                    ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pb.remark as product_brand','pr.active']);
        return view('pages.servicesdistribution.index', ['company' => Company::get()->first()],compact('products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('product_price as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->whereRaw($whereclause)
                        ->where('pt.id','!=','1')
                        ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.price as product_price','pb.remark as product_brand']);           
            return view('pages.servicesdistribution.index',['company' => Company::get()->first()], compact('products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $active = ['1','0'];
        return view('pages.servicesdistribution.create',[
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id in (2,8) order by remark;'),
            'data' => $data,
            'active' => $active, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param ProductDistribution $productdistribution
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(ProductDistribution $productdistribution, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $user = Auth::user();
        $productdistribution->create(
            array_merge(
                ['active' => $request->get('active') ],
                ['product_id' => $request->get('product_id') ],
                ['branch_id' => $request->get('branch_id') ],
                ['created_by' => $user->id ],
            )
        );
        return redirect()->route('servicesdistribution.index')
            ->withSuccess(__('Product distribution created successfully.'));
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

        return view('pages.servicesdistribution.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param ProductDistribution $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(String $branch_id,String $product_id) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $active = ['1','0'];
        $product = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->join('product_distribution as pr','pr.product_id','=','product_sku.id')
        ->join('branch as bc','bc.id','=','pr.branch_id')
        ->where('product_sku.id',$product_id)
        ->where('bc.id','=',$branch_id)
        ->get(['product_sku.id as id','product_sku.abbr','product_sku.brand_id','product_sku.category_id','product_sku.type_id','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand','pr.branch_id','bc.remark as branch_name','pr.active as active'])->first();
        return view('pages.servicesdistribution.edit', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'active' => $active,
            'product' => $product,
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id in (2,8) order by remark;'),
            'company' => Company::get()->first(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param ProductDistribution $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(String $branch,String $product, Request $request) 
    {
        $user = Auth::user();
        ProductDistribution::where('product_id','=',$product)->where('branch_id','=',$branch)->update(
            array_merge(
                ['active' => $request->get('active') ],
            )
        );
        
        return redirect()->route('servicesdistribution.index')
            ->withSuccess(__('Product distribution updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param ProductDistribution $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(String $branch,String $product) 
    {
        ProductDistribution::where('product_id','=',$product)->where('branch_id','=',$branch)->delete();
        return redirect()->route('servicesdistribution.index')
            ->withSuccess(__('Product distribution deleted successfully.'));
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
                            'icon' => 'fa fa-spa',
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