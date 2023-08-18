<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("address"=>$address,"storecode"=>$storecode,"name"=>$name,"city"=>$city,"longitude"=>$longitude,"latitude"=>$latitude,"rank"=>$rank);
		}else{
			$query = " select storecode,name,city,longitude,latitude,1 as rank,address from x_store_master where city=(select city from x_user where usercode=:usercode) and isdidiws='0' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$storecode = $row["storecode"];
					$name = $row["name"];
					$city = $row["city"];
					$longitude = $row["longitude"];
					$latitude = $row["latitude"];
					$rank = $row["rank"];
					$address = $row["address"];
					$arr[]=array("address"=>$address,"storecode"=>$storecode,"name"=>$name,"city"=>$city,"longitude"=>$longitude,"latitude"=>$latitude,"rank"=>$rank);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
}
?>