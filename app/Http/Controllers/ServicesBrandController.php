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
use App\Models\ProductBrand;
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



class ServicesBrandController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="productsbrand",$id=1;

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
        $brands = ProductBrand::where('type_id','=','2')->orderBy('product_brand.remark', 'ASC')
                    ->paginate(10,['product_brand.id','product_brand.remark']);
        return view('pages.servicesbrand.index', ['company' => Company::get()->first()],compact('brands','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
                        ->whereRaw($whereclause)
                        ->where('pt.type_id','=','2')
                        ->paginate(10,['product_sku.id','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand']);            
            return view('pages.servicesbrand.index',['company' => Company::get()->first()], compact('products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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

        $data = $this->data;
        return view('pages.servicesbrand.create',[
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param ProductBrand $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(ProductBrand $productbrand, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user

        $user = Auth::user();
        $productbrand->create(
            array_merge(
                ['remark' => $request->get('remark') ],
            )
        );
        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Brand created successfully.'));
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

        return view('pages.servicesbrand.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(ProductBrand $productbrand) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $brand = ProductBrand::where('product_brand.id',$productbrand->id)
        ->get(['product_brand.id as id','product_brand.remark'])->first();
        return view('pages.servicesbrand.edit', [
            'data' => $data,
            'brand' => $brand, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param ProductBrand $productbrand
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(ProductBrand $productbrand, Request $request) 
    {
        $user = Auth::user();
        $productbrand->update(
            array_merge(
                ['remark' => $request->get('remark') ],
            )
        );
        
        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Product updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param ProductBrand $productbrand
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(ProductBrand $productbrand) 
    {
        $productbrand->delete();

        return redirect()->route('productsbrand.index')
            ->withSuccess(__('Brand deleted successfully.'));
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