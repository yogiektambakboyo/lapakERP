<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
//use Illuminate\Support\Facades\Request;


use DataTables;

use App\User;
use Illuminate\Support\Facades\DB;
class MasterPricingController extends Controller

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
		return view('master_pricing',["menu_data"=>$data]);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */
	 
	 public function getDataWholesaler()
    {
		
		$results = DB::select("select storecode,name from x_store_master where isdidiws='0' order by name");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }


	
	public function getDataRange($tim_pe)
    {
		if($tim_pe =='QWERTY'){
			$tim_pe = '%';
		}
		$results = DB::select("select d.shortdesc,s.name,p.skucode,p.storecode,p.price,p.pricemember_1,p.pricemember_2,p.up_values from x_product_price p
		join x_store_master s on s.storecode=p.storecode and s.city not in ('DEMO','SURABAYA DUMMY','SYSTEM')
		join x_product_sku d on d.skucode=p.skucode where CAST(s.storecode as character varying) like :tim_pe ", ['tim_pe' => $tim_pe]);
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function updateDataPrice(Request $request)
	{
		$storecode = $request->input('storecode');
		$skucode = $request->input('skucode');
		$price = $request->input('price');
		$price_member1 = $request->input('price_member1');
		$price_member2 = $request->input('price_member2');
		$up_values = $request->input('up_values');

		$inserted = DB::update('INSERT INTO public.x_log_price(
								skucode, storecode, price, createdate, pricemember_1, pricemember_2, up_values)
								VALUES (:skucode, :storecode, :price, now(), :pricemember_1,:pricemember_2, :up_values) ',
			['price'=>$price,'storecode'=>$storecode,'skucode'=>$skucode,'pricemember_1'=>$price_member1,'pricemember_2'=>$price_member1,'up_values'=>$up_values]);
			
		$affected = DB::update('update x_product_price set price=:price,pricemember_1=:price_member1,pricemember_2=:price_member2,up_values=:up_values where skucode = :skucode and storecode=:storecode ',
		['price'=>$price,'storecode'=>$storecode,'skucode'=>$skucode,'price_member1'=>$price_member1,'price_member2'=>$price_member2,'up_values'=>$up_values]);
		return $request->all();
	}
	
							
	

}