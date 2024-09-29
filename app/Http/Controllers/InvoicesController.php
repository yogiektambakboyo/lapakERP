<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\Room;
use App\Models\Product;
use App\Models\JobTitle;
use App\Models\Settings;
use App\Models\Supplier;
use App\Models\Order;
use App\Models\Currency;
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
use App\Exports\InvoicesExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use charlieuki\ReceiptPrinter\ReceiptPrinter as ReceiptPrinter;
use App\Http\Controllers\Lang;


class InvoicesController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="invoices",$id=1;

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
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);        

        $has_period_stock = DB::select("
            select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
        ");

        if(count($has_period_stock)<=0){
            DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
            select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
            from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int-1;");
        }

        SettingsDocumentNumber::where('doc_type','=','Invoice')->whereRaw("to_char(updated_at,'YYYYY')!=to_char(now(),'YYYYY') ")->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );

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
                })->where('ub.user_id', $user->id)->where('invoice_master.dated','>=',Carbon::now()->subDay(7))->where('invoice_master.invoice_no','ilike','INV-%')
              ->paginate(10,['invoice_master.is_checkout','invoice_master.id','b.remark as branch_name','invoice_master.invoice_no','invoice_master.dated','jt.name as customer','invoice_master.total','invoice_master.total_discount','invoice_master.total_payment' ]);
        return view('pages.invoices.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            return Excel::download(new InvoicesExport($strencode), 'invoices_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $invoices = Invoice::orderBy('id', 'ASC')
                ->join('customers as jt','jt.id','=','invoice_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $user->id)  
                ->where('invoice_master.invoice_no','ilike','%'.$keyword.'%') 
                ->where('b.id','like','%'.$branchx.'%') 
                ->where('invoice_master.invoice_no','ilike','INV-%')
                ->whereBetween('invoice_master.dated',$fil) 
              ->paginate(10,['invoice_master.is_checkout','invoice_master.id','b.remark as branch_name','invoice_master.invoice_no','invoice_master.dated','jt.name as customer','invoice_master.total','invoice_master.total_discount','invoice_master.total_payment' ]);
        return view('pages.invoices.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        //return Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']);
        
        return view('pages.invoices.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->orderBy('customers.name')->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
            'currency' => Currency::all(),
            'type_customers' => $type_customer,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']),
        ]);
    }

    /**
     * Show form for creating user
     * 
     * @return \Illuminate\Http\Response
     */
    public function createpos() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        //return Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']);
        
        return view('pages.invoices.createpos',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->orderBy('customers.name')->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
            'currency' => Currency::all(),
            'type_customers' => $type_customer,
            'orders' => Order::where('is_checkout','0')->get(),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']),
        ]);
    }

    public function getproduct() 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select product_sku.photo,m.remark as uom,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd on pd.product_id = product_sku.id  and pd.active = '1'
        join product_stock pts on pts.product_id = pd.product_id and pts.branch_id = pd.branch_id and pts.qty>0
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        join product_uom pu on pu.product_id = product_sku.id
        join uom m on m.id = pu.uom_id
        join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id = pp.branch_id and ub.branch_id=pd.branch_id 
        join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = ub.branch_id
        where product_sku.active = '1' order by product_sku.remark");
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
        $count_no = SettingsDocumentNumber::where('doc_type','=','Invoice')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->get(['current_value','abbr']);
        $invoice_no = $count_no[0]->abbr.'-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_invoice = Invoice::create(
            array_merge(
                ['invoice_no' => $invoice_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['currency' => $request->get('currency') ],
                ['kurs' => $request->get('kurs') ],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => (int)$request->get('payment_nominal')>=(int)$request->get('total_order')?(int)$request->get('total_order'):$request->get('payment_nominal') ],
                ['ref_no' => $request->get('ref_no')],
                ['tax' => $request->get('tax')],
            )
        );

        if(!$res_invoice){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save invoice failed'],
            );
    
            return $result;
        }

        SettingsDocumentNumber::where('doc_type','=','Invoice')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        DB::delete("delete from invoice_payment where invoice_no = ?", [$invoice_no]);
        DB::insert("INSERT INTO public.invoice_payment(invoice_no, dated, payment_type, nominal, created_by, created_at) VALUES('".$invoice_no."', now()::date, '".$request->get('payment_type')."', ".$request->get('payment_nominal').", ".$user->id.", now());", []);

        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_stock = DB::select("select doc_no,qty_available from lot_number l where l.branch_id = '".$branch->branch_id."' and l.product_id = '".$request->get('product')[$i]["id"]."' and l.qty_available > 0 order by l.qty_available desc; ");

            $qty_order = $request->get('product')[$i]["qty"];
            $qty_served = 0;
            $lot_no = "";
            
            for ($j=0; $j < count($res_stock); $j++) { 
                $element = $res_stock[$j];
                $product_id = $request->get('product')[$i]["id"];
                $branch_id = $branch->branch_id;
                $lot_no = $element->doc_no;
                $doc_no = $invoice_no;
                $qty_order = $request->get('product')[$i]["qty"];

                if($qty_served == 0 && $element->qty_available >= $qty_order){
                    DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_order,$branch_id]);
                    $qty_served = $request->get('product')[$i]["qty"];
                }else if($qty_served < $qty_order){
                    if($element->qty_available >= ($qty_order - $qty_served)){
                        $qty_d = ($qty_order - $qty_served);
                        DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_d,$branch_id]);
                        $qty_served = $qty_served + $qty_d;
                    }else if($element->qty_available < ($qty_order - $qty_served)){
                        $qty_d = $element->qty_available;
                        DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_d,$branch_id]);
                        $qty_served = $qty_served + $element->qty_available;
                    }
                }
            }

            $res_invoice_detail = true;

            if($qty_served>0){
                $res_invoice_detail = InvoiceDetail::create(
                    array_merge(
                        ['invoice_no' => $invoice_no],
                        ['product_id' => $request->get('product')[$i]["id"]],
                        ['qty' => $qty_served],
                        ['price' => $request->get('product')[$i]["price"]],
                        ['total' => $request->get('product')[$i]["total"]],
                        ['discount' => $request->get('product')[$i]["discount"]],
                        ['seq' => $i ],
                        ['vat' => $request->get('product')[$i]["vat_total"]],
                        ['vat_total' => ((((int)$request->get('product')[$i]["qty"]*(int)$request->get('product')[$i]["price"])-(int)$request->get('product')[$i]["discount"])/100)*(int)$request->get('product')[$i]["vat_total"]],
                        ['product_name' => Product::where('id','=',$request->get('product')[$i]["id"])->get('remark')->first()->remark],
                        ['uom' => $request->get('product')[$i]["uom"]]
                    )
                );

                DB::update("update lot_number set updated_at = now(),qty_onhand = qty_onhand - ".$qty_served." where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
                DB::update("update lot_number set updated_at = now(),qty_available = qty_onhand-qty_allocated where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
            }else{
                $product_id = $request->get('product')[$i]["id"];
                $branch_id = $branch->branch_id;
                $doc_no = $invoice_no;
                $qty_order = $request->get('product')[$i]["qty"];

                DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,0,$branch_id]);
            }

        
            if(!$res_invoice_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save invoice detail failed'],
                );
        
                return $result;
            }else{
                DB::update("update public.period_stock set qty_out=qty_out+".$request->get('product')[$i]['qty']." ,updated_at = now(), balance_end = balance_end - ".$request->get('product')[$i]['qty']." where branch_id = ".$branch['branch_id']." and product_id = ".$request->get('product')[$i]['id']." and periode = to_char(now(),'YYYYMM')::int;");
                $this->update_lotno($lot_no, $request->get('product')[$i]["id"],$branch['branch_id']); 
            }

            //DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$branch['branch_id']." and product_id = ".$request->get('product')[$i]["id"]);
            
        }


        Order::where('order_no',$request->get('ref_no'))->update(
            array_merge(
                ['is_checkout' => '1'],
            )
        );


        $result = array_merge(
            ['status' => 'success'],
            ['data' => Invoice::where('invoice_no','=',$invoice_no)->get('id')->first()->id ],
            ['message' => $invoice_no],
        );

      

        return $result;
    }

    public function update_lotno(String $doc_no,String $product_id,String $branch_id) 
    {
        DB::update('update lot_number set updated_at= now(),qty_onhand = (select sum(coalesce(rd.qty,0))  from receive_master rm 
                            join receive_detail rd on rd.receive_no = rm.receive_no where rd.lot_no = ? ) where doc_no = ? ', [ $doc_no, $doc_no ]);

        DB::update('update lot_number set updated_at= now(),qty_onhand = qty_onhand-(select sum(coalesce(sa.qty_served,0))  from stock_allocation sa 
                            join invoice_master im on im.invoice_no = sa.doc_no 
                            join invoice_detail id on id.invoice_no = im.invoice_no and id.product_id = sa.product_id 
                            where sa.lot_no = ? ) where doc_no = ? ', [ $doc_no, $doc_no ]);
        DB::update('update lot_number set qty_available = (qty_onhand - qty_allocated) where doc_no = ? ', [ $doc_no ]);

        DB::update("update product_stock set updated_at=now(),qty = (select coalesce(sum(coalesce(qty_available,0)),0) from lot_number where product_id = ".$product_id." and branch_id = ".$branch_id." ) 
                    where product_id = ".$product_id." and branch_id = ".$branch_id.";", []);

        DB::update("update period_stock set balance_end = (select coalesce(sum(coalesce(qty_available,0)),0) from lot_number where product_id = ".$product_id." and branch_id = ".$branch_id." ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$product_id." and branch_id = ".$branch_id.";", []);

        DB::update("update period_stock set qty_out = (select coalesce(sum(coalesce(sa.qty_served,0)),0)  from stock_allocation sa 
                            join invoice_master im on im.invoice_no = sa.doc_no 
                            join customers c on c.id = im.customers_id
                            join invoice_detail id on id.invoice_no = im.invoice_no and id.product_id = sa.product_id  where id.product_id = ".$product_id." and c.branch_id = ".$branch_id." and to_char(im.dated,'YYYYMM')::int=to_char(now()::date,'YYYYMM')::int ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$product_id." and branch_id = ".$branch_id.";", []);

        DB::update("update period_stock set qty_in = (select coalesce(sum(coalesce(rd.qty,0)),0)  from receive_master rm 
        join receive_detail rd on rd.receive_no = rm.receive_no where rd.product_id = ".$product_id." and rm.branch_id = ".$branch_id." and to_char(rm.dated,'YYYYMM')::int=to_char(now()::date,'YYYYMM')::int ) where periode = to_char(now()::date,'YYYYMM')::int and product_id = ".$product_id." and branch_id = ".$branch_id.";", []);
        
        $result = array_merge(
            ['status' => 'success'],
            ['data' =>  $doc_no],
            ['message' => ''],
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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $user = Auth::user();
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];
        $room = Room::where('branch_room.id','=',$invoice->branch_room_id)->get(['branch_room.remark'])->first();
         //credit_card,gopay,qris,shopeepay,bank_transfer
         $payment_type = ['Cash','Kartu', 'GoPay','ShoopePay','Bank Transfer','QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.invoices.show',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'currency' => Currency::all(),
            'type_customers' => $type_customer,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']),
            'orderDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw(' ps.type_id DESC, invoice_detail.seq  ASC')->get(['usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
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
        
        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.invoices.print', [
            'data' => $data,
            'settings' => Company::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('customers as us','us.id','=','om.customers_id')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'potrait');
        //return $pdf->stream('invoice.pdf');
        return view('pages.invoices.print',[
            'data' => $data,
            'settings' => Company::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('customers as us','us.id','=','om.customers_id')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ]);
        
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

        return view('pages.invoices.printsj', [
            'data' => $data,
            'settings' => Company::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('customers as us','us.id','=','om.customers_id')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ]);
        
        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.invoices.printsj', [
            'data' => $data,
            'settings' => Settings::get(),
            'invoice' => Invoice::join('users as u','u.id','=','invoice_master.created_by')->where('invoice_master.id',$invoice->id)->get(['invoice_master.*','u.name'])->first(),
            'customers' => Customer::where('id',$invoice->customers_id)->get(['customers.*']),
            'invoiceDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('customers as us','us.id','=','om.customers_id')->join('branch as bc','bc.id','=','us.branch_id')->leftjoin('users as usm','usm.id','=','invoice_detail.referral_by')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderByRaw('ps.type_id ASC,invoice_detail.seq  ASC')->get(['bc.remark as branch_name','bc.address as branch_address','usm.name as referral_by','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount','om.tax','om.voucher_code']),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');
    }

    public function printspk(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        //return InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->where('invoice_detail.invoice_no',$invoice->invoice_no)->get(['om.tax','om.voucher_code','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','invoice_detail.product_name','invoice_detail.discount','ps.type_id','om.scheduled_at','um.conversion']);

        $data = $this->data;
         //credit_card,gopay,qris,shopeepay,bank_transfer
         $payment_type = ['Cash','Kartu', 'GoPay','ShoopePay','Bank Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.invoices.printspk', [
            'data' => $data,
            'customers' => Customer::join('order_master as om','om.customers_id','customers.id')->join('branch_room as br','br.id','om.branch_room_id')->join('branch as b','b.id','=','customers.branch_id')->get(['br.remark as room_name','b.remark as branch_name','customers.id','customers.name']),
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
         //credit_card,gopay,qris,shopeepay,bank_transfer
         $payment_type = ['Cash','Kartu', 'GoPay','ShoopePay','Bank Transfer','QRIS'];
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
         //credit_card,gopay,qris,shopeepay,bank_transfer
         $payment_type = ['Cash','Kartu', 'GoPay','ShoopePay','Bank Transfer','QRIS'];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.invoices.show',[
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
    public function edit(Invoice $invoice) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;


        $room = Room::where('branch_room.id','=',$invoice->branch_room_id)->get(['branch_room.remark'])->first();
         //credit_card,gopay,qris,shopeepay,bank_transfer
         $payment_type = ['Cash','Kartu', 'GoPay','ShoopePay','Bank Transfer','QRIS'];
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        $type_customer = ['Sendiri','Berdua','Keluarga','Rombongan'];

        return view('pages.invoices.edit',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'invoice' => $invoice,
            'room' => $room,
            'usersall' => $usersall,
            'type_customers' => $type_customer,
            'currency' => Currency::all(),
            'orders' => Order::where('is_checkout','0')->get(),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
            'users' => $users,
            'orderDetails' => InvoiceDetail::join('invoice_master as om','om.invoice_no','=','invoice_detail.invoice_no')->join('product_sku as ps','ps.id','=','invoice_detail.product_id')->join('product_uom as u','u.product_id','=','invoice_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->leftjoin('users as us','us.id','=','invoice_detail.assigned_to')->where('invoice_detail.invoice_no',$invoice->invoice_no)->orderBy('invoice_detail.seq')->get(['invoice_detail.seq','us.name as assigned_to','um.remark as uom','invoice_detail.qty','invoice_detail.price','invoice_detail.total','ps.id','ps.remark as product_name','invoice_detail.discount']),
            'usersReferrals' => $usersReferral,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark','branch.currency']),
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
    public function getinvoice(String $invoice_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select pt.remark as type,od.qty,od.product_id,od.discount,od.price,od.total,ps.remark,ps.abbr,um.remark as uom,od.assigned_to_name as assignedto,od.assigned_to as assignedtoid,od.vat,od.vat_total,od.referral_by,od.referral_by_name
        from invoice_detail od 
        join invoice_master om on om.invoice_no = od.invoice_no
        join product_sku ps on ps.id=od.product_id
        join product_type pt on pt.id=ps.type_id
        join product_uom uo on uo.product_id = od.product_id
        join uom um on um.id=uo.uom_id 
        where od.invoice_no='".$invoice_no."' order by od.seq");
        
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
    public function update(Invoice $invoice, Request $request) 
    {

        $user = Auth::user();
        $invoice_no = $request->get('invoice_no');

        $last_data = InvoiceDetail::where('invoice_detail.invoice_no','=',$invoice_no)->get('invoice_detail.*');
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();

        for ($i=0; $i < count($last_data); $i++) { 
            DB::update("UPDATE product_stock set qty = qty+".$last_data[$i]['qty']." WHERE branch_id = ".$branch['branch_id']." and product_id = ".$last_data[$i]["product_id"].";");
        }

        InvoiceDetail::where('invoice_no', $invoice_no)->delete();
    
        $res_invoice = $invoice->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::parse($request->get('order_date'))->format('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['currency' => $request->get('currency') ],
                ['kurs' => $request->get('kurs') ],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name  ],
                ['total_payment' => (int)$request->get('payment_nominal')>=(int)$request->get('total_order')?(int)$request->get('total_order'):$request->get('payment_nominal') ],
                ['ref_no' => $request->get('ref_no')],
                ['tax' => $request->get('tax')],
                ['customer_type' => $request->get('customer_type')],
            )
        );

        if(!$res_invoice){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save invoice failed'],
            );
    
            return $result;
        }

        for ($i=0; $i < count($request->get('product')); $i++) { 
            DB::update("update lot_number set qty_available = qty_available+(select sum(qty_served) from stock_allocation where doc_no = '".$invoice_no."' and product_id = ".$request->get('product')[$i]['id'].") where doc_no = (select lot_no from stock_allocation where doc_no = '".$invoice_no."' and product_id = ".$request->get('product')[$i]['id'].");", []);
            DB::delete("delete from stock_allocation where doc_no = '".$invoice_no."' and product_id = ".$request->get('product')[$i]['id'].";");

            $res_stock = DB::select("select doc_no,qty_available from lot_number l where l.branch_id = '".$branch->branch_id."' and l.product_id = '".$request->get('product')[$i]["id"]."' and l.qty_available > 0 order by l.qty_available desc; ");

            $qty_order = $request->get('product')[$i]["qty"];
            $qty_served = 0;
            $lot_no = "";

            for ($j=0; $j < count($res_stock); $j++) { 
                $element = $res_stock[$j];
                $product_id = $request->get('product')[$i]["id"];
                $branch_id = $branch->branch_id;
                $lot_no = $element->doc_no;
                $doc_no = $invoice_no;
                $qty_order = $request->get('product')[$i]["qty"];

                if($qty_served == 0 && $element->qty_available >= $qty_order){
                    DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_order,$branch_id]);
                    $qty_served = $request->get('product')[$i]["qty"];
                }else if($qty_served < $qty_order){
                    if($element->qty_available >= ($qty_order - $qty_served)){
                        $qty_d = ($qty_order - $qty_served);
                        DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_d,$branch_id]);
                        $qty_served = $qty_served + $qty_d;
                    }else if($element->qty_available < ($qty_order - $qty_served)){
                        $qty_d = $element->qty_available;
                        DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,$qty_d,$branch_id]);
                        $qty_served = $qty_served + $element->qty_available;
                    }
                }
            }

            if($qty_served>0){
                $res_invoice_detail = InvoiceDetail::create(
                    array_merge(
                        ['invoice_no' => $invoice_no],
                        ['product_id' => $request->get('product')[$i]["id"]],
                        ['qty' => $qty_served],
                        ['price' => $request->get('product')[$i]["price"]],
                        ['total' => $request->get('product')[$i]["total"]],
                        ['discount' => $request->get('product')[$i]["discount"]],
                        ['seq' => $i ],
                        ['vat' => $request->get('product')[$i]["vat_total"]],
                        ['vat_total' => ((((int)$request->get('product')[$i]["qty"]*(int)$request->get('product')[$i]["price"])-(int)$request->get('product')[$i]["discount"])/100)*(int)$request->get('product')[$i]["vat_total"]],
                        ['product_name' => $request->get('product')[$i]["abbr"]],
                        ['uom' => $request->get('product')[$i]["uom"]]
                    )
                );

                

                DB::update("update lot_number set updated_at = now(),qty_onhand = qty_onhand - ".$qty_served." where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
                DB::update("update lot_number set updated_at = now(),qty_available = qty_onhand-qty_allocated where doc_no='".$lot_no."' and product_id='".$request->get('product')[$i]["id"]."';");
            }else{
                DB::insert("INSERT INTO public.stock_allocation(product_id, lot_no, doc_no, qty_order, qty_served, branch_id) values (?, ?, ?, ?, ?, ?)", [$product_id,$lot_no,$doc_no,$qty_order,0,$branch_id]);
            }


            DB::update("UPDATE product_stock set qty = qty-".$request->get('product')[$i]['qty']." WHERE branch_id = ".$branch['branch_id']." and product_id = ".$request->get('product')[$i]["id"]);
            $this->update_lotno($lot_no, $request->get('product')[$i]["id"],$branch['branch_id']); 


            if(!$res_invoice_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save invoice detail failed'],
                );
        
                return $result;
            }           
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

        if($invoice->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $invoice->invoice_no],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $invoice->invoice_no],
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
