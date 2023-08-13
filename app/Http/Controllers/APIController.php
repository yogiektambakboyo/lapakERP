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

        if (Auth::attempt(['username' => $username, 'password' => $password])) {
            //id,name,username,password,active,lastlogin,roles
            $login = DB::select( DB::raw("select '' as id,username,'' as password,name,now()::date as downloaddate,'1' as active,b.remark  as lastlogin,'99' as roles from users u join branch b on b.id = u.branch_id  where username = :username"), array(
                'username' => $username,
            ));
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $login],
                ['message' => 'Login Succesfully'],
            ); 
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ""],
                ['message' => 'Username/Password not valid'],
            );  
        }

        return response()->json($result);
    }

    public function api_product_list(Request $request)
    { 
        $result_query = DB::select( DB::raw("select ps.id,ps.remark,ps.abbr,ps.barcode,ps.photo,ps.photo_2,pc.remark as category_name,pb.remark as brand_name from product_sku ps 
        join product_category pc on pc.id = ps.category_id 
        join product_brand pb on pb.id = ps.brand_id 
        where active = 1"), array());
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $result_query],
            ['message' => 'Get Product Succesfully'],
        ); 

        return response()->json($result);
    }

    public function api_product_list_stock(Request $request)
    { 
        $result_query = DB::select( DB::raw("select ps.id,ps.remark,ps.abbr,ps.barcode,ps.photo,ps.photo_2,pc.remark as category_name,pb.remark as brand_name 
        from product_sku ps 
        join product_category pc on pc.id = ps.category_id 
        join product_brand pb on pb.id = ps.brand_id 
        join product_stock pt on pt.product_id = ps.id 
        join users u on u.id = :users_id and u.active=1 and pt.branch_id = u.branch_id
        where ps.active = 1"), array(
            'users_id' => $request->get('user_id'),
        ));
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $result_query],
            ['message' => 'Get Stock Product Succesfully'],
        ); 

        return response()->json($result);
    }

    public function api_product_update(Request $request)
    { 
        $result_query = DB::select( DB::raw("select ps.id,ps.remark,ps.abbr,ps.barcode,ps.photo,ps.photo_2,pc.remark as category_name,pb.remark as brand_name from product_sku ps 
        join product_category pc on pc.id = ps.category_id 
        join product_brand pb on pb.id = ps.brand_id 
        where active = 1"), array(
            
        ));
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $result_query],
            ['message' => 'Get Product Succesfully'],
        ); 

        return response()->json($result);
    }

    public function api_order_list(Request $request)
    { 
        $result_query = DB::select( DB::raw("select om.id,om.order_no,om.dated,c.name as customers_name,om.customers_id,om.created_at,om.created_by,u.name as creator_name,om.is_checkout 
        from order_master om 
        join customers c on c.id = om.customers_id 
        join users u on u.id= om.created_by 
        where om.is_checkout = 0 and om.dated = now()::date"), array());
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $result_query],
            ['message' => 'Get Orders Succesfully'],
        ); 

        return response()->json($result);
    }

    public function api_customer_list(Request $request)
    { 
        $result_query = DB::select( DB::raw("select om.id,om.order_no,om.dated,c.name as customers_name,om.customers_id,om.created_at,om.created_by,u.name as creator_name,om.is_checkout 
        from order_master om 
        join customers c on c.id = om.customers_id 
        join users u on u.id= om.created_by 
        where om.is_checkout = 0 and om.dated = now()::date"), array());
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $result_query],
            ['message' => 'Get Orders Succesfully'],
        ); 

        return response()->json($result);
    }

    
    public function api_order_create(Request $request)
    { 
        $branch = Customer::where('id','=',$request->get('customer_id'))->get(['branch_id'])->first();
        $count_no = SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->get(['current_value','abbr']);
        $count_no_daily = SettingsDocumentNumber::where('doc_type','=','Order_Queue')->where('branch_id','=',$branch->branch_id)->where('period','=','Daily')->get(['current_value','abbr']);
        $order_no = $count_no[0]->abbr.'-'.substr(('000'.$branch->branch_id),-3).'-'.date("Y").'-'.substr(('00000000'.((int)($count_no[0]->current_value) + 1)),-8);

        $res_order = Order::create(
            array_merge(
                ['order_no' => $order_no ],
                ['created_by' => $request->get('user_id')],
                ['dated' => Carbon::parse($request->get('order_date'))->format('Y-m-d') ],
                ['customers_id' => $request->get('customer_id') ],
                ['total' => 0 ],
                ['remark' => $request->get('remark') ],
                ['payment_nominal' => 0 ],
                ['payment_type' => 0 ],
                ['total_payment' => 0 ],
                ['branch_room_id' => 0],
                ['voucher_code' => ''],
                ['total_discount' => 0],
                ['tax' => 0],
                ['queue_no' => (int)($count_no_daily[0]->current_value+1)],
                ['customers_name' => Customer::where('id','=',$request->get('customer_id'))->get(['name'])->first()->name ],
            )
        );

        SettingsDocumentNumber::where('doc_type','=','Order')->where('branch_id','=',$branch->branch_id)->where('period','=','Yearly')->update(
            array_merge(
                ['current_value' => ((int)($count_no[0]->current_value) + 1)]
            )
        );

    
        if(!$res_order){
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Save order failed'],
            );
    
            return $result;
        }else{
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $order_no],
                ['message' => 'Save order sucess'],
            );
    
            return $result;
        }

        /**
        
        */
    }

}
