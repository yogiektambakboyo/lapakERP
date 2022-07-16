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
        return view('pages.products.create',[
            'productCategorys' => ProductCategory::latest()->get(),
            'productCategorysRemark' => ProductCategory::latest()->get()->pluck('remark')->toArray(),
            'productBrands' => ProductBrand::latest()->get(),
            'productBrandsRemark' => ProductBrand::latest()->get()->pluck('remark')->toArray(),
            'productTypes' => ProductType::latest()->get(),
            'productTypesRemark' => ProductType::latest()->get()->pluck('remark')->toArray(),
            'data' => $data,
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
    public function store(Product $product, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $user = Auth::user();
        $product->create(
            array_merge(
                ['abbr' => $request->get('abbr') ],
                ['created_by' => $user->id],
                ['remark' => $request->get('remark') ],
                ['type_id' => $request->get('type_id') ],
                ['category_id' => $request->get('category_id') ],
                ['brand_id' => $request->get('brand_id') ],
            )
        );
        return redirect()->route('products.index')
            ->withSuccess(__('Product created successfully.'));
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
        $data = $this->data;
        //return $product->id;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id',$product->id)
        ->get(['product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        return view('pages.products.show', [
            'product' => $products ,
            'data' => $data,
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Product $product) 
    {
        $data = $this->data;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id',$product->id)
        ->get(['product_sku.id as id','product_sku.abbr','product_sku.brand_id','product_sku.category_id','product_sku.type_id','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();
        return view('pages.products.edit', [
            'productCategorys' => ProductCategory::latest()->get(),
            'productCategorysRemark' => ProductCategory::latest()->get()->pluck('remark')->toArray(),
            'productBrands' => ProductBrand::latest()->get(),
            'productBrandsRemark' => ProductBrand::latest()->get()->pluck('remark')->toArray(),
            'productTypes' => ProductType::latest()->get(),
            'productTypesRemark' => ProductType::latest()->get()->pluck('remark')->toArray(),
            'data' => $data,
            'product' => $products,
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
    public function update(Product $product, Request $request) 
    {
        $user = Auth::user();
        $product->update(
            array_merge(
                ['abbr' => $request->get('abbr') ],
                ['updated_by' => $user->id],
                ['remark' => $request->get('remark') ],
                ['type_id' => $request->get('type_id') ],
                ['category_id' => $request->get('category_id') ],
                ['brand_id' => $request->get('brand_id') ],
            )
        );
        
        return redirect()->route('products.index')
            ->withSuccess(__('Product updated successfully.'));
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
            ->withSuccess(__('Product deleted successfully.'));
    }
}