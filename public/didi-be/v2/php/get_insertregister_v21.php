<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$handphone=$_POST["handphone"];
	$alamat=$_POST["alamat"];
	$storecode=$_POST["storecode"];
	$latitude=$_POST["latitude"];
	$longitude=$_POST["longitude"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " update x_user set phoneno=:handphone,subscriber_store=:storecode,storecode=:storecode2,latitude=:latitude,longitude=:longitude,active='1',issuspend='0' where username=:handphone ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':handphone', $handphone, PDO::PARAM_STR,50);		
			$stmt->bindParam(':alamat', $alamat, PDO::PARAM_STR,200);		
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,200);		
			$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,200);		
			$stmt->bindParam(':latitude', $latitude, PDO::PARAM_STR,200);		
			$stmt->bindParam(':longitude', $longitude, PDO::PARAM_STR,200);		
			//$stmt->execute();			
			if ($row = $stmt->execute()) {
					$status = "1";
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