<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$deviceid=$_POST["deviceid"];
$orderid=$_POST["orderid"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("address"=>$address,"storecode"=>$storecode,"storename"=>$name,"lastconnect"=>$lastconnect,"status"=>$status);
		}else{
			$query = " select n.city,l.storecode,n.name,n.address,'2017-01-01 00:00' as lastconnect,n.isparent as status from x_admin_user u
						join x_admin_link l on l.adminid=u.adminid
						join x_store_master m on m.storecode=l.storecode
						join x_store_master n on n.city=m.city and n.storecode=m.storecode
						where u.deviceid=:deviceid order by n.name  ";
			$stmt = $dbh->prepare($query); 
			$stmt->bindParam(':deviceid', $deviceid, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$storecode = $row["storecode"];
					$name = $row["name"];
					$lastconnect = $row["lastconnect"];
					$address = $row["address"];
					$status = $row["status"];
					$arr[]=array("address"=>$address,"storecode"=>$storecode,"storename"=>$name,"lastconnect"=>$lastconnect,"status"=>$status);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>