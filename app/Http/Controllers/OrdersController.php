<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\Voucher;
use App\Models\JobTitle;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\Customer;
use App\Models\Settings;
use App\Models\SettingsDocumentNumber;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\OrdersExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use App\Models\Company;
use Barryvdh\DomPDF\Facade\Pdf;
use charlieuki\ReceiptPrinter\ReceiptPrinter as ReceiptPrinter;
use App\Http\Controllers\Lang;


class OrdersController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="orders",$id=1;

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

        $has_period_stock = DB::select("
            select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
        ");

        if(count($has_period_stock)<=0){
            DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
            select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
            from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int-1;");
        }

        SettingsDocumentNumber::where('doc_type','=','Order_Queue')->whereRaw('updated_at::date!=now()::date')->where('period','=','Daily')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );

        SettingsDocumentNumber::where('doc_type','=','Order')->whereRaw("to_char(updated_at,'YYYYY')!=to_char(now(),'YYYYY') ")->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        $orders = Order::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','order_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $user->id)->where('order_master.dated','>=',Carbon::now()->subDay(7)) 
              ->paginate(10,['order_master.id','b.remark as branch_name','order_master.order_no','order_master.dated','jt.name as customer','order_master.total','order_master.total_discount','order_master.total_payment' ]);
        return view('pages.orders.index',['company' => Company::get()->first()], compact('orders','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        
        $begindate = date(Carbon::parse($request->filter_begin_date)->format('Y-m-d'));
        $enddate = date(Carbon::parse($request->filter_end_date)->format('Y-m-d'));
        $branchx = $request->filter_branch_id;
        $fil = [ $begindate , $enddate ];

    
        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx.'#'.Auth::user()->id);
            return Excel::download(new OrdersExport($strencode), 'orders_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $orders = Order::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','order_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $user->id)
                ->where('order_master.order_no','ilike','%'.$keyword.'%')  
                ->where('b.id','like','%'.$branchx.'%')  
                ->whereBetween('order_master.dated',$fil)  
              ->paginate(10,['order_master.id','b.remark as branch_name','order_master.order_no','order_master.dated','jt.name as customer','order_master.total','order_master.total_discount','order_master.total_payment' ]);
        return view('pages.orders.index',['company' => Company::get()->first()], compact('orders','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch','users_branch.branch_id', '=', 'users.branch_id')
                        //->join('shift_counter','shift_counter.users_id','=','users.id')
                        ->join('shift_counter', function($join)
                         {
                             $join->on('shift_counter.users_id','=','users.id');
                             $join->on('shift_counter.branch_id','=','users_branch.branch_id');
                         })
                        ->where([
                            ['users_branch.user_id','=',$user->id],
                            ['users.job_id','=',2]
                        ])->orderBy('shift_counter.queue_no','asc')->get(['users.id','users.name','shift_counter.queue_no']);
        return view('pages.orders.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    public function getproduct() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select '' as executed_at,m.remark as uom,product_sku.vat as vat_total,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price+coalesce(pa.value,0) as price,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        join product_uom pu on pu.product_id = product_sku.id
        join uom m on m.id = pu.uom_id
        join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id = pp.branch_id and ub.branch_id=pd.branch_id 
        join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = pp.branch_id and pk.qty > 0
        left join price_adjustment pa on pa.product_id = pd.product_id and pa.branch_id = pd.branch_id and now()::date between pa.dated_start and pa.dated_end
        where product_sku.active = '1'  order by product_sku.remark");
        return $product;
    }

    public function getproduct_nostock() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select '' as executed_at,m.remark as uom,product_sku.vat as vat_total,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price+coalesce(pa.value,0) as price,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        join product_uom pu on pu.product_id = product_sku.id
        join uom m on m.id = pu.uom_id
        join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id = pp.branch_id and ub.branch_id=pd.branch_id 
        left join price_adjustment pa on pa.product_id = pd.product_id and pa.branch_id = pd.branch_id and now()::date between pa.dated_start and pa.dated_end
        where product_sku.active = '1'  order by product_sku.remark");
        return $product;
    }

    public function checkvoucher(Request $request){
        $user = Auth::user();
        $where = " now() between voucher.dated_start and voucher.dated_end";
        /**$voucher = Voucher::whereRaw($where)
                    ->join('users_branch as ub','ub.branch_id', '=', 'voucher.branch_id')
                    ->join('branch as b','b.id','=','ub.branch_id')
                    ->join('voucher_detail as vd','vd.voucher_code','=','voucher.voucher_code')
                    ->where('ub.user_id',$user->id)
                    ->where('voucher.is_used',0)
                    ->where('voucher.voucher_code','=',$request->get('voucher_code'))
                    ->get(['vd.product_id','voucher.remark','voucher.value','voucher.value_idx']);**/
        $voucher = DB::select("select vd.product_id,v.remark,v.value,v.value_idx,v.moq from voucher v
                                join users_branch ub on  ub.branch_id=v.branch_id 
                                join branch b on b.id=ub.branch_id 
                                join voucher_detail vd on vd.voucher_code=v.voucher_code
                                where (v.is_used=0 or v.unlimeted=1) and ub.user_id='".$user->id."' and now() between v.dated_start and v.dated_end and v.voucher_code = '".$request->get('voucher_code')."' ;
                                ");
        return $voucher; 
    }

    public function printthermal(Order $order) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $order->update(
            array_merge(
                ["printed_at" => Carbon::now()],
                ["printed_count" => $order->printed_count+1]
            )
        );

        $data = $this->data;
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        // Set data
        $settings = Settings::get()->first();
        $branch = Branch::join('customers','customers.branch_id','=','branch.id')
                    ->join('order_master','order_master.customers_id','=','customers.id')->where('order_master.order_no','=',$order->order_no)->get('branch.*')->first();
        $orderdetail = OrderDetail::join('uom','uom.remark','=','order_detail.uom')->join('product_sku','product_sku.id','=','order_detail.product_id')->where('order_no','=',$order->order_no)->get(['uom.conversion','product_name','qty','price','order_detail.vat','product_sku.type_id']);
        $terapists = OrderDetail::where('order_no','=',$order->order_no)->distinct()->get(['assigned_to_name']);

        // Init printer
        $printer = new ReceiptPrinter;
        $printer->init(
            config('receiptprinter.connector_type'),
            config('receiptprinter.connector_descriptor')
        );
        
        $currency = 'Rp';
        $image_path = 'logo.png';
        $tax_percentage = $orderdetail[0]->vat;

        // Header
        $store_name = $branch->remark;
        $store_address = $branch->address;

        // Set store info
        //$printer->setStore($mid, $store_name, $store_address, $store_phone, $store_email, $store_website);
        $printer->setStore('', $store_name, $store_address, '', '', '');

        // Set currency
        $printer->setCurrency($currency);

        // Recipet Information
        $printer->setDated(substr(explode(" ",$order->dated)[0],5,2)."-".substr(explode(" ",$order->dated)[0],8,2)."-".substr(explode(" ",$order->dated)[0],0,4));
        $customer_name = $order->customers_name;
        $room_name = Room::where('id','=',$order->branch_room_id)->get()->first()->remark;
        $transaction_id = $order->order_no;

        $printer->setCustomerName($customer_name);
        $printer->setRoomName($room_name);
        $printer->setOperator(User::where('id','=',$order->created_by)->get('name')->first()->name);
        
        // Set transaction ID
        $printer->setTransactionID($transaction_id);

        foreach ($terapists as $terapist) {
            $printer->addTerapist(
                $terapist['assigned_to_name']
            );
        }

        // Add items
        $scheduled_at = $order->scheduled_at;
        $sum_scheduled_at = $scheduled_at;
        foreach ($orderdetail as $item) {
            $printer->addItem(
                $item['product_name'],
                $item['qty'],
                $item['price'],
                $item['type_id']
            );

            $printer->addTimeExec(Carbon::parse($sum_scheduled_at)->isoFormat('H:mm').' - '.(Carbon::parse($sum_scheduled_at)->add($item['conversion'].' minutes')->isoFormat('H:mm')));
            $sum_scheduled_at = Carbon::parse($sum_scheduled_at)->add($item['conversion'].' minutes')->isoFormat('H:mm');
        }

        $printer->printReceiptSPK();

        $room = Room::where('branch_room.id','=',$order->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'room' => $room,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['om.tax','om.voucher_code','us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total','ps.id','ps.remark as product_name','order_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]); 
    }

    public function print(Order $order) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $order->update(
            array_merge(
                ["printed_at" => Carbon::now()],
                ["printed_count" => $order->printed_count+1]
            )
        );

        $data = $this->data;
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.orders.print', [
            'data' => $data,
            'customers' => Customer::join('order_master as om','om.customers_id','customers.id')->join('branch_room as br','br.id','om.branch_room_id')->join('branch as b','b.id','=','customers.branch_id')->get(['br.remark as room_name','b.remark as branch_name','customers.id','customers.name']),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'order' => $order,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['om.customers_name','om.tax','om.voucher_code','us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total','ps.id','order_detail.product_name','order_detail.discount','ps.type_id','om.scheduled_at','um.conversion']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type,
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a5', 'potrait');
        return $pdf->stream('spk.pdf');
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
        $user = Auth::user();
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();
        //$count_no = DB::select("select max(id) as id from order_master om where to_char(om.dated,'YYYY')=to_char(now(),'YYYY') ");
        $count_no = SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->get(['current_value','abbr']);
        $count_no_daily = SettingsDocumentNumber::where('doc_type','=','Order_Queue')->where('branch_id','=',$branch->branch_id)->where('period','=','Daily')->get(['current_value','abbr']);
        $order_no = $count_no[0]->abbr.'-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_order = Order::create(
            array_merge(
                ['order_no' => $order_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => (int)$request->get('payment_nominal')>=(int)$request->get('total_order')?(int)$request->get('total_order'):$request->get('payment_nominal') ],
                ['scheduled_at' => Carbon::parse($request->get('scheduled_at'))->format('Y-m-d H:i:s.u') ],
                ['branch_room_id' => $request->get('branch_room_id')],
                ['voucher_code' => $request->get('voucher_code')],
                ['total_discount' => $request->get('total_discount')],
                ['tax' => $request->get('total_vat')],
                ['queue_no' => (int)($count_no_daily[0]->current_value+1)],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name ],
            )
        );

        if($request->get('voucher_code')!=""){
            Voucher::where('voucher.voucher_code','=',$request->get('voucher_code'))
            ->update(
                array_merge(
                    ['is_used' => 1]
                )
            );
        }


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
                    ['product_name' => $request->get('product')[$i]["abbr"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['vat_total' => $request->get('product')[$i]["total_vat"]],
                    ['seq' => $i ],
                    ['assigned_to' => $request->get('product')[$i]["assignedtoid"]],
                    ['assigned_to_name' => User::where('id','=',$request->get('product')[$i]["assignedtoid"])->get(['name'])->first()->name ],
                    ['referral_by' => $user->id],
                    ['referral_by_name' => User::where('id','=', $user->id)->get(['name'])->first()->name],
                )
            );

            $counters_ = DB::select("select count(users_id)+1 as c from shift_counter where branch_id='".$branch->branch_id."';"); 
            DB::select("update shift_counter set queue_no=".$counters_[0]->c.",updated_at=now() where users_id=".$request->get('product')[$i]['assignedtoid']."; ");
            DB::select("update shift_counter set queue_no=queue_no-1,updated_at=now() where  branch_id='".$branch->branch_id."'; ");


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

        SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        SettingsDocumentNumber::where('doc_type','=','Order_Queue')->where('branch_id','=',$branch->branch_id)->where('period','=','Daily')->update(
            array_merge(
                ['current_value' => ((int)($count_no_daily[0]->current_value) + 1)]
            )
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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);


        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$order->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'room' => $room,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['om.tax','om.voucher_code','us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total','ps.id','ps.remark as product_name','order_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }

    public function grid(Order $order){
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$order->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.grid',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'room' => $room,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total as sub_total','om.total as total','ps.id','ps.remark as product_name','order_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $room = Room::where('branch_room.id','=',$order->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.orders.edit',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'order' => $order,
            'room' => $room,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'orderDetails' => OrderDetail::join('order_master as om','om.order_no','=','order_detail.order_no')->join('product_sku as ps','ps.id','=','order_detail.product_id')->join('product_uom as u','u.product_id','=','order_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','order_detail.assigned_to')->where('order_detail.order_no',$order->order_no)->get(['us.name as assigned_to','um.remark as uom','order_detail.qty','order_detail.price','order_detail.total as sub_total','om.total as total','ps.id','ps.remark as product_name','order_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
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
        $product = DB::select(" select od.vat,od.vat_total,to_char(om.scheduled_at,'mm/dd/YYYY') as scheduled_date,to_char(om.scheduled_at,'HH24:MI') as scheduled_time,rm.remark as room_name,om.customers_id,om.remark as order_remark,to_char(om.dated,'mm/dd/YYYY') as dated,om.payment_type,om.payment_nominal,om.scheduled_at,om.branch_room_id,od.qty,od.product_id,od.discount,od.price,od.total,ps.remark,ps.abbr,um.remark as uom,us.name as assignedto,us.id as assignedtoid,
        usr.name as referralby,usr.id as referralbyid   
        from order_detail od 
        join order_master om on om.order_no = od.order_no
        join product_sku ps on ps.id=od.product_id
        join product_uom uo on uo.product_id = od.product_id
        join uom um on um.id=uo.uom_id 
        join users us on us.id= od.assigned_to
        join users usr on usr.id= od.referral_by
        join branch_room rm on rm.id=om.branch_room_id
        where od.order_no='".$order_no."' ");
        
        return $product;
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return  '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'.
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'.
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'.
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Terapis" id="assign_row" class="btn btn-xs btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>'.
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Dijual Oleh"  id="referral_row" class="btn btn-xs btn-purple"><div class="fa-1x"><i class="fas fa-users fa-fw"></i></div></a>' ;
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
        
        $res_order = $order->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => (int)$request->get('payment_nominal')>=(int)$request->get('total_order')?(int)$request->get('total_order'):$request->get('payment_nominal') ],
                ['scheduled_at' => Carbon::parse($request->get('scheduled_at'))->format('Y-m-d H:i:s.u') ],
                ['branch_room_id' => $request->get('branch_room_id')],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name ],
                ['voucher_code' => $request->get('voucher_code')],
                ['tax' => $request->get('total_vat')],
                ['total_discount' => $request->get('total_discount')],
            )
        );

        if($request->get('voucher_code')!=""){
            Voucher::where('voucher.voucher_code','=',$request->get('voucher_code'))
            ->update(
                array_merge(
                    ['is_used' => 1]
                )
            );
        }

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
                    ['product_name' => $request->get('product')[$i]["abbr"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['discount' => $request->get('product')[$i]["discount"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['vat_total' => $request->get('product')[$i]["total_vat"]],
                    ['seq' => $i ],
                    ['assigned_to' => $request->get('product')[$i]["assignedtoid"]],
                    ['assigned_to_name' => User::where('id','=',$request->get('product')[$i]["assignedtoid"])->get(['name'])->first()->name ],
                    ['referral_by' => $user->id],
                    ['referral_by_name' => User::where('id','=', $user->id)->get(['name'])->first()->name],
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
        if($order->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $order->order_no],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $order->order_no],
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
