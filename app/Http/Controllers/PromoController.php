<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Product;
use App\Models\Promo;
use App\Models\PromoDetail;
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
use App\Exports\VoucherExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;



class PromoController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="promo",$id=1;

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
       
        $products = DB::select("select v.promo_id,left(string_agg(ps.abbr,', '),25) as product_name,v.remarks as voucher_remark,v.branch_id,bc.remark as branch_name,v.value as value,v.value_idx,v.date_start,v.date_end 
        from promo v 
        join promo_detail vd on vd.promo_id=v.promo_id 
        join branch as bc on bc.id= v.branch_id
        join users_branch as ub2 on ub2.branch_id=v .branch_id
        join product_sku ps on ps.id = vd.product_id::bigint
        where ub2.user_id = '".$user->id."' group by v.promo_id,v.remarks,v.branch_id,bc.remark,v.value,v.value_idx,v.date_start,v.date_end;");
        return view('pages.promo.index',['company' => Company::get()->first()] ,compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            return Excel::download(new VoucherExport($strencode), 'voucher_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->src=='Search'){
            $branchx = "";
            $whereclause = " upper(v.voucher_code) like '%".strtoupper($keyword)."%' and '".$begindate."' between v.dated_start and v.dated_end ";
            /**$products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('voucher as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                        ->where('ub2.user_id','=',$user->id)
                        ->whereRaw($whereclause)
                        ->where('bc.id','like','%'.$branchx.'%')  
                        ->get(['pr.invoice_no','pr.is_used','pr.remark as voucher_remark','pr.voucher_code','product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end']); 
             **/
            $request->filter_branch_id = "";
            $request->filter_end_date = "";     
            $products = DB::select("select left(string_agg(ps.abbr,', '),25) as product_name,v.invoice_no,v.is_used,v.price,v.remark as voucher_remark,v.voucher_code,v.branch_id,bc.remark as branch_name,v.value as value,v.value_idx,v.dated_start,v.dated_end 
                                from voucher v 
                                join voucher_detail vd on vd.voucher_code=v.voucher_code 
                                join branch as bc on bc.id= v.branch_id
                                join users_branch as ub2 on ub2.branch_id=v .branch_id
                                join product_sku ps on ps.id = vd.product_id::bigint
                                where ub2.user_id = '".$user->id."' and ".$whereclause." and bc.id::character varying like '%".$branchx."%' group by v.invoice_no,v.is_used,v.price,v.remark,v.voucher_code,v.branch_id,bc.remark,v.value,v.value_idx,v.dated_start,v.dated_end ;");

            return view('pages.promo.index',['company' => Company::get()->first()], compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }else{
            $whereclause = " upper(v.voucher_code) like '%".strtoupper($keyword)."%' and '".$begindate."' between v.dated_start and v.dated_end ";
            /**$products = Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('voucher as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->join('users_branch as ub2','ub2.branch_id', '=', 'pr.branch_id')
                        ->where('ub2.user_id','=',$user->id)
                        ->whereRaw($whereclause)
                        ->where('bc.id','like','%'.$branchx.'%')  
                        ->get(['pr.invoice_no','pr.is_used','pr.remark as voucher_remark','pr.voucher_code','product_sku.id','product_sku.remark as product_name','pr.branch_id','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end']); 
            **/
            $request->filter_branch_id = "";
            $request->filter_end_date = "";     
            $products = DB::select("select left(string_agg(ps.abbr,', '),25) as product_name,v.invoice_no,v.is_used,v.price,v.remark as voucher_remark,v.voucher_code,v.branch_id,bc.remark as branch_name,v.value as value,v.value_idx,v.dated_start,v.dated_end 
                                from voucher v 
                                join voucher_detail vd on vd.voucher_code=v.voucher_code 
                                join branch as bc on bc.id= v.branch_id
                                join users_branch as ub2 on ub2.branch_id=v .branch_id
                                join product_sku ps on ps.id = vd.product_id::bigint
                                where ub2.user_id = '".$user->id."' and ".$whereclause." and bc.id::character varying like '%".$branchx."%' group by v.invoice_no,v.is_used,v.price,v.remark,v.voucher_code,v.branch_id,bc.remark,v.value,v.value_idx,v.dated_start,v.dated_end ;");
            return view('pages.promo.index',['company' => Company::get()->first()], compact('request','branchs','products','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new ProductsExport, 'voucher_'.Carbon::now()->format('YmdHis').'.xlsx');
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
        return view('pages.promo.create',[
            'products' => DB::select('select ps.id,ps.remark from product_sku as ps where ps.type_id=2 order by ps.remark;'),
            'data' => $data, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param Voucher $voucher
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Promo $promo, Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
    
        $product_id = $request->get('product_id');
        $promo_id = date('YmdHis');
        
        $user = Auth::user();
            $promo->create(
                array_merge(
                    ['value' => $request->get('value') ],
                    ['value_idx' => $request->get('value_idx') ],
                    ['date_start' => Carbon::createFromFormat('d-m-Y', $request->get('dated_start'))->format('Y-m-d') ],
                    ['date_end' => Carbon::createFromFormat('d-m-Y', $request->get('dated_end'))->format('Y-m-d') ],
                    ['branch_id' => $request->get('branch_id') ],
                    ['moq' => $request->get('moq') ],
                    ['type_customer' => $request->get('type_customer') ],
                    ['active_time' => $request->get('active_time') ],
                    ['active_day' => $request->get('active_day') ],
                    ['remarks' => $request->get('remark') ],
                    ['created_by' => $user->id ],
                    ['promo_id' => $promo_id ],
                )
            );

            

            for($j=0;$j<count($product_id);$j++){
                if($product_id[$j]=="%"){
                    DB::update("insert into promo_detail(promo_id,product_id,created_by,created_at)
                    select '".$promo_id."',id,1,now() from product_sku ps 
                    where ps.type_id = 2");
                    break;
                }else{
                    PromoDetail::create(
                        array_merge(
                            ['product_id' => $product_id[$j] ],
                            ['promo_id' => $promo_id ],
                            ['created_by' => $user->id ],
                        )
                    );
                }

                
            }
    
        return redirect()->route('promo.index')
            ->withSuccess(__(' Promo created successfully.'));
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

        return view('pages.promo.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
    }

    public function check(){
        $user = Auth::user();
        $voucher = DB::select("select p.id,p.promo_id,p.remarks,p.active_day,p.active_time,p.moq,p.value_idx,p.value,p.type_customer,pd.product_id  from promo p
        join promo_detail pd on pd.promo_id = p.promo_id 
        join users_branch ub on  ub.branch_id=p.branch_id and ub.user_id = ".$user->id."
        join branch b on b.id=ub.branch_id 
        where now()::date between p.date_start and p.date_end");
        return $voucher; 
    }

    /**
     * Edit user data
     * 
     * @param ProductPrice $product
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(String $branch_id,String $product_id,String $dated_start,String $dated_end,String $voucher_code) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user  = Auth::user();
        $data = $this->data;
        $product = DB::select("select v.type_customer,v.active_day,v.active_time,v.moq,bc.id as branch_id,left(string_agg(ps.abbr,', '),150) as product_name,v.remarks,v.promo_id,v.branch_id,bc.remark as branch_name,v.value as value,v.value_idx,v.date_start,v.date_end 
                from promo v 
                join promo_detail vd on vd.promo_id=v.promo_id and vd.promo_id='".$voucher_code."'
                join branch as bc on bc.id= v.branch_id and bc.id = ".$branch_id."
                join users_branch as ub2 on ub2.branch_id=v .branch_id
                join product_sku ps on ps.id = vd.product_id::bigint
                where ub2.user_id = '".$user->id."' group by v.type_customer,v.active_day,v.active_time,v.moq,bc.id,v.remarks,v.promo_id,v.branch_id,bc.remark,v.value,v.value_idx,v.date_start,v.date_end  limit 1
        ;");

        return view('pages.promo.edit', [
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'data' => $data,
            'product' => $product[0], 'company' => Company::get()->first(),
            'products' => Product::get(),
        ]);
    }

    /**
     * Update user data
     * 
     * @param Voucher $voucher
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(String $branch,String $product,String $dated_start,String $dated_end,String $voucher_code, Request $request) 
    {
        $user = Auth::user();
        Promo::where('branch_id','=',$branch)
                        ->where('promo_id','=',$voucher_code)
                        ->update(
                            array_merge(
                                ['value' => $request->get('value') ],
                                ['value_idx' => $request->get('value_idx') ],
                                ['active_day' => $request->get('active_day') ],
                                ['active_time' => $request->get('active_time') ],
                                ['moq' => $request->get('moq') ],
                                ['type_customer' => $request->get('type_customer') ],
                                ['date_end' => Carbon::createFromFormat('d-m-Y', $request->get('dated_end'))->format('Y-m-d')],
                                ['date_start' => Carbon::createFromFormat('d-m-Y', $request->get('dated_start'))->format('Y-m-d') ],
                            )
                        );

        return redirect()->route('promo.index')
            ->withSuccess(__('Promo updated successfully.'));
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
        Voucher::where('product_id','=',$product)
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