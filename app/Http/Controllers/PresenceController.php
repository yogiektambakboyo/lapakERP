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


class PresenceController extends Controller
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
        
        $worktime = DB::select("select wt.id,b.remark as branch_name,u.name as nama,wt.dated,to_char(wt.dated,'dd-MM-YYYY') as dated_f,to_char(wt.time_in,'HH24:MI') time_in,case when to_char(wt.time_out,'HH24:MI')=to_char(wt.time_in,'HH24:MI') then '00:00' else to_char(wt.time_out,'HH24:MI') end time_out,wt.georeverse_in,wt.georeverse_out,wt.photo_in,wt.photo_out  from work_time wt 
        join users u on u.id = wt.user_id 
        join users_branch ub  on ub.user_id = u.id 
        join branch b  on b.id = ub.branch_id 
        where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id."  ) and wt.dated>now()-interval'7 day'
        order by wt.id");
        return view('pages.worktime.index',['company' => Company::get()->first()], compact('worktime','data','keyword','act_permission','branchs','payment_type'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            $worktime = DB::select("select wt.id,b.remark as branch_name,u.name as nama,wt.dated,to_char(wt.dated,'dd-MM-YYYY') as dated_f,to_char(wt.time_in,'HH24:MI') time_in,case when to_char(wt.time_out,'HH24:MI')=to_char(wt.time_in,'HH24:MI') then '00:00' else to_char(wt.time_out,'HH24:MI') end time_out,wt.georeverse_in,wt.georeverse_out,wt.photo_in,wt.photo_out  from work_time wt 
            join users u on u.id = wt.user_id 
            join users_branch ub  on ub.user_id = u.id 
            join branch b  on b.id = ub.branch_id and b.id::character varying like  '%".$branchx."%'
            where ub.branch_id in (select ub2.branch_id from users_branch ub2 where ub2.user_id = ".$user->id." ) and wt.dated between '".$begindate."' and '".$enddate."'
            order by wt.id");
        
        return view('pages.worktime.index',['company' => Company::get()->first()], compact('worktime','data','keyword','act_permission','branchs','payment_type'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new UsersExport, 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
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
        $user = Auth::user();
        $payment_type = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $payment_type_new = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        //$usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->orderBy('users.name','ASC')->get(['users.id','users.name']);
        
        
        $usersall = DB::select("select distinct id,name from users where id in (
            select ubb.user_id 
            from users_branch ub 
            join users_branch ubb on ubb.branch_id = ub.branch_id
            where ub.user_id = ".$user->id." 
            ) and job_id in (1,2) and users.active=1
            order by name;"
        );
        

            
        return view('pages.invoices.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('customers.status','=','1')->where('ub.user_id',$user->id)->orderBy('customers.name')->limit(30)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'userx' => $user,
            'usersall' => $usersall,
            'type_customers' => $type_customer,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

   
    /**
     * Show user data
     * 
     * @param Invoice $invoice
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        if($invoice->branch_room_id == ""){
            $room_id = 14;
        }else{
            $room_id = $invoice->branch_room_id;
        }
        $room = Room::where('branch_room.id','=', $room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $payment_type_new = ['Cash','BANK 1 - Debit','BANK 1 - Kredit','BANK 2 - Debit','BANK 2 - Kredit','BANK 1 - Transfer','BANK 2 - Transfer','BANK 1 - QRIS','BANK 2 - QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.invoices.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'type_customers' => $type_customer,
            'orderDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw(' ps.type_id DESC, invoice_detail.seq  ASC')->get(['usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code','invoice_detail.executed_at']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
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
