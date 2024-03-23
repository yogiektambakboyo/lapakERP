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
use App\Models\Picking;
use App\Models\PickingDetail;
use App\Models\PickingRef;
use App\Models\Packing;
use App\Models\PackingDetail;
use App\Models\Shipment;
use App\Models\ShipmentDetail;
use App\Models\PackingRef;
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


class ShipmentController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="shipment",$id=1;

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

        $data = $this->data;
        $keyword = "";
        $user = Auth::user();
        $act_permission = $this->act_permission[0];
        
        $invoices = DB::select("select pm.remark,pm.id,pm.doc_no,pm.customer_id,b.remark as branch_name,pm.remark,pm.dated,count(pd.product_id)  as count_sku
        from shipment_master pm 
        join shipment_detail pd  on pd.doc_no = pm.doc_no
        join branch b on b.id = pm.customer_id
        join users_branch ub on ub.branch_id = 15 and ub.user_id = ".$id."
        group by pm.id,pm.doc_no,pm.dated,pm.remark,b.remark order by 2");
        return view('pages.shipment.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs')); 
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
                ->join('branch as jt','jt.id','=','invoice_master.customers_id')
                ->join('branch as b','b.id','=','jt.id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.id');
                })->where('ub.user_id', $user->id)  
                ->where('invoice_master.invoice_no','ilike','%'.$keyword.'%') 
                ->where('b.id','like','%'.$branchx.'%')
                ->where('invoice_master.invoice_no','ilike','INVI-%') 
                ->whereBetween('invoice_master.dated',$fil) 
              ->get(['invoice_master.is_checkout','invoice_master.id','b.remark as branch_name','invoice_master.invoice_no','invoice_master.dated','jt.remark as customer','invoice_master.total','invoice_master.total_discount','invoice_master.total_payment' ]);
        return view('pages.shipment.index',['company' => Company::get()->first()], compact('invoices','data','keyword','act_permission','branchs'))->with('i', ($request->input('page', 1) - 1) * 5);
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
        return view('pages.shipment.create',[
            'customers' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('branch.remark','not like','%PUSAT%')->where('branch.id','>',1)->where('ub.user_id',$user->id)->orderBy('branch.remark')->get(['branch.id','branch.remark']),
            'data' => $data,
            'users' => $users,
            'usersall' => $usersall,
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
        $branch = Branch::where('id','=',$request->get('customer_id'))->get(['id'])->first();

        $count_no = SettingsDocumentNumber::where('doc_type','=','Shipment')->where('branch_id','=',15)->where('period','=','Yearly')->get(['current_value','abbr']);
        $doc_no = $count_no[0]->abbr.'-'.substr(('0015'),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        SettingsDocumentNumber::where('doc_type','=','Shipment')->where('branch_id','=',15)->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        $res_ = Shipment::create(
            array_merge(
                ['doc_no' => $doc_no ],
                ['remark' => $request->get('remark') ],
                ['customer_id' => $request->get('customer_id') ],
                ['shipping_method' => $request->get('shipping_method') ],
                ['status' => $request->get('status') ],
                ['shipper_name' => $request->get('shipper_name') ],
                ['awb' => $request->get('awb') ],
                ['address' => $request->get('address') ],
                ['etd' => $request->get('etd') ],
                ['eta' => $request->get('eta') ],
                ['created_by' => $user->id],
                ['dated' => Carbon::createFromFormat('d-m-Y', $request->get('doc_date'))->format('Y-m-d') ],
                ['isshipped' => "0" ],
            )
        );

        
        if(!$res_){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save packing failed'],
            );
    
            return $result;
        }


        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_doc_detail = ShipmentDetail::create(
                array_merge(
                    ['doc_no' => $doc_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty_pack"]],
                    ['seq' => $i ],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['ref_no_po' => $request->get('product')[$i]["po_no"]],
                    ['ref_no' => $request->get('product')[$i]["ref_no"]]
                )
            );


            if(!$res_doc_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save shipment detail failed'],
                );
        
                return $result;
            }

        }

        $result = array_merge(
            ['status' => 'success'],
            ['data' => Shipment::where('doc_no','=',$doc_no)->get('id')->first()->id ],
            ['message' => $doc_no],
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
    public function show(Shipment $shipment) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;

        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        return view('pages.shipment.show',[
            'customers' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('branch.remark','not like','%PUSAT%')->where('branch.id','>',1)->where('ub.user_id',$user->id)->orderBy('branch.remark')->get(['branch.id','branch.remark']),
            'data' => $data,
            'doc_data' => $shipment,
            'data_details' => ShipmentDetail::join('shipment_master as om','om.doc_no','=','shipment_detail.doc_no')->join('product_sku as ps','ps.id','=','shipment_detail.product_id')->join('product_uom as u','u.product_id','=','shipment_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('shipment_detail.doc_no',$shipment->doc_no)->get(['shipment_detail.qty','ps.id','ps.remark as product_name','shipment_detail.ref_no_po as po_no']),
            'company' => Company::get()->first(),
        ]);
    }


    public function print(Shipment $shipment) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $users = User::where('id','=',$shipment->created_by)->get(['users.id','users.name'])->first();
        $doc = Shipment::join('branch','branch.id','=','shipment_master.customer_id')->where('shipment_master.doc_no','=',$shipment->doc_no)->get(['shipment_master.*','branch.remark as branch_name']);
        $pdf = PDF::setOptions(['isHtml5ParserEnabled' => true, 'isRemoteEnabled' => true])->loadView('pages.shipment.print', [
            'customers' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('branch.remark','not like','%PUSAT%')->where('branch.id','>',1)->where('ub.user_id',$user->id)->orderBy('branch.remark')->get(['branch.id','branch.remark']),
            'doc_data' => $doc[0],
            'users' => $users,
            'settings' => Settings::get(),
            'data_details' => ShipmentDetail::join('shipment_master as om','om.doc_no','=','shipment_detail.doc_no')->join('product_sku as ps','ps.id','=','shipment_detail.product_id')->join('product_uom as u','u.product_id','=','shipment_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('shipment_detail.doc_no',$shipment->doc_no)->get(['um.remark as uom','shipment_detail.qty','ps.id','ps.remark as product_name','shipment_detail.ref_no_po as po_no']),
            'company' => Company::get()->first(),
        ])->setOptions(['defaultFont' => 'sans-serif'])->setPaper('a4', 'landscape');
        return $pdf->stream('shipment.pdf');
    }

    


    /**
     * Edit user data
     * 
     * @param Invoice $invoice
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(Shipment $shipment) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;

        $users = User::join('users_branch as ub','ub.branch_id', '=', 'users.branch_id')->where('ub.user_id','=',$user->id)->where('users.job_id','=',2)->get(['users.id','users.name']);

        return view('pages.shipment.edit',[
            'customers' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('branch.remark','not like','%PUSAT%')->where('branch.id','>',1)->where('ub.user_id',$user->id)->orderBy('branch.remark')->get(['branch.id','branch.remark']),
            'data' => $data,
            'doc_data' => $shipment,
            'data_details' => ShipmentDetail::join('shipment_master as om','om.doc_no','=','shipment_detail.doc_no')->join('product_sku as ps','ps.id','=','shipment_detail.product_id')->join('product_uom as u','u.product_id','=','shipment_detail.product_id')->join('uom as um','um.id','=','u.uom_id')->where('shipment_detail.doc_no',$shipment->doc_no)->get(['shipment_detail.qty','ps.id','ps.remark as product_name','shipment_detail.ref_no_po as po_no']),
            'company' => Company::get()->first(),
        ]);
    }

     /**
     * Edit user data
     * 
     * @param Order $order
     * 
     * @return \Illuminate\Http\Response
     */
    public function getdoc_data(String $doc_no) 
    {
        $data = $this->data;
        $user = Auth::user();
        $product = DB::select(" select pd.qty as qty_pack,o.remark as uom,pd.doc_no,pd.product_id,ps.abbr,ps.remark as product_name,dk.qty,pd.ref_no_po as po_no,pd.ref_no from shipment_master pm 
        join shipment_detail pd on pd.doc_no = pm.doc_no
        join purchase_detail dk on dk.purchase_no = pd.ref_no_po and dk.product_id = pd.product_id
        join product_sku ps on ps.id = pd.product_id 
        join product_uom uo on uo.product_id=ps.id
        join uom o on o.id= uo.uom_id
        where pd.doc_no='".$doc_no."'");
        
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
     * @param Invoice $invoice
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(Shipment $shipment, Request $request) 
    {

        $user = Auth::user();
        $doc_no = $request->get('doc_no');
        $branch_id = $request->get('customer_id');
        ShipmentDetail::where('doc_no', $doc_no)->delete();

        $res_= $shipment->update(
            array_merge(
                ['updated_by'   => $user->id],
                ['remark' => $request->get('remark') ],
                ['shipping_method' => $request->get('shipping_method') ],
                ['status' => $request->get('status') ],
                ['shipper_name' => $request->get('shipper_name') ],
                ['awb' => $request->get('awb') ],
                ['address' => $request->get('address') ],
                ['etd' => $request->get('etd') ],
                ['eta' => $request->get('eta') ],
                ['dated' => Carbon::createFromFormat('d-m-Y', $request->get('dated'))->format('Y-m-d') ],
            )
        );

        if(!$res_){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save shipment failed'],
            );
    
            return $result;
        }

        for ($i=0; $i < count($request->get('product')); $i++) { 
            $res_detail = ShipmentDetail::create(
                array_merge(
                    ['doc_no' => $doc_no],
                    ['product_id' => $request->get('product')[$i]["id"]],
                    ['qty' => $request->get('product')[$i]["qty_pack"]],
                    ['seq' => $i ],
                    ['uom' => $request->get('product')[$i]["uom"]],
                    ['ref_no_po' => $request->get('product')[$i]["po_no"]],
                    ['ref_no' => $request->get('product')[$i]["ref_no"]]
                )
            );

            if(!$res_detail){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ''],
                    ['message' => 'Save shipment detail failed'],
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