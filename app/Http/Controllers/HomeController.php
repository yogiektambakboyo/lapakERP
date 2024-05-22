<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Auth;
use App\Models\Settings;
use File;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Lang;

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



            $data = $this->data;

            $d_data = DB::select("
                select coalesce(sum(coalesce(im.total,0)),0) as total from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                      
            ");

            $d_data_c = DB::select("
                select count(distinct im.invoice_no) as count_sales from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                       
            ");

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

            $check_settingdoc = DB::select("
                insert into setting_document_counter(doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) 
                select doc_type, sdc.abbr, period, 0, null, 1, 1, now(), b.id
                from setting_document_counter sdc 
                join branch b on b.id not in (select distinct branch_id from setting_document_counter)
                where branch_id = 1 ;                
            ");

            $update_null_commision = DB::select("
                update product_commisions set created_by_fee=0  where created_by_fee is null;
            ");

            $update_null_commision = DB::select("
                update product_commisions set assigned_to_fee=0  where assigned_to_fee  is null; 
            ");

            $update_null_commision = DB::select("
                update product_commisions set referral_fee=0  where referral_fee  is null; 
            ");


            $has_period_stock = DB::select("
                select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
            ");

            if(count($has_period_stock)<=0){
                DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
                select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
                from period_stock ps  where ps.periode=to_char(now()-interval '5 day','YYYYMM')::int;");
            }

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

            $visitor = DB::select("
                select customer_type,count(distinct customers_id) as counter  from invoice_master im where im.dated = now()::date group by customer_type 
            ");

            $visitor_dated = DB::select("
                select dated,count(distinct customers_id) as counter  from invoice_master im where im.dated between now()-interval'7 days' and now()::date group by dated;
            ");

            $p_buffer_Stock = DB::select("
                insert into product_stock_buffer(product_id,branch_id,qty) 
                select ps.id,b.id,0 from product_sku ps
                join branch b on 1=1
                where b.id > 1 and ps.id||'-'||b.id not in (select product_id||'-'||branch_id  from product_stock_buffer);
            ");

            $p_Stock = DB::select("
                    insert into product_stock
                    select ps2.id,b.id,0,null,now(),1  from product_sku ps2
                    join branch b on b.id > 1
                    where ps2.type_id=1 and b.id||''||ps2.id not in (
                    select branch_id||''||product_id  
                    from product_stock ps);
            ");

            $p_insert_s_service = DB::select("
                    insert into product_stock
                    select ps.id,b.id,9999,null,now(),1 from product_sku ps 
                    join branch b on 1=1
                    where ps.type_id > 1 and b.id||''||ps.id  not in (
                    select branch_id||''||product_id  from product_stock
                    );
            ");

            $p_insert_s_service = DB::select("
                update product_stock set qty = 9999 where product_id in  (select id from product_sku where type_id>1) and qty<50;
            ");


            
            return view('pages.home-index',[
                'd_data' => $d_data,
                'd_data_c' => $d_data_c,
                'd_data_p' => $d_data_p,
                'd_data_s' => $d_data_s,
                'd_data_t' => $d_data_t,
                'd_data_r_p' => $d_data_r_p,
                'd_data_r_s' => $d_data_r_s,
                'd_data_v' => $visitor,
                'd_data_v_dated' => $visitor_dated,
            ])->with('data',$data)->with('company',Company::get()->first());
        }else{
            $data = [];
            return view('pages.auth.login')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
        }
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

    public function policy() 
    {
            $data = [];
            return view('pages.auth.policy')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
    }

    public function erase_account() 
    {
            $data = [];
            return view('pages.auth.erase_account')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
    }

    public function nonactive_account() 
    {
            $data = [];
            return view('pages.auth.nonactive_account')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
    }


    public function send_wa(Request $request) 
    {
            $data = [];
            //$url_acc = "https://kakikupos.com/send-msg-wa?token=".$val_token."&no=".$whatsapp_no_."&adrotp=".$otp."&name=".base64_encode($name);
            $number = $request->get("no");
            $msg = $request->get("msg");
            $token = $request->get("token");
            $fromapp = $request->get("fromapp");
            $name = $request->get("name");
            $name = base64_decode($name);
            $otp = $request->get("adrotp");
            $msg = "*OTP Notifikasi* \r\n\r\nHai ".$name.", silahkan masukkan kode OTP *".$otp."* untuk login aplikasi ".$fromapp.".\r\n\r\n_Abaikan pesan ini jika anda tidak merasa login ke aplikasi_";
            $str="number=".$number."&message=".$msg;

            $resp = "Token Not Valid";

            $validate = md5(date("Y-m-d"));

            if($token == $validate){
                $curl = curl_init();

                curl_setopt_array($curl, [
                    CURLOPT_PORT => "8000",
                    CURLOPT_URL => "http://localhost:8000/send-message",
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_ENCODING => "",
                    CURLOPT_MAXREDIRS => 10,
                    CURLOPT_TIMEOUT => 30,
                    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                    CURLOPT_CUSTOMREQUEST => "POST",
                    CURLOPT_POSTFIELDS => $str,
                    CURLOPT_HTTPHEADER => [
                        "Content-Type: application/x-www-form-urlencoded"
                    ],
                ]);

                $response = curl_exec($curl);
                $err = curl_error($curl);

                curl_close($curl);



                if ($err) {
                    $resp = "Error ". $err;
                } else {
                    $resp = $response;
                }
            }

            return $resp;
    }

    public function send_wa_media(Request $request) 
    {
            
            $resp = "Token Not Valid";
            $tokenx = $_GET["tokenx"];
            if($tokenx == "qwsertyqqOPSd"){

                echo "=============================================================<br>";
                echo "*".str_repeat('&nbsp;', 50)."Get API Filemaker".str_repeat('&nbsp;', 50)."*<br>";
                echo "=============================================================<br>";

                $curl = curl_init();
                $today = date('m/d/Y');

                $result_1 = [];
                $result_2 = [];

                $dbname = base64_decode($_GET["dbname"]);
                $layout_name = base64_decode($_GET["layout_name"]);
                $doc_no = base64_decode($_GET["doc_no"]);
                $doc_column = base64_decode($_GET["doc_column"]);
                $wa_no = base64_decode($_GET["wa_no"]);

                //$url = "172.19.20.239";
                $url = "18.138.115.173";

                if(empty($wa_no)||empty($dbname)||empty($layout_name)||empty($doc_no)||empty($doc_column)){
                echo "failed";
                }else{

                //Begin If
                
                //echo "Get Data From ".$dbname." <br>";

                //token lokal QWRtaW5pc3RyYXRvcjpxd3Jvb3Q=
                //token public QWd1czpBNnVzQjRsaQ==
                curl_setopt_array($curl, [
                    CURLOPT_URL => "https://".$url."/fmi/data/vLatest/databases/".$dbname."/sessions",
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_ENCODING => "",
                    CURLOPT_MAXREDIRS => 10,
                    CURLOPT_SSL_VERIFYHOST => 0,
                    CURLOPT_SSL_VERIFYPEER => 0,
                    CURLOPT_TIMEOUT => 30,
                    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                    CURLOPT_CUSTOMREQUEST => "POST",
                    CURLOPT_POSTFIELDS => "{ \"fmDataSource\":\n  [ { \"database\":\"".$dbname."\", \"username\":\"\", \"password\":\"\" } ]\n}",
                    CURLOPT_HTTPHEADER => [
                    "Authorization: Basic QWRtaW5pc3RyYXRvcjpxd3Jvb3Q=",
                    "Content-Type: application/json"
                    ],
                ]);

                $response = curl_exec($curl);
                $err = curl_error($curl);

                curl_close($curl);

                $json_response = json_decode($response);
                $token = "";
                $err = "";
                if ($err) {
                    echo "cURL Error #:" . $err;
                } else {
                    $token = $json_response->response->token;
                    echo "Login success with token : ".$token;

                    $curl = curl_init();
                    curl_setopt_array($curl, [
                        CURLOPT_URL => "https://".$url."/fmi/data/vLatest/databases/".$dbname."/layouts/".$layout_name."/_find",
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_ENCODING => "",
                        CURLOPT_MAXREDIRS => 10,
                        CURLOPT_SSL_VERIFYHOST => 0,
                        CURLOPT_SSL_VERIFYPEER => 0,
                        CURLOPT_TIMEOUT => 30,
                        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                        CURLOPT_CUSTOMREQUEST => "POST",
                        CURLOPT_POSTFIELDS => "{\n  \"query\": [\n    { \"".$doc_column."\" : \"".$doc_no."\"  }\n  ],\n  \"limit\": 2500\n}",

                        CURLOPT_HTTPHEADER => [
                            "Content-Type: application/json",
                            "Authorization: Bearer ".$token
                        ],
                    ]);
                    
                    $resp = curl_exec($curl);
                    $err = curl_error($curl);
                    
                    curl_close($curl);

                    if ($err) {
                    echo "cURL Error #:" . $err;
                    }else{
                    echo "<br>";
                    echo "<br>";
                    echo "Success get data";
                    echo "<br>";
                    echo "<br>";

                    $json_slab = json_decode($resp);
                    $result = $json_slab->response->data;

                    $query = "";
                    for ($i=0; $i < count($result); $i++) { 
                        $res_enc = json_decode(json_encode($result[$i]->fieldData), true);
                        $result_1[] = $res_enc;
                    }

                    $filePDF = $result_1[0]["zFile"];
                    $fileName = $result_1[0]["zFileName"];

                    var_dump($result_1);
                    var_dump($result_1[0]["zFile"]);
                    echo "<br>";
                    echo "<br>";


                    $cookieFile = tempnam(sys_get_temp_dir(), "CURLCOOKIE");
                    $curl = curl_init();
                    curl_setopt_array($curl, [
                        CURLOPT_URL => $filePDF,
                        CURLOPT_COOKIEJAR =>$cookieFile,
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_MAXREDIRS => 10,
                        CURLOPT_SSL_VERIFYHOST => 0,
                        CURLOPT_SSL_VERIFYPEER => 0,
                        CURLOPT_TIMEOUT => 30,
                        CURLOPT_CUSTOMREQUEST => "POST",
                        CURLOPT_POSTFIELDS => "{\n  \"query\": [\n    { \"".$doc_column."\" : \"".$doc_no."\"  }\n  ],\n  \"limit\": 2500\n}",
                        CURLOPT_HTTPHEADER => [
                            "Content-Type: application/pdf",
                            "Authorization: Bearer ".$token
                        ],
                    ]);
                    
                    $respf = curl_exec($curl);
                    $err = curl_error($curl);
                    curl_close($curl);

                    $curl = curl_init();
                    curl_setopt_array($curl, [
                        CURLOPT_URL => $filePDF,
                        CURLOPT_COOKIEFILE =>$cookieFile,
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_MAXREDIRS => 10,
                        CURLOPT_SSL_VERIFYHOST => 0,
                        CURLOPT_SSL_VERIFYPEER => 0,
                        CURLOPT_TIMEOUT => 30,
                        CURLOPT_CUSTOMREQUEST => "POST",
                        CURLOPT_POSTFIELDS => "{\n  \"query\": [\n    { \"".$doc_column."\" : \"".$doc_no."\"  }\n  ],\n  \"limit\": 2500\n}",
                        CURLOPT_HTTPHEADER => [
                            "Content-Type: application/pdf",
                            "Authorization: Bearer ".$token
                        ],
                    ]);
                    
                    $respf = curl_exec($curl);
                    $err = curl_error($curl);
                    curl_close($curl);

                    // Log Out

                    $curl = curl_init();
                    curl_setopt_array($curl, [
                        CURLOPT_URL => "https://".$url."/fmi/data/vLatest/databases/".$dbname."/sessions/".$token,
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_ENCODING => "",
                        CURLOPT_MAXREDIRS => 10,
                        CURLOPT_TIMEOUT => 30,
                        CURLOPT_SSL_VERIFYHOST => 0,
                        CURLOPT_SSL_VERIFYPEER => 0,
                        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                        CURLOPT_CUSTOMREQUEST => "DELETE",
                        CURLOPT_POSTFIELDS => "",
                        CURLOPT_HTTPHEADER => [
                            "Content-Type: application/json",
                            "Authorization: Bearer ".$token
                        ],
                        ]);
                        
                        $response = curl_exec($curl);
                        $err = curl_error($curl);
                        
                        curl_close($curl);



                        $fe = base64_encode($respf);
                        $decoded = base64_decode($fe);
                        $file = 'zzFile_'.date("YmdHis").'.pdf';
                        //file_put_contents($file, $decoded);

                        $destination = '/images/user-files/'.$file;
                        File::put(public_path($destination), $decoded);

                        $file_link = "https://kakikupos.com/images/user-files/".$file;

                        //Send WA

                        $curl = curl_init();

                        //$number = $_GET["no"];
                        $number = $wa_no;
                        $caption = "Terlampir Dokumen ".$layout_name." *Nomor  ".$doc_no."*";
                        //$caption = $_GET["caption"];
                        $file = $file_link;
                        //$file = $_GET["file"];
                        //$str="number=".$number."&message=".$msg;
                        $str="number=".$number."&caption=".$caption."&file=".$file;

                        curl_setopt_array($curl, [
                        CURLOPT_PORT => "8000",
                        CURLOPT_URL => "http://localhost:8000/send-media",
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_ENCODING => "",
                        CURLOPT_MAXREDIRS => 10,
                        CURLOPT_TIMEOUT => 30,
                        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                        CURLOPT_CUSTOMREQUEST => "POST",
                        CURLOPT_POSTFIELDS => $str,
                        CURLOPT_HTTPHEADER => [
                            "Content-Type: application/x-www-form-urlencoded"
                        ],
                        ]);

                        $response = curl_exec($curl);
                        $err = curl_error($curl);

                        curl_close($curl);

                        if ($err) {
                        echo "cURL Error #:" . $err;
                        } else {
                        echo $response;
                        }




                    }

                }
                //End If

                }
            }
            return $resp;
    }

}
