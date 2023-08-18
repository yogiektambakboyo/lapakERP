<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
//use Illuminate\Support\Facades\Request;


use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class MasterPartnerController extends Controller

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
		return view('master_partner',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */
	 
	 public function getDataCity()
    {
		
		$results = DB::select("select city as storecode,city as name from x_store_master where isdidiws='0' order by city");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }


	
	public function getDataRange($tim_pe)
    {
		if($tim_pe =='QWERTY'){
			$tim_pe = '%';
		}
		$results = DB::select("select u.storecode,u.longitude,u.latitude,u.member_type,u.isneedprint,u.isposadmin,u.issuspend,u.usercode,u.name,u.address,u.city,u.phoneno,u.username,u.password,u.createdate,u.active,m.name as wholesaler 
from x_user u
join x_store_master m on m.storecode=u.storecode join x_partner p on p.handphone=u.username where u.city like :tim_pe ", ['tim_pe' => $tim_pe]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataWholesalerOne($city)
    {
		$results = DB::select("select m.storecode,m.name from x_store_master m where m.city like :city ", ['city' => $city]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function updateDataUser(Request $request)
	{
		$usercode = $request->input('usercode');
		$isposadmin = $request->input('isposadmin');
		$longitude = $request->input('longitude');
		$latitude = $request->input('latitude');
		$address = $request->input('address');
		$member_type = $request->input('member_type');
		$active = $request->input('active');
		$city = $request->input('city');
		$storecode = $request->input('storecode');

		$inserted = DB::update('insert into x_log_user select * from x_user where usercode=:usercode ',
			['usercode'=>$usercode]);
			
		$affected = DB::update('update x_user set city=:city,storecode=:storecode,subscriber_store=:subscriber_store,active=:active,member_type=:member_type,address=:address,latitude=:latitude,longitude=:longitude,isposadmin=:isposadmin where usercode=:usercode ',
		['city'=>$city,'storecode'=>$storecode,'subscriber_store'=>$storecode,'active'=>$active,'member_type'=>$member_type,'address'=>$address,'latitude'=>$latitude,'longitude'=>$longitude,'isposadmin'=>$isposadmin,'usercode'=>$usercode]);
		return $request->all();
	}
	
	
							
	

}