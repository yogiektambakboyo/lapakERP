<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_orderdraft set storecode=(select d.storecode from x_user u 
join x_store_master s on s.city=u.city and isdidiws='1' 
join x_store_master d on s.relatedws=d.storecode
where u.usercode=:usercode limit 1) where usercode=:usercode2 and isinvoice='0'  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
			//$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			if($stmt->execute())
			
		
			{
				$query = " UPDATE x_user set storecode=(select d.storecode from x_user u 
join x_store_master s on s.city=u.city and isdidiws='1' 
join x_store_master d on s.relatedws=d.storecode
where u.usercode=:usercode limit 1) where usercode=:usercode2  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();
				
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