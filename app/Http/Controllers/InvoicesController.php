<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\JobTitle;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\Invoice;
use App\Models\InvoiceDetail;
use App\Models\Customer;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\UsersExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;


class InvoicesController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="invoices";

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
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        
        $invoices = Invoice::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','invoice_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $user->id)  
              ->paginate(10,['invoice_master.id','b.remark as branch_name','invoice_master.invoice_no','invoice_master.dated','jt.name as customer','invoice_master.total','invoice_master.total_discount','invoice_master.total_payment' ]);
        return view('pages.invoices.index', compact('invoices','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $keyword = $request->search;
        $data = $this->data;

        if($request->export=='Export Excel'){
            return Excel::download(new UsersExport($keyword), 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.name','LIKE','%'.$keyword.'%')->paginate(10,['users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date' ]);
            return view('pages.invoices.index', compact('users','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','Debit Card'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        return view('pages.invoices.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    public function getproduct() 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select m.remark as uom,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        join product_uom pu on pu.product_id = product_sku.id
        join uom m on m.id = pu.uom_id
        join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id = pp.branch_id and ub.branch_id=pd.branch_id 
        join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = ub.branch_id
        where product_sku.active = '1' ");
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return '<a href="#"  onclick="addProduct(\''.$product->id.'\',\''.$product->abbr.'\', \''.$product->price.'\', \'0\', \'1\', \''.$product->uom.'\');" class="btn btn-xs btn-primary"><div class="fa-1x"><i class="fas fa-basket-shopping fa-fw"></i></div></a>';
        })->make();
    }

    public function gettimetable() 
    {
        $data = $this->data;
        $user = Auth::user();
        $timetable = DB::select(" select br.remark as branch_room_name,om.invoice_no,c.name as customer_name,to_char(om.scheduled_at,'YYYY-MM-DD HH24:MI') scheduled_at,case when sum(u.conversion)<30 then 30 else sum(u.conversion) end as duration,
        case when sum(u.conversion)<30 then to_char(om.scheduled_at+interval'30 minutes','YYYY-MM-DD HH24:MI') 
        else to_char((om.scheduled_at+interval '1 minutes' * sum(u.conversion)),'YYYY-MM-DD HH24:MI') end as est_end
        from invoice_master om
        join invoice_detail od on od.invoice_no = om.invoice_no 
        join product_uom pu on pu.product_id = od.product_id 
        join uom u  on u.id = pu.uom_id 
        join customers c on c.id = om.customers_id 
        join branch_room br on br.branch_id = c.branch_id and br.id = om.branch_room_id 
        join users_branch ub on ub.branch_id = br.branch_id and ub.branch_id = c.branch_id and ub.user_id = ".$user->id."
        where scheduled_at >= now()::date and om.is_checkout='0'
        group by br.remark,om.invoice_no,om.customers_id,om.scheduled_at,c.name
        order by 1,4 ");
        return Datatables::of($timetable)->make();
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param Invoice $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
        
        $user = Auth::user();
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();
        $count_no = DB::select("select max(id) as id from invoice_master om where to_char(om.dated,'YYYY')=to_char(now(),'YYYY') ");
        $invoice_no = 'INV-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->id) + 1)),-8);

        $res_invoice = Invoice::create(
            array_merge(
                ['invoice_no' => $invoice_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('d/m/Y') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => $request->get('total_order') ],
                ['scheduled_at' => Carbon::parse($request->get('scheduled_at'))->format('d/m/Y H:i:s.u') ],
                ['branch_room_id' => $request->get('branch_room_id')],
                ['ref_no' => $request->get('ref_no')],
            )
        );

        $branch_id = Room::where('id',$request->get('branch_room_id'))->get(['branch_id'])->first();

        if(!$res_invoice){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save invoice failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_invoice_detail = InvoiceDetail::create(
                array_merge(
                    ['invoice_no' => $invoice_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['seq' => $i ],
                    ['assigned_to' => $request->get('product')[$i]["assignedtoid"]],
                    ['referral_by' => $request->get('product')[$i]["referralbyid"]],
                )
            );


            if(!$res_invoice_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save invoice detail failed'],
                );
        
                return $result;
            }

            DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$branch_id['branch_id']." and product_id = ".$request->get('product')[$i]["id"]);

        }


        Order::where('order_no',$request->get('ref_no'))->update(
            array_merge(
                ['is_checkout'   => '1'],
            )
        );


        $result = array_merge(
            ['status' => 'success'],
            ['data' => $invoice_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
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
        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$invoice->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','Debit Card'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.invoices.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'orderDetails' =>InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->get(['usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type,
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Invoice $invoice
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Invoice $invoice) 
    {
        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$invoice->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','Debit Card'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.invoices.edit',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'orderDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->where('invoice_detail.invoice_no',$invoice->invoice_no)->get(['us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type,
        ]);
    }

     /**
     * Edit user data
     * 
     * @param Order $order
     * 
     * @return \Illuminate\Http\Response
     */
    public function getinvoice(String $invoice_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select od.qty,od.product_id,od.discount,od.price,od.total,ps.remark,ps.abbr,um.remark as uom,us.name as assignedto,us.id as assignedtoid 
        from invoice_detail od 
        join invoice_master om on om.invoice_no = od.invoice_no
        join product_sku ps on ps.id=od.product_id
        join product_uom uo on uo.product_id = od.product_id
        join uom um on um.id=uo.uom_id 
        join users us on us.id= od.assigned_to
        where od.invoice_no='".$invoice_no."' ");
        
        return $product;
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return  '<a href="#" id="add_row" class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'.
            '<a href="#" id="minus_row" class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'.
            '<a href="#" id="delete_row" class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'.
            '<a href="#" id="assign_row" class="btn btn-xs btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>';
        })->make();
    }

    /**
     * Update user data
     * 
     * @param Invoice $invoice
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Invoice $invoice, Request $request) 
    {

        $user = Auth::user();
        $invoice_no = $request->get('invoice_no');

        InvoiceDetail::where('invoice_no', $invoice_no)->delete();

        $res_invoice = $invoice->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('d/m/Y') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => $request->get('total_order') ],
                ['scheduled_at' => Carbon::parse($request->get('scheduled_at'))->format('d/m/Y H:i:s.u') ],
                ['branch_room_id' => $request->get('branch_room_id')],
                ['ref_no' => $request->get('ref_no')],
            )
        );

        $branch_id = Room::where('id',$request->get('branch_room_id'))->get(['branch_id'])->first();

        if(!$res_invoice){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save invoice failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_invoice_detail = InvoiceDetail::create(
                array_merge(
                    ['invoice_no' => $invoice_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['seq' => $i ],
                    ['assigned_to' => $request->get('product')[$i]["assignedtoid"]],
                    ['referral_by' => $request->get('product')[$i]["referralbyid"]],
                )
            );


            if(!$res_invoice_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save invoice detail failed'],
                );
        
                return $result;
            }
           
            DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$branch_id['branch_id']." and product_id = ".$request->get('product')[$i]["id"]);
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $invoice_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Delete user data
     * 
     * @param Invoice $invoice
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(Invoice $invoice) 
    {
        InvoiceDetail::where('invoice_no', $invoice->invoice_no)->delete();

        $invoice->delete();

        return redirect()->route('invoices.index')
            ->withSuccess(__('Invoice deleted successfully.'));
    }
}
