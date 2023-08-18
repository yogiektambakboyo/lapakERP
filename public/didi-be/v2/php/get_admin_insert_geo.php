<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$device_id=$_POST["device_id"];
$longitude=$_POST["longitude"];
$latitude=$_POST["latitude"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " INSERT INTO public.x_log_admin_geo(
	deviceid, longitude, latitude)
	VALUES (:deviceid, :longitude, :latitude); ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':deviceid', $device_id, PDO::PARAM_STR,100);
				$stmt->bindParam(':longitude', $longitude, PDO::PARAM_STR,100);
				$stmt->bindParam(':latitude', $latitude, PDO::PARAM_STR,100);
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