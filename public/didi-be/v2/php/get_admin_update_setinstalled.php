<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$imei=$_POST["imei"];
$phone=$_POST["phone"];
$dated=$_POST["dated"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " INSERT INTO public.x_combing_history(
					imei, phone, created_date, isinstalled, reason, reason_desc, notes, id)
					select imei,phone,now(),isinstalled,reason, reason_desc,notes,combingcode from x_combing where combingcode not in (select id from x_combing_history)  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = "update x_combing set isinstalled='1',reason=0,reason_desc='',updated_date=now(),updated_by=:imei2 where imei=:imei and phone=:phone and dated=:dated  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':imei', $imei, PDO::PARAM_STR,50);
			$stmt->bindParam(':imei2', $imei, PDO::PARAM_STR,50);
			$stmt->bindParam(':phone', $phone, PDO::PARAM_STR,50);
			$stmt->bindParam(':dated', $dated, PDO::PARAM_STR,50);
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