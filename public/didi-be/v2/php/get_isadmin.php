<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$isposadmin="-";
	$user=$_POST["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
		}else{
			$query = "  select isposadmin from x_user u where u.usercode=:usercode";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$isposadmin = $row["isposadmin"];
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	echo $isposadmin;
//}
?>