<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\PettyCash;
use App\Models\PettyCashDetail;
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
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\InvoiceDetail;
use App\Models\Customer;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\PettyProductExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use charlieuki\ReceiptPrinter\ReceiptPrinter as ReceiptPrinter;
use App\Http\Controllers\Lang;


class PettyProductController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="invoices",$id=1;

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

        $has_period_stock = DB::select("
            select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
        ");

        if(count($has_period_stock)<=0){
            DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
            select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
            from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int-1;");
        }

        SettingsDocumentNumber::where('doc_type','=','Petty')->whereRaw("to_char(updated_at,'YYYYY')!=to_char(now(),'YYYYY') ")->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );

        $data = $this->data;
        $keyword = "";
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        
        $invoices = PettyCash::orderBy('id', 'ASC')
                ->join('branch as b','b.id','=','petty_cash.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'petty_cash.branch_id');
                })->where('ub.user_id', $user->id)->where('petty_cash.type','!=','Kas - Keluar')->where('petty_cash.dated','>=',Carbon::now()->subDay(7))
              ->get(['petty_cash.id','b.remark as branch_name','petty_cash.doc_no','petty_cash.dated','petty_cash.total','petty_cash.remark','petty_cash.type' ]);
        return view('pages.pettyproduct.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            return Excel::download(new PettyProductExport($strencode), 'pettycash_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $invoices = PettyCash::orderBy('id', 'ASC')
                ->join('branch as b','b.id','=','petty_cash.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'petty_cash.branch_id');
                })->where('ub.user_id', $user->id)  
                ->where('petty_cash.doc_no','ilike','%'.$keyword.'%') 
                ->where('b.id','like','%'.$branchx.'%') 
                ->where('petty_cash.type','!=','Kas - Keluar')
                ->whereBetween('petty_cash.dated',$fil) 
                ->get(['petty_cash.id','b.remark as branch_name','petty_cash.doc_no','petty_cash.dated','petty_cash.total','petty_cash.remark','petty_cash.type' ]);

        return view('pages.pettyproduct.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new PettyProductExport, 'pettycash_'.Carbon::now()->format('YmdHis').'.xlsx');
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
        $doc_type = ['Produk - Keluar','Produk - Masuk'];
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->orderBy('users.name','ASC')->get(['users.id','users.name']);
        return view('pages.pettyproduct.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->orderBy('customers.name')->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
            'doc_type' => $doc_type,
            'type_customers' => $type_customer,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    /**
     * Show form for creating user
     * 
     * @return \Illuminate\Http\Response
     */
    public function createout() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $doc_type = ['Produk - Keluar','Produk - Masuk'];
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->orderBy('users.name','ASC')->get(['users.id','users.name']);
        return view('pages.pettyproduct.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->orderBy('customers.name')->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
            'doc_type' => $doc_type,
            'type_customers' => $type_customer,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
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
        where product_sku.active = '1' order by product_sku.remark");
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
        $count_no = SettingsDocumentNumber::where('doc_type','=','Petty')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->get(['current_value','abbr']);
        $doc_no = $count_no[0]->abbr.'-'.substr(('000'.$request->get('branch_id')),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_master = PettyCash::create(
            array_merge(
                ['doc_no' => $doc_no ],
                ['created_by' => $user->id],
                ['dated' =>  Carbon::createFromFormat('d-m-Y', $request->get('doc_date'))->format('Y-m-d') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['branch_id' => $request->get('branch_id')],
                ['type' => $request->get('type')],
            )
        );


        if(!$res_master){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save petty failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_detail = PettyCashDetail::create(
                array_merge(
                    ['doc_no' => $doc_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['line_total' => $request->get('product')[$i]["total"]],
                    ['seq' => $i ],
                    ['product_name' => Product::where('id','=',$request->get('product')[$i]["id"])->get('remark')->first()->remark],
                    ['uom' => $request->get('product')[$i]["uom"]]
                )
            );


            if(!$res_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save detail failed'],
                );
        
                return $result;
            }

            if($request->get('type')=="Produk - Keluar"){
                DB::update(" INSERT INTO public.stock_log (product_id, qty, branch_id, doc_no,remarks, created_at) VALUES(".$request->get('product')[$i]["id"].", ".$request->get('product')[$i]['qty']." , ".$request->get('branch_id').", '".$doc_no."','Produk Keluar Created', now()) ");
                DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]["id"]);
                DB::update("update public.period_stock set qty_out=qty_out+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end - ".$request->get('product')[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
            }else{
                DB::update(" INSERT INTO public.stock_log (product_id, qty, branch_id, doc_no,remarks, created_at) VALUES(".$request->get('product')[$i]["id"].", ".$request->get('product')[$i]['qty']." , ".$request->get('branch_id').", '".$doc_no."','Produk Masuk Created', now()) ");
                DB::update("UPDATE product_stock set qty = qty+".$request->get('product')[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]["id"]);
                DB::update("update public.period_stock set qty_in=qty_in+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end + ".$request->get('product')[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
            }
        }



        $result = array_merge(
            ['status' => 'success'],
            ['data' => PettyCash::where('doc_no','=',$doc_no)->get('id')->first()->id ],
            ['message' => $doc_no],
        );

        SettingsDocumentNumber::where('doc_type','=','Petty')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
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
    public function show(PettyCash $petty) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;

        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $doc_type = ['Produk - Keluar','Produk - Masuk'];
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        return view('pages.pettyproduct.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $petty,
            'usersall' => $usersall,
            'type_customers' => $type_customer,
            'doc_type' => $doc_type,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),

            'orderDetails' => PettyCashDetail::join('petty_cash as om','om.doc_no','=','petty_cash_detail.doc_no')->join('product_sku as ps','ps.id','=','petty_cash_detail.product_id')->join('product_uom as u','u.product_id','=','petty_cash_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('petty_cash_detail.doc_no',$petty->doc_no)->get(['um.remark as uom','petty_cash_detail.qty','petty_cash_detail.price','petty_cash_detail.line_total as total','ps.id','ps.remark as product_name']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }


    public function print(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $invoice->update(
            array_merge(
                ["printed_at" => Carbon::now()],
                ["printed_count" => $invoice->printed_count+1]
            )
        );
        
        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.pettyproduct.print', [
            'data' => $data,
            'settings' => Settings::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');
    }

    public function printsj(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $invoice->update(
            array_merge(
                ["printed_at" => Carbon::now()],
                ["printed_count" => $invoice->printed_count+1]
            )
        );
        
        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.pettyproduct.printsj', [
            'data' => $data,
            'settings' => Settings::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');
    }

    public function printspk(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

       
        $data = $this->data;
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.pettyproduct.printspk', [
            'data' => $data,
            'customers' => Customer::join('invoice_master as om','om.customers_id','customers.id')->join('branch_room as br','br.id','om.branch_room_id')->join('branch as b','b.id','=','customers.branch_id')->get(['br.remark as room_name','b.remark as branch_name','customers.id','customers.name']),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'invoice' => $invoice,
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderBy('invoice_detail.seq')->get(['om.customers_name','om.tax','om.voucher_code','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','invoice_detail.product_name','invoice_detail.discount','ps.type_id','om.scheduled_at','um.conversion']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type,
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a5', 'potrait');
        return $pdf->stream('spk.pdf');
    }

    public function printthermal(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $invoice->update(
            array_merge(
                ["printed_at" => Carbon::now()],
                ["printed_count" => $invoice->printed_count+1]
            )
        );

        $data = $this->data;
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        // Set data
        $settings = Settings::get()->first();
        $branch = Branch::join('customers','customers.branch_id','=','branch.id')
                    ->join('invoice_master','invoice_master.customers_id','=','customers.id')->where('invoice_master.invoice_no','=',$invoice->invoice_no)->get('branch.*')->first();
        $invoicedetail = InvoiceDetail::join('uom','uom.remark','=','invoice_detail.uom')->join('product_sku','product_sku.id','=','invoice_detail.product_id')->where('invoice_no','=',$invoice->invoice_no)->get(['uom.conversion','product_name','qty','price','invoice_detail.vat','type_id']);
        $terapists = InvoiceDetail::where('invoice_no','=',$invoice->invoice_no)->distinct()->get(['assigned_to_name']);

        // Init printer
        $printer = new ReceiptPrinter;
        $printer->init(
            config('receiptprinter.connector_type'),
            config('receiptprinter.connector_descriptor')
        );
        
        $currency = 'Rp';
        $image_path = 'logo.png';
        $tax_percentage = $invoicedetail[0]->vat;

        // Header
        $store_name = $branch->remark;
        $store_address = $branch->address;

        // Set store info
        //$printer->setStore($mid, $store_name, $store_address, $store_phone, $store_email, $store_website);
        $printer->setStore('', $store_name, $store_address, '', '', '');

        // Set currency
        $printer->setCurrency($currency);

        // Recipet Information
        $printer->setDated(substr(explode(" ",$invoice->dated)[0],5,2)."-".substr(explode(" ",$invoice->dated)[0],8,2)."-".substr(explode(" ",$invoice->dated)[0],0,4));
        $customer_name = $invoice->customers_name;
        $room_name = Room::where('id','=',$invoice->branch_room_id)->get()->first()->remark;
        $transaction_id = $invoice->invoice_no;

        $printer->setCustomerName($customer_name);
        $printer->setRoomName($room_name);
        $printer->setOperator(User::where('id','=',$invoice->created_by)->get('name')->first()->name);
        
        // Set transaction ID
        $printer->setTransactionID($transaction_id);

        foreach ($terapists as $terapist) {
            $printer->addTerapist(
                $terapist['assigned_to_name']
            );
        }

        // Total
        $printer->setPaymentType($invoice->payment_type);
        $printer->setTotalPayment($invoice->total_payment);
        $printer->setTotal($invoice->total);


        // Add items
        $scheduled_at = $invoice->scheduled_at;
        $sum_scheduled_at = $scheduled_at;
        foreach ($invoicedetail as $item) {
            $printer->addItem(
                $item['product_name'],
                $item['qty'],
                $item['price'],
                $item['type_id']
            );
            $printer->addTimeExec(Carbon::parse($sum_scheduled_at)->isoFormat('H:mm').' - '.(Carbon::parse($sum_scheduled_at)->add($item['conversion'].' minutes')->isoFormat('H:mm')));
            $sum_scheduled_at = Carbon::parse($sum_scheduled_at)->add($item['conversion'].' minutes')->isoFormat('H:mm');
        }


        // Print receipt
        $printer->printReceiptInvoice();

        $room = Room::where('branch_room.id','=',$invoice->branch_room_id)->get(['branch_room.remark'])->first();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.pettyproduct.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'orderDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderBy('invoice_detail.seq')->get(['usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }


    /**
     * Edit user data
     * 
     * @param Invoice $invoice
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(PettyCash $petty) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;

        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $doc_type = ['Kas - Keluar','Produk - Keluar','Produk - Masuk'];
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->orderBy('users.name','ASC')->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];

        return view('pages.pettyproduct.edit',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $petty,
            'usersall' => $usersall,
            'type_customers' => $type_customer,
            'doc_type' => $doc_type,
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),

            'orderDetails' => PettyCashDetail::join('petty_cash as om','om.doc_no','=','petty_cash_detail.doc_no')->join('product_sku as ps','ps.id','=','petty_cash_detail.product_id')->join('product_uom as u','u.product_id','=','petty_cash_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('petty_cash_detail.doc_no',$petty->doc_no)->get(['um.remark as uom','petty_cash_detail.qty','petty_cash_detail.price','petty_cash_detail.line_total as total','ps.id','ps.remark as product_name']),
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
    public function getinvoice(String $doc_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" 
            select pt.remark as type,od.qty,od.product_id,0 as discount,od.price,od.line_total as total,ps.remark,ps.abbr,um.remark as uom,'' as assignedto,'' as assignedtoid,0 as vat,0 as vat_total,'' as referral_by,'' as referral_by_name
            from petty_cash_detail od 
            join petty_cash om on om.doc_no = od.doc_no
            join product_sku ps on ps.id=od.product_id
            join product_type pt on pt.id=ps.type_id
            join product_uom uo on uo.product_id = od.product_id
            join uom um on um.id=uo.uom_id 
            where od.doc_no='".$doc_no."'");
            
        return $product;
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return  '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'.
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'.
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'.
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Terapis" id="assign_row" class="btn btn-xs btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>';
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
    public function update(PettyCash $petty, Request $request) 
    {

        $user = Auth::user();
        $doc_no = $request->get('doc_no');

        $last_data = PettyCashDetail::where('petty_cash_detail.doc_no','=',$doc_no)->get('petty_cash_detail.*');

        for ($i=0; $i < count($last_data); $i++) { 
            if($request->get('type')=="Produk - Keluar"){
                DB::update("UPDATE product_stock set qty = qty+".$last_data[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$last_data[$i]["product_id"].";");
                DB::update("update public.period_stock set qty_out=qty_out-".$last_data[$i]['qty']." ,updated_at = now(), balance_end = balance_end + ".$last_data[$i]['product_id']." where branch_id = ".$request->get('branch_id')." and product_id = ".$last_data[$i]['product_id']." and periode = to_char(now(),'YYYYMM')::int;");
            }else{
                 DB::update("UPDATE product_stock set qty = qty-".$last_data[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$last_data[$i]["product_id"].";");
                 DB::update("update public.period_stock set qty_in=qty_in-".$last_data[$i]['qty']." ,updated_at = now(), balance_end = balance_end - ".$last_data[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$last_data[$i]['product_id']." and periode = to_char(now(),'YYYYMM')::int;");
            }
        }

        PettyCashDetail::where('doc_no', $doc_no)->delete();

        $res_petty = $petty->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::createFromFormat('d-m-Y', $request->get('dated'))->format('Y-m-d') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['branch_id' => $request->get('branch_id') ],
                ['type' => $request->get('type') ],
            )
        );

        if(!$res_petty){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save petty failed'],
            );
    
            return $result;
        }

        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_petty_detail = PettyCashDetail::create(
                array_merge(
                    ['doc_no' => $doc_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['line_total' => $request->get('product')[$i]["total"]],
                    ['uom' => $request->get('product')[$i]["uom"]]
                )
            );


            if($request->get('type')=="Produk - Keluar"){
                DB::update(" INSERT INTO public.stock_log (product_id, qty, branch_id, doc_no,remarks, created_at) VALUES(".$request->get('product')[$i]["id"].", ".$request->get('product')[$i]['qty']." , ".$request->get('branch_id').", '".$doc_no."','Edit Produk Keluar', now()) ");
                DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]["id"]);
                DB::update("update public.period_stock set qty_out=qty_out+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end - ".$request->get('product')[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
            }else{
                DB::update(" INSERT INTO public.stock_log (product_id, qty, branch_id, doc_no,remarks, created_at) VALUES(".$request->get('product')[$i]["id"].", ".$request->get('product')[$i]['qty']." , ".$request->get('branch_id').", '".$doc_no."','Edit Produk Masuk', now()) ");
                DB::update("UPDATE product_stock set qty = qty+".$request->get('product')[$i]['qty']." WHERE branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]["id"]);
                DB::update("update public.period_stock set qty_in=qty_in+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end + ".$request->get('product')[$i]['qty']." where branch_id = ".$request->get('branch_id')." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
            }
            
            if(!$res_petty_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save petty detail failed'],
                );
        
                return $result;
            }           
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $doc_no],
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
    public function destroy(PettyCash $petty) 
    {

        PettyCashDetail::where('doc_no', $petty->doc_no)->delete();

        if($petty->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $petty->doc_no],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $petty->doc_no],
                ['message' => 'Delete failed'],
            );   
        }
        return $result;
    }

    public function checkout(Invoice $invoice) 
    {
        $upd = $invoice::where('invoice_no',$invoice->invoice_no)->update(
            array_merge(
                ['is_checkout'   => '1'],
            )
        );
        if($upd){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $invoice->invoice_no],
                ['message' => 'Set Checkout Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $invoice->invoice_no],
                ['message' => 'Update failed'],
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
