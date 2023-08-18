<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$nama=$_POST["nama"];
	$provinsi=$_POST["provinsi"];
	$kota=$_POST["kota"];
	$handphone=$_POST["handphone"];
	$password=$_POST["password"];
	$alamat=$_POST["alamat"];
	$refcode=$_POST["refcode"];
	$member_type=$_POST["member_type"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select insertusercommerce_v23(:nama,:alamat,:kota,:handphone,:password,:refcode,:member_type) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':nama', $nama, PDO::PARAM_STR,50);	
			//$stmt->bindParam(':provinsi', $provinsi, PDO::PARAM_STR,50);	
			$stmt->bindParam(':kota', $kota, PDO::PARAM_STR,50);	
			$stmt->bindParam(':handphone', $handphone, PDO::PARAM_STR,50);	
			$stmt->bindParam(':password', $password, PDO::PARAM_STR,50);	
			$stmt->bindParam(':alamat', $alamat, PDO::PARAM_STR,200);	
			$stmt->bindParam(':refcode', $refcode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':member_type', $member_type, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$status = $row["status"];
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>