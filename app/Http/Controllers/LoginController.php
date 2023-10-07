<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use App\Services\Login\RememberMeExpiration;
use App\Models\Settings;
use App\Models\Company;
use App\Http\Controllers\Lang;
use Illuminate\Support\Facades\DB;

class LoginController extends Controller
{
    use RememberMeExpiration;

    /**
     * Display login page.
     * 
     * @return Renderable
     */
    public function show()
    {
        return view('pages.auth.login',[
            'settings' => Settings::get()->first(),'company' => Company::get()->first()
        ]);
    }

    /**
     * Handle account login request
     * 
     * @param LoginRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function login(LoginRequest $request)
    {
        $credentials = $request->getCredentials();

        if(!Auth::validate($credentials)):
            return redirect()->to('login')
                ->withErrors(trans('auth.failed'));
        endif;

        $user = Auth::getProvider()->retrieveByCredentials($credentials);

        Auth::login($user, $request->get('remember'));

        if($request->get('remember')):
            $this->setRememberMeExpiration($user);
        endif;

        return $this->authenticated($request, $user);
    }

    public function api_login(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
        where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
        union all 
        select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
        where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
        ) a limit 1");

        if(substr($whatsapp_no,0,2)=="08"){
            $whatsapp_no = "628".substr($whatsapp_no,2,strlen($whatsapp_no));
        }

        if(count($data)>0){
            $random_numb = mt_rand(1111,9999);
            $data[0]->pass_wd = strval($random_numb);

            DB::select("update customers set pass_wd=".$random_numb." where id=".$data[0]->id.";");
            DB::select("update users set pass_wd=".$random_numb." where id=".$data[0]->id.";");

            $curl = curl_init();
            $token = "Bz7ZeaBPLYvF21GeqUpZk6qA8rFz8zJJlcIgMU7su0rB8lMP00H0akRpKo04k1sH";
            $data_msg = [
                'phone' => $whatsapp_no,
                'message' => '*OTP Notifikasi* \r\n\r\nHai '.$data[0]->name.', silahkan masukkan kode OTP *'.$random_numb.'* untuk login aplikasi.\r\n\r\n_Abaikan pesan ini jika anda tidak merasa login ke aplikasi_',
            ];
            curl_setopt($curl, CURLOPT_HTTPHEADER,
                array(
                    "Authorization: $token",
                )
            );
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data_msg));
            curl_setopt($curl, CURLOPT_URL,  "https://solo.wablas.com/api/send-message");
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
            $result = curl_exec($curl);
            curl_close($curl);
            
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Kode 4 digit OTP terkirim ke nomor Handphone kamu via WhatsApp, silahkan cek dan masukkan disini.'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'No handphone belum terdaftar'],
            );   
        }
        return $result;
        
    }

    public function api_profile(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $data = DB::select("select c.id,c.name, m.remark as membership,m.point as m_point,'cust' as user_type,coalesce(cp.point,0) as point, 0 as voucher,coalesce(c.external_code,'') as external_code 
        from customers c 
        join membership m on m.id = c.membership_id 
        left join customers_point cp on cp.customers_id = c.id
        where pass_wd='".$pass_wd."' and c.whatsapp_no ='".$whatsapp_no."' ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'Login failed'],
            );   
        }
        return $result;
        
    }

    public function api_photo_slide(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $data = DB::select("select id,remark,image_path from content_promotion cp where now()::date between date_begin and date_end order by seq; ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'Login failed'],
            );   
        }
        return $result;
        
    }

    public function api_branch(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $data = DB::select("select b.id,remark as branch_name,b.address as branch_address,b.longitude, b.latitude from branch b 
        join customers c on c.pass_wd='".$pass_wd."' and c.whatsapp_no ='".$whatsapp_no."'
        where b.id>1 and b.active = 1; ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'get Branch failed'],
            );   
        }
        return $result;
        
    }

    public function api_invoice(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $data = DB::select("select im.invoice_no,im.dated,coalesce(ir.value_review,0) value_review,coalesce(ir.remarks,'') as remarks   
        from customers c 
        join invoice_master im on im.customers_id = c.id 
        left join invoice_review ir on ir.invoice_no = im.invoice_no 
        where pass_wd='".$pass_wd."' and c.whatsapp_no ='".$whatsapp_no."' order by im.dated desc ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'Login failed'],
            );   
        }
        return $result;
        
    }

    public function api_post_review(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $invoice_no = $request->invoice_no;
        $value_review = $request->value_review;
        $remarks = $request->comment;
        $notes = $request->service_selected;
        $customers_id = $request->customers_id;
        $item_list = json_decode($request->item_list, true);
        return $item_list;
        $data = DB::select(" INSERT INTO public.invoice_review
        (invoice_no, customers_id, value_review, remarks, created_at, notes)
        VALUES('".$invoice_no."', '".$customers_id."', '".$value_review."', '".$remarks."',now(), '".$notes."'); ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $invoice_no],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $invoice_no],
                ['message' => 'Login failed'],
            );   
        }
        return $result;
        
    }

    public function api_post_invoice_terapist(Request $request)
    {
        $invoice_no = $request->invoice_no;
        $data = DB::select(" select id.invoice_no,assigned_to,string_agg(id.product_name,', ') as product_name,id.assigned_to_name,case when u.photo is null then 'https://kakikupos.com/images/user-files/user.png' else 'https://kakikupos.com/images/user-files/'||u.photo end as photo  
            from invoice_detail id 
            join product_sku ps on ps.id = id.product_id and ps.type_id > 1
            join users u on u.id = id.assigned_to 
            where id.invoice_no = '".$invoice_no."' and assigned_to is not null
            group by id.invoice_no,assigned_to,id.assigned_to_name,u.photo ");

        if(count($data)>0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Gagal mendapatkan data faktur'],
            );   
        }
        return $result;
        
    }

    /**
     * Handle response after user authenticated
     * 
     * @param Request $request
     * @param Auth $user
     * 
     * @return \Illuminate\Http\Response
     */
    protected function authenticated(Request $request, $user) 
    {
        return redirect()->intended();
    }
}
