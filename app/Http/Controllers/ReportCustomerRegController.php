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
use App\Models\Customer;
use App\Models\ProductBrand;
use App\Models\ProductCategory;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ReportCustomerRegExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use App\Http\Controllers\Lang;


class ReportCustomerRegController extends Controller
{
    /**
     * Display all products
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="customer_registration",$id=1;

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

        $report_data = DB::select("
            select b.remark as  branch_name,s.name as sellername,cr.id,cr.name,cr.address,cr.phone_no,cr.handphone,cr.city,cr.credit_limit,cr.longitude,cr.latitude,cr.email,cr.citizen_id,cr.tax_id,cr.contact_person,cr.contact_person_job_position,cr.contact_person_level,cr.type,cr.clasification,cr.photo,regexp_replace(cr.notes, E'[\\n\\r]+', ' ', 'g' ) as notes,cr.created_at 
            from customers_registration cr 
            join sales s on s.id = cr.sales_id 
            join branch b on b.id = s.branch_id where cr.is_approved=0 order by  b.remark
        ");
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $brands = ProductBrand::orderBy('product_brand.remark', 'ASC')
                    ->paginate(10,['product_brand.id','product_brand.remark']);
        return view('pages.reports.customer_reg',['company' => Company::get()->first()] ,compact('brands','branchs','data','keyword','act_permission','report_data'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function approve(Request $request)
    {   
    
        if($request->get('input_approve')==1){
                DB::select("
                INSERT INTO public.customers
                (name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, ref_id)
                select  name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level,id
                from customers_registration cr where cr.id = ".$request->get('input_id')." and cr.is_approved = 0;
            ");

            Customer::where('ref_id','=',$request->get('input_id'))->update(
                array_merge( 
                    ['visit_day' => $request->get('input_day') ],
                    ['visit_week' => $request->get('input_week') ],
                )
            );

            DB::select("update customers_registration set is_approved = ".$request->get('input_approve').",notes=notes||' #Reject# '||'".$request->get('input_notes')."' where id = ".$request->get('input_id')." and is_approved = 0;");

            DB::select("
                    update customers c set branch_id = s.branch_id from sales s where s.id = c.sales_id and c.branch_id = 1 and c.created_at > now()-interval '1 day';
            ");
        }else{
            DB::select("update customers_registration set is_approved = ".$request->get('input_approve')." where id = ".$request->get('input_id')." and is_approved = 0;");
        }

    
        DB::select("update customers_registration set is_approved = ".$request->get('input_approve').",notes=notes||' #Reject# '||'".$request->get('input_notes')."' where id = ".$request->get('input_id')." and is_approved = 0;");

        return redirect()->route('reports.customer_reg.index')
            ->withSuccess(__('Customer approval successfully.'));
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

        $begindate = date(Carbon::parse($request->filter_begin_date_in)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date_in)->format('Y-m-d'));
        $branchx = $request->filter_branch_id_in;

        if($request->export=='Export Excel'){
            $strencode = base64_encode($begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id);
            return Excel::download(new ReportCustomerRegExport($strencode), 'report_customer_reg'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $report_data = DB::select("
                    select b.remark as  branch_name,s.name as sellername,cr.id,cr.name,cr.address,cr.phone_no,cr.handphone,cr.city,cr.credit_limit,cr.longitude,cr.latitude,cr.email,cr.citizen_id,cr.tax_id,cr.contact_person,cr.contact_person_job_position,cr.contact_person_level,cr.type,cr.clasification,cr.photo,regexp_replace(cr.notes, E'[\\n\\r]+', ' ', 'g' ) as notes,cr.created_at  
                    from customers_registration cr 
                    join sales s on s.id = cr.sales_id 
                    join branch b on b.id = s.branch_id and b.id::character varying like '%".$branchx."%'
                    where cr.is_approved=0 and cr.created_at::date between '".$begindate."' and '".$enddate."'
                    order by  b.remark   
            ");          
            return view('pages.reports.customer_reg',['company' => Company::get()->first()], compact('report_data','branchs','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new ProductsExport, 'customerreg_'.Carbon::now()->format('YmdHis').'.xlsx');
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

        return view('pages.productsbrand.show', [
            'product' => $products ,
            'data' => $data, 'company' => Company::get()->first(),
        ]);
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