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
            $login = DB::select( DB::raw("select s.id||'' id,s.name,s.username,s.password, s.address,s.phone,s.email,coalesce(s.ident_id,'-') ident_id,s.active||'' as active,coalesce(s.last_login,'') as last_login,t.version_mobile  from sales s join settings  t on 1=1 
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
                                           VALUES(:name, :username, :password, :address, 1, -1, :phone, :email, :ident_id); "), $arr
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