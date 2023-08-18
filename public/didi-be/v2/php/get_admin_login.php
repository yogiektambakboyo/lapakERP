<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$deviceid=$_POST["deviceid"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			
			$query = "select case when count(deviceid)>=1 then '1' else '0' end as device from x_admin_user where deviceid=:deviceid and active='1' ";
			$stmtcek = $dbh->prepare($query);			
			$stmtcek->bindParam(':deviceid', $deviceid, PDO::PARAM_STR,50);
			$resultcek=$stmtcek->execute();

			if (!$resultcek) {
				$status="0";
				echo $status;
				exit;
			}else{
				
				while ($row = $stmtcek->fetch()) 
				{
					$status = $row["device"]; 
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