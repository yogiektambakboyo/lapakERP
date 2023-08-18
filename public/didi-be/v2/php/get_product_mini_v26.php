<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
$usercode=$_GET["usercode"];
//if($method == 'SFA_Borwita_Android'){
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"searchkey"=>$searchkey,"price"=>$price);
		}else{
			$query = " delete from x_product_distribution where storecode=1 ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " delete from x_product_price where storecode=1 ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Collect Data',t.ticket from x_log_user_ticket t
						join x_user u on u.username=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();
			
			
			$query = " update x_product_stock set qty=999999 where qty=0 and storecode in (select storecode from x_store_master where isstockcheck='0')  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " update x_orderdraft set usercode=usercode*(-1),storecode=storecode*(-1) where isinvoice='0' and createdate<now()-INTERVAL '3 days'  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			
			$query = " select exec_fase(:usercode) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$status = $row["status"];
			}
			
			$query = "select count(1) as c from x_user u
			join x_store_master m on m.storecode=u.subscriber_store
			where u.username=:usercode and m.isdidiws='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
			}
		
		if(intval($c)>0){
			$query = " select s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
			case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
			from x_product_sku s
			join x_user u on u.username=:usercode
			join x_store_master x on x.city=u.city and x.isdidiws='1'
			join x_store_master y on y.storecode=x.relatedws
			join x_product_distribution d on d.skucode=s.skucode and d.storecode=y.storecode
			join x_product_price p on p.storecode=y.storecode and p.skucode=d.skucode and p.price>0
			where d.active='1'    ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$searchkey = $row["searchkey"];
					$price = $row["price"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"searchkey"=>$searchkey,"price"=>$price);
			}	
		}else{
			$query = " select * from (
select s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
			CASE WHEN u.member_type=1 THEN coalesce(p.pricemember_1,0)
			WHEN u.member_type=2 THEN coalesce(p.pricemember_2,0)
			ELSE CAST((COALESCE(p.price,0)) as numeric(14,0)) END as price
			from x_product_sku s
			join x_user u on u.username=:usercode
			join x_store_master x on x.storecode=u.subscriber_store
			join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode
			join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0
			where d.active='1' 
) a where price>0   ";
						$stmt = $dbh->prepare($query);
						$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
						$stmt->execute();			
						while ($row = $stmt->fetch()) {
								$kode = $row["kode"];
								$nama = $row["nama"];
								$barcode = $row["barcode"];
								$searchkey = $row["searchkey"];
								$price = $row["price"];
								$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"searchkey"=>$searchkey,"price"=>$price);
						}	
		}
				
				
			
		}
	}
	catch(PDOException $e)
	{
		//echo $e->getMessage();
		$arr[]=array("kode"=>"yyyy","nama"=>"Koneksi Terputus","barcode"=>$barcode,"searchkey"=>$searchkey,"price"=>$price);
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>