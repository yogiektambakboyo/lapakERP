<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class ReportCombingController extends Controller

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
		return view('report_combing',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getDataRange($start_date,$end_date,$tim_pe)
    {
		if($tim_pe =='QWERTY'){
			$tim_pe = '%';
		}
		$results = DB::select("select coalesce(m.usercode,'0') as  usercode,coalesce(w.name,'-') as ws,case when coalesce(o.dated,'2019-01-01'::date)>(now()::date-INTERVAL '30 DAYS') then '1' else '0' end as isactive,coalesce(orderqty,0) as isbuy,c.imei,a.remarks timpe,a.remarks||' - '||c.imei as remarks,c.combingcode,coalesce(c.notes,'')||' - '||c.phone as phone,c.visit_start,c.visit_end,c.dated,c.isinstalled,r.description||' - '||c.reason_desc as reason,c.longitude,c.latitude,c.georeverse 
					from x_combing c
					join x_reason r on r.reasoncode=c.reason
					join x_admin_user a on a.deviceid=c.imei
					left join x_user m on m.username=c.phone
					left join x_store_master w on w.storecode=m.storecode
					left join x_order_user_summary o on o.usercode=m.usercode
					where c.notes!='Dummy' and c.dated between :start_date and :end_date and c.imei like :tim_pe
					"
					, ['start_date' => $start_date,"end_date" => $end_date,'tim_pe' => $tim_pe]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
							
	

}