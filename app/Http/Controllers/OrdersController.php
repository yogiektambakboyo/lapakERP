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


class OrdersController extends Controller
{
    /**
     * Display all users
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
        $user = Auth::user();
        
        //$orders = DB::select("select om.id,b.remark as branch_name,om.order_no,om.dated,jt.name as customer,om.total,om.total_discount,total_payment from order_master om 
        //                        join customers as jt on jt.id=om.customers_id
        //                        join branch as b on b.id=jt.branch_id
         //                       join users_branch as ub on ub.branch_id= b.id and ub.branch_id=jt.branch_id
        //");
        
        $orders = Order::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','order_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $user->id)  
              ->paginate(10,['order_master.id','b.remark as branch_name','order_master.order_no','order_master.dated','jt.name as customer','order_master.total','order_master.total_discount','order_master.total_payment' ]);
        return view('pages.orders.index', compact('orders','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $keyword = $request->search;
        $data = $this->data;

        if($request->export=='Export Excel'){
            return Excel::download(new UsersExport($keyword), 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.name','LIKE','%'.$keyword.'%')->paginate(10,['users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date' ]);
            return view('pages.orders.index', compact('users','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.orders.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
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
        $timetable = DB::select(" select br.remark as branch_room_name,om.order_no,c.name as customer_name,to_char(om.scheduled_at,'YYYY-MM-DD HH24:MI') scheduled_at,case when sum(u.conversion)<30 then 30 else sum(u.conversion) end as duration,
        case when sum(u.conversion)<30 then to_char(om.scheduled_at+interval'30 minutes','YYYY-MM-DD HH24:MI') 
        else to_char((om.scheduled_at+interval '1 minutes' * sum(u.conversion)),'YYYY-MM-DD HH24:MI') end as est_end
        from order_master om
        join order_detail od on od.order_no = om.order_no 
        join product_uom pu on pu.product_id = od.product_id 
        join uom u  on u.id = pu.uom_id 
        join customers c on c.id = om.customers_id 
        join branch_room br on br.branch_id = c.branch_id and br.id = om.branch_room_id 
        join users_branch ub on ub.branch_id = br.branch_id and ub.branch_id = c.branch_id and ub.user_id = ".$user->id."
        where scheduled_at >= now()::date and om.is_checkout='0'
        group by br.remark,om.order_no,om.customers_id,om.scheduled_at,c.name
        order by 1,4 ");
        return Datatables::of($timetable)->make();
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param Order $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
        
        $user = Auth::user();
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();
        $count_no = DB::select("select max(id) as id from order_master om where to_char(om.dated,'YYYY')=to_char(now(),'YYYY') ");
        $order_no = 'ORD-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->id) + 1)),-8);

        $res_order = Order::create(
            array_merge(
                ['order_no' => $order_no ],
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
            )
        );

        if(!$res_order){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save order failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_order_detail = OrderDetail::create(
                array_merge(
                    ['order_no' => $order_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['seq' => $i ],
                    ['assigned_to' => $request->get('product')[$i]["assignedtoid"]],
                    ['referral_by' => $user->id],
                )
            );


            if(!$res_order_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save order detail failed'],
                );
        
                return $result;
            }
        }


        $result = array_merge(
            ['status' => 'success'],
            ['data' => $order_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Show user data
     * 
     * @param Order $order
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Order $order) 
    {
        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$order->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','Debit Card'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'room' => $room,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total','ps.id','ps.remark as product_name','order_detail.discount']),
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
    public function edit(Order $order) 
    {
        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','Debit Card'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.edit',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->where('order_detail.order_no',$order->order_no)->get(['order_detail.qty','order_detail.price','order_detail.total','ps.id','ps.remark as product_name','order_detail.discount']),
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
    public function getorder(String $order_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select od.qty,od.product_id,od.discount,od.price,od.total,ps.remark,ps.abbr from order_detail od join product_sku ps on ps.id=od.product_id where od.order_no='".$order_no."' ");
        
        return $product;
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return  '<a href="#" id="add_row" class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'.
            '<a href="#" id="minus_row" class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'.
            '<a href="#" id="delete_row" class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>';
        })->make();
    }

    /**
     * Update user data
     * 
     * @param User $user
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Order $order, Request $request) 
    {

        $user = Auth::user();
        $order_no = $request->get('order_no');

        OrderDetail::where('order_no', $order_no)->delete();
        //$order->delete();

        $res_order = $order->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('d/m/Y') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => $request->get('total_order') ],
                ['scheduled_at' => $request->get('scheduled_at')],
                ['branch_room_id' => $request->get('branch_room_id')],
            )
        );

        if(!$res_order){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save order failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_order_detail = OrderDetail::create(
                array_merge(
                    ['order_no' => $order_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['seq' => $i ],
                    ['assigned_to' => $user->id],
                    ['referral_by' => $user->id],
                )
            );


            if(!$res_order_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save order detail failed'],
                );
        
                return $result;
            }
        }


        $result = array_merge(
            ['status' => 'success'],
            ['data' => $order_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Delete user data
     * 
     * @param Order $order
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(Order $order) 
    {
        OrderDetail::where('order_no', $order->order_no)->delete();

        $order->delete();

        return redirect()->route('orders.index')
            ->withSuccess(__('Order deleted successfully.'));
    }
}
