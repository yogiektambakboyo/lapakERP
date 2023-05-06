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
use App\Models\Settings;
use App\Models\ProductBrand;
use App\Models\Shift;
use App\Models\ProductCategory;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\CloseShiftExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;
use App\Http\Controllers\Lang;



class ReportCloseShiftController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="productsbrand",$id=1;

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
        // Closure as callback
        
    }

    public function index(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $report_data = DB::select("
                select s.id as shift_id,b.id as branch_id,b.remark as branch_name,im.dated ,s.remark as shift_name,sum(id.total+id.vat_total) as total_all,
                sum(case when ps.type_id = 2 then id.total+id.vat_total else 0 end) as total_service,
                sum(case when ps.type_id = 1 and ps.category_id !=26 then id.total+id.vat_total else 0 end) as total_product,
                sum(case when ps.type_id = 1 and ps.category_id =26 then id.total+id.vat_total else 0 end) as total_drink,
                sum(case when ps.type_id = 8 then id.total+id.vat_total else 0 end) as total_extra,
                sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
                sum(case when im.payment_type = 'BCA - Debit' then id.total+id.vat_total else 0 end) as total_b_d,
                sum(case when im.payment_type = 'BCA - Kredit' then id.total+id.vat_total else 0 end) as total_b_k,
                sum(case when im.payment_type = 'Mandiri - Debit' then id.total+id.vat_total else 0 end) as total_m_d,
                sum(case when im.payment_type = 'Mandiri - Kredit' then id.total+id.vat_total else 0 end) as total_m_k,
                sum(case when im.payment_type = 'QRIS' then id.total+id.vat_total else 0 end) as total_qr,
                sum(case when im.payment_type = 'Transfer' then id.total+id.vat_total else 0 end) as total_tr,
                count(distinct im.invoice_no) qty_transaction,count(distinct im.customers_id) qty_customers
                from invoice_master im 
                join invoice_detail id on id.invoice_no  = im.invoice_no 
                join product_sku ps on ps.id = id.product_id 
                join customers c on c.id = im.customers_id 
                join branch b on b.id = c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join branch_shift bs on bs.branch_id = b.id
                join shift s on im.created_at::time  between s.time_start and s.time_end and s.id = bs.shift_id
                where im.dated>now()-interval'7 days'
                group by b.remark,im.dated,s.remark,b.id,s.id              
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        return view('pages.reports.close_shift',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function getdata(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        $filter_begin_date = date(Carbon::parse($request->filter_begin_date)->format('Y-m-d'));
        $filter_shift = $request->get('filter_shift')==null?'%':$request->get('filter_shift');
        $filter_branch_id =  $request->get('filter_branch_id')==null?'%':$request->get('filter_branch_id');
        $report_data = DB::select("
                select ps.category_id,s.remark as shift_name,b.remark as branch_name,im.dated,id.product_name,ps.abbr,ps.type_id,id.price,sum(id.qty) as qty,sum(id.total+id.vat_total) as total,count(distinct c.id) as qty_customer
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_sku ps on ps.id = id.product_id 
                join branch_shift bs on bs.branch_id = b.id
                join shift s on s.id = ".$filter_shift."  and s.id = bs.shift_id
                where im.dated = '".$filter_begin_date."' and im.created_at::time  between s.time_start and s.time_end  and c.branch_id = ".$filter_branch_id."
                group by ps.category_id,s.remark,b.remark,im.dated,id.product_name,ps.abbr,id.price,ps.type_id                         
        ");

        $creator = DB::select("
                select coalesce(string_agg(distinct created_by,', '),'-') as created_by from (select coalesce(u.name,'-') as created_by
                from invoice_master im 
                join customers c on c.id= im.customers_id 
                join users u on u.id= im.created_by
                join branch_shift bs on bs.branch_id = c.branch_id
                join shift s on s.id = ".$filter_shift."  and s.id = bs.shift_id
                where im.dated = '".$filter_begin_date."'  and c.branch_id = ".$filter_branch_id."  and im.created_at::time  between s.time_start and s.time_end  order by im.invoice_no   
                ) a             
        ");

        $payment_data = DB::select("
                select im.invoice_no,im.total_payment,im.payment_type,count(distinct im.invoice_no) as qty_payment
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join shift s on s.id = ".$filter_shift."
                where im.dated = '".$filter_begin_date."' and im.created_at::time  between s.time_start and s.time_end  and c.branch_id = ".$filter_branch_id." 
                 group by im.invoice_no,im.total_payment,im.payment_type                       
        ");
        $cust = DB::select("
                select count(distinct c.id) as c_cus
                from invoice_master im 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id 
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join shift s on s.id = ".$filter_shift."
                where im.dated = '".$filter_begin_date."' and im.created_at::time  between s.time_start and s.time_end  and c.branch_id = ".$filter_branch_id."                      
        ");

        $petty_datas = DB::select("
            select ps.abbr,pc.type,sum(pcd.qty) qty,sum(pcd.line_total) as total  from petty_cash pc 
            join petty_cash_detail pcd on pcd.doc_no = pc.doc_no
            join product_sku ps on ps.id = pcd.product_id 
            join shift s on s.id = ".$filter_shift."
            join users_branch as ub on ub.branch_id = pc.branch_id and ub.user_id = '".$user->id."'
            where pc.dated  = '".$filter_begin_date."' and pc.created_at::time between s.time_start and s.time_end  and pc.branch_id = ".$filter_branch_id."  
            group by ps.abbr,pc.type order by 1                   
        ");
        $out_data = DB::select("
                select ps2.abbr,sum(pi2.qty) as qty 
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join customers c on c.id = im.customers_id 
                join branch b on b.id=c.branch_id
                join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                join product_sku ps on ps.id = id.product_id 
                join product_ingredients pi2 on pi2.product_id = ps.id 
                join product_sku ps2 on ps2.id = pi2.product_id_material 
                join shift s on s.id = ".$filter_shift." 
                where im.dated = '".$filter_begin_date."'  and im.created_at::time between s.time_start and s.time_end and c.branch_id = ".$filter_branch_id."
                group by ps2.abbr                    
        ");
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);


        return view('pages.reports.close_shift_print', [
            'data' => $data,
            'payment_datas' => $payment_data,
            'report_datas' => $report_data,
            'out_datas' => $out_data,
            'creator' => $creator,
            'settings' => Settings::get(),
            'petty_datas' => $petty_datas,
            'cust' => $cust,
        ]);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.reports.close_shift_print', [
            'data' => $data,
            'payment_datas' => $payment_data,
            'report_datas' => $report_data,
            'out_datas' => $out_data,
            'creator' => $creator,
            'settings' => Settings::get(),
            'petty_datas' => $petty_datas,
            'cust' => $cust,
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');

        return view('pages.reports.print',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        
        $shifts = Shift::orderBy('shift.id')->get(['shift.id','shift.remark','shift.id','shift.time_start','shift.time_end']); 
        
        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $branchx = $request->filter_branch_id_in;
        $shift_id = $request->filter_shift_id_in;

        if($request->export=='Export Excel'){
             $strencode = base64_encode($shift_id.'#'.$begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new CloseShiftExport($strencode), 'closeshift_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
                    select s.id as shift_id,b.id as branch_id,b.remark as branch_name,im.dated ,s.remark as shift_name,sum(id.total+id.vat_total) as total_all,
                    sum(case when ps.type_id = 2 then id.total+id.vat_total else 0 end) as total_service,
                    sum(case when ps.type_id = 1 and ps.category_id !=26 then id.total+id.vat_total else 0 end) as total_product,
                    sum(case when ps.type_id = 1 and ps.category_id =26 then id.total+id.vat_total else 0 end) as total_drink,
                    sum(case when ps.type_id = 8 then id.total+id.vat_total else 0 end) as total_extra,
                    sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
                    sum(case when im.payment_type = 'BCA - Debit' then id.total+id.vat_total else 0 end) as total_b_d,
                    sum(case when im.payment_type = 'BCA - Kredit' then id.total+id.vat_total else 0 end) as total_b_k,
                    sum(case when im.payment_type = 'Mandiri - Debit' then id.total+id.vat_total else 0 end) as total_m_d,
                    sum(case when im.payment_type = 'Mandiri - Kredit' then id.total+id.vat_total else 0 end) as total_m_k,
                    sum(case when im.payment_type = 'QRIS' then id.total+id.vat_total else 0 end) as total_qr,
                    sum(case when im.payment_type = 'Transfer' then id.total+id.vat_total else 0 end) as total_tr,
                    count(distinct im.invoice_no) qty_transaction,count(distinct im.customers_id) qty_customers
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no  = im.invoice_no 
                    join product_sku ps on ps.id = id.product_id 
                    join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$branchx."%'
                    join branch b on b.id = c.branch_id
                    join users_branch as ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                    join branch_shift bs on bs.branch_id = b.id
                    join shift s on im.created_at::time  between s.time_start and s.time_end and s.id::character varying like '%".$shift_id."%'  and s.id = bs.shift_id
                    where im.dated between '".$begindate."' and '".$enddate."'
                    group by b.remark,im.dated,s.remark,b.id,s.id              
            ");         
            return view('pages.reports.close_shift',['company' => Company::get()->first()], compact('shifts','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.productsbrand.create',[
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
        $data = $this->data;
        //return $product->id;
        $products = Product::join('product_type as pt','pt.id','=','product_sku.type_id')
        ->join('product_category as pc','pc.id','=','product_sku.category_id')
        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
        ->where('product_sku.id',$product->id)
        ->get(['product_sku.id as product_id','product_sku.abbr','product_sku.remark as product_name','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand'])->first();

        return view('pages.productsbrand.show', [
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
        $data = $this->data;
        $brand = ProductBrand::where('product_brand.id',$productbrand->id)
        ->get(['product_brand.id as id','product_brand.remark'])->first();
        return view('pages.productsbrand.edit', [
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