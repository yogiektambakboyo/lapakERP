<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$categorycode=$_GET["categorycode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"description"=>$description);
		}else{
			$query = " select subcategorycode as code,subcategoryname as description from x_product_subcategory where categorycode=:categorycode order by subcategoryname  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':categorycode', $categorycode, PDO::PARAM_STR,50);
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