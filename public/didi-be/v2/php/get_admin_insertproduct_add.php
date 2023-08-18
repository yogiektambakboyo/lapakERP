<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,@Field("description") String description,@Field("categorycode") String categorycode,@Field("subcategorycode") String subcategorycode,@Field("brandcode") String brandcode,@Field("subbrandcode") String subbrandcode,@Field("casesize") String casesize,@Field("price") String price,@Field("storecode") String storecode
	$status="0";
	$skucode=$_POST["skucode"];
	$description=$_POST["description"];
	$categorycode=$_POST["categorycode"];
	$subcategorycode=$_POST["subcategorycode"];
	$brandcode=$_POST["brandcode"];
	$subbrandcode=$_POST["subbrandcode"];
	$casesize=$_POST["casesize"];
	$price=$_POST["price"];
	$storecode=$_POST["storecode"];
	$printdesc=$_POST["printdesc"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select insertproduct_add(:storecode,:skucode,:description,:categorycode,:subcategorycode,:brandcode,:subbrandcode,:casesize,:price,:printdesc) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':description', $description, PDO::PARAM_STR,50);	
			$stmt->bindParam(':categorycode', $categorycode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':subcategorycode', $subcategorycode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':brandcode', $brandcode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':subbrandcode', $subbrandcode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':casesize', $casesize, PDO::PARAM_STR,50);	
			$stmt->bindParam(':price', $price, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':printdesc', $printdesc, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$status = $row["status"];
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>