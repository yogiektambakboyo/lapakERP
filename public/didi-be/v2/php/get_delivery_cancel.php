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
			
			$query = "select case when count(orderid)>=1 then '1' else '0' end as device from x_order_master where orderid=:orderid and isprint='1' ";
			$stmtcek = $dbh->prepare($query);			
			$stmtcek->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
			$resultcek=$stmtcek->execute();

			if (!$resultcek) {
				$status="4";
				echo $status;
				exit;
			}else{
				
				
				while ($row = $stmtcek->fetch()) 
				{
					$status = $row["device"]; 
				}

				if ($status=="0") 
				{
					
					$query = " update x_order_master set iscanceled='1' where orderid=:orderid and isprint='0'  ";
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
					
				}else{
					$status = "3";
				}
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