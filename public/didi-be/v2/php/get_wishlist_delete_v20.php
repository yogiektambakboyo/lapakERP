<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$orderid=$_POST["orderid"];
$result="0";
$c="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			
			$query = " DELETE FROM x_order_wishlist where usercode=:usercode and remarks=:remarks ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':remarks', $orderid, PDO::PARAM_STR,250);
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