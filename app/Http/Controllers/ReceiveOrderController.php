<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\Settings;
use App\Models\JobTitle;
use App\Models\Order;
use App\Models\PeriodSellPrice;
use App\Models\Supplier;
use App\Models\OrderDetail;
use App\Models\Invoice;
use App\Models\InvoiceDetail;
use App\Models\Purchase;
use App\Models\Receive;
use App\Models\SettingsDocumentNumber;
use App\Models\ReceiveDetail;
use App\Models\Customer;
use App\Models\LotNumber;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ReceivesExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use App\Models\Company;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Http\Controllers\Lang;



class ReceiveOrderController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="receiveorders",$id=1;

    public function __construct()
    {
        $this->middleware(function ($request, $next) {
            $this->user= Auth::user();
            $user = Auth::user();
            $role_id = $user->roles->first()->id;

            $this->act_permission = DB::select("
                select sum(coalesce(allow_create,0)) as allow_create,sum(coalesce(allow_delete,0)) as allow_delete,sum(coalesce(allow_show,0)) as allow_show,sum(coalesce(allow_edit,0)) as allow_edit from (
                    select count(1) as allow_create,0 as allow_delete,0 as allow_show,0 as allow_edit from permissions p join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.create' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,count(1) as allow_delete,0 as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.delete' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,count(1) as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.show' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,0 as allow_show,count(1) as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.edit' and p.name like '".$this->module.".%'
                ) a
            ");   
            return $next($request);
        });   
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

        SettingsDocumentNumber::where('doc_type','=','Receive')->whereRaw("to_char(updated_at,'YYYYY')!=to_char(now(),'YYYYY') ")->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );

        $has_period_sell_price = DB::select("
            select period  from period_price_sell ps where ps.period = to_char(now()::date,'YYYYMM')::int;
        ");

        if(count($has_period_sell_price)<=0){
            DB::select("insert into public.period_price_sell(period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id)
            SELECT to_char(now(),'YYYYMM')::int, product_id, value, null, null, 1, now(), branch_id
            FROM public.period_price_sell where period=to_char(now(),'YYYYMM')::int-1;");
        }

        $data = $this->data;
        $keyword = "";
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);    
        $receives = DB::select("select rm.id,b.remark as branch_name,rm.receive_no,rm.ref_no,rm.dated,rm.total,total_discount,rm.total_payment,s.name as customer  
                                from receive_master rm 
                                join suppliers s on s.id = rm.supplier_id 
                                join branch b on b.id = s.branch_id 
                                join users_branch ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                                where rm.dated > now()-interval'7 days'");
        return view('pages.receiveorders.index',['company' => Company::get()->first()], compact('receives','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            $strencode = base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
            return Excel::download(new ReceivesExport($strencode), 'receiveorder_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $receives = DB::select("select rm.id,b.remark as branch_name,rm.receive_no,rm.ref_no,rm.dated,rm.total,total_discount,rm.total_payment,s.name as customer  
                                from receive_master rm 
                                join suppliers s on s.id = rm.supplier_id 
                                join branch b on b.id = s.branch_id 
                                join users_branch ub on ub.branch_id = b.id and ub.user_id = '".$user->id."'
                                where (rm.receive_no like '%".$keyword."%' or rm.ref_no like '%".$keyword."%' ) and b.id::character varying like '%".$branchx."%' and rm.dated between '".$begindate."' and '".$enddate."' ");

            
            return view('pages.receiveorders.index',['company' => Company::get()->first()], compact('branchs','receives','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $purchases = DB::select("select distinct pm.purchase_no as purchase_no
                                from purchase_master pm
                                join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc) ub on ub.branch_id = pm.branch_id 
                                where pm.purchase_no not in (select coalesce(ref_no,'-') as po from receive_master) ");
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        return view('pages.receiveorders.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'suppliers' => $suppliers,
            'usersall' => $usersall,
            'purchases' => $purchases,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    public function createfrompo(String $po_no) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $purchases = DB::select("select distinct pm.purchase_no as purchase_no
                                from purchase_master pm
                                join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc) ub on ub.branch_id = pm.branch_id 
                                where pm.purchase_no = '".$po_no."' ");
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        //return $purchases;
        return view('pages.receiveorders.createfrompo',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'suppliers' => $suppliers,
            'usersall' => $usersall,
            'purchases' => $purchases,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    public function getproduct() 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select distinct m.remark as uom,product_sku.vat as vat_total,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,'0' as discount,'0' as qty,'0' as total
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
        return $product;
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
     * @param ReceiveOrder $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
        
        $user = Auth::user();
        //$count_no = DB::select("select max(id) as id from receive_master om where to_char(om.dated,'YYYY')=to_char(now(),'YYYY') ");
        $count_no = SettingsDocumentNumber::where('doc_type','=','Receive')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->get(['current_value','abbr']);
        $receive_no = $count_no[0]->abbr.'-'.substr(('000'.$request->get('branch_id')),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

    
        $res_receive = Receive::create(
            array_merge(
                ['receive_no' => $receive_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::parse($request->get('dated'))->format('Y-m-d') ],
                ['supplier_id' => $request->get('supplier_id') ],
                ['supplier_name' => $request->get('supplier_name') ],
                ['total' => $request->get('total_order') ],
                ['total_vat' => $request->get('total_vat') ],
                ['total_discount' => $request->get('total_discount') ],
                ['remark' => $request->get('remark') ],
                ['ref_no' => $request->get('ref_no') ],
                ['branch_id' => $request->get('branch_id')],
                ['currency' => $request->get('currency')],
                ['kurs' => $request->get('kurs')],
                ['branch_name' => $request->get('branch_name')],
            )
        );

        SettingsDocumentNumber::where('doc_type','=','Receive')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        if(!$res_receive){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save receive failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $check_lot = DB::select("select distinct lot_no as lot_no from receive_detail where po_no='".$request->get('ref_no')."' and product_id='".$request->get('product')[$i]["id"]."'; ");

            $lot_no = "";
            if(count($check_lot)>0){
                $lot_no = $check_lot[0]->lot_no;

                DB::update("update lot_number set updated_at = now(),qty_onhand = qty_onhand + ".$request->get('product')[$i]["qty"]." where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
                DB::update("update lot_number set updated_at = now(),qty_available = qty_onhand-qty_allocated where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
            }else{
                $count_no_lot = SettingsDocumentNumber::where('doc_type','=','Lot_Number')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Monthly')->get(['current_value','abbr']);
                $lot_no = $count_no_lot[0]->abbr.'-'.substr(('000'.$request->get('branch_id')),-3).'-'.date("Ym").'-'.substr(('00000000'.((int)($count_no_lot[0]->current_value) + 1)),-8);

                $res_lot_no = LotNumber::create(
                    array_merge(
                        ['doc_no' => $lot_no],
                        ['product_id' => $request->get('product')[$i]["id"]],
                        ['qty_available' => $request->get('product')[$i]["qty"]],
                        ['qty_onhand' => $request->get('product')[$i]["qty"]],
                        ['qty_allocated' => "0"],
                        ['price' => $request->get('product')[$i]["price"]],
                        ['created_by' => $user->id ],
                        ['branch_id' => $request->get('branch_id')],
                        ['currency' => $request->get('currency')],
                        ['kurs' => $request->get('kurs')],
                        ['price' => $request->get('product')[$i]["price"]],
                     )
                );

                SettingsDocumentNumber::where('doc_type','=','Lot_Number')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Monthly')->update(
                    array_merge(
                        ['current_value' => ((int)($count_no_lot[0]->current_value) + 1)]
                    )
                );
            }
            
            $res_receive_detail = ReceiveDetail::create(
                array_merge(
                    ['receive_no' => $receive_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['po_no' => $request->get('ref_no') ],
                    ['lot_no' => $lot_no ],
                    ['expired_at' => Carbon::parse($request->get('product')[$i]["exp"])->format('Y-m-d') ],
                    ['product_remark' => $request->get('product')[$i]["abbr"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['discount' => $request->get('product')[$i]["disc"]],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['seq' => $i ],
                 )
            );

            


            if(!$res_receive_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save receive detail failed'],
                );
        
                return $result;
            }

            

            PeriodSellPrice::where('branch_id','=',$request->get('branch_id'))->where('product_id','=',$request->get('product')[$i]["id"])->update(array_merge(
                [ 'value' => $request->get('product')[$i]["price"]],
                [ 'updated_at' => Carbon::now() ]
            ));

            DB::update("UPDATE product_stock set updated_at=now(),qty = qty+".$request->get('product')[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]["id"]);

            DB::insert("INSERT INTO public.product_stock_detail (product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) VALUES(".$request->get('product')[$i]['id'].", ".$request->get('branch_id').", ".$request->get('product')[$i]['qty'].", (now() + '2 years'::interval), null, now(), ".$user->id.")");
            DB::update("update public.period_stock set qty_in=qty_in+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end + ".$request->get('product')[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $receive_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Show user data
     * 
     * @param Receive $receive
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Receive $receive) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.receiveorders.show',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'receive' => $receive,
            'receiveDetails' => ReceiveDetail::join('receive_master as om','om.receive_no','=','receive_detail.receive_no')->join('product_sku as ps','ps.id','=','receive_detail.product_id')->join('product_uom as u','u.product_id','=','receive_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('receive_detail.receive_no',$receive->receive_no)->get(['um.remark as uom','receive_detail.qty','receive_detail.price','receive_detail.total','ps.id','ps.remark as product_name','receive_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }


    public function print(Receive $receive) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);


        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name','suppliers.address','suppliers.email','suppliers.handphone']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = Pdf::loadView('pages.receiveorders.print', [
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'receive' => $receive,
            'receiveDetails' => ReceiveDetail::join('receive_master as om','om.receive_no','=','receive_detail.receive_no')->join('branch as bh','bh.id','=','om.branch_id')->join('product_sku as ps','ps.id','=','receive_detail.product_id')->join('product_uom as u','u.product_id','=','receive_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('receive_detail.receive_no',$receive->receive_no)->get(['um.remark as uom','receive_detail.qty','receive_detail.price','receive_detail.total','ps.id','ps.remark as product_name','receive_detail.discount','bh.remark as branch_name','bh.address']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type,
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('receive.pdf');
        return view('pages.receiveorders.print',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'receive' => $receive,
            'receiveDetails' => ReceiveDetail::join('receive_master as om','om.receive_no','=','receive_detail.receive_no')->join('branch as bh','bh.id','=','om.branch_id')->join('product_sku as ps','ps.id','=','receive_detail.product_id')->join('product_uom as u','u.product_id','=','receive_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('receive_detail.receive_no',$receive->receive_no)->get(['um.remark as uom','receive_detail.qty','receive_detail.price','receive_detail.total','ps.id','ps.remark as product_name','receive_detail.discount','bh.remark as branch_name','bh.address']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }


    /**
     * Edit user data
     * 
     * @param Receive $receive
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Receive $receive) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.receiveorders.edit',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'receive' => $receive,
            'receiveDetails' => ReceiveDetail::join('receive_master as om','om.receive_no','=','receive_detail.receive_no')->join('product_sku as ps','ps.id','=','receive_detail.product_id')->join('product_uom as u','u.product_id','=','receive_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('receive_detail.receive_no',$receive->receive_no)->get(['um.remark as uom','receive_detail.qty','receive_detail.price','receive_detail.total','ps.id','ps.remark as product_name','receive_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }

     /**
     * Edit user data
     * 
     * @param Receive $receive
     * 
     * @return \Illuminate\Http\Response
     */
    public function getdocdata(String $receive_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select od.vat,om.total as result_total,om.total_vat,om.receive_no,to_char(od.expired_at,'dd-mm-YYYY') as exp,od.batch_no as bno,od.qty,od.product_id,od.discount,od.price,od.total as subtotal,ps.remark,ps.abbr,um.remark as uom 
        from receive_detail od 
        join receive_master om on om.receive_no = od.receive_no
        join product_sku ps on ps.id=od.product_id
        join product_uom uo on uo.product_id = od.product_id
        join uom um on um.id=uo.uom_id 
        where od.receive_no='".$receive_no."' ");
        
        return $product;
    }

    /**
     * Update user data
     * 
     * @param Receive $receive
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Receive $receive, Request $request) 
    {

        $user = Auth::user();
        $receive_no = $request->get('receive_no');

        ReceiveDetail::where('receive_no', $receive_no)->delete();

        $res_receive = $receive->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::parse($request->get('dated'))->format('Y-m-d') ],
                ['supplier_id' => $request->get('supplier_id') ],
                ['supplier_name' => $request->get('supplier_name') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['total_vat' => $request->get('total_vat')],
                ['total_discount' => $request->get('total_discount')],
                ['ref_no' => $request->get('ref_no')],
                ['branch_id' => $request->get('branch_id')],
                ['branch_name' => $request->get('branch_name')]
            )
        );

        if(!$res_receive){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save receive failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_receive_detail = ReceiveDetail::create(
                array_merge(
                    ['receive_no' => $receive_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['total' => $request->get('product')[$i]["total"]],
                    ['batch_no' => $request->get('product')[$i]["bno"]],
                    ['expired_at' => Carbon::parse($request->get('product')[$i]["exp"])->format('Y-m-d') ],
                    ['product_remark' => $request->get('product')[$i]["abbr"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['discount' => $request->get('product')[$i]["disc"]],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['seq' => $i ],
                )
            );


            if(!$res_receive_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save receive detail failed'],
                );
        
                return $result;
            }
           
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $receive_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Delete user data
     * 
     * @param Receive $receive
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(Receive $receive) 
    {
        ReceiveDetail::where('receive_no', $receive->receive_no)->delete();

        if($receive->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $receive->receive_no],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $receive->receive_no],
                ['message' => 'Delete failed'],
            );   
        }

        //return redirect()->route('receiveorders.index')->withSuccess(__('Receive deleted successfully.'));
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
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
        }


    }
}
