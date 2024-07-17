<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\WorkTime;
use App\Models\Product;
use App\Models\JobTitle;
use App\Models\Settings;
use App\Models\Supplier;
use App\Models\Order;
use App\Models\PeriodSellPrice;
use App\Models\SettingsDocumentNumber;
use App\Models\OrderDetail;
use App\Models\PurchaseDetail;
use App\Models\Invoice;
use App\Models\ProductIngredients;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\InvoiceDetail;
use App\Models\Customer;
use App\Models\Department;
use App\Models\Voucher;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\InvoicesExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use charlieuki\ReceiptPrinter\ReceiptPrinter as ReceiptPrinter;
use App\Http\Controllers\Lang;


class PresenceSumController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="work_time",$id=1;

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

        $payment_type = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $payment_type_new = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];

        $data = $this->data;
        $keyword = "";
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        
        $worktime = DB::select("
        select a.branch_name,a.dated,a.dated_f,sum(c_in) as c_in,sum(c_leave) as c_leave from (
            select b.remark as branch_name,wt.dated,to_char(wt.dated,'dd-MM-YYYY') as dated_f,count(distinct u.id) c_in,0 as c_leave 
            from work_time wt
            join users u on u.id = wt.user_id 
            join users_branch ub  on ub.user_id = u.id 
            join branch b  on b.id = ub.branch_id 
            where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id."  ) and wt.dated>now()-interval'307 day'
            group by b.remark,wt.dated
            union
            select b.remark as branch_name,c.dated,to_char(c.dated,'dd-MM-YYYY') as dated_f,0 c_in,count(distinct u.id) as c_leave 
            from leave_request wt
            join calendar c on c.dated between wt.dated_start and wt.dated_end
            join users u on u.id = wt.user_id 
            join users_branch ub  on ub.user_id = u.id 
            join branch b  on b.id = ub.branch_id 
            where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id."  ) and c.dated>now()-interval'307 day'
            group by b.remark,c.dated
        ) a 
        group by a.branch_name,a.dated,a.dated_f
        order by 2

        ");
        return view('pages.worktimesum.index',['company' => Company::get()->first()], compact('worktime','data','keyword','act_permission','branchs','payment_type'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $payment_type = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $payment_type_new = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];


        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $begindate = Carbon::createFromFormat('d/m/Y', $request->filter_begin_date)->format('Y-m-d');        
        $enddate = Carbon::createFromFormat('d/m/Y', $request->filter_end_date)->format('Y-m-d');
        $branchx = $request->filter_branch_id;
        $fil = [ $begindate , $enddate ];

        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx.'#'.Auth::user()->id);
            return Excel::download(new InvoicesExport($strencode), 'invoices_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $worktime = DB::select("
            select a.branch_name,a.dated,a.dated_f,sum(c_in) as c_in,sum(c_leave) as c_leave from (
            select b.remark as branch_name,wt.dated,to_char(wt.dated,'dd-MM-YYYY') as dated_f,count(distinct u.id) c_in,0 as c_leave 
            from work_time wt
            join users u on u.id = wt.user_id 
            join users_branch ub  on ub.user_id = u.id 
            join branch b  on b.id = ub.branch_id and b.id::character varying like  '%".$branchx."%'
            where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id."  ) and wt.dated between '".$begindate."' and '".$enddate."'
            group by b.remark,wt.dated
            union
            select b.remark as branch_name,c.dated,to_char(c.dated,'dd-MM-YYYY') as dated_f,0 c_in,count(distinct u.id) as c_leave 
            from leave_request wt
            join calendar c on c.dated between wt.dated_start and wt.dated_end
            join users u on u.id = wt.user_id 
            join users_branch ub  on ub.user_id = u.id 
            join branch b  on b.id = ub.branch_id and b.id::character varying like  '%".$branchx."%'
            where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id."  ) and c.dated between '".$begindate."' and '".$enddate."'
            group by b.remark,c.dated
        ) a 
        group by a.branch_name,a.dated,a.dated_f
        order by 2

        
           ");
        
        return view('pages.worktimesum.index',['company' => Company::get()->first()], compact('worktime','data','keyword','act_permission','branchs','payment_type'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new UsersExport, 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
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
