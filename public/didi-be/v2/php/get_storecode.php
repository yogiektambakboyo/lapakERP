<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//storecode=subquery.storecode,
    //price=subquery.price,
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " select subscriber_store as storecode from x_user where usercode=:usercode  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->execute();	
			
				while ($row = $stmt->fetch()) {
					$result = $row["storecode"];
				}
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
echo $result;
//}
?>