<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	$storecode=$_POST["storecode"];
	$usercode=$_POST["usercode"];
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"description"=>$description);
		}else{
	
			$query = " select id as code,name as description from x_supplier where isactive='1' and storecode=:storecode ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			//$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
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
		$arr[]=array("code"=>$code,"description"=>$description);
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
}
?>