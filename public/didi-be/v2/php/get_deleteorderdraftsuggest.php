<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$result="0";
	$user=$_POST["usercode"];
	$sku=$_POST["skucode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " delete from x_orderdraft x where x.usercode=:usercode and x.skucode=:skucode  and isinvoice='0' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->bindParam(':skucode', $sku, PDO::PARAM_STR,50);	
			if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}		
			
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>