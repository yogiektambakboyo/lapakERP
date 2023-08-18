<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$status="0";
	$usercode=$_POST["usercode"];
	$nominal=$_POST["nominal"];
	$file_attachment=$_POST["file_attachment"];
	$bank_account=$_POST["bank_account"];
	$bank_account_name=$_POST["bank_account_name"];
	
	$isvalid="0";
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " INSERT INTO public.x_deposit_order(
	usercode, nominal,file_attachment,bank_account,bank_account_name,isapproved)
	VALUES ( :usercode, :nominal,:file_attachment,:bank_account,:bank_account_name,2); ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':nominal', $nominal, PDO::PARAM_STR,50);							
			$stmt->bindParam(':file_attachment', $file_attachment, PDO::PARAM_STR,50);							
			$stmt->bindParam(':bank_account', $bank_account, PDO::PARAM_STR,50);							
			$stmt->bindParam(':bank_account_name', $bank_account_name, PDO::PARAM_STR,50);							
				if($stmt->execute()) {
						$status = "1";
						
						$query = " INSERT INTO public.x_log_deposit(usercode, nominal, description) VALUES ( :usercode, :nominal,'REQ CASH DEPOSIT'); ";
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