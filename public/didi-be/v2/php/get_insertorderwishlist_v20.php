<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$remarks=$_POST["remarks"];
$result="0";
$c="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			
			$query = " INSERT INTO public.x_order_wishlist
select usercode, storecode, skucode, qty, price, sequence, createdate, isinvoice, id, relatedid, isfrombarcode, :remarks
from x_orderdraft where usercode=:usercode and isinvoice='0' ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				//$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':remarks', $remarks, PDO::PARAM_STR,250);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
			
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>