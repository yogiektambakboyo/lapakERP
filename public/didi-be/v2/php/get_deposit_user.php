<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$code="-";$product_name="-";$price="-";$name="-";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("nominal"=>$nominal);
		}else{
			$query = " select nominal from x_deposit where usercode=:usercode and nominal::text=convert_from(decrypt(key_chain::bytea,'xXDIDI123Xx','aes'),'SQL_ASCII') ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$nominal = $row["nominal"];
					$arr[]=array("nominal"=>$nominal);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
		$resultcabang = $arr;
		echo json_encode($resultcabang);
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>