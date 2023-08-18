<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class TransactionPartnerController extends Controller

{

	/**

     * Displays front end view

     *

     * @return \Illuminate\View\View

     */

    public function index()

    {
		$results = DB::select("  select m.id,m.name as title,m.parent,m.link_url as url,m.sequence,m.icon as icon,count(n.id) as countparent from users u 
		join user_permission p on p.user_id=u.id and p.active='1'
		join user_roles_permission r on r.user_roles_id=p.user_roles_id and r.active='1'
		join menu m on m.id=r.menu_id and m.active='1'
		left join menu n on n.parent=m.id and n.active='1'
		where u.id=:user_id group by m.id,m.name,m.parent,m.link_url,m.sequence,m.icon order by sequence  ", ["user_id" => \Auth::user()->id]);
		$data = $results;
		return view('transaction-partner',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getData()
    {
		$results = DB::select(" select id, name, address, handphone, email, idcard, file_idcard, file_place, file_nameperson, operationaltime, province, city, longitude, latitude, placelength, placewidth, placeheight, living_status, note, created_date, gender, birthdate, status from x_partner where status=0");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataRange($start_date,$end_date)
    {
		$results = DB::select("select m.orderid,to_char(m.created_date,'YYYY-MM-DD') as dated,harga total,u.name,m.note address,k.product_name as storename,u.city as store_address 
		from x_order_ppob m 
		join x_user u on u.usercode=m.usercode
		join x_ppob_product k on k.code=m.code
		where to_char(m.created_date,'YYYY-MM-DD') between :start_date and :end_date
		order by m.created_date ", ['start_date' => $start_date,"end_date" => $end_date]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function rejectPartner(Request $request)
	{
		$id = $request->input('id');		
		$reason = $request->input('reason');		
		$inserted = DB::update("INSERT INTO public.x_log_partner_order(partner_id, reason, status) VALUES (:id, :reason,'2');",
			['id'=>$id,'reason'=>$reason]);
		$inserted = DB::update("UPDATE x_partner set status=2 where id=:id;",
			['id'=>$id]);
			
		return $request->all();
	}
	
	public function approvePartner(Request $request)
	{
		$id = $request->input('id');		
		$membership = $request->input('membership');		
		$membership_period = $request->input('membership_period');		
		$noted = $request->input('noted');		
		$reason = 'Approve';		
		$inserted = DB::update("INSERT INTO public.x_log_partner_order(partner_id, reason, status) VALUES (:id, :reason,'1');",
			['id'=>$id,'reason'=>$reason]);
			
		$inserted = DB::update("UPDATE x_partner set status=1,membership=:membership,noted=:noted where id=:id; ",
			['id'=>$id,'membership'=>$membership,'noted'=>$noted]);
			
		$random_str = rand(10,99);
			
		$inserted = DB::update("INSERT INTO public.x_store_master
								select 
								f.storecode+1, p.name, p.address, p.city||'-'||p.handphone as city, p.handphone, p.email, '-' as fax, p.longitude, p.latitude, '-' as postalcode, now() as createdate, idcard as netizenid,file_nameperson as  photo,p.name as owner,'1' as  isparent, isdidiws, f.storecode+1, upvalue, minimumorder, storegroup, isdrawradius, '0' as isneeddelivered, '1' as isstockcheck
								from x_store_master x
								join (select max(storecode) storecode from x_store_master) f on 1=1
								join x_partner p on p.id=:id
								where x.storecode=35 and p.handphone not in (select phoneno from x_store_master); ",['id'=>$id]);
		
		$inserted = DB::update("INSERT INTO public.x_user(
								usercode, name, address, city, phoneno, email, fax, longitude, latitude, postalcode, storecode, createdate, netizenid, username, password, active, subscriber_store, member_type, isneedprint, fcm_token, isposadmin, reference_code, issuspend,password_encryt
								)
								select 
								f.usercode+1, p.name, p.address, p.city||'-'||p.handphone as city, p.handphone, p.email, '-' as fax, p.longitude, p.latitude, '-' as postalcode,g.storecode, now() as createdate, idcard as netizenid,p.handphone,to_char(birthdate,'YYYYMMDD')||:rand,'1',g.storecode,'0','1','-','1','0','0',encrypt(CAST((to_char(birthdate,'YYYYMMDD')||:rand2) as character varying)::bytea,CAST('xXDIDI123Xx' as bytea),CAST('aes' as text))::character varying
								from x_user x
								join (select max(usercode) usercode from x_user) f on 1=1
								join x_partner p on p.id=:id
								join x_store_master g on g.phoneno=p.handphone
								where x.usercode=236 and p.handphone not in (select username from x_user); ",['id'=>$id,'rand'=>$random_str,'rand2'=>$random_str]);
								
		$inserted = DB::update(" insert into x_product_distribution(storecode,skucode,sequence,emptystock)
								select s.storecode,m.skucode,0 as sequence,'0'::bit as emptystock from x_store_master s
								join x_partner p on p.handphone=s.phoneno and p.id=:id
								join x_partner_membership_sku m on m.membership_id=p.membership 
								union 
								select s.storecode,m.skucode,0 as sequence,'0'::bit as emptystock from x_product_partner_store m
								join x_store_master s on s.storecode=m.storecode
								join x_partner p on p.handphone=s.phoneno and p.id=:ids ",['id'=>$id,'ids'=>$id]);
								
		$inserted = DB::update(" insert into x_product_stock(storecode,skucode,qty,entrytime)
								select s.storecode,m.skucode,0,now() as entrytime from x_store_master s
								join x_partner p on p.handphone=s.phoneno and p.id=:id
								join x_partner_membership_sku m on m.membership_id=p.membership
								union 
								select s.storecode,m.skucode,0 as active,now() as entrytime from x_product_partner_store m
								join x_store_master s on s.storecode=m.storecode
								join x_partner p on p.handphone=s.phoneno and p.id=:ids ",['id'=>$id,'ids'=>$id]);
								
		$inserted = DB::update(" insert into x_product_price
								select m.skucode,s.storecode,c.price+((price*up_values)/100) as price,0 as priceoff,0 as discount,now()::date as startdate,(now()::date+ interval '10 years')::date as enddate,now() as createdate,0 pricemember_1,0 pricemember_2,0 up_values,0 up_values_system,9999 as priority_values 
								from x_store_master s
								join x_partner p on p.handphone=s.phoneno and p.id=:id
								join x_partner_membership_sku m on m.membership_id=p.membership
								join x_store_master_setting t on t.id=1
								join x_store_master m2 on m2.storecode=t.storecode
								join x_store_master m3 on m3.storecode=m2.relatedws
								join x_product_price c on c.storecode=m3.storecode and c.skucode=m.skucode
								union 
								select m.skucode,s.storecode,c.price+((price*up_values)/100) as price,0 as priceoff,0 as discount,now()::date as startdate,(now()::date+ interval '10 years')::date as enddate,now() as createdate,0 pricemember_1,0 pricemember_2,0 up_values,0 up_values_system,9999 as priority_values 
								from x_store_master s
								join x_partner p on p.handphone=s.phoneno and p.id=:ids
								join x_product_partner_store m on m.storecode=s.storecode
								join x_store_master_setting t on t.id=1
								join x_store_master m2 on m2.storecode=t.storecode
								join x_store_master m3 on m3.storecode=m2.relatedws
								join x_product_price c on c.storecode=m3.storecode and c.skucode=m.skucode ",['id'=>$id,'ids'=>$id]);
								
		$inserted = DB::update(" insert into x_partner_contract(partner_id,begin_date,end_date)
									select id, now()::date, (now()::date + interval '".$membership_period." months')::date
									from x_partner p where p.id=:id ",['id'=>$id]);
									
		$inserted = DB::update(" SELECT public.insertorderpartner_v1(:id, 'BRG MINTA DIKIRIM - PARTNER') ",['id'=>$id]);
		
		$inserted = DB::update(" update x_user set password_encryt=encrypt(CAST((password) as character varying)::bytea,CAST('xXDIDI123Xx' as bytea),CAST('aes' as text))::character varying
where password_encryt is null; ");

		$inserted = DB::update(" INSERT INTO public.x_system_sms(target, message) 
								select p.handphone,'Hai '||x.name||', Pengajuan Partner DIDI sudah disetujui.Berikut akses untuk login anda username = '||p.handphone||' password = '||x.password
								from x_partner p 
								join x_user x on x.username=p.handphone
								where p.id=:id ",['id'=>$id]);
		
		
			
		return $request->all();
	}
}
