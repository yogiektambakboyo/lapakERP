<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$device_id=$_POST["device_id"];
$longitude=$_POST["longitude"];
$latitude=$_POST["latitude"];
$time_check=$_POST["time_check"];
$note=$_POST["note"];
$attend_type=$_POST["attend_type"];
$result="0";

//echo $min_qty."-".$max_qty."-".$disc_id."-".$disc_value."-".$skucode;

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " INSERT INTO public.x_admin_attending(
	device_id, longitude, latitude, time_check, note, attend_type)
	VALUES (:device_id, :longitude, :latitude, :time_check, :note, :attend_type); ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':device_id', $device_id, PDO::PARAM_STR,100);
				$stmt->bindParam(':longitude', $longitude, PDO::PARAM_STR,100);
				$stmt->bindParam(':latitude', $latitude, PDO::PARAM_STR,100);
				$stmt->bindParam(':time_check', $time_check, PDO::PARAM_STR,100);
				$stmt->bindParam(':note', $note, PDO::PARAM_STR,250);
				$stmt->bindParam(':attend_type', $attend_type, PDO::PARAM_STR,100);
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