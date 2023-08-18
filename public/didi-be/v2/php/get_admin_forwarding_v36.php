<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,@Field("description") String description,@Field("categorycode") String categorycode,@Field("subcategorycode") String subcategorycode,@Field("brandcode") String brandcode,@Field("subbrandcode") String subbrandcode,@Field("casesize") String casesize,@Field("price") String price,@Field("storecode") String storecode
	$status="0";
	$orderid=$_POST["orderid"];
	$storecode=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			if($storecode != "0"){
				$query = " update x_order_allocate set storecode=:storecode where orderid=:orderid ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
				$stmt->execute();	
			}
			
			
			
			$query = " select forwardingorder_v36(:orderid,:storecode) as status ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$status = $row["status"];
			}	
			
			
			$query = "select distinct u.fcm_token,u.name,u.usercode from x_order_master m join x_user u on u.usercode=m.usercode where m.orderid=:orderid ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);		
			$stmt->execute();

			$name ="";
			$usercodex="0";
			while ($row = $stmt->fetch()) {
					$fcm_token = $row["fcm_token"];
					$name = $row["name"];
					$usercodex = $row["usercode"];
			}	
			
			$url = 'https://fcm.googleapis.com/fcm/send';
			$fields = array (
					'to' => $fcm_token,
					'notification' => array (
							"body" => "Hai ".$name.", Order anda dengan ID ".$orderid." sudah kami terima dan akan segera diproses lebih lanjut.",
							"title" => "DIDI",
							"icon" => "myicon"
					)
			);
			$fields = json_encode ($fields);
			$headers = array (
					'Authorization: key=' . "AAAAwg1wzJI:APA91bGZEyKf_H4uh7L9-b3BkPu9lnh-6R6cP4YmlIEeQnDbtR36VBTklS70_lZ5upLcjFuEyQ2OfEp3xe7NOeomjjT1tq3RTOK9HJsuPMyyAD6IsKzkA7px6WEMe8d7Kvpt3kM0nSKI",
					'Content-Type: application/json'
			);

			$ch = curl_init ();
			curl_setopt ( $ch, CURLOPT_URL, $url );
			curl_setopt ( $ch, CURLOPT_POST, true );
			curl_setopt ( $ch, CURLOPT_HTTPHEADER, $headers );
			curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, true );
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
			curl_setopt ( $ch, CURLOPT_POSTFIELDS, $fields );

			curl_exec ( $ch );
			curl_close ( $ch );	
			
			
			$msg = "Hai ".$name.", Order anda dengan ID ".$orderid." sudah kami terima dan akan segera diproses lebih lanjut.";
			$query = "INSERT INTO public.x_notification_log(usercode, message, created_date, response) VALUES (:usercode, :msg, now(), ''); ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':msg', $msg, PDO::PARAM_STR,100);		
			$stmt->bindParam(':usercode', $usercodex, PDO::PARAM_STR,50);		
			$stmt->execute();
			
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>