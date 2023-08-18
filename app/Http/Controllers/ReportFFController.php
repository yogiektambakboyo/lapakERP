<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class ReportFFController extends Controller

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
		return view('reportff',["menu_data"=>$data]);
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
		join x_product_sku k on k.skucode=d.skucode and k.brandcode='1408'
		group by m.orderid,m.dated,u.name,u.address,s.name,s.city
		order by m.dated ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataRange($start_date,$end_date)
    {
		$results = DB::select("select m.orderid,m.dated,cast(sum(d.total) as bigint) total,u.name,u.address,s.name as storename,s.city as store_address from x_order_master m 
		join x_order_detail d on d.orderid=m.orderid
		join x_store_master s on s.storecode=m.storecode
		join x_user u on u.usercode=m.usercode
		join x_product_sku k on k.skucode=d.skucode and k.brandcode='1408'
		where m.dated between :start_date and :end_date
		group by m.orderid,m.dated,u.name,u.address,s.name,s.city
		order by m.dated ", ['start_date' => $start_date,"end_date" => $end_date]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
							
	
	public function getDataBrandDashBoard()
    {
		$results = DB::select("select to_char(c.dated,'YYYY-MM') as period,sum(coalesce(d.total,0)) as total,count(distinct coalesce(o.orderid,'')) as order,count(distinct o.usercode) as user from
						x_calendar c 
						join x_product_brand b on b.brandcode='1408'
						join x_product_sku s on s.brandcode=b.brandcode
						join x_order_master o on o.dated=c.dated and iscanceled='0'
						join x_order_detail d on d.orderid=o.orderid and d.skucode=s.skucode
						join x_user u on u.usercode=o.usercode
						where c.dated between '2017-01-01' and now()::date
						group by to_char(c.dated,'YYYY-MM') order by to_char(c.dated,'YYYY-MM')");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataBrandDashBoardToday()
    {
		$results = DB::select("select sum(total) as total,sum(orders) as order,sum(users) as user, sum(total_7) as total_7,sum(order_7) as order_7,sum(user_7) as user_7
							,cast(sum(total)*100/sum(total_7) as int) as pro_total,cast(sum(orders)*100/sum(order_7) as int) as pro_order,cast(sum(users)*100/sum(user_7) as int) as pro_user
							from (
							select sum(coalesce(d.total,0)) as total,count(distinct coalesce(o.orderid,'')) as orders,count(distinct o.usercode) as users,0 as total_7,0 as order_7,0 as user_7 from
							x_calendar c 
							join x_product_brand b on b.brandcode='1408'
							join x_product_sku s on s.brandcode=b.brandcode
							join x_order_master o on o.dated=c.dated and iscanceled='0'
							join x_order_detail d on d.orderid=o.orderid and d.skucode=s.skucode
							join x_user u on u.usercode=o.usercode
							where c.dated=now()::date
							union																									  
							select 0 as total,0 as orders,0 as users,sum(coalesce(d.total,0)) as total_7,count(distinct coalesce(o.orderid,'')) as order_7,count(distinct o.usercode) user_7 
							from x_calendar c 
							join x_product_brand b on b.brandcode='1408'
							join x_product_sku s on s.brandcode=b.brandcode
							join x_order_master o on o.dated=c.dated and iscanceled='0'
							join x_order_detail d on d.orderid=o.orderid and d.skucode=s.skucode
							join x_user u on u.usercode=o.usercode
							where c.dated=(now() - INTERVAL '7 DAY')::date) a");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
    public function getDataFFDetail($orderid)
    {
		$results = DB::select("select d.orderid,d.skucode,s.shortdesc,d.pcsqty,cast(d.price as int) price,cast(d.total as bigint) total from x_order_detail d
					join x_product_sku s on s.skucode=d.skucode and s.brandcode='1408'
					where d.orderid=:orderid and d.price>0
					order by s.shortdesc ", ["orderid" => $orderid]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataFFDetail500x()
    {
		
		/*
		select distinct CASE WHEN u.issuspend='1' THEN 'Offline' ELSE 'Online' END as issuspend,u.name,u.usercode,case when c.usercode is null then 'B' ELSE 'K' END as status,trim(longitude) longitude,trim(latitude) latitude  from x_user u 
						left join (select max(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and s.end_date 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on  fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=55 and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode 
						) c on c.usercode=u.usercode
						where u.isposadmin='0' and u.city='KUTA JAYA'
		*/
		/*$results = DB::select("select distinct  CASE WHEN d.usercode IS NOT NULL AND c.usercode IS NOT NULL THEN 'Ya' 
					  WHEN d.usercode IS NULL AND c.usercode IS NOT NULL THEN 'Tidak' ELSE '-' END as buyfrompromo,CASE WHEN u.issuspend='1' THEN 'Offline' ELSE 'Online' END as issuspend,u.name,u.usercode,case when c.usercode is null then 'B' ELSE 'K' END as status,trim(longitude) longitude,trim(latitude) latitude  from x_user u 
						left join (select max(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and s.end_date 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on  fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=55 and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode 
						) c on c.usercode=u.usercode
						left join (
								select distinct m.usercode from 
								x_log_order_related l
								join x_orderdraft d on d.relatedid=l.relatedid and d.isfrompopup='1'
								join x_order_master m on m.orderid=l.orderid and m.iscanceled='0'
								join x_user u on u.usercode=m.usercode and u.city='KUTA JAYA' and isposadmin='0'
								where l.description like 'ORDFF500 - DISC FRISIAN FLAG 500'
						) d on d.usercode=u.usercode
						where u.isposadmin='0' and u.city='KUTA JAYA' ");**/
		$results = DB::select(" select distinct  CASE WHEN k.id IS NULL THEN 'Tidak' ELSE 'Ya' END as sellmilk,CASE WHEN d.usercode IS NOT NULL AND c.usercode IS NOT NULL THEN 'Ya' 
					  WHEN d.usercode IS NULL AND c.usercode IS NOT NULL THEN 'Tidak' ELSE '-' END as buyfrompromo,CASE WHEN u.issuspend='1' THEN 'Offline' ELSE 'Online' END as issuspend,u.name,u.usercode,case when c.usercode is null then 'B' ELSE 'K' END as status,trim(longitude) longitude,trim(latitude) latitude  
					  from x_user u 
						left join (select max(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and now() 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on  fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=55 and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode 
						) c on c.usercode=u.usercode
						left join (
								select distinct m.usercode from 
								x_log_order_related l
								join x_orderdraft d on d.relatedid=l.relatedid and d.isfrompopup='1'
								join x_order_master m on m.orderid=l.orderid and m.iscanceled='0'
								join x_user u on u.usercode=m.usercode and u.city='KUTA JAYA' and isposadmin='0'
								where l.description like 'ORDFF500 - DISC FRISIAN FLAG 500'
						) d on d.usercode=u.usercode
						left join x_user_distribution k on k.usercode=u.usercode and k.subcategorycode='029'
						where u.isposadmin='0' and u.city='KUTA JAYA' and u.usercode not in (
							'865',
							'460',
							'239',
							'447',
							'455',
							'517',
							'521',
							'866',
							'445',
							'238',
							'454',
							'518',
							'240',
							'459',
							'439'
						)
							 ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	
	public function getDataFFDetail500xLongLat()
    {
		$results = DB::select("select distinct u.name,u.usercode,case when c.usercode is null then 'B' ELSE 'K' END as status,trim(longitude) longitude,trim(latitude) latitude  from x_user u 
						left join (select max(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and now() 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on  fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=55 and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode 
						) c on c.usercode=u.usercode
						where u.isposadmin='0' and u.city='KUTA JAYA' and longitude!='0'  and longitude!=' ' and u.usercode not in (
							'865',
							'460',
							'239',
							'447',
							'455',
							'517',
							'521',
							'866',
							'445',
							'238',
							'454',
							'518',
							'240',
							'459',
							'439'
						) ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataFFDetailRepeat()
    {
		$results = DB::select("select count(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and now() 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on  fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=55 and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode having  count(orderid)>1 ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }

}