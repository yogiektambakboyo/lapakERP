<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$user_mirror=$_POST["usercode_mirror"];
	$store=$_POST["storecode"];
	$picktime=$_POST["picktime"];
	$remarks=$_POST["remarks"];
	$disc=$_POST["disc"];
	$paymentid=$_POST["paymentid"];
	$nominal_pay=$_POST["nominal_pay"];
	$nominal_payed=$_POST["nominal_payed"];
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select insertorder_purchase(:storecode,:usercode,:picktime,:remarks,:user_mirror,:disc,:nominal_pay,:nominal_payed,:paymentid) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':picktime', $picktime, PDO::PARAM_STR,50);	
			$stmt->bindParam(':remarks', $remarks, PDO::PARAM_STR,50);	
			$stmt->bindParam(':user_mirror', $user_mirror, PDO::PARAM_STR,50);	
			$stmt->bindParam(':disc', $disc, PDO::PARAM_STR,50);	
			$stmt->bindParam(':nominal_pay', $nominal_pay, PDO::PARAM_STR,50);	
			$stmt->bindParam(':nominal_payed', $nominal_payed, PDO::PARAM_STR,50);	
			$stmt->bindParam(':paymentid', $paymentid, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$status = $row["status"];
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
}
?>