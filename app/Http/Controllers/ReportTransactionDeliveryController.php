<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class ReportTransactionDeliveryController extends Controller

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
		return view('report-transaction-delivery',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */

    public function getData()
    {
		
		$results = DB::select("select m.orderid,m.dated,cast(sum(d.total) as bigint) total,u.name,u.address,s.name as storename,s.city as store_address from x_order_master m 
		join x_order_detail d on d.orderid=m.orderid
		join x_store_master s on s.storecode=m.storecode
		join x_user u on u.usercode=m.usercode
		join x_product_sku k on k.skucode=d.skucode 
		group by m.orderid,m.dated,u.name,u.address,s.name,s.city
		order by m.dated ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataRange($start_date,$end_date)
    {
		$results = DB::select("select case when t.end_delivery::date=m.dated and cast(to_char(t.end_delivery,'HH24MISS') as int)>cast(to_char(ts.time_out,' HH24MISS') as int) then '1' else '0' end as isovertime 
		,coalesce(to_char(t.progress_date,'YYYY-MM-yy HH24:MI:SS'),'1990-01-01 00:00:00') as orderpick,coalesce(to_char(t.end_delivery,'YYYY-MM-yy  HH24:MI:SS'),'1990-01-01 00:00:00') as orderdelivered,coalesce(to_char(t.start_delivery,'YYYY-MM-yy HH24:MI:SS'),'1990-01-01 00:00:00') as orderset,coalesce(ud.name,'Not Assigned') as deliveryman,m.orderid,m.dated,cast(sum(d.total) as bigint) total,u.name,u.address,s.name as storename,s.city as store_address from x_order_master m 
		join x_order_detail d on d.orderid=m.orderid
		join x_store_master s on s.storecode=m.storecode
		join x_user u on u.usercode=m.usercode
		join x_product_sku k on k.skucode=d.skucode
		left join x_delivery_task t on t.order_id=d.orderid
		left join x_user_delivery ud on ud.id=t.delivery_id
		left join x_delivery_time_sheet ts on ts.day_name=trim(to_char(m.uploadtime,'day'))
		where m.dated between :start_date and :end_date
		group by ts.time_out,t.progress_date,t.start_delivery,t.end_delivery,ud.name,m.orderid,m.dated,u.name,u.address,s.name,s.city
		order by m.dated ", ['start_date' => $start_date,"end_date" => $end_date]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
							
	
    public function getDataTransactionDetail($orderid)
    {
		$results = DB::select("select d.orderid,d.skucode,s.shortdesc,d.pcsqty,cast(d.price as int) price,cast(d.total as bigint) total,case when v.orderid is null then '0' else '1' end as isdelivered from x_order_detail d
join x_product_sku s on s.skucode=d.skucode
left join x_order_detail_delivery v on v.orderid=d.orderid and v.skucode=s.skucode
where d.orderid=:orderid and d.price>0
order by s.shortdesc ", ["orderid" => $orderid]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	

}