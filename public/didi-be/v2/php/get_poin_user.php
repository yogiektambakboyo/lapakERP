<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$user=$_POST["usercode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$poin="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
		   echo $poin;
		}else{
			$query = "select poin from x_poin where usercode=:usercode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$poin = $row["poin"];
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	echo $poin;
//}
?>