<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Room;
use App\Models\Branch;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Lang;

use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use App\Services\Login\RememberMeExpiration;
use App\Models\Settings;

use App\Models\SettingsDocumentNumber;
use App\Models\Customer;
use App\Models\Order;
use App\Models\User;
use App\Models\Product;
use App\Models\ProductUom;
use App\Models\OrderDetail;
use Carbon\Carbon;



class APIController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data,$act_permission,$module="rooms",$id=1;

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


    public function api_login(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $login = DB::select( DB::raw("select s.id||'' id,s.name,s.username,s.password, s.address,s.phone,s.email,coalesce(s.ident_id,'-') ident_id,s.active||'' as active,coalesce(s.last_login,'2024-01-01') as last_login,t.version_mobile  from sales s join settings  t on 1=1 
                                         where s.username = :username and s.password = :password; "), 
            array(
                'username' => $username,
                'password' => $password
            ));
        

            if (count($login)>0) {
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $login],
                    ['message' => 'Login Berhasil'],
                ); 
            }else{
                $data_res = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $data_res],
                    ['message' => 'Username/Password tidak valid'],
                );  
            }
        }else{
            $data_res = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data_res],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_gt5_transaction(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("select sa.doc_no,to_char(sa.dated,'dd-mm-YYYY') as dated,sa.sales_id,s.name,sum(sad.point) as point  from scan_activity sa 
            join scan_activity_detail sad on sad.doc_no = sa.doc_no 
            join sales s on s.id = sa.sales_id and s.username = :username and s.password = :password
            group by sa.doc_no,sa.dated,sa.sales_id,s.name,sa.created_at
            order by sa.created_at desc limit 5; "), 
            array(
                'username' => $username,
                'password' => $password
            ));
        

            if (count($data_res)>0) {
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $data_res],
                    ['message' => 'Akses Berhasil'],
                ); 
            }else{
                $data_res = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $data_res],
                    ['message' => 'Akses data transaksi gagal'],
                );  
            }
        }else{
            $data_res = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data_res],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_gt_transaction(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("select sa.doc_no,to_char(sa.dated,'dd-mm-YYYY') as dated,sa.sales_id,s.name,sum(sad.point) as point  from scan_activity sa 
            join scan_activity_detail sad on sad.doc_no = sa.doc_no 
            join sales s on s.id = sa.sales_id and s.username = :username and s.password = :password
            group by sa.doc_no,sa.dated,sa.sales_id,s.name,sa.created_at
            order by sa.created_at desc; "), 
            array(
                'username' => $username,
                'password' => $password
            ));
        

            if (count($data_res)>0) {
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $data_res],
                    ['message' => 'Akses Berhasil'],
                ); 
            }else{
                $data_res = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $data_res],
                    ['message' => 'Akses data transaksi gagal'],
                );  
            }
        }else{
            $data_res = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data_res],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_check_lot(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $lot_number = $request->lot_number;
        $product_id = $request->product_id;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $product = DB::select( DB::raw("select sl.is_used,pc.id as category_id,sl.recid,sl.lot_number,sl.alias_code,sl.qty,coalesce(sl.qty_available,0) as qty_available,ps.id as product_id,ps.remark,pc.remark as category_name,pc.add_column_2 as point
            from stock_lotnumber sl 
            join product_sku ps on ps.alias_code = sl.alias_code 
            join product_category pc on pc.id = ps.category_id 
            where sl.lot_number = :lot_number and sl.alias_code = :product_id and sl.no_surat like 'STB%' "), 
            array(
                'lot_number' => $lot_number,
                'product_id' => $product_id
            ));
        

            if (count($product)>0) {
                $is_used = 0;

                for ($i=0; $i < count($product); $i++) { 
                    if($product[$i]->is_used == 1){
                        $is_used = 1;
                    }
                }

                if($is_used == 1){
                    $re = array();
                    $result = array_merge(
                        ['status' => 'failed'],
                        ['data' => $re ],
                        ['message' => 'QR Code sudah pernah discan'],
                    ); 
                }else{
                    $result = array_merge(
                        ['status' => 'success'],
                        ['data' => $product],
                        ['message' => 'Akses Berhasil'],
                    ); 
                }

                
            }else{
                $re = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $re],
                    ['message' => 'QR Code tidak ditemukan'],
                );  
            }
        }else{
            $data_res = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data_res],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_insert_scan(Request $request)
    { 
        $id = $request->id;
        $dated = $request->dated;
        $doc_no = $request->doc_no;
        $token = $request->token;
        $detail = $request->detail;
        $photofile = $request->filephoto;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $del_product = DB::select( DB::raw("DELETE FROM public.scan_activity where doc_no=:doc_no "), 
                array(
                    'doc_no' => $doc_no
                )
            );

            $del_product_detail = DB::select( DB::raw("DELETE FROM public.scan_activity_detail where doc_no=:doc_no "), 
                array(
                    'doc_no' => $doc_no
                )
            );
            
            $product = DB::select( DB::raw("INSERT INTO public.scan_activity(doc_no, dated, created_by, created_at, sales_id,photofile)VALUES (:doc_no, :dated, :created_by, now(), :sales_id,:photofile); "), 
            array(
                'doc_no' => $doc_no,
                'dated' => $dated,
                'created_by' => $id,
                'photofile' => $photofile,
                'sales_id' => $id
            ));


            $counter = 0;
            $point = 0;
            for ($i=0; $i < count($detail); $i++) { 
                $product_detail = DB::select( DB::raw("INSERT INTO public.scan_activity_detail(
                        doc_no, product_id, lot_number, qty, point, category_id, product_name, category_name, alias_code, expired, point_balance)
                        VALUES (:doc_no, :product_id, :lot_number, :qty, :point, :category_id, :product_name, :category_name, :alias_code,now()+interval'1 year' ,:point_balance);"), 
                    array(
                        'doc_no' => $detail[$i]["doc_no"],
                        'lot_number' => $detail[$i]["lot_number"],
                        'qty' => $detail[$i]["qty"],
                        'point' => $detail[$i]["point"],
                        'point_balance' => $detail[$i]["point"],
                        'category_id' => $detail[$i]["category_id"],
                        'product_name' => $detail[$i]["product_name"],
                        'category_name' => $detail[$i]["category_name"],
                        'alias_code' => $detail[$i]["alias_code"],
                        'product_id' => $detail[$i]["product_id"]
                    ));

                    $point = $point + (int)$detail[$i]["point"];
                    $counter++;

                    $update_used = DB::select( DB::raw("update stock_lotnumber set is_used = 1 where alias_code = :alias_code and lot_number = :lot_number; "), 
                    array(
                            'lot_number' => $detail[$i]["lot_number"],
                            'alias_code' => $detail[$i]["alias_code"]
                        )
                    );
            }

            if ($counter>0) {

                $update_poin = DB::select( DB::raw("update sales set point=point+:point where id = :sales_id; "), 
                    array(
                        'point' => $point,
                        'sales_id' => $id
                    )
                );

                

                $insert_log = DB::select( DB::raw("INSERT INTO public.log_point
                (doc_no, sales_id, point, created_at)
                VALUES(:doc_no,:sales_id ,:point, now());"), 
                    array(
                        'point' => $point,
                        'doc_no' => $doc_no,
                        'sales_id' => $id
                    )
                );

                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => ""],
                    ['message' => 'Insert Berhasil'],
                ); 
            }else{
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ""],
                    ['message' => 'Insert gagal'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_user_info(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ident_id = $request->ident_id;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $login = DB::select( DB::raw("select s.id||'' id,s.name,s.username,s.password, s.address,s.phone,s.email,coalesce(s.ident_id,'-') ident_id,s.active||'' as active,coalesce(s.last_login,'2024-01-01') as last_login,t.version_mobile,s.point as poin  from sales s join settings  t on 1=1 
                                         where s.active=1 and s.username = :username and s.password = :password; "), 
            array(
                'username' => $username,
                'password' => $password
            ));
        

            if (count($login)>0) {
                $update_d = DB::select( DB::raw("update sales set last_login=now(), ident_id=:ident_id
                                         where active=1 and username = :username and password = :password and username!='test@gmail.com'; "), 
                    array(
                        'username' => $username,
                        'ident_id' => $ident_id,
                        'password' => $password
                    )
                );
                    
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $login],
                    ['message' => 'Login Berhasil'],
                ); 
            }else{
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => ""],
                    ['message' => 'Username/Password tidak valid'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_rewards(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("select id,remark,point,to_char(dated_start,'dd-mm-YYYY') as dated_start,to_char(dated_end,'dd-mm-YYYY') as dated_end,quota,quota_available from rewards r where quota_available>0;"));
        

            if (count($data_res)>0) {
                
                    
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $data_res],
                    ['message' => 'Akses Data Berhasil'],
                ); 
            }else{
                $a = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $a],
                    ['message' => 'Akses Data Gagal'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_rewards_req(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("select r.remark, rt.point, to_char(rt.created_at,'dd-mm-YYYY HH24:MI') as created_at, case when rt.status=0 then 'Review' when rt.status=1 then 'Disetujui' else 'Di Tolak' end as status  from rewards_transaction rt 
                                                    join rewards r on r.id = rt.rewards_id 
                                                    join sales s on s.id = rt.sales_id and s.username = :username and s.password = :password; "), 
                                                        array(
                                                        'username' => $username,
                                                        'password' => $password
                                                        )
                                                    );
        
            

            if (count($data_res)>0) {
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $data_res],
                    ['message' => 'Akses Data Berhasil'],
                ); 
            }else{
                $a = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $a],
                    ['message' => 'Akses Data Gagal'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_gt_transaction_detail(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $doc_no = $request->doc_no;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("select sd.product_id,sd.qty,'' as scan_res,'' as seq,sd.category_id,sd.doc_no,sd.product_name,sd.category_name,sd.alias_code,sd.lot_number,sd.point from scan_activity sa 
                                                    join scan_activity_detail sd on sd.doc_no = sa.doc_no and sd.doc_no=:doc_no
                                                    join sales s on s.id = sa.sales_id and s.username = :username and s.password = :password; "), 
                                                        array(
                                                        'username' => $username,
                                                        'doc_no' => $doc_no,
                                                        'password' => $password
                                                        )
                                                    );
        
            

            if (count($data_res)>0) {
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => $data_res],
                    ['message' => 'Akses Data Berhasil'],
                ); 
            }else{
                $a = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $a],
                    ['message' => 'Akses Data Gagal'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_change_password(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => ""],
                ['message' => 'Akses Data Berhasil'],
            ); 
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_remove_account(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => ""],
                ['message' => 'Akses Data Berhasil'],
            ); 
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_nonactive_account(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => ""],
                ['message' => 'Akses Data Berhasil'],
            ); 
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_get_rewards_req_create(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $token = $request->token;
        $sales_id = $request->sales_id;
        $rewards_id = $request->rewards_id;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $data_res = DB::select( DB::raw("INSERT INTO public.rewards_transaction(rewards_id, sales_id, point, request_at, status, created_at) 
            select r.id, s.id, r.point, now(), 0, now() from sales s 
            join rewards r on r.id=:rewards_id
            where s.id=:sales_id and s.point>=r.point; "), 
                                                        array(
                                                        'sales_id' => $sales_id,
                                                        'rewards_id' => $rewards_id
                                                        )
                                                    );
        
            

            if (count($data_res)>0) {
                $data_res = DB::select( DB::raw("update sales set point=point-(select point from rewards where id=:rewards_id) where id=:sales_id ; "), 
                                                            array(
                                                            'sales_id' => $sales_id,
                                                            'rewards_id' => $rewards_id
                                                            )
                                                        );
                                                        
                $result = array_merge(
                    ['status' => 'success'],
                    ['data' => ""],
                    ['message' => 'Akses Data Berhasil'],
                ); 
            }else{
                $a = array();
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $a],
                    ['message' => 'Poin tidak mencukupi'],
                );  
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

    public function api_register_sales(Request $request)
    { 
        $username = $request->username;
        $password = $request->password;
        $phone = $request->phone;
        $address = $request->address;
        $name = $request->name;
        $email = $request->email;
        $token = $request->token;
        $ident_id = $request->ident_id;
        $ua = $request->header('User-Agent');
        $token_svr = md5(date('Ymd'));

        $arr = array(
            'username' => $username,
            'password' => $password,
            'phone' => $phone,
            'address' => $address,
            'name' => $name,
            'email' => $email,
            'ident_id' => $ident_id
        );

        $res[] = $arr; 


        if($ua == "Malaikat_Ridwan" && $token == $token_svr){
            $check_exist = DB::select( DB::raw(" select email from public.sales where email = :email; "), array("email" => $email));

            if(count($check_exist)>0){
                $result = array_merge(
                    ['status' => 'failed'],
                    ['data' => $res],
                    ['message' => 'Email sudah digunakan akun lain/ Masih dalam proses pengajuan'],
                );  
            }else{
                $login = DB::select( DB::raw(" INSERT INTO public.sales(name, username, password, address, branch_id, active, phone, email, ident_id)
                                           VALUES(:name, :username, :password, :address, 1, 0, :phone, :email, :ident_id); "), $arr
                );
            
                if (count($login)>0) {
                    $result = array_merge(
                        ['status' => 'success'],
                        ['data' => $res],
                        ['message' => 'Pendaftaran berhasil'],
                    ); 
                }else{
                    $result = array_merge(
                        ['status' => 'failed'],
                        ['data' => $res],
                        ['message' => 'Pendaftaran gagal'],
                    );  
                }
            }
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Tidak diijinkan akses'],
            );  
        }
        

        return response()->json($result);
    }

}
