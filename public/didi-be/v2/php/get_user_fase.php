<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	$user=$_POST["usercode"];
	$mustcompare="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("mustcompare"=>$mustcompare);
		}else{
			
				
			$query = "  select CASE WHEN count(1)>9999999999 THEN '1' ELSE '0' END as mustcompare from x_user u
						join x_order_master m on m.usercode=u.usercode
						join x_store_master s on s.storecode=m.storecode
						where u.usercode=:usercode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$mustcompare = $row["mustcompare"];
					//$arr[]=array("mustcompare"=>$mustcompare);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $mustcompare;
	}
	echo $mustcompare;
//}
?>