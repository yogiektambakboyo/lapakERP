<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$cost="0";
	$result ="0";
	$user=$_POST["usercode"];
	$user_mirror=$_POST["usercode_mirror"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$cost="0";
		}else{
			//Cek apakah sudah pernah beli
			$query = " select count(1) as counter from x_order_master o
					join x_order_detail d on d.orderid=o.orderid
					join x_product_sku s on s.skucode=d.skucode 
					join x_disc_detail_item i on i.disc_id='FF-ONEBUY5' and i.skucode=s.skucode
					where o.usercode=:usercode and o.iscanceled='0'  "; 
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user_mirror, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$cost = $row["counter"];
			}
			
			// 0 = Tidak ada
			// >0 = Sudah pernah beli 
			
			if(intval($cost)>0){
				//Jika sudah pernah beli
				/**$query = " select count(1) as counter from x_disc_master where disc_id='FF-ONEBUY5' and CURRENT_DATE between start_date and end_date  "; 
				$stmt = $dbh->prepare($query);		
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$cost = $row["counter"];
				}
				if(intval($cost)>0){
					$result = "2";
				}else{
					$result = "0";
				}**/
				$result = "0";
			}else{
				//Jika Apakah sudah ada di keranjang blm
				$query = " select count(1) as counter from x_orderdraft o
					join x_product_sku s on s.skucode=o.skucode 
					join x_disc_detail_item i on i.disc_id='FF-ONEBUY5' and i.skucode=s.skucode
					where o.usercode=:usercode and o.isinvoice='0'  ";  
				$stmt = $dbh->prepare($query);	
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);					
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$cost = $row["counter"];
				}
				
				if(intval($cost)>0){
					$result = "1";
				}else{
					$result = "2";
				}
				
				
				$query = " select count(1) as counter from x_disc_master where disc_id='FF-ONEBUY5'  and  CURRENT_DATE between start_date and end_date "; 
				$stmt = $dbh->prepare($query);		
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$cost = $row["counter"];
				}
				
				if(intval($cost)>0){
					//None
				}else{
					$result = "0";
				}
			}
		}
	}
	catch(PDOException $e)
	{
		$cost="0";
	}
	echo $result;
//}
?>