<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
$target=$_POST["target"];
$message=$_POST["message"];
$status = "0";
if($method == 'DIDI_ADMIN_APPS'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
		   $status = "Koneksi Database Terputus";
			echo $status;
		}else{
			$query = "  INSERT INTO public.x_system_sms(target, message) VALUES (:target, :message); ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':target', $target, PDO::PARAM_STR,50);	
			$stmt->bindParam(':message', $message, PDO::PARAM_STR,50);	
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