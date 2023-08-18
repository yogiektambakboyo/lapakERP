<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("code"=>$reasoncode,"description"=>$description);
		}else{
			$query = "  select reasoncode,description from x_reason where active='1' and type='CBG' order by reasoncode ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$reasoncode = $row["reasoncode"];
					$description = $row["description"];
					$arr[]=array("code"=>$reasoncode,"description"=>$description);
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