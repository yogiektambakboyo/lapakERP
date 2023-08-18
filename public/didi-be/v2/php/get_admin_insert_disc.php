<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$min_qty=$_POST["min_qty"];
$max_qty=$_POST["max_qty"];
$disc_id=$_POST["disc_id"];
$disc_value=$_POST["disc_value"];
$skucode=$_POST["skucode"];
$result="0";

//echo $min_qty."-".$max_qty."-".$disc_id."-".$disc_value."-".$skucode;

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " insert into x_disc_detail_item(disc_id, skucode, min_qty, max_qty, min_value, max_value, disc_value, type, ismultiply) VALUES (:disc_id, :skucode, :min_qty, :max_qty, 9999999, 9999999, :disc_value, '1', '0')   ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':min_qty', $min_qty, PDO::PARAM_STR,50);
				$stmt->bindParam(':max_qty', $max_qty, PDO::PARAM_STR,50);
				$stmt->bindParam(':disc_id', $disc_id, PDO::PARAM_STR,50);
				$stmt->bindParam(':disc_value', $disc_value, PDO::PARAM_STR,50);
				$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
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