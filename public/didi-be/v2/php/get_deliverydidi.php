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
			$query = " select cost from x_deliverycost where storecode in(
select storecode from x_store_master where owner='DIDI' and city in (select city from x_user where usercode=:usercode2)
	) and :usercode like usercode  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$cost = $row["cost"];
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