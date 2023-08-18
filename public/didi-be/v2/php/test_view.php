<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=localhost", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"description"=>$description);
		}else{
			$query = " select skucode,description from x_product_sku ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["skucode"];
					$description = $row["description"];
					$arr[]=array("skucode"=>$code,"description"=>$description);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>