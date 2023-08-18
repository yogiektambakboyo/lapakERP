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
			//Cek apakah sudah dikeranjang
			$query = " select count(1) as counter from x_orderdraft o
					join x_product_sku s on s.skucode=o.skucode 
					join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=s.skucode
					where o.usercode=:usercode and o.isinvoice='0'  ";  
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);					
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$cost = $row["counter"];
				}
				
				if(intval($cost)>0){
					$result = "1";
					$query = " select count(1) as counter from x_disc_master 
								join x_user u on u.city='KUTA JAYA' and u.isposadmin='0' and u.usercode=:usercode
								where disc_id='FF-500x'  and  CURRENT_DATE between start_date and end_date "; 
					$stmt = $dbh->prepare($query);	
					$stmt->bindParam(':usercode', $user_mirror, PDO::PARAM_STR,50);						
					$stmt->execute();			
					while ($row = $stmt->fetch()) {
						$cost = $row["counter"];
					}
					
					if(intval($cost)>0){
						$result = "1";
					}else{
						$result = "0";
					}
				}else{
					$query = " select count(1) as counter from x_disc_master 
								join x_user u on u.city='KUTA JAYA' and u.isposadmin='0' and u.usercode=:usercode
								where disc_id='FF-500x'  and  CURRENT_DATE between start_date and end_date "; 
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':usercode', $user_mirror, PDO::PARAM_STR,50);						
					$stmt->execute();			
					while ($row = $stmt->fetch()) {
						$cost = $row["counter"];
					}
					
					if(intval($cost)>0){
						$result = "2";
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