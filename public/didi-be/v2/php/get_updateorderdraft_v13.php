<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$skucode=$_POST["skucode"];
$qty=$_POST["qty"];
$sequence=$_POST["sequence"];
$price=$_POST["price"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_orderdraft set qty=:qty,price=:price,sequence=:sequence where usercode=:usercode and skucode=:skucode and isinvoice='0' ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
				$stmt->bindParam(':qty', $qty, PDO::PARAM_STR,50);
				$stmt->bindParam(':price', $price, PDO::PARAM_STR,50);
				$stmt->bindParam(':sequence', $sequence, PDO::PARAM_STR,50);
				$stmt->execute();
				
				$query = " UPDATE x_orderdraft set relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode2||:usercode2 where usercode=:usercode and isinvoice='0'  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,50);
				
				
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