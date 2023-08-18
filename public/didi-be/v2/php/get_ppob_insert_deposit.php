<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$status="0";
	$usercode=$_POST["usercode"];
	$nominal=$_POST["nominal"];
	
	$isvalid="0";
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " INSERT INTO public.x_deposit_order(
	usercode, nominal)
	VALUES ( :usercode, :nominal); ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':nominal', $nominal, PDO::PARAM_STR,50);							
				if($stmt->execute()) {
						$status = "1";
						
						$query = " INSERT INTO public.x_log_deposit(usercode, nominal, description) VALUES ( :usercode, :nominal,'REQ DEPOSIT'); ";
						$stmt = $dbh->prepare($query);
						$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
						$stmt->bindParam(':nominal', $nominal, PDO::PARAM_STR,50);
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