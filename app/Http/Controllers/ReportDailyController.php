<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;

class ReportDailyController extends Controller
{
    public function index()
    {
		$results = DB::select("  select m.id,m.name as title,m.parent,m.link_url as url,m.sequence,m.icon as icon,count(n.id) as countparent from users u 
		join user_permission p on p.user_id=u.id and p.active='1'
		join user_roles_permission r on r.user_roles_id=p.user_roles_id and r.active='1'
		join menu m on m.id=r.menu_id and m.active='1'
		left join menu n on n.parent=m.id and n.active='1'
		where u.id=:user_id group by m.id,m.name,m.parent,m.link_url,m.sequence,m.icon order by sequence  ", ["user_id" => \Auth::user()->id]);
		$data = $results;
		return view('report_daily',["menu_data"=>$data]);
    }
	
	public function getDataDaily($start_date,$end_date)
    {
		$results = DB::select(" select distinct COALESCE(totalqtydidi,0) totalqtydidi,COALESCE(isdelivered,0) as isdelivered,to_char(c.dated,'YYYYMM') as periode,coalesce(a.totalqty,0) as totalqty,coalesce(a.total,0) as total,coalesce(a.b2b,0) as b2b,
coalesce(b2brevenue,0) as b2brevenue,
coalesce(a.activeuser,0) as activeuser,coalesce(a.activews,0) as activews,coalesce(b.ppob_qtytr,0) ppob_qtytr,coalesce(b.ppob_qtyuser,0) ppob_qtyuser,coalesce(b.ppob_total,0) ppob_total,coalesce(b.ppob_revenue,0) ppob_revenue,coalesce(g.ppob_deposit,0) ppob_deposit
					from x_calendar c 
					left join (
						select count(distinct totalqtydidi) as totalqtydidi,count(distinct isdelivered) isdelivered,periode,sum(total) as total, sum(b2b) as b2b,sum(b2brevenue) as b2brevenue,count(distinct usercode) as activeuser,count(distinct storecode) as activews,count(distinct orderid) as totalqty from (
							select case when s.isdidiws='1' then m.orderid else '0' end as totalqtydidi,case when s.isdidiws='1' and m.isdelivered='1' then m.orderid else '0' end as isdelivered,to_char(dated,'YYYYMM') as periode,m.orderid,d.skucode,
							d.total,coalesce(r.total,0) as ftotal,
							case when s.isdidiws='1' then d.total else 0 end as b2b,
							case when d.total>r.total and d.total<>r.total then d.total-r.total else 0 end as b2brevenue,
							m.usercode,m.storecode from x_order_master m 
							join x_order_detail d on d.orderid=m.orderid
							join x_store_master s on s.storecode=m.storecode and s.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY')
							join x_store_master s2 on s2.storecode=s.relatedws 
							left join x_log_order_forwarded fd on fd.orderid=m.orderid and fd.orderid=d.orderid
							left join x_order_detail r on r.orderid=fd.orderid_forwarded and r.skucode=d.skucode
							left join x_product_price q on q.storecode=s2.storecode and q.skucode=d.skucode
							where iscanceled='0'
						) s group by periode
					) a on a.periode=to_char(c.dated,'YYYYMM')
					left join (
						select periode as periode_ppob,count(distinct orderid) as ppob_qtytr,count(distinct usercode) as ppob_qtyuser,sum(harga) as ppob_total,sum(profit) as ppob_revenue from ( 
						select to_char(m.created_date,'YYYYMM') as periode,m.orderid,m.harga,m.harga_beli,m.harga-m.harga_beli as profit,m.usercode from x_order_ppob m
						join x_user u on m.usercode=u.usercode and u.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY') 
						where m.status='1' and m.note like '%Sukses%'
						) b group by periode
					) b on b.periode_ppob=to_char(c.dated,'YYYYMM')
					left join (
						select to_char(m.created_date,'YYYYMM') as periode,count(distinct m.usercode) as ppob_deposit from x_deposit_order m
						join x_user u on m.usercode=u.usercode and u.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY') 
						where m.isapproved='1' group by to_char(m.created_date,'YYYYMM')
					) g on g.periode=to_char(c.dated,'YYYYMM')
					where to_char(c.dated,'YYYYMM') between :start_date and :end_date order by to_char(c.dated,'YYYYMM') asc
					
					 ", ['start_date' => $start_date,"end_date" => $end_date]);
		$data = $results;
		return DataTables::collection($results)->toJson();	
    }
	
	/**
	
	public function getDataDaily($start_date,$end_date)
    {
		$results = DB::select(" select distinct COALESCE(totalqtydidi,0) totalqtydidi,COALESCE(isdelivered,0) as isdelivered,to_char(c.dated,'YYYYMM') as periode,coalesce(a.totalqty,0) as totalqty,coalesce(a.total,0) as total,coalesce(a.b2b,0) as b2b,
coalesce(b2brevenue,0) as b2brevenue,
coalesce(a.activeuser,0) as activeuser,coalesce(a.activews,0) as activews
					from x_calendar c 
					left join (
						select count(distinct totalqtydidi) as totalqtydidi,count(distinct isdelivered) isdelivered,periode,sum(total) as total, sum(b2b) as b2b,sum(b2brevenue) as b2brevenue,count(distinct usercode) as activeuser,count(distinct storecode) as activews,count(distinct orderid) as totalqty from (
							select case when s.isdidiws='1' then m.orderid else '0' end as totalqtydidi,case when s.isdidiws='1' and m.isdelivered='1' then m.orderid else '0' end as isdelivered,to_char(dated,'YYYYMM') as periode,m.orderid,d.skucode,
							d.total,coalesce(r.total,0) as ftotal,
							case when s.isdidiws='1' then d.total else 0 end as b2b,
							case when d.total>r.total and d.total<>r.total then d.total-r.total else 0 end as b2brevenue,
							m.usercode,m.storecode from x_order_master m 
							join x_order_detail d on d.orderid=m.orderid
							join x_store_master s on s.storecode=m.storecode and s.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY')
							join x_store_master s2 on s2.storecode=s.relatedws 
							left join x_log_order_forwarded fd on fd.orderid=m.orderid and fd.orderid=d.orderid
							left join x_order_detail r on r.orderid=fd.orderid_forwarded and r.skucode=d.skucode
							left join x_product_price q on q.storecode=s2.storecode and q.skucode=d.skucode
							where iscanceled='0'
						) s group by periode
					) a on a.periode=to_char(c.dated,'YYYYMM')
					where to_char(c.dated,'YYYYMM') between :start_date and :end_date order by to_char(c.dated,'YYYYMM') asc ", ['start_date' => $start_date,"end_date" => $end_date]);
		$data = $results;
		return DataTables::collection($results)->toJson();	
    }
	
	public function getDataDaily($start_date,$end_date)
    {
		$results = DB::select(" select distinct COALESCE(totalqtydidi,0) totalqtydidi,COALESCE(isdelivered,0) as isdelivered,to_char(c.dated,'YYYYMM') as periode,coalesce(a.totalqty,0) as totalqty,coalesce(a.total,0) as total,coalesce(a.b2b,0) as b2b,
coalesce(b2brevenue,0) as b2brevenue,
coalesce(a.activeuser,0) as activeuser,coalesce(a.activews,0) as activews
					from x_calendar c 
					left join (
						select count(distinct totalqtydidi) as totalqtydidi,count(distinct isdelivered) isdelivered,periode,sum(total) as total, sum(b2b) as b2b,sum(b2brevenue) as b2brevenue,count(distinct usercode) as activeuser,count(distinct storecode) as activews,count(distinct orderid) as totalqty from (
							select case when s.isdidiws='1' then m.orderid else '0' end as totalqtydidi,case when s.isdidiws='1' and m.isdelivered='1' then m.orderid else '0' end as isdelivered,to_char(dated,'YYYYMM') as periode,m.orderid,d.skucode,d.total,
							case when s.isdidiws='1' then d.total else 0 end as b2b,
							case when s.isdidiws='1' and coalesce(q.up_values,0)>0.0 then ((d.price*d.pcsqty)/((coalesce(q.up_values,0))+1))/100 else 0 end as b2brevenue,
							m.usercode,m.storecode from x_order_master m 
							join x_order_detail d on d.orderid=m.orderid
							join x_store_master s on s.storecode=m.storecode and s.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA')
							join x_store_master s2 on s2.storecode=s.relatedws --and s2.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA')
							left join x_product_price q on q.storecode=s2.storecode and q.skucode=d.skucode
							where iscanceled='0'
						) s group by periode
					) a on a.periode=to_char(c.dated,'YYYYMM')
					where to_char(c.dated,'YYYYMM') between :start_date and :end_date order by to_char(c.dated,'YYYYMM') asc ", ['start_date' => $start_date,"end_date" => $end_date]);
		$data = $results;
		return DataTables::collection($results)->toJson();	
    }
	
	
	public function getDataDaily($start_date,$end_date)
    {
		$results = DB::select(" select distinct COALESCE(totalqtydidi,0) totalqtydidi,COALESCE(isdelivered,0) as isdelivered,to_char(c.dated,'YYYYMM') as periode,coalesce(a.totalqty,0) as totalqty,coalesce(a.total,0) as total,coalesce(a.b2b,0) as b2b,coalesce(b2brevenue,0) as b2brevenue,coalesce(a.activeuser,0) as activeuser,coalesce(a.activews,0) as activews
					from x_calendar c 
					left join (
						select count(distinct totalqtydidi) as totalqtydidi,count(distinct isdelivered) isdelivered,periode,sum(total) as total, sum(b2b) as b2b,sum(b2b)*0.015 as b2brevenue,count(distinct usercode) as activeuser,count(distinct storecode) as activews,count(distinct orderid) as totalqty from (
							select case when s.isdidiws='1' then m.orderid else '0' end as totalqtydidi,case when s.isdidiws='1' and m.isdelivered='1' then m.orderid else '0' end as isdelivered,to_char(dated,'YYYYMM') as periode,m.orderid,d.skucode,d.total,case when s.isdidiws='1' then d.total else 0 end as b2b,m.usercode,m.storecode from x_order_master m 
							join x_order_detail d on d.orderid=m.orderid
							join x_store_master s on s.storecode=m.storecode and s.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA')
							where iscanceled='0'
						) s group by periode
					) a on a.periode=to_char(c.dated,'YYYYMM')
					where to_char(c.dated,'YYYYMM') between :start_date and :end_date order by to_char(c.dated,'YYYYMM') asc ", ['start_date' => $start_date,"end_date" => $end_date]);
		$data = $results;
		return DataTables::collection($results)->toJson();	
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
    }**/
}
