<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_user set storecode=:storecode,subscriber_store=:storecode2 where usercode=:usercode  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
					$query = " INSERT INTO public.x_user_store_log(usercode, storecode, created_date) VALUES ( :usercode, :storecode, now())  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
					$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
					$stmt->execute();
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