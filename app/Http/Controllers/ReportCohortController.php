<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class ReportCohortController extends Controller

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
		return view('report_cohort',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getDataRange()
    {		
		$results = DB::select("DELETE FROM z_cohort_items");
		$results = DB::select("DELETE FROM z_user_activities");
		$results = DB::select("DELETE FROM z_cohort_size");
		$results = DB::select("DELETE FROM z_retention_table");
		
		$results = DB::select("INSERT INTO z_cohort_items  select
    date_trunc('month', U.createdate)::date as cohort_month,
    usercode
  from x_user u where city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY') order by 1, 2");
  
  
		$results = DB::select("INSERT INTO z_user_activities
					select
					A.usercode,
					EXTRACT(year FROM age(A.dated,C.cohort_month))*12 + EXTRACT(month FROM age(A.dated,C.cohort_month))
					as month_number
				  from public.x_order_master A
				  left join z_cohort_items C ON A.usercode = C.usercode where A.iscanceled='0' 
				  group by 1, 2");
		//$results = DB::select("INSERT INTO z_cohort_size select cohort_month, count(1) as num_users from z_cohort_items group by 1 order by 1");
		$results = DB::select("INSERT INTO z_cohort_size select z.periodec::date, count(c.usercode) as num_users from (select distinct to_char(dated,'YYYYMM')||'01' as periodec from x_calendar where to_char(dated,'YYYYMM') between '201708' and to_char(now()::date,'YYYYMM')) z left join z_cohort_items c on c.cohort_month=z.periodec::date group by 1 order by 1");
  
		$results = DB::select("INSERT INTO z_retention_table 
  SELECT periodec::date,list,coalesce(num_users,0) num_users FROM (  
SELECT s.periodec,list FROM
(select distinct to_char(dated,'YYYYMM')||'01' as periodec from x_calendar where to_char(dated,'YYYYMM') between '201708' and to_char(now()::date,'YYYYMM')) s
CROSS JOIN
(select EXTRACT(year FROM age(periodec::date,datedbegin::date))*12 + EXTRACT(month FROM age(periodec::date,datedbegin::date)) as list from 																						   
(select distinct to_char(dated,'YYYYMM')||'01' as periodec,'20170801' as datedbegin from x_calendar where to_char(dated,'YYYYMM') between '201708' and to_char(now()::date,'YYYYMM')) w ) d ) c
left join (
	select
    C.cohort_month,
    A.month_number,
    count(1) as num_users
  from z_user_activities A
  left join z_cohort_items C ON A.usercode = C.usercode
  group by 1, 2 order by 1,2
) s on s.cohort_month=periodec::date and s.month_number=list ");
  /**
  $results = DB::select("INSERT INTO z_retention_table 
  select
    C.cohort_month,
    A.month_number,
    count(1) as num_users
  from z_user_activities A
  left join z_cohort_items C ON A.usercode = C.usercode
  group by 1, 2");
  **/
		$results = DB::select("select to_char(cohort_month,'YYYYMM') as periode,case when month_number=0 then total_users else num_users end as num_users,total_users,month_number,percentage from (select
  B.cohort_month,
  S.num_users as total_users,
  B.month_number,
  B.num_users,																					  
  '0' as percentage
from z_retention_table B
left join z_cohort_size S ON B.cohort_month = S.cohort_month
where B.cohort_month IS NOT NULL order by 1, 3) a");
					
		/**$results = DB::select("select coalesce(w.name,'-') as ws,case when coalesce(o.dated,'2019-01-01'::date)>(now()::date-INTERVAL '30 DAYS') then '1' else '0' end as isactive,coalesce(orderqty,0) as isbuy,c.imei,a.remarks timpe,a.remarks||' - '||c.imei as remarks,c.combingcode,coalesce(c.notes,'')||' - '||c.phone as phone,c.visit_start,c.visit_end,c.dated,c.isinstalled,r.description||' - '||c.reason_desc as reason,c.longitude,c.latitude,c.georeverse 
					from x_combing c
					join x_reason r on r.reasoncode=c.reason
					join x_admin_user a on a.deviceid=c.imei
					left join x_user m on m.username=c.phone
					left join x_store_master w on w.storecode=m.storecode
					left join x_order_user_summary o on o.usercode=m.usercode
					where c.notes!='Dummy' and c.dated between :start_date and :end_date and c.imei like :tim_pe"
					, ['start_date' => $start_date,"end_date" => $end_date,'tim_pe' => $tim_pe]);**/
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataPeriode($start,$end)
    {
		$results = DB::select("select distinct to_char(dated,'YYYYMM') as periode from x_calendar where to_char(dated,'YYYYMM') between :start and :end "
					, ['start' => $start,"end" => $end]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function getDataPeriodeUser($start,$end)
    {
		$results = DB::select("select a.periode,qtysignup,coalesce(b.userorder,0) as userorder,sum(qtysignup) OVER (PARTITION BY ID ORDER BY a.periode ) as total from (
	select 1::integer as ID,to_char(c.dated,'YYYYMM') as periode,count(distinct usercode) as qtysignup
from x_calendar c
left join x_user u on to_char(u.createdate,'YYYYMM')=to_char(c.dated,'YYYYMM') AND u.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY')
group by to_char(c.dated,'YYYYMM')
order by to_char(c.dated,'YYYYMM')
	) a 
left join
(select to_char(dated,'YYYYMM') as periode,count(distinct m.usercode) as userorder from x_order_master m join x_user u on u.usercode=m.usercode and u.city not in ('DEMO','DUMMY','LAMONGAN','SYSTEM','X-AREA','SURABAYA DUMMY') where m.iscanceled='0' group by to_char(m.dated,'YYYYMM')) b
on b.periode=a.periode where a.periode between :start and :end "
					, ['start' => $start,"end" => $end]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
							
	

}