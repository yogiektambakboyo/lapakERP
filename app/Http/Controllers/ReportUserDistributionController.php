<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;

class ReportUserDistributionController extends Controller

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
		return view('report_user_distribution',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getDataRange($region)
    {
		if($region =='QWERTY'){
			$region = '%';
		}
		$results = DB::select(" select coalesce(s.name,'-') as ws,case when coalesce(o.dated,'2019-01-01'::date)>(now()::date-INTERVAL '30 DAYS') then '1' else '0' end as isactive,'0' as isdrawradius,m.city,coalesce(m.address,'-') as address,coalesce(orderqty,0) as isbuy,m.name as name,m.longitude,m.latitude
								from x_user m
								left join x_store_master s on s.storecode=m.storecode
								left join x_order_user_summary o on o.usercode=m.usercode 
								where m.city like :region and m.city not in ('.','SYSTEM','DEMO','SURABAYA DUMMY','LAMONGAN') and length(m.name)>1
								union
								select '-' as ws,'0' as isactive,c.isdrawradius,c.city,coalesce(c.address,'-') as address,-1 as isbuy,c.name as name,c.longitude,c.latitude 
								from x_store_master c 
								where c.city like :region2 and c.city not in ('.','SYSTEM','DEMO','SURABAYA DUMMY','LAMONGAN','DUMMY') AND lower(OWNER)!='didi' "
					, ['region' => $region,'region2' => $region]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
							
	

}
