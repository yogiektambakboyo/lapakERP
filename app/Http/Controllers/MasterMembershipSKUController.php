<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class MasterMembershipSKUController extends Controller

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
		return view('master_membershipsku',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getData()
    {
		$results = DB::select(" SELECT p.description,m.skucode,s.shortdesc,m.qty,m.active 
								FROM x_partner_membership_sku m
								join x_product_sku s on s.skucode=m.skucode
								join x_master_partner_membership p on p.id=m.membership_id ");
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


}
