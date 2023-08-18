<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'MOBILE_SMS_SERVICE'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("message"=>$message,"target"=>$target,"id"=>$id);
		}else{
			$query = "  SELECT id,target,message FROM public.x_system_sms where issending='0' and target is not null and length(target)>9 and  length(target)<14 ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$id = $row["id"];
					$target = $row["target"];
					$message = $row["message"];
					$arr[]=array("message"=>$message,"target"=>$target,"id"=>$id);
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