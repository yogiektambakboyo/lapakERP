<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$orderid=$_POST["orderid"];
	$user=$_POST["usercode"];
	$reason=$_POST["reason"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			
			$query = " update x_order_master set iscanceled='1' where orderid=:orderid ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);				
						
			if ($stmt->execute()) {
					$status = "1";
					$query = " INSERT INTO x_log_cancel_order(usercode, orderid, reason, createdate) VALUES (:usercode, :orderid, :reason, now()::timestamp);  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
					$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
					$stmt->bindParam(':reason', $reason, PDO::PARAM_STR,50);	
					$stmt->execute();
				}	
					
			
			
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>