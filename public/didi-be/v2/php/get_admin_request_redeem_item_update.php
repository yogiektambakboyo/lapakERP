<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$id=$_POST["id"];
$poin=$_POST["poin"];
$active=$_POST["active"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_poin_redeem set active=:active,poin=:poin where id=:id  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':id', $id, PDO::PARAM_STR,50);
				$stmt->bindParam(':poin', $poin, PDO::PARAM_STR,50);
				$stmt->bindParam(':active', $active, PDO::PARAM_STR,50);
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