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
			case when x.upvalue<=0 then p.price else (p.price+((p.price*x.upvalue)/100)) end as price 
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
			$query = " select s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
			case when x.upvalue<=0 then p.price else (p.price+((p.price*x.upvalue)/100)) end as price 
			from x_product_sku s
			join x_user u on u.username=:usercode
			join x_store_master x on x.storecode=u.subscriber_store
			join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode
			join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0
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