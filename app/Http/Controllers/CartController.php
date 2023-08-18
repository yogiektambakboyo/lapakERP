<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Response; 

class CartController extends Controller
{
    public function index($username){
		//$no_handphone = $request->input('no_handphone');
		
		$results = DB::select("  select * from (select row_number() over(PARTITION BY skucode order by skucode,priority_values,price asc) as uniquecode,* from (
				select u.usercode,u.name,p.priority_values,s.skucode||'.jpg' as img,o.qty,'0' as disc_value,u.city,x.storecode,s.skucode,s.description as skuname,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
				case when (p.up_values+p.up_values_system)<=0 then p.price::int else (p.price+((p.price*(p.up_values+p.up_values_system))/100))::int end as price 
				from x_product_sku s
				join x_orderdraft o on o.skucode=o.skucode and isinvoice='0'
				join x_user u on u.usercode=o.usercode and u.username=:username
				join x_store_master x on x.city=u.city and x.isdidiws='0'
				join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode and d.skucode=o.skucode
				join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0  and p.skucode=o.skucode
				join x_product_stock c on c.skucode=p.skucode and c.storecode=x.storecode and c.qty>0
				where d.active='1'																		
			) g) d where uniquecode=1 ",["username"=>$username]);

			$resultuser = DB::select("  select * from 
				x_user u where u.username=:username limit 1",["username"=>$username]);
		//$data = $results;
		return view('cart_spa',["success"=>true,"data"=>$results,"username"=>$username,"data_user"=>$resultuser]);
	}

	public function searchProduct(Request $request){
		$usercode = $request->input("userCode");
		$keyword = $request->input("keyWord");
		$results = DB::select("   select usercode,name,'https://didi-bucket.s3-ap-southeast-1.amazonaws.com/image_product/'||skucode||'.jpg' as pic,storecode,skucode,printdesc,barcode,price::int price from (select row_number() over(PARTITION BY skucode order by skucode,priority_values,price asc) as uniquecode,* from (
			select u.usercode,u.name,p.priority_values,x.storecode,s.skucode,s.printdesc,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
			case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
			from x_product_sku s
			join x_user u on u.usercode=:usercode
			join x_store_master x on x.city=u.city and x.isdidiws='0'
			join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode
			join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0
			join x_product_stock c on c.skucode=p.skucode and c.storecode=x.storecode and c.qty>0
			where d.active='1'																		
		) g) d where uniquecode=1 and (searchkey like '%". strtolower($keyword) ."%' or printdesc like '%". strtolower($keyword) ."%') ",["usercode"=>$usercode]);

		return $results;
	}

	public function insertOrderDraft(Request $request)
	{
		$usercode = $request->input('userCode');
		$skucode = $request->input('skuCode');
		$price = $request->input('price');
		
		$deleted = DB::delete("delete from x_orderdraft where isinvoice='0' and skucode=:skucode and usercode=:usercode ",['usercode'=>$usercode,'skucode'=>$skucode]);

		$inserted = DB::insert("INSERT INTO x_orderdraft(usercode, storecode, skucode, qty, price, sequence, createdate,isinvoice,isfrombarcode) 
		select usercode,storecode, :skucode, '1', :price, '999', now(),'0','0' 
		from x_user 
		where usercode=:usercode",
			['usercode'=>$usercode,'skucode'=>$skucode,'price'=>$price]);
		return ["success"=>$inserted,"data"=>$request->all()];
	}

	public function deleteOrderDraft(Request $request)
	{
		$usercode = $request->input('userCode');
		$skucode = $request->input('skuCode');
		
		$deleted = DB::delete("delete from x_orderdraft where isinvoice='0' and skucode=:skucode and usercode=:usercode ",['usercode'=>$usercode,'skucode'=>$skucode]);
		return ["success"=>$deleted,"data"=>$request->all()];
	}

	public function updateOrderDraft(Request $request)
	{
		$usercode = $request->input('userCode');
		$skucode = $request->input('skuCode');
		$qty = $request->input('qty');
		
		$updated = DB::update("update x_orderdraft set qty=:qty where isinvoice='0' and skucode=:skucode and usercode=:usercode ",['qty'=>$qty,'usercode'=>$usercode,'skucode'=>$skucode]);
		return ["success"=>$updated,"data"=>$request->all()];
	}

	public function submitOrderDraft(Request $request)
	{
		$usercode = $request->input('userCode');

		$results = DB::select("select u.name,u.username,s.printdesc as printitem,o.qty as pcsqty,cast(o.qty*price as int) pcsprice from x_orderdraft o join x_user u on u.usercode=o.usercode join x_product_sku s on s.skucode=o.skucode where isinvoice='0' and o.usercode=:usercode ",['usercode'=>$usercode]);

		$itemall = "";
		$contactenc = "";
		$count = 0;
		$names = "";
		$totalitem = 0;
		foreach($results as $key => $row){
			$itemall = $itemall ." \n ". $row->pcsqty ." Pcs ". $row->printitem ."  Rp. ". number_format($row->pcsprice ,0, ',', '.');
			$count++;
			$names = $row->name;
			$contactenc=$row->username;
			$totalitem = $totalitem + (((int) $row->pcsqty) * ((int) $row->pcsprice));
		}


		if (substr($contactenc,0,2)=="08"){
			$contactenc = substr_replace($contactenc,"628",0,2);
		}

		if($count>0){
				$milliseconds = round(microtime(true) * 1000);

				$uri = 'https://www.waboxapp.com/api/send/chat';
				$data = [   
					'token' => '4697998db9995323485d2efcf886956d5c435007d866d', //Access Token
					'uid' => '6281239935890', // Nomor Admin
					'to' => $contactenc, // Nomor Penerima
					'custom_uid' => mt_rand(100000,999999), // Selalu berubah tiap pesannya
					'text' => "Hai ".$names.", Barang yang ada dikeranjang kamu \n ".$itemall." \n ----------------------------------- +\n Total  Rp. ".number_format($totalitem ,0, ',', '.')."\n\n Silahkan ketik KONFIRMASI untuk menyetujui pesanan, atau untuk mengubah barang lain klik link https://diditeknologi.com/cart-spa/".$contactenc." , untuk menghapus pesanan ketik RESET"
				];

				$ch = curl_init();  //inisialisasi curl library
				curl_setopt($ch, CURLOPT_URL, $uri);  //mengatur opsi curl
				curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
				curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
				curl_setopt($ch, CURLOPT_POST, 1);
				curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
				curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
				curl_setopt($ch, CURLOPT_MAXREDIRS, 5);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($ch, CURLOPT_TIMEOUT, 20);
				curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 25);
				$response = json_decode(curl_exec($ch)); // execute curl

				$info = curl_getinfo($ch);
				curl_close ($ch);
		}

		return ["success"=>$response,"data"=>$request->all()];
	}

}
