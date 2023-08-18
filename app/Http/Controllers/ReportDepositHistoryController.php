<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class ReportDepositHistoryController extends Controller

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
		return view('report_deposit_history',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getData()
    {
		$results = DB::select(" select o.id,u.name,o.usercode,o.nominal,file_attachment,bank_account_name,transfer_date,
		case 
		when o.isapproved=3 then 'Validasi Admin'
		when o.isapproved=1 then 'Disetujui'
		when o.isapproved=2 then 'Ditolak'
		when o.isapproved=0 then 'Diajukan User'
		end as status
		from x_deposit_order o
join x_user u on u.usercode=o.usercode ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
}
