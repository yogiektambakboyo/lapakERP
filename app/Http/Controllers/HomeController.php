<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Auth;
use App\Models\Order;
use App\Models\OrderDetail;
use App\Models\Settings;
use App\Models\Company;
use App\Models\SettingsDocumentNumber;
use App\Models\Customer;
use Session;
use Illuminate\Support\Facades\DB;
use App\Models\Currency;
use App\Http\Controllers\Lang;
use Illuminate\Support\Facades\Redirect;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Client;

class HomeController extends Controller
{
    private $data;
    public function index() 
    {
        $user = Auth::user();
        if($user != null){
            $join_date_renew = DB::select("UPDATE users SET join_years = case when extract(year from age(now(),join_date))<=0 then 1 else extract(year from age(now(),join_date)) end");  

            $id = $user->roles->first()->id;
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
                            'display' => '', 
                            'sub_menu' => []
                        ],
                        [
                            'icon' => 'fa fa-box',
                            'title' => \Lang::get('home.product_management'),
                            'url' => 'javascript:;',
                            'caret' => true,
                            'display' => '', 
                            'sub_menu' => []
                        ],
                        [
                            'icon' => 'fa fa-box',
                            'title' => \Lang::get('home.service_management'),
                            'url' => 'javascript:;',
                            'caret' => true,
                            'display' => '', 
                            'sub_menu' => []
                        ],
                        [
                            'icon' => 'fa fa-table',
                            'title' => \Lang::get('home.transaction'),
                            'url' => 'javascript:;',
                            'caret' => true,
                            'display' => '', 
                            'sub_menu' => []
                        ],
                        [
                            'icon' => 'fa fa-chart-column',
                            'title' => \Lang::get('home.reports'),
                            'url' => 'javascript:;',
                            'caret' => true,
                            'display' => '', 
                            'sub_menu' => []
                        ],
                        [
                            'icon' => 'fa fa-screwdriver-wrench',
                            'title' => \Lang::get('home.settings'),
                            'url' => 'javascript:;',
                            'caret' => true,
                            'display' => '', 
                            'sub_menu' => []
                        ]  
                    ]      
            ];

            $c_user = 0;
            $c_product = 0;
            $c_service = 0;
            $c_trans = 0;
            $c_report = 0;
            $c_setting = 0;
    
            foreach ($permissions as $key => $menu) {
                if($menu['parent']=='Users'){
                    $c_user++;
                    array_push($this->data['menu'][0]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }
                if($menu['parent']=='Products'){
                    $c_product++;
                    array_push($this->data['menu'][1]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }
                if($menu['parent']=='Services'){
                    $c_service++;
                    array_push($this->data['menu'][2]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }
                if($menu['parent']=='Transactions'){
                    $c_trans++;
                    array_push($this->data['menu'][3]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }	
                if($menu['parent']=='Reports'){
                    $c_report++;
                    array_push($this->data['menu'][4]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }
                if($menu['parent']=='Settings'){
                    $c_setting++;
                    array_push($this->data['menu'][5]['sub_menu'], array(
                        'url' => $menu['url'],
                         'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                        'route-name' => $menu['name']
                    ));
                }
            }
    
            if($c_user == 0){
                $this->data['menu'][0]['display'] = 'd-none';
            }
            if($c_product == 0){
                $this->data['menu'][1]['display'] = 'd-none';
            }
    
            if($c_service == 0){
                $this->data['menu'][2]['display'] = 'd-none';
            }
    
            if($c_trans == 0){
                $this->data['menu'][3]['display'] = 'd-none';
            }
    
            if($c_report == 0){
                $this->data['menu'][4]['display'] = 'd-none';
            }
    
            if($c_setting == 0){
                $this->data['menu'][5]['display'] = 'd-none';
            }



            $data = $this->data;

            $d_data = DB::select("
                select coalesce(sum(coalesce(im.total,0)),0) as total from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                      
            ");

            $s_reset_daily = DB::select("update setting_document_counter s set updated_at=now(),current_value = 0  where s.period='Daily' and (s.updated_at is null or s.updated_at::date!= now()::date);");
            $s_reset_monthly = DB::select("update setting_document_counter s set updated_at=now(),current_value = 0 where s.period='Monthly' and (s.updated_at is null or to_char(s.updated_at,'YYYYMM')!= to_char(now(),'YYYYMM'));");
            $s_reset_yearly = DB::select("update setting_document_counter s set updated_at=now(),current_value = 0 where s.period='Yearly' and (s.updated_at is null or to_char(s.updated_at,'YYYY')!= to_char(now(),'YYYY'));");

            $d_data_c = DB::select("
                select count(distinct im.invoice_no) as count_sales from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                       
            ");

            $insert_doc = DB::select('
                insert into setting_document_counter(doc_type,abbr,"period",current_value,branch_id)
                select sdc.doc_type,sdc.abbr,sdc.period,sdc.current_value,b.id 
                from branch b 
                join setting_document_counter sdc on sdc.branch_id=1
                where b.id not in (select distinct branch_id from setting_document_counter)
                order by b.id;
            ');

            $d_data_p = DB::select("
                select coalesce(sum(id.total+id.vat_total),0) as total_product  from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id not in (2,8)
                where ub.user_id = ".$user->id."  and im.dated = now()::date                       
            ");

            $d_data_t = DB::select("
                select u.name as user_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join users u on u.id = id.assigned_to 
                where ub.user_id = ".$user->id."  and im.dated = now()::date 
                group by u.name order by 2 desc                    
            ");

            $d_data_s = DB::select("
                select coalesce(sum(id.total+id.vat_total),0) as total_service  from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id in (2,8)
                where ub.user_id = ".$user->id."  and im.dated = now()::date                     
            ");

            $d_data_r_p = DB::select("
                select ps.remark  as product_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                where ub.user_id = ".$user->id."  and im.dated = now()::date  
                group by ps.remark  order by 2 desc
            ");

            $d_data_r_s = DB::select("
                select ps.remark  as product_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 2
                where ub.user_id = ".$user->id."  and im.dated = now()::date  
                group by ps.remark  order by 2 desc
            ");



            $has_period_stock = DB::select("
                select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
            ");

            if(count($has_period_stock)<=0){
                DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
                select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
                from period_stock ps  where ps.periode=to_char(now()-interval '5 day','YYYYMM')::int;");
            }

            DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
                        select to_char(now()::date,'YYYYMM')::int,b.id,ps.id,0,0,0 as qty_in,0 as qty_out,null,1,now()  
                        from product_sku ps
                        join branch b on 1=1
                        left join period_stock pt on pt.branch_id = b.id and pt.product_id = ps.id and pt.periode = to_char(now()::date,'YYYYMM')::int
                        where pt.branch_id is null
            ", []);

            $exist_product_stock = DB::select("
                    insert into product_stock(product_id,branch_id,qty,updated_at,created_at,created_by) 
                    select id,pd.branch_id,0 as qty,now(),now(),ub.user_id
                    from product_sku
                    join product_distribution pd  on pd.product_id = product_sku.id  and pd.active = '1'
                    join (select * from users_branch u where u.user_id = '".$user->id."' order by branch_id desc limit 1 ) ub on ub.branch_id=pd.branch_id 
                    left join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = ub.branch_id
                    where product_sku.active = '1' and product_sku.type_id = '1' and pk.product_id is null;
            ");

            $has_shift_counter = DB::select("
                select users_id from shift_counter where created_at::date=now()::date;
            ");

            if(count($has_shift_counter)<=0){
                DB::select("insert into shift_counter(users_id,queue_no,created_by,created_at,branch_id)
                select u.id,row_number() over(partition by u.branch_id  order by u.name),1,now(),u.branch_id  from users u 
                join users_shift us on us.users_id = u.id and us.dated = now()::date
                where u.job_id = 2
                group by u.id,u.name;");
            }else{
                DB::select("
                    delete from shift_counter where created_at::date<now()::date;
                ");
            }

            $has_period_sell_price = DB::select("
                select period  from period_price_sell ps where ps.period = to_char(now()::date,'YYYYMM')::int;
            ");

            if(count($has_period_sell_price)<=0){
                DB::select("insert into public.period_price_sell(period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id)
                SELECT to_char(now(),'YYYYMM')::int, product_id, value, null, null, 1, now(), branch_id
                FROM public.period_price_sell  where period=to_char(now()-interval '5 day','YYYYMM')::int;");
            }
            
            return view('pages.home-index',[
                'd_data' => $d_data,
                'd_data_c' => $d_data_c,
                'd_data_p' => $d_data_p,
                'd_data_s' => $d_data_s,
                'd_data_t' => $d_data_t,
                'd_data_r_p' => $d_data_r_p,
                'd_data_r_s' => $d_data_r_s,
            ])->with('data',$data)->with('company',Company::get()->first());
        }else{
            $data = [];
            return redirect()->route('login.profile', []);
            //return view('pages.auth.login')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
        }
    }

    public function policy() 
    {
            $data = [];
            return view('pages.auth.policy')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
    }

    public function order_welcome(String $abbr)
    {
        Session::put('ses_customer_id', "");
        Session::put('ses_customer_name', "");

        $branch = DB::select('select id,address,remark from branch where abbr = ? limit 1;', [$abbr]);
        if(count($branch)>=1){
            Session::put('ses_company_name', $branch[0]->remark);
            Session::put('ses_company_addess', $branch[0]->address);
            Session::put('ses_company_id', $branch[0]->id);
            return view('pages.auth.order_welcome',
            [
                'branch' => $branch,
                'settings' => Settings::get()->first(),
                'company' => Company::get()->first()
            ]);
        }else{
            return abort(404);
        }
        
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param Order $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store_order(Request $request) 
    {
        $branch_id = $request->get('branch_id') ;
        $customer_id = $request->get('customer_id') ;

        $count_no = SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch_id)->where('period','=','Yearly')->get(['current_value','abbr']);
        $count_no_daily = SettingsDocumentNumber::where('doc_type','=','Order_Queue')->where('branch_id','=',$branch_id)->where('period','=','Daily')->get(['current_value','abbr']);
        $order_no = $count_no[0]->abbr.'-'.substr(('000'.$branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_order = Order::create(
            array_merge(
                ['order_no' => $order_no ],
                ['created_by' => 1],
                ['dated' => date('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => $request->get('total_order') ],
                ['remark' => $request->get('remark') ],
                ['currency' => $request->get('currency') ],
                ['kurs' => $request->get('kurs') ],
                ['payment_nominal' => $request->get('payment_nominal') ],
                ['payment_type' => $request->get('payment_type') ],
                ['total_payment' => (int)$request->get('payment_nominal')>=(int)$request->get('total_order')?(int)$request->get('total_order'):$request->get('payment_nominal') ],
                ['voucher_code' => $request->get('voucher_code')],
                ['total_discount' => $request->get('total_discount')],
                ['tax' => $request->get('total_vat')],
                ['queue_no' => (int)($count_no_daily[0]->current_value+1)],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name ],
            )
        );

        $c_name = Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name;

        SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch_id)->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

        SettingsDocumentNumber::where('doc_type','=','Order_Queue')->where('branch_id','=',$branch_id)->where('period','=','Daily')->update(
            array_merge(
                ['current_value' => ((int)($count_no_daily[0]->current_value) + 1)]
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
                    ['seq' => $request->get('product')[$i]["seq"] ]
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

        $client = new Client(); //GuzzleHttp\Client
        $response = $client->request('POST', 'https://app.midtrans.com/snap/v1/transactions', [
            'body' => '{ "transaction_details": { "order_id" : "'.$order_no.'" , "gross_amount" : '.$request->get('total_order').'},
            "customer_details": {
                    "first_name": "'.$c_name.'",
                    "last_name": "ONLINE",
                    "email": "yogiektambakboyo@gmail.com",
                    "phone": "+6285746879090"
                }
            }',
            'headers' => [
                'accept' => 'application/json',
                'authorization' => 'Basic TWlkLXNlcnZlci10eGIyWEN6VmpMbTRRV29sU2drZGdpejY6',
                'content-type' => 'application/json',
            ],
        ]);

        //$res = $response->getBody()->getContents();
        

        $fin_url = "";
        if(!empty($response->getBody())){
            $url = json_decode($response->getBody()->getContents(), true);
            $fin_url = $url["redirect_url"];

            DB::update("update order_master set payment_url = ? where order_no = ?;", [ $fin_url, $order_no ]);
        }


        $result = array_merge(
            ['status' => 'success'],
            ['data' => $order_no],
            ['redirect_url' => $fin_url],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    public function get_order(Request $request) 
    {
        $branch_id = $request->get('branch_id') ;
        $customer_id = $request->get('customer_id') ;

        $order_list = DB::select("select om.id,om.order_no,to_char(om.dated,'dd-mm-YYYY') as dated,om.total, om.total_payment, om.payment_url
                                    from order_master om 
                                    join order_detail od on od.order_no = om.order_no 
                                    where om.customers_id = ? and (om.total_payment > 0 or om.dated = now()::date )
                                    group by om.id,om.order_no,to_char(om.dated,'dd-mm-YYYY'),om.total, om.total_payment, om.payment_url
                                    order by dated,order_no desc ", [$customer_id]);

        $result = array_merge(
            ['status' => 'success'],
            ['data' => $order_list],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    public function ordercustomer() 
    {
        $branch = DB::select('select id,address,remark from branch where id = ? limit 1;', [Session::get('ses_company_id')]);
        $data = [];

        $customer_id = "";
        $customer_name = "";

        $order_id = "";
        $status_code = "";
        $transaction_status = "";
        if(empty($_GET['order_id'])){

        }else{
            $order_id = $_GET['order_id'];
        }

        if(empty($_GET['status_code'])){

        }else{
            $status_code = $_GET['status_code'];
        }

        if(empty($_GET['transaction_status'])){

        }else{
            $transaction_status = $_GET['transaction_status'];
        }

        if(!empty(Session::get('ses_customer_id'))){
            $customer_id = Session::get('ses_customer_id');
        }
        if(!empty(Session::get('ses_customer_name'))){
            $customer_name = Session::get('ses_customer_name');
        }

        if(count($branch)>=1){
            Session::put('ses_company_name', $branch[0]->remark);
            Session::put('ses_company_addess', $branch[0]->address);
            Session::put('ses_company_id', $branch[0]->id);
            return view('pages.pos-customer-order',[
                'branch' => $branch,
                'settings' => Settings::get()->first(),
                'company' => Company::get()->first(),
                'customer_name' => $customer_name,
                'customer_id' => $customer_id,
                'order_id' => $order_id,
                'status_code' => $status_code,
                'transaction_status' => $transaction_status,
            ]);
        }else{
            return abort(404);
        }
    }

    public function payment_notif(Request $request) 
    {
        $data = json_decode(file_get_contents('php://input'), true);

        if(!empty($data)){
            $data_str = json_encode($data);
            DB::insert("insert into log_payment(remark) values (?);", [$data_str]);

            $transaction_time   = $data['transaction_time'];
            $transaction_status = $data['transaction_status'];
            $transaction_id = $data['transaction_id'];
            $status_message = $data['status_message'];
            $signature_key  = $data['signature_key'];
            $payment_type   = $data['payment_type'];
            $order_id       = $data['order_id'];
            $merchant_id    = $data['merchant_id'];
            $gross_amount   = $data['gross_amount'];
            $fraud_status   = $data['fraud_status'];
            $currency       = $data['currency'];
            
           
            $sql = "INSERT INTO payment_notif(transaction_time,transaction_status,transaction_id,status_message,signature_key,payment_type,order_id,merchant_id,gross_amount,fraud_status,currency)
            VALUES (?,?,?,?,?,?,?,?,?,?,?);";

            DB::insert($sql, [$transaction_time,$transaction_status,$transaction_id,$status_message,$signature_key,$payment_type,$order_id,$merchant_id,$gross_amount,$fraud_status,$currency]);
            
            if($payment_type == "credit_card"){
                $p_type = "Kartu";
            }else if($payment_type == "gopay"){
                $p_type = "GoPay";
            }else if($payment_type == "qris"){
                $p_type = "QRIS";
            }else if($payment_type == "shopeepay"){
                $p_type = "ShoopePay";
            }else if($payment_type == "bank_transfer"){
                $p_type = "Bank Transfer";
            }

            if($transaction_status == "capture" || $transaction_status == "settlement"){
                DB::update('update order_master set total_payment = ?,payment_type = ? where order_no = ? ', [ $gross_amount, $p_type, $order_id ]);
            }

            $result = array_merge(
                ['status' => 'success'],
                ['data' => ''],
                ['message' => 'success'],
            );
    
            return $result;

        }else{
            $result = array_merge(
                ['status' => 'success'],
                ['data' => ''],
                ['message' => 'alive'],
            );
    
            return $result;
        }
    }

    public function setsession(Request $request) 
    {
        $branch = DB::select('select id,address,remark from branch where id = ? limit 1;', [Session::get('ses_company_id')]);
        $customer_name = $request->get('name');
        $phone_no = $request->get('phone_no');
        $branch_id = $request->get('branch_id');
        $customer_id = "0";

        if(count($branch)>=1){
            $data = $this->data;

            $check_cust = DB::select('select id,name,address,phone_no,membership_id,abbr,branch_id,city from customers where phone_no = ?', [$phone_no]);

            if(count($check_cust)>0){
                $customer_id = $check_cust[0]->id;
                $customer_name = $check_cust[0]->name;
            }else{
                Customer::create(
                    array_merge( 
                        ['phone_no' => $request->get('phone_no') ],
                        ['name' => $request->get('name') ],
                        ['address' => "Online" ],
                        ['membership_id' => '1' ],
                        ['abbr' => '1' ],
                        ['branch_id' => $request->get('branch_id') ],
                        ['sales_id' => $request->get('sales_id') ],
                        ['city' => "Online" ],
                        ['whatsapp_no' => $request->get('phone_no') ],
                    )
                );

                $customer_ids = DB::select("select id from customers where branch_id = ? order by id desc limit 1", [ $branch_id]);
                $customer_id = $customer_ids[0]->id;
            }

            Session::put('ses_customer_name', $customer_name);
            Session::put('ses_customer_id', $customer_id);
            
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $customer_id],
                ['message' => 'success'],
            );

        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Save invoice failed'],
            );
        }
        return $result;
    }

    public function getproduct_public() 
    {
        $branch = DB::select('select id,address,remark from branch where id = ? limit 1;', [Session::get('ses_company_id')]);

        if(count($branch)>=1){
            Session::put('ses_company_name', $branch[0]->remark);
            Session::put('ses_company_addess', $branch[0]->address);
            Session::put('ses_company_id', $branch[0]->id);
            $data = $this->data;
            $product = DB::select("select pc.id as category_id,product_sku.photo,product_sku.product_desc,m.remark as uom,product_sku.id,product_sku.remark,product_sku.abbr,pt.remark as type,pc.remark as category_name,pb.remark as brand_name,pp.price,'0' as discount,'0' as qty,'0' as total
            from product_sku
            join product_distribution pd on pd.product_id = product_sku.id  and pd.active = '1' and pd.branch_id = ?
            join product_stock pts on pts.product_id = pd.product_id and pts.branch_id = pd.branch_id and pts.qty>0
            join product_category pc on pc.id = product_sku.category_id 
            join product_type pt on pt.id = product_sku.type_id 
            join product_brand pb on pb.id = product_sku.brand_id 
            join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
            join product_uom pu on pu.product_id = product_sku.id
            join uom m on m.id = pu.uom_id
            join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = pd.branch_id
            where product_sku.active = '1' order by product_sku.remark",[$branch[0]->id]);

            $product_cat = DB::select("select  pc.id as category_id,pc.remark as category_name
            from product_sku
            join product_distribution pd on pd.product_id = product_sku.id  and pd.active = '1' and pd.branch_id = ?
            join product_stock pts on pts.product_id = pd.product_id and pts.branch_id = pd.branch_id and pts.qty>0
            join product_category pc on pc.id = product_sku.category_id 
            join product_type pt on pt.id = product_sku.type_id 
            join product_brand pb on pb.id = product_sku.brand_id 
            join product_price pp on pp.product_id = pd.product_id and pp.branch_id = pd.branch_id
            join product_uom pu on pu.product_id = product_sku.id
            join uom m on m.id = pu.uom_id
            join product_stock pk on pk.product_id = product_sku.id and pk.branch_id = pd.branch_id
            where product_sku.active = '1' group by  pc.id,pc.remark order by 2",[$branch[0]->id]);
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $product],
                ['data_category' => $product_cat],
                ['message' => 'Save invoice failed'],
            );

        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => []],
                ['message' => 'Save invoice failed'],
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
                        'display' => '', 
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.product_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
		            [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.service_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => \Lang::get('home.transaction'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => \Lang::get('home.reports'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => \Lang::get('home.settings'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ]  
                ]      
        ];

        $c_user = 0;
        $c_product = 0;
        $c_service = 0;
        $c_trans = 0;
        $c_report = 0;
        $c_setting = 0;

        foreach ($permissions as $key => $menu) {
            if($menu['parent']=='Users'){
                $c_user++;
                array_push($this->data['menu'][0]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                $c_product++;
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                $c_service++;
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                $c_trans++;
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                $c_report++;
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                $c_setting++;
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
        }

        if($c_user == 0){
            $this->data['menu'][0]['display'] = 'd-none';
        }
        if($c_product == 0){
            $this->data['menu'][1]['display'] = 'd-none';
        }

        if($c_service == 0){
            $this->data['menu'][2]['display'] = 'd-none';
        }

        if($c_trans == 0){
            $this->data['menu'][3]['display'] = 'd-none';
        }

        if($c_report == 0){
            $this->data['menu'][4]['display'] = 'd-none';
        }

        if($c_setting == 0){
            $this->data['menu'][5]['display'] = 'd-none';
        }
    }
}
