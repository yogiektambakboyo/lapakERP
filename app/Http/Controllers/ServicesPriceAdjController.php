<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Product;
use App\Models\ProductPriceAdj;
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
use App\Exports\ProductsPriceAdjExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ServicesPriceAdjController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="servicespriceadj",$id=1;

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
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $products = Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->join('price_adjustment as pr','pr.product_id','=','product_sku.id')
                    ->join('branch as bc','bc.id','=','pr.branch_id')
                    ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                    ->where('ub2.user_id','=',$user->id)
                    ->where('pt.id','!=','1')
                    ->whereRaw('now()::date between pr.dated_start and pr.dated_end')
                    ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end','pb.remark as product_brand']);
        return view('pages.servicespriceadj.index',['company' => Company::get()->first()] ,compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $begindate = date(Carbon::parse($request->filter_begin_date)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date)->format('Y-m-d'));
        $branchx = $request->filter_branch_id;
        if($begindate=='2022-01-01'){
            $begindate = Carbon::now()->format('Y-m-d');
        }
        
        $fil = [ $begindate , $enddate ];
        
        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new ProductsPriceAdjExport($strencode), 'servicespriceadjustment_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->src=='Search'){
            $branchx = "";
            $whereclause = " upper(product_sku.remark) like '%".strtoupper($keyword)."%' and '".$begindate."' between pr.dated_start and pr.dated_end ";
            $products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('price_adjustment as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                        ->where('ub2.user_id','=',$user->id)
                        ->whereRaw($whereclause)
                        ->where('pt.id','!=','1')
                        ->where('bc.id','like','%'.$branchx.'%')  
                        ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end','pb.remark as product_brand']); 
                        $request->filter_branch_id = "";
                        $request->filter_end_date = "";       
            return view('pages.servicespriceadj.index',['company' => Company::get()->first()], compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }else{
            $whereclause = " upper(product_sku.remark) like '%".strtoupper($keyword)."%' and '".$begindate."' between pr.dated_start and pr.dated_end ";
            $products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('price_adjustment as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                        ->where('ub2.user_id','=',$user->id)
                        ->whereRaw($whereclause)
                        ->where('pt.id','!=','1')
                        ->where('bc.id','like','%'.$branchx.'%')  
                        ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end','pb.remark as product_brand']);                 
            return view('pages.servicespriceadj.index',['company' => Company::get()->first()], compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.servicespriceadj.create',[
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id in (2,8) order by remark;'),
            'data' => $data, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param ProductPrice $productprice
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(ProductPriceAdj $productpriceadj, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $user = Auth::user();
        $productpriceadj->create(
            array_merge(
                ['value' => $request->get('value') ],
                ['dated_start' => Carbon::parse($request->get('dated_start'))->format('Y-m-d') ],
                ['dated_end' => Carbon::parse($request->get('dated_end'))->format('Y-m-d') ],
                ['product_id' => $request->get('product_id') ],
                ['branch_id' => $request->get('branch_id') ],
                ['created_by' => $user->id ],
            )
        );
        return redirect()->route('servicespriceadj.index')
            ->withSuccess(__('Service price adjustment created successfully.'));
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

        return view('pages.servicespriceadj.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param ProductPrice $product
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
        $product = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->join('price_adjustment as pr','pr.product_id','=','product_sku.id')
        ->join('branch as bc','bc.id','=','pr.branch_id')
        ->where('product_sku.id',$product_id)
        ->where('bc.id','=',$branch_id)
        ->get(['product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end','pb.remark as product_brand'])->first(); 
        return view('pages.servicespriceadj.edit', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'product' => $product, 'company' => Company::get()->first(),
            'products' => Product::get(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param ProductPriceAdj $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(String $branch,String $product,String $dated_start,String $dated_end, Request $request) 
    {
        $user = Auth::user();
        ProductPriceAdj::where('product_id','=',$product)
                        ->where('branch_id','=',$branch)
                        ->where('dated_start','=',Carbon::parse($dated_start)->format('Y-m-d'))
                        ->where('dated_end','=',Carbon::parse($dated_end)->format('Y-m-d'))
                        ->update(
                            array_merge(
                                ['value' => $request->get('value') ],
                            )
                        );
        
        return redirect()->route('servicespriceadj.index')
            ->withSuccess(__('Price Adjustment updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param ProductPrice $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(String $branch,String $product,String $dated_start,String $dated_end) 
    {
        ProductPriceAdj::where('product_id','=',$product)
                        ->where('branch_id','=',$branch)
                        ->where('dated_start','=',Carbon::parse($dated_start)->format('Y-m-d'))
                        ->where('dated_end','=',Carbon::parse($dated_end)->format('Y-m-d'))->delete();
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $product],
            ['message' => 'Delete Successfully'],
        );  
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