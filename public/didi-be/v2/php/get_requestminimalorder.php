<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$cost="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$cost="0";
		}else{
			$query = " select y.minimumorder 
			from x_user u 
			join x_store_master x on x.city=u.city and x.isdidiws='1'
			join x_store_master y on y.storecode=x.relatedws
			where where u.username=:usercode    ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$cost = $row["minimumorder"];
				}	
		}
	}
	catch(PDOException $e)
	{
		$cost="0";
	}
	echo $cost;
//}
?>