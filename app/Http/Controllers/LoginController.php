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
use Illuminate\Support\Facades\Session;

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

        $user_data = DB::select("select id from users u where active=1 and u.username = '".$request->get('username')."'");
        if(count($user_data)<=0){
            Session::flush();
            Auth::logout();
            return redirect('login');
        }
        
        $user = Auth::getProvider()->retrieveByCredentials($credentials);

        Auth::login($user, $request->get('remember'));

        if($request->get('remember')):
            $this->setRememberMeExpiration($user);
        endif;

        return $this->authenticated($request, $user);
    }

    public function get_checkmembership(Request $request) 
    {
        $user_data = DB::select("select id,name,address,branch_id from customers u where u.phone_no = '".$request->get('phone_no')."' or u.id = ".$request->get('phone_no'));
        return $user_data;
    }

    public function api_login(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $token_today = $request->token;
        $val_token = md5(date("Y-m-d"));
        $user_agent = $request->server('HTTP_USER_AGENT');

        DB::select("delete  from notif_log nl where created_at <= now()-interval '2 minutes'; ");

        $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
        where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
        union all 
        select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
        where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
        ) a limit 1");

        $data_notif = DB::select("select whatsapp_no from notif_log where whatsapp_no ='".$whatsapp_no."'; ");

        $whatsapp_no_ = $whatsapp_no;

        if(substr($whatsapp_no,0,2)=="08"){
            $whatsapp_no_ = "628".substr($whatsapp_no,2,strlen($whatsapp_no));
        }

        if(count($data)>0 && count($data_notif)<=0 && $val_token==$token_today && $user_agent=="Malaikat_Ridwan"){
            $random_numb = mt_rand(1111,9999);
            $data[0]->pass_wd = strval($random_numb);

            DB::select("update customers set pass_wd=".$random_numb." where whatsapp_no='".$whatsapp_no."';");
            DB::select("update users set pass_wd=".$random_numb." where phone_no='".$whatsapp_no."';");
            //$sal = DB::select("select name from customers where whatsapp_no='".$whatsapp_no."';");
            $name = $data[0]->name;

            $curl = curl_init();
            $val_token = md5(date("Y-m-d"));
            $url_acc = "https://kakikupos.com/send-msg-wa?token=".$val_token."&no=".$whatsapp_no_."&adrotp=".$random_numb."&fromapp=kakiku"."&name=".base64_encode($name);


            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_URL, $url_acc);
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
            $result = curl_exec($curl);
            curl_close($curl);

            DB::select("insert into notif_log(whatsapp_no) values('".$whatsapp_no."'); ");

            $result = array_merge(
                ['status' => 'success'],
                ['data' => $data],
                ['message' => 'Kode 4 digit OTP terkirim ke nomor Handphone kamu via WhatsApp, silahkan cek dan masukkan disini.'],
            );    
        }else if(count($data_notif)>0){
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'Anda sudah melakukan permintaan OTP, Mohon tunggu 2 menit untuk request OTP lagi'],
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

    public function api_register_otp(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $token_today = $request->token;
        $name = $request->ident_id;
        $val_token = md5(date("Y-m-d"));
        $user_agent = $request->server('HTTP_USER_AGENT');

        DB::select("delete  from notif_log nl where created_at <= now()-interval '1 minutes'; ");

        $data_notif = DB::select("select whatsapp_no from notif_log where whatsapp_no ='".$whatsapp_no."'; ");

        $whatsapp_no_ = $whatsapp_no;

        if(substr($whatsapp_no,0,2)=="08"){
            $whatsapp_no_ = "628".substr($whatsapp_no,2,strlen($whatsapp_no));
        }

        if(count($data_notif)<=0 && $val_token==$token_today && $user_agent=="Malaikat_Ridwan"){
            $random_numb = mt_rand(1111,9999);

            $curl = curl_init();
            $val_token = md5(date("Y-m-d"));
            $url_acc = "https://kakikupos.com/send-msg-wa?token=".$val_token."&no=".$whatsapp_no_."&adrotp=".$random_numb."&fromapp=kakiku"."&name=".base64_encode($name);


            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "GET");
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_URL, $url_acc);
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
            $result = curl_exec($curl);
            curl_close($curl);

            DB::select("insert into notif_log(whatsapp_no) values('".$whatsapp_no."'); ");

            $result = array_merge(
                ['status' => 'success'],
                ['data' => strval($random_numb)],
                ['message' => 'Kode 4 digit OTP terkirim ke nomor Handphone kamu via WhatsApp, silahkan cek dan masukkan disini.'],
            );    
        }else if(count($data_notif)>0){
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => "" ],
                ['message' => 'Anda sudah melakukan permintaan OTP, Mohon tunggu 2 menit untuk request OTP lagi'],
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

        $data = DB::select(" insert into customers_point(customers_id,point) select id,0  from customers c  where c.id not in (select customers_id  from customers_point); ");

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

    public function api_register(Request $request)
    {
        $whatsapp_no = $request->handphone;
        $name = $request->name;
        $address = $request->address;
        $handphone = $request->handphone;
        $city = $request->city;
        $branch_id = $request->branch_id;
        $gender_id = $request->gender_id;
        $file_photo = $request->file_photo;
        $token_today = $request->token;
        $acc_type = $request->acc_type;
        $user_agent = $request->server('HTTP_USER_AGENT');

        //name,address,handphone,city,branch_id, gender_id, file_photo, token, acc_type

        $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
        where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
        union all 
        select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
        where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
        ) a limit 1");

        $val_token = md5(date("Y-m-d"));
        if(count($data)<=0 && $val_token==$token_today && $user_agent=="Malaikat_Ridwan"){

            if($acc_type == "Staff"){
                $gender = ($gender_id=="Pria"?'Male':'Female');
                $data = DB::select(" insert into users(name,address,username,password,phone_no,gender,city,photo,branch_id,job_id,department_id,work_year,join_years) 
                values('".$name."','".$address."',md5(to_char(now(),'YYYY-MM-DD HH24:MI:SS.MS')),md5(to_char(now(),'YYYY-MM-DD HH24:MI:SS.MS')),'".$handphone."','".$gender."','".$address."','".$file_photo."','".$branch_id."',2,2,1,1); ");

                $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
                where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
                union all 
                select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
                where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
                ) a limit 1");

                $data = DB::select("insert into users_branch(user_id,branch_id) values(".$data[0]->id.",".$branch_id.");");
                
            }else{
                $data = DB::select(" insert into customers(name,address,phone_no,whatsapp_no,branch_id,city,gender) 
                values('".$name."','".$address."','".$handphone."','".$handphone."',".$branch_id.",'".$city."','".$gender_id."'); ");
            }

            $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
            where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
            union all 
            select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
            where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
            ) a limit 1");

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
                    ['message' => 'Register failed'],
                );   
            }

            
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $data ],
                ['message' => 'Validation failed'],
            );   
        }
        
        return $result;
        
    }

    public function api_check_hp(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $token = $request->token;

        $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type from customers c 
        where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
        union all 
        select id,name,u.phone_no,pass_wd,'emp' as user_type from users u 
        where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
        ) a limit 1");

        if(count($data)<=0){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => ''],
                ['message' => 'Success'],
            );    
        }else{
            $data = array();
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => ''],
                ['message' => 'Nomor Handphone sudah terpakai akun lain'],
            );   
        }
        return $result;
        
    }

    public function api_user_info(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $token = $request->token;

        $data = DB::select("select * from (select id,name,whatsapp_no,pass_wd,'cust' as user_type,'' as photo,1 as job_id,'customer' as job_title  from customers c 
        where c.whatsapp_no is not null and whatsapp_no ='".$whatsapp_no."'
        union all 
        select id,name,u.phone_no,pass_wd,'emp' as user_type,u.photo,u.job_id,jt.remark as job_title  from users u 
        join job_title jt on jt.id = u.job_id  where u.phone_no is not null and u.phone_no = '".$whatsapp_no."'
        ) a limit 1");

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
                ['data' => $data],
                ['message' => 'Akun tidak ditemukan'],
            );   
        }
        return $result;
        
    }

    public function api_profile_emp(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;

        $data = DB::select("
            select sum(case when to_char(im.dated,'MM')=to_char(now(),'MM') then 1 else 0 end)  as count_mp,
            count(distinct case when to_char(im.dated,'MM')=to_char(now(),'MM') then im.customers_id  else 0 end)   as count_mc,
            count(id.product_id) as count_yp,count(distinct im.customers_id) as count_yc,(p.values*100/pp.price)::int as procent,u.job_id,u.name,u.phone_no,u.gender,u.work_year,jt.remark as job_name,case when u.photo is null then 'https://kakikupos.com/images/user-files/user.png' else 'https://kakikupos.com/images/user-files/'||u.photo end as photo  
            from users u 
            join job_title jt on jt.id = u.job_id 
            join product_commision_by_year p on p.product_id = 289 and p.jobs_id = u.job_id  and p.years = u.work_year and p.branch_id = u.branch_id 
            join product_price pp on pp.product_id = p.product_id and pp.branch_id = p.branch_id 
            join invoice_detail id on id.assigned_to = u.id
            join invoice_master im on im.invoice_no = id.invoice_no and to_char(im.dated,'YYYY')=to_char(now()::date,'YYYY') 
            where u.phone_no is not null and u.pass_wd='".$pass_wd."' and u.phone_no ='".$whatsapp_no."'
            group by u.job_id,u.name,u.phone_no,u.gender,u.work_year,jt.remark,u.photo,p.values,pp.price; ");

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
                ['message' => 'Gagal mendapatkan data karyawan'],
            );   
        }
        return $result;
        
    }

    public function api_photo_slide(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $data = DB::select("select id,remark,image_path,promo_name,remark,to_char(date_begin,'dd-mm-yyyy') date_begin,to_char(date_end,'dd-mm-yyyy') date_end from content_promotion cp where now()::date between date_begin and date_end order by seq; ");

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

    public function api_photo_slide_detail(Request $request)
    {
        $whatsapp_no = $request->whatsapp_no;
        $pass_wd = $request->pass_wd;
        $id = $request->id;
        $data = DB::select("select id,remark,image_path,promo_name,remark,to_char(date_begin,'dd-mm-yyyy') date_begin,to_char(date_end,'dd-mm-yyyy') date_end from content_promotion cp where now()::date between date_begin and date_end and id=".$id." order by seq; ");

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

    public function api_branch_list(Request $request)
    {
        $token_today = $request->token;
        $val_token = md5(date("Y-m-d"));
        $user_agent = $request->server('HTTP_USER_AGENT');
        $whatsapp_no = $request->whatsapp_no;
        $data = DB::select("
        select * from (
        select 0 as id,'-- Pilih Cabang --' as branch_name,'0' as branch_address,'0' as longitude,'0' as latitude from branch b 
        where b.id=1
        UNION
        select b.id,remark as branch_name,b.address as branch_address,b.longitude, b.latitude from branch b 
        where b.id>1 and b.active = 1) a order by branch_name; ");

        if(count($data)>0 && $val_token==$token_today && $user_agent=="Malaikat_Ridwan"){
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
        $item_list = $request->item_list;
        $item_list = json_decode($item_list,true);
        $data = DB::select(" INSERT INTO public.invoice_review
        (invoice_no, customers_id, value_review, remarks, created_at, notes)
        VALUES('".$invoice_no."', '".$customers_id."', '".$value_review."', '".$remarks."',now(), '".$notes."'); ");

        if(count($data)>0){

            for ($i=0; $i < count($item_list); $i++) { 
                $data = DB::select(" INSERT INTO public.invoice_review_detail
                (invoice_no, user_id, value_review, created_at)
                VALUES('".$item_list[$i]["invoice_no"]."', '".$item_list[$i]["assigned_to"]."', '".$item_list[$i]["review"]."',now()); ");
            }

            $data = DB::select(" update customers_point set updated_at=now(),point = point+(select distinct m.point  from customers c 
            join membership m on m.id = c.membership_id where c.id = ".$customers_id." ) where customers_id = ".$customers_id."; ");

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
