<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
$id=$_POST["id"];
$status = "0";
if($method == 'MOBILE_SMS_SERVICE'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
		   $status = "Koneksi Database Terputus";
			echo $status;
		}else{
			$query = "  UPDATE x_system_sms set issending='1' where id=:id ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':id', $id, PDO::PARAM_STR,50);	
			if($stmt->execute()){
				$status = "1";
			}		
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	echo $status;
}
?>