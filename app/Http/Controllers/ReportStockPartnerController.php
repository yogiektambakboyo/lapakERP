<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class ReportStockPartnerController extends Controller

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
		return view('report_stock_partner',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getData()
    {
		$results = DB::select(" select s.storecode,s.name,s.city,k.skucode,k.shortdesc,c.qty,e.price,h.price as price_hpp,h.stock_values,h.stock_qty from x_partner p
join x_store_master s on s.phoneno=p.handphone
join x_product_distribution d on d.storecode=s.storecode and d.active='1'
join x_product_sku k on k.skucode=d.skucode
join x_product_stock c on c.skucode=k.skucode and c.storecode=d.storecode
join x_product_price e on e.storecode=d.storecode and e.skucode=k.skucode
left join (
	select storecode,skucode,price,stock_values,stock_qty from (select row_number() over(PARTITION BY storecode,skucode order by created_date desc) as uniquecode
	,storecode,skucode,price,stock_values,stock_qty
	from x_product_hpp
	group by storecode,skucode,created_date
	) b where uniquecode=1
) h on h.storecode=s.storecode and h.skucode=k.skucode and h.skucode=d.skucode
where p.status=1 ");
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
