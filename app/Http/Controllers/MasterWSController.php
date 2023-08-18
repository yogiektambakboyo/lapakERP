<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
//use Illuminate\Support\Facades\Request;


use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class MasterWSController extends Controller

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
		return view('master_wholesaler',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */
	 
	public function getDataWholesaler()
    {
		
		$results = DB::select("select storecode,name,address,city,phoneno,longitude,latitude,createdate,owner,isparent,isdidiws,storegroup,isstockcheck,isneeddelivered from x_store_master");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }


	
	public function getDataRange($tim_pe)
    {
		if($tim_pe =='QWERTY'){
			$tim_pe = '%';
		}
		$results = DB::select("select storecode,name,address,city,phoneno,longitude,latitude,createdate,owner,isparent,isdidiws,storegroup,isstockcheck,isneeddelivered from x_store_master where city like :tim_pe ", ['tim_pe' => $tim_pe]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function updateDataWS(Request $request)
	{
		$storecode = $request->input('storecode');
		$isdidiws = $request->input('isdidiws');
		$isneeddelivered = $request->input('isneeddelivered');
		$owner = $request->input('owner');
		$longitude = $request->input('longitude');
		$latitude = $request->input('latitude');
		$address = $request->input('address');
		$storegroup = $request->input('storegroup');

		$inserted = DB::update('insert into x_log_store_master select * from x_store_master where storecode=:storecode ',
			['storecode'=>$storecode]);
			
		$affected = DB::update('update x_store_master set isdidiws=:isdidiws,isneeddelivered=:isneeddelivered,address=:address,latitude=:latitude,longitude=:longitude,isposadmin=:isposadmin where storecode=:storecode ',
		['storegroup'=>$storegroup,'isdidiws'=>$isdidiws,'isneeddelivered'=>$isneeddelivered,'owner'=>$owner,'latitude'=>$latitude,'longitude'=>$longitude,'address'=>$address,'storecode'=>$storecode]);
		return $request->all();
	}
	
	public function addDataWS(Request $request)
	{
		$name = $request->input('name');
		$isdidiws = $request->input('isdidiws');
		$isneeddelivered = $request->input('isneeddelivered');
		$owner = $request->input('owner');
		$longitude = $request->input('longitude');
		$latitude = $request->input('latitude');
		$address = $request->input('address');
		$city = $request->input('city');
		$storegroup = $request->input('storegroup');
		$phoneno = $request->input('phoneno');
			
		$affected = DB::update('insert into x_store_master(storecode,isdidiws,storegroup,isneeddelivered,owner,latitude,longitude,address,name,city,phoneno) select max(storecode)+1 as storecode,:isdidiws,:storegroup,:isneeddelivered,:owner,:latitude,:longitude,:address,:name,:city,:phoneno from x_store_master   ',
		['phoneno'=>$phoneno,'city'=>$city,'storegroup'=>$storegroup,'isdidiws'=>$isdidiws,'isneeddelivered'=>$isneeddelivered,'owner'=>$owner,'latitude'=>$latitude,'longitude'=>$longitude,'address'=>$address,'name'=>$name]);
		
		$inserted = DB::update('update x_store_master set relatedws=storecode where name=:name and city=:city ',
			['city'=>$city,'name'=>$name]);
			
			$inserted = DB::update('insert into x_log_store_master select * from x_store_master where name=:name and city=:city ',
			['city'=>$city,'name'=>$name]);
		return $request->all();
	}
	
							
	

}