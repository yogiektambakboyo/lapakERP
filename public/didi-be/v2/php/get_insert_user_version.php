<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$version=$_POST["version"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " DELETE FROM  public.x_user_version where usercode=:usercode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->execute();	
			
			$query = " INSERT INTO public.x_user_version(usercode, version,created_date) VALUES (:usercode, :version,now()) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':version', $version, PDO::PARAM_STR,50);			
			//$stmt->execute();			
			if ($stmt->execute()) {
				$status = "1";
				$query = " INSERT INTO public.x_log_user_version_history(usercode, version,created_date) VALUES (:usercode, :version,now()) ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
				$stmt->bindParam(':version', $version, PDO::PARAM_STR,50);			
				$stmt->execute();	
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