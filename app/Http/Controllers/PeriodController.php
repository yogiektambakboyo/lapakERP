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
use App\Models\ProductIngredients;
use App\Models\Type;
use App\Models\Period;
use App\Models\Uom;
use App\Models\ProductUom;
use App\Models\ProductBrand;
use App\Models\Category;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ProductsExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use File;
use App\Models\Company;
use App\Http\Controllers\Lang;



class PeriodController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="period",$id=1;

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
        $act_permission = $this->act_permission[0];

        $data = $this->data;
        $keyword = "";

        $products = Period::orderBy('period.remark', 'ASC')
                    ->get(['period.period_no','period.start_date','period.remark','period.start_cal','period.end_cal','period.close_trans','period.updated_at']);
        return view('pages.period.index', ['act_permission' => $act_permission,'company' => Company::get()->first()],compact('products','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.period.create',[
            'productCategorys' => Category::where('type_id','=','1')->latest()->get(),
            'productCategorysRemark' => Category::where('type_id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productBrands' => ProductBrand::where('type_id','=','1')->latest()->get(),
            'productBrandsRemark' => ProductBrand::where('type_id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productTypes' => Type::where('id','=','1')->latest()->get(),
            'productTypesRemark' => Type::where('id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productUoms' => Uom::where('type_id','=','1')->latest()->orderBy('remark')->get(),
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    

    /**
     * Store a newly created user
     * 
     * @param Product $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function get_period_status(Request $request) 
    {
        $isvalid_edit = DB::select(" select close_trans,remark from period where '".$request->invoice_date."'::date between start_cal and end_cal and period_no=to_char('".$request->invoice_date."'::date,'YYYYMM')::int; ");
        return $isvalid_edit;
    }

    /**
     * Show user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Period $period) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;

        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->join('product_uom as pu','pu.product_id','=','product_sku.id')
        ->join('uom as uo','uo.id','=','pu.uom_id')
        ->where('product_sku.id',$product->id)
        ->get(['pu.uom_id','uo.remark as product_uom','product_sku.photo','product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        $productsw = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id','!=',$product->id)
        ->get(['product_sku.id','product_sku.remark']);


        return view('pages.period.show', [
            'product' => $products ,
            'products' => $productsw ,
            'uoms' => Uom::get(),
            'data' => $data, 'company' => Company::get()->first(), 
            'ingredients' => ProductIngredients::join('product_sku as ps','ps.id','product_ingredients.product_id_material')->join('uom as u','u.id','product_ingredients.uom_id')->where('product_ingredients.product_id',$product->id)->get(['product_ingredients.product_id','product_ingredients.product_id_material','u.remark as uom_name','ps.remark as product_name','product_ingredients.qty']),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(String $period) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $products = Period::orderBy('period.remark', 'ASC')->where('period.period_no','=',$period)->get(['period.period_no','period.start_date','period.remark','period.start_cal','period.end_cal','period.close_trans'])->first();

        return view('pages.period.edit', [
            'data' => $data,
            'product' => $products, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param Product $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Period $period, Request $request) 
    {
        $user = Auth::user();
       
        Period::where('period_no','=',$request->input_period_no)->update(array_merge(
            ['close_trans' => $request->get('input_close_trans')],
            ['updated_at' => date('Y-m-d H:i:s')],
        ));

        return redirect()->route('period.index')->withSuccess(__('Period updated successfully.'));
    }


    /**
     * Store a newly created user skill
     * 
     *
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function deleteIngredients(Request $request) 
    {

        DB::insert("DELETE FROM public.product_ingredients
        where product_id=".$request->get('input_product_id')." and product_id_material=".$request->get('input_product_material')." ;");
            
        $result = array_merge(
            ['status' => 'success'],
            ['data' => ''],
            ['message' => 'Save Successfully'],
        );    
        return $result;
    }

    /**
     * Delete user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(Product $product) 
    {
        if($product->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $product->product_name],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $product->product_name],
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