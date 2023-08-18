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
			$query = " select CASE WHEN m.isdidiws='1' THEN '1' ELSE '0' END as storecode 
						from x_user u
						join x_store_master m on m.storecode=u.subscriber_store
						where u.usercode=:usercode  ";
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