<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$poin=$_POST["poin"];
$skucode=$_POST["skucode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " INSERT INTO public.x_poin_redeem(
	skucode, poin, active, storecode, created_date, updated_date, created_by, updated_by)
	VALUES ( :skucode, :poin, '1','%', now(), now(), 1, 1)  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':poin', $poin, PDO::PARAM_STR,50);
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