<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$imei=$_POST["imei"];
$phone=$_POST["phone"];
$visit_start=$_POST["visit_start"];
$visit_end=$_POST["visit_end"];
$isinstalled=$_POST["isinstalled"];
$reason=$_POST["reason"];
$reason_desc=$_POST["reason_desc"];
$longitude=$_POST["longitude"];
$latitude=$_POST["latitude"];
$georeverse=$_POST["georeverse"];
$notes=$_POST["notes"];
$result="0";

//echo $min_qty."-".$max_qty."-".$disc_id."-".$disc_value."-".$skucode;

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " INSERT INTO public.x_combing(
						 imei, phone, visit_start, visit_end, dated, created_date, isinstalled, reason, reason_desc, longitude, latitude, georeverse,notes)
						VALUES (:imei, :phone, :visit_start, :visit_end, now()::date, now(), :isinstalled, :reason, :reason_desc, :longitude, :latitude, :georeverse,:notes) ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':imei', $imei, PDO::PARAM_STR,100);
				$stmt->bindParam(':phone', $phone, PDO::PARAM_STR,100);
				$stmt->bindParam(':visit_start', $visit_start, PDO::PARAM_STR,100);
				$stmt->bindParam(':visit_end', $visit_end, PDO::PARAM_STR,100);
				$stmt->bindParam(':isinstalled', $isinstalled, PDO::PARAM_STR,100);
				$stmt->bindParam(':reason', $reason, PDO::PARAM_STR,100);
				$stmt->bindParam(':reason_desc', $reason_desc, PDO::PARAM_STR,200);
				$stmt->bindParam(':longitude', $longitude, PDO::PARAM_STR,100);
				$stmt->bindParam(':latitude', $latitude, PDO::PARAM_STR,100);
				$stmt->bindParam(':georeverse', $georeverse, PDO::PARAM_STR,500);
				$stmt->bindParam(':notes', $notes, PDO::PARAM_STR,500);
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