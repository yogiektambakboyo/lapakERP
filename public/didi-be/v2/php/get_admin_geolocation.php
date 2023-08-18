<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$orderid=$_POST["orderid"];
$usercode="0";$address="0";$latitude="0";$longitude="0";$handphone="0";$name="-";
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("usercode"=>$usercode,"address"=>$address,"latitude"=>$latitude,"longitude"=>$longitude,"handphone"=>$handphone,"name"=>$name);
		}else{
			$query = " select u.usercode,u.address,COALESCE(u.latitude,'0') latitude,COALESCE(u.longitude,'0') longitude,u.phoneno,u.name from x_user u
join x_order_master m on m.orderid=:orderid and m.usercode=u.usercode limit 1 ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$usercode = $row["usercode"];
					$address = $row["address"];
					$latitude = $row["latitude"];
					$longitude = $row["longitude"];
					$handphone = $row["handphone"];
					$name = $row["name"];
					$arr=array("usercode"=>$usercode,"address"=>$address,"latitude"=>$latitude,"longitude"=>$longitude,"handphone"=>$handphone,"name"=>$name);
				}	
		}
	}
	catch(PDOException $e)
	{
		$arr=array("usercode"=>$usercode,"address"=>$address,"latitude"=>$latitude,"longitude"=>$longitude,"handphone"=>$handphone,"name"=>"Error "+$e->getMessage());
		echo $arr;
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>