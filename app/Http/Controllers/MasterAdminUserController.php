<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
//use Illuminate\Support\Facades\Request;


use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class MasterAdminUserController extends Controller

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
		return view('master_admin_user',["menu_data"=>$data]);
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


	
	public function getDataRange()
    {
		$results = DB::select("select deviceid,remarks,active,adminid from x_admin_user order by remarks ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataRangeAccess($adminid)
    {
		$results = DB::select("select l.adminid,u.remarks,s.storecode,s.name,'1' active from x_admin_link l
join x_admin_user u on u.adminid=l.adminid
join x_store_master s on s.storecode=l.storecode 
where l.adminid=:adminid
union 
select u.adminid,u.remarks,s.storecode,s.name,'0' active from x_admin_user u  
join x_store_master s on s.storecode not in (select storecode from x_admin_link where adminid=:adminid)
where u.adminid=:adminid ",['adminid'=>$adminid]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function updateDataUser(Request $request)
	{
		$adminid = $request->input('adminid');
		$storecode = $request->input('storecode');
		$active = $request->input('active');
		
		if($active=="1"||$active==1){
			$inserted = DB::update('delete from x_admin_link where adminid=:adminid and storecode=:storecode ',
			['adminid'=>$adminid,'storecode'=>$storecode]);
		}else{
			$inserted = DB::update('insert into x_admin_link(adminid,storecode) values(:adminid,:storecode) ',
			['adminid'=>$adminid,'storecode'=>$storecode]);
		}
		return $request->all();
	}
	
	public function addDataUser(Request $request)
	{
		$deviceid = $request->input('deviceid');
		$name = $request->input('name');
		
		$inserted = DB::update("INSERT INTO public.x_admin_user(deviceid, remarks, lastlogin) VALUES (:deviceid, :name, now()); ",
			['deviceid'=>$deviceid,'name'=>$name]);
		return $request->all();
	}	
							
}