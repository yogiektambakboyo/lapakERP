<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
$target=$_POST["target"];
$counter = "0";
if($method == 'DIDI_ADMIN_APPS'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
		   $counter="Gagal Konek DB";
		}else{
			$query = "  select username from x_user where username=:target union select handphone as username from x_partner where handphone=:target2 ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':target', $target, PDO::PARAM_STR,50);
			$stmt->bindParam(':target2', $target, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$username = $row["username"];
					$arr[]=array("username"=>$username);
					$counter="1";
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	echo $counter;
}
?>