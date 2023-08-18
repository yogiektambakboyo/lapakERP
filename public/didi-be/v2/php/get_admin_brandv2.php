<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$subcategorycode=$_GET["subcategorycode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"description"=>$description);
		}else{
			$query = " select brandcode as code,brandname as description from x_product_brand where subcategorycode like :subcategorycode order by brandname ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':subcategorycode', $subcategorycode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["code"];
					$description = $row["description"];
					$arr[]=array("code"=>$code,"description"=>$description);
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