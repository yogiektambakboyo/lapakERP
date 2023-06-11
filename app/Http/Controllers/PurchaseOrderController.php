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
use App\Models\Supplier;
use App\Models\Settings;
use App\Models\SettingsDocumentNumber;
use App\Models\OrderDetail;
use App\Models\Invoice;
use App\Models\InvoiceDetail;
use App\Models\Purchase;
use App\Models\PurchaseDetail;
use App\Models\Customer;
use App\Models\Department;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\PurchasesExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Auth;
use Illuminate\Support\Facades\DB;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Models\Company;

use App\Http\Controllers\Lang;


class PurchaseOrderController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="purchaseorders",$id=1;

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
            from period_stock ps where where ps.periode=to_char(now()-interval '5 day','YYYYMM')::int;");
        }

        SettingsDocumentNumber::where('doc_type','=','Purchase')->whereRaw("to_char(updated_at,'YYYYY')!=to_char(now(),'YYYYY') ")->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => 0 ],
                ['updated_at' => Carbon::now() ]
            )
        );
        
        $data = $this->data;
        $keyword = "";
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        $purchases = Purchase::orderBy('id', 'ASC')
                ->join('users_branch as ub', 'ub.branch_id','purchase_master.branch_id')->where('purchase_master.supplier_name','!=','PUSAT')->where('ub.user_id', $user->id)->where('purchase_master.dated','>=',Carbon::now()->subDay(7))  
              ->get(['purchase_master.id','purchase_master.branch_name','purchase_master.remark','purchase_master.purchase_no','purchase_master.dated','purchase_master.supplier_name as supplier','purchase_master.total','purchase_master.total_discount','purchase_master.total_payment' ]);
        return view('pages.purchaseorders.index',['company' => Company::get()->first()],compact('purchases','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
            return Excel::download(new PurchasesExport($strencode), 'purchases_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $purchases = Purchase::orderBy('id', 'ASC')
                ->join('suppliers as jt','jt.id','=','purchase_master.supplier_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })
                ->where('ub.user_id', $user->id)
                ->where('purchase_master.supplier_name','!=','PUSAT')
                ->where('purchase_master.purchase_no','like','%'.$keyword.'%')
                ->where('b.id','like','%'.$branchx.'%')  
                ->whereBetween('purchase_master.dated',$fil)  
              ->get(['purchase_master.id','b.remark as branch_name','purchase_master.purchase_no','purchase_master.dated','jt.name as supplier','purchase_master.total','purchase_master.total_discount','purchase_master.total_payment' ]);
              return view('pages.purchaseorders.index',['company' => Company::get()->first()] ,compact('branchs','purchases','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new PurchasesExport, 'purchases_'.Carbon::now()->format('YmdHis').'.xlsx');
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
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('suppliers.name','!=','PUSAT')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $usersall = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->whereIn('users.job_id',[1,2])->get(['users.id','users.name']);
        return view('pages.purchaseorders.create',[
            'customers' => Customer::join('users_branch as ub','ub.branch_id', '=', 'customers.branch_id')->join('branch as b','b.id','=','ub.branch_id')->where('ub.user_id',$user->id)->get(['customers.id','customers.name','b.remark']),
            'data' => $data,
            'suppliers' => $suppliers,
            'usersall' => $usersall,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
            'rooms' => Room::join('users_branch as ub','ub.branch_id', '=', 'branch_room.branch_id')->where('ub.user_id','=',$user->id)->get(['branch_room.id','branch_room.remark']),
        ]);
    }

    public function getproduct() 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select("select distinct m.remark as uom,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,product_sku.vat as vat_total,'0' as discount,'0' as qty,'0' as total
        from product_sku
        join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
        join product_category pc on pc.id = product_sku.category_id 
        join product_type pt on pt.id = product_sku.type_id 
        join product_brand pb on pb.id = product_sku.brand_id 
        join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
        join product_uom pu on pu.product_id = product_sku.id
        join uom m on m.id = pu.uom_id
        join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id = pp.branch_id and ub.branch_id=pd.branch_id 
        left join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = ub.branch_id
        where product_sku.active = '1' and pt.id ='1' order by product_sku.remark ");
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
     * @param PurchaseOrder $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user
        
        $user = Auth::user();
        //$count_no = DB::select("select max(id) as id from purchase_master om where to_char(om.dated,'YYYY')=to_char(now(),'YYYY') ");
        $count_no = SettingsDocumentNumber::where('doc_type','=','Purchase')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->get(['current_value','abbr']);
        $purchase_no = $count_no[0]->abbr.'-'.substr(('000'.$request->get('branch_id')),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_purchase = Purchase::create(
            array_merge(
                ['purchase_no' => $purchase_no ],
                ['created_by' => $user->id],
                ['dated' => Carbon::createFromFormat('d-m-Y', $request->get('dated'))->format('Y-m-d') ],
                ['supplier_id' => $request->get('supplier_id') ],
                ['supplier_name' => $request->get('supplier_name') ],
                ['total' => $request->get('total_order') ],
                ['total_vat' => $request->get('total_vat') ],
                ['remark' => $request->get('remark') ],
                ['total_discount' => $request->get('total_discount') ],
                ['branch_id' => $request->get('branch_id')],
                ['branch_name' => $request->get('branch_name')],
            )
        );

        if(!$res_purchase){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save purchase failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_purchase_detail = PurchaseDetail::create(
                array_merge(
                    ['purchase_no' => $purchase_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['subtotal' => $request->get('product')[$i]["total"]],
                    ['subtotal_vat' => floatval($request->get('product')[$i]["total"])*(1+(floatval($request->get('product')[$i]["vat_total"])/100))],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['discount' => $request->get('product')[$i]["disc"]],
                    ['vat_total' => (floatval($request->get('product')[$i]["vat_total"])*floatval($request->get('product')[$i]["total"]))/100],
                    ['product_remark' => $request->get('product')[$i]["abbr"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['seq' => $i ],
                 )
            );


            if(!$res_purchase_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save purchase detail failed'],
                );
        
                return $result;
            }
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $purchase_no],
            ['message' => 'Save Successfully'],
        );

        SettingsDocumentNumber::where('doc_type','=','Purchase')->where('branch_id','=',$request->get('branch_id'))->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        return $result;
    }

    /**
     * Show user data
     * 
     * @param Purchase $purchase
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(Purchase $purchase) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        return view('pages.purchaseorders.show',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'purchase' => $purchase,
            'purchaseDetails' => PurchaseDetail::join('purchase_master as om','om.purchase_no','=','purchase_detail.purchase_no')->join('product_sku as ps','ps.id','=','purchase_detail.product_id')->join('product_uom as u','u.product_id','=','purchase_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('purchase_detail.purchase_no',$purchase->purchase_no)->get(['um.remark as uom','purchase_detail.qty','purchase_detail.price','purchase_detail.subtotal_vat','purchase_detail.subtotal','ps.id','ps.remark as product_name','purchase_detail.discount']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }

    public function print(Purchase $purchase) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);


        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name','suppliers.address','suppliers.email','suppliers.handphone']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.purchaseorders.print', [
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'purchase' => $purchase,
            'purchaseDetails' => PurchaseDetail::join('purchase_master as om','om.purchase_no','=','purchase_detail.purchase_no')->join('branch as bh','bh.id','=','om.branch_id')->join('product_sku as ps','ps.id','=','purchase_detail.product_id')->join('product_uom as u','u.product_id','=','purchase_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('purchase_detail.purchase_no',$purchase->purchase_no)->get(['um.remark as uom','purchase_detail.qty','purchase_detail.price','purchase_detail.subtotal as total','ps.id','ps.remark as product_name','purchase_detail.discount','bh.remark as branch_name','bh.address']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type,
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('invoice.pdf');
        return view('pages.purchaseorders.print',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'settings' => Settings::get(),
            'purchase' => $purchase,
            'purchaseDetails' => PurchaseDetail::join('purchase_master as om','om.purchase_no','=','purchase_detail.purchase_no')->join('branch as bh','bh.id','=','om.branch_id')->join('product_sku as ps','ps.id','=','purchase_detail.product_id')->join('product_uom as u','u.product_id','=','purchase_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('purchase_detail.purchase_no',$purchase->purchase_no)->get(['um.remark as uom','purchase_detail.qty','purchase_detail.price','purchase_detail.subtotal as total','ps.id','ps.remark as product_name','purchase_detail.discount','bh.remark as branch_name','bh.address']),
            'usersReferrals' => User::get(['users.id','users.name']),
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }

    /**
     * Edit user data
     * 
     * @param Purchase $purchase
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Purchase $purchase) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $suppliers = Supplier::join('users_branch as ub','ub.branch_id', '=', 'suppliers.branch_id')->where('suppliers.name','!=','PUSAT')->where('ub.user_id','=',$user->id)->get(['suppliers.id','suppliers.name']);
        $payment_type = ['Cash','BCA - Debit','BCA - Kredit','Mandiri - Debit','Mandiri - Kredit','Transfer','QRIS'];
        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.purchaseorders.edit',[
            'data' => $data,
            'suppliers' => $suppliers,
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'users' => $users,
            'purchase' => $purchase,
            'purchaseDetails' => PurchaseDetail::join('purchase_master as om','om.purchase_no','=','purchase_detail.purchase_no')->join('product_sku as ps','ps.id','=','purchase_detail.product_id')->join('product_uom as u','u.product_id','=','purchase_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('purchase_detail.purchase_no',$purchase->purchase_no)->get(['um.remark as uom','purchase_detail.qty','purchase_detail.price','purchase_detail.subtotal as total','ps.id','ps.remark as product_name','purchase_detail.discount']),
            'usersReferrals' => $usersReferral,
            'payment_type' => $payment_type, 'company' => Company::get()->first(),
        ]);
    }

     /**
     * Edit user data
     * 
     * @param Purchase $purchase
     * 
     * @return \Illuminate\Http\Response
     */
    public function getdocdata(String $purchase_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select od.vat,od.qty,od.product_id,od.discount,od.price,od.subtotal_vat,od.subtotal,ps.remark,ps.abbr,um.remark as uom,om.dated,om.supplier_id,om.branch_id,om.remark as d_remark
        from purchase_detail od 
        join purchase_master om on om.purchase_no = od.purchase_no
        join product_sku ps on ps.id=od.product_id
        join product_uom uo on uo.product_id = od.product_id
        join uom um on um.id=uo.uom_id 
        where od.purchase_no='".$purchase_no."' ");
        
        return $product;
        return Datatables::of($product)
        ->addColumn('action', function ($product) {
            return  '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'.
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'.
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>';
        })->make();
    }

    /**
     * Update user data
     * 
     * @param Purchase $purchase
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Purchase $purchase, Request $request) 
    {

        $user = Auth::user();
        $purchase_no = $request->get('purchase_no');

        PurchaseDetail::where('purchase_no', $purchase_no)->delete();

        $res_purchase = $purchase->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['dated' => Carbon::createFromFormat('d-m-Y', $request->get('dated'))->format('Y-m-d') ],
                ['supplier_id' => $request->get('supplier_id') ],
                ['supplier_name' => $request->get('supplier_name') ],
                ['total' => $request->get('total_order') ],
                ['total_vat' => $request->get('total_vat') ],
                ['remark' => $request->get('remark') ],
                ['branch_id' => $request->get('branch_id')],
                ['total_discount' => $request->get('total_discount') ],
                ['branch_name' => $request->get('branch_name')],
            )
        );

        if(!$res_purchase){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save purchase failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_purchase_detail = PurchaseDetail::create(
                array_merge(
                    ['purchase_no' => $purchase_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty"]],
                    ['price' => $request->get('product')[$i]["price"]],
                    ['subtotal' => $request->get('product')[$i]["total"]],
                    ['subtotal_vat' => floatval($request->get('product')[$i]["total"])*(1+(floatval($request->get('product')[$i]["vat_total"])/100))],
                    ['vat' => $request->get('product')[$i]["vat_total"]],
                    ['discount' => $request->get('product')[$i]["disc"]],
                    ['vat_total' => (floatval($request->get('product')[$i]["vat_total"])*floatval($request->get('product')[$i]["total"]))/100],
                    ['product_remark' => $request->get('product')[$i]["abbr"]],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['seq' => $i ],
                )
            );


            if(!$res_purchase_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save purchase detail failed'],
                );
        
                return $result;
            }
           
        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $purchase_no],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Delete user data
     * 
     * @param Purchase $purchase
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(Purchase $purchase) 
    {
        PurchaseDetail::where('purchase_no', $purchase->purchase_no)->delete();

        if($purchase->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $purchase->purchase_no],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $purchase->purchase_no],
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
