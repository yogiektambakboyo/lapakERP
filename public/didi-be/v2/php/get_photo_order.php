<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="-";
	$skucode=$_GET["skucode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("photo"=>$photo);
		}else{
			$query = " select photo from x_product_photo where active='1' and skucode=:skucode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$photo = $row["photo"];
					$arr[]=array("photo"=>$photo);
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