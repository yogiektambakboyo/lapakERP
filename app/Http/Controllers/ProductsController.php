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
use SimpleSoftwareIO\QrCode\Facades\QrCode;



class ProductsController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="products",$id=1;

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
        $products = Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->where('pt.id','=','1')
                    ->get(['product_sku.photo','product_sku.id','product_sku.barcode','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand']);
        return view('pages.products.index', ['act_permission' => $act_permission,'company' => Company::get()->first()],compact('products','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            $whereclause = " upper(product_sku.remark) ilike '%".strtoupper($keyword)."%' or pt.remark ilike '%".strtoupper($keyword)."%' ";
            $products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->whereRaw($whereclause)
                        ->where('pt.id','=','1')
                        ->get(['product_sku.photo','product_sku.id','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand']);            
            return view('pages.products.index',[ 'act_permission' => $act_permission, 'company' => Company::get()->first()], compact('products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.products.create',[
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
    public function store(Product $product,Request $request) 
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
                ['barcode' => $request->get('barcode') ],
            )
        );

        $my_id = Product::orderBy('id', 'desc')->first()->id;

        ProductUom::create(array_merge(
            ['product_id'=> $my_id],
            ['uom_id' => $request->get('uom_id')],
        ));



        if($request->file('photo') == null){
            Product::where(['id' => $my_id])->update( array_merge(
                ['photo' => 'goods.png'],
            ));
        }else{
            $file_photo = $request->file('photo');
            $img_file_photo = $file_photo->getClientOriginalName().'.'.$file_photo->getClientOriginalExtension();
            $final_fileimg_photo = md5($my_id.'_'.$img_file_photo).'.'.$file_photo->getClientOriginalExtension();
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$img_file_photo);

            $destinationx = '/images/user-files/'.$img_file_photo;//or any extension such as jpeg,png
            $newdestinationx =  '/images/user-files/'.$final_fileimg_photo;
            File::move(public_path($destinationx), public_path($newdestinationx));

            Product::where(['id' => $my_id])->update( array_merge(
                    ['photo' => $final_fileimg_photo],
            ));
        }

        if($request->file('photo_2') == null){
            Product::where(['id' => $my_id])->update( array_merge(
                ['photo_2' => 'goods.png'],
            ));
        }else{
            $file_photo = $request->file('photo_2');
            $img_file_photo = $file_photo->getClientOriginalName().'.'.$file_photo->getClientOriginalExtension();
            $final_fileimg_photo = md5($my_id.'_'.$img_file_photo).'.'.$file_photo->getClientOriginalExtension();
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$img_file_photo);

            $destinationx = '/images/user-files/'.$img_file_photo;//or any extension such as jpeg,png
            $newdestinationx =  '/images/user-files/'.$final_fileimg_photo;
            File::move(public_path($destinationx), public_path($newdestinationx));

            Product::where(['id' => $my_id])->update( array_merge(
                    ['photo_2' => $final_fileimg_photo],
            ));
        }

        DB::select("
            insert into product_stock(product_id,branch_id,qty,created_at,created_by)
            select ps.id,b.id,0,now(),1  from product_sku ps
            join branch b on 1=1
            where b.id>1 and ps.id::character varying||b.id::character varying not in (select product_id::character varying||branch_id::character varying  from product_stock);
        
        ");

        DB::select("
            insert into period_stock(periode,product_id,branch_id,balance_begin,balance_end,qty_in,qty_out,created_at,created_by)
            select to_char(now(),'YYYYMM')::int,ps.id,b.id,0,0,0,0,now(),1  from product_sku ps
            join branch b on 1=1
            where b.id>1 and ps.id::character varying||b.id::character varying not in (select product_id::character varying||branch_id::character varying  from period_stock)
            
        ");

        DB::select("
            insert into period_price_sell(period,product_id,branch_id,value,created_at,created_by)
            select to_char(now(),'YYYYMM')::int,ps.id,b.id,0,now(),1  from product_sku ps
            join branch b on 1=1
            where b.id>1 and ps.id::character varying||b.id::character varying not in (select product_id::character varying||branch_id::character varying  from period_price_sell)
        ");

        DB::select("
            insert into product_distribution(product_id,branch_id,created_at,updated_at,active)
            select ps.id,b.id,now(),now(),1  from product_sku ps
            join branch b on 1=1
            where ps.id::character varying||b.id::character varying 
            not in (select product_id::character varying||branch_id::character varying from product_distribution)
        ");

        DB::select("
            insert into product_price(product_id,price,branch_id,updated_by,updated_at,created_by,created_at)
            select ps.id,0,b.id,null,now(),1,now()  from product_sku ps
            join branch b on 1=1
            where ps.id::character varying||b.id::character varying 
            not in (select product_id::character varying||branch_id::character varying from product_price)
        ");

        DB::select("
            insert into product_stock(product_id,branch_id,qty,updated_at,created_at,created_by)
            select ps.id,b.id,0,null,now(),1  from product_sku ps
            join branch b on 1=1
            where ps.id::character varying||b.id::character varying 
            not in (select product_id::character varying||branch_id::character varying from product_stock)
        ");

        return redirect()->route('products.index')
            ->withSuccess(__('Product created successfully.'));
    }

    /**
     * Store a newly created user
     * 
     * @param Product $product
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function storeIngredients(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $user = Auth::user();
        ProductIngredients::create(
            array_merge(
                ['product_id_material' => $request->get('input_product_id_material') ],
                ['created_by' => $user->id],
                ['qty' => $request->get('input_qty') ],
                ['product_id' => $request->get('input_product_id') ],
                ['uom_id' => $request->get('input_uom') ],
            )
        );

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $request->get('input_product_id')],
            ['message' => 'Delete Successfully'],
        );  

        return $result;
    }

    /**
     * Show user data
     * 
     * @param Product $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product) 
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
        ->get(['pu.uom_id','uo.remark as product_uom','product_sku.barcode','product_sku.photo','product_sku.photo_2','product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand'])->first(); 

        $productsw = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id','!=',$product->id)
        ->get(['product_sku.id','product_sku.remark']);

        

        return view('pages.products.show', [
            'product' => $products ,
            'products' => $productsw ,
            'uoms' => Uom::get(),
            'data' => $data, 'company' => Company::get()->first(), 
            'ingredients' => ProductIngredients::join('product_sku as ps','ps.id','product_ingredients.product_id_material')->join('uom as u','u.id','product_ingredients.uom_id')->where('product_ingredients.product_id',$product->id)->get(['product_ingredients.product_id','product_ingredients.product_id_material','u.remark as uom_name','ps.remark as product_name','product_ingredients.qty']),
        ]);
    }

    public function print_qr(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $act_permission = $this->act_permission[0];

        $data = $this->data;
        $keyword = "";
        $products = Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->where('pt.id','=','1')->orderBy('product_sku.barcode','asc')
                    ->get(['product_sku.photo','product_sku.id','product_sku.barcode','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand']);
        return view('pages.products.print_qr', ['act_permission' => $act_permission,'company' => Company::get()->first()],compact('products','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->join('product_uom','product_uom.product_id','=','product_sku.id')
        ->where('product_sku.id',$product->id)
        ->get(['product_uom.uom_id as uom_id','product_sku.photo','product_sku.barcode','product_sku.photo_2','product_sku.id as id','product_sku.abbr','product_sku.brand_id','product_sku.category_id','product_sku.type_id','product_sku.remark as product_name','pt.abbr as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        $productsw = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id','!=',$product->id)
        ->get(['product_sku.id','product_sku.remark']);

        return view('pages.products.edit', [
            'productCategorys' => Category::where('type_id','=','1')->latest()->get(),
            'productCategorysRemark' => Category::where('type_id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productBrands' => ProductBrand::where('type_id','=','1')->latest()->get(),
            'productBrandsRemark' => ProductBrand::where('type_id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productTypes' => Type::where('id','=','1')->latest()->get(),
            'productTypesRemark' => Type::where('id','=','1')->latest()->get()->pluck('remark')->toArray(),
            'productUoms' => Uom::where('type_id','=','1')->latest()->orderBy('remark')->get(),
            'data' => $data,
            'products' => $productsw ,
            'uoms' => Uom::get(),
            'product' => $products, 'company' => Company::get()->first(),
            'ingredients' => ProductIngredients::join('product_sku as ps','ps.id','product_ingredients.product_id_material')->join('uom as u','u.id','product_ingredients.uom_id')->where('product_ingredients.product_id',$product->id)->get(['product_ingredients.product_id','product_ingredients.product_id_material','u.remark as uom_name','ps.remark as product_name','product_ingredients.qty']),
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
                ['updated_at' => Carbon::now()],
                ['remark' => $request->get('remark') ],
                ['type_id' => $request->get('type_id') ],
                ['category_id' => $request->get('category_id') ],
                ['brand_id' => $request->get('brand_id') ],
                ['barcode' => $request->get('barcode') ],
            )
        );

        ProductUom::where('product_id','=',$request->id)->update(array_merge(
            ['uom_id' => $request->get('uom_id')],
        ));

        $my_id = $product->id;


        if($request->file('photo') == null){
            
        }else{
            $file_photo = $request->file('photo');
            $img_file_photo = $file_photo->getClientOriginalName().'.'.$file_photo->getClientOriginalExtension();
            $final_fileimg_photo = md5($my_id.'_'.$img_file_photo).'.'.$file_photo->getClientOriginalExtension();
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$img_file_photo);

            $destinationx = '/images/user-files/'.$img_file_photo;//or any extension such as jpeg,png
            $newdestinationx =  '/images/user-files/'.$final_fileimg_photo;
            File::move(public_path($destinationx), public_path($newdestinationx));

            Product::where(['id' => $my_id])->update( array_merge(
                    ['photo' => $final_fileimg_photo],
            ));
        }

        if($request->file('photo_2') == null){
            
        }else{
            $file_photo = $request->file('photo_2');
            $img_file_photo = $file_photo->getClientOriginalName().'.'.$file_photo->getClientOriginalExtension();
            $final_fileimg_photo = md5($my_id.'_'.$img_file_photo).'.'.$file_photo->getClientOriginalExtension();
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$img_file_photo);

            $destinationx = '/images/user-files/'.$img_file_photo;//or any extension such as jpeg,png
            $newdestinationx =  '/images/user-files/'.$final_fileimg_photo;
            File::move(public_path($destinationx), public_path($newdestinationx));

            Product::where(['id' => $my_id])->update( array_merge(
                    ['photo_2' => $final_fileimg_photo],
            ));
        }

        
        return redirect()->route('products.index')
            ->withSuccess(__('Product updated successfully.'));
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