<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$store=$_POST["storecode"];
	$skucode=$_POST["skucode"];
	$price=$_POST["price"];
	$active=$_POST["active"];
	$qty=$_POST["qty"];
	$isempty=$_POST["isempty"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select updatestock(:storecode,:skucode,:price,:qty,:active,:isempty) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':price', $price, PDO::PARAM_STR,50);	
			$stmt->bindParam(':active', $active, PDO::PARAM_STR,50);	
			$stmt->bindParam(':qty', $qty, PDO::PARAM_STR,50);	
			$stmt->bindParam(':isempty', $isempty, PDO::PARAM_STR,50);	
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
//}
?>